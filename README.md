---

# 📄 README.md — Retail Orders Data Pipeline

🌐 **[English Version](#english-version--🇺🇸) | [中文版本](#中文版本--🇨🇳)**

---

# 🇨🇳 中文版本

# 📌 项目简介

本项目展示了一个完整的数据处理与分析流程，包括：

1. **从 Kaggle 下载数据集**
2. **解压与加载数据**
3. **使用 pandas 进行数据清洗**
4. **特征工程（折扣、销售价、利润）**
5. **将清洗后的数据写入 MySQL 数据库**
6. **在 MySQL Shell DB Notebook 中进行可视化分析**
7. **使用 SQL 进行业务分析**

本项目适用于：

* 数据分析学习者
* Pandas + MySQL 数据 Pipeline 构建者
* SQL 初学者与练习者
* 使用 VS Code + MySQL Shell 的用户

---

# 🧰 环境要求

## 软件

* Python 3.8+
* MySQL Server 8+
* MySQL Shell（支持 DB Notebook 可视化）
* VS Code（可选）
* Kaggle CLI（用于数据下载）

## Python 依赖

```bash
pip install pandas sqlalchemy pymysql kaggle
```

---

# 🚀 如何运行本项目

## ✔️ Step 1：克隆项目

```bash
git clone <your-repo-url>
cd retail-orders-mysql-pipeline
```

## ✔️ Step 2：安装依赖

```bash
pip install -r requirements.txt
```

## ✔️ Step 3：从 Kaggle 下载并加载数据

示例：

```python
!kaggle datasets download ankitbansal06/retail-orders -f orders.csv
```


## ✔️ Step 4：使用 Pandas 进行数据清洗

包括：

* 处理缺失值
* 重命名列
* 转换日期格式
* 创建新列（折扣、销售价、利润）
* 删除不需要的中间列

## ✔️ Step 5：写入 MySQL 数据库


## ✔️ Step 6：在 MySQL Shell DB Notebook 中进行


# 🎉 完成！

---

# 🇺🇸 English Version

# 📌 Project Overview

This project demonstrates a complete end-to-end data pipeline including:

1. **Downloading dataset from Kaggle**
2. **Extracting and loading CSV data**
3. **Cleaning data using pandas**
4. **Feature engineering (discount, sale price, profit)**
5. **Loading processed data into a MySQL database**
6. **Visualizing results in MySQL Shell DB Notebook**
7. **Running SQL queries for business analysis**

This project is ideal for:

* Data analysis learners
* Pandas + MySQL pipeline builders
* SQL beginners
* VS Code + MySQL Shell users

---

# 🧰 Requirements

## Software

* Python 3.8+
* MySQL Server 8+
* MySQL Shell (DB Notebook support)
* VS Code (optional)
* Kaggle CLI

## Python dependencies

```bash
pip install pandas sqlalchemy pymysql kaggle
```

---

# 🚀 How to Run This Project

## ✔️ Step 1: Clone repository

```bash
git clone https://github.com/Luxflamy/-Data-Analytics-Proj.-PinAnBank.git
```

## ✔️ Step 2: Install dependencies

## ✔️ Step 3: Download data from Kaggle

```python
!kaggle datasets download ankitbansal06/retail-orders -f orders.csv
```

## ✔️ Step 4: Clean data with pandas

## ✔️ Step 5: Load data into MySQL

## ✔️ Step 6: Visualization in MySQL Shell DB Notebook

# 🎉 Done!

A complete workflow from **Kaggle → pandas → MySQL → Visualization** is now fully implemented.
