from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import undetected_chromedriver as uc
import pandas as pd

options = uc.ChromeOptions()
options.add_argument("--start-maximized")

driver = uc.Chrome(options=options)

def scrap_standing(url):

    driver.get(url)

    # Wait until Cloudflare check disappears and table becomes available
    wait = WebDriverWait(driver, 60)
    table = wait.until(
        EC.presence_of_element_located((By.CLASS_NAME, "stats_table"))
    )

    header = table.find_element(By.TAG_NAME, 'thead')
    body = table.find_element(By.TAG_NAME, 'tbody')

    column_names = [i.text for i in header.find_elements(By.TAG_NAME, 'th')]

    rows = []

    for i in body.find_elements(By.TAG_NAME, 'tr'):
        row = []
        row.append(i.find_element(By.TAG_NAME, 'th').text)

        row_values = i.find_elements(By.TAG_NAME, 'td')

        row.append(row_values[0].text)

        for j in row_values[1:]:
            row.append(j.text)

        rows.append(row)

    standings_df = pd.DataFrame(rows, columns=column_names)

    return standings_df