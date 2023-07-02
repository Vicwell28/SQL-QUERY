SELECT
    emp.RegionDescription as Region,
    p.ProductName as Producto,
    sum(od.Quantity * od.UnitPrice) as Cantidad,
    YEAR(o.OrderDate) as Fecha,
    c.CategoryName as Categoria
FROM
    `order details` od
    INNER JOIN products p on od.ProductID = p.ProductID
    INNER JOIN categories c on p.CategoryID = c.CategoryID
    INNER JOIN orders o on od.OrderID = o.OrderID
    INNER JOIN (
        SELECT
            et.EmployeeID,
            r.RegionID,
            r.RegionDescription
        FROM
            employeeterritories et
            INNER JOIN territories t on et.TerritoryID = t.TerritoryID
            INNER JOIN region r on t.RegionID = r.RegionID
        group by
            et.EmployeeID
    ) as emp on o.EmployeeID = emp.EmployeeID
group by
    Region,
    Producto,
    Fecha;