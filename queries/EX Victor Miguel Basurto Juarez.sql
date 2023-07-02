REALIZAR UNA CONSULTA DONDE MUERSTER LOS PRODUCTO MAS GANANCIA QUE OBTUVIERON POR CATEGORIA, Y EN QUE AÑO DE PRODUJO ESA VANTA, POR REGION. 


//SE PRODUCNES LAS RELACIONES NECESTAIRAS PARA OBTENER EL PRODUCTO, CON SU GANANCIA, ASI COMO EL EMPEALDO QUE LO VENDIO Y SU CATEGRIA 

SELECT O.order_id, O.employee_id, O.order_date, C.category_id, (OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
FROM orders AS O
INNER JOIN order_details AS OD ON OD.order_id = O.order_id
INNER JOIN products AS P ON P.product_id = OD.product_id
INNER JOIN categories AS C ON C.category_id = P.category_id


//MUESTRA LOS PRODUCTOS MAS VENDISOS POR CATEGORIA
SELECT C.category_id, P.product_id, (OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
FROM orders AS O
INNER JOIN order_details AS OD ON OD.order_id = O.order_id
INNER JOIN products AS P ON P.product_id = OD.product_id
INNER JOIN categories AS C ON C.category_id = P.category_id


SELECT C.category_id, P.product_id
FROM orders AS O
INNER JOIN order_details AS OD ON OD.order_id = O.order_id
INNER JOIN products AS P ON P.product_id = OD.product_id
INNER JOIN categories AS C ON C.category_id = P.category_id
GROUP BY C.category_id, P.product_id


//POR REGION YA OBTENEMOS EL PRODUCTO CON MAS GANANCIAS
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

SELECT * FROM (

(SELECT C.category_id, P.product_id
FROM orders AS O
INNER JOIN order_details AS OD ON OD.order_id = O.order_id
INNER JOIN products AS P ON P.product_id = OD.product_id
INNER JOIN categories AS C ON C.category_id = P.category_id
GROUP BY C.category_id, P.product_id) AS Q1
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
) AS Q2 ON Q2.product_id = Q1.product_id

)

///EN ESTA CONSULTA SE OBTUO LAS GANANCIAS PRO REGION ASI COMO LOS PRODUCTOS
SELECT *
FROM (
SELECT
    Q2.region_ids,
    MAX(Q2.maxganncia) AS maxganancia,
    ARRAY_AGG(maxProduct.product_id) AS productosmax
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
    Q2.region_ids ) AS Q1
INNER JOIN products AS P ON P.product_id = any(Q1.productosmax)


///SE OBTIENE POR FECHA EL PRODUCTO MAS VENIDOD PARA PODER LIGARLO A LA SIG CONSULTA
SELECT O.order_date, P.product_id, SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
FROM orders AS O
INNER JOIN order_details AS OD ON OD.order_id = O.order_id
INNER JOIN products AS P ON P.product_id = OD.product_id
INNER JOIN categories AS C ON C.category_id = P.category_id
GROUP BY O.order_date, P.product_id


SELECT O.order_date, P.product_id, SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
FROM orders AS O
INNER JOIN order_details AS OD ON OD.order_id = O.order_id
INNER JOIN products AS P ON P.product_id = OD.product_id
INNER JOIN categories AS C ON C.category_id = P.category_id
WHERE P.product_id = 24
GROUP BY O.order_date, P.product_id