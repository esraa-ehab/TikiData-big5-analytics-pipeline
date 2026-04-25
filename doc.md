# EPL Analytics - Function Documentation

This document explains what each function in the project does.
It is written as a practical reference for future maintenance.

## Project Overview

The project collects football data from FBref and builds CSV tables.
Main outputs are stored in the `Scrapped_data` directory (configured by `OUTPUT_DIR`).

Main data flows:
- Standings scraping via Selenium.
- Player wages scraping via Selenium.
- Match stats scraping via `soccerdata`.
- Dimension table generation for leagues, teams, and formations.

---

## scraper/config.py

This module does not define functions. It stores shared constants used by other modules.

### Key Constants

- `LEAGUE_IDS`, `LEAGUE_NAMES_DW`, `COUNTRIES`
	- Parallel lists used to build the league dimension table.
- `LEAGUES`
	- Mapping of league display name to `(fbref_competition_id, slug)`.
	- Used by Selenium scrapers to build FBref URLs.
- `SOCCERDATA_LEAGUES`
	- League names in the format expected by `soccerdata`.
- `SEASONS`
	- List of seasons to scrape (`2016` through `2025`).
- `OUTPUT_DIR`
	- Folder where CSV files are saved.

---

## scraper/driver.py

### `create_driver(version_main: int | None = None) -> uc.Chrome`

Purpose:
- Creates and returns a configured `undetected_chromedriver` Chrome instance.

How it works:
- Builds `ChromeOptions`.
- Adds `--start-maximized`.
- Optionally pins Chrome major version when `version_main` is provided.

Parameters:
- `version_main`:
	- Optional Chrome major version (for compatibility issues).

Returns:
- A ready-to-use Selenium driver (`uc.Chrome`).

Used by:
- `scrape_standings.py`.
- `scrape_players.py`.

---

## scraper/scrape_standings.py

### `scrap_standing(driver, url: str, league: str, season: int) -> pd.DataFrame`

Purpose:
- Scrapes one standings table from a single FBref page.

How it works:
- Opens the given URL in Selenium.
- Waits for the first element with class `stats_table`.
- Reads table header and body rows.
- Converts the table into a DataFrame.
- Adds two columns: `Season` and `League`.

Parameters:
- `driver`: Active Selenium driver.
- `url`: FBref standings URL for one league-season.
- `league`: League name label to append.
- `season`: Season year label to append.

Returns:
- DataFrame containing standings rows for that page.

Notes:
- Assumes FBref table structure remains compatible.

### `scrape_all_standings() -> pd.DataFrame`

Purpose:
- Scrapes standings for all configured leagues and seasons.

How it works:
- Creates one browser driver.
- Loops through every `(league, season)` pair from config.
- Builds the FBref standings URL.
- Calls `scrap_standing(...)` and stores each result.
- Quits driver in a `finally` block.
- Concatenates all DataFrames into one output DataFrame.

Parameters:
- None.

Returns:
- Single DataFrame with all leagues and seasons combined.

Side effects:
- Prints progress messages.
- Uses network and browser resources.

---

## scraper/scrape_players.py

### `scrap_players(driver, url: str, season: int) -> pd.DataFrame`

Purpose:
- Scrapes one player wages table from FBref.

How it works:
- Opens the URL in Selenium.
- Waits for table with id `player_wages`.
- Reads header and table body rows.
- Skips rows with no `<td>` cells.
- Builds a DataFrame and appends `Season` column.

Parameters:
- `driver`: Active Selenium driver.
- `url`: FBref wages URL for one league-season.
- `season`: Season label to append.

Returns:
- DataFrame of player wage rows for one page.

### `scrape_all_players() -> pd.DataFrame`

Purpose:
- Scrapes player wages for all configured leagues and seasons.

How it works:
- Creates Selenium driver with `version_main=147`.
- Loops through every `(league, season)` pair.
- Builds wages URL per pair.
- Calls `scrap_players(...)`.
- Closes driver in `finally`.
- Concatenates results to one DataFrame.

Parameters:
- None.

Returns:
- Combined DataFrame for all leagues and seasons.

Side effects:
- Prints progress messages.
- Uses network and browser resources.

---

## scraper/scrape_matches.py

### `fetch_data(league: str, season: int) -> pd.DataFrame | None`

Purpose:
- Fetches team match stats for one league-season using `soccerdata`.

How it works:
- Creates a `sd.FBref` instance for one league and season.
- Calls `read_team_match_stats()`.
- Adds two columns: `league`, `season`.
- Returns DataFrame on success.
- On failure, prints an error and returns `None`.

Parameters:
- `league`: League key from `SOCCERDATA_LEAGUES`.
- `season`: Season year.

Returns:
- DataFrame on success, otherwise `None`.

### `scrape_all_matches(max_workers: int = 10) -> pd.DataFrame`

Purpose:
- Collects match stats for all leagues and seasons in parallel.

How it works:
- Builds full task list from leagues x seasons.
- Uses `ThreadPoolExecutor` with `max_workers` threads.
- Submits `fetch_data(...)` for each task.
- Tracks progress via `tqdm`.
- Keeps successful results (non-`None`).
- Concatenates all results into one DataFrame.

Parameters:
- `max_workers`: Number of parallel workers (default `10`).

Returns:
- Combined DataFrame containing all fetched match stats.

Side effects:
- Prints errors per failed task.
- Performs many parallel network calls.

---

## scraper/create_dimentions.py

Note:
- File name is `create_dimentions.py`.
- Some code may import `create_dimensions` (spelling difference), so keep naming consistent when editing imports.

### `create_leagues() -> pd.DataFrame`

Purpose:
- Builds a static league dimension table across all seasons.

How it works:
- Reverses season order from latest to earliest.
- Repeats league id/name/country lists per season.
- Generates `Season_year` values.
- Creates DataFrame with columns:
	- `League_id`
	- `League_name`
	- `Country`
	- `Season_year`
- Sorts by `League_name`, `Season_year`.

Parameters:
- None.

Returns:
- DataFrame representing league metadata by season.

### `create_teams(standings_path: str | None = None) -> pd.DataFrame`

Purpose:
- Builds teams dimension from standings CSV.

How it works:
- Uses provided path or default `Scrapped_data/standings_data.csv`.
- Reads CSV into DataFrame.
- Selects `Squad` and `League` columns.
- Removes duplicates.

Parameters:
- `standings_path`: Optional custom CSV path.

Returns:
- DataFrame with unique team-league combinations.

### `create_formations(matches_path: str | None = None) -> pd.DataFrame`

Purpose:
- Builds formations dimension from matches CSV.

How it works:
- Uses provided path or default `Scrapped_data/matches_table.csv`.
- Reads CSV.
- Extracts unique values from `Opp Formation`.
- Removes null values.
- Returns a one-column DataFrame named `formations`.

Parameters:
- `matches_path`: Optional custom CSV path.

Returns:
- DataFrame of unique non-null formations.

---

## scraper/main.py

### `run(targets: list[str]) -> None`

Purpose:
- Executes one or more pipelines (scrapers/builders) selected by name.

How it works:
- For each target in `targets`:
	- Looks up `(function, output_csv_path)` in `SCRAPERS` dictionary.
	- Runs the function.
	- Saves returned DataFrame to CSV.
	- Prints completion summary with row count.

Parameters:
- `targets`: List of keys from `SCRAPERS`.

Returns:
- `None`.

Side effects:
- Writes CSV files.
- Prints progress and save messages.

Related runtime behavior in `__main__`:
- If no CLI args: runs all pipelines.
- If args provided: runs only selected keys.
- Validates keys and exits with code `1` on invalid names.

---

## Quick Reference (Function List)

- `create_driver(version_main=None)`
- `scrap_standing(driver, url, league, season)`
- `scrape_all_standings()`
- `scrap_players(driver, url, season)`
- `scrape_all_players()`
- `fetch_data(league, season)`
- `scrape_all_matches(max_workers=10)`
- `create_leagues()`
- `create_teams(standings_path=None)`
- `create_formations(matches_path=None)`
- `run(targets)`
