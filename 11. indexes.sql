USE sql_store;

/* Indexes are stored as binary trees.
 * Used for fast filtering and sorting
 * Primary keys are always indexed by default.
 * Newly created indexes include primary keys as a pair.
 * Only one index can be used for queries.
 * Use UNION instead of OR condition to utilize multiple indexes.
 * Composite indexes create subindexes based on index orders.
 * So, INDEX(a, b) creates INDEX(a) first,
 * then creates subindexes for each sections of a.
 * Composite indexes can have a maximum of 16 columns.
 */

# Indexing with numericals
-- EXPLAIN SELECT customer_id FROM customers WHERE points > 1000;

-- CREATE INDEX idx_points ON customers (points);
-- EXPLAIN SELECT customer_id FROM customers WHERE points > 1000;
-- EXPLAIN SELECT points FROM customers WHERE points > 1000;
-- -- Still needs full table scan when retrieving other rows
-- EXPLAIN SELECT city FROM customers WHERE points > 1000;

-- -- filesort vs index sort
-- EXPLAIN SELECT customer_id FROM customers ORDER BY points;
-- EXPLAIN SELECT customer_id FROM customers ORDER BY state;

-- DROP INDEX idx_points ON customers;

# Indexing with prefixes for strings
-- EXPLAIN SELECT customer_id, last_name FROM customers WHERE last_name LIKE 'Jo%';

-- -- To decide the length of prefix
-- SELECT
-- 	COUNT(DISTINCT LEFT(last_name, 1)),
-- 	COUNT(DISTINCT LEFT(last_name, 2)),
-- 	COUNT(DISTINCT LEFT(last_name, 4)),
-- 	COUNT(DISTINCT LEFT(last_name, 8))
-- FROM customers;

-- CREATE INDEX idx_lastname ON customers (last_name(4));
-- SELECT customer_id, last_name FROM customers WHERE last_name LIKE 'Jo%';
-- EXPLAIN SELECT customer_id, last_name FROM customers WHERE last_name LIKE 'Jo%';

-- DROP INDEX idx_lastname ON customers;

# Full text indexing
-- USE sql_blog;

-- -- Target query
-- SELECT * FROM posts 
-- WHERE title REGEXP 'react|redux' OR body REGEXP 'react|redux';
-- SHOW STATUS LIKE 'last_query_cost';

-- CREATE FULLTEXT INDEX idx_title_body ON posts (title, body);

-- SELECT *, MATCH(title, body) AGAINST('react redux') AS relevance_score FROM posts
-- WHERE MATCH(title, body) AGAINST('react redux');
-- SHOW STATUS LIKE 'last_query_cost';

-- -- Boolean mode [+ to include, - to exclude, "..." to be exact]
-- SELECT * FROM posts
-- WHERE MATCH(title, body) AGAINST('"Web applications" +form -redux' IN BOOLEAN MODE);

-- DROP INDEX idx_title_body ON posts;

# Composite indexing
/* Use most frequently used columns first
 * Columns with higher cardinality first works better most of the time
 */

-- CREATE INDEX idx_state ON customers (state);
-- CREATE INDEX idx_points ON customers (points);

-- -- Only one of the indexes are used and subtable needs full scan
-- EXPLAIN SELECT customer_id FROM customers
-- WHERE state = 'CA' AND points > 1000;

-- CREATE INDEX idx_state_points ON customers (state, points);
-- EXPLAIN SELECT customer_id FROM customers
-- WHERE state = 'CA' AND points > 1000;
-- -- NB: idx_state_point makes idx_state redundant

-- -- Ordering matters
-- CREATE INDEX idx_points_state ON customers (points, state);

-- EXPLAIN SELECT customer_id FROM customers
-- USE INDEX (idx_points_state)
-- WHERE state = 'CA' AND points > 1000;

-- -- Checking cardinality
-- SHOW INDEXES IN customers;

-- DROP INDEX idx_state ON customers;
-- DROP INDEX idx_points ON customers;
-- DROP INDEX idx_state_points ON customers;
-- DROP INDEX idx_points_state ON customers;