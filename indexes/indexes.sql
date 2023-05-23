-- Índices: Los índices son estructuras de datos utilizadas para mejorar el rendimiento de las consultas en la base de datos. Se crean en una o varias columnas de una tabla y permiten buscar y acceder rápidamente a los datos en función de los valores del índice. Los índices aceleran las consultas al reducir la cantidad de datos que se deben examinar.

-- Índices (Indexes):
-- Supongamos que tienes una tabla llamada "Usuarios" con una columna "Nombre" y deseas mejorar el rendimiento de las consultas de búsqueda por nombre. Puedes crear un índice en esa columna de la siguiente manera:

CREATE INDEX idx_nombre ON Usuarios (Nombre);

-- Esto creará un índice llamado "idx_nombre" en la tabla "Usuarios" para la columna "Nombre". Ahora, las consultas que involucren búsquedas por nombre se ejecutarán más rápidamente gracias al índice.



-- Índices (Indexes):
-- Supongamos que tienes una tabla llamada "Usuarios" con una columna "Nombre" y deseas buscar un usuario específico por su nombre utilizando el índice creado anteriormente:
SELECT * FROM Usuarios WHERE Nombre = 'John';
-- Esta consulta utilizará el índice creado en la columna "Nombre" para acelerar la búsqueda y recuperar los datos del usuario con nombre "John".
