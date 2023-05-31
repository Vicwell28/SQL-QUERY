--- PUT IN THE SAME CELL THE PRODUCTS WITH MAXIMUM PROFIT AND PRODUCTS WITH LESS PROFIT BY REGION
--- EN LA SIGUIENTE CONSULTA TE OBTIENE EL PRODUCTO CON MAYOR GANANCIA ASÍ  COMO EL PRODUCTO CON MENOS GANANCIA
SELECT
    Q1.region_ids,
    MAX(Q1.totaldescuento),
    MIN(Q1.totaldescuento)
FROM
    (
        SELECT
            empleadosporregion.region_ids,
            OD.product_id,
            SUM(OD.quantity),
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
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
    ) AS Q1
GROUP BY
    Q1.region_ids -----OCMPROBACION
SELECT
    *
FROM
    (
        SELECT
            Q2.region_ids,
            MAX(Q2.maxganncia) AS maxganancia,
            MAX(Q2.minganancia) AS minganancia,
            ARRAY_AGG(maxProduct.product_id) AS productosmax,
            ARRAY_AGG(mingProduct.product_id) AS productosmin
        FROM
            (
                SELECT
                    Q1.region_ids,
                    MAX(Q1.totaldescuento) AS maxGanncia,
                    MIN(Q1.totaldescuento) AS minGanancia
                FROM
                    (
                        SELECT
                            empleadosporregion.region_ids,
                            OD.product_id,
                            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                        FROM
                            order_details AS OD
                            INNER JOIN orders AS O ON O.order_id = OD.order_id
                            INNER JOIN (
                                SELECT
                                    ET.employee_id,
                                    MAX(R.region_id) AS region_ids
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
                    ) AS Q1
                GROUP BY
                    Q1.region_ids
            ) AS Q2
            INNER JOIN (
                SELECT
                    empleadosporregion.region_ids,
                    OD.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                FROM
                    order_details AS OD
                    INNER JOIN orders AS O ON O.order_id = OD.order_id
                    INNER JOIN (
                        SELECT
                            ET.employee_id,
                            MAX(R.region_id) AS region_ids
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
            ) AS maxProduct ON maxProduct.region_ids = Q2.region_ids
            AND maxProduct.totaldescuento = Q2.maxGanncia
            INNER JOIN (
                SELECT
                    empleadosporregion.region_ids,
                    OD.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                FROM
                    order_details AS OD
                    INNER JOIN orders AS O ON O.order_id = OD.order_id
                    INNER JOIN (
                        SELECT
                            ET.employee_id,
                            MAX(R.region_id) AS region_ids
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
            ) AS mingProduct ON mingProduct.region_ids = Q2.region_ids
            AND mingProduct.totaldescuento = Q2.minGanancia
        GROUP BY
            Q2.region_ids
    ) AS Q3
    INNER JOIN products AS P ON P.product_id = ANY(Q3.productosmax)
    INNER JOIN products AS P2 ON P2.product_id = ANY(Q3.productosmin) 
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    ---------RESULTADO FINAL
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
SELECT
    Q3.region_ids,
    CONCAT(
        STRING_AGG(DISTINCT(P.product_name), ', ') || ' ' || TO_CHAR(MAX(Q3.maxganancia), 'L9,999,999.99'),
        E '\n',
        STRING_AGG(DISTINCT(P2.product_name), ', ') || ' ' || TO_CHAR(MAX(Q3.minganancia), 'L9,999,999.99')
    ) AS productos
FROM
    (
        SELECT
            Q2.region_ids,
            MAX(Q2.maxganncia) AS maxganancia,
            MAX(Q2.minganancia) AS minganancia,
            ARRAY_AGG(maxProduct.product_id) AS productosmax,
            ARRAY_AGG(mingProduct.product_id) AS productosmin
        FROM
            (
                SELECT
                    Q1.region_ids,
                    MAX(Q1.totaldescuento) AS maxGanncia,
                    MIN(Q1.totaldescuento) AS minGanancia
                FROM
                    (
                        SELECT
                            empleadosporregion.region_ids,
                            OD.product_id,
                            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                        FROM
                            order_details AS OD
                            INNER JOIN orders AS O ON O.order_id = OD.order_id
                            INNER JOIN (
                                SELECT
                                    ET.employee_id,
                                    MAX(R.region_id) AS region_ids
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
                    ) AS Q1
                GROUP BY
                    Q1.region_ids
            ) AS Q2
            INNER JOIN (
                SELECT
                    empleadosporregion.region_ids,
                    OD.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                FROM
                    order_details AS OD
                    INNER JOIN orders AS O ON O.order_id = OD.order_id
                    INNER JOIN (
                        SELECT
                            ET.employee_id,
                            MAX(R.region_id) AS region_ids
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
            ) AS maxProduct ON maxProduct.region_ids = Q2.region_ids
            AND maxProduct.totaldescuento = Q2.maxGanncia
            INNER JOIN (
                SELECT
                    empleadosporregion.region_ids,
                    OD.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                FROM
                    order_details AS OD
                    INNER JOIN orders AS O ON O.order_id = OD.order_id
                    INNER JOIN (
                        SELECT
                            ET.employee_id,
                            MAX(R.region_id) AS region_ids
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
            ) AS mingProduct ON mingProduct.region_ids = Q2.region_ids
            AND mingProduct.totaldescuento = Q2.minGanancia
        GROUP BY
            Q2.region_ids
    ) AS Q3
    INNER JOIN products AS P ON P.product_id = ANY(Q3.productosmax)
    INNER JOIN products AS P2 ON P2.product_id = ANY(Q3.productosmin)
GROUP BY
    Q3.region_ids 
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- CONSULTA QUE MUESTRA LOS PRODUCTOS CON SU GANANCIA EN CADA REGION CON SU GANANCIA
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
SELECT
    empleadosporregion.region_ids,
    OD.product_id,
    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
FROM
    order_details AS OD
    INNER JOIN orders AS O ON O.order_id = OD.order_id
    INNER JOIN (
        SELECT
            ET.employee_id,
            MAX(R.region_id) AS region_ids
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
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- CONSULTA QUE MUESTRA EL MAX Y MIN DE GANANCIA TOTAL DE LOS PRODUCTOS POR REGION
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
SELECT
    Q1.region_ids,
    MAX(Q1.totaldescuento) AS maxGanncia,
    MIN(Q1.totaldescuento) AS minGanancia
FROM
    (
        SELECT
            empleadosporregion.region_ids,
            OD.product_id,
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
        FROM
            order_details AS OD
            INNER JOIN orders AS O ON O.order_id = OD.order_id
            INNER JOIN (
                SELECT
                    ET.employee_id,
                    MAX(R.region_id) AS region_ids
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
    ) AS Q1
GROUP BY
    Q1.region_ids
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- CONSULTA QUE MUESTRA DE DETERMIANDA REGIN TODOS LOS PRODUCTOS CON MAX Y MIN GANANCIA 
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
SELECT
    Q2.region_ids,
    MAX(Q2.maxganncia) AS maxganancia,
    MAX(Q2.minganancia) AS minganancia,
    ARRAY_AGG(maxProduct.product_id) AS productosmax,
    ARRAY_AGG(mingProduct.product_id) AS productosmin
FROM
    (
        SELECT
            Q1.region_ids,
            MAX(Q1.totaldescuento) AS maxGanncia,
            MIN(Q1.totaldescuento) AS minGanancia
        FROM
            (
                SELECT
                    empleadosporregion.region_ids,
                    OD.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                FROM
                    order_details AS OD
                    INNER JOIN orders AS O ON O.order_id = OD.order_id
                    INNER JOIN (
                        SELECT
                            ET.employee_id,
                            MAX(R.region_id) AS region_ids
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
            ) AS Q1
        GROUP BY
            Q1.region_ids
    ) AS Q2
    INNER JOIN (
        SELECT
            empleadosporregion.region_ids,
            OD.product_id,
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
        FROM
            order_details AS OD
            INNER JOIN orders AS O ON O.order_id = OD.order_id
            INNER JOIN (
                SELECT
                    ET.employee_id,
                    MAX(R.region_id) AS region_ids
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
    ) AS maxProduct ON maxProduct.region_ids = Q2.region_ids
    AND maxProduct.totaldescuento = Q2.maxGanncia
    INNER JOIN (
        SELECT
            empleadosporregion.region_ids,
            OD.product_id,
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
        FROM
            order_details AS OD
            INNER JOIN orders AS O ON O.order_id = OD.order_id
            INNER JOIN (
                SELECT
                    ET.employee_id,
                    MAX(R.region_id) AS region_ids
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
    ) AS mingProduct ON mingProduct.region_ids = Q2.region_ids
    AND mingProduct.totaldescuento = Q2.minGanancia
GROUP BY
    Q2.region_ids 
------------------------------------------------------------------------
------------------------------------------------------------------------
    --- YA QUE TENGAMOS TODOS LOS PRODUCTOS CON MAX Y MIN GANANCIA HACEMOS LA ULTIMA CONSULTA DONDE EN UNA SOLA CELDA LOS PRODUCTOS CON MAX Y MIN GANANCIAA
------------------------------------------------------------------------
-----------------------------------------------------------------------
SELECT
    Q3.region_ids,
    CONCAT(
        STRING_AGG(DISTINCT(P.product_name), ', ') || ' ' || TO_CHAR(MAX(Q3.maxganancia), 'L9,999,999.99'),
        E '\n',
        STRING_AGG(DISTINCT(P2.product_name), ', ') || ' ' || TO_CHAR(MAX(Q3.minganancia), 'L9,999,999.99')
    ) AS productos
FROM
    (
        SELECT
            Q2.region_ids,
            MAX(Q2.maxganncia) AS maxganancia,
            MAX(Q2.minganancia) AS minganancia,
            ARRAY_AGG(maxProduct.product_id) AS productosmax,
            ARRAY_AGG(mingProduct.product_id) AS productosmin
        FROM
            (
                SELECT
                    Q1.region_ids,
                    MAX(Q1.totaldescuento) AS maxGanncia,
                    MIN(Q1.totaldescuento) AS minGanancia
                FROM
                    (
                        SELECT
                            empleadosporregion.region_ids,
                            OD.product_id,
                            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                        FROM
                            order_details AS OD
                            INNER JOIN orders AS O ON O.order_id = OD.order_id
                            INNER JOIN (
                                SELECT
                                    ET.employee_id,
                                    MAX(R.region_id) AS region_ids
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
                    ) AS Q1
                GROUP BY
                    Q1.region_ids
            ) AS Q2
            INNER JOIN (
                SELECT
                    empleadosporregion.region_ids,
                    OD.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                FROM
                    order_details AS OD
                    INNER JOIN orders AS O ON O.order_id = OD.order_id
                    INNER JOIN (
                        SELECT
                            ET.employee_id,
                            MAX(R.region_id) AS region_ids
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
            ) AS maxProduct ON maxProduct.region_ids = Q2.region_ids
            AND maxProduct.totaldescuento = Q2.maxGanncia
            INNER JOIN (
                SELECT
                    empleadosporregion.region_ids,
                    OD.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento
                FROM
                    order_details AS OD
                    INNER JOIN orders AS O ON O.order_id = OD.order_id
                    INNER JOIN (
                        SELECT
                            ET.employee_id,
                            MAX(R.region_id) AS region_ids
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
            ) AS mingProduct ON mingProduct.region_ids = Q2.region_ids
            AND mingProduct.totaldescuento = Q2.minGanancia
        GROUP BY
            Q2.region_ids
    ) AS Q3
    INNER JOIN products AS P ON P.product_id = ANY(Q3.productosmax)
    INNER JOIN products AS P2 ON P2.product_id = ANY(Q3.productosmin)
GROUP BY
    Q3.region_ids