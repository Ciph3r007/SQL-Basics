USE sql_store;

# SELECT
SELECT name, unit_price, unit_price * 1.1 AS new_price FROM products;

# WHERE
SELECT * FROM order_items WHERE order_id = 6 AND quantity * unit_price > 30;

# IN
SELECT * FROM products WHERE quantity_in_stock IN (49, 38, 72);

# BETWEEN
SELECT * FROM customers WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

# LIKE
SELECT * FROM customers WHERE address LIKE '%trail%' OR address LIKE '%avenue%';
SELECT * FROM customers WHERE phone LIKE '%9';
SELECT * FROM customers WHERE phone LIKE '%7__';

# REGEXP
SELECT * FROM customers WHERE first_name REGEXP '^elka$|^ambur$';
SELECT * FROM customers WHERE last_name REGEXP 'ey$|on$';
SELECT * FROM customers WHERE last_name REGEXP '^my|se';
SELECT * FROM customers WHERE last_name REGEXP 'b[ru]';

# IS NULL / IS NOT NULL
SELECT * FROM orders WHERE shipped_date IS NULL;

# Sorting
SELECT *, (quantity * unit_price) AS total_price 
FROM order_items WHERE order_id = 2 
ORDER BY total_price DESC;

# LIMIT (start=0, length)
SELECT * FROM customers ORDER BY points DESC LIMIT 3;
SELECT * FROM customers ORDER BY points DESC LIMIT 1, 1;