/*markdown
# SQL JOIN 操作详解与实战指南
## INNER JOIN、LEFT JOIN、RIGHT JOIN、FULL OUTER JOIN、CROSS JOIN 详细讲解

本文档展示如何使用各种 JOIN 语句连接多个表，实现复杂的数据查询。
*/

-- ==========================================
-- 前置说明：创建测试表（如果需要）
-- ==========================================

-- 假设我们有以下表结构：
-- 1. pingan_bank_customers - 客户表
-- 2. orders - 订单表
-- 3. accounts - 账户表
-- 4. transactions - 交易表

-- 为了演示 JOIN，我们创建一些测试表
-- 注意：如果表已存在，可以删除注释符号执行

/*
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE,
    amount DECIMAL(10, 2),
    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY,
    customer_id VARCHAR(20),
    account_type VARCHAR(50),
    balance DECIMAL(15, 2),
    created_date DATE
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(10, 2),
    transaction_date DATE,
    transaction_type VARCHAR(50)
);
*/

-- ==========================================
-- 1. INNER JOIN 操作
-- ==========================================

-- INNER JOIN 返回两个表中都匹配的行
-- 只显示在两个表中都存在的数据

-- 1.1 基本 INNER JOIN - 连接客户和订单表
-- 显示有订单的客户信息
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户姓名,
    c.customer_type AS 客户类型,
    c.risk_score AS 风险评分,
    o.order_id AS 订单ID,
    o.order_date AS 订单日期,
    o.amount AS 订单金额
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
LIMIT 20;

-- 1.2 INNER JOIN 与 WHERE 子句组合
-- 显示有订单且风险评分高于50的客户
SELECT 
    c.customer_id,
    c.name,
    c.risk_score,
    o.order_id,
    o.amount,
    o.order_date
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.risk_score > 50 AND o.amount > 1000
ORDER BY c.risk_score DESC
LIMIT 20;

-- 1.3 INNER JOIN 与 ORDER BY 组合
-- 按订单金额从高到低排列
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    o.order_id AS 订单号,
    o.amount AS 金额,
    o.status AS 状态
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.amount DESC
LIMIT 15;

-- 1.4 INNER JOIN 与聚合函数
-- 统计每个客户的订单数和总金额
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    c.customer_type AS 客户类型,
    COUNT(o.order_id) AS 订单数,
    SUM(o.amount) AS 总金额,
    AVG(o.amount) AS 平均订单金额
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.customer_type
HAVING COUNT(o.order_id) > 0
ORDER BY 总金额 DESC
LIMIT 20;

-- 1.5 多表 INNER JOIN - 连接三个表
-- 显示客户、订单和交易信息
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    o.order_id AS 订单ID,
    o.amount AS 订单金额,
    a.account_id AS 账户ID,
    a.balance AS 账户余额
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN accounts a ON c.customer_id = a.customer_id
LIMIT 15;

-- 1.6 INNER JOIN 与不同的关联条件
-- 基于多个条件的 JOIN
SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    o.order_date,
    o.amount
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id 
                    AND c.customer_type = '个人'
                    AND YEAR(o.order_date) = 2023
LIMIT 15;

-- 1.7 INNER JOIN 的自连接 - 表自己和自己连接
-- 查找相同客户类型的不同客户
SELECT 
    c1.customer_id AS 客户1_ID,
    c1.name AS 客户1_名,
    c2.customer_id AS 客户2_ID,
    c2.name AS 客户2_名,
    c1.customer_type AS 客户类型
FROM pingan_bank_customers c1
INNER JOIN pingan_bank_customers c2 
    ON c1.customer_type = c2.customer_type 
    AND c1.customer_id < c2.customer_id
LIMIT 10;

-- ==========================================
-- 2. LEFT JOIN 操作
-- ==========================================

-- LEFT JOIN 返回左表的所有行，以及右表中匹配的行
-- 如果右表中没有匹配，则用 NULL 填充

-- 2.1 基本 LEFT JOIN - 显示所有客户及其订单（包括无订单的客户）
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    c.customer_type AS 客户类型,
    o.order_id AS 订单ID,
    o.amount AS 订单金额,
    o.order_date AS 订单日期
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LIMIT 20;

-- 2.2 LEFT JOIN 与 WHERE 子句 - 找出没有订单的客户
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    c.customer_type AS 客户类型,
    o.order_id AS 订单ID
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
LIMIT 20;

-- 2.3 LEFT JOIN 与聚合 - 统计所有客户的订单数（包括0个订单）
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    c.customer_type AS 客户类型,
    COUNT(o.order_id) AS 订单数,
    COALESCE(SUM(o.amount), 0) AS 总金额
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.customer_type
ORDER BY 订单数 DESC
LIMIT 20;

-- 2.4 LEFT JOIN 与 COALESCE - 处理 NULL 值
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    COALESCE(o.order_id, '无订单') AS 订单ID,
    COALESCE(o.amount, 0) AS 订单金额,
    o.status AS 订单状态
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LIMIT 20;

-- 2.5 多表 LEFT JOIN - 客户、账户、订单
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    a.account_id AS 账户ID,
    a.balance AS 账户余额,
    o.order_id AS 订单ID,
    o.amount AS 订单金额
FROM pingan_bank_customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN orders o ON c.customer_id = o.customer_id
LIMIT 20;

-- 2.6 LEFT JOIN 与 IFNULL 函数
SELECT 
    c.customer_id,
    c.name,
    c.risk_score,
    IFNULL(COUNT(o.order_id), 0) AS 订单数,
    IFNULL(SUM(o.amount), 0) AS 总金额
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.risk_score
HAVING COUNT(o.order_id) = 0 OR COUNT(o.order_id) > 5
ORDER BY 订单数 DESC
LIMIT 20;

-- 2.7 LEFT JOIN 与条件 - 找出有高额订单的客户或无订单的客户
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    COUNT(o.order_id) AS 订单总数,
    MAX(o.amount) AS 最大订单金额,
    CASE 
        WHEN o.order_id IS NULL THEN '无订单'
        WHEN MAX(o.amount) > 5000 THEN '高额消费'
        ELSE '正常'
    END AS 客户分类
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.customer_type
LIMIT 20;

-- ==========================================
-- 3. RIGHT JOIN 操作
-- ==========================================

-- RIGHT JOIN 返回右表的所有行，以及左表中匹配的行
-- 如果左表中没有匹配，则用 NULL 填充

-- 3.1 基本 RIGHT JOIN - 显示所有订单及其对应的客户信息
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    o.order_id AS 订单ID,
    o.amount AS 订单金额,
    o.order_date AS 订单日期,
    o.status AS 订单状态
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
LIMIT 20;

-- 3.2 RIGHT JOIN 与 WHERE - 找出无匹配客户的订单
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    o.order_id AS 订单ID,
    o.amount AS 订单金额
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
LIMIT 20;

-- 3.3 RIGHT JOIN 与聚合 - 统计所有订单和对应的客户信息
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    COUNT(o.order_id) AS 该客户订单数,
    SUM(o.amount) AS 订单总金额,
    AVG(o.amount) AS 平均订单金额
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY 订单总金额 DESC
LIMIT 20;

-- 3.4 RIGHT JOIN 与 COALESCE - 处理 NULL 值
SELECT 
    COALESCE(c.customer_id, '未知') AS 客户ID,
    COALESCE(c.name, '未注册客户') AS 客户名,
    o.order_id AS 订单ID,
    o.amount AS 订单金额,
    o.status AS 订单状态
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
LIMIT 20;

-- 3.5 多表 RIGHT JOIN
SELECT 
    c.customer_id,
    c.name,
    a.account_id,
    a.balance,
    o.order_id,
    o.amount
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
RIGHT JOIN accounts a ON o.customer_id = a.customer_id
LIMIT 15;

-- ==========================================
-- 4. FULL OUTER JOIN 操作
-- ==========================================

-- MySQL 不原生支持 FULL OUTER JOIN
-- 可以使用 UNION 来实现 LEFT JOIN + RIGHT JOIN

-- 4.1 使用 UNION 模拟 FULL OUTER JOIN
-- 显示所有客户和所有订单（无论是否匹配）
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    o.order_id,
    o.amount,
    '左表客户' AS 来源
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
UNION
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    o.order_id,
    o.amount,
    '右表订单' AS 来源
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
LIMIT 30;

-- 4.2 FULL OUTER JOIN 与聚合统计
-- 统计所有客户和订单的综合情况
SELECT 
    COALESCE(c.customer_id, '无客户记录') AS 客户ID,
    COALESCE(c.name, '未知') AS 客户名,
    COUNT(DISTINCT o.order_id) AS 订单数,
    SUM(o.amount) AS 总金额
FROM pingan_bank_customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY 总金额 DESC
LIMIT 20;

-- 4.3 UNION 实现 FULL OUTER JOIN - 详细版本
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    c.customer_type AS 客户类型,
    o.order_id AS 订单ID,
    o.amount AS 订单金额,
    '仅在客户表' AS 匹配状态
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    o.order_id,
    o.amount,
    '仅在订单表' AS 匹配状态
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
UNION ALL
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    o.order_id,
    o.amount,
    '两表都有' AS 匹配状态
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY 客户ID, 订单ID
LIMIT 30;

-- ==========================================
-- 5. CROSS JOIN 操作
-- ==========================================

-- CROSS JOIN 返回两个表的笛卡尔积
-- 结果集数量 = 表1的行数 × 表2的行数

-- 5.1 基本 CROSS JOIN - 创建所有可能的组合
-- 注意：这可能返回大量数据！
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    c.customer_type AS 客户类型,
    a.account_id AS 账户ID,
    a.account_type AS 账户类型
FROM pingan_bank_customers c
CROSS JOIN accounts a
LIMIT 20;

-- 5.2 CROSS JOIN 与 WHERE 条件 - 过滤结果
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    a.account_id,
    a.account_type,
    a.balance
FROM pingan_bank_customers c
CROSS JOIN accounts a
WHERE c.customer_type = '个人' AND a.account_type = '储蓄账户'
LIMIT 20;

-- 5.3 CROSS JOIN 用于生成日期范围或序列
-- 这种技巧常用于报表生成
SELECT 
    YEAR(c.open_date) AS 年份,
    MONTH(a.created_date) AS 月份,
    COUNT(c.customer_id) AS 客户数
FROM pingan_bank_customers c
CROSS JOIN accounts a
GROUP BY YEAR(c.open_date), MONTH(a.created_date)
LIMIT 20;

-- ==========================================
-- 6. NATURAL JOIN 操作
-- ==========================================

-- NATURAL JOIN 自动匹配两个表中名称相同的列
-- 使用时需谨慎，因为隐式匹配可能导致错误

-- 6.1 基本 NATURAL JOIN
-- 注意：只有当两个表中有相同列名时才能使用
SELECT 
    customer_id,
    name,
    account_id,
    balance
FROM pingan_bank_customers
NATURAL JOIN accounts
LIMIT 15;

-- ==========================================
-- 7. 使用 USING 子句的 JOIN
-- ==========================================

-- USING 是 ON 的简洁写法，用于相同列名的关联

-- 7.1 使用 USING 替代 ON
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    a.account_id,
    a.balance
FROM pingan_bank_customers c
INNER JOIN accounts a USING (customer_id)
LIMIT 15;

-- 7.2 多个 USING 条件
SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    o.amount
FROM pingan_bank_customers c
INNER JOIN orders o USING (customer_id)
LIMIT 15;

-- ==========================================
-- 8. 高级 JOIN 实战示例
-- ==========================================

-- 8.1 复杂的多表 JOIN - 客户、账户、交易综合分析
SELECT 
    c.customer_id AS 客户ID,
    c.name AS 客户名,
    c.customer_type AS 客户类型,
    c.risk_score AS 风险分,
    a.account_id AS 账户ID,
    a.account_type AS 账户类型,
    a.balance AS 账户余额,
    COUNT(t.transaction_id) AS 交易次数,
    SUM(t.amount) AS 交易总额
FROM pingan_bank_customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.name, c.customer_type, c.risk_score, a.account_id, a.account_type, a.balance
ORDER BY 交易总额 DESC
LIMIT 20;

-- 8.2 自连接 - 找出相同地区的客户
SELECT 
    c1.customer_id AS 客户1_ID,
    c1.name AS 客户1_名,
    c2.customer_id AS 客户2_ID,
    c2.name AS 客户2_名,
    c1.address AS 共同地址
FROM pingan_bank_customers c1
INNER JOIN pingan_bank_customers c2 
    ON SUBSTRING(c1.address, 1, 2) = SUBSTRING(c2.address, 1, 2)
    AND c1.customer_id < c2.customer_id
LIMIT 20;

-- 8.3 条件 JOIN - 根据客户类型选择不同的关联条件
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    CASE 
        WHEN c.customer_type = '个人' THEN a.account_type
        WHEN c.customer_type = '企业' THEN a.account_type
    END AS 账户类型
FROM pingan_bank_customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id 
                    AND c.customer_type = '个人'
LIMIT 20;

-- 8.4 子查询 JOIN - 结合子查询进行高级查询
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    high_value.订单数,
    high_value.总金额
FROM pingan_bank_customers c
LEFT JOIN (
    SELECT 
        customer_id,
        COUNT(*) AS 订单数,
        SUM(amount) AS 总金额
    FROM orders
    WHERE amount > 1000
    GROUP BY customer_id
) high_value ON c.customer_id = high_value.customer_id
ORDER BY high_value.总金额 DESC
LIMIT 20;

-- 8.5 JOIN 与 CASE 语句组合 - 客户分类分析
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    c.risk_score,
    COUNT(o.order_id) AS 订单数,
    SUM(o.amount) AS 消费总额,
    CASE 
        WHEN SUM(o.amount) IS NULL THEN '非活跃'
        WHEN SUM(o.amount) > 10000 THEN 'VIP'
        WHEN SUM(o.amount) > 5000 THEN '高价值'
        ELSE '普通'
    END AS 客户等级
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.customer_type, c.risk_score
ORDER BY 消费总额 DESC
LIMIT 20;

-- 8.6 多个 JOIN 条件 - 复杂的关联规则
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    o.order_id,
    o.amount,
    o.order_date,
    a.account_id,
    a.balance
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id 
                   AND o.status = 'completed'
LEFT JOIN accounts a ON c.customer_id = a.customer_id
                     AND a.account_type = '储蓄账户'
WHERE c.risk_score BETWEEN 40 AND 80
ORDER BY c.customer_id
LIMIT 20;

-- 8.7 JOIN 性能优化 - 使用过滤条件减少数据量
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS 订单数,
    SUM(o.amount) AS 总金额
FROM pingan_bank_customers c
INNER JOIN (
    -- 先过滤订单表，只选择2023年的订单
    SELECT customer_id, order_id, amount 
    FROM orders 
    WHERE YEAR(order_date) = 2023
) o ON c.customer_id = o.customer_id
WHERE c.customer_type IN ('个人', '企业')
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 0
ORDER BY 总金额 DESC
LIMIT 20;

-- 8.8 LEFT JOIN 与 COUNT(DISTINCT) - 避免重复计数
SELECT 
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS 订单数,
    COUNT(DISTINCT a.account_id) AS 账户数,
    SUM(o.amount) AS 订单总额
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.name
ORDER BY 订单数 DESC
LIMIT 20;

-- ==========================================
-- 9. JOIN 对比与最佳实践总结
-- ==========================================

-- 9.1 不同 JOIN 类型的对比示例
-- 同一个查询使用不同的 JOIN 方式

-- 方式1：使用 INNER JOIN（仅显示匹配数据）
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS 订单数
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY 订单数 DESC
LIMIT 10;

-- 方式2：使用 LEFT JOIN（显示所有客户，包括无订单）
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS 订单数
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY 订单数 DESC
LIMIT 10;

-- 方式3：使用 RIGHT JOIN（显示所有订单）
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS 订单数
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY 订单数 DESC
LIMIT 10;

-- 9.2 JOIN 顺序的重要性
-- 同样的 LEFT JOIN，不同的表顺序会产生不同结果

-- 查询A：以客户为主（LEFT JOIN）
SELECT COUNT(*) as 结果数
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 查询B：以订单为主（RIGHT JOIN，等同于 LEFT JOIN with table order reversed）
SELECT COUNT(*) as 结果数
FROM pingan_bank_customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- 9.3 JOIN 与聚合函数 - 常见错误
-- ❌ 错误：不能在 GROUP BY 中缺少 SELECT 中的非聚合列
-- ✅ 正确：所有 SELECT 中的非聚合列都应在 GROUP BY 中

-- 正确的做法
SELECT 
    c.customer_id,
    c.name,
    c.customer_type,
    COUNT(o.order_id) AS 订单数,
    SUM(o.amount) AS 总金额
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.customer_type
LIMIT 10;

-- 9.4 NULL 值处理
-- 使用 COALESCE 或 IFNULL 处理 NULL 值

SELECT 
    COALESCE(c.customer_id, '无') AS 客户ID,
    COALESCE(c.name, '未知') AS 客户名,
    COALESCE(o.order_id, 0) AS 订单ID,
    COALESCE(o.amount, 0) AS 订单金额
FROM pingan_bank_customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id
LIMIT 15;

-- 9.5 性能优化建议示例
-- ✅ 好的做法：先过滤，再 JOIN

-- 方法1：先过滤再JOIN（推荐，性能好）
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS 订单数
FROM pingan_bank_customers c
INNER JOIN (
    SELECT customer_id, order_id 
    FROM orders 
    WHERE YEAR(order_date) = 2023 AND status = 'completed'
) o ON c.customer_id = o.customer_id
WHERE c.risk_score < 70
GROUP BY c.customer_id, c.name
LIMIT 10;

-- 方法2：JOIN后再过滤（不推荐，性能较差）
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS 订单数
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023 
  AND o.status = 'completed'
  AND c.risk_score < 70
GROUP BY c.customer_id, c.name
LIMIT 10;

-- 9.6 使用索引优化 JOIN 性能
-- ✅ 确保 JOIN 条件中的列有索引
-- 假设已创建索引：
-- CREATE INDEX idx_customer_id ON pingan_bank_customers(customer_id);
-- CREATE INDEX idx_order_customer_id ON orders(customer_id);

-- 9.7 多表 JOIN 的列数限制
-- 当 JOIN 多个表时，注意列数和性能

SELECT 
    c.customer_id,
    c.name,
    o.order_id,
    a.account_id,
    t.transaction_id
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN accounts a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON a.account_id = t.account_id
LIMIT 10;

-- 9.8 JOIN 与 DISTINCT 的组合
-- 当有多个 INNER JOIN 可能产生重复行时

SELECT DISTINCT
    c.customer_id,
    c.name,
    a.account_id
FROM pingan_bank_customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN accounts a ON c.customer_id = a.customer_id
LIMIT 10;

-- 9.9 JOIN 查询的执行计划分析
-- 使用 EXPLAIN 查看 JOIN 的执行效率

EXPLAIN SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS 订单数
FROM pingan_bank_customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
LIMIT 10;