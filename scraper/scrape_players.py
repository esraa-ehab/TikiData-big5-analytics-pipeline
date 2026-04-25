"""
Scrape player wages from FBref.
"""

import warnings
import pandas as pd
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from config import LEAGUES, SEASONS, OUTPUT_DIR
from driver import create_driver

warnings.filterwarnings("ignore")



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
        row = [i.find_element(By.TAG_NAME, "th").text]
        row_values = i.find_elements(By.TAG_NAME, "td")

        if len(row_values) == 0:
            continue

        row.append(row_values[0].text)
        for j in row_values[1:]:
            row.append(j.text)
        rows.append(row)

    players_df = pd.DataFrame(rows, columns=column_names)
    players_df["Season"] = season
    return players_df


def scrape_all_players() -> pd.DataFrame:
    driver = create_driver(version_main=147)
    leagues_dict = {}

    try:
        for league_name, (league_id, league_slug) in LEAGUES.items():
            for season in SEASONS:
                print(f"League: {league_name}, Season: {season}")
                url = (
                    f"https://fbref.com/en/comps/{league_id}"
                    f"/{season-1}-{season}/wages"
                    f"/{season-1}-{season}-{league_slug}-Wages"
                )
                data = scrap_players(driver, url, season)
                leagues_dict[f"{league_name}{season}"] = data
                print(f"Scraping {league_name} {season} done")
            print("\n")
    finally:
        driver.quit()

    frames = list(leagues_dict.values())
    return pd.concat(frames, ignore_index=True)


if __name__ == "__main__":
    df = scrape_all_players()
    out = f"{OUTPUT_DIR}/players_data.csv"
    df.to_csv(out, index=False)
    print(f"Saved → {out}")