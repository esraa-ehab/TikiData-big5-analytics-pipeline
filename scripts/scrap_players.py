import undetected_chromedriver as uc
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd

import warnings
warnings.filterwarnings("ignore")

options = uc.ChromeOptions()
options.add_argument("--start-maximized")

driver = uc.Chrome(options=options, version_main=147)

def scrap_players(url, season):

    driver.get(url)

    # Wait until Cloudflare check disappears and table becomes available
    wait = WebDriverWait(driver, 60)
    table = wait.until(
        EC.presence_of_element_located((By.ID, 'player_wages'))
    )

    header = table.find_element(By.TAG_NAME, 'thead')
    body = table.find_element(By.TAG_NAME, 'tbody')

    column_names = [i.text for i in header.find_elements(By.TAG_NAME, 'th')]

    rows = []

    for i in body.find_elements(By.TAG_NAME, 'tr'):
        row = []

        row.append(i.find_element(By.TAG_NAME, 'th').text)

        row_values = i.find_elements(By.TAG_NAME, 'td')

        if len(row_values) == 0:
            continue

        row.append(row_values[0].text)

        for j in row_values[1:]:
            row.append(j.text)

        rows.append(row)

    players_df = pd.DataFrame(rows, columns=column_names)

    players_df["Season"] = season

    return players_df

leagues = {
    "Premier League": (9, "Premier-League"),
    "La Liga": (12, "La-Liga"),
    "Serie A": (11, "Serie-A"),
    "Bundesliga": (20, "Bundesliga"),
    "Ligue 1": (13, "Ligue-1")
}

leagues_dict = {}

for league in leagues.items():
    for season in range(2016, 2026, 1):
        print(f"League: {league[0]}, Season: {season}")
        base_url = f"https://fbref.com/en/comps/{league[1][0]}/{season-1}-{season}/wages/{season-1}-{season}-{league[1][1]}-Wages"
        data = scrap_players(base_url, season)

        leagues_dict[str(league[0])+str(season)] = data
        print(f'Scraping {league[0]} {season} done')
 
    print("\n\n")

league_dict_values = list(leagues_dict.values())

players_data = league_dict_values[0]

for i in league_dict_values[1:]:
    players_data = pd.concat([players_data, i])

players_data.to_csv("Scrapped_data\players_data.csv")