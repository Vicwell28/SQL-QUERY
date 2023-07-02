import pandas as pd
import pymysql
import numpy as np
from DatabaseConnection import DatabaseConnection

db_connection = DatabaseConnection()

db_connection.connect()

df_employees = db_connection.execute_query("SELECT * FROM employees")
df_employeeterritories = db_connection.execute_query(
    "SELECT * FROM employeeterritories")
df_territories = db_connection.execute_query("SELECT * FROM territories")
df_region = db_connection.execute_query("SELECT * FROM region")

df_order_details = db_connection.execute_query("SELECT * FROM `order details`")
df_orders = db_connection.execute_query("SELECT * FROM orders")

db_connection.disconnect()

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
