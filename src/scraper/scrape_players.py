"""
Scrape player wages from FBref.
5 threads — one per league, each iterating through all seasons.
"""

import warnings
import threading
import pandas as pd
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from config import LEAGUES, SEASONS, OUTPUT_DIR
from driver import create_driver

warnings.filterwarnings("ignore")

_results: dict[str, pd.DataFrame] = {}
_results_lock = threading.Lock()
_driver_init_lock = threading.Lock()

def scrap_players(driver, url: str, season: int) -> pd.DataFrame:
    driver.get(url)

    wait = WebDriverWait(driver, 60)
    table = wait.until(
        EC.presence_of_element_located((By.ID, "player_wages"))
    )

    header = table.find_element(By.TAG_NAME, "thead")
    body   = table.find_element(By.TAG_NAME, "tbody")

    column_names = [i.text for i in header.find_elements(By.TAG_NAME, "th")]

    rows = []
    for i in body.find_elements(By.TAG_NAME, "tr"):

        # skip header/group rows
        if "class" in i.get_attribute("outerHTML") and "thead" in i.get_attribute("class"):
            continue

        row_values = i.find_elements(By.TAG_NAME, "td")
        if len(row_values) == 0:
            continue

        row = [i.find_element(By.TAG_NAME, "th").text]

        try:
            country = i.find_element(By.CSS_SELECTOR, 'td[data-stat="nationality"] a').get_attribute("href")
        except:
            country = None

        row.append(row_values[0].text)

        for j in row_values[1:]:
            row.append(j.text)

        row[2] = country
        rows.append(row)

    players_df = pd.DataFrame(rows, columns=column_names)

    players_df["Season"] = season
    return players_df


def _league_worker(league_name: str, league_id: str, league_slug: str) -> None:
    """Thread target: scrapes every season for one league."""
    with _driver_init_lock:  # one thread initializes at a time
        driver = create_driver(version_main=147)

    try:
        for season in SEASONS:
            print(f"[{league_name}] Season {season} — starting")
            url = (
                f"https://fbref.com/en/comps/{league_id}"
                f"/{season-1}-{season}/wages"
                f"/{season-1}-{season}-{league_slug}-Wages"
            )
            try:
                data = scrap_players(driver, url, season)
                key = f"{league_name}{season}"
                with _results_lock:
                    _results[key] = data
                print(f"[{league_name}] Season {season} — done ({len(data)} rows)")
            except Exception as exc:
                print(f"[{league_name}] Season {season} — FAILED: {exc}")
    finally:
        driver.quit()


def scrape_all_players() -> pd.DataFrame:
    threads = [
        threading.Thread(
            target=_league_worker,
            args=(league_name, league_id, league_slug),
            name=league_name,
            daemon=True,
        )
        for league_name, (league_id, league_slug) in LEAGUES.items()
    ]

    for t in threads:
        t.start()

    for t in threads:
        t.join()

    frames = list(_results.values())
    if not frames:
        raise RuntimeError("No data was collected — check the logs above.")

    return pd.concat(frames, ignore_index=True)


if __name__ == "__main__":
    df = scrape_all_players()
    out = f"{OUTPUT_DIR}/players_data.csv"
    nations_code = []
    nations = []

    for i,j in df.iterrows():
        nation = j['Nation']
        nation = str(nation)
        if len(nation.split('/')) > 1:
            nations.append(nation.split('/')[-1].split('-')[0])
            nations_code.append(nation.split('/')[-2])
        else:
            nations.append('Unknown')
            nations_code.append('Unknown')

    df['Nation'] = pd.Series(nations_code)

    country_data = pd.DataFrame()
    country_data['Nation_codes'] = pd.Series(nations_code)
    country_data['Nation'] = pd.Series(nations)

    country_data = country_data.drop_duplicates()

    country_data.to_csv(f'{OUTPUT_DIR}/countries.csv')

    df.to_csv(out, index=False)
    print(f"Saved → {out}")