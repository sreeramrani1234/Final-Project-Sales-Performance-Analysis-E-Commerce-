create database sales_performence_ecommerce;
use sales_performence_ecommerce;
describe indian_ecommerce_2000;
select * from indian_ecommerce_2000;
CREATE TABLE Customers (                               
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100)
);
describe customers;
select * from customers;
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_category VARCHAR(100),
     unit_price DECIMAL(10,2),
    product_name VARCHAR(100)
);
describe products;
select * from products;
CREATE TABLE Orders (
    order_id INT primary key,
    order_date date,
    product_name VARCHAR(100),
    customer_name VARCHAR(100),
    discount_percentage DECIMAL(5,2),
    payment_mode VARCHAR(100),
    quantity INT
);
   describe orders; 
   select * from orders;

CREATE TABLE sales(
 order_id  INT PRIMARY KEY,
 product_id INT,
 customer_id INT,
 quantity INT,
 discount_percent DECIMAL(5,2),
 total_amount DECIMAL(12,2),
 profit DECIMAL(10,2)
);
 describe sales; 
 select * from sales;
CREATE TABLE review(
    customer_id VARCHAR(100),
    product_id VARCHAR(100),
    rating INT CHECK (rating BETWEEN 1 AND 5));
   describe review ;
select * from review;


DELIMITER //
CREATE PROCEDURE GetTopProductCategoryProfit()
BEGIN
    SELECT product_category,SUM(profit) AS total_profit FROM indian_ecommerce_2000
	
    GROUP BY product_category
    ORDER BY total_profit DESC
    
    LIMIT 4;
END //
DELIMITER ;


CALL GetTopProductCategoryProfit();
 DELIMITER //
CREATE PROCEDURE GetTopDiscountCategory()
BEGIN
    SELECT 
        product_category,
        AVG(discount_percentage) AS avg_discount
    
    FROM orders o
    JOIN products p ON  o.product_name = p.product_name
    GROUP BY p.product_category
    ORDER BY avg_discount DESC
LIMIT 1;
END //   
DELIMITER ;
 CALL  GetTopDiscountCategory();  
DELIMITER //

CREATE PROCEDURE GetTopRatedProduct()
BEGIN
    SELECT 
      p . product_name,
      p . product_category,
      r.  rating
    FROM Products p
    JOIN review r ON  p.product_id = r.product_id
    WHERE r.rating = (
        SELECT MAX(rating) FROM products
    );
  END //      
  DELIMITER ;
 CALL GetTopRatedProduct(); 
 DELIMITER //

CREATE PROCEDURE AvgProductsPerCustomer()
BEGIN
    SELECT 
        AVG(total_products) AS avg_products_per_customer
    FROM (
        SELECT 
            o.customer_name,
            SUM(o.quantity) AS total_products
        FROM orders o
        JOIN customers c 
            ON o.customer_name = c.customer_name
        GROUP BY o.customer_name
    ) AS customer_totals;
END //
DELIMITER ;

DELIMITER ;
CALL AvgProductsPerCustomer();
CALL GetTopProductCategoryProfit();
Delimiter $$
CREATE PROCEDURE GetSalesInsights()
BEGIN
    -- 1️⃣ Top 5 products by sales
    SELECT 
        p.product_name,
        SUM(o.quantity * p.unit_price) AS total_sales
    FROM orders o
    JOIN products p ON o.product_name = p.product_name
    GROUP BY p.product_name
    ORDER BY total_sales DESC
    LIMIT 5;

    -- 2️⃣ Monthly sales trend
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(o.quantity * p.unit_price) AS total_sales
    FROM orders o
    JOIN products p ON o.product_name = p.product_name
    GROUP BY month
    ORDER BY month;
END $$
Delimiter ;
CALL GetSalesInsights();
DELIMITER //
CREATE PROCEDURE GetMonthlySalesTrend()
BEGIN
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(o.quantity * p.unit_price) AS total_sales
    FROM orders o
    JOIN products p ON o.product_name = p.product_name
    GROUP BY month
    ORDER BY month;
END //
DELIMITER ;
CALL GetMonthlySalesTrend();
DELIMITER $$

CREATE PROCEDURE GetTotalRevenue()
BEGIN
    SELECT SUM(total_amount) AS total_revenue
    FROM sales;
END $$

DELIMITER ;
CALL GetTotalRevenue();
DELIMITER $$

DELIMITER $$
DELIMITER $$

CREATE PROCEDURE yearly_sales()
BEGIN
    SELECT 
        YEAR(o.order_date) AS order_year,
        SUM(s.total_amount) AS total_sales
    FROM orders o
    JOIN sales s USING(order_id)
    GROUP BY YEAR(o.order_date)
    ORDER BY YEAR(o.order_date);
END $$

DELIMITER ;
CALL yearly_sales();






























CALL YearlySales();

    





    
   
    
   
