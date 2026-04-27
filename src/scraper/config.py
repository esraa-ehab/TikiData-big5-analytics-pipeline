"""
Shared configuration: league definitions and season range.
"""

# Used by create_leagues() — order must match across all three lists
LEAGUE_IDS      = ["PL", "LL", "SA", "BL1", "FL1"]
LEAGUE_NAMES_DW = ["Premier League", "La Liga", "Serie A", "Bundsliga", "Ligue 1"]
COUNTRIES       = ["England", "Spain", "Italy", "Germany", "France"]

LEAGUES = {
    "Premier League": (9, "Premier-League"),
    "La Liga":        (12, "La-Liga"),
    "Serie A":        (11, "Serie-A"),
    "Bundesliga":     (20, "Bundesliga"),
    "Ligue 1":        (13, "Ligue-1"),
}

SOCCERDATA_LEAGUES = [
    "ENG-Premier League",
    "ESP-La Liga",
    "ITA-Serie A",
    "GER-Bundesliga",
    "FRA-Ligue 1",
]

SEASONS = list(range(2016, 2026))

OUTPUT_DIR = "project/tikidata/seeds"