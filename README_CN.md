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

### 客户数据（Customer）
🎉 完成！

如需增强版本（Plotly、Dash、完整 EDA 模板、自动化 pipeline），请联系我。


好的，这是上面表格的中文版本，并对说明列进行了相应的本地化优化。

| 字段名         | 说明与用途                                                                                                 |
| :------------- | :------------------------------------------------------------------------------------------------------- |
| customer_id   | **客户的唯一标识符**。作为主键，用于在银行所有系统中关联和识别客户数据。                                       |
| name          | **客户的法定名称**（个人或企业）。用于身份验证和官方文件。                                                       |
| id_type       | **提供的身份证件类型**（例如：身份证、护照、营业执照）。                                                         |
| id_number     | **官方身份证件的号码**。用于客户身份识别（KYC）和反欺诈流程。                                                    |
| mobile        | **主要联系电话**。用于发送通知、双重认证和客户服务。                                                             |
| address       | **注册的邮寄地址**。用于账单寄送、法律文书送达和地址验证。                                                       |
| open_date     | **客户账户正式开设的日期**。对于计算客户存续时间和忠诚度非常重要。                                                 |
| customer_type | **客户类型分类**，是'个人'还是'企业'实体。这决定了他们可以使用的产品和服务。                                        |
| risk_score    | **代表客户风险状况的数值评分**。基于交易、行为和其他因素计算得出，用于合规和信贷决策。                                 |