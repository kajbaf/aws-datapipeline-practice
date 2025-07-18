# Data Engineering Practice

This project demonstrates a practical data pipeline built using a modern data stack: Apache Spark, Delta Lake, and local containerized infrastructure. The focus is on profiling, modeling, and transforming customer and sales data into analytics-ready Delta Lake tables. This environment is lightweight but reflects production-grade architecture principles.

I usually set up such systems with a some additional components like `dbt` and `Airflow` as a local development environment which data teams can use to debug their queries locally before deploying to the production environment.

Although I usually include components like `dbt` and `Airflow` in such projects for local debugging of data pipelines, they are not used in this implementation. However, the project structure supports modular development and can be easily extended with orchestration and semantic modeling layers in future iterations.

To review the original problem statement, see:
> [Problem Statement](../README.md#problem)

## Goal

The primary objective is to integrate and clean customer and sales data, model it into a well-partitioned analytical table in an Open Table Format (Delta Lake), and make it query-optimized for downstream use.

This local implementation includes design principles aligned with production systems:

* Medallion architecture (bronze, silver, gold layers)
* Partitioned storage for performance
* Data quality rules and failure tolerance
* Reusable, inspectable notebooks and PySpark jobs

For more details see:
> [Architecture](docs/architecture.md)

## Task 1: Integrate Data and Build Data Models
### Steps
* **Step 0 – Validate Environment**
Set up Spark + Delta Lake and validate cluster + storage connectivity.
[Notebook: TestConnect.](../notebooks/TestConnection.ipynb)
**Step 1 – Exploratory Analysis**:
Profile source data, identify outliers, nulls, schema inconsistencies, and candidate keys using Pandas.
[Notebook: ExploreData.](../notebooks/ExploreData.ipynb)
**Step 2 - Data Modeling**: 
Define core analytical goals and model design (e.g., grain, schema, dimensions), along with data quality considerations and assumptions.
**Step 3: Developing ETL/ELT**:
Implement medallion-style transformation: bronze -> silver -> gold. Write gold outputs to Delta Lake, optimized for analytics performance.
**Step 4: Data Quality Tests**:
Identify and test key data constraints (e.g., not-null fields, referential integrity, date ranges, numeric thresholds) to enforce expectations and pipeline stability.
