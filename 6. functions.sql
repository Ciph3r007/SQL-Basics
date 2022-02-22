USE sql_store;

/* Common Functions:
 * Numeric: ABS, ROUND, TRUNCATE, CEILING, FLOOR, RAND
 * String: LENGTH (bytes), CHAR_LENGTH, UPPER/LOWER, TRIM, SUBSTRING/LEFT/RIGHT, LPAD/RPAD,
 * 		   LOCATE/POSITION, REPLACE, REVERSE, CONCAT (Operator || in postgres), INITCAP (postgres)
 * Datetime: NOW/CURDATE/CURTIME, YEAR/MONTH/DAY, DAYNAME/MONTHNAME, EXTRACT, DATE_FORMAT/TIME_FORMAT
 * Utilities: CASE, IF, IFNULL, COALESCE, CAST (OPERATOR :: in postgres) 
 */

## Orders from current year
SELECT * FROM orders WHERE YEAR(order_date) = YEAR(NOW());

## Full name and phone numbers of customers
-- SELECT
-- 	CONCAT(first_name, ' ', last_name) AS full_name, 
-- 	IFNULL(phone, 'Unknown') AS phone
-- FROM customers;

# IF
## Order counts per item
SELECT
	product_id, 
    name, 
    COUNT(*) AS orders, 
    IF(COUNT(*) = 1, 'Once', 'Multiple times') AS frequency
FROM products JOIN order_items USING (product_id)
GROUP BY product_id;

# CASE (Not a function)
## Customer rank based on points
SELECT
	CONCAT(first_name, ' ', last_name) AS customer,
    points,
    CASE
		WHEN points >= 3000 THEN 'Gold'
        WHEN points >= 2000 THEN 'Silver'
        ELSE 'Bronze'
	END AS category
FROM customers
ORDER BY points DESC;

SELECT
	REVERSE('mood'),
	REPLACE('kita ba? balani??', ' ', '_'),
    LOCATE('world', 'hello world'), -- Not in postgres 
    POSITION('world' IN 'hello world'),
    LPAD('hello', 10, '.'),
    LENGTH(TRIM(' hihi ')),
    LENGTH('♥'),
    CHAR_LENGTH('♥');
    
SELECT
    EXTRACT(YEAR FROM '2012-05-06'),
    DAYNAME(NOW()),
    CURDATE() + INTERVAL '2' WEEK;