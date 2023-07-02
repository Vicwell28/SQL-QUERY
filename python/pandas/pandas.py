# 1. Creación de Series y DataFrames:

import pandas as pd
import numpy as np
# Crear una Serie
s = pd.Series([1, 3, 5, np.nan, 6, 8])
print(s)
# Salida:
# 0    1.0
# 1    3.0
# 2    5.0
# 3    NaN
# 4    6.0
# 5    8.0
# dtype: float64

# Crear un DataFrame desde un diccionario
data = {'Nombre': ['Juan', 'María', 'Pedro'],
        'Edad': [25, 30, 35],
        'Ciudad': ['Madrid', 'Barcelona', 'Sevilla']}
df = pd.DataFrame(data)
print(df)
# Salida:
#   Nombre  Edad      Ciudad
# 0   Juan    25      Madrid
# 1  María    30  Barcelona
# 2  Pedro    35     Sevilla

# Leer un archivo CSV y crear un DataFrame
df_csv = pd.read_csv('datos.csv')

# 2. Manipulación de datos:

# Filtrar filas basadas en una condición
df_filtered = df[df['Edad'] > 25]
print(df_filtered)
# Salida:
#   Nombre  Edad      Ciudad
# 1  María    30  Barcelona
# 2  Pedro    35     Sevilla

# Agregar una nueva columna calculada
df['Edad_doble'] = df['Edad'] * 2
print(df)
# Salida:
#   Nombre  Edad      Ciudad  Edad_doble
# 0   Juan    25      Madrid          50
# 1  María    30  Barcelona          60
# 2  Pedro    35     Sevilla          70

# Operaciones de agrupación
df_grouped = df.groupby('Ciudad').mean()
print(df_grouped)
# Salida:
#            Edad  Edad_doble
# Ciudad                     
# Barcelona    30          60
# Madrid       25          50
# Sevilla      35          70


# 3. Limpieza de datos:

# Verificar valores faltantes
print(df.isnull())
# Salida:
#    Nombre   Edad  Ciudad
# 0   False  False   False
# 1   False  False   False
# 2   False  False   False

# Eliminar filas con valores faltantes
df_cleaned = df.dropna()

# Eliminar duplicados
df_deduplicated = df.drop_duplicates()

# Llenar valores faltantes con un valor específico
df_filled = df.fillna(0)


