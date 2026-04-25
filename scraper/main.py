"""
Run all scrapers and dimension builders.
Usage:
    python main.py                  # runs everything
    python main.py standings        # standings only
    python main.py players          # players only
    python main.py matches          # matches only
    python main.py leagues          # league dimension table only
    python main.py teams            # teams dimension table only (requires standings csv)
"""

import sys

from scrape_standings  import scrape_all_standings
from scrape_players    import scrape_all_players
from scrape_matches    import scrape_all_matches
from create_dimensions import create_leagues, create_teams, create_formations
from config import OUTPUT_DIR


SCRAPERS = {
    "standings": (scrape_all_standings, f"{OUTPUT_DIR}/standings_data.csv"),
    "players":   (scrape_all_players,   f"{OUTPUT_DIR}/players_data.csv"),
    "matches":   (scrape_all_matches,   f"{OUTPUT_DIR}/matches_table.csv"),
    "leagues":   (create_leagues,       f"{OUTPUT_DIR}/league_table.csv"),
    "teams":     (create_teams,         f"{OUTPUT_DIR}/teams_table.csv"),
    "formations":(create_formations,    f"{OUTPUT_DIR}/formations_table.csv"),
}


def run(targets: list[str]) -> None:
    for name in targets:
        fn, path = SCRAPERS[name]
        print(f"\n{'='*50}")
        print(f"Running: {name}")
        print(f"{'='*50}")
        df = fn()
        df.to_csv(path, index=False)
        print(f"Saved → {path}  ({len(df):,} rows)")


if __name__ == "__main__":
    args = sys.argv[1:]
    chosen = args if args else list(SCRAPERS.keys())

    invalid = [a for a in chosen if a not in SCRAPERS]
    if invalid:
        print(f"Unknown scraper(s): {invalid}")
        print(f"Valid options: {list(SCRAPERS.keys())}")
        sys.exit(1)

    run(chosen)