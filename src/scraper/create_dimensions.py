"""
Build static dimension tables:
  - league_table     : league metadata (id, name, country, season)
  - teams_table      : unique squads per league, derived from standings data
  - formations_table : unique formations, derived from matches data
"""

import pandas as pd
import numpy as np
import hashlib

from config import (
    LEAGUE_IDS, LEAGUE_NAMES_DW, COUNTRIES, SEASONS, OUTPUT_DIR
)


# ---------------------------------------------------------------------------
# League dimension
# ---------------------------------------------------------------------------

def create_leagues() -> pd.DataFrame:
    seasons = list(range(max(SEASONS), min(SEASONS) - 1, -1))

    league_table = pd.DataFrame({
        "League_id":   LEAGUE_IDS     * len(seasons),
        "League_name": LEAGUE_NAMES_DW * len(seasons),
        "Country":     COUNTRIES      * len(seasons),
        "Season_year": [s for s in seasons for _ in LEAGUE_IDS],
    })

    league_table.sort_values(by=["League_name", "Season_year"], inplace=True)
    return league_table


# ---------------------------------------------------------------------------
# Teams dimension
# ---------------------------------------------------------------------------

def create_teams(standings_path: str | None = None) -> pd.DataFrame:
    path = standings_path or f"{OUTPUT_DIR}/standings_data.csv"
    data = pd.read_csv(path)

    squad_data = data[["Squad", "League"]].drop_duplicates()

    squad_data["unique_team_id"] = squad_data["Squad"].apply(
    lambda x: int(hashlib.sha256(x.encode()).hexdigest(), 16) % 10**8
    )
    return squad_data


# ---------------------------------------------------------------------------
# Formations dimension
# ---------------------------------------------------------------------------

def create_formations(matches_path: str | None = None) -> pd.DataFrame:
    path = matches_path or f"{OUTPUT_DIR}/matches_table.csv"
    matches = pd.read_csv(path)

    formations = matches["Opp Formation"].unique()
    formations = formations[pd.notnull(formations)]
    return pd.DataFrame(formations, columns=["formations"])


# ---------------------------------------------------------------------------
# Seasons dimension
# ---------------------------------------------------------------------------

def create_seasons() -> pd.DataFrame:
    seasons = np.arange(2016, 2026)
    season_ids = [f"S{i}" for i in range(len(seasons))]

    return pd.DataFrame({
        "season_id": season_ids,
        "season": seasons
    })

if __name__ == "__main__":
    leagues_df = create_leagues()
    out = f"{OUTPUT_DIR}/league_table.csv"
    leagues_df.to_csv(out, index=False)
    print(f"Saved -> {out}  ({len(leagues_df):,} rows)")

    teams_df = create_teams()
    out = f"{OUTPUT_DIR}/teams_table.csv"
    teams_df.to_csv(out, index=False)
    print(f"Saved -> {out}  ({len(teams_df):,} rows)")

    formations_df = create_formations()
    out = f"{OUTPUT_DIR}/formations_table.csv"
    formations_df.to_csv(out, index=False)
    print(f"Saved -> {out}  ({len(formations_df):,} rows)")