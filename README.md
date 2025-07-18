# Data Engineering Practice

This repository contains a sample data engineering project designed toying with different technologies. It demonstrates how to ingest, clean, transform, and integrate data from multiple sources, and store the result using a modern Open Table Format (OTF), optimized for analytical workloads.

## Problem
This take home assignment consists of two parts: a Data Pipeline and a High-Level Design/Architecture.
### Data Pipeline
Design and implement a sample data pipeline using the following input datasets included in this package
1. `customer_data.parquet`
2. `sales_data.csv`

The goal is to integrate and process the data from both files and output it in a user-specified Open Table Format (OTF) (e.g., Delta Lake, Apache Iceberg, or Apache Hudi). The output should be optimized for query performance and ready for analytics team consumption.

Please include steps for loading, transforming, and storing the data, ensuring the final dataset is clean, query-ready, and adheres to best practices for the chosen OTF.
### High Level Design / Architecture
Modern applications generate a large amount and variety of data, across many systems. This data, if harnessed, can be a strategic and tactical asset. Please speak to the design of a data pipeline that would facilitate getting value from such data. Some elements we would like to hear about include:
- Extraction, transformation, loading and integration
- Enrichment and extension (semantic layer)
- Mitigating risk / single source of truth
- Scalability, availability and security
- Orchestration / workflow / performance
- Monitoring (failure, optimization, etc.)

## Tech Stack
This project uses multiple modern technologies for processing and analyzing data, including:
- **Apache Spark** For scalable, distributed data processing
- **Pandas** For exploratory analysis and lightweight transformation
- **Delta Lake** As the Open Table Format for data storage whih can supports ACID transactions
- **DBT** For writing transformation and data models and managing data lineage
- **Docker Compose** To simulate a local execution cluster and cloud-like data lake environment
This setup reflects how I typically design and build local dev environments for data teams, which can simulate realtime production systems in a modular, testable way.
