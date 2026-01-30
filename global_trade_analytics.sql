/*
================================================================================
Project: Global Trade & BI Analytics Portfolio
Description: High-performance MySQL script for Apparel Supply Chain and 
             Photovoltaic (PV) Module Export analytics.
Author: Assistant (Generated for User)
Date: 2026-01-30
Database: global_trade_analytics
================================================================================
*/

-- 1. Database Setup
-- -----------------------------------------------------------------------------
DROP DATABASE IF EXISTS global_trade_analytics;
CREATE DATABASE global_trade_analytics;
USE global_trade_analytics;

-- 2. Table Creation
-- -----------------------------------------------------------------------------

-- Users Table: Stores customer information globally
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products Table: Stores item details with JSON tech specs
-- tech_specs handles flexible attributes for PV modules vs. Apparel
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category ENUM('PV Module', 'Apparel') NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    tech_specs JSON, -- Stores efficiency, materials, dimensions, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders Table: Transactional header data
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    total_amount DECIMAL(12, 2) DEFAULT 0.00,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Order Items Table: Line items for each order
CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(12, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Logistics Table: Shipping and tracking information
CREATE TABLE logistics (
    logistics_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    carrier VARCHAR(50),
    tracking_number VARCHAR(100),
    shipment_date DATETIME,
    estimated_delivery DATETIME,
    delivery_status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- 3. Data Seeding (Diverse Dataset)
-- -----------------------------------------------------------------------------

-- Insert Users (Global distribution)
INSERT INTO users (full_name, email, country, city) VALUES
('John Doe', 'john.doe@example.com', 'USA', 'Los Angeles'),
('Alice Smith', 'alice.s@example.co.uk', 'UK', 'London'),
('Wei Chen', 'wei.chen@techcorp.cn', 'China', 'Shanghai'),
('Hans Müller', 'hans.m@solar.de', 'Germany', 'Berlin'),
('Sofia Rossi', 'sofia.r@fashion.it', 'Italy', 'Milan'),
('Raj Patel', 'raj.p@energy.in', 'India', 'Mumbai'),
('Elena Ivanova', 'elena.i@trade.ru', 'Russia', 'Moscow'),
('Carlos Garcia', 'carlos.g@sol.es', 'Spain', 'Madrid'),
('Yuki Tanaka', 'yuki.t@import.jp', 'Japan', 'Tokyo'),
('Liam O''Connor', 'liam.o@green.ie', 'Ireland', 'Dublin');

-- Insert Products (PV Modules & Apparel with JSON specs)
INSERT INTO products (product_name, category, price, tech_specs) VALUES
-- PV Modules (Efficiency stored as numeric percentage for easy querying)
('SolarMax Pro 400W', 'PV Module', 250.00, '{"wattage": 400, "efficiency_percent": 21.5, "cell_type": "Monocrystalline", "dimensions": "1755x1038x35mm"}'),
('EcoSun Ultra 450W', 'PV Module', 320.00, '{"wattage": 450, "efficiency_percent": 22.8, "cell_type": "Monocrystalline", "bifacial": true}'),
('PhotonX 500W Panel', 'PV Module', 400.00, '{"wattage": 500, "efficiency_percent": 23.1, "cell_type": "N-Type TOPCon", "warranty_years": 25}'),
('BudgetSolar 300W', 'PV Module', 150.00, '{"wattage": 300, "efficiency_percent": 19.5, "cell_type": "Polycrystalline"}'),
('GreenTech Flex 200W', 'PV Module', 180.00, '{"wattage": 200, "efficiency_percent": 20.0, "type": "Flexible"}'),

-- Apparel (Material and sustainability specs)
('Organic Cotton T-Shirt', 'Apparel', 25.00, '{"material": "100% Organic Cotton", "size": "L", "color": "White", "sustainability_rating": "A+"}'),
('Recycled Poly Jacket', 'Apparel', 85.00, '{"material": "Recycled Polyester", "size": "M", "water_resistant": true}'),
('Denim Jeans Classic', 'Apparel', 60.00, '{"material": "Cotton Blend", "size": "32/34", "cut": "Straight"}'),
('Hemp Cargo Pants', 'Apparel', 70.00, '{"material": "Hemp/Cotton", "size": "34", "color": "Khaki"}'),
('Bamboo Fiber Socks', 'Apparel', 12.00, '{"material": "Bamboo Viscose", "pack_size": 3}');

-- Insert Orders (Spread over months for Time Series Analysis)
INSERT INTO orders (user_id, order_date, status, total_amount) VALUES
(1, '2023-10-15 10:00:00', 'Delivered', 2500.00), -- PV Order
(2, '2023-10-20 14:30:00', 'Delivered', 85.00),   -- Apparel
(3, '2023-11-05 09:15:00', 'Shipped', 12800.00),  -- Large PV Order
(4, '2023-11-12 11:45:00', 'Processing', 3200.00), -- PV Order
(5, '2023-12-01 16:20:00', 'Delivered', 200.00),   -- Apparel
(6, '2023-12-15 10:00:00', 'Pending', 5000.00),    -- PV Order
(7, '2024-01-05 13:00:00', 'Delivered', 50.00),    -- Apparel
(8, '2024-01-10 09:30:00', 'Shipped', 6400.00),    -- PV Order
(9, '2024-01-25 15:00:00', 'Processing', 120.00),  -- Apparel
(10, '2024-02-01 11:00:00', 'Pending', 400.00);    -- PV Order

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 10, 250.00), -- 10 SolarMax Pro
(2, 7, 1, 85.00),   -- 1 Jacket
(3, 2, 40, 320.00), -- 40 EcoSun Ultra
(4, 3, 8, 400.00),  -- 8 PhotonX
(5, 6, 4, 25.00),   -- 4 T-Shirts
(5, 8, 1, 60.00),   -- 1 Jeans
(5, 10, 2, 20.00),  -- 2 Socks (price adjustment sim)
(6, 1, 20, 250.00),
(7, 6, 2, 25.00),
(8, 2, 20, 320.00),
(9, 8, 2, 60.00),
(10, 3, 1, 400.00);

-- Insert Logistics
INSERT INTO logistics (order_id, carrier, tracking_number, shipment_date, estimated_delivery, delivery_status) VALUES
(1, 'DHL', 'DHL123456789', '2023-10-16 08:00:00', '2023-10-20 18:00:00', 'Delivered'),
(2, 'FedEx', 'FX987654321', '2023-10-21 09:00:00', '2023-10-25 12:00:00', 'Delivered'),
(3, 'Maersk', 'MSK555444333', '2023-11-06 10:00:00', '2023-12-01 10:00:00', 'In Transit'),
(4, 'UPS', 'UPS111222333', '2023-11-13 14:00:00', '2023-11-20 18:00:00', 'In Transit'),
(5, 'DHL', 'DHL999888777', '2023-12-02 11:00:00', '2023-12-05 15:00:00', 'Delivered'),
(6, 'Maersk', 'MSK222333444', NULL, NULL, 'Pending Pickup'),
(7, 'FedEx', 'FX444555666', '2024-01-06 09:00:00', '2024-01-09 12:00:00', 'Delivered'),
(8, 'UPS', 'UPS777888999', '2024-01-11 16:00:00', '2024-01-18 18:00:00', 'Shipped'),
(9, 'DHL', 'DHL333222111', '2024-01-26 10:00:00', '2024-01-30 14:00:00', 'Processing'),
(10, NULL, NULL, NULL, NULL, 'Pending Processing');


-- 4. Analytical Queries
-- -----------------------------------------------------------------------------

-- Query 1: High-Efficiency PV Modules Analysis (JSON Handling & Complex Join)
-- Goal: Find customers who ordered panels with efficiency > 22%, including logistics info.
-- Demonstrates: JSON_EXTRACT (via ->>), JOINs across 4 tables, Filtering.

SELECT 
    u.full_name AS Customer,
    u.country AS Location,
    p.product_name AS PV_Model,
    p.tech_specs->>'$.efficiency_percent' AS Efficiency_Pct,
    p.tech_specs->>'$.cell_type' AS Technology,
    o.order_date,
    l.carrier AS Logistics_Provider,
    l.delivery_status
FROM 
    users u
JOIN 
    orders o ON u.user_id = o.user_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
LEFT JOIN 
    logistics l ON o.order_id = l.order_id
WHERE 
    p.category = 'PV Module'
    AND CAST(p.tech_specs->>'$.efficiency_percent' AS DECIMAL(4,1)) > 22.0
ORDER BY 
    Efficiency_Pct DESC;


-- Query 2: Monthly Revenue Trend (CTE & Aggregation)
-- Goal: Calculate total revenue per month to track business growth.
-- Demonstrates: CTEs (Common Table Expressions), Date Formatting, Aggregation.

WITH MonthlyRevenue AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS Revenue_Month,
        COUNT(order_id) AS Total_Orders,
        SUM(total_amount) AS Total_Revenue
    FROM 
        orders
    WHERE 
        status != 'Cancelled'
    GROUP BY 
        DATE_FORMAT(order_date, '%Y-%m')
)
SELECT 
    Revenue_Month,
    Total_Orders,
    CONCAT('$', FORMAT(Total_Revenue, 2)) AS Formatted_Revenue
FROM 
    MonthlyRevenue
ORDER BY 
    Revenue_Month DESC;


-- Query 3: Supply Chain Visibility (4-Table Join for Relational Mapping)
-- Goal: Full trace of an order from user to logistics status for all 'Shipped' orders.
-- Demonstrates: INNER JOINs connecting the entire schema graph.

SELECT 
    o.order_id,
    u.full_name,
    u.city,
    COUNT(oi.item_id) AS Items_Count,
    SUM(oi.quantity) AS Total_Items_Qty,
    o.total_amount,
    l.tracking_number,
    l.delivery_status
FROM 
    orders o
JOIN 
    users u ON o.user_id = u.user_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    logistics l ON o.order_id = l.order_id
WHERE 
    l.delivery_status IN ('Shipped', 'In Transit', 'Delivered')
GROUP BY 
    o.order_id, u.full_name, u.city, o.total_amount, l.tracking_number, l.delivery_status
ORDER BY 
    o.order_date DESC
LIMIT 10;
