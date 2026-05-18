# TikiData Big 5 Analytics Pipeline

## Overview

**TikiData Big 5 Analytics Pipeline** is a comprehensive data engineering solution that collects, transforms, and analyzes football (soccer) data from the world's top five leagues. It aggregates player statistics, team performance, match results, and league standings to provide actionable insights for football analytics.

The pipeline pulls data from **FBref** (Football Reference) and builds a modern data warehouse using **dbt** for transformation, **Snowflake** for storage, and **Dagster** for orchestration.

---

## What This Project Does

This project automates the complete lifecycle of football data:

### Data Collection
- **Standings Data**: Scrapes league tables, points, and rankings using Selenium
- **Player Wages**: Extracts player salary and contract information
- **Match Statistics**: Gathers team match stats including formation, goals, and performance metrics
- **Dimension Tables**: Automatically generates reference data for leagues, teams, players, and formations

### Data Transformation
- Cleans and standardizes raw data into production-ready analytics tables
- Creates reusable dimensional and fact tables following the medallion architecture pattern
- Implements data quality checks and constraints

### Data Delivery
- Publishes analytics-ready tables for business intelligence tools (e.g., Tableau, Power BI)
- Enables interactive dashboards and ad-hoc queries

---

## Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Orchestration** | Dagster | Schedules and monitors data pipelines |
| **Transformation** | dbt (Data Build Tool) | SQL-based data transformations |
| **Data Warehouse** | Snowflake | Centralized cloud data storage |
| **Web Scraping** | Selenium, SoccerData | Extracts data from FBref |
| **Language** | Python 3.10+ | Scripting and orchestration |
| **Dashboarding** | Tableau | Business intelligence visualizations |

---

## Architecture

### Data Flow Diagram

```


### Medallion Architecture

The project follows the medallion (bronze-silver-gold) data architecture pattern:

#### 🥉 **Staging Layer** (`stg_*`)
Raw data ingested from source systems with minimal transformations.
- `stg_standings` - League standings tables
- `stg_players` - Player information and wages
- `stg_matches` - Match-level statistics
- `stg_teams` - Team reference data
- `stg_leagues` - League definitions
- `stg_seasons` - Season identifiers
- `stg_formations` - Formation types
- `stg_positions` - Player positions

#### 🥈 **Intermediate Layer** (`int_*`)
Business logic applied, data cleaned and aggregated.
- `int_standings` - Standardized standings with calculated metrics
- `int_players` - Player profiles with derived attributes
- `int_matches` - Match analytics
- `int_teams` - Team master data
- `int_leagues` - League master data
- `int_unique_players` - Deduplicated player records

#### 🥇 **Mart Layer** (`marts/dims/` and `marts/facts/`)
Analytics-ready tables for BI tools and reporting.

**Dimensions (Reference Tables):**
- `dim_league` - League master dimension
- `dim_team` - Team dimension with team IDs and metadata
- `dim_player` - Player dimension with career information
- `dim_unique_player` - Unique player identifier for deduplication
- `dim_date` - Date dimension for time-based analysis

**Facts (Event/Measure Tables):**
- `fact_standing` - League standings facts (positions, points, goals)
- `fact_match` - Match-level facts (scores, formations, performances)
- `fact_contract` - Player contract and wage facts

---

## Entity Relationship Diagram (ERD)

```
[Placeholder: Add ERD Diagram]

Key Relationships:
- Matches connect to Teams and Leagues via foreign keys
- Players relate to Teams and Seasons
- Standings connect to Teams, Leagues, and Seasons
- Contracts link Players to Teams and Seasons
```

---

## Dimensional Data Model

```
[Placeholder: Add Dimensional Model Diagram]

Star Schema Example:

                    dim_league
                        |
        ┌───────────────┼───────────────┐
        |               |               |
    dim_date        fact_standing   dim_team
                        |
                    dim_season
```

### Key Dimensions

| Dimension | Purpose | Key Attributes |
|-----------|---------|-----------------|
| **dim_league** | League reference | League ID, League Name, Country |
| **dim_team** | Team reference | Team ID, Team Name, League, Country |
| **dim_player** | Player reference | Player ID, Name, Position, Nationality |
| **dim_date** | Time reference | Date, Month, Year, Quarter, Season |

### Key Facts

| Fact Table | Grain | Key Measures |
|-----------|-------|--------------|
| **fact_standing** | One row per team per season | Points, Goals For, Goals Against, Rank |
| **fact_match** | One row per match | Home Goals, Away Goals, Possession, Shots |
| **fact_contract** | One row per player contract | Wages, Contract Duration, Transfer Fee |

---

## Project Structure

```
TikiData-big5-analytics-pipeline/
├── README.md                          # This file
├── doc.md                             # Detailed function documentation
├── pyproject.toml                     # Python project configuration
├── uv.lock                            # Dependency lock file
│
├── project/
│   └── tikidata/                      # Main dbt project
│       ├── dbt_project.yml            # dbt configuration
│       ├── profiles.yml               # Snowflake connection config
│       ├── packages.yml               # dbt package dependencies
│       │
│       ├── models/                    # dbt transformation models
│       │   ├── stg/                   # Staging layer (raw → clean)
│       │   ├── intermediate/          # Intermediate layer (business logic)
│       │   ├── marts/                 # Marts layer (analytics-ready)
│       │   │   ├── dims/              # Dimension tables
│       │   │   └── facts/             # Fact tables
│       │   ├── sources.yml            # Source table definitions
│       │   └── schema.yml             # Column descriptions & tests
│       │
│       ├── tests/                     # dbt tests (data quality)
│       ├── macros/                    # Custom dbt macros
│       └── seeds/                     # Reference/lookup data
│
├── src/                               # Python source code
│   └── scraper/                       # Data scraping modules
│       ├── config.py                  # Scraper configuration (leagues, seasons)
│       ├── driver.py                  # Selenium WebDriver setup
│       ├── scrape_standings.py        # Standings scraper
│       ├── scrape_players.py          # Player wages scraper
│       ├── scrape_matches.py          # Match stats scraper
│       ├── create_dimentions.py       # Dimension table builder
│       └── main.py                    # Pipeline orchestration
│
├── Notebooks/                         # Jupyter notebooks for exploration
│
├── Documentation/                     # Project documentation
│   └── *.pptx, *.md                   # Guides and presentations
│
├── Dashboard/                         # Tableau/BI dashboards
│   └── Dashboard.twb                  # Tableau workbook
│
├── logs/                              # Pipeline execution logs
│   └── dbt.log                        # dbt run logs
│
└── recources/                         # External resources and references
```

---

## Getting Started

### Prerequisites

- Python 3.10 or higher
- Snowflake account with database and schema
- dbt CLI installed
- Git

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/esraa-ehab/TikiData-big5-analytics-pipeline.git
   cd TikiData-big5-analytics-pipeline
   ```

2. **Create a virtual environment:**
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   uv sync
   # or: pip install -e .
   ```

4. **Configure Snowflake connection:**
   Edit `project/tikidata/profiles.yml` with your Snowflake credentials:
   ```yaml
   tikidata:
     target: dev
     outputs:
       dev:
         type: snowflake
         account: your_account
         user: your_user
         password: your_password
         database: your_database
         schema: your_schema
         warehouse: your_warehouse
   ```

### Running the Pipeline

#### Option 1: Run Data Scrapers
```bash
cd src/scraper
python main.py                # Run all scrapers
python main.py standings      # Run specific scraper
```

#### Option 2: Run dbt Transformations
```bash
cd project/tikidata
dbt deps                      # Install dbt packages
dbt seed                      # Load reference data
dbt run                       # Execute transformations
dbt test                      # Run data quality checks
```

#### Option 3: Run with Dagster (Production)
```bash
cd project
dagster dev
```

---

## Dashboard Preview

```
[Placeholder: Add Dashboard Screenshot]

Key Dashboards:
- League Performance Dashboard - Rankings, points, and trends
- Player Analytics Dashboard - Wages, performance, and comparisons
- Match Analysis Dashboard - Formation, goals, and team statistics
- Seasonal Trends Dashboard - Historical performance patterns
```

---

## Data Pipeline Execution Flow

```
[Placeholder: Add Execution Flow Diagram]

Sequence:
1. FBref → Python Scrapers (standings, players, matches)
2. CSV/Raw Tables → dbt Staging Models
3. Staging → dbt Intermediate Models (transformations)
4. Intermediate → dbt Mart Models (dimensions + facts)
5. Mart Tables → BI Tools (Tableau, Power BI)
6. BI Tools → Dashboards & Reports
```

---

## Key Data Sources

- **FBref (Football Reference)**
  - URL: https://fbref.com
  - Data: League standings, player statistics, match records
  - Update Frequency: Real-time during seasons

- **SoccerData Library**
  - Used for detailed match statistics and team metrics

---

## Configuration

### Leagues and Seasons

The pipeline is configured to scrape data for the Big 5 European leagues:

1. **Premier League** (England)
2. **La Liga** (Spain)
3. **Serie A** (Italy)
4. **Bundesliga** (Germany)
5. **Ligue 1** (France)

**Seasons Covered:** 2016 to 2025

Configuration file: `src/scraper/config.py`

### Output Locations

- **Raw Scraped Data:** `Scrapped_data/` (CSV files)
- **Transformed Data:** Snowflake database tables
- **Warehouse:** PROD database, MARTS schema

---

## Data Quality

The project implements multiple data quality checks:

- **Unique Constraints:** Player IDs, Team IDs, League IDs are unique
- **Foreign Key Constraints:** Referential integrity between dimensions and facts
- **Not Null Constraints:** Critical columns must have values
- **dbt Tests:** Custom tests in `schema.yml` validate business logic

Run data quality tests:
```bash
dbt test
```

---

## Performance & Scalability

### Scraping Performance
- Multi-threaded web scraping (default: 10 workers for matches)
- Selenium-based scraping with browser caching
- Estimated time: 2-4 hours for full historical data refresh

### Transformation Performance
- dbt models optimized as incremental tables where applicable
- Snowflake clustering keys on high-cardinality join columns
- Parallel execution of independent models

### Storage
- Estimated raw data: 500MB - 2GB
- Estimated warehouse: 2-5GB (depending on historical depth)

---

## Troubleshooting

### Scraper Issues

**Problem:** "ChromeDriver version mismatch"
```
Solution: Update Chrome version or pin version in create_driver(version_main=147)
```

**Problem:** "FBref page structure changed"
```
Solution: Update CSS selectors in scrape_standings.py or scrape_players.py
```

### dbt Issues

**Problem:** "Database connection failed"
```
Solution: Verify Snowflake credentials in profiles.yml and test with: dbt debug
```

**Problem:** "Model dependency errors"
```
Solution: Run `dbt run -s model_name --full-refresh` to rebuild dependent models
```

---

## Contributing

To contribute to this project:

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -m "Add your feature"`
3. Push to branch: `git push origin feature/your-feature`
4. Open a Pull Request

---

## Documentation

- **[Detailed Function Documentation](doc.md)** - In-depth function reference
- **[dbt Documentation](project/tikidata/target/index.html)** - Auto-generated dbt docs (run `dbt docs generate`)
- **[Resources](recources/)** - Additional references and guides

---

## Team

- **Authors:** 
   - Israa Ehab
   - Abdelrahman Karam
- **Repository:** https://github.com/esraa-ehab/TikiData-big5-analytics-pipeline

---

## Contact & Support

For questions, issues, or feature requests, please:
- Open an issue on GitHub
- Check existing documentation in `doc.md`
- Review dbt logs in `logs/dbt.log`

---

## Roadmap

- [ ] Add incremental match data updates (instead of full refreshes)
- [ ] Implement advanced analytics models (xG, expected goals)
- [ ] Add more data sources (player market value, transfers)
- [ ] Optimize scraper for faster data collection
- [ ] Add anomaly detection for data quality monitoring
- [ ] Expand dashboard capabilities with predictive analytics

---

## Appendix: Visual Placeholders

### 1. Data Architecture Diagram
```
[INSERT HIGH-LEVEL ARCHITECTURE DIAGRAM HERE]
Shows: Data sources → Scrapers → Staging → Intermediate → Marts → BI Tools
```

### 2. Entity Relationship Diagram (ERD)
```
[INSERT DETAILED ERD HERE]
Shows: All tables, relationships, and primary/foreign keys
```

### 3. Dimensional Data Model
```
[INSERT STAR SCHEMA DIAGRAM HERE]
Shows: Fact table in center with dimension tables around it
```

### 4. Pipeline Execution Flow
```
[INSERT DAGSTER DAG DIAGRAM HERE]
Shows: Task dependencies and execution order
```

### 5. Sample Dashboard
```
[INSERT TABLEAU/POWER BI DASHBOARD SCREENSHOT HERE]
Shows: Key metrics, charts, and visualizations
```

### 6. Data Volume Trends
```
[INSERT CHART SHOWING DATA GROWTH OVER TIME]
```

### 7. System Performance Metrics
```
[INSERT PERFORMANCE DASHBOARD SCREENSHOT]
Shows: Pipeline execution time, data freshness, transformation performance
```

---

**Last Updated:** May 2026  
**Project Status:** Active Development
