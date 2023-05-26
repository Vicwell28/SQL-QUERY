--- PONER EN LA MISMA CELDA LOS PRODUCTOS CON MAXIMA GANANCIA Y LOS PRODUCTOS CON MENOS GANANCIA POR REGION
SELECT
    Q1.region_ids,
    Q1.product_id,
    SUM(Q1.totaldescuento),
    SUM(Q1.quantity)
FROM
    (
        SELECT
            OD.order_id,
            OD.product_id,
            OD.quantity,
            (OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento,
            empleadosporregion.employee_id,
            empleadosporregion.region_ids
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
    ) AS Q1
GROUP BY
    Q1.region_ids,
    Q1.product_id --- Q1
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
    OD.product_id ---Q2
SELECT
    Q1.region_idS,
    MAX(Q1.totaldescuento) as ganancia
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
    Q1.region_ids ---Q3
SELECT
    Q1.region_ids,
    Q2.ganancia,
    ARRAY_AGG(Q1.product_id) AS product_ids
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
    INNER JOIN (
        SELECT
            Q1.region_idS,
            MAX(Q1.totaldescuento) as ganancia
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
            Q1.region_ids
    ) AS Q2 ON Q1.region_ids = Q2.region_ids
    AND Q1.totaldescuento = Q2.ganancia
GROUP BY
    Q1.region_ids,
    Q2.ganancia ---Q4
SELECT
    R.region_description,
    P.product_name,
    Q3.ganancia
FROM
    (
        SELECT
            Q1.region_ids,
            Q2.ganancia,
            ARRAY_AGG(Q1.product_id) AS product_ids
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
            INNER JOIN (
                SELECT
                    Q1.region_idS,
                    MAX(Q1.totaldescuento) as ganancia
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
                    Q1.region_ids
            ) AS Q2 ON Q1.region_ids = Q2.region_ids
            AND Q1.totaldescuento = Q2.ganancia
        GROUP BY
            Q1.region_ids,
            Q2.ganancia
    ) AS Q3
    INNER JOIN region AS R ON R.region_id = Q3.region_ids
    INNER JOIN products AS P ON P.product_id = ANY(Q3.product_ids)