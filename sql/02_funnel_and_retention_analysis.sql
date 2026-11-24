-- ============================================================================
-- 02_funnel_and_retention_analysis.sql
-- Funnel Drop-Off & Repeat Engagement Cohort Diagnostics
-- Author: Rahul
-- ============================================================================

WITH funnel_stages AS (
    SELECT
        COUNT(DISTINCT s.session_id) AS total_sessions,
        COUNT(DISTINCT CASE WHEN s.page_views > 1 THEN s.session_id END) AS product_views,
        COUNT(DISTINCT ce.session_id) AS add_to_cart,
        COUNT(DISTINCT o.session_id) AS checkout_initiated,
        COUNT(DISTINCT CASE WHEN p.payment_status = 'Success' THEN o.session_id END) AS payment_completed
    FROM raw_sessions s
    LEFT JOIN raw_cart_events ce ON s.session_id = ce.session_id
    LEFT JOIN clean_orders o ON s.session_id = o.session_id
    LEFT JOIN raw_payments p ON o.order_id = p.order_id
)
SELECT
    total_sessions,
    product_views,
    add_to_cart,
    checkout_initiated,
    payment_completed,
    ROUND((1.0 - (payment_completed * 1.0 / NULLIF(checkout_initiated, 0))) * 100, 2) AS checkout_dropoff_pct
FROM funnel_stages;

WITH customer_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        order_amount,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
    FROM clean_orders
    WHERE order_status = 'completed'
)
SELECT
    CASE WHEN order_sequence = 1 THEN 'New Customer' ELSE 'Repeat Customer' END AS customer_segment,
    COUNT(DISTINCT customer_id) AS customer_count,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(order_amount), 2) AS avg_order_value,
    ROUND(AVG(DATEDIFF(day, previous_order_date, order_date)), 1) AS avg_days_between_orders
FROM customer_orders
GROUP BY CASE WHEN order_sequence = 1 THEN 'New Customer' ELSE 'Repeat Customer' END;
