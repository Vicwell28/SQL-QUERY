-- Procedimientos almacenados: Los procedimientos almacenados son bloques de código SQL que se almacenan en la base de datos y se pueden llamar desde otras aplicaciones o consultas. Proporcionan una forma de encapsular lógica de negocio compleja y reutilizable en la base de datos. Los procedimientos almacenados se definen una vez y se pueden ejecutar muchas veces sin necesidad de volver a escribir el código.


-- Procedimientos almacenados (Stored Procedures):
-- Supongamos que necesitas un procedimiento almacenado que inserte un nuevo usuario en la tabla "Usuarios". Puedes crearlo de la siguiente manera:

CREATE PROCEDURE InsertarUsuario
    @Nombre VARCHAR(50),
    @Edad INT
AS
BEGIN
    INSERT INTO Usuarios (Nombre, Edad)
    VALUES (@Nombre, @Edad);
END;

-- Ahora puedes llamar al procedimiento almacenado "InsertarUsuario" pasando los parámetros necesarios para insertar un nuevo usuario en la tabla.



-- Procedimientos almacenados (Stored Procedures):
-- Supongamos que quieres utilizar el procedimiento almacenado "InsertarUsuario" para insertar un nuevo usuario en la tabla "Usuarios" con un nombre y una edad específicos:
EXEC InsertarUsuario 'Maria', 25;
-- Esto llamará al procedimiento almacenado "InsertarUsuario" y pasará los valores "Maria" y 25 como parámetros para insertar un nuevo usuario en la tabla.