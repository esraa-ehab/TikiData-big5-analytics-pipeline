
GRANT USAGE ON WAREHOUSE tikidata_wh TO ROLE dbt_dev_role;
GRANT USAGE ON DATABASE tikidata TO ROLE dbt_dev_role;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE STAGE
    ON SCHEMA tikidata.raw TO ROLE dbt_dev_role;

-- staging, intermediate, marts: dbt creates and manages these
GRANT USAGE, CREATE TABLE, CREATE VIEW
    ON SCHEMA tikidata.staging TO ROLE dbt_dev_role;

GRANT USAGE, CREATE TABLE, CREATE VIEW
    ON SCHEMA tikidata.intermediate TO ROLE dbt_dev_role;

GRANT USAGE, CREATE TABLE, CREATE VIEW
    ON SCHEMA tikidata.marts TO ROLE dbt_dev_role;