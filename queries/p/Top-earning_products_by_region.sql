---
---
---
--- Consultas para PostgreSQL
---
--- 
--- 
SELECT
    region.region_description,
    products.product_name,
    RES.total_cantidad,
    TO_CHAR(RES.max, 'L9,999,999.99')
FROM
    (
        SELECT
            empleadosporregion.region_ids,
            OD.product_id,
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_dinero,
            SUM(OD.quantity) AS total_cantidad,
            MAX(
                SUM(OD.quantity * OD.unit_price * (1 - OD.discount))
            ) OVER (PARTITION BY empleadosporregion.region_ids)
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
            ) AS empleadosporregion ON empleadosporregion.employee_id = O.employee_id
        GROUP BY
            empleadosporregion.region_ids,
            OD.product_id
    ) AS RES
    INNER JOIN region ON region.region_id = RES.region_ids
    INNER JOIN products ON products.product_id = RES.product_id
WHERE
    RES.total_dinero = RES.max 
    ---
    --- 
    --- 
    ---FUNCIONES
    ---
    --- 
    --- 
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

---
--- 
--- 
---FUNCIONES 
---
--- 
--- 
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

---
---
---
--- MANDAR A LLAMAR LAS FUNCIONES
---
---
---
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