SELECT customerName, country, phone FROM customers WHERE country = 'USA' ORDER BY customerName;

SELECT c.customerName, SUM(p.amount) AS total_paid
FROM customers c JOIN payments p ON c.customerNumber = p.customerNumber GROUP BY c.customerName ORDER BY total_paid DESC;

-- Product-level order summary
SELECT o.orderNumber, p.productName, od.quantityOrdered, od.priceEach
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
LIMIT 10;

SELECT customerName
FROM customers
WHERE customerNumber = (SELECT customerNumber FROM payments GROUP BY customerNumber ORDER BY SUM(amount) DESC LIMIT 1);

-- View of all orders with their sales rep
CREATE VIEW order_with_sales_rep AS
SELECT o.orderNumber, o.orderDate, c.customerName, e.firstName AS salesRepFirst, e.lastName AS salesRepLast FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber;
SELECT * FROM order_with_sales_rep LIMIT 5;
SELECT * FROM order_with_sales_rep LIMIT 10;

CREATE INDEX idx_customerNumber ON payments(customerNumber);
 -- to see how the index helps we join:
SELECT c.customerName, SUM(p.amount) AS total_paid FROM customers c JOIN payments p ON 
c.customerNumber= p.customerNumber GROUP BY c.customerName Limit 12;

-- using explain to showcase the use of index
EXPLAIN
SELECT c.customerName, SUM(p.amount) AS total_paid
FROM customers c
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerName;

-- show the bestselling products by total revenue
SELECT p.productName, SUM(od.quantityOrdered *od.priceEach) AS total_revenue FROM orderdetails od JOIN products p ON od.productCode = p.productCode
GROUP BY p.productName
ORDER BY total_revenue DESC LIMIT 5;
