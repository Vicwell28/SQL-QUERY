# Mostrar por región los productos  que mas ganancias obtuvieron en los tres ultimos años. 

# Forma la siguiente tabla  
# Categoria          2023                      2022                    2021
# Vegetales         Lechuga                  Lechuga         Brocoli 

import pandas as pd
from DatabaseConnection import DatabaseConnection

db_connection = DatabaseConnection()

db_connection.connect()


# Consulta SQL para obtener los totales por región y producto
query_totals = '''
SELECT
    r.regionDescription,
    p.productName,
    SUM(od.unitPrice * od.quantity * (1 - od.discount)) AS total
FROM
    orders o
    JOIN `order details` od ON o.orderId = od.orderId
    JOIN products p ON od.productId = p.productId
    JOIN employeeterritories et ON o.employeeId = et.employeeId
    JOIN territories t ON et.territoryId = t.territoryId
    JOIN region r ON t.regionId = r.regionId
GROUP BY
    r.regionDescription,
    p.productName
'''

results_totals = db_connection.execute_query(query_totals)

db_connection.disconnect()













































SELECT DATE_FORMAT(O.OrderDate, '%Y-%m-01') AS Periodo, P.ProductName, SUM(OD.Quantity) as Ventas 
FROM `order details` AS OD
INNER JOIN orders AS O ON O.OrderID = OD.OrderID
INNER JOIN products AS P ON P.ProductID = OD.ProductID
GROUP BY PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM O.OrderDate), '2010-01-01') DIV 3, OD.ProductID
ORDER BY Periodo;


SELECT SUM(Q1.Ventas) FROM 
(SELECT DATE_FORMAT(O.OrderDate, '%Y-%m-01') AS Periodo, P.ProductName, SUM(OD.Quantity) as Ventas 
FROM `order details` AS OD
INNER JOIN orders AS O ON O.OrderID = OD.OrderID
INNER JOIN products AS P ON P.ProductID = OD.ProductID
GROUP BY PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM O.OrderDate), '2010-01-01') DIV 3, OD.ProductID
ORDER BY Periodo
) AS Q1;

SELECT SUM(OD.Quantity)
FROM `order details` AS OD
INNER JOIN orders AS O ON O.OrderID = OD.OrderID
INNER JOIN products AS P ON P.ProductID = OD.ProductID;







 SELECT *
 FROM `order details` AS OD
 INNER JOIN orders AS O ON OD.OrderID = O.OrderID
 INNER JOIN (
 SELECT E.EmployeeID, R.RegionID FROM employees AS E
 INNER JOIN employeeterritories AS ET ON E.EmployeeID = ET.EmployeeID
 INNER JOIN territories AS T ON T.TerritoryID = ET.TerritoryID
 INNER JOIN region AS R ON R.RegionID = T.RegionID
 GROUP BY E.EmployeeID) AS Q1 ON Q1.EmployeeID = O.EmployeeID;
 
 
 
CREATE VIEW EmpleadoXRegion AS
 SELECT E.EmployeeID, R.RegionID, R.RegionDescription FROM employees AS E
 INNER JOIN employeeterritories AS ET ON E.EmployeeID = ET.EmployeeID
 INNER JOIN territories AS T ON T.TerritoryID = ET.TerritoryID
 INNER JOIN region AS R ON R.RegionID = T.RegionID
 GROUP BY E.EmployeeID;
 
SELECT * FROM EmpleadoXRegion;


SELECT 
OD.ProductID,
P.ProductName,
OD.Quantity, 
OD.UnitPrice, 
OD.Discount,
ER.EmployeeID, 
ER.RegionID, 
ER.RegionDescription
FROM `order details` AS OD
INNER JOIN products AS P ON P.ProductID = OD.ProductID
INNER JOIN orders AS O ON OD.OrderID = O.OrderID
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID;



##LOS PRODUCTOS CON MAYOR GANANCIA POR REGION
SELECT 
OD.ProductID,
P.ProductName,
OD.Quantity, 
OD.UnitPrice, 
OD.Discount,
ER.EmployeeID, 
ER.RegionID, 
ER.RegionDescription
FROM `order details` AS OD
INNER JOIN products AS P ON P.ProductID = OD.ProductID
INNER JOIN orders AS O ON OD.OrderID = O.OrderID
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID;



SELECT 
OD.ProductID,
P.ProductName,
SUM(OD.Quantity * OD.UnitPrice) AS Total, 
ER.EmployeeID, 
ER.RegionID, 
ER.RegionDescription
FROM `order details` AS OD
INNER JOIN products AS P ON P.ProductID = OD.ProductID
INNER JOIN orders AS O ON OD.OrderID = O.OrderID
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
GROUP BY ER.RegionID, OD.ProductID;


SELECT 
MAX(Q1.Total) AS Total
 FROM 
(
SELECT 
OD.ProductID,
P.ProductName,
SUM(OD.Quantity * OD.UnitPrice) AS Total, 
ER.EmployeeID, 
ER.RegionID, 
ER.RegionDescription
FROM `order details` AS OD
INNER JOIN products AS P ON P.ProductID = OD.ProductID
INNER JOIN orders AS O ON OD.OrderID = O.OrderID
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
GROUP BY ER.RegionID, OD.ProductID
) AS Q1
GROUP BY Q1.RegionID;



SELECT * FROM 
(
	SELECT 
	OD.ProductID,
	P.ProductName,
	SUM(OD.Quantity * OD.UnitPrice) AS Total, 
	ER.EmployeeID, 
	ER.RegionID, 
	ER.RegionDescription
	FROM `order details` AS OD
	INNER JOIN products AS P ON P.ProductID = OD.ProductID
	INNER JOIN orders AS O ON OD.OrderID = O.OrderID
	INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
	GROUP BY ER.RegionID, OD.ProductID
) AS Q1
INNER JOIN 
(
	SELECT 
	MAX(Q.Total) AS Total
	 FROM 
	(
		SELECT 
		OD.ProductID,
		P.ProductName,
		SUM(OD.Quantity * OD.UnitPrice) AS Total, 
		ER.EmployeeID, 
		ER.RegionID, 
		ER.RegionDescription
		FROM `order details` AS OD
		INNER JOIN products AS P ON P.ProductID = OD.ProductID
		INNER JOIN orders AS O ON OD.OrderID = O.OrderID
		INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
		GROUP BY ER.RegionID, OD.ProductID
	) AS Q
	GROUP BY Q.RegionID
) AS Q2 ON Q1.Total = Q2.Totalm;











# Mostrar el año en el obtuvo su mayor ganancia el producto mas vendido por región y categoria. 
SELECT 
P.ProductID,
P.ProductName, 
C.CategoryID, 
C.CategoryName,
O.EmployeeID, 
(OD.Quantity * OD.UnitPrice) AS Subtotal,
O.RequiredDate, 
ER.RegionID,
ER.RegionDescription
FROM `order details` AS OD
INNER JOIN products AS P ON P.ProductID = OD.ProductID
INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
INNER JOIN orders AS O ON OD.OrderID = O.OrderID
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID;




##SE OTIENENS LOS PRODUCTOS MAS VENDIDOS POR REGION Y CATEGORIA. 
## el producto mas vendido por región y categoria. 
DROP VIEW IF EXISTS ProductoMasVendidoXRegionXCategoria;
CREATE VIEW ProductoMasVendidoXRegionXCategoria AS
SELECT Q1.* FROM
(
	SELECT 
	P.ProductID,
	P.ProductName, 
	C.CategoryID, 
	C.CategoryName,
	O.EmployeeID, 
	SUM(OD.Quantity * OD.UnitPrice) AS Total,
	O.RequiredDate, 
	ER.RegionID,
	ER.RegionDescription
	FROM `order details` AS OD
	INNER JOIN orders AS O ON OD.OrderID = O.OrderID
	INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
	INNER JOIN products AS P ON P.ProductID = OD.ProductID
	INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
	GROUP BY ER.RegionID, C.CategoryID, P.ProductID
) AS Q1
INNER JOIN 
(
	SELECT 
    Q.RegionID, 
    Q.CategoryID,
	MAX(Q.Total) AS Total
	FROM 
	(
		SELECT 
		P.ProductID,
		P.ProductName, 
		C.CategoryID, 
		C.CategoryName,
		O.EmployeeID, 
		SUM(OD.Quantity * OD.UnitPrice) AS Total,
		O.RequiredDate, 
		ER.RegionID,
		ER.RegionDescription
		FROM `order details` AS OD
		INNER JOIN orders AS O ON OD.OrderID = O.OrderID
		INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
		INNER JOIN products AS P ON P.ProductID = OD.ProductID
		INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
		GROUP BY ER.RegionID, C.CategoryID, P.ProductID
	) AS Q
	GROUP BY Q.RegionID, Q.CategoryID
) AS Q2 
ON Q2.Total = Q1.Total AND Q2.RegionID = Q1.RegionID AND Q2.CategoryID = Q1.CategoryID;
 

##OBTENER LAS FECHAS DONE MAS SE VENDIO UN PRODUCTO PRO REGION Y CATEGORIA. 
## Mostrar el año en el obtuvo su mayor ganancia
##CREATE OR REPLACE VIEW FechasGananciasXProducto AS
SELECT 
Q1.ProductID,
MAX(Q1.Ganancia) AS Ganancia,
Q1.RequiredDate
FROM 
(
	SELECT 
	P.ProductID,
	P.ProductName, 
	C.CategoryID, 
	C.CategoryName,
	O.EmployeeID, 
	SUM(OD.Quantity * OD.UnitPrice) AS Ganancia,
	O.RequiredDate, 
	ER.RegionID,
	ER.RegionDescription
	FROM `order details` AS OD
	INNER JOIN products AS P ON P.ProductID = OD.ProductID
	INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
	INNER JOIN orders AS O ON OD.OrderID = O.OrderID
	INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
	GROUP BY P.ProductID, O.RequiredDate
) AS Q1 GROUP BY Q1.ProductID;


##VISTAS
SELECT * FROM FechasGananciasXProducto;
SELECT * FROM ProductoMasVendidoXRegionXCategoria;

SELECT 
    Q1.CategoryName,
    MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Eastern' THEN CONCAT(Q1.ProductName, YEAR(Q2.RequiredDate)) END) AS EasternRegion,
    MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Westerns' THEN CONCAT(Q1.ProductName, YEAR(Q2.RequiredDate)) END) AS WesternRegion,
    MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Northern' THEN CONCAT(Q1.ProductName, YEAR(Q2.RequiredDate)) END) AS NorthernRegion,
    MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Southern' THEN CONCAT(Q1.ProductName, YEAR(Q2.RequiredDate)) END) AS SouthernRegion
FROM ProductoMasVendidoXRegionXCategoria AS Q1
INNER JOIN FechasGananciasXProducto AS Q2 ON Q2.ProductID = Q1.ProductID
GROUP BY Q1.CategoryName;




##ULTIMA CONSULTA
##Mostrar por región los productos  que mas ganancias obtuvieron en los tres ultimos años. 
##Forma la siguiente tabla  
##Categoria          2023                      2022                    2021
##Vegetales         Lechuga                  Lechuga         Brocoli 















SELECT DISTINCT YEAR(O.OrderDate) 
FROM `order details` AS OD
INNER JOIN orders AS O ON OD.OrderID = O.OrderID
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
INNER JOIN products AS P ON P.ProductID = OD.ProductID
INNER JOIN categories AS C ON C.CategoryID = P.CategoryID


## 1998
## 1997
## 1996


SELECT DISTINCT YEAR(O.OrderDate) 
FROM `order details` AS OD
INNER JOIN orders AS O ON OD.OrderID = O.OrderID
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
INNER JOIN products AS P ON P.ProductID = OD.ProductID
INNER JOIN categories AS C ON C.CategoryID = P.CategoryID



SELECT SUM(OD.UnitPrice * OD.Quantity)
FROM `order details` AS OD;

SELECT SUM(Q.Ganancia)
FROM 
(
SELECT 
OD.ProductID,
P.ProductName,
C.CategoryID, 
C.CategoryName,
SUM(OD.Quantity * OD.UnitPrice) AS Ganancia,
YEAR(O.OrderDate),
ER.EmployeeID, 
ER.RegionID
FROM `order details` AS OD
INNER JOIN orders AS O ON OD.OrderID = O.OrderID
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
INNER JOIN products AS P ON P.ProductID = OD.ProductID
INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
GROUP BY ER.RegionID, C.CategoryID, P.ProductID, YEAR(O.OrderDate)
) AS Q 




##ARRIBA COMPORBACION



DROP VIEW IF EXISTS ProductoMasVendidoXRegionXCategoria;
CREATE VIEW ProductoMasVendidoXRegionXCategoria AS
SELECT Q1.* FROM
(
	SELECT 
	OD.ProductID,
	P.ProductName,
	C.CategoryID, 
	C.CategoryName,
	SUM(OD.Quantity * OD.UnitPrice) AS Ganancia,
	YEAR(O.OrderDate) AS OrderDate,
	ER.EmployeeID, 
	ER.RegionID
	FROM `order details` AS OD
	INNER JOIN orders AS O ON OD.OrderID = O.OrderID
	INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
	INNER JOIN products AS P ON P.ProductID = OD.ProductID
	INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
	GROUP BY ER.RegionID, C.CategoryID, OD.ProductID, YEAR(O.OrderDate)
) AS Q1
INNER JOIN 
(
	SELECT 
	Q.RegionID, 
    Q.CategoryID, 
    Q.OrderDate,
    MAX(Q.Ganancia) AS Ganancia
	FROM 
	(
		SELECT 
		OD.ProductID,
        P.ProductName,
		C.CategoryID, 
        C.CategoryName,
		SUM(OD.Quantity * OD.UnitPrice) AS Ganancia,
        YEAR(O.OrderDate) AS OrderDate,
		ER.EmployeeID, 
        ER.RegionID
        ER.Region
		FROM `order details` AS OD
		INNER JOIN orders AS O ON OD.OrderID = O.OrderID
		INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
		INNER JOIN products AS P ON P.ProductID = OD.ProductID
		INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
		GROUP BY ER.RegionID, C.CategoryID, OD.ProductID, YEAR(O.OrderDate)
	) AS Q
	GROUP BY Q.RegionID, Q.CategoryID, Q.OrderDate
) AS Q2 
ON Q2.Ganancia = Q1.Ganancia AND Q2.RegionID = Q1.RegionID AND Q2.CategoryID = Q1.CategoryID AND Q2.OrderDate = Q1.OrderDate;



























SELECT 
Q1.CategoryName, 
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Eastern' AND Q1.OrderDate = 1998 THEN Q1.ProductName END) AS '1998',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Eastern' AND Q1.OrderDate = 1997 THEN Q1.ProductName END) AS '1997',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Eastern' AND Q1.OrderDate = 1996 THEN Q1.ProductName END) AS '1996',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Westerns' AND Q1.OrderDate = 1998 THEN Q1.ProductName END) AS '1998',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Westerns' AND Q1.OrderDate = 1997 THEN Q1.ProductName END) AS '1997',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Westerns' AND Q1.OrderDate = 1996 THEN Q1.ProductName END) AS '1996',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Northern' AND Q1.OrderDate = 1998 THEN Q1.ProductName END) AS '1998',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Northern' AND Q1.OrderDate = 1997 THEN Q1.ProductName END) AS '1997',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Northern' AND Q1.OrderDate = 1996 THEN Q1.ProductName END) AS '1996',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Southern' AND Q1.OrderDate = 1998 THEN Q1.ProductName END) AS '1998',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Southern' AND Q1.OrderDate = 1997 THEN Q1.ProductName END) AS '1997',
MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Southern' AND Q1.OrderDate = 1996 THEN Q1.ProductName END) AS '1996'
FROM
(
	SELECT 
	OD.ProductID,
	P.ProductName,
	C.CategoryID, 
	C.CategoryName,
	SUM(OD.Quantity * OD.UnitPrice) AS Ganancia,
	YEAR(O.OrderDate) AS OrderDate,
	ER.EmployeeID, 
	ER.RegionID,
	ER.RegionDescription
	FROM `order details` AS OD
	INNER JOIN orders AS O ON OD.OrderID = O.OrderID
	INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
	INNER JOIN products AS P ON P.ProductID = OD.ProductID
	INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
	GROUP BY ER.RegionID, C.CategoryID, OD.ProductID, YEAR(O.OrderDate)
) AS Q1
INNER JOIN 
(
	SELECT 
	Q.RegionID, 
    Q.CategoryID, 
    Q.OrderDate,
    MAX(Q.Ganancia) AS Ganancia
	FROM 
	(
		SELECT 
		OD.ProductID,
        P.ProductName,
		C.CategoryID, 
        C.CategoryName,
		SUM(OD.Quantity * OD.UnitPrice) AS Ganancia,
        YEAR(O.OrderDate) AS OrderDate,
		ER.EmployeeID, 
        ER.RegionID
		FROM `order details` AS OD
		INNER JOIN orders AS O ON OD.OrderID = O.OrderID
		INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
		INNER JOIN products AS P ON P.ProductID = OD.ProductID
		INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
		GROUP BY ER.RegionID, C.CategoryID, OD.ProductID, YEAR(O.OrderDate)
	) AS Q
	GROUP BY Q.RegionID, Q.CategoryID, Q.OrderDate
) AS Q2 
ON Q2.Ganancia = Q1.Ganancia AND Q2.RegionID = Q1.RegionID AND Q2.CategoryID = Q1.CategoryID AND Q2.OrderDate = Q1.OrderDate
GROUP BY Q1.CategoryID

