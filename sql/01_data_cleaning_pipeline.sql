-- ============================================================================
-- 01_data_cleaning_pipeline.sql
-- Automated ETL Cleaning & Validation across 6 Relational Tables (50,000+ rows)
-- Author: Rahul
-- ============================================================================

WITH deduplicated_orders AS (
    SELECT 
        order_id,
        customer_id,
        session_id,
        order_date,
        COALESCE(order_amount, 0) AS order_amount,
        LOWER(TRIM(order_status)) AS order_status,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, session_id, order_date, order_amount 
            ORDER BY order_id ASC
        ) AS row_num
    FROM raw_orders
    WHERE customer_id IS NOT NULL
)
SELECT 
    order_id,
    customer_id,
    session_id,
    order_date,
    order_amount,
    order_status
INTO clean_orders
FROM deduplicated_orders
WHERE row_num = 1;

UPDATE raw_customers
SET 
    city = COALESCE(NULLIF(TRIM(city), ''), 'Unknown'),
    acquisition_channel = COALESCE(NULLIF(TRIM(acquisition_channel), ''), 'Organic'),
    signup_date = CAST(signup_date AS DATE)
WHERE customer_id IS NOT NULL;

SELECT 
    COUNT(DISTINCT c.customer_id) AS valid_customers,
    COUNT(DISTINCT s.session_id) AS valid_sessions,
    COUNT(DISTINCT ce.cart_id) AS valid_cart_events,
    COUNT(DISTINCT o.order_id) AS valid_orders,
    COUNT(DISTINCT p.payment_id) AS valid_payments,
    COUNT(DISTINCT st.ticket_id) AS valid_support_tickets
FROM raw_customers c
LEFT JOIN raw_sessions s ON c.customer_id = s.customer_id
LEFT JOIN raw_cart_events ce ON s.session_id = ce.session_id
LEFT JOIN clean_orders o ON c.customer_id = o.customer_id
LEFT JOIN raw_payments p ON o.order_id = p.order_id
LEFT JOIN raw_support_tickets st ON c.customer_id = st.customer_id;
