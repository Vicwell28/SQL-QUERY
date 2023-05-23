-- Transacciones: Las transacciones son unidades lógicas de trabajo que agrupan una serie de operaciones de base de datos en una sola unidad. Permiten mantener la integridad de los datos y aseguran que todas las operaciones se completen correctamente o se reviertan si ocurre un error. Las transacciones se utilizan para garantizar la consistencia de la base de datos en entornos concurrentes.

-- Transacciones (Transactions):
-- Supongamos que necesitas realizar una serie de operaciones de inserción y actualización en varias tablas como parte de una transacción. Puedes iniciar y completar una transacción de la siguiente manera:

BEGIN TRANSACTION;

INSERT INTO Tabla1 (Columna1, Columna2) VALUES (Valor1, Valor2);
UPDATE Tabla2 SET Columna1 = Valor1 WHERE Condición;

COMMIT TRANSACTION;
-- Aquí, las operaciones de inserción y actualización se realizan dentro de una transacción. Si todas las operaciones se completan correctamente, puedes confirmar la transacción utilizando COMMIT TRANSACTION. En caso de que ocurra un error, puedes revertir la transacción utilizando ROLLBACK TRANSACTION para deshacer todos los cambios realizados.




-- Transacciones (Transactions):
-- Supongamos que necesitas realizar una serie de operaciones de inserción y actualización en varias tablas dentro de una transacción:
BEGIN TRANSACTION;

INSERT INTO Tabla1 (Columna1, Columna2) VALUES (Valor1, Valor2);
UPDATE Tabla2 SET Columna1 = Valor1 WHERE Condición;

COMMIT TRANSACTION;
-- Aquí, las operaciones de inserción y actualización se realizan dentro de la transacción. Si todas las operaciones se completan correctamente, puedes confirmar la transacción utilizando COMMIT TRANSACTION. En caso de que ocurra un error, puedes revertir la transacción utilizando ROLLBACK TRANSACTION para deshacer todos los cambios realizados.

-- Recuerda adaptar los ejemplos según tu base de datos y estructura específica.