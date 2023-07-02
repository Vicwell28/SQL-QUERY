---
---
---
--- Consultas para MYSQL
---
---
---
---
/ / EMPLEADO POR REGION
SELECT
    R.RegionID,
    R.RegionDescription,
    ET.EmployeeID
FROM
    region AS R
    INNER JOIN territories AS T ON T.RegionID = R.RegionID
    INNER JOIN employeeterritories AS ET ON ET.TerritoryID = T.TerritoryID
GROUP BY
    R.RegionID,
    ET.EmployeeID 

/ / COMPROBACION
SELECT
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TOTAL
FROM
    `order details` AS OD / / LO QUE VENDIO CADA EMPLEADO
SELECT
    O.EmployeeID,
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TOTAL
FROM
    `order details` AS OD
    INNER JOIN orders AS O ON O.OrderID = OD.OrderID
GROUP BY
    O.EmployeeID 

/ / OBTENER LA GANANCIA TOTAL POR REGION
SELECT
    Q2.RegionDescription,
    FORMAT(SUM(Q1.TOTAL), 2) AS TOTAL
FROM
    (
        SELECT
            O.EmployeeID,
            SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TOTAL
        FROM
            `order details` AS OD
            INNER JOIN orders AS O ON O.OrderID = OD.OrderID
        GROUP BY
            O.EmployeeID
    ) AS Q1
    INNER JOIN (
        SELECT
            R.RegionID,
            R.RegionDescription,
            ET.EmployeeID
        FROM
            region AS R
            INNER JOIN territories AS T ON T.RegionID = R.RegionID
            INNER JOIN employeeterritories AS ET ON ET.TerritoryID = T.TerritoryID
        GROUP BY
            R.RegionID,
            ET.EmployeeID
    ) AS Q2 ON Q2.EmployeeID = Q1.EmployeeID
GROUP BY
    Q2.RegionID DESC
ORDER BY
    TOTAL DESC 
    
/ / OBTERNER EL PRODUCTO MAS VENDIDO POR REGION 
/ / OBTENER LA GANANCIA TOTAL DE PRODUCTO POR REGION
SELECT
    OD.ProductID,
    Q1.*,
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TOTAL
FROM
    `order details` AS OD
    INNER JOIN orders AS O ON O.OrderID = OD.OrderID
    INNER JOIN (
        SELECT
            R.RegionID,
            ET.EmployeeID
        FROM
            region AS R
            INNER JOIN territories AS T ON T.RegionID = R.RegionID
            INNER JOIN employeeterritories AS ET ON ET.TerritoryID = T.TerritoryID
        GROUP BY
            R.RegionID,
            ET.EmployeeID
    ) AS Q1 ON Q1.EmployeeID = O.EmployeeID
GROUP BY
    Q1.RegionID,
    OD.ProductID 
    
/ / OBTENER EL PRODUCTO CON MAYOR GANANCIA POR REGION
SELECT
    Q2.RegionID,
    MAX(Q2.TOTAL) AS GananciaMax
FROM
    (
        SELECT
            OD.ProductID,
            Q1.*,
            SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TOTAL
        FROM
            `order details` AS OD
            INNER JOIN orders AS O ON O.OrderID = OD.OrderID
            INNER JOIN (
                SELECT
                    R.RegionID,
                    ET.EmployeeID
                FROM
                    region AS R
                    INNER JOIN territories AS T ON T.RegionID = R.RegionID
                    INNER JOIN employeeterritories AS ET ON ET.TerritoryID = T.TerritoryID
                GROUP BY
                    R.RegionID,
                    ET.EmployeeID
            ) AS Q1 ON Q1.EmployeeID = O.EmployeeID
        GROUP BY
            Q1.RegionID,
            OD.ProductID
    ) AS Q2
GROUP BY
    Q2.RegionID 
    
/ / MOSTRAR PRODUCTOS CON MAYOR GANACIA POR REGION
SELECT
    Q2.RegionID,
    Q2.TotalGanancia AS ProductMax,
    GROUP_CONCAT(Q2.ProductID) as Products
FROM
    (
        SELECT
            Q2.RegionID,
            MAX(Q2.TotalGanancia) AS GananciaMax
        FROM
            (
                SELECT
                    OD.ProductID,
                    Q1.*,
                    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalGanancia
                FROM
                    `order details` AS OD
                    INNER JOIN orders AS O ON O.OrderID = OD.OrderID
                    INNER JOIN (
                        SELECT
                            R.RegionID,
                            ET.EmployeeID
                        FROM
                            region AS R
                            INNER JOIN territories AS T ON T.RegionID = R.RegionID
                            INNER JOIN employeeterritories AS ET ON ET.TerritoryID = T.TerritoryID
                        GROUP BY
                            R.RegionID,
                            ET.EmployeeID
                    ) AS Q1 ON Q1.EmployeeID = O.EmployeeID
                GROUP BY
                    Q1.RegionID,
                    OD.ProductID
            ) AS Q2
        GROUP BY
            Q2.RegionID
    ) AS Q1
    INNER JOIN (
        SELECT
            OD.ProductID,
            Q1.*,
            SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalGanancia
        FROM
            `order details` AS OD
            INNER JOIN orders AS O ON O.OrderID = OD.OrderID
            INNER JOIN (
                SELECT
                    R.RegionID,
                    ET.EmployeeID
                FROM
                    region AS R
                    INNER JOIN territories AS T ON T.RegionID = R.RegionID
                    INNER JOIN employeeterritories AS ET ON ET.TerritoryID = T.TerritoryID
                GROUP BY
                    R.RegionID,
                    ET.EmployeeID
            ) AS Q1 ON Q1.EmployeeID = O.EmployeeID
        GROUP BY
            Q1.RegionID,
            OD.ProductID
    ) AS Q2 ON Q1.RegionID = Q2.RegionID
    AND Q1.GananciaMax = Q2.TotalGanancia
GROUP BY
    Q2.RegionID 