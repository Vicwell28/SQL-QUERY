# Mostrar el año en el obtuvo su mayor ganancia el producto mas vendido por región y categoria. 

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


