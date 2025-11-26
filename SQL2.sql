/*markdown
# SQL 数据操作 (DML) 示例
## INSERT、UPDATE、DELETE 操作教程

本文档展示如何安全地进行数据插入、更新和删除操作。
*/

-- ==========================================
-- 1. INSERT 操作示例 - 插入新数据
-- ==========================================

-- 1.1 插入单条新客户记录
INSERT INTO pingan_bank_customers (
    customer_id, 
    name, 
    id_type, 
    id_number, 
    mobile, 
    address, 
    open_date, 
    customer_type, 
    risk_score, 
    year_opened
) VALUES (
    'PA99999999',           -- 新客户 ID
    '测试客户001',          -- 姓名
    '身份证',              -- 证件类型
    '1234567890123456',    -- 证件号码
    '13800138000',         -- 手机号
    '北京市朝阳区建国路1号', -- 地址
    '2024-01-15',          -- 开户日期
    '个人',                -- 客户类型
    45,                    -- 风险评分
    2024                   -- 开户年份
);

-- 查看插入结果
SELECT * FROM pingan_bank_customers WHERE customer_id = 'PA99999999';

-- ⚠️ 撤销操作（回滚这条插入）
-- DELETE FROM pingan_bank_customers WHERE customer_id = 'PA99999999';

-- 1.2 批量插入多条客户记录
INSERT INTO pingan_bank_customers (
    customer_id, name, id_type, id_number, mobile, address, open_date, customer_type, risk_score, year_opened
) VALUES 
    ('PA88888888', '测试客户002', '身份证', '1234567890123457', '13800138001', '上海市浦东新区世纪大道1号', '2024-01-16', '个人', 52, 2024),
    ('PA87654321', '测试客户003', '护照', 'PA123456789', '13800138002', '深圳市罗湖区深南东路1号', '2024-01-17', '企业', 38, 2024),
    ('PA87654322', '测试客户004', '营业执照', '91110105MA00XXXXX0', '13800138003', '广州市天河区体育东路1号', '2024-01-18', '企业', 62, 2024);

-- 验证批量插入结果
SELECT * FROM pingan_bank_customers WHERE customer_id IN ('PA88888888', 'PA87654321', 'PA87654322');

-- ⚠️ 撤销操作（回滚这些插入）
-- DELETE FROM pingan_bank_customers WHERE customer_id IN ('PA88888888', 'PA87654321', 'PA87654322');

-- ==========================================
-- 2. UPDATE 操作示例 - 更新现有数据
-- ==========================================

-- ⚠️ 重要提示：以下 UPDATE 操作仅针对之前 INSERT 的测试数据
-- 不会修改原始生产数据

-- 2.1 更新单条记录的风险评分
-- 将测试客户001的风险评分从45更新为35
UPDATE pingan_bank_customers 
SET risk_score = 35 
WHERE customer_id = 'PA99999999';

-- 验证更新结果
SELECT customer_id, name, risk_score FROM pingan_bank_customers WHERE customer_id = 'PA99999999';

-- ⚠️ 撤销操作（恢复为45）
-- UPDATE pingan_bank_customers SET risk_score = 45 WHERE customer_id = 'PA99999999';

-- 2.2 更新多个字段
-- 更新测试客户002的手机号和地址
UPDATE pingan_bank_customers 
SET 
    mobile = '13900139000',
    address = '新地址：北京市海淀区中关村大街1号'
WHERE customer_id = 'PA88888888';

-- 验证更新结果
SELECT customer_id, name, mobile, address FROM pingan_bank_customers WHERE customer_id = 'PA88888888';

-- ⚠️ 撤销操作（恢复原值）
-- UPDATE pingan_bank_customers 
-- SET mobile = '13800138001', address = '上海市浦东新区世纪大道1号'
-- WHERE customer_id = 'PA88888888';

-- 2.3 批量更新多条测试记录的风险评分
-- 将所有测试客户（PA开头）的风险评分统一调整为50
UPDATE pingan_bank_customers 
SET risk_score = 50 
WHERE customer_id IN ('PA87654321', 'PA87654322');

-- 验证批量更新结果
SELECT customer_id, name, risk_score FROM pingan_bank_customers WHERE customer_id IN ('PA87654321', 'PA87654322');

-- ⚠️ 撤销操作（恢复原值）
-- UPDATE pingan_bank_customers SET risk_score = 38 WHERE customer_id = 'PA87654321';
-- UPDATE pingan_bank_customers SET risk_score = 62 WHERE customer_id = 'PA87654322';

-- 2.4 使用表达式更新（基于条件的计算更新）
-- 将所有测试的个人客户的风险评分增加10分
UPDATE pingan_bank_customers 
SET risk_score = risk_score + 10 
WHERE customer_id IN ('PA99999999', 'PA88888888') AND customer_type = '个人';

-- 验证结果
SELECT customer_id, name, customer_type, risk_score FROM pingan_bank_customers WHERE customer_id IN ('PA99999999', 'PA88888888');

-- ⚠️ 撤销操作（恢复原值）
-- UPDATE pingan_bank_customers SET risk_score = 35 WHERE customer_id = 'PA99999999';
-- UPDATE pingan_bank_customers SET risk_score = 52 WHERE customer_id = 'PA88888888';

-- 2.5 条件更新：更新所有低风险的测试客户为中等风险
-- 将风险评分<40的测试客户更新为45
UPDATE pingan_bank_customers 
SET risk_score = 45 
WHERE risk_score < 40 AND customer_id LIKE 'PA%';

-- 验证结果
SELECT customer_id, name, risk_score FROM pingan_bank_customers WHERE customer_id LIKE 'PA%' AND customer_id != 'PA13356886';

-- ==========================================
-- 3. DELETE 操作示例 - 删除现有数据
-- ==========================================

-- ⚠️ 重要提示：DELETE 操作是永久性的，请确保只删除测试数据！
-- 本示例仅删除 PA 开头的测试记录

-- 3.1 删除单条测试记录
DELETE FROM pingan_bank_customers 
WHERE customer_id = 'PA99999999';

-- 验证删除结果
SELECT COUNT(*) as 剩余测试记录数 FROM pingan_bank_customers WHERE customer_id LIKE 'PA%';

-- ⚠️ 恢复操作（重新插入被删除的记录）
-- INSERT INTO pingan_bank_customers VALUES ('PA99999999', '测试客户001', '身份证', '1234567890123456', '13800138000', '北京市朝阳区建国路1号', '2024-01-15', '个人', 45, 2024);

-- 3.2 批量删除多条测试记录
DELETE FROM pingan_bank_customers 
WHERE customer_id IN ('PA88888888', 'PA87654321', 'PA87654322');

-- 验证批量删除结果
SELECT COUNT(*) as 剩余测试记录数 FROM pingan_bank_customers WHERE customer_id LIKE 'PA%';

-- ⚠️ 恢复操作（重新插入被删除的记录）
-- INSERT INTO pingan_bank_customers (customer_id, name, id_type, id_number, mobile, address, open_date, customer_type, risk_score, year_opened) VALUES 
-- ('PA88888888', '测试客户002', '身份证', '1234567890123457', '13800138001', '上海市浦东新区世纪大道1号', '2024-01-16', '个人', 52, 2024),
-- ('PA87654321', '测试客户003', '护照', 'PA123456789', '13800138002', '深圳市罗湖区深南东路1号', '2024-01-17', '企业', 38, 2024),
-- ('PA87654322', '测试客户004', '营业执照', '91110105MA00XXXXX0', '13800138003', '广州市天河区体育东路1号', '2024-01-18', '企业', 62, 2024);

-- 3.3 条件删除：删除高风险的测试客户
-- 删除所有风险评分 >= 70 的测试客户
DELETE FROM pingan_bank_customers 
WHERE risk_score >= 70 AND customer_id LIKE 'PA%';

-- 验证条件删除结果
SELECT COUNT(*) as 剩余测试记录数 FROM pingan_bank_customers WHERE customer_id LIKE 'PA%';

-- ==========================================
-- 4. 进阶操作示例 - UPSERT（插入或更新）
-- ==========================================

-- 4.1 使用 REPLACE 语句（如果存在则替换，不存在则插入）
-- 注意：这会完全替换整行数据
REPLACE INTO pingan_bank_customers (
    customer_id, name, id_type, id_number, mobile, address, open_date, customer_type, risk_score, year_opened
) VALUES (
    'PA77777777',
    '新客户或更新客户',
    '身份证',
    '9999999999999999',
    '13900139999',
    '杭州市滨江区阿里巴巴1号',
    '2024-02-01',
    '个人',
    55,
    2024
);

-- 验证 REPLACE 操作
SELECT * FROM pingan_bank_customers WHERE customer_id = 'PA77777777';

-- 4.2 使用 INSERT ... ON DUPLICATE KEY UPDATE（推荐）
-- 这是更灵活的 UPSERT 方式
INSERT INTO pingan_bank_customers (
    customer_id, name, id_type, id_number, mobile, address, open_date, customer_type, risk_score, year_opened
) VALUES (
    'PA77777777',
    '更新后的客户名称',
    '身份证',
    '9999999999999999',
    '13900139999',
    '杭州市滨江区新地址',
    '2024-02-01',
    '个人',
    65,
    2024
)
ON DUPLICATE KEY UPDATE
    name = '更新后的客户名称',
    mobile = '13900139999',
    address = '杭州市滨江区新地址',
    risk_score = 65;

-- 验证 INSERT ON DUPLICATE KEY UPDATE 操作
SELECT * FROM pingan_bank_customers WHERE customer_id = 'PA77777777';

-- ==========================================
-- 5. 安全操作示例 - 事务处理和备份恢复
-- ==========================================

-- 5.1 使用事务保护 INSERT 操作
-- 这样可以在出错时回滚所有操作
START TRANSACTION;

INSERT INTO pingan_bank_customers (
    customer_id, name, id_type, id_number, mobile, address, open_date, customer_type, risk_score, year_opened
) VALUES ('PA66666666', '事务测试客户', '身份证', '5555555555555555', '13855555555', '成都市高新区1号', '2024-03-01', '个人', 40, 2024);

-- 查看插入的数据
SELECT * FROM pingan_bank_customers WHERE customer_id = 'PA66666666';

-- 如果一切正常，提交事务
COMMIT;

-- 如果出错，可以回滚（注意：COMMIT 后无法回滚）
-- ROLLBACK;

-- 5.2 使用 LIMIT 进行安全删除
-- 先查看有多少条记录要删除
SELECT COUNT(*) FROM pingan_bank_customers WHERE customer_id LIKE 'PA%' AND customer_id != 'PA13356886';

-- 然后分批删除（示例：一次删除最多5条）
DELETE FROM pingan_bank_customers 
WHERE customer_id LIKE 'PA%' AND customer_id != 'PA13356886'
LIMIT 5;

-- 验证删除结果
SELECT COUNT(*) FROM pingan_bank_customers WHERE customer_id LIKE 'PA%' AND customer_id != 'PA13356886';

-- ==========================================
-- 6. 数据备份与恢复示例
-- ==========================================

-- 6.1 创建临时备份表（在修改前备份重要数据）
CREATE TABLE IF NOT EXISTS pingan_bank_customers_backup AS
SELECT * FROM pingan_bank_customers WHERE customer_id LIKE 'PA%';

-- 验证备份表
SELECT COUNT(*) as 备份记录数 FROM pingan_bank_customers_backup;

-- 6.2 从备份表恢复数据（如果需要）
-- 这个示例展示如何从备份恢复
-- INSERT INTO pingan_bank_customers
-- SELECT * FROM pingan_bank_customers_backup
-- WHERE customer_id NOT IN (SELECT customer_id FROM pingan_bank_customers);

-- 6.3 清理备份表（操作完成后）
-- DROP TABLE pingan_bank_customers_backup;