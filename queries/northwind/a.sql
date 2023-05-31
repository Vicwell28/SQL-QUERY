SELECT
    Q2.region_ids,
    MAX(Q2.maxganncia) as maxganancia,
    MAX(Q2.minganancia) as minganancia,
    ARRAY_AGG(maxProduct.product_id) as productosmax,
    ARRAY_AGG(mingProduct.product_id) as productosmin
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
    ) AS Q2
    INNER JOIN (
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
    ) AS maxProduct ON maxProduct.region_ids = Q2.region_ids
    AND maxProduct.totaldescuento = Q2.maxGanncia
    INNER JOIN (
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
    ) AS mingProduct ON mingProduct.region_ids = Q2.region_ids
    AND mingProduct.totaldescuento = Q2.minGanancia
GROUP BY
    Q2.region_ids