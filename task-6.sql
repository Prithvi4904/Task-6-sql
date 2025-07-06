-- Cleanup: Drop tables if they already exist
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(100)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample data into Customers
INSERT INTO Customers (CustomerID, Name, City) VALUES
(1, 'Alice', 'Boston'),
(2, 'Bob', 'New York'),
(3, 'Charlie', 'Chicago'),
(4, 'David', 'Miami');

-- Insert sample data into Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, Amount) VALUES
(101, 1, '2024-01-10', 250.00),
(102, 2, '2024-02-15', 450.00),
(103, 1, '2024-03-01', 300.00),
(104, 3, '2024-04-10', 150.00),
(105, 5, '2024-05-01', 500.00);  -- Invalid customer (to test logic)

-- 1️⃣ Subquery in SELECT: Show each customer's total amount spent
SELECT 
    Name,
    (SELECT SUM(Amount) FROM Orders WHERE Orders.CustomerID = Customers.CustomerID) AS TotalSpent
FROM Customers;

-- 2️⃣ Subquery in WHERE with IN: Customers who have placed orders
SELECT Name
FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders);

-- 3️⃣ Subquery in WHERE with EXISTS: Customers who have placed at least one order
SELECT Name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);

-- 4️⃣ Scalar subquery using = : Customers whose total order amount is more than 400
SELECT Name
FROM Customers
WHERE (
    SELECT SUM(Amount) FROM Orders WHERE Orders.CustomerID = Customers.CustomerID
) > 400;

-- 5️⃣ Correlated subquery in FROM: Find average order amount per customer
SELECT 
    c.Name,
    order_summary.AvgAmount
FROM Customers c
JOIN (
    SELECT CustomerID, AVG(Amount) AS AvgAmount
    FROM Orders
    GROUP BY CustomerID
) AS order_summary
ON c.CustomerID = order_summary.CustomerID;

-- 6️⃣ Subquery in FROM: Top spender among all customers
SELECT *
FROM (
    SELECT CustomerID, SUM(Amount) AS TotalSpent
    FROM Orders
    GROUP BY CustomerID
) AS Spending
ORDER BY TotalSpent DESC
LIMIT 1;
