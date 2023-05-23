SELECT * 
FROM order_details AS OD 
INNER JOIN orders AS O ON O.order_id = OD.order_id

//COMPROBACION
SELECT SUM( OD.quantity * OD.unit_price * (1 - OD.discount)) AS totalVentas
FROM order_details AS OD

//LO QUE VENDIO CADA EMPLEADO
SELECT SUM( OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento, O.employee_id
FROM order_details AS OD
INNER JOIN orders AS O ON O.order_id = OD.order_id
GROUP BY O.employee_id


//MOSTAR LOS TERITORIOS Y REGION ES DE UN EMPEALOD
SELECT * FROM territories AS T
INNER JOIN region AS R ON R.region_id = T.region_id
INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id


//OBTENER EL EMPLEADO ID CON EL ARREGLO DE LAS REGIOES A LAS CUALES ESTA DADO DE ALTOA
SELECT ET.employee_id, ARRAY_AGG(R.region_id) AS region_ids, ARRAY_AGG(R.region_description) FROM territories AS T
INNER JOIN region AS R ON R.region_id = T.region_id
INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id
GROUP BY ET.employee_id


//LOS EMPLEAOD QUE PERTENECEA A UNA DETRMINADAD REGION 
SELECT ET.employee_id, MAX(R.region_id) AS region_ids, MAX(R.region_description) AS region_name FROM territories AS T
INNER JOIN region AS R ON R.region_id = T.region_id
INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id
GROUP BY ET.employee_id


///RESULTADO 
SELECT R.region_description, TO_CHAR(ventasRegion.total, 'L9,999,999.99') AS total_ventas 
FROM
(
    SELECT SUM(totalventasporempleado.totaldescuento) as total, empleadosporregion.region_ids as region_id
        FROM (
            SELECT SUM( OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento, O.employee_id
            FROM order_details AS OD
            INNER JOIN orders AS O ON O.order_id = OD.order_id
            GROUP BY O.employee_id
        ) AS totalventasporempleado
    INNER JOIN (
            SELECT ET.employee_id, MAX(R.region_id) AS region_ids FROM territories AS T
            INNER JOIN region AS R ON R.region_id = T.region_id
            INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id
            GROUP BY ET.employee_id
        ) AS empleadosporregion ON totalventasporempleado.employee_id = empleadosporregion.employee_id
    GROUP BY empleadosporregion.region_ids
) AS ventasRegion 
INNER JOIN region AS R ON R.region_id = ventasRegion.region_id
ORDER BY ventasRegion.total



//OBTERNER EL PRODUCTO MAS VENDIDO POR REGION

SELECT R.region_description, TO_CHAR(ventasRegion.total, 'L9,999,999.99') AS total_ventas 
FROM
(
    SELECT SUM(totalventasporempleado.totaldescuento) as total, empleadosporregion.region_ids as region_id
        FROM (
            SELECT SUM( OD.quantity * OD.unit_price * (1 - OD.discount)) AS totaldescuento, O.employee_id
            FROM order_details AS OD
            INNER JOIN orders AS O ON O.order_id = OD.order_id
            GROUP BY O.employee_id
        ) AS totalventasporempleado
    INNER JOIN (
             SELECT ET.employee_id, MAX(R.region_id) AS region_ids,  string_agg(DISTINCT(T.territory_description), ',') AS t_names FROM territories AS T 
            INNER JOIN region AS R ON R.region_id = T.region_id
            INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id
            GROUP BY ET.employee_id
        ) AS empleadosporregion ON totalventasporempleado.employee_id = empleadosporregion.employee_id
    GROUP BY empleadosporregion.region_ids
) AS ventasRegion 
INNER JOIN region AS R ON R.region_id = ventasRegion.region_id
ORDER BY ventasRegion.total




-- Obtener total por region
SELECT
    empleadosporregion.region_name AS name,
    TO_CHAR(
        SUM(totalventasporempleado.totaldescuento),
        'L9,999,999.99'
    ) as total
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
            MAX(R.region_description) AS region_name
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
    TO_CHAR(
        SUM(totalventasporempleado.totaldescuento),
        'L9,999,999.99'
    ) ASC

