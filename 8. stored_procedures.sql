USE sql_invoicing;

# Create procedure
## All invoices with balance
-- DROP PROCEDURE IF EXISTS get_invoices_with_balance;

-- DELIMITER $$
-- CREATE PROCEDURE get_invoices_with_balance()
-- BEGIN
-- 	SELECT * FROM invoices WHERE invoice_total - payment_total > 0;
-- END$$
-- DELIMITER ;

-- CALL get_invoices_with_balance();

# With parameters
## Invoices for a client
-- DROP PROCEDURE IF EXISTS get_invoices_by_client;

-- DELIMITER $$
-- CREATE PROCEDURE get_invoices_by_client(client_id INT)
-- BEGIN
-- 	SELECT * FROM invoices i
--     WHERE i.client_id = client_id;
-- END$$
-- DELIMITER ;

-- CALL get_invoices_by_client(1);

# With optional parameters
-- DROP PROCEDURE IF EXISTS get_payments;

-- DELIMITER $$
-- CREATE PROCEDURE get_payments(client_id INT, payment_method TINYINT)
-- BEGIN
-- 	SELECT * FROM payments p
--     WHERE p.client_id = IFNULL(client_id, p.client_id)
-- 		AND p.payment_method = IFNULL(payment_method, p.payment_method);
-- END$$
-- DELIMITER ;

-- CALL get_payments(5, NULL);

# Functions
-- DROP FUNCTION IF EXISTS get_risk_factor;

-- DELIMITER $$
-- CREATE FUNCTION get_risk_factor(client_id INT)
-- RETURNS INTEGER
-- -- DETERMINISTIC
-- READS SQL DATA
-- -- MODIFIES SQL DATA
-- BEGIN
-- 	DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
--     DECLARE invoices_total DECIMAL(9, 2);
--     DECLARE invoices_count INT;
--     
--     SELECT COUNT(*), SUM(invoice_total) INTO invoices_count, invoices_total
--     FROM invoices i WHERE i.client_id = client_id;
--     
--     SET risk_factor = invoices_total / invoices_count * 5;
--     
-- RETURN IFNULL(risk_factor, 0);
-- END$$
-- DELIMITER ;

-- SELECT client_id, name, get_risk_factor(client_id) FROM clients;





