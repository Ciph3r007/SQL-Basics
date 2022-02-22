USE sql_invoicing;

# Aggregate Functions (MIN, MAX, SUM, AVG, COUNT)
SELECT
	'First half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT
	'Second half of 2019',
    SUM(invoice_total),
    SUM(payment_total),
    SUM(invoice_total - payment_total)
FROM invoices WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT
	'Total',
    SUM(invoice_total),
    SUM(payment_total),
    SUM(invoice_total - payment_total)
FROM invoices WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31';

# GROUP BY Clause
## Total payments for each day
SELECT p.date, pm.name AS payment_method, SUM(p.amount) AS total_payments
FROM payments p JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY p.date, payment_method
ORDER BY p.date;

SELECT date, SUM(amount) AS total_payments
FROM payments
GROUP BY date
ORDER BY date;

# HAVING Clause (THIS EXCERCISE IS A GOOD ONE)
/* Used after GROUP BY 
 * Equivalent to WHERE for each groups 
 * Unlike WHERE, can only filter from selected columns)
 */
## All customers from Virginia who spent more than $100
USE sql_store;
SELECT c.customer_id, c.first_name, c.last_name, c.state, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM  customers c JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE c.state = 'VA'
GROUP BY c.customer_id
HAVING total_spent > 100
ORDER BY total_spent DESC;

# ROLLUP (Do not use aliases on GROUP BY | Only in MySQL)
## Total payments for each transaction type
SELECT pm.name AS payment_method, SUM(p.amount) AS total
FROM payments p JOIN payment_methods pm ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;


SELECT DISTINCT product_id FROM order_items;