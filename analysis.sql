USE mydb;

SELECT * FROM orders LIMIT 10;

SELECT region, SUM(list_price) 
FROM orders
GROUP BY region;
