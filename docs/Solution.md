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
Here is the task break down of setting up a proper system for data modeling.
### Step 1 – Validate Environment
> Set up Spark, Delta Lake and Jupyter Notebooks, and validates cluster connectivity and proper mapping of storage paths.

**Notebook:** [TestConnect](../notebooks/TestConnection.ipynb)

### Step 2 – Exploratory Analysis*:
> Profile source data, identify outliers, nulls, schema inconsistencies, and candidate keys using Pandas.

**Notebook:** [ExploreData](../notebooks/ExploreData.ipynb)

**Report**

1. **Schema Consistency**:

The `customer` dataset appears clean with stable schema:
- `customer_id` is a unique identifier (can be primary key).
- All fields are of expected types (e.g., `age: integer`, `gender: categorical`).

The `sales` dataset contains:
- Referential relationship via customer_id.
- There is a potential for foreign key integrity issues on `customer_id`.
> **Action:** We'll add a foreign key integrity test between `sales.customer_id` and `customer.customer_id`.
2. **Data Quality Issues**:
* Missing values:
Overall missing values are very low (< 0.1%), but still:
  - `age` has some missing entries.
* Duplicate values:
  - There is no data duplication in `sales` or `customer` datasets.
  - There is only one `invoice_no` per `customer_id` in the `sales` table.
* Date format (`invoice_date`):
is stored as string (e.g., "15-10-2022"), which needs conversion.

  * We can add Date test as part of Silver transformations.
  * We can extract year, month, day for partitioning data.
> **Action:**
> - Apply a date parser and validate that `invoice_date` is consistent and convertible.
> - `customer_id`, `invoice_date`, and `invoice_no` are essential, rows with missing values here will be dropped in Silver.
> - `age` is non-critical — missing values will be retained as null and filled into an `"Unknown"` age band during modeling.
3. Outliers and Numerical Ranges
* `quantity` is within valid bounds for retail purchases (1–5); no filtering needed.
* `price` has high variance; we'll check for negative prices and flag values above 99th percentile for review or anomaly tagging.
> **Action:**
> * Check for negative values (invalid value)
> * Abnormally large values (suspicious activity)

### Step 3 - Data Modeling:
> Define core analytical goals and model design (e.g., grain, schema, dimensions), along with data quality considerations and assumptions.

* We will use Medalion Architecture for our data modeling, in which:

| Stage   | Required Enhancements                                                    |
|---------|--------------------------------------------------------------------------|
| Bronze  | Ingest raw files without enforcing schema.                               |
| Silver  | Validated foreign keys, convert invoice_date, drop grabage data          |
| Gold    | Creates fact and dims, derive aggregates, expose sales_by_customer table |


* Based on the analysis we have done, we can define our data models. Here is a summary of attributes:

| Column          | Use in Analytics                         | Comment                           |
|-----------------|-------------------------------------------|-----------------------------------|
| `gender`        | Segmentation, funnel breakdown            | Standard categories               |
| `age`           | Bucketization, cohort analysis            | Define age bands (e.g., 18–25…)   |
| `payment_method`| Payment trend analysis, fraud detection   | Normalize spelling/capitalization |
| `shopping_mall` | Store-level performance, regional trends  | Optional enrichment               |
| `category`      | Category mix, AOV by product group        | Could evolve into full dim_product|
| `invoice_date`  | Time-based analytics, incremental loading | Must be parsed to derive calendar dim |


**Modeling Implications:**
  * Fact Table:
    - `fact_sales_by_customer`
        * PK: `invoice_no`, granularity: one line per invoice
        * FK: `customer_id`, `category`, `shopping_mall`, `invoice_date`
  * Dimensions:
    - `dim_customer`(`customer_id` PK): `customer_id`, `age`, `gender`, `payment_method`

### Step 4: Developing ETL/ELT:
Based on the data models defined above, we will implement 
Implement medallion-style transformation: bronze -> silver -> gold. Write gold outputs to Delta Lake, optimized for analytics performance.

**Notebook:** [LoadData](../notebooks/LoadData.ipynb)

### Step 5: Data Quality Tests:
Identify and test key data constraints (e.g., not-null fields, referential integrity, date ranges, numeric thresholds) to enforce expectations and pipeline stability.
