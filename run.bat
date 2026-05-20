.\.venv\Scripts\activate

cd .\project\tikidata\

dbt seed

dbt run

dbt docs generate

dbt docs serve