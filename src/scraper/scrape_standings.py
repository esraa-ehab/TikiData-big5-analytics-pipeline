"""
Scrape league standings from FBref.
Scrape league standings from FBref.
"""

import pandas as pd
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from src.scraper.config import LEAGUES, SEASONS, OUTPUT_DIR
from src.scraper.driver import create_driver



def scrap_standing(driver, url: str, league: str, season: int) -> pd.DataFrame:
    driver.get(url)

    wait = WebDriverWait(driver, 60)
    table = wait.until(
        EC.presence_of_element_located((By.CLASS_NAME, "stats_table"))
        EC.presence_of_element_located((By.CLASS_NAME, "stats_table"))
    )

    header = table.find_element(By.TAG_NAME, "thead")
    body   = table.find_element(By.TAG_NAME, "tbody")

    column_names = [i.text for i in header.find_elements(By.TAG_NAME, "th")]

    rows = []
    for i in body.find_elements(By.TAG_NAME, "tr"):
        row = [i.find_element(By.TAG_NAME, "th").text]
        row_values = i.find_elements(By.TAG_NAME, "td")
        row.append(row_values[0].text)
        for j in row_values[1:]:
            row.append(j.text)
        rows.append(row)

    standings_df = pd.DataFrame(rows, columns=column_names)
    standings_df["Season"] = season
    standings_df["League"] = league
    return standings_df

    standings_df = pd.DataFrame(rows, columns=column_names)
    standings_df["Season"] = season
    standings_df["League"] = league
    return standings_df



def scrape_all_standings() -> pd.DataFrame:
def scrape_all_standings() -> pd.DataFrame:
    driver = create_driver(version_main=147)
    leagues_dict = {}

    try:
        for league_name, (league_id, league_slug) in LEAGUES.items():
            for season in SEASONS:
                print(f"League: {league_name}, Season: {season}")
                url = (
                    f"https://fbref.com/en/comps/{league_id}"
                    f"/{season-1}-{season}"
                    f"/{season-1}-{season}-{league_slug}-Stats"
                    f"/{season-1}-{season}"
                    f"/{season-1}-{season}-{league_slug}-Stats"
                )
                data = scrap_standing(driver, url, league_name, season)
                data = scrap_standing(driver, url, league_name, season)
                leagues_dict[f"{league_name}{season}"] = data
                print(f"Scraping {league_name} {season} done")
            print("\n")
    finally:
        driver.quit()

    frames = list(leagues_dict.values())
    return pd.concat(frames, ignore_index=True)


if __name__ == "__main__":
    df = scrape_all_standings()
    out = f"{OUTPUT_DIR}/standings_data.csv"
    df.to_csv(out, index=False)
    print(f"Saved → {out}")