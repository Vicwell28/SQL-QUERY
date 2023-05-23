-- La vista en sí misma no almacena datos de manera independiente, sino que se define mediante una consulta SQL almacenada en la base de datos. Cuando se consulta una vista, la consulta se ejecuta dinámicamente y los datos se recuperan de las tablas subyacentes en tiempo real. Esto significa que los datos mostrados por la vista se actualizan automáticamente cuando cambian los datos en las tablas subyacentes.


-- Vistas (Views):
-- Supongamos que deseas crear una vista que muestre solo los usuarios mayores de 18 años de la tabla "Usuarios". Puedes crear una vista de la siguiente manera:

CREATE VIEW UsuariosMayoresDeEdad
AS
SELECT Nombre, Edad
FROM Usuarios
WHERE Edad > 18;

-- Ahora puedes consultar la vista "UsuariosMayoresDeEdad" para obtener una lista de los usuarios mayores de 18 años.


-- Vistas (Views):
-- Supongamos que quieres consultar la vista "UsuariosMayoresDeEdad" para obtener la lista de los usuarios mayores de 18 años:
SELECT * FROM UsuariosMayoresDeEdad;
-- Esta consulta recuperará los datos de la vista "UsuariosMayoresDeEdad" y mostrará solo los usuarios que cumplen con el criterio de ser mayores de 18 años.
