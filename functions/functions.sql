-- Funciones: Las funciones en SQL son similares a los procedimientos almacenados, pero devuelven un valor como resultado. Pueden ser utilizadas en expresiones SQL y son útiles para realizar cálculos o manipulaciones de datos más complejas. Las funciones pueden ser definidas por el usuario o estar incluidas en el sistema de gestión de bases de datos.
-- Funciones (Functions):
-- Supongamos que necesitas una función que calcule el promedio de las edades de los usuarios en la tabla "Usuarios". Puedes crear una función de este tipo:
CREATE FUNCTION CalcularPromedioEdad() RETURNS FLOAT AS BEGIN DECLARE @Promedio FLOAT;

SELECT
    @Promedio = AVG(Edad)
FROM
    Usuarios;

RETURN @Promedio;

END;

-- Ahora puedes llamar a la función "CalcularPromedioEdad" para obtener el promedio de las edades de los usuarios en la tabla.
-- Funciones (Functions):
-- Supongamos que quieres utilizar la función "CalcularPromedioEdad" para obtener el promedio de las edades de los usuarios en la tabla "Usuarios":
SELECT
    CalcularPromedioEdad();

-- Esta consulta llamará a la función "CalcularPromedioEdad" y devolverá el promedio de las edades de los usuarios.
CREATE FUNCTION ObtenerUsuariosMayoresDeEdad(@edadMinima INT) RETURNS TABLE AS RETURN (
    SELECT
        Nombre,
        Edad
    FROM
        Usuarios
    WHERE
        Edad >= @edadMinima
);

CREATE
OR REPLACE FUNCTION GetBestSellingProductByDollarAmountInTheRegion(regionId INT) RETURNS TABLE (
    product_id SMALLINT,
    total_dinero DOUBLE PRECISION,
    total_cantidad BIGINT,
    region_ids SMALLINT
) AS $ $ BEGIN RETURN QUERY
SELECT
    OD.product_id,
    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_dinero,
    SUM(OD.quantity) AS total_cantidad,
    MAX(R.region_ids) AS region_ids
FROM
    order_details AS OD
    INNER JOIN orders AS O ON O.order_id = OD.order_id
    INNER JOIN (
        SELECT
            ET.employee_id,
            MAX(R.region_id) AS region_ids,
            MAX(R.region_description) AS region_name
        FROM
            territories AS T
            INNER JOIN region AS R ON R.region_id = T.region_id
            INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id
        GROUP BY
            ET.employee_id
    ) AS R ON R.employee_id = O.employee_id
WHERE
    R.region_ids = regionId
GROUP BY
    OD.product_id
ORDER BY
    total_dinero DESC
LIMIT
    1;

END;

$ $ LANGUAGE plpgsql;

SELECT
    R.region_description,
    P.product_name,
    TO_CHAR(T.total_dinero, 'L9,999,999.99'),
    T.total_cantidad
FROM
    (
        SELECT
            *
        FROM
            GetBestSellingProductByDollarAmountInTheRegion(1)
        UNION
        SELECT
            *
        FROM
            GetBestSellingProductByDollarAmountInTheRegion(2)
        UNION
        SELECT
            *
        FROM
            GetBestSellingProductByDollarAmountInTheRegion(3)
        UNION
        SELECT
            *
        FROM
            GetBestSellingProductByDollarAmountInTheRegion(4)
    ) AS T
    INNER JOIN region AS R ON R.region_id = T.region_ids
    INNER JOIN products AS P ON P.product_id = T.product_id 
    
    ----
    CREATE
    OR REPLACE FUNCTION GetBestSellingProductByQuantityInTheRegion(regionId INT) RETURNS TABLE (
        product_id SMALLINT,
        total_dinero DOUBLE PRECISION,
        total_cantidad BIGINT,
        region_ids SMALLINT
    ) AS $ $ BEGIN RETURN QUERY
SELECT
    OD.product_id,
    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_dinero,
    SUM(OD.quantity) AS total_cantidad,
    MAX(R.region_ids) AS region_ids
FROM
    order_details AS OD
    INNER JOIN orders AS O ON O.order_id = OD.order_id
    INNER JOIN (
        SELECT
            ET.employee_id,
            MAX(R.region_id) AS region_ids,
            MAX(R.region_description) AS region_name
        FROM
            territories AS T
            INNER JOIN region AS R ON R.region_id = T.region_id
            INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id
        GROUP BY
            ET.employee_id
    ) AS R ON R.employee_id = O.employee_id
WHERE
    R.region_ids = regionId
GROUP BY
    OD.product_id
ORDER BY
    total_cantidad DESC
LIMIT
    1;

END;

$ $ LANGUAGE plpgsql;

SELECT
    R.region_description,
    P.product_name,
    TO_CHAR(T.total_dinero, 'L9,999,999.99'),
    T.total_cantidad
FROM
    (
        SELECT
            *
        FROM
            GetBestSellingProductByQuantityInTheRegion(1)
        UNION
        SELECT
            *
        FROM
            GetBestSellingProductByQuantityInTheRegion(2)
        UNION
        SELECT
            *
        FROM
            GetBestSellingProductByQuantityInTheRegion(3)
        UNION
        SELECT
            *
        FROM
            GetBestSellingProductByQuantityInTheRegion(4)
    ) AS T
    INNER JOIN region AS R ON R.region_id = T.region_ids
    INNER JOIN products AS P ON P.product_id = T.product_id