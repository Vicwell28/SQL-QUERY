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






df_totals = pd.DataFrame(results_totals, columns=['regionDescription', 'productName', 'total'])


# Consulta SQL para obtener el máximo total por región
query_max_total = '''
SELECT
    subquery.regionDescription,
    MAX(subquery.total) AS max_total
FROM
    (SELECT
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
        p.productName) AS subquery
GROUP BY
    subquery.regionDescription
'''

# Ejecutar consulta del máximo total por región
instancia.execute(query_max_total)
results_max_total = instancia.fetchall()
df_max_total = pd.DataFrame(results_max_total, columns=['regionDescription', 'max_total'])

# Cerrar el instancia
instancia.close()

# Cerrar la conexión a la base de datos
base_datos.close()

# Realizar merge de los resultados
df = pd.merge(df_totals, df_max_total, on='regionDescription')

# Filtrar los resultados con el máximo total por región
df = df[df['total'] == df['max_total']]

# Ordenar por descripción de región
df = df.sort_values('regionDescription')

# Imprimir el DataFrame con los resultados
print(df)