-- https://replit.com/@henryprosser/Databases-Lab-2-Querying-Multiple-Tables#main.sql -- 

CREATE TABLE Item (
ItemName VARCHAR (30) NOT NULL,
ItemType CHAR(1) NOT NULL,
ItemColour VARCHAR(10),
PRIMARY KEY (ItemName));

.separator "\t"
.import item.txt Item

CREATE TABLE Employee (
EmployeeNumber SMALLINT UNSIGNED NOT NULL ,
EmployeeName VARCHAR(10) NOT NULL ,
EmployeeSalary INTEGER UNSIGNED NOT NULL ,
DepartmentName VARCHAR(10) NOT NULL REFERENCES Department,
BossNumber SMALLINT UNSIGNED NOT NULL REFERENCES Employee,
PRIMARY KEY (EmployeeNumber));

.separator "\t"
.import employee.txt Employee

CREATE TABLE Department (
DepartmentName VARCHAR(10) NOT NULL,
DepartmentFloor SMALLINT UNSIGNED NOT NULL,
DepartmentPhone SMALLINT UNSIGNED NOT NULL,
EmployeeNumber SMALLINT UNSIGNED NOT NULL REFERENCES
Employee,
PRIMARY KEY (DepartmentName));

.separator "\t"
.import department.txt Department

CREATE TABLE Sale (
SaleNumber INTEGER UNSIGNED NOT NULL,
SaleQuantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
ItemName VARCHAR(30) NOT NULL REFERENCES Item,
DepartmentName VARCHAR(10) NOT NULL REFERENCES Department,
PRIMARY KEY (SaleNumber));

.separator "\t"
.import sale.txt Sale

CREATE TABLE Supplier (
SupplierNumber INTEGER UNSIGNED NOT NULL,
SupplierName VARCHAR(30) NOT NULL,
PRIMARY KEY (SupplierNumber));

.separator "\t"
.import supplier.txt Supplier

CREATE TABLE Delivery (
DeliveryNumber INTEGER UNSIGNED NOT NULL,
DeliveryQuantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
ItemName VARCHAR(30) NOT NULL REFERENCES Item,
DepartmentName VARCHAR(10) NOT NULL REFERENCES Department,
SupplierNumber INTEGER UNSIGNED NOT NULL REFERENCES
Supplier,
PRIMARY KEY (DeliveryNumber));

.separator "\t"
.import delivery.txt Delivery

---------------------------------------------------------------------
-- Q1 --
.print "1.  What are the names of employees in the Marketing Department?"
SELECT EmployeeName
FROM Employee
WHERE Employee.DepartmentName = "Marketing";
.print

-- Q2 --
.print "2.  Find the average salary of the employees in the Clothes department."
SELECT AVG(EmployeeSalary)
FROM Employee
WHERE Employee.DepartmentName = "Clothes";
.print

-- Q3 --
.print "3.  List the items delivered by exactly one supplier (i.e. the items always delivered by the same supplier)."
SELECT ItemName
FROM Delivery
WHERE SupplierNumber
GROUP BY ItemName
HAVING COUNT(Delivery.SupplierNumber) = 1;
.print

-- Q4 --
.print "4.  List the departments for which each item delivered to the department is delivered to some other department as well."
SELECT DISTINCT(DepartmentName)
FROM Delivery
WHERE ItemName IN (SELECT ItemName FROM Delivery GROUP BY ItemName HAVING COUNT(DISTINCT DepartmentName) > 1);
.print

-- Q5 --
.print "5.  Among all the departments with a total salary greater than £25000, find the departments that sell Stetsons."
SELECT DISTINCT(DepartmentName)
FROM Employee
WHERE DepartmentName IN (SELECT DepartmentName FROM Employee GROUP BY DepartmentName HAVING SUM(EmployeeSalary) > 25000) 
AND DepartmentName IN (SELECT DepartmentName FROM Sale WHERE ItemName = "Stetson");
.print

-- Q6 --
.print "6.  Find the suppliers that deliver compasses and at least three other kinds of item."
SELECT DISTINCT Delivery.SupplierNumber, Supplier.SupplierName FROM (Supplier NATURAL JOIN Delivery)
WHERE SupplierNumber IN 
(SELECT SupplierNumber
FROM Delivery
WHERE ItemName <> 'Compass'
GROUP BY SupplierNumber
HAVING COUNT(DISTINCT ItemName >= 3))
AND SupplierNumber IN 
(SELECT SupplierNumber
FROM Delivery
WHERE ItemName = 'Compass');
.print




















