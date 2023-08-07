import pandas as pd
from DatabaseConnection import DatabaseConnection

db_connection = DatabaseConnection()
db_connection.connect()

#ESTA PRACTICA CONSISTE EN # Mostrar el año en el obtuvo su mayor ganancia el producto mas vendido por región y categoria.

# ESTA CONSULTA NOS RETONA LOS PRODUCTOS POR CATEGORIA Y REGION QUE MAS SE HAN VENDIDO
query_max_products_region_x_category = '''
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
'''

#ESTA CONSULTA NOS RETORNA LA FECHA DE CADA PRODUCTO DONDE SE HA VENDIDO MAS
query_year_product = '''
SELECT 
Q1.ProductID,
MAX(Q1.Ganancia) AS Ganancia,
YEAR(Q1.RequiredDate) as Year
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
	GROUP BY P.ProductID, YEAR(O.RequiredDate)
) AS Q1 GROUP BY Q1.ProductID;
'''

#ESTO LO QUE HACE ES IR A CONSULTA LA BASE DE DATOS Y NOS RETORNA LOS DATOS COMO DATA FRAME DE PANDAS, CON LA CLASE DE SQL QUE SE CONECTA A NUESTRA DB
query_max_products_region_x_category = db_connection.execute_query(query_max_products_region_x_category)
query_year_product = db_connection.execute_query(query_year_product)

db_connection.disconnect()

# Unir los DataFrames por las columnas comunes pro 'ProductID'
merged_data = pd.merge(
    query_max_products_region_x_category,
    query_year_product,
    left_on="ProductID",
    right_on="ProductID"
)

# Seleccionar las columnas que deseo  mostrar
columns_to_show = ['ProductName', 'CategoryName', 'RegionDescription', 'Year']

# Utilizar loc[] para filtrar y mostrar solo las columnas seleccionadas
merged_data = merged_data.loc[:, columns_to_show]

# Convertir el año a string y combinar con el nombre de la región
merged_data['ProductName'] = merged_data['ProductName'].str.strip(
) + ' ' + merged_data['Year'].astype(str)

merged_data.to_json("merge.json", "index")

# Utilizar pivot_table para dar el formato deseado
pivot_df = merged_data.pivot_table(index='CategoryName', columns='RegionDescription', values='ProductName', aggfunc=lambda x: ''.join(str(x)))

# Resetear el índice para obtener 'CategoryName' como columna
pivot_df.reset_index(inplace=True)

# Guardar en un archivo Excel
pivot_df.to_excel('informacion_productos.xlsx', index=False, engine='openpyxl')
