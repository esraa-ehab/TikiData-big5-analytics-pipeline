USE ROLE sysadmin;
CREATE OR REPLACE WAREHOUSE tikidata_wh
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

CREATE DATABASE IF NOT EXISTS tikidata;

CREATE SCHEMA IF NOT EXISTS tikidata.raw
    COMMENT = 'Raw scraped data — never modified';

CREATE SCHEMA IF NOT EXISTS tikidata.staging
    COMMENT = 'dbt staging models — 1:1 with raw, cleaned and renamed';

CREATE SCHEMA IF NOT EXISTS tikidata.intermediate
    COMMENT = 'dbt intermediate models — joined and reconciled';

CREATE SCHEMA IF NOT EXISTS tikidata.marts
    COMMENT = 'dbt mart models — final tables served to Power BI';