import pandas as pd
from DatabaseConnection import DatabaseConnection

db_connection = DatabaseConnection()

db_connection.connect()

#TODO: El producto que mas ganancias por Región.
# Consulta SQL para obtener 
query_totals = '''
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
INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
'''

query_prducts = "SELECT * FROM products"
query_regions = "SELECT * FROM region"

dt_results = db_connection.execute_query(query_totals)
dt_products = db_connection.execute_query(query_prducts)
dt_regions = db_connection.execute_query(query_regions)

db_connection.disconnect()

dt_results['Total'] = dt_results['Quantity'] * dt_results['UnitPrice']

dt_results = dt_results.groupby(
    ["RegionID", "ProductID"]).sum("Total").reset_index()

maxTotalByRegion = dt_results.groupby("RegionID").max("Total").reset_index()

dt_results = pd.merge(
    maxTotalByRegion,
    dt_results,
    left_on='Total',
    right_on='Total',
    how='inner'
).reset_index()

dt_results = pd.merge(
    dt_results,
    dt_regions,
    left_on='RegionID_y',
    right_on='RegionID',
    how='inner'
)

dt_results = pd.merge(
    dt_results,
    dt_products,
    left_on='ProductID_y',
    right_on='ProductID',
    how='inner'
)

# Seleccionar las columnas que deseas mostrar
columns_to_show = ['RegionDescription', 'ProductName', 'Total']

# Utilizar loc[] para filtrar y mostrar solo las columnas seleccionadas
dt_results = dt_results.loc[:, columns_to_show]

dt_results['RegionDescription'] = dt_results['RegionDescription'].str.strip()

dt_results.to_json("ProductosMasGananciaPorRegion.json", 'records')
