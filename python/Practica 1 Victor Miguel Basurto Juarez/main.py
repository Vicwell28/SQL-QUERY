import pandas as pd
from DatabaseConnection import DatabaseConnection

# 3. Creación de una instancia de DatabaseConnection:
#    - Se crea una instancia de la clase DatabaseConnection con el nombre `db_connection`.
db_connection = DatabaseConnection()
# 4. Conexión a la base de datos:
#    - Se llama al método `connect` en la instancia `db_connection` para establecer la conexión con la base de datos.
db_connection.connect()

# 5. Ejecución de consultas:
#    - Se ejecutan varias consultas SQL utilizando el método `execute_query` en la instancia `db_connection`. Las consultas extraen datos de diferentes tablas de la base de datos.
#    - Los resultados de las consultas se guardan en diferentes DataFrames.

df_employees = db_connection.execute_query("SELECT * FROM employees")
df_employeeterritories = db_connection.execute_query("SELECT * FROM employeeterritories")
df_territories = db_connection.execute_query("SELECT * FROM territories")
df_region = db_connection.execute_query("SELECT * FROM region")

df_order_details = db_connection.execute_query("SELECT * FROM `order details`")
df_orders = db_connection.execute_query("SELECT * FROM orders")

df_products = db_connection.execute_query("SELECT * FROM `order details` AS OD INNER JOIN orders AS O ON OD.OrderID = O.OrderID INNER JOIN ( SELECT E.EmployeeID, R.RegionID FROM employees AS E INNER JOIN employeeterritories AS ET ON E.EmployeeID = ET.EmployeeID INNER JOIN territories AS T ON T.TerritoryID = ET.TerritoryID INNER JOIN region AS R ON R.RegionID = T.RegionID GROUP BY E.EmployeeID) AS Q1 ON Q1.EmployeeID = O.EmployeeID")

# 6. Cierre de la conexión:
#    - Se llama al método `disconnect` en la instancia `db_connection` para cerrar la conexión con la base de datos.
db_connection.disconnect()


# 7. Procesamiento y análisis de datos:
#    - Se realizan una serie de operaciones en los DataFrames para manipular y analizar los datos.
#    - Se combinan los DataFrames utilizando el método `pd.merge` para obtener los datos necesarios.
#    - Se realizan cálculos y agrupaciones en los DataFrames para obtener los resultados deseados.
#    - Se seleccionan columnas específicas de los DataFrames.
#    - Se guarda el resultado final en archivos JSON utilizando el método `to_json` de Pandas.

# SELECT E.EmployeeID, R.RegionID FROM employees AS E
# INNER JOIN employeeterritories AS ET ON E.EmployeeID = ET.EmployeeID
# INNER JOIN territories AS T ON T.TerritoryID = ET.TerritoryID
# INNER JOIN region AS R ON R.RegionID = T.RegionID
# GROUP BY E.EmployeeID;

df_employees_regions = pd.merge(
    df_employees,
    df_employeeterritories,
    left_on='EmployeeID',
    right_on='EmployeeID',
    how='inner'
)

df_employees_regions = pd.merge(
    df_employees_regions,
    df_territories,
    left_on='TerritoryID',
    right_on='TerritoryID',
    how='inner'
)

df_employees_regions = pd.merge(
    df_employees_regions,
    df_region,
    left_on='RegionID',
    right_on='RegionID',
    how='inner'
)

# El método reset_index se utiliza para restablecer los índices de un DataFrame después de realizar operaciones de agrupación, filtrado u otras transformaciones que puedan modificar la estructura del índice.

df_employees_regions = df_employees_regions.groupby('EmployeeID').first('RegionID').reset_index()

# SELECT SUM(OD.UnitPrice * OD.Quantity) FROM `order details` AS OD ;

# SELECT Q1.RegionID, SUM(OD.UnitPrice * OD.Quantity) as TOTAL
# FROM `order details` AS OD
# INNER JOIN orders AS O ON OD.OrderID = O.OrderID
# INNER JOIN (
# SELECT E.EmployeeID, R.RegionID FROM employees AS E
# INNER JOIN employeeterritories AS ET ON E.EmployeeID = ET.EmployeeID
# INNER JOIN territories AS T ON T.TerritoryID = ET.TerritoryID
# INNER JOIN region AS R ON R.RegionID = T.RegionID
# GROUP BY E.EmployeeID) AS Q1 ON Q1.EmployeeID = O.EmployeeID
# GROUP BY Q1.RegionID;

df_total_region = pd.merge(
    df_order_details,
    df_orders,
    left_on='OrderID',
    right_on='OrderID',
    how='inner'
)

df_total_region = pd.merge(
    df_total_region,
    df_employees_regions,
    left_on='EmployeeID',
    right_on='EmployeeID',
    how='inner'
)

df_total_region['Total'] = df_total_region['Quantity'] * df_total_region['UnitPrice']

df_total_region = df_total_region.groupby('RegionID').sum('Total').reset_index()

df_total_region = pd.merge(
    df_total_region,
    df_region,
    left_on='RegionID',
    right_on='RegionID',
    how='inner'
)

df_total_region = df_total_region[['RegionID', 'RegionDescription', 'Total']]

df_employees_regions.to_json("employees_regions.json", orient="records")

df_total_region.to_json("total_region.json", orient='records')

# print(df_products)

df_products['Total'] = df_products['Quantity'] * df_products['UnitPrice']

df_products = df_products.groupby('RegionID').sum('Total').reset_index()

df_products = pd.merge(
    df_products,
    df_region,
    left_on='RegionID',
    right_on='RegionID',
    how='inner'
)

print(df_products)