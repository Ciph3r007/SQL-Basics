USE sql_invoicing;

/* Trigger: A block of SQL code that gets executed automatically
 * before or after an INSERT, DELETE or UPDATE statement.
 *
 * Event: A block of SQL code that gets executed based on a schedule.
 */

# Triggers
## Trigger when inserting a payment
-- DROP TRIGGER IF EXISTS payments_after_insert;

-- DELIMITER $$
-- CREATE TRIGGER payments_after_insert
-- 	AFTER INSERT ON payments
--     FOR EACH ROW
-- BEGIN
-- 	UPDATE invoices SET payment_total = payment_total + new.amount
--     WHERE invoice_id = NEW.invoice_id;
--     
--     INSERT INTO payments_audit VALUES(NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW());
-- END $$
-- DELIMITER ;

-- INSERT INTO payments VALUES(DEFAULT, 5, 18, '2000-01-01', 10, 1);


## Trigger when deleting a payment
-- DROP TRIGGER IF EXISTS payments_after_delete;

-- DELIMITER $$
-- CREATE TRIGGER payments_after_delete
-- 	AFTER DELETE ON payments
--     FOR EACH ROW
-- BEGIN
-- 	UPDATE invoices SET payment_total = payment_total - OLD.amount
--     WHERE invoice_id = OLD.invoice_id;
--     
--     INSERT INTO payments_audit VALUES(OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW());
-- END $$
-- DELIMITER ;

-- DELETE FROM payments WHERE payment_id = LAST_INSERT_ID();

# Events (ALTER can be used instead of CREATE to alter existing event)
## Yearly audit delete event
-- SHOW VARIABLES LIKE 'event%'
-- SET GLOBAL event_scheduler = ON / OFF

-- DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;

-- DELIMITER $$
-- CREATE EVENT yearly_delete_stale_audit_rows
-- ON SCHEDULE
-- 	-- AT 'some date' # FOR one-time events
--     EVERY 1 YEAR STARTS '2021-01-01' ENDS '2025-01-01'
-- DO BEGIN
-- 	DELETE FROM payments_audit WHERE action_date < NOW() - INTERVAL 1 YEAR;
-- END $$
-- DELIMITER ;

# Show triggers/events
-- SHOW TRIGGERS;
-- SHOW EVENTS;

# Disabling events
-- ALTER event yearly_delete_stale_audit_rows DISABLE;