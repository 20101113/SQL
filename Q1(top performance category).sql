create database sales
show databases;
use sales;

-- Create tables
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_date DATE,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 599.99),
(3, 'Tablet', 'Electronics', 399.99),
(4, 'Desk Chair', 'Furniture', 149.99),
(5, 'Coffee Table', 'Furniture', 199.99),
(6, 'Bookshelf', 'Furniture', 89.99),
(7, 'Running Shoes', 'Apparel', 79.99),
(8, 'T-shirt', 'Apparel', 19.99),
(9, 'Jeans', 'Apparel', 59.99);

INSERT INTO sales (sale_id, product_id, sale_date, quantity) VALUES
(1, 1, '2023-01-15', 2),
(2, 2, '2023-01-16', 3),
(3, 4, '2023-01-17', 1),
(4, 7, '2023-01-18', 4),
(5, 3, '2023-02-01', 2),
(6, 5, '2023-02-02', 1),
(7, 8, '2023-02-03', 5),
(8, 1, '2023-02-15', 1),
(9, 6, '2023-02-16', 2),
(10, 2, '2023-02-17', 2),
(11, 9, '2023-03-01', 3),
(12, 4, '2023-03-02', 2),
(13, 7, '2023-03-03', 3),
(14, 3, '2023-03-15', 1),
(15, 5, '2023-03-16', 1);

-- Problem Statement:
-- Analyze the sales data to find the top-performing product category for each month of 2023.
-- The performance should be based on total revenue (quantity sold * unit price).
-- Your query should return the month, the top-performing category, and its total revenue.
-- In case of a tie, include all categories with the same top performance.
explain WITH MonthlyRevenue AS (
    -- Step 1: Calculate total revenue for each category per month
    SELECT 
        DATE_FORMAT(s.sale_date, '%Y-%m') AS month, 
        p.category,
        SUM(s.quantity * p.unit_price) AS total_revenue
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    WHERE YEAR(s.sale_date) = 2023
    GROUP BY month, p.category
)

SELECT month,
    category AS top_category,
    total_revenue
FROM (
    SELECT month, category, total_revenue,
        RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS revenue_rank
    FROM MonthlyRevenue
) AS RankedRevenue
WHERE revenue_rank = 1
ORDER BY month;
