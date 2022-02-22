USE sql_store;

# Common Table Expression (CTE)
# Get all product names which were never shipped
WITH shipped AS (
	select * FROM orders WHERE shipped_date IS NOT NULL
)
SELECT name AS "Product Name" FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id 
	FROM shipped JOIN order_items USING (order_id)
);

/* Window Functions:
 * Executes after everything except order by clause
 * Default frame works from beginning upto current row
 * Syntax:
 * FUNC(column) OVER(PARTITION BY column ORDER BY column FRAME)
 * FUNC: ROW_NUMBER, RANK, DENSE_RANK, Aggregate Functions
 * FRAME: ROWS/RANGE BETWEEN <START> AND <END>
 * START/END: n/UNBOUNDED PRECEDING/FOLLOWING, CURRENT ROW
 * RANGE considers duplicates as same row (ROW is more preferable MOTT)
 */
 
# Rank of customers on each state
SELECT
	customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    state,
	points,
    RANK() OVER(
		PARTITION BY state
		ORDER BY points DESC
	) AS "rank"
FROM customers;

# Average points per state
SELECT
	customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    state,
	points,
    AVG(points)
		OVER(PARTITION BY state) AS avg_points
FROM customers
ORDER BY avg_points DESC;

# Moving average of last 3 days order amounts
WITH order_price AS (
	SELECT
		order_date,
        SUM(quantity * unit_price) AS price
    FROM orders JOIN order_items USING (order_id)
    GROUP BY order_date
)
SELECT
	order_date,
    price,
    ROUND(AVG(price) 
		OVER(ORDER BY order_date
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		), 2
	) AS moving_avg
FROM order_price;


/* ROLLUP and CUBE can both calculate total sum, avg etc.
 * CUBE calulates for all columns whereas ROLLUP calculates for just first one
 * Total values are shown as null entry in the target columns
 * [CUBE is NOT supported in MySQL]
 */

SELECT
	state,
    city,
    SUM(points) AS total
FROM customers
GROUP BY state, city WITH ROLLUP;

SELECT
	IFNULL(state, 'All states') AS state,
    COALESCE(city, 'All cities') AS city,
    SUM(points) AS total
FROM customers
GROUP BY state, city WITH ROLLUP;