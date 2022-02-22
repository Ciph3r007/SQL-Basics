USE sql_store;
 
# Subqueries in WHERE
## Employees with above average salary
USE sql_hr;
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

## Clients without invoices
USE sql_invoicing;
SELECT * FROM clients
WHERE client_id NOT IN (SELECT DISTINCT client_id FROM invoices);

## Customers who have ordered Lettuce (id = 3)
SELECT DISTINCT customer_id, first_name, last_name
FROM customers JOIN orders USING (customer_id)
WHERE order_id IN (
	SELECT order_id FROM order_items
    WHERE product_id = 3
);
-- OR --
SELECT DISTINCT customer_id, first_name, last_name
FROM customers JOIN orders USING (customer_id)
JOIN order_items USING (order_id)
WHERE product_id = 3;

# Correlated Subqueries 
## Invoices larger than client's average invoice
USE sql_invoicing;
SELECT * FROM invoices i
WHERE invoice_total > (
	SELECT AVG(invoice_total) FROM invoices
    WHERE client_id = i.client_id
);

# EXISTS (More efficient than IN)
## Products that have never been ordered
SELECT * FROM products 
WHERE product_id NOT IN (
	SELECT product_id FROM order_items
);
-- BETTER --
SELECT * FROM products p
WHERE NOT EXISTS (
	SELECT product_id FROM order_items
    WHERE product_id = p.product_id
);

# Subqueries in SELECT
USE sql_invoicing;
SELECT
	client_id,
    name,
	(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
    (SELECT AVG(invoice_total) FROM invoices) AS average,
    (SELECT total_sales - average) AS difference
FROM clients c;

#Subqueries in FROM (Alias is a must | Better to use VIEWS)
USE sql_invoicing;
SELECT * FROM (
	SELECT
		client_id,
		name,
		(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
		(SELECT AVG(invoice_total) FROM invoices) AS average,
		(SELECT total_sales - average) AS difference
	FROM clients c
) AS summary WHERE total_sales IS NOT NULL;

