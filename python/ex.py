import pandas as pd
import numpy as np
from DatabaseConnection import DatabaseConnection
import matplotlib.pyplot as plt


db_connection = DatabaseConnection()

db_connection.connect()


# SELECT DATE_FORMAT(O.OrderDate, '%Y-%m-01') AS Periodo, P.ProductName, SUM(OD.Quantity) as Ventas 
# FROM `order details` AS OD
# INNER JOIN orders AS O ON O.OrderID = OD.OrderID
# INNER JOIN products AS P ON P.ProductID = OD.ProductID
# GROUP BY PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM O.OrderDate), '2010-01-01') DIV 3, OD.ProductID
# ORDER BY Periodo;


# SELECT SUM(Q1.Ventas) FROM 
# (SELECT DATE_FORMAT(O.OrderDate, '%Y-%m-01') AS Periodo, P.ProductName, SUM(OD.Quantity) as Ventas 
# FROM `order details` AS OD
# INNER JOIN orders AS O ON O.OrderID = OD.OrderID
# INNER JOIN products AS P ON P.ProductID = OD.ProductID
# GROUP BY PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM O.OrderDate), '2010-01-01') DIV 3, OD.ProductID
# ORDER BY Periodo
# ) AS Q1;

# SELECT SUM(OD.Quantity)
# FROM `order details` AS OD
# INNER JOIN orders AS O ON O.OrderID = OD.OrderID
# INNER JOIN products AS P ON P.ProductID = OD.ProductID


df_orders = db_connection.execute_query("SELECT * FROM `order details` AS OD INNER JOIN orders AS O ON O.OrderID = OD.OrderID")
df_products = db_connection.execute_query("SELECT * FROM products")

db_connection.disconnect()

df_orders['Periodo'] = df_orders['OrderDate'].dt.to_period('M') 

df_orders = df_orders.groupby(['Periodo', 'ProductID']).agg({'Quantity': 'sum'}).reset_index()

df_orders = df_orders.rename(columns={'Quantity': 'Ventas'})

df_orders = pd.merge(
    df_orders, 
    df_products[['ProductName', 'ProductID']], 
    on="ProductID",
    how="inner"
)

print(df_orders)

