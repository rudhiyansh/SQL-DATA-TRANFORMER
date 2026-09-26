-- ============================================================
-- Project: DATA TRANFORMER 
-- ============================================================

CREATE DATABASE IF NOT EXISTS Data_Transformer;
USE Data_Transformer;

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY,
    FirstName VARCHAR (50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    RegistrationDate DATE 
);

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Employees (
	EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
    );


INSERT INTO Customers (CustomerID, FirstName, LastName, Email, RegistrationDate) VALUES
(1, 'John', 'Doe',   '  john.doe@email.com',   '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com  ', '2021-11-02'); 
 
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate, Salary) VALUES
(1, 'Mark',  'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee',     'HR',    '2021-03-20', 55000.00); 

-- Q1: INNER JOIN -- all orders and customer details where orders exist

SELECT o.OrderID , o.OrderDate , o.TotalAmount , c.CustomerID , c.FirstName , c.LastName 
FROM Orders o
INNER JOIN Customers c
ON o.CustomerID = c.CustomerID;


-- Q2: LEFT JOIN -- all customers and their orders (if any)

SELECT c.CustomerID , c.FirstName , c.LastName , o.OrderID , o.OrderDate , o.TotalAmount
FROM Orders o
LEFT JOIN Customers c 
ON o.CustomerID = c.CustomerID;


-- Q3: RIGHT JOIN -- all orders and their corresponding customers (if any)

SELECT o.OrderID , o.OrderDate , o.TotalAmount , c.CustomerID , c.FirstName , c.LastName 
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID ;

-- Q4: FULL OUTER JOIN -- all customers and all orders, regardless of match

SELECT c.CustomerID , c.FirstName , c.LastName , o.OrderID , o.OrderDate , o.TotalAmount
FROM Customers c 
LEFT JOIN Orders o 
ON c.CustomerID = o.CustomerID

UNION 

SELECT c.CustomerID , c.FirstName , c.LastName , o.OrderID , o.OrderDate , o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;


-- Q5: Subquery -- customers who have placed orders worth more than average

SELECT DISTINCT c.CustomerID , c.FirstName , c.LastName 
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID 
WHERE o.TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);

-- Q6: Subquery -- employees with salary above the average salary

SELECT EmployeeID , FirstName , LastName , salary 
FROM Employees 
WHERE Salary > (SELECT AVG(salary) FROM Employees);


-- Q7: Extract year and month from OrderDate

SELECT OrderID , YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth
FROM Orders ;

-- Q8: Difference in days between order date and current date

SELECT OrderID , OrderDate , DATEDIFF(CURDATE() , OrderDate ) AS DaySinceOrder
FROM Orders;

-- Q9: Format OrderDate to a more readable format (e.g. 'DD-MON-YYYY')

SELECT OrderID , DATE_FORMAT(OrderDate , "%d-%b-%Y") AS FromattedDate
FROM Orders ;

-- Q10: Concatenate FirstName and LastName to form a full name

SELECT CustomerID , CONCAT(FirstName , " " , LastName) AS FullName FROM Customers ;


-- Q11: Replace part of a string (e.g. replace 'John' with 'Jonathan')

SELECT CustomerID , FirstName , REPLACE(FirstName , "John" , "Jonathan" ) AS UpdatedName FROM Customers;


-- Q12: Convert FirstName to uppercase and LastName to lowercase

SELECT CustomerID , UPPER(FirstName) AS FirstName_Upper, LOWER(FirstName) AS FirstName_Lower FROM Customers;

-- Q13: Trim extra spaces from the Email field

SELECT CustomerID , Email , TRIM(Email) AS Email_Trimmed FROM Customers ;

-- Q14: Running total of TotalAmount for each order

SELECT OrderID , CustomerID , OrderDate , TotalAmount , SUM(TotalAmount) OVER (ORDER BY OrderDate , OrderID ) AS RunningTotal FROM Orders;

-- Q15: Rank orders based on TotalAmount using RANK()

SELECT OrderID , CustomerId , TotalAmount , RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank FROM Orders;

-- Q16: Assign a discount based on TotalAmount

SELECT OrderID , TotalAmount ,
	CASE 
		WHEN TotalAmount > 1000 THEN "10% off"
        WHEN TotalAmount > 500 THEN "5% off"
        ELSE "No discount"
	END AS DiscountTier
FROM Orders ;


-- Q17: Categorize employees' salaries as high, medium, or low


SELECT EmployeeID , FirstName , LastName , Salary ,
	CASE 
		WHEN Salary > 50000 THEN "High"
        WHEN Salary BETWEEN 30000 AND 50000 THEN "Medium"
        ELSE "Low"
	END AS SalaryCategory
FROM Employees ;




















