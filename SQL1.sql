-- 1. 使用数据库
USE mydb;



-- 2. 查看表结构
DESCRIBE pingan_bank_customers;

-- 4. 预览前 5 行数据
SELECT * FROM pingan_bank_customers LIMIT 1;

-- 3. 查看数据摘要统计
-- 统计客户总数、风险评分范围等基本信息
SELECT 
    COUNT(*) as 总客户数,
    COUNT(DISTINCT customer_id) as 唯一客户数,
    MIN(risk_score) as 最低风险分,
    MAX(risk_score) as 最高风险分,
    ROUND(AVG(risk_score), 2) as 平均风险分,
    COUNT(DISTINCT year_opened) as 开户年份数
FROM pingan_bank_customers;

-- 4. 风险评分分级分析
-- 将客户按风险分数分为：低风险(0-30)、中风险(31-70)、高风险(71-100)
SELECT 
    CASE 
        WHEN risk_score <= 30 THEN '低风险'
        WHEN risk_score <= 70 THEN '中风险'
        ELSE '高风险'
    END as 风险等级,
    COUNT(*) as 客户数量,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM pingan_bank_customers), 2) as 占比百分比
FROM pingan_bank_customers
GROUP BY 风险等级
ORDER BY 风险等级;

-- 5. 客户类型分布分析
-- 分析个人客户 vs 企业客户的分布情况
SELECT 
    customer_type as 客户类型,
    COUNT(*) as 客户数量,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM pingan_bank_customers), 2) as 占比百分比,
    ROUND(AVG(risk_score), 2) as 平均风险分
FROM pingan_bank_customers
GROUP BY customer_type
ORDER BY 客户数量 DESC;

-- 6. 开户年份趋势分析
-- 按年份统计开户客户数和平均风险分
SELECT 
    year_opened as 开户年份,
    COUNT(*) as 开户客户数,
    ROUND(AVG(risk_score), 2) as 平均风险分,
    MIN(risk_score) as 最低风险分,
    MAX(risk_score) as 最高风险分
FROM pingan_bank_customers
GROUP BY year_opened
ORDER BY year_opened DESC;

-- 7. 证件类型分布分析
-- 统计各类证件类型的客户数量和平均风险分
SELECT 
    id_type as 证件类型,
    COUNT(*) as 客户数量,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM pingan_bank_customers), 2) as 占比百分比,
    ROUND(AVG(risk_score), 2) as 平均风险分
FROM pingan_bank_customers
WHERE id_type IS NOT NULL
GROUP BY id_type
ORDER BY 客户数量 DESC;

-- 8. 高风险客户识别
-- 查询风险分数 >= 80 的高风险客户名单
SELECT 
    customer_id,
    name,
    customer_type,
    risk_score,
    open_date,
    mobile
FROM pingan_bank_customers
WHERE risk_score >= 80
ORDER BY risk_score DESC
LIMIT 20;

-- 9. 客户类型与风险等级的交叉分析
-- 分析不同客户类型下各风险等级的分布
SELECT 
    customer_type as 客户类型,
    CASE 
        WHEN risk_score <= 30 THEN '低风险'
        WHEN risk_score <= 70 THEN '中风险'
        ELSE '高风险'
    END as 风险等级,
    COUNT(*) as 客户数,
    ROUND(AVG(risk_score), 2) as 平均风险分
FROM pingan_bank_customers
GROUP BY customer_type, 风险等级
ORDER BY customer_type, 风险等级;

-- 10. 数据质量检查
-- 检查各字段的缺失值和数据完整性
SELECT 
    '客户ID' as 字段,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) as 缺失值数,
    COUNT(CASE WHEN customer_id IS NOT NULL THEN 1 END) as 有效值数
FROM pingan_bank_customers
UNION ALL
SELECT '姓名', COUNT(CASE WHEN name IS NULL THEN 1 END), COUNT(CASE WHEN name IS NOT NULL THEN 1 END) FROM pingan_bank_customers
UNION ALL
SELECT '证件类型', COUNT(CASE WHEN id_type IS NULL THEN 1 END), COUNT(CASE WHEN id_type IS NOT NULL THEN 1 END) FROM pingan_bank_customers
UNION ALL
SELECT '手机号', COUNT(CASE WHEN mobile IS NULL OR mobile = 'Invalid' THEN 1 END), COUNT(CASE WHEN mobile IS NOT NULL AND mobile != 'Invalid' THEN 1 END) FROM pingan_bank_customers
UNION ALL
SELECT '风险分数', COUNT(CASE WHEN risk_score IS NULL THEN 1 END), COUNT(CASE WHEN risk_score IS NOT NULL THEN 1 END) FROM pingan_bank_customers;

-- 11. 地区分析（从地址中提取省份）
-- 统计各省份的客户数和平均风险分
SELECT 
    SUBSTRING_INDEX(address, '市', 1) as 省份,
    COUNT(*) as 客户数,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM pingan_bank_customers), 2) as 占比百分比,
    ROUND(AVG(risk_score), 2) as 平均风险分
FROM pingan_bank_customers
WHERE address IS NOT NULL
GROUP BY SUBSTRING_INDEX(address, '市', 1)
ORDER BY 客户数 DESC
LIMIT 15;

-- 12. 手机号有效性统计
-- 统计有效和无效手机号的分布
SELECT 
    CASE 
        WHEN mobile = 'Invalid' THEN '无效手机号'
        WHEN mobile IS NULL THEN '缺失手机号'
        ELSE '有效手机号'
    END as 手机号状态,
    COUNT(*) as 客户数,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM pingan_bank_customers), 2) as 占比百分比
FROM pingan_bank_customers
GROUP BY 手机号状态
ORDER BY 客户数 DESC;

-- 13. 风险分数分布统计
-- 按风险分数范围统计客户分布，更细致的风险等级划分
SELECT 
    CASE 
        WHEN risk_score < 20 THEN '0-19分（极低风险）'
        WHEN risk_score < 40 THEN '20-39分（低风险）'
        WHEN risk_score < 60 THEN '40-59分（中低风险）'
        WHEN risk_score < 80 THEN '60-79分（中高风险）'
        ELSE '80-100分（高风险）'
    END as 风险评级,
    COUNT(*) as 客户数,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM pingan_bank_customers), 2) as 占比百分比
FROM pingan_bank_customers
GROUP BY 风险评级
ORDER BY risk_score;

-- 14. 开户日期分析
-- 统计每个月的新开户客户数和平均风险分
SELECT 
    DATE_FORMAT(open_date, '%Y-%m') as 开户月份,
    COUNT(*) as 新开户数,
    ROUND(AVG(risk_score), 2) as 平均风险分,
    MIN(risk_score) as 最低风险分,
    MAX(risk_score) as 最高风险分
FROM pingan_bank_customers
WHERE open_date IS NOT NULL
GROUP BY DATE_FORMAT(open_date, '%Y-%m')
ORDER BY 开户月份 DESC;

-- 15. 客户等级分析（基于风险评分）
-- 将客户按5个等级分类
SELECT 
    CASE 
        WHEN risk_score < 20 THEN 'A级（超低风险）'
        WHEN risk_score < 40 THEN 'B级（低风险）'
        WHEN risk_score < 60 THEN 'C级（中等风险）'
        WHEN risk_score < 80 THEN 'D级（中高风险）'
        ELSE 'E级（高风险）'
    END as 客户等级,
    COUNT(*) as 客户数,
    ROUND(AVG(risk_score), 2) as 平均风险分,
    COUNT(DISTINCT customer_type) as 客户类型数
FROM pingan_bank_customers
GROUP BY 客户等级
ORDER BY risk_score;

-- 16. 不同客户类型的风险对比
-- 详细对比个人和企业客户的风险特征
SELECT 
    customer_type as 客户类型,
    COUNT(*) as 总客户数,
    ROUND(AVG(risk_score), 2) as 平均风险分,
    MIN(risk_score) as 最低风险分,
    MAX(risk_score) as 最高风险分,
    COUNT(CASE WHEN risk_score >= 80 THEN 1 END) as 高风险客户数,
    ROUND(COUNT(CASE WHEN risk_score >= 80 THEN 1 END) * 100 / COUNT(*), 2) as 高风险占比
FROM pingan_bank_customers
GROUP BY customer_type;

-- 17. 新老客户对比
-- 按开户年份分析客户质量变化
SELECT 
    year_opened as 开户年份,
    COUNT(*) as 开户客户数,
    COUNT(CASE WHEN risk_score >= 80 THEN 1 END) as 高风险客户数,
    ROUND(COUNT(CASE WHEN risk_score >= 80 THEN 1 END) * 100 / COUNT(*), 2) as 高风险占比,
    ROUND(AVG(risk_score), 2) as 平均风险分
FROM pingan_bank_customers
WHERE year_opened IS NOT NULL
GROUP BY year_opened
ORDER BY year_opened DESC;