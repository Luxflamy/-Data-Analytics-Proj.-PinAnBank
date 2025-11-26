/*markdown
# SQL 查询条件与别名操作指南
## LIKE、通配符、IN、BETWEEN、ALIASES 详解与示例

本文档展示如何使用 WHERE 条件语句和别名来优化 SQL 查询。
*/

-- ==========================================
-- 1. LIKE 操作与通配符
-- ==========================================

-- LIKE 用于模糊查询字符串
-- 通配符：% 表示任意个字符，_ 表示单个字符

-- 1.1 使用 % 通配符 - 搜索所有包含"北京"的地址
SELECT 
    customer_id,
    name,
    address
FROM pingan_bank_customers
WHERE address LIKE '%北京%'
LIMIT 10;

-- 1.2 使用 % 通配符 - 搜索所有以"重庆"开头的地址
SELECT 
    customer_id,
    name,
    address
FROM pingan_bank_customers
WHERE address LIKE '重庆%'
LIMIT 10;

-- 1.3 使用 % 通配符 - 搜索所有以"市"结尾的地址
SELECT 
    customer_id,
    name,
    address
FROM pingan_bank_customers
WHERE address LIKE '%市'
LIMIT 10;

-- 1.4 使用 _ 通配符 - 搜索所有两字名称的客户
-- _ 代表单个字符，所以 __ 表示恰好两个字符
SELECT 
    customer_id,
    name,
    customer_type
FROM pingan_bank_customers
WHERE name LIKE '__'
LIMIT 10;

-- 1.5 使用 _ 和 % 组合 - 搜索名字以"张"开头的客户（不限长度）
SELECT 
    customer_id,
    name,
    customer_type
FROM pingan_bank_customers
WHERE name LIKE '张%'
LIMIT 10;

-- 1.6 不区分大小写的 LIKE 查询
-- MySQL 默认 LIKE 不区分大小写
SELECT 
    customer_id,
    name,
    id_type
FROM pingan_bank_customers
WHERE id_type LIKE 'id%'
LIMIT 10;

-- 1.7 区分大小写的 LIKE 查询（使用 BINARY）
SELECT 
    customer_id,
    name,
    id_type
FROM pingan_bank_customers
WHERE id_type LIKE BINARY '身份证'
LIMIT 10;

-- 1.8 使用 NOT LIKE - 搜索地址中不包含"号"的客户
SELECT 
    customer_id,
    name,
    address
FROM pingan_bank_customers
WHERE address NOT LIKE '%号%'
LIMIT 10;

-- 1.9 复杂的 LIKE 组合 - 搜索包含"市"但不包含"西"的地址
SELECT 
    customer_id,
    name,
    address
FROM pingan_bank_customers
WHERE address LIKE '%市%' AND address NOT LIKE '%西%'
LIMIT 10;

-- ==========================================
-- 2. IN 操作符
-- ==========================================

-- IN 用于在 WHERE 子句中指定多个值
-- 语法：WHERE column IN (value1, value2, value3...)

-- 2.1 基本 IN 操作 - 查询指定年份开户的客户
SELECT 
    customer_id,
    name,
    year_opened,
    customer_type
FROM pingan_bank_customers
WHERE year_opened IN (2021, 2022, 2023)
ORDER BY year_opened DESC
LIMIT 15;

-- 2.2 IN 操作与字符串 - 查询特定证件类型的客户
SELECT 
    customer_id,
    name,
    id_type,
    risk_score
FROM pingan_bank_customers
WHERE id_type IN ('身份证', '护照', '营业执照')
LIMIT 15;

-- 2.3 IN 操作与数值范围 - 查询特定风险评分的客户
SELECT 
    customer_id,
    name,
    risk_score,
    customer_type
FROM pingan_bank_customers
WHERE risk_score IN (30, 45, 60, 75, 90)
ORDER BY risk_score DESC
LIMIT 15;

-- 2.4 使用 NOT IN - 查询不是身份证的客户
SELECT 
    customer_id,
    name,
    id_type,
    COUNT(*) as 记录数
FROM pingan_bank_customers
WHERE id_type NOT IN ('身份证')
GROUP BY id_type
LIMIT 15;

-- 2.5 IN 操作与 OR 的对比
-- 使用 IN 的方式（推荐）
SELECT 
    customer_id,
    name,
    customer_type
FROM pingan_bank_customers
WHERE customer_type IN ('个人', '企业')
LIMIT 10;

-- 2.6 IN 操作与子查询 - 查询年份在特定列表中的客户
SELECT 
    customer_id,
    name,
    year_opened,
    risk_score
FROM pingan_bank_customers
WHERE year_opened IN (
    SELECT DISTINCT year_opened 
    FROM pingan_bank_customers 
    WHERE risk_score > 70
)
LIMIT 15;

-- 2.7 IN 操作与多个条件的组合
-- 查询特定客户类型且特定证件类型的客户
SELECT 
    customer_id,
    name,
    customer_type,
    id_type,
    risk_score
FROM pingan_bank_customers
WHERE customer_type IN ('个人', '企业')
  AND id_type IN ('身份证', '营业执照')
  AND risk_score >= 50
LIMIT 15;

-- 2.8 IN 操作的性能优化 - 使用 FIND_IN_SET
-- 适用于逗号分隔的字段值
SELECT 
    customer_id,
    name,
    customer_type
FROM pingan_bank_customers
WHERE FIND_IN_SET(customer_type, '个人,企业')
LIMIT 15;

-- ==========================================
-- 3. BETWEEN 操作符
-- ==========================================

-- BETWEEN 用于在 WHERE 子句中指定范围
-- 语法：WHERE column BETWEEN value1 AND value2
-- 包含边界值（value1 和 value2 都被包含）

-- 3.1 基本 BETWEEN 操作 - 查询风险评分在指定范围内的客户
SELECT 
    customer_id,
    name,
    risk_score,
    customer_type
FROM pingan_bank_customers
WHERE risk_score BETWEEN 40 AND 70
ORDER BY risk_score DESC
LIMIT 15;

-- 3.2 BETWEEN 与日期 - 查询在特定日期范围内开户的客户
SELECT 
    customer_id,
    name,
    open_date,
    risk_score
FROM pingan_bank_customers
WHERE open_date BETWEEN '2021-01-01' AND '2022-12-31'
ORDER BY open_date DESC
LIMIT 15;

-- 3.3 BETWEEN 与 NOT - 查询风险评分不在指定范围的客户
SELECT 
    customer_id,
    name,
    risk_score,
    customer_type
FROM pingan_bank_customers
WHERE risk_score NOT BETWEEN 40 AND 70
ORDER BY risk_score DESC
LIMIT 15;

-- 3.4 多个 BETWEEN 条件组合 - 查询在特定日期和风险范围内的客户
SELECT 
    customer_id,
    name,
    open_date,
    risk_score,
    customer_type
FROM pingan_bank_customers
WHERE open_date BETWEEN '2020-01-01' AND '2023-12-31'
  AND risk_score BETWEEN 50 AND 80
ORDER BY open_date DESC
LIMIT 15;

-- 3.5 BETWEEN 与字符串 - 查询名字在字母范围内的客户
-- 例如：查询名字以"A"到"Z"开头的客户（按字母顺序）
SELECT 
    customer_id,
    name,
    customer_type
FROM pingan_bank_customers
WHERE name BETWEEN '王' AND '赵'
LIMIT 15;

-- 3.6 BETWEEN 与计算字段 - 查询年份范围内的客户
SELECT 
    customer_id,
    name,
    year_opened,
    risk_score,
    YEAR(open_date) as 开户年度
FROM pingan_bank_customers
WHERE year_opened BETWEEN 2020 AND 2022
ORDER BY year_opened DESC
LIMIT 15;

-- 3.7 BETWEEN 与 IN 的组合 - 查询特定年份且风险在范围内的客户
SELECT 
    customer_id,
    name,
    year_opened,
    risk_score
FROM pingan_bank_customers
WHERE year_opened IN (2021, 2022, 2023)
  AND risk_score BETWEEN 30 AND 60
ORDER BY year_opened, risk_score DESC
LIMIT 15;

-- 3.8 BETWEEN 性能对比 - 与 >= AND <= 的对比
-- 这两种写法效果相同，BETWEEN 更简洁
-- 方法1：使用 BETWEEN（推荐）
SELECT COUNT(*) as 方法1_BETWEEN FROM pingan_bank_customers
WHERE risk_score BETWEEN 40 AND 70;

-- 方法2：使用 >= AND <=
SELECT COUNT(*) as 方法2_比较运算符 FROM pingan_bank_customers
WHERE risk_score >= 40 AND risk_score <= 70;

-- ==========================================
-- 4. ALIASES（别名）操作
-- ==========================================

-- 别名用于为列、表、计算字段等设置更易读的名称
-- 语法：SELECT column AS alias_name FROM table_name
-- 或：SELECT column alias_name FROM table_name （AS 可省略）

-- 4.1 列别名 - 简化列名显示
SELECT 
    customer_id AS 客户ID,
    name AS 姓名,
    customer_type AS 客户类型,
    risk_score AS 风险评分
FROM pingan_bank_customers
LIMIT 10;

-- 4.2 中文别名与英文别名混合
SELECT 
    customer_id as cust_id,
    name as customer_name,
    id_type as 证件类型,
    risk_score as risk_level
FROM pingan_bank_customers
LIMIT 10;

-- 4.3 计算字段别名 - 对计算结果使用别名
SELECT 
    customer_id,
    name,
    risk_score,
    risk_score * 1.1 AS 调整后风险分,
    YEAR(open_date) AS 开户年份
FROM pingan_bank_customers
LIMIT 10;

-- 4.4 函数结果别名 - 对聚合函数使用别名
SELECT 
    COUNT(*) AS 总客户数,
    COUNT(DISTINCT customer_type) AS 客户类型数,
    AVG(risk_score) AS 平均风险分,
    MIN(risk_score) AS 最低风险分,
    MAX(risk_score) AS 最高风险分
FROM pingan_bank_customers;

-- 4.5 条件语句别名 - 对 CASE 语句使用别名
SELECT 
    customer_id,
    name,
    risk_score,
    CASE 
        WHEN risk_score < 30 THEN '低风险'
        WHEN risk_score < 70 THEN '中风险'
        ELSE '高风险'
    END AS 风险等级,
    CASE 
        WHEN customer_type = '个人' THEN 'Individual'
        WHEN customer_type = '企业' THEN 'Enterprise'
        ELSE 'Unknown'
    END AS customer_category
FROM pingan_bank_customers
LIMIT 10;

-- 4.6 表别名 - 为表设置别名（在 JOIN 或复杂查询中非常有用）
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    c.risk_score,
    c.open_date
FROM pingan_bank_customers AS c
WHERE c.risk_score > 50
LIMIT 10;

-- 4.7 表别名简写 - AS 关键字可以省略
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    c.risk_score
FROM pingan_bank_customers c
LIMIT 10;

-- 4.8 别名在 WHERE 子句中的限制
-- ⚠️ 注意：不能在 WHERE 子句中使用列别名
-- 以下查询会报错：
-- SELECT risk_score AS 风险分 FROM pingan_bank_customers WHERE 风险分 > 50;

-- 4.9 别名在 ORDER BY 中的使用 - 可以使用列别名
SELECT 
    customer_id,
    name,
    risk_score AS 风险分
FROM pingan_bank_customers
ORDER BY 风险分 DESC
LIMIT 10;

-- 4.10 别名在 GROUP BY 中的使用 - 可以使用列别名
SELECT 
    customer_type AS 客户类型,
    COUNT(*) AS 客户数,
    AVG(risk_score) AS 平均风险分
FROM pingan_bank_customers
GROUP BY 客户类型
ORDER BY 客户数 DESC;

-- 4.11 多级别名组合 - 表别名 + 列别名
SELECT 
    c.customer_id AS id,
    c.name AS 姓名,
    c.customer_type AS 类型,
    c.risk_score AS 风险,
    YEAR(c.open_date) AS 年份
FROM pingan_bank_customers AS c
WHERE c.year_opened >= 2020
ORDER BY c.risk_score DESC
LIMIT 10;

-- 4.12 别名与 CONCAT 函数组合 - 创建复合字段
SELECT 
    customer_id,
    CONCAT(name, '(', customer_type, ')') AS 客户信息,
    risk_score AS 风险分,
    CONCAT(YEAR(open_date), '年') AS 开户时间
FROM pingan_bank_customers
LIMIT 10;

-- 4.13 子查询中的别名 - 子查询结果也需要别名
SELECT 
    client.customer_id,
    client.name,
    client.avg_risk
FROM (
    SELECT 
        customer_id,
        name,
        AVG(risk_score) AS avg_risk
    FROM pingan_bank_customers
    GROUP BY customer_id, name
) AS client
WHERE client.avg_risk > 60
LIMIT 10;

-- 4.14 长别名与易读性 - 选择有意义的别名
SELECT 
    customer_id AS 平安银行客户ID,
    name AS 客户真实姓名,
    customer_type AS 客户业务类型,
    risk_score AS 风险管理评分,
    open_date AS 首次开户日期,
    year_opened AS 开户年份
FROM pingan_bank_customers
LIMIT 10;

-- 4.15 空格别名 - 包含空格的别名需要用反引号或双引号
SELECT 
    customer_id AS `客户 ID`,
    name AS `客户 名称`,
    risk_score AS `风险 评分`
FROM pingan_bank_customers
LIMIT 10;

-- ==========================================
-- 5. 综合实战示例 - 结合多个条件
-- ==========================================

-- 5.1 复杂查询示例1：结合 LIKE + IN + BETWEEN + ALIASES
-- 查询：北京和上海地区，特定证件类型，风险分在中等水平的客户
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户姓名,
    c.address AS 客户地址,
    c.id_type AS 证件类型,
    c.risk_score AS 风险评分,
    CASE 
        WHEN c.risk_score BETWEEN 30 AND 50 THEN '低风险'
        WHEN c.risk_score BETWEEN 51 AND 70 THEN '中风险'
        ELSE '高风险'
    END AS 风险等级,
    YEAR(c.open_date) AS 开户年份
FROM pingan_bank_customers c
WHERE c.address LIKE '%北京%' OR c.address LIKE '%上海%'
  AND c.id_type IN ('身份证', '营业执照')
  AND c.risk_score BETWEEN 40 AND 80
ORDER BY c.risk_score DESC
LIMIT 20;

-- 5.2 复杂查询示例2：多条件组合 + 聚合 + 别名
-- 统计北上广深地区，特定客户类型，特定风险分的客户信息
SELECT 
    CASE 
        WHEN address LIKE '%北京%' THEN '北京'
        WHEN address LIKE '%上海%' THEN '上海'
        WHEN address LIKE '%广州%' THEN '广州'
        WHEN address LIKE '%深圳%' THEN '深圳'
        ELSE '其他'
    END AS 城市,
    customer_type AS 客户类型,
    COUNT(*) AS 客户数,
    ROUND(AVG(risk_score), 2) AS 平均风险分,
    MIN(risk_score) AS 最低风险分,
    MAX(risk_score) AS 最高风险分
FROM pingan_bank_customers
WHERE (address LIKE '%北京%' OR address LIKE '%上海%' OR address LIKE '%广州%' OR address LIKE '%深圳%')
  AND customer_type IN ('个人', '企业')
  AND risk_score BETWEEN 20 AND 90
GROUP BY 城市, 客户类型
ORDER BY 城市, 平均风险分 DESC;

-- 5.3 复杂查询示例3：LIKE + NOT LIKE + BETWEEN + 表别名
-- 查询：地址包含"市"但不包含"号"，且在特定时间范围内开户的客户
SELECT 
    c.customer_id,
    c.name,
    c.address AS 详细地址,
    c.open_date AS 开户日期,
    c.year_opened AS 开户年份,
    c.risk_score AS 风险分,
    CONCAT(c.name, '(', c.customer_type, ')') AS 客户信息
FROM pingan_bank_customers c
WHERE c.address LIKE '%市%' 
  AND c.address NOT LIKE '%号%'
  AND c.open_date BETWEEN '2020-01-01' AND '2023-12-31'
  AND c.risk_score NOT BETWEEN 70 AND 100
ORDER BY c.open_date DESC
LIMIT 15;

-- 5.4 复杂查询示例4：子查询 + IN + ALIASES
-- 查询：风险分在高风险客户平均值以上，且证件类型在特定列表内的客户
SELECT 
    detail.客户ID,
    detail.客户姓名,
    detail.证件类型,
    detail.风险评分,
    detail.风险等级
FROM (
    SELECT 
        customer_id AS 客户ID,
        name AS 客户姓名,
        id_type AS 证件类型,
        risk_score AS 风险评分,
        CASE 
            WHEN risk_score < 30 THEN 'A级(超低)'
            WHEN risk_score < 50 THEN 'B级(低)'
            WHEN risk_score < 70 THEN 'C级(中)'
            WHEN risk_score < 85 THEN 'D级(高)'
            ELSE 'E级(极高)'
        END AS 风险等级
    FROM pingan_bank_customers
    WHERE id_type IN ('身份证', '护照', '营业执照')
) detail
WHERE detail.风险评分 > (
    SELECT AVG(risk_score) FROM pingan_bank_customers
)
ORDER BY detail.风险评分 DESC
LIMIT 20;

-- 5.5 复杂查询示例5：综合统计 + LIKE + BETWEEN + GROUP BY
-- 统计：各年份、各客户类型、各风险等级的客户分布
SELECT 
    year_opened AS 开户年份,
    customer_type AS 客户类型,
    CASE 
        WHEN risk_score < 40 THEN '低风险(0-39)'
        WHEN risk_score < 60 THEN '中风险(40-59)'
        WHEN risk_score < 80 THEN '中高风险(60-79)'
        ELSE '高风险(80+)'
    END AS 风险等级,
    COUNT(*) AS 客户数,
    ROUND(AVG(risk_score), 2) AS 平均风险分
FROM pingan_bank_customers
WHERE year_opened IN (2020, 2021, 2022, 2023)
  AND risk_score BETWEEN 20 AND 100
GROUP BY year_opened, customer_type, 风险等级
ORDER BY year_opened DESC, 客户类型, 风险等级;