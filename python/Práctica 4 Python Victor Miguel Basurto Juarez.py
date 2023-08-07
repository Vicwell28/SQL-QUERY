import pandas as pd
from DatabaseConnection import DatabaseConnection

db_connection = DatabaseConnection()
db_connection.connect()

# Forma la siguiente tabla  
# Categoria          2023                      2022                    2021
# Vegetales         Lechuga                  Lechuga         Brocoli 
# Consulta SQL para obtener los totales por región y producto
# Mostrar por región los productos  que mas ganancias obtuvieron en los tres ultimos años. 
query_a = '''
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
'''

query_b = '''
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
'''

query_a = db_connection.execute_query(query_a)
query_b = db_connection.execute_query(query_b)

db_connection.disconnect()

query_a.to_json("query_a.json", "index");
query_b.to_json("query_b.json", "index");

merged_data = pd.merge(query_a, query_b, on=["Ganancia", "RegionID", "CategoryID", "OrderDate"], how='inner')

# Seleccionar las columnas que deseas mostrar
columns_to_show = ['ProductName', 'ProductID','CategoryName', 'RegionDescription', 'OrderDate']

# Utilizar loc[] para filtrar y mostrar solo las columnas seleccionadas
merged_data = merged_data.loc[:, columns_to_show]

# Convertir el año a string y combinar con el nombre de la región
merged_data['RegionDescription'] = merged_data['RegionDescription'].str.strip() + ' ' + merged_data['OrderDate'].astype(str)


# Utilizar pivot_table para dar el formato deseado
pivot_df = merged_data.pivot_table(index='CategoryName', columns='RegionDescription', values='ProductName', aggfunc=lambda x: ''.join(str(x)))

# Resetear el índice para obtener 'CategoryName' como columna
pivot_df.reset_index(inplace=True)

# Renombrar las columnas resultantes
pivot_df.columns = [col.replace(" ", "-").replace("-", " - ") for col in pivot_df.columns]

# Mostrar solo las columnas requeridas en el resultado final
result_df = pivot_df[['CategoryName', 'Eastern - 1998', 'Eastern - 1997', 'Eastern - 1996',
                      'Westerns - 1998', 'Westerns - 1997', 'Westerns - 1996',
                      'Northern - 1998', 'Northern - 1997', 'Northern - 1996',
                      'Southern - 1998', 'Southern - 1997', 'Southern - 1996']]

merged_data.to_json("merged_data.json", "index")

# Guardar en un archivo Excel
result_df.to_excel('informacion_productos_consulta.xlsx', index=False, engine='openpyxl')

# COMPROBACION CON LA CONSULATA

# SELECT 
# Q1.CategoryName, 
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Eastern' AND Q1.OrderDate = 1998 THEN Q1.ProductName END) AS 'Eastern- 1998',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Eastern' AND Q1.OrderDate = 1997 THEN Q1.ProductName END) AS 'Eastern- 1997',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Eastern' AND Q1.OrderDate = 1996 THEN Q1.ProductName END) AS 'Eastern- 1996',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Westerns' AND Q1.OrderDate = 1998 THEN Q1.ProductName END) AS 'Westerns- 1998',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Westerns' AND Q1.OrderDate = 1997 THEN Q1.ProductName END) AS 'Westerns- 1997',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Westerns' AND Q1.OrderDate = 1996 THEN Q1.ProductName END) AS 'Westerns - 1996',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Northern' AND Q1.OrderDate = 1998 THEN Q1.ProductName END) AS 'Northern - 1998',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Northern' AND Q1.OrderDate = 1997 THEN Q1.ProductName END) AS 'Northern- 1997',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Northern' AND Q1.OrderDate = 1996 THEN Q1.ProductName END) AS 'Northern - 1996',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Southern' AND Q1.OrderDate = 1998 THEN Q1.ProductName END) AS 'Southern - 1998',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Southern' AND Q1.OrderDate = 1997 THEN Q1.ProductName END) AS 'Southern - 1997',
# MAX(CASE WHEN TRIM(Q1.RegionDescription) = 'Southern' AND Q1.OrderDate = 1996 THEN Q1.ProductName END) AS 'Southern - 1996'
# FROM
# (
# 	SELECT 
# 	OD.ProductID,
# 	P.ProductName,
# 	C.CategoryID, 
# 	C.CategoryName,
# 	SUM(OD.Quantity * OD.UnitPrice) AS Ganancia,
# 	YEAR(O.OrderDate) AS OrderDate,
# 	ER.EmployeeID, 
# 	ER.RegionID,
# 	ER.RegionDescription
# 	FROM `order details` AS OD
# 	INNER JOIN orders AS O ON OD.OrderID = O.OrderID
# 	INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
# 	INNER JOIN products AS P ON P.ProductID = OD.ProductID
# 	INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
# 	GROUP BY ER.RegionID, C.CategoryID, OD.ProductID, YEAR(O.OrderDate)
# ) AS Q1
# INNER JOIN 
# (
# 	SELECT 
# 	Q.RegionID, 
#     Q.CategoryID, 
#     Q.OrderDate,
#     MAX(Q.Ganancia) AS Ganancia
# 	FROM 
# 	(
# 		SELECT 
# 		OD.ProductID,
#         P.ProductName,
# 		C.CategoryID, 
#         C.CategoryName,
# 		SUM(OD.Quantity * OD.UnitPrice) AS Ganancia,
#         YEAR(O.OrderDate) AS OrderDate,
# 		ER.EmployeeID, 
#         ER.RegionID
# 		FROM `order details` AS OD
# 		INNER JOIN orders AS O ON OD.OrderID = O.OrderID
# 		INNER JOIN EmpleadoXRegion AS ER ON ER.EmployeeID = O.EmployeeID
# 		INNER JOIN products AS P ON P.ProductID = OD.ProductID
# 		INNER JOIN categories AS C ON C.CategoryID = P.CategoryID
# 		GROUP BY ER.RegionID, C.CategoryID, OD.ProductID, YEAR(O.OrderDate)
# 	) AS Q
# 	GROUP BY Q.RegionID, Q.CategoryID, Q.OrderDate
# ) AS Q2 
# ON Q2.Ganancia = Q1.Ganancia AND Q2.RegionID = Q1.RegionID AND Q2.CategoryID = Q1.CategoryID AND Q2.OrderDate = Q1.OrderDate
# GROUP BY Q1.CategoryID drrr
