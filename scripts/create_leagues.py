import pandas as pd

def create_leagues():
    leagues = ["PL", "LL", "SA", "BL1", "FL1"]
    league_names = ["Premier League", "La Liga", "Serie A", "Bundsliga", "Ligue 1"]
    countries = ["England", "Spain", "Italy", "Germany", "France"]
    seasons = list(range(2025, 2015, -1))

    league_table = pd.DataFrame({
        "League_id": leagues * len(seasons),
        "League_name": league_names * len(seasons),
        "Country": countries * len(seasons),
        "Season_year": [s for s in seasons for _ in leagues]
    })

    league_table.sort_values(by=["League_name", "Season_year"])

    return league_table