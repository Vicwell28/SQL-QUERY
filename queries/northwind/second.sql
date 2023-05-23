-- POR TERRITORIOS
SELECT
    empleadosporregion.region_name AS name,
    TO_CHAR(
        SUM(totalventasporempleado.totaldescuento),
        'L9,999,999.99'
    ) as total, 
    string_agg(DISTINCT(empleadosporregion.t_names), ',')
FROM
    (
        SELECT
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento,
            O.employee_id
        FROM
            order_details AS OD
            INNER JOIN orders AS O ON O.order_id = OD.order_id
        GROUP BY
            O.employee_id
    ) AS totalventasporempleado
    INNER JOIN (
        SELECT
            ET.employee_id,
            MAX(R.region_id) AS region_ids,
            MAX(R.region_description) AS region_name,
            string_agg(DISTINCT(T.territory_description), ',') AS t_names
        FROM
            territories AS T
            INNER JOIN region AS R ON R.region_id = T.region_id
            INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id
        GROUP BY
            ET.employee_id
    ) AS empleadosporregion ON totalventasporempleado.employee_id = empleadosporregion.employee_id
GROUP BY
    empleadosporregion.region_ids,
    empleadosporregion.region_name
ORDER BY
        SUM(totalventasporempleado.totaldescuento)