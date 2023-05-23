SELECT
    OD.product_id,
    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_dinero,
    SUM(OD.quantity) AS total_cantidad,
    ARRAY_AGG(R.employee_id) AS empleados,
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
    R.region_ids = 1
GROUP BY
    OD.product_id
ORDER BY
    total_dinero DESC
LIMIT 1