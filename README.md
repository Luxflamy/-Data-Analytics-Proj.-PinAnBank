
# Retail Orders Data Pipeline — Kaggle → Pandas → MySQL → Visualization

🌐 Languages: 🇨🇳 [中文版本](README_CN.md) | English

---

## 📌 Project Overview

This project demonstrates a complete end-to-end data pipeline:

1. **Download dataset from Kaggle**
2. **Extract and load the CSV file**
3. **Clean the data using pandas**
4. **Apply feature engineering (discount, sales price, profit)**
5. **Load cleaned data into a MySQL database**
6. **Perform data visualization inside MySQL Shell DB Notebook**
7. **Run business-level analysis using SQL**

This project is ideal for:

- Data analysis learners  
- Pandas + MySQL ETL / pipeline developers  
- SQL beginners  
- Users of MySQL Shell + VS Code  

---

## 🧰 Requirements

### Software
- Python 3.8+
- MySQL Server 8+
- MySQL Shell (DB Notebook supported)
- VS Code (optional)

### Python Dependencies

```bash
pip install pandas sqlalchemy pymysql kaggle
```

🚀 How to Run the Project

✔️ Step 1: Clone the repository

```bash
git clone https://github.com/Luxflamy/-Data-Analytics-Proj.-PinAnBank.git
```

✔️ Step 2: Prepare Python environment


✔️ Step 3: Download & clean data (Kaggle → pandas) and Load DataFrame into MySQL

run Order Data Analysis.ipynb

✔️ Step 4: Load DataFrame into MySQL

✔️ Step 5: Visualize in MySQL Shell DB Notebook (Python cell)

🎉 Done!
If you need an extended version (Plotly dashboard, full EDA notebook, automated pipeline), feel free to ask!


### Data Head（Customer）

| Field          | Description and Purpose                                                                                                |
| :------------- | :--------------------------------------------------------------------------------------------------------------------- |
| customer_id   | **Unique identifier** for each customer. Used as the primary key to link customer data across all banking systems.     |
| name          | **Legal name** of the customer (individual or business). Essential for identity verification and official documentation. |
| id_type       | **Type of identification document** provided (e.g., National ID, Passport, Business License).                          |
| id_number     | **Number of the official identification document**. Used for KYC (Know Your Customer) and anti-fraud processes.        |
| mobile        | **Primary contact number**. Used for notifications, two-factor authentication, and customer service.                   |
| address       | **Registered mailing address**. Used for statement delivery, legal correspondence, and address verification.           |
| open_date     | **The date the customer's account was officially opened**. Important for calculating customer longevity and loyalty.   |
| customer_type | **Classification of the customer** as an 'Individual' or 'Corporate' entity. Determines the products and services available to them. |
| risk_score    | **A numerical rating representing the customer's risk profile**. Calculated based on transactions, behavior, and other factors for compliance and credit decisions. |
