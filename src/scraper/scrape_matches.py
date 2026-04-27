"""
Scrape team match stats via the soccerdata library (FBref backend).
"""

import warnings
import logging
import pandas as pd
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm

import soccerdata as sd

from src.scraper.config import SOCCERDATA_LEAGUES, SEASONS, OUTPUT_DIR

warnings.filterwarnings("ignore", category=FutureWarning)
logging.getLogger("soccerdata").setLevel(logging.ERROR)


def fetch_data(league: str, season: int) -> pd.DataFrame | None:
    try:
        fbref = sd.FBref(leagues=[league], seasons=[season])
        df = fbref.read_team_match_stats()
        df["league"] = league
        df["season"] = season
        return df
    except Exception as e:
        print(f"Error for {league} {season}: {e}")
        return None


def scrape_all_matches(max_workers: int = 10) -> pd.DataFrame:
    tasks = [
        (league, season)
        for league in SOCCERDATA_LEAGUES
        for season in SEASONS
    ]
    results = []

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {
            executor.submit(fetch_data, league, season): (league, season)
            for league, season in tasks
        }
        for future in tqdm(as_completed(futures), total=len(futures), desc="Scraping FBref"):
            res = future.result()
            if res is not None:
                results.append(res)

    return pd.concat(results, ignore_index=False)


if __name__ == "__main__":
    df = scrape_all_matches()
    out = f"{OUTPUT_DIR}/matches_table.csv"
    df.to_csv(out)
    print(f"Saved → {out}")