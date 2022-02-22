USE sql_store;

# Insert Rows
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES 
	('Ataa', 10, 0.5),
    ('Moyda', 5, 1.25),
    ('Suji', 3, 1.05);

# Creating Table from query (Also usable with Insert)
USE sql_invoicing;
CREATE TABLE invoice_archived AS
SELECT
	invoice_id,
    name,
    number,
    invoice_total,
    payment_total,
    invoice_date,
    due_date,
    payment_date
FROM invoices
JOIN clients USING (client_id)
WHERE payment_date IS NOT NULL;

# Updating Multiple Records (Disable safe update)
UPDATE customers SET points = points + 50 WHERE birth_date < '1990-01-01';

# Update Using Subqueries
UPDATE orders SET comments = 'Gold Customer'
WHERE customer_id IN (SELECT customer_id FROM customers WHERE points > 3000);

# Deleting
DELETE FROM products WHERE name IN ('Ataa', 'Moyda', 'Suji');