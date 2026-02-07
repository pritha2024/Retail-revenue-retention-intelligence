# Online Retail: Revenue, RFM Segmentation & Churn-Risk Proxy (Python • SQL • Power BI)

End-to-end, industry-style analytics project on **Online Retail transactional data** to understand **revenue drivers**, **customer purchasing behavior**, and **retention opportunities**.  
Deliverables include: cleaned datasets, an SQLite SQL query pack, a churn-risk proxy model, and a Power BI dashboard.

---

## 📌 Business Problem
A retail business wants to answer:

- **Where does revenue come from?** (country, seasonality, products, top customers)
- **How healthy is retention?** (repeat vs one-time buyers)
- **Which customers are most valuable and who is at risk?** (RFM segmentation)
- **Can we predict churn risk?** (proxy churn label + ML model)

> **Industry insight:** A meaningful share of revenue can be **anonymous** (missing `CustomerID`).  
> Anonymous transactions are kept for **transaction-level revenue analysis**, but excluded for **customer-level modeling** (RFM/churn).

---

## 🗂️ Dataset
- Dataset: Online Retail (Kaggle)
- **Data type:** invoice-line transaction data (InvoiceNo, InvoiceDate, StockCode/Description, Quantity, UnitPrice, CustomerID, Country)
- **Raw file:** `data/raw/OnlineRetail.csv` 


---


## ✅ Key Cleaning Rules (Important)
### Transaction-level analysis (revenue, products, countries)
Keep **valid sales lines**:
- `InvoiceNo` not starting with `"C"` (remove cancellations/returns)
- `Quantity > 0`
- `UnitPrice > 0`

### Customer-level modeling (RFM + churn proxy)
Use **identified + valid sales** only:
- `CustomerID` not null
- `InvoiceNo` not starting with `"C"`
- `Quantity > 0`
- `UnitPrice > 0`

---

## 📒 Notebooks
- `notebooks/01_data_audit.ipynb`  
  Data checks: missingness, duplicates, cancellations, negative qty/price flags.

- `notebooks/02_feature_engineering.ipynb`  
  Cleaning + RFM feature engineering + customer segmentation.

- `notebooks/03_modeling_churn_proxy.ipynb`  
  Churn-risk proxy labeling (60-day window) + model training (RandomForest, XGBoost).

---

## 🧾 Outputs
- `data/processed/transactions_cleaned.csv`  
  Cleaned transaction-level dataset for SQL + Power BI.

- `data/processed/customer_rfm.csv`  
  Customer-level RFM dataset + segment labels.

- `sql/customer_behavior_sql_queries.sql`  
  Query pack: revenue by country, monthly trend, top customers, repeat rate, top products, AOV by country, segment summary.

- `reports/OnlineRetail_Revenue_Analysis_Summary.pdf`  
  Business-ready findings + recommendations.

- `reports/OnlineRetail_Business_Problem.pdf`  
  One-page problem framing.

- `powerbi/Revenue Analysis.pbix` (or your PBIX file)  
  Final dashboard.

---

## 🧠 What the Model Predicts (Churn Proxy)
This dataset has **no explicit churn label**, so churn is defined as:

> **Churn = customer makes no purchase in the next N days (default N = 60) after a cutoff date T.**

Steps:
1. Split transactions into **history window** (≤ T) and **future window** (T, T+N]
2. Build RFM features **only from history** (avoid leakage)
3. Label churn = 1 if customer **does not appear** in the future window
4. Train models to output **churn probability** per customer

---

## 🧮 SQL Business Questions Answered
- Revenue by country (who drives revenue?)
- Monthly revenue trend (seasonality & peak months)
- Top customers by revenue (concentration risk)
- Repeat vs one-time customers (retention)
- Top products by revenue (hero products)
- AOV by country (high-volume vs high-ticket markets)
- Segment distribution (Champions / Loyal / Need Attention / At Risk)

---

## 📊 Power BI Dashboard (Recommended Layout)
**Top KPI cards**
- Total Revenue
- Total Orders (distinct InvoiceNo)
- Identified Customers (distinct CustomerID)
- Anonymous Revenue % (revenue where CustomerID is blank)
- Average Transaction Value (Revenue / Orders)

**Core visuals**
- Revenue by Month (bar/line)
- Revenue by Country (bar)
- Top Products by Revenue (bar)
- Repeat vs One-time share (donut)
- Segment distribution + average R/F/M (table)

**Slicers**
- InvoiceDate (Between)
- Country (dropdown)
- Customer Type (Identified vs Anonymous)

---

## 🛠️ How to Run
### 1) Clone & install
```bash
git clone <your-repo-url>
cd <your-repo-folder>
pip install -r requirements.txt
```

If you don’t have `requirements.txt`, install:
```bash
pip install pandas numpy matplotlib seaborn scikit-learn xgboost
```

### 2) Run notebooks (in order)
Open and run:
1. `01_data_audit.ipynb`
2. `02_feature_engineering.ipynb`
3. `03_modeling_churn_proxy.ipynb`

### 3) SQL (SQLite)
- Open `identifier.sqlite` (or your `.sqlite` database)
- Import `transactions_cleaned.csv` and `customer_rfm.csv`
- Run queries from: `sql/customer_behavior_sql_queries.sql`

### 4) Power BI
- Open `powerbi/Revenue Analysis.pbix`
- Refresh data sources if needed
- Export dashboard screenshots + include in report

---

## 📁 Suggested Repo Structure
```
.
├── data/
│   ├── raw/
│   └── processed/
├── notebooks/
├── sql/
├── powerbi/
├── reports/
└── README.md
```

---

## 🔍 Key Business Takeaways (example phrasing)
- **UK is high-volume, lower basket size:** highest total revenue, but lower AOV vs many international markets.
- **Seasonality is strong:** revenue peaks toward **Oct–Dec**, with a high point in **November**.
- **Revenue concentration exists:** a small set of customers contribute disproportionately.
- **Retention opportunity:** a meaningful share of customers are **one-time buyers**.
- **Actionable segmentation:** Champions/Loyal customers should be protected; At-Risk customers need win-back campaigns.
- **Identity capture matters:** anonymous revenue limits personalization and retention strategy.

---

## 📜 License
MIT 

---

## 👩🏻‍💻 Author
**Pritha**  
Portfolio project: Python • SQL (SQLite) • Power BI • RFM • Churn-risk proxy
