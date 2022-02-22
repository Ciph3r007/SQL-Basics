USE sql_store;

## Balance of each customer
USE sql_invoicing;
CREATE OR REPLACE VIEW clients_balance AS
SELECT client_id, name, SUM(invoice_total - payment_total) AS balance
FROM clients JOIN invoices USING (client_id)
GROUP BY client_id
ORDER BY client_id;

SELECT * FROM clients_balance;