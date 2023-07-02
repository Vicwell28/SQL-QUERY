SELECT productoporregion.region_ids, MAX(productoporregion.ganancia)
FROM (
		SELECT
    empleadosporregion.region_ids,
    OD.product_id,
    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
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
	) AS productoporregion
GROUP BY productoporregion.region_ids