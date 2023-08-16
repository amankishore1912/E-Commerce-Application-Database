
create database E_Commerce;
use E_Commerce;

/* Creating user_details table */
create table user_details(
ID int NOT NULL,
username varchar(20) NOT NULL,
password varchar(20) NOT NULL,
First_Name varchar(50) NOT NULL,
Last_Name varchar(50),
Phone_No int NOT NULL,
Primary Key (ID));

/* Data is imported from other sources */

	select * from user_details

/* Creating user_address table */
create table user_address(
ID int Not null,
User_ID int not null,
Address_line1 varchar(50) NOT NULL,
City varchar(20) NOT Null,
Country varchar(20) not null,
Postal_Code int not null,
Primary key (ID),
Foreign Key (User_ID) references user_details(ID));

/* Data is imported from other sources */

	select * from user_address;
	alter table user_address
	add constraint FK_useraddress Foreign Key (User_ID) references user_details(ID);

/* Creating user_payment table */
create table user_payment(
ID int not null,
User_PID int not null,
Payment_Type varchar(20) not null,
Provider varchar(20),
Account_No int not null,
Primary Key (ID),
Foreign Key (User_PID) references user_details(ID));

/* Data is imported from other sources */

	select * from user_payment;
	alter table user_payment
	add constraint FK_UserPay Foreign Key (User_PID) references user_details(ID);

/* Creating Product_Category table */
create table Product_Category(
ID int not null,
Name varchar(30) not null,
Description Text,
Cat_Sales int not null,
Primary Key (ID));

/* Inserting values in Product_Category Table */
Insert into Product_Category(ID, Name, Description, Cat_Sales)
Values
	(101, 'Gadgets & Electronics', 'A category for electronic devices and gadgets', 250);
Insert into Product_Category(ID, Name, Description, Cat_Sales)
Values
	(102, 'Kitchen Appliances', 'A category for items used in Kitchen', 25);
Insert into Product_Category(ID, Name, Description, Cat_Sales)
Values
	(103, 'Home Decor', 'A category for the uses in households', 20);
Insert into Product_Category(ID, Name, Description, Cat_Sales)
Values
	(104, 'Vehicle Accessories','A category for Vehicles Products', 11);

	select * from Product_Category;

/* Product_Inventory Table data imported */
	select * from Product_Inventory;
/* Adding the Foreign Key Constraint to the table */ 
	alter table Product_Inventory
	add constraint FK_Pro_Inventory Foreign Key (Category_ID) references Product_Category(ID);

/* Product Table data imported */
	select * from Product;
/* Adding the Foreign Key Constraint to the table */ 	
	alter table Product  
	add constraint FK1_Product Foreign Key (Category_ID) references Product_Category(ID);

	alter table Product  
	add constraint FK2_Product Foreign Key (Inventory_ID) references Product_Inventory(ID);

/* Orders Table data imported */
	select * from Orders
/* Adding the Foreign Key Constraint to the table */ 	
	alter table Orders 
	add constraint FK_Orders Foreign Key (User_ID) references user_details(ID);
	

/* OrderItems Table data imported */
	select * from OrderItems;
/* Adding the Foreign Key Constraint to the table */ 	
	alter table OrderItems 
	add constraint FK1_OrderItems Foreign Key (Order_ID) references Orders(ID);
	
	alter table OrderItems 
	add constraint FK2_OrderItems Foreign Key (Product_ID) references Product(Prod_ID);


/* Payment Table data imported */
	select * from Payment;
/* Adding the Foreign Key Constraint to the table */ 	
	alter table Payment 
	add constraint FK_Payment Foreign Key (Order_ID) references Orders(ID);
	
/* Shipping_Details Table data imported */
	select * from Shipping_Details;
/* Adding the Foreign Key Constraint to the table */ 	
	alter table Shipping_Details 
	add constraint FK1_ShipDetails Foreign Key (Order_ID) references Orders(Ord_ID);
	
	alter table Shipping_Details 
	add constraint FK2_ShipDetails Foreign Key (User_Id) references user_details(ID);

	/*Task 1 and Task 2: Display all the tables populated with realitstic Data */
	select * from user_details
	select * from user_address
	select * from user_payment
	select * from Product_Category
	select * from Product_Inventory
	select * from Product
	select * from Orders
	select * from OrderItems
	select * from Payment
	select * from Shipping_Details


	/*Task 3: Performing CRUD Operations on the database */

	-- Insert a new product
INSERT INTO Product (Prod_ID, Description, SKU, Category_ID, Inventory_ID, Price)
VALUES (51, 'New Laptop', 'Powerful laptop with SSD', 'LAP123', 101, 251, 1299.99);


	-- Retrieve all products
SELECT * FROM Product;

-- Retrieve orders for a specific user
SELECT * FROM Orders WHERE User_ID = 12;

-- Update product price
UPDATE Product
SET Price = 1399.99
WHERE SKU = 'LAP123';

-- Update order status
UPDATE Orders
SET Order_Status = 'Shipped'
WHERE Ord_ID = 1005;

-- Delete a product
DELETE FROM Product
WHERE SKU = 'LAP123';

-- Delete an order
DELETE FROM Orders
WHERE Ord_ID = 1005;

-- Retrieve products with a specific category
SELECT * FROM Product
WHERE Category_ID = 2;

-- Retrieve shipping details for a specific user and region
SELECT * FROM Shipping_Details
WHERE User_ID = 123 AND Country = 'India';


	/* Advanced Queries */

	/* Finding Products with the highest Sales */
	SELECT TOP 10
    p.Name AS Product_Name,
    SUM(oi.Quantity) AS Total_Sales
FROM
    Product p
JOIN
    OrderItems oi ON p.Prod_ID = oi.Product_ID
GROUP BY
    p.Prod_ID, p.Name
ORDER BY
    Total_Sales DESC;

	/* Calculating Total Revenue between a specific time period */

	DECLARE @StartDate DATE = '2023-01-01';
	DECLARE @EndDate DATE = '2023-12-31';

	SELECT SUM(oi.Quantity * p.Price) AS Total_Revenue
	FROM Orders o
	JOIN
		OrderItems oi ON o.Ord_ID = oi.Order_ID
	JOIN
		Product p ON oi.Product_ID = p.Prod_ID
	WHERE o.Order_Date >= @StartDate AND o.Order_Date <= @EndDate;

	/* Query to identify the most active customers */
	SELECT TOP 10
    u.ID AS User_ID,
    u.First_Name,
    u.Last_Name,
    COUNT(o.Ord_ID) AS Total_Orders
	FROM
		user_details u
	JOIN
		Orders o ON u.ID = o.User_ID
	GROUP BY
		u.ID, u.First_Name, u.Last_Name
	ORDER BY
		Total_Orders DESC;


	/* Views have been Created */

	/* View 1 created */
	Go
	Create View List_of_Products
	As select a.Prod_ID, a.Name, a.Description, a.SKU, a.Category_ID, a.Price, b.Inv_ID, b. Quantity, b.Sales 
	from Product a
	full join Product_Inventory b
	on a.Inventory_ID = b.Inv_ID

	/* View 2 Created */
	Go
	CREATE VIEW MonthlySales AS
	SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(oi.Quantity * p.Price) AS Revenue,
    COUNT(o.Ord_ID) AS NumOrders,
    STRING_AGG(p.Name, ', ') AS TopProducts
	FROM
		Orders o
	JOIN
		OrderItems oi ON o.Ord_ID = oi.Order_ID
	JOIN
		Product p ON oi.Product_ID = p.Prod_ID
	GROUP BY
		YEAR(Order_Date), MONTH(Order_Date)

	/* View 3 Created */
	Go
	CREATE VIEW CustomerLoyalty AS
	SELECT
    u.ID AS Customer_ID,
    u.First_Name,
    u.Last_Name,
    COUNT(DISTINCT o.Ord_ID) AS NumOrders,
    SUM(oi.Quantity) AS TotalItemsPurchased,
    SUM(oi.Quantity * p.Price) AS TotalSpent
	FROM
		user_details u
	JOIN
		Orders o ON u.ID = o.User_ID
	JOIN
		OrderItems oi ON o.Ord_ID = oi.Order_ID
	JOIN
		Product p ON oi.Product_ID = p.Prod_ID
	GROUP BY
		u.ID, u.First_Name, u.Last_Name

	/* View 4 Created */
	Go
	CREATE VIEW ShippingPerformance AS
	SELECT
    o.Ord_ID AS Order_ID,
    o.Order_Date,
    s.Shipping_Date,
    DATEDIFF(day, o.Order_Date, s.Shipping_Date) AS DeliveryDays,
    CASE WHEN DATEDIFF(day, o.Order_Date, s.Shipping_Date) > o.Expected_Delivery_Days THEN 1 ELSE 0 END AS DelayedOrder
	FROM
		Orders o
	JOIN
		Shipping_Details s ON o.Ord_ID = s.Order_ID;


	/* Queries to display Views */
	select * from ShippingPerformance
	select * from MonthlySales
	select * from List_of_Products
	select * from CustomerLoyalty


	/* Data Analysis */
	
	/* Query to Identify the most popular product Category */
	SELECT TOP 5
    c.Name AS Category_Name,
    SUM(oi.Quantity) AS Total_Sales
	FROM
		Product_Category c
	JOIN
		Product p ON c.Cat_ID = p.Category_ID
	JOIN
		OrderItems oi ON p.Prod_ID = oi.Product_ID
	GROUP BY
		c.Cat_ID, c.Name
	ORDER BY
		Total_Sales DESC;


	/* Query to identify the region with the highest Sales */
	SELECT TOP 1 Country,
    SUM(oi.Quantity * p.Price) AS Total_Sales
	FROM
		Shipping_Details sd
	JOIN
		Orders o ON sd.Order_ID = o.Ord_ID
	JOIN
		OrderItems oi ON o.Ord_ID = oi.Order_ID
	JOIN
		Product p ON oi.Product_ID = p.Prod_ID
	GROUP BY
		Country
	ORDER BY
		Total_Sales DESC;



	/*Adding Security to the database */

-- Create roles
CREATE ROLE Admin;
CREATE ROLE Manager;
CREATE ROLE Customer;

-- Grant permissions to roles
GRANT SELECT, INSERT, UPDATE, DELETE ON Product TO Manager;
GRANT SELECT ON Product TO Customer;

GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO Manager;
GRANT SELECT, INSERT ON Orders TO Customer;

GRANT SELECT ON Shipping_Details TO Manager;
GRANT SELECT ON Shipping_Details TO Customer;

-- Assign users to roles
ALTER ROLE Admin ADD MEMBER [guest];   -- Replace [admin_user] with actual username
ALTER ROLE Manager ADD MEMBER [guest];
ALTER ROLE Customer ADD MEMBER [user1];
ALTER ROLE Customer ADD MEMBER [user2];



-- Create a view for restricted access to Product table
Go
CREATE VIEW SecureProductView AS
SELECT Prod_ID, Name, Price
FROM Product;

CREATE FUNCTION dbo.OrdersRowFilterPredicate(@User_ID INT)
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_securitypredicate_result
    WHERE @User_ID = USER_ID();

-- Create the security policy
CREATE SECURITY POLICY OrdersRLS
    ADD FILTER PREDICATE dbo.OrdersRowFilterPredicate(User_ID) ON dbo.Orders
    WITH (STATE = ON);


	/* Transaction and Rollbacks */

	--Safe Transaction without error

	BEGIN TRANSACTION;

DECLARE @NewOrderID INT;

-- Insert a new order
INSERT INTO Orders (Ord_ID, User_ID, Order_Date, Total_Amount, Order_Status, Expected_Delivery_Days)
VALUES (1042, 40, GETDATE(), 100.00, 'Pending', 5);

-- Get the ID of the newly inserted order
SET @NewOrderID = SCOPE_IDENTITY();

-- Insert order items
INSERT INTO OrderItems (OrderItem_ID, Order_ID, Product_ID, Quantity, Subtotal)
VALUES (341, @NewOrderID, 1, 2, 50.00);

-- If all inserts were successful, commit the transaction
COMMIT TRANSACTION;

	--Transaction that account error

	BEGIN TRANSACTION;

DECLARE @NewOrderID1 INT;

-- Insert a new order
INSERT INTO Orders (Ord_ID, User_ID, Order_Date, Total_Amount, Order_Status, Expected_Delivery_Days)
VALUES (1042, 40, GETDATE(), 100.00, 'Pending', 5);

-- Get the ID of the newly inserted order
SET @NewOrderID = SCOPE_IDENTITY();

-- Insert order items
INSERT INTO OrderItems (OrderItem_ID, Order_ID, Product_ID, Quantity, Subtotal)
VALUES (341, @NewOrderID, 1, 2, 50.00);

-- Simulate an error
ROLLBACK TRANSACTION;




	/* Creating Indexes for optimizing SQL Queries */

	CREATE INDEX IX_Product_Name_Price ON Product (Name, Price);

	CREATE INDEX IX_Orders_User_ID ON Orders (User_ID);
	CREATE INDEX IX_Orders_Order_Date ON Orders (Order_Date);
	CREATE INDEX IX_Orders_Order_Status ON Orders (Order_Status);

	CREATE INDEX IX_Shipping_Details_User_ID ON Shipping_Details (User_ID);
	CREATE INDEX IX_Shipping_Details_Region ON Shipping_Details (Country);

	CREATE UNIQUE NONCLUSTERED INDEX IX_User_Details_Username ON User_Details (Username);

	CREATE INDEX IX_User_Payment_User_ID ON User_Payment (User_PID);


	/* Backups */

	-- Full Backup
-- Full Backup
BACKUP DATABASE E_Commerce
TO DISK = 'C:\Backup\E_Commerce_Full.bak';

-- Transaction Log Backup
BACKUP LOG E_Commerce
TO DISK = 'E:\Backup\E_Commerce_Log.bak';



/* All the Queries had already been Executed that is why the red line showing on the Query Window.
There is no error in any of the commands */