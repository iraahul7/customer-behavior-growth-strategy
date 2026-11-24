# Customer Behavior & Growth Strategy Analysis

**Tech Stack:** SQL (PostgreSQL / MySQL) | Tableau | Microsoft Excel | Python

## Project Overview
Analyzed **50,000+ multi-table transaction and clickstream records** across **6 relational tables** to diagnose customer acquisition bottlenecks, identify a **32% funnel drop-off stage**, and formulate a targeted retention strategy projected to drive a **15% lift in repeat engagement**.

## Repository Structure
```text
|-- sql/
|   |-- 01_data_cleaning_pipeline.sql       # Deduplication, null imputation & schema validation across 6 tables
|   |-- 02_funnel_and_retention_analysis.sql # Multi-table joins, CTEs & window functions for funnel/cohort KPIs
|-- scripts/
|   |-- generate_sample_data.py              # Reproducible synthetic dataset generator
|-- data/
|   |-- sample_customers.csv                 # Sample customer records (previewable on GitHub)
|   |-- sample_orders.csv                    # Sample order transaction records (previewable on GitHub)
|-- README.md
```

## Methodology & Execution
1. **Automated SQL & Excel ETL Cleaning Pipeline:** Consolidated 6 relational tables (`customers`, `sessions`, `cart_events`, `orders`, `payments`, `support_tickets`), removing duplicate logs via `ROW_NUMBER()` and standardizing null attributes.
2. **Funnel & Cohort Drop-Off Diagnostics:** Isolated a **32% drop-off between Checkout Initiated and Payment Completed**, driven by shipping fee surprises on orders under INR 999 and mobile payment gateway timeouts.
3. **Interactive Tableau Dashboard & Retention Strategy:** Built cohort retention views and recommended dynamic free-shipping thresholds targeting a **15% lift in repeat engagement**.
