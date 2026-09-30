# EMS Chargemaster & Medicare Reimbursement Analysis

## Executive Summary
This project analyzes public CMS Medicare provider utilization data (`bigquery-public-data.cms_medicare.physicians_and_other_supplier_2015`) to evaluate pricing structures, chargemaster inflation, and reimbursement variances across emergency medical services (EMS) and ambulance transport codes. By establishing statistical benchmarks-specifically charge multipliers and 90th percentile (P90) thresholds-this analysis provides insight into how outpatient transport providers structure list prices relative to federal payment baselines.

## Dataset & Scope
- **Data Source:** Google Cloud BigQuery public datasets (`bigquery-puiblic-data.cms_medicare.physicians_and_other_supplier_2015`).
- **Target Population:** Ambulance service providers in Illinois (`nppes_provider_state = 'IL'` and `provider_type = 'Ambulance Service Provider'`).
- **Focus Codes:** Core emergency and non-emergency transport codes (`A0425`, `A0426`, `A0427`, `A0428`, `A0429`, `A0433`, `A0434`, etc.) and related support items.

---

## Repository Structure & Query Guide

The repository is structured into modular SQL scripts designed for reproducible analytics and revenue cycle auditing;

| Dir | File Name | Analytical Purpose | Key SQL Techniques |
| :--- | :--- | :--- | :--- |
| sql | `01_ambulance_volume_summary.sql` | Aggregates total claim volume, active provider counts, and average submitted charges versus Medicare allowed amounts by specific HCPCS code. | `GROUP BY`, `SUM`, `AVG`, conditional `IN` filters. |
| sql | `02_charge_multiplier_analysis.sql` | Calculates the ratio between list prices (chargemaster) and government-allowed baselines to evaluate pricing spread (minimum, average, and maximum multipliers). | CTEs (`WITH`), `SAFE_DIVIDE`, `MIN`, `MAX`, `AVG`. |
| sql | `03_p90_outlier_detection.sql` | Establishes statistical benchmarks by isolating providers operating in the top 10% pricing tier for transport services. | Window functions (`PERCENTILE_CONT`), `PARTITION BY`, `QUALIFY`. |
| outputs | `ambulance_volume_summary.csv` | Output from `01_ambulance_volume_summary.sql` | |
| outputs | `charge_multiplier_results.csv` | Output from `02_charge_multiplier_analysis.sql` | |
| outputs | `p90_outlier_results.csv` | Output from `03_p90_outlier_detection.sql` | |

---

## Key Methodology & Metrics

1. **Charge Multiplier:**
    $$\text{Charge Multiplier} = \frac{\text{Average Submitted Charge Amt}}{\text{Average Medicare Allowed Amt}}$$
    Measures how many times higher a provider's list price (chargemaster) is compared to the established government payment floor.
2. **P90 Threshold:**
    Calculated via analytic window functions to identify the 90th percentile pricing tier per HCPCS code. This serves as a standard benchmark in healthcare revenue cycle management for evaluating pricing dispersion and identifying statistical outliers.

---

## Technical Highlights
- **BigQuery Optimization:** Utilized Commont Table Expressions (CTEs) for clean readability and intermediate calculations.
- **Advanced Window Functions:** Deployed `PERCENTILE_CONT` with `PARTITION BY` and `QUALIFY` clauses to filter rank-ordered datasets cleanly without messy nested subqueries.
- **Defensive Data Modeling:** Applied `SAFE_DIVIDE` to prevent runtime division-by-zero errors across edge-case provider billing records.

## Usage
These queries can be executed directly within the Google Cloud BigQuery console against the public CMS provider tables. Results can be exported to CSV format for visualization in spreadsheet software or business intelligence tooks like Looker Studio.