# 零售订单数据管道 — Kaggle → Pandas → MySQL → 可视化

🌐 Languages: [English](README_EN.md) | 🇨🇳 中文版本

---

## 📌 项目简介

本项目展示了一个完整的数据处理与分析流程，包括：

1. **从 Kaggle 下载数据集**
2. **解压并加载 CSV 文件**
3. **使用 pandas 清洗数据**
4. **执行特征工程（折扣、销售额、利润等）**
5. **将数据写入 MySQL 数据库**
6. **在 MySQL Shell DB Notebook 中进行可视化**
7. **编写 SQL 做业务分析**

该项目适用于：

- 数据分析学习者  
- Pandas + MySQL ETL/Pipeline 开发者  
- SQL 初学者  
- MySQL Shell + VS Code 用户  

---

## 🧰 环境要求

### 软件
- Python 3.8+
- MySQL Server 8+
- MySQL Shell（支持 DB Notebook）
- VS Code（可选）

### Python 依赖安装

```bash
pip install pandas sqlalchemy pymysql kaggle
```

### 克隆仓库
```bash
git clone https://github.com/Luxflamy/-Data-Analytics-Proj.-PinAnBank.git
cd -Data-Analytics-Proj.-PinAnBank
```

### Step 3：下载与清洗数据（Kaggle → pandas）并将 DataFrame 写入 MySQL

运行Order Data Analysis.ipynb

### Step 4: 在 MySQL Shell DB Notebook 中可视化


🎉 完成！

如需增强版本（Plotly、Dash、完整 EDA 模板、自动化 pipeline），请联系我。