use hr_db;
SELECT 
    department_id,
    COUNT(employee_id) AS total_employees,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id
HAVING COUNT(employee_id) > 5 
   AND AVG(salary) >6000;
   

CREATE DATABASE sales_db;
USE sales_db;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY, 
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE orders (
    order_id     INT AUTO_INCREMENT PRIMARY KEY, -- Use SERIAL PRIMARY KEY in PostgreSQL
    customer_id  INT NOT NULL,
    order_date   DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    status       VARCHAR(20) DEFAULT 'Completed',
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'Alice', 'Smith', 'alice@example.com'),
(2, 'Bob', 'Jones', 'bob@example.com'),
(3, 'Charlie', 'Brown', 'charlie@example.com');

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2026-03-01', 149.99),
(102, 1, '2026-03-15', 75.50),
(103, 2, '2026-04-02', 210.00);

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id;
    

CREATE DATABASE agency_db;
USE agency_db;


CREATE TABLE agents (
    agent_id   INT AUTO_INCREMENT PRIMARY KEY, -- Use SERIAL PRIMARY KEY in PostgreSQL
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    region     VARCHAR(50) NOT NULL
);


CREATE TABLE deals (
    deal_id     INT AUTO_INCREMENT PRIMARY KEY, 
    agent_id    INT NOT NULL,
    deal_amount DECIMAL(10, 2) NOT NULL CHECK (deal_amount >= 0),
    close_date  DATE NOT NULL,
    CONSTRAINT fk_agent
        FOREIGN KEY (agent_id) 
        REFERENCES agents(agent_id) 
        ON DELETE CASCADE
);

INSERT INTO agents (agent_id, first_name, last_name, email, region) VALUES
(1, 'Sarah', 'Connor', 'sarah@agency.com', 'North'),
(2, 'James', 'Bond',   'james@agency.com', 'West'),
(3, 'Ethan', 'Hunt',   'ethan@agency.com', 'East'),
(4, 'Jason', 'Bourne', 'jason@agency.com', 'South');


INSERT INTO deals (deal_id, agent_id, deal_amount, close_date) VALUES
(101, 1, 80000.00, '2026-01-10'),
(102, 1, 45000.00, '2026-02-14'),
(103, 2, 120000.00, '2026-03-01'),
(104, 3, 25000.00, '2026-03-20');

SELECT 
    agent_id,
    first_name,
    last_name,
    region
FROM agents
WHERE agent_id IN (
    -- Subquery returns a dynamic set of qualifying agent IDs
    SELECT DISTINCT agent_id
    FROM deals
    WHERE deal_amount > 50000
);


CREATE DATABASE restaurant_analytics;
use restaurant_analytics; 


CREATE TABLE restaurant_revenue (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    total_revenue NUMERIC(10, 2) NOT NULL
);

-
INSERT INTO restaurant_revenue (restaurant_id, restaurant_name, total_revenue)
VALUES
    (101, 'Bistro Alpha', 50000.00),
    (102, 'Trattoria Beta', 50000.00),
    (103, 'Cafe Gamma',    35000.00);

SELECT
    restaurant_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS rank_val,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS dense_rank_val
FROM restaurant_revenue;


CREATE DATABASE customer_analytics;
use customer_analytics;


CREATE TABLE customer_spend (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    total_spend NUMERIC(10, 2) NOT NULL
);


INSERT INTO customer_spend (customer_id, customer_name, total_spend)
VALUES
    (1, 'Aarav Sharma',  5000.00),
    (2, 'Priya Patel',  12000.00),
    (3, 'Rohan Mehta',   2500.00),
    (4, 'Ananya Iyer',    800.00);
    
SELECT 
    customer_name,
    total_spend,
    CASE 
        WHEN total_spend >= 10000 THEN 'Platinum'
        WHEN total_spend >= 5000  THEN 'Gold'
        WHEN total_spend >= 1000  THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_tier
FROM customer_spend;


CREATE DATABASE ecommerce_db;
use ecommerce_db;


CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO customers (full_name, email, status) VALUES
('Alice Smith', 'alice@example.com', 'active'),
('Bob Jones', 'bob@example.com', 'inactive'),
('Charlie Brown', 'charlie@example.com', 'active'),
('Diana Prince', 'diana@example.com', 'pending');


SELECT * FROM customers WHERE email = 'bob@example.com';


CREATE INDEX idx_customers_email ON customers (email);

EXPLAIN ANALYZE SELECT * FROM customers WHERE email = 'bob@example.com';


-- 1. Create the food_orders table
CREATE TABLE food_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    restaurant_name VARCHAR(100) NOT NULL,
    item_ordered VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    price_per_item DECIMAL(10, 2) NOT NULL,
    order_date DATE NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- 2. Insert sample rows (8 rows across Mumbai, Delhi, and Bengaluru)
INSERT INTO food_orders (order_id, customer_name, restaurant_name, item_ordered, quantity, price_per_item, order_date, city)
VALUES
    (101, 'Aarav Sharma', 'Bastian', 'Lobster Roll', 1, 1450.00, '2026-03-01', 'Mumbai'),
    (102, 'Priya Patel', 'Britannia & Co.', 'Berry Pulao', 2, 550.00, '2026-03-02', 'Mumbai'),
    (103, 'Rohan Verma', 'Karim''s', 'Mutton Korma', 3, 420.00, '2026-03-03', 'Delhi'),
    (104, 'Sneha Rao', 'Vidyarthi Bhavan', 'Masala Dosa', 4, 90.00, '2026-03-04', 'Bengaluru'),
    (105, 'Vikram Malhotra', 'The Bombay Canteen', 'Pork Ribs', 2, 850.00, '2026-03-05', 'Mumbai'),
    (106, 'Ananya Das', 'Indian Accent', 'Tasting Menu Platter', 1, 3500.00, '2026-03-06', 'Delhi'),
    (107, 'Karan Mehta', 'Truffles', 'All American Burger', 2, 320.00, '2026-03-07', 'Bengaluru'),
    (108, 'Neha Kulkarni', 'Bastian', 'Burrata Salad', 1, 750.00, '2026-03-08', 'Mumbai');

-- Query 1: Retrieve all orders placed in 'Mumbai', sorted by price_per_item descending
SELECT *
FROM food_orders
WHERE city = 'Mumbai'
ORDER BY price_per_item DESC;

-- Query 2: Return all distinct restaurant names with at least one order
SELECT DISTINCT restaurant_name
FROM food_orders;

-- Query 3: List the top 5 most expensive individual orders (total order value = quantity * price_per_item)
SELECT 
    order_id,
    customer_name,
    restaurant_name,
    item_ordered,
    quantity,
    price_per_item,
    (quantity * price_per_item) AS total_order_amount
FROM food_orders
ORDER BY total_order_amount DESC
LIMIT 5;


CREATE TABLE delivery_orders (
    order_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL
);

INSERT INTO delivery_orders (order_id, restaurant_name, city, total_amount, order_status, order_date)
VALUES
    (1, 'The Bombay Canteen', 'Mumbai', 3200.00, 'Delivered', '2026-10-01'),
    (2, 'The Bombay Canteen', 'Mumbai', 4500.00, 'Delivered', '2026-10-02'),
    (3, 'The Bombay Canteen', 'Mumbai', 3800.00, 'Delivered', '2026-10-05'),
    (4, 'Indian Accent', 'Delhi', 5500.00, 'Delivered', '2026-10-02'),
    (5, 'Indian Accent', 'Delhi', 6200.00, 'Delivered', '2026-10-06'),
    (6, 'Karim''s', 'Delhi', 1800.00, 'Delivered', '2026-10-03'),
    (7, 'Karim''s', 'Delhi', 2400.00, 'Delivered', '2026-10-07'),
    (8, 'Karim''s', 'Delhi', 2100.00, 'Delivered', '2026-10-09'),
    (9, 'Truffles', 'Bengaluru', 1200.00, 'Delivered', '2026-10-04'),
    (10, 'Truffles', 'Bengaluru', 1500.00, 'Delivered', '2026-10-08');


SELECT 
    restaurant_name,
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM delivery_orders
GROUP BY restaurant_name;


SELECT 
    restaurant_name,
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM delivery_orders
GROUP BY restaurant_name
HAVING SUM(total_amount) > 5000;

SELECT 
    restaurant_name,
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_amount), 2) AS average_order_value,
    CASE 
        WHEN SUM(total_amount) > 10000 THEN 'High Revenue'
        ELSE 'Moderate Revenue'
    END AS revenue_category
FROM delivery_orders
GROUP BY restaurant_name
HAVING SUM(total_amount) > 5000
ORDER BY total_revenue DESC;

-- 1. Create Tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);


INSERT INTO customers (customer_id, name, city, phone)
VALUES
    (1, 'Aarav Sharma', 'Mumbai', '9820112233'),
    (2, 'Priya Patel', 'Ahmedabad', '9898223344'),
    (3, 'Rohan Verma', 'Delhi', '9811334455'),
    (4, 'Sneha Rao', 'Bengaluru', '9845445566'),
    (5, 'Vikram Malhotra', 'Mumbai', '9820556677'),    -- No orders
    (6, 'Ananya Iyer', 'Chennai', '9840667788');       -- No orders

INSERT INTO restaurants (restaurant_id, name, cuisine_type, city)
VALUES
    (101, 'The Bombay Canteen', 'Modern Indian', 'Mumbai'),
    (102, 'Agashiye', 'Gujarati', 'Ahmedabad'),
    (103, 'Karim''s', 'Mughlai', 'Delhi'),
    (104, 'Vidyarthi Bhavan', 'South Indian', 'Bengaluru'),
    (105, 'Bastian', 'Seafood', 'Mumbai'),
    (106, 'Indian Accent', 'Contemporary Indian', 'Delhi');

INSERT INTO orders (order_id, customer_id, restaurant_id, amount, order_date)
VALUES
    (1001, 1, 101, 2450.00, '2026-10-01'), -- Mumbai customer, Mumbai restaurant
    (1002, 2, 102, 1800.00, '2026-10-02'), -- Ahmedabad customer, Ahmedabad restaurant
    (1003, 3, 103, 1250.00, '2026-10-03'), -- Delhi customer, Delhi restaurant
    (1004, 4, 104, 650.00,  '2026-10-04'), -- Bengaluru customer, Bengaluru restaurant
    (1005, 1, 103, 3200.00, '2026-10-05'), -- Mumbai customer, Delhi restaurant (different city)
    (1006, 2, 101, 2900.00, '2026-10-06'); -- Ahmedabad customer, Mumbai restaurant (different city)


SELECT 
    o.order_id,
    c.name AS customer_name,
    r.name AS restaurant_name,
    o.amount,
    o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id;


SELECT 
    c.customer_id,
    c.name AS customer_name,
    c.city AS customer_city,
    o.order_id,
    o.restaurant_id,
    o.amount,
    o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;


SELECT 
    o.order_id,
    c.name AS customer_name,
    c.city AS customer_city,
    r.name AS restaurant_name,
    r.city AS restaurant_city,
    o.amount,
    o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE c.city = r.city;

-- 1. Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Restaurants Table
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    rating DECIMAL(2, 1) CHECK (rating >= 1.0 AND rating <= 5.0)
);

-- 3. Delivery Agents Table
CREATE TABLE delivery_agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    city VARCHAR(50) NOT NULL,
    vehicle_type VARCHAR(30) NOT NULL
);

-- 4. Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    agent_id INT NOT NULL,
    order_timestamp TIMESTAMP NOT NULL,
    delivered_timestamp TIMESTAMP,
    order_amount DECIMAL(10, 2) NOT NULL CHECK (order_amount >= 0),
    order_status VARCHAR(20) DEFAULT 'Delivered',
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_orders_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    CONSTRAINT fk_orders_agent FOREIGN KEY (agent_id) REFERENCES delivery_agents(agent_id)
);

-- Customers (12 rows across Mumbai, Bangalore, Delhi)
INSERT INTO customers (customer_id, customer_name, email, phone, city) VALUES
(1, 'Aarav Sharma', 'aarav.s@example.com', '9820012345', 'Mumbai'),
(2, 'Priya Nair', 'priya.n@example.com', '9845012345', 'Bangalore'),
(3, 'Rohan Mehta', 'rohan.m@example.com', '9811012345', 'Delhi'),
(4, 'Ananya Iyer', 'ananya.i@example.com', '9820054321', 'Mumbai'),
(5, 'Vikram Malhotra', 'vikram.m@example.com', '9811054321', 'Delhi'),
(6, 'Sneha Rao', 'sneha.r@example.com', '9845054321', 'Bangalore'),
(7, 'Aditya Verma', 'aditya.v@example.com', '9820098765', 'Mumbai'),
(8, 'Neha Kapoor', 'neha.k@example.com', '9811098765', 'Delhi'),
(9, 'Karthik Subbaraj', 'karthik.s@example.com', '9845098765', 'Bangalore'),
(10, 'Pooja Hegde', 'pooja.h@example.com', '9820011223', 'Mumbai'),
(11, 'Kabir Sen', 'kabir.s@example.com', '9811022334', 'Delhi'),
(12, 'Tanvi Deshmukh', 'tanvi.d@example.com', '9820033445', 'Mumbai');

-- Restaurants (12 rows across Mumbai, Bangalore, Delhi)
INSERT INTO restaurants (restaurant_id, restaurant_name, cuisine_type, city, rating) VALUES
(101, 'Bastian', 'Seafood', 'Mumbai', 4.6),
(102, 'Trishna', 'Coastal Indian', 'Mumbai', 4.5),
(103, 'The Bombay Canteen', 'Modern Indian', 'Mumbai', 4.7),
(104, 'Gajalee', 'Maharashtrian', 'Mumbai', 4.3),
(105, 'Toit Brewpub', 'Continental', 'Bangalore', 4.7),
(106, 'CTR Shri Sagar', 'South Indian', 'Bangalore', 4.6),
(107, 'Meghana Foods', 'Biryani', 'Bangalore', 4.4),
(108, 'Truffles', 'American Burgers', 'Bangalore', 4.5),
(109, 'Bukhara', 'North Indian', 'Delhi', 4.8),
(110, 'Karim''s', 'Mughlai', 'Delhi', 4.4),
(111, 'Saravana Bhavan', 'South Indian', 'Delhi', 4.2),
(112, 'Indian Accent', 'Contemporary Indian', 'Delhi', 4.9);

-- Delivery Agents (10 rows)
INSERT INTO delivery_agents (agent_id, agent_name, phone, city, vehicle_type) VALUES
(201, 'Ramesh Patil', '9167000001', 'Mumbai', 'Motorcycle'),
(202, 'Sunil Kamble', '9167000002', 'Mumbai', 'Electric Scooter'),
(203, 'Ganesh Gaikwad', '9167000003', 'Mumbai', 'Motorcycle'),
(204, 'Manjunath Reddy', '9740000001', 'Bangalore', 'Electric Scooter'),
(205, 'Suresh Gowda', '9740000002', 'Bangalore', 'Motorcycle'),
(206, 'Harish Kumar', '9740000003', 'Bangalore', 'Bicycle'),
(207, 'Amit Singh', '9910000001', 'Delhi', 'Motorcycle'),
(208, 'Deepak Yadav', '9910000002', 'Delhi', 'Motorcycle'),
(209, 'Rajesh Sharma', '9910000003', 'Delhi', 'Electric Scooter'),
(210, 'Kuldeep Rawat', '9910000004', 'Delhi', 'Motorcycle');

-- Orders (20 rows: mixes recent orders and older baseline records)
INSERT INTO orders (order_id, customer_id, restaurant_id, agent_id, order_timestamp, delivered_timestamp, order_amount, order_status) VALUES
(1001, 1, 101, 201, CURRENT_TIMESTAMP - INTERVAL '1 day 2 hours',  CURRENT_TIMESTAMP - INTERVAL '1 day 1 hour 25 minute', 2450.00, 'Delivered'),
(1002, 2, 105, 204, CURRENT_TIMESTAMP - INTERVAL '1 day 5 hours',  CURRENT_TIMESTAMP - INTERVAL '1 day 4 hours 20 minute', 1850.00, 'Delivered'),
(1003, 3, 109, 207, CURRENT_TIMESTAMP - INTERVAL '2 days 3 hours', CURRENT_TIMESTAMP - INTERVAL '2 days 2 hours 15 minute', 3200.00, 'Delivered'),
(1004, 1, 103, 202, CURRENT_TIMESTAMP - INTERVAL '2 days 6 hours', CURRENT_TIMESTAMP - INTERVAL '2 days 5 hours 18 minute', 1900.00, 'Delivered'),
(1005, 4, 101, 203, CURRENT_TIMESTAMP - INTERVAL '3 days 1 hour',  CURRENT_TIMESTAMP - INTERVAL '3 days 20 minute',         1450.00, 'Delivered'),
(1006, 5, 110, 208, CURRENT_TIMESTAMP - INTERVAL '3 days 4 hours', CURRENT_TIMESTAMP - INTERVAL '3 days 3 hours 25 minute',  950.00, 'Delivered'),
(1007, 6, 107, 205, CURRENT_TIMESTAMP - INTERVAL '4 days 2 hours', CURRENT_TIMESTAMP - INTERVAL '4 days 1 hour 15 minute', 1200.00, 'Delivered'),
(1008, 2, 105, 204, CURRENT_TIMESTAMP - INTERVAL '4 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '4 days 7 hours 10 minute', 2100.00, 'Delivered'),
(1009, 7, 102, 201, CURRENT_TIMESTAMP - INTERVAL '5 days 2 hours', CURRENT_TIMESTAMP - INTERVAL '5 days 1 hour 30 minute', 3100.00, 'Delivered'),
(1010, 8, 112, 209, CURRENT_TIMESTAMP - INTERVAL '5 days 5 hours', CURRENT_TIMESTAMP - INTERVAL '5 days 4 hours 10 minute', 4800.00, 'Delivered'),
(1011, 1, 101, 202, CURRENT_TIMESTAMP - INTERVAL '6 days 1 hour',  CURRENT_TIMESTAMP - INTERVAL '6 days 15 minute',         1650.00, 'Delivered'),
(1012, 9, 106, 206, CURRENT_TIMESTAMP - INTERVAL '6 days 4 hours', CURRENT_TIMESTAMP - INTERVAL '6 days 3 hours 20 minute',  450.00, 'Delivered'),
(1013, 3, 109, 207, CURRENT_TIMESTAMP - INTERVAL '8 days 2 hours', CURRENT_TIMESTAMP - INTERVAL '8 days 1 hour 10 minute', 2800.00, 'Delivered'),
(1014, 5, 110, 210, CURRENT_TIMESTAMP - INTERVAL '9 days 3 hours', CURRENT_TIMESTAMP - INTERVAL '9 days 2 hours 20 minute', 1350.00, 'Delivered'),
(1015, 4, 101, 203, CURRENT_TIMESTAMP - INTERVAL '10 days 1 hour', CURRENT_TIMESTAMP - INTERVAL '10 days 25 minute',        2200.00, 'Delivered'),
(1016, 2, 105, 205, CURRENT_TIMESTAMP - INTERVAL '11 days 2 hours',CURRENT_TIMESTAMP - INTERVAL '11 days 1 hour 18 minute', 1600.00, 'Delivered'),
(1017, 10, 104, 201, CURRENT_TIMESTAMP - INTERVAL '12 days 5 hours',CURRENT_TIMESTAMP - INTERVAL '12 days 4 hours 15 minute', 850.00, 'Delivered'),
(1018, 1, 101, 202, CURRENT_TIMESTAMP - INTERVAL '13 days 3 hours',CURRENT_TIMESTAMP - INTERVAL '13 days 2 hours 20 minute', 1750.00, 'Delivered'),
(1019, 2, 105, 204, CURRENT_TIMESTAMP - INTERVAL '14 days 4 hours',CURRENT_TIMESTAMP - INTERVAL '14 days 3 hours 15 minute', 2300.00, 'Delivered'),
(1020, 11, 112, 209, CURRENT_TIMESTAMP - INTERVAL '15 days 1 hour',CURRENT_TIMESTAMP - INTERVAL '15 days 20 minute',        5200.00, 'Delivered');


SELECT 
    r.restaurant_id,
    r.restaurant_name,
    r.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_revenue,
    ROUND(AVG(o.order_amount), 2) AS avg_order_value
FROM restaurants r
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY 
    r.restaurant_id, 
    r.restaurant_name, 
    r.city
HAVING 
    COUNT(o.order_id) > 3
ORDER BY 
    total_revenue DESC;
    
    
CREATE TABLE orders (
    order_id            INT PRIMARY KEY,
    agent_id            INT NOT NULL,
    city                VARCHAR(50) NOT NULL,
    status              VARCHAR(20) NOT NULL, -- e.g.,
    order_placed_at     TIMESTAMP NOT NULL,
    delivered_at        TIMESTAMP            
);

WITH qualified_agents AS (
    SELECT
        city,
        agent_id,
        COUNT(order_id) AS completed_orders,
        -- Average duration in minutes, filtering for valid timestamp intervals
        AVG(
            CASE 
                WHEN delivered_at >= order_placed_at 
                THEN EXTRACT(EPOCH FROM (delivered_at - order_placed_at)) / 60.0 
                ELSE NULL 
            END
        ) AS avg_delivery_time_mins
    FROM orders
    WHERE status = 'completed'
      AND delivered_at IS NOT NULL
    GROUP BY city, agent_id
    HAVING COUNT(order_id) > 5
),
ranked_agents AS (
    SELECT
        city,
        agent_id,
        completed_orders,
        ROUND(avg_delivery_time_mins::NUMERIC, 2) AS avg_delivery_time_mins,
        DENSE_RANK() OVER (
            PARTITION BY city
            ORDER BY completed_orders DESC, avg_delivery_time_mins ASC
        ) AS agent_rank
    FROM qualified_agents
)
SELECT
    city,
    agent_id,
    completed_orders,
    avg_delivery_time_mins,
    agent_rank
FROM ranked_agents
WHERE agent_rank <= 3
ORDER BY city ASC, agent_rank ASC;