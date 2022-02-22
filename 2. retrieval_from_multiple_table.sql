USE sql_store;

# Inner Join ('INNER' is not a must | 'NATURAL JOIN' selects keys automatically)
SELECT order_id, p.product_id, name, quantity, oi.unit_price
FROM order_items oi JOIN products p ON oi.product_id = p.product_id;

# Multiple Join
USE sql_invoicing;
SELECT date, invoice_id, amount, c.name AS client, pm.name AS transaction
FROM payments p JOIN clients c ON p.client_id = c.client_id
JOIN payment_methods pm ON payment_method = payment_method_id;

# Outer Join (LEFT or RIGHT)
SELECT p.product_id, name, quantity FROM products p LEFT JOIN order_items oi ON p.product_id = oi.product_id;

# Multiple Outer Join
SELECT order_date, order_id, first_name, s.name AS shipper, os.name AS status 
FROM orders o LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN shippers s ON o.shipper_id = s.shipper_id
LEFT JOIN order_statuses os ON status = order_status_id
ORDER BY status;

# Using
USE sql_invoicing;
SELECT date, c.name AS client, amount, pm.name 
FROM payments p 
JOIN clients c USING (client_id)
JOIN payment_methods pm ON payment_method = payment_method_id;

# Cross Join (BOTH R SEM SHITE)
SELECT s.name AS shipper, p.name AS product 
FROM shippers s, products p
ORDER BY shipper;

SELECT s.name AS shipper, p.name AS product 
FROM shippers s CROSS JOIN products p
ORDER BY shipper;

# Union (Similar: UNION ALL, INTERSECT, EXCEPT)
SELECT customer_id, first_name, points, 'Bronze' AS type
FROM customers WHERE points < 2000
UNION
SELECT customer_id, first_name, points, 'Silver'
FROM customers WHERE points BETWEEN 2000 AND 3000
UNION
SELECT customer_id, first_name, points, 'Gold' AS type
FROM customers WHERE points > 3000
ORDER BY points DESC;