# 🥪 The Awful Shop

A test dbt project for a made-up café that sells jaffles 🥪 and drinks ☕. It builds dimensions, facts, reports and metrics from the café's source data, and runs locally on DuckDB.

The project is based on dbt Labs' [Jaffle Shop](https://github.com/dbt-labs/jaffle-shop), with extended source data: stores and regions, products with tags and price history, customer changes, a marketing CRM, payments, daily inventory counts, store metrics and a finance sales sheet.

## 🗂️ What's inside

| Folder | What it holds |
|---|---|
| 🌱 `seeds/jaffle-data` | Source data: 16 small CSV files |
| 🧹 `models/staging` | One `stg_` model per source table |
| 🔧 `models/intermediate` | Intermediate models |
| ⭐ `models/marts` | Dimensions, facts, reports, metrics and exposures |
| 📸 `snapshots` | Customer history |
| ✅ `data-tests` | Checks across models |

## 🚀 Run it locally

You need [dbt](https://docs.getdbt.com/) v2 with DuckDB, no warehouse required. 🦆

```bash
dbt deps
dbt build --vars '{"load_source_data": true}'
```

This loads the seed data into a local `jaffle_shop.duckdb` file, builds every model and runs every test.

## 🙏 Credits

Based on [dbt-labs/jaffle-shop](https://github.com/dbt-labs/jaffle-shop). The original data comes from the [Jaffle Shop generator](https://github.com/dbt-labs/jaffle-shop-generator).
