-- Disparadores (triggers): Los disparadores son objetos de base de datos que se activan automáticamente en respuesta a eventos específicos, como la inserción, actualización o eliminación de datos en una tabla. Los disparadores permiten ejecutar lógica adicional antes o después de que ocurra un evento, lo que permite mantener la integridad de los datos y realizar acciones personalizadas.

-- Disparadores (Triggers):
-- Supongamos que tienes una tabla llamada "Ventas" y deseas crear un disparador que actualice automáticamente el stock de un producto después de que se registre una venta. Puedes crear un disparador de esta manera:

CREATE TRIGGER ActualizarStock
AFTER INSERT ON Ventas
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET Stock = Stock - NEW.Cantidad
    WHERE ProductoID = NEW.ProductoID;
END;

-- Ahora, cada vez que se inserte una nueva venta en la tabla "Ventas", el disparador se activará y actualizará el stock del producto correspondiente en la tabla "Productos".




-- Disparadores (Triggers):
-- Supongamos que tienes una tabla llamada "Ventas" y deseas insertar una nueva venta y actualizar automáticamente el stock del producto correspondiente utilizando el disparador "ActualizarStock":
INSERT INTO Ventas (ProductoID, Cantidad) VALUES (123, 5);
-- Después de ejecutar esta instrucción de inserción, el disparador "ActualizarStock" se activará automáticamente y actualizará el stock del producto relacionado en la tabla "Productos".