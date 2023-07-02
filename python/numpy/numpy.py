import numpy as np

# Crear un arreglo 1D
arr1 = np.array([1, 2, 3, 4, 5])
print(arr1)
# Salida: [1 2 3 4 5]

# Crear un arreglo 2D
arr2 = np.array([[1, 2, 3], [4, 5, 6]])
print(arr2)
# Salida:
# [[1 2 3]
#  [4 5 6]]


# 2. Operaciones matemáticas:

arr = np.array([1, 2, 3, 4, 5])

# Suma de todos los elementos
print(np.sum(arr))
# Salida: 15

# Promedio de los elementos
print(np.mean(arr))
# Salida: 3.0

# Raíz cuadrada de cada elemento
print(np.sqrt(arr))
# Salida: [1.         1.41421356 1.73205081 2.         2.23606798]


# 3. Indexación y rebanado:
arr = np.array([1, 2, 3, 4, 5])

# Acceder al primer elemento
print(arr[0])
# Salida: 1

# Acceder a un rango de elementos
print(arr[1:4])
# Salida: [2 3 4]

# Asignar un nuevo valor a un elemento
arr[2] = 10
print(arr)
# Salida: [ 1  2 10  4  5]


