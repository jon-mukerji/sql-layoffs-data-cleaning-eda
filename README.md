# SQL Layoffs Data Cleaning & Exploratory Data Analysis

## Project Overview

This project demonstrates an end-to-end SQL workflow using a layoffs dataset. The project is split into two stages:

1. **Data Cleaning** – preparing raw data for analysis.
2. **Exploratory Data Analysis (EDA)** – using SQL to identify patterns and trends in layoffs.

The project was completed in **MySQL / MySQL Workbench** and focuses on practical SQL techniques commonly used in data analyst workflows.

## Project Objectives

- Preserve the original dataset by working with staging tables.
- Identify and remove duplicate records.
- Standardize inconsistent text values.
- Handle blank and NULL values.
- Convert the date field to the correct datatype.
- Explore layoffs by company, industry, country, stage, year, and month.
- Build rolling totals and rankings using SQL window functions.

## Skills Demonstrated

- SQL
- MySQL
- Data Cleaning
- Exploratory Data Analysis (EDA)
- Common Table Expressions (CTEs)
- Window Functions
- `ROW_NUMBER()`
- `DENSE_RANK()`
- Aggregate Functions
- `GROUP BY`
- `ORDER BY`
- Data Standardization
- NULL Handling
- Date Conversion
- Self Joins
- Rolling Totals

## Repository Structure

```text
sql-layoffs-data-cleaning-eda/
│
├── README.md
├── .gitignore
├── LICENSE
├── data/
│   └── README.md
└── sql/
    ├── data_cleaning_layoffs.sql
    └── exploratory_data_analysis.sql
```

## Part 1 — Data Cleaning

The cleaning workflow includes:

- Creating staging tables so the raw table remains unchanged.
- Identifying duplicates using `ROW_NUMBER()`.
- Removing duplicate rows.
- Trimming whitespace from company names.
- Standardizing industry values such as Crypto-related categories.
- Standardizing country names.
- Converting the `date` column to the `DATE` datatype.
- Converting blank industry values to `NULL`.
- Populating missing industry values by matching company records.
- Removing records where both layoff metrics are missing.
- Removing the temporary duplicate-checking column after cleaning.

See: [`sql/data_cleaning_layoffs.sql`](sql/data_cleaning_layoffs.sql)

## Part 2 — Exploratory Data Analysis

The EDA explores:

- Maximum layoffs and percentage laid off.
- Companies with 100% layoffs.
- Companies with full layoffs ordered by funding raised.
- Total layoffs by company.
- Dataset time range.
- Total layoffs by industry.
- Total layoffs by country.
- Layoffs by year.
- Layoffs by company stage.
- Monthly layoff trends.
- Rolling monthly layoffs using a window function.
- Company layoffs by year.
- Top 5 companies by layoffs for each year using `DENSE_RANK()`.

See: [`sql/exploratory_data_analysis.sql`](sql/exploratory_data_analysis.sql)

## Example SQL Techniques

### Duplicate Detection

```sql
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry,
                            total_laid_off, percentage_laid_off,
                            `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
```

### Rolling Total

```sql
WITH Rolling_total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS `Month`,
           SUM(total_laid_off) AS total_off
    FROM layoff_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `Month`
)
SELECT `Month`,
       total_off,
       SUM(total_off) OVER (ORDER BY `Month`) AS rolling_total
FROM Rolling_total;
```

### Top 5 Companies by Layoffs Per Year

```sql
WITH Company_year(company, years, total_laid_off) AS (
    SELECT company,
           YEAR(`Date`),
           SUM(total_laid_off)
    FROM layoff_staging2
    GROUP BY company, YEAR(`Date`)
),
Company_year_rank AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY years
               ORDER BY total_laid_off DESC
           ) AS Ranking
    FROM Company_year
    WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5;
```

## How to Run the Project

1. Install MySQL and MySQL Workbench.
2. Import your layoffs dataset into a table named `layoffs`.
3. Open [`sql/data_cleaning_layoffs.sql`](sql/data_cleaning_layoffs.sql) and execute the cleaning steps in order.
4. After the cleaned table `layoff_staging2` is ready, run [`sql/exploratory_data_analysis.sql`](sql/exploratory_data_analysis.sql).
5. Review the query outputs and use them as the basis for further visualization or business analysis.

## Dataset

The raw dataset is **not included in this repository by default**. Add the dataset only if its license permits redistribution. See [`data/README.md`](data/README.md) for guidance.

## Key Learning

This project strengthened my understanding of how SQL can be used for more than retrieving data. It demonstrates a practical workflow for cleaning, transforming, validating, and analyzing a real-world dataset before producing analytical insights.

## Next Steps

- Build a Power BI dashboard using the cleaned dataset.
- Reproduce selected analysis in Python/Pandas.
- Add KPI cards and trend visualizations.
- Create a short findings summary with business-focused insights.

## Author

Built as part of my data analytics learning and portfolio development.
