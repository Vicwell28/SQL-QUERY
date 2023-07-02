SELECT
    O.order_id,
    O.employee_id,
    O.order_date,
    C.category_id,
    (OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
FROM
    orders AS O
    INNER JOIN order_details AS OD ON OD.order_id = O.order_id
    INNER JOIN products AS P ON P.product_id = OD.product_id
    INNER JOIN categories AS C ON C.category_id = P.category_id 
    
// MOSTRAR PRODUCTOS CON SU GANANCIA Y SU CATEGORIA
SELECT
    C.category_id,
    P.product_id,
    (OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
FROM
    orders AS O
    INNER JOIN order_details AS OD ON OD.order_id = O.order_id
    INNER JOIN products AS P ON P.product_id = OD.product_id
    INNER JOIN categories AS C ON C.category_id = P.category_id 

// AGRUPAR POR CATEGORIA Y SUMAR LA GANANCIA DE CADA PRODUCTO
SELECT
    C.category_id,
    P.product_id,
    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
FROM
    orders AS O
    INNER JOIN order_details AS OD ON OD.order_id = O.order_id
    INNER JOIN products AS P ON P.product_id = OD.product_id
    INNER JOIN categories AS C ON C.category_id = P.category_id
GROUP BY
    C.category_id,
    P.product_id 

// SACAR LA MAYOR GANANCIA OBTENIDA DE UN PRODUCTO POR CATEGORIA
SELECT
    ProductoConMayorGananciaPorCategoria.category_id,
    MAX(ProductoConMayorGananciaPorCategoria.ganancia)
FROM
    (
        SELECT
            C.category_id,
            P.product_id,
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
        FROM
            orders AS O
            INNER JOIN order_details AS OD ON OD.order_id = O.order_id
            INNER JOIN products AS P ON P.product_id = OD.product_id
            INNER JOIN categories AS C ON C.category_id = P.category_id
        GROUP BY
            C.category_id,
            P.product_id
    ) AS ProductoConMayorGananciaPorCategoria
GROUP BY
    ProductoConMayorGananciaPorCategoria.category_id 
    
// CONSULTAR LOS PRODUCTSO CON MAYOR GANANCIA PRO CATEGORIA
SELECT
    *
FROM
    (
        SELECT
            C.category_id,
            P.product_id,
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
        FROM
            orders AS O
            INNER JOIN order_details AS OD ON OD.order_id = O.order_id
            INNER JOIN products AS P ON P.product_id = OD.product_id
            INNER JOIN categories AS C ON C.category_id = P.category_id
        GROUP BY
            C.category_id,
            P.product_id
    ) AS ProductosConSuGananciaYCategoria
    INNER JOIN (
        SELECT
            ProductoConMayorGananciaPorCategoria.category_id,
            MAX(ProductoConMayorGananciaPorCategoria.ganancia) AS MaxGanancia
        FROM
            (
                SELECT
                    C.category_id,
                    P.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
                FROM
                    orders AS O
                    INNER JOIN order_details AS OD ON OD.order_id = O.order_id
                    INNER JOIN products AS P ON P.product_id = OD.product_id
                    INNER JOIN categories AS C ON C.category_id = P.category_id
                GROUP BY
                    C.category_id,
                    P.product_id
            ) AS ProductoConMayorGananciaPorCategoria
        GROUP BY
            ProductoConMayorGananciaPorCategoria.category_id
    ) AS MayorGananciaGeneradoPorCategoria ON MayorGananciaGeneradoPorCategoria.category_id = ProductosConSuGananciaYCategoria.category_id
    AND MayorGananciaGeneradoPorCategoria.MaxGanancia = ProductosConSuGananciaYCategoria.ganancia

    
// VAMOS A AGURPAR POR CATEGORIA Y JUNTAR LSO PRODUCTOS QUE OBTUVIERON LA MISMA GANANCIA
SELECT
    ProductosConSuGananciaYCategoria.category_id,
    ARRAY_AGG(ProductosConSuGananciaYCategoria.product_id) AS product_ids
FROM
    (
        SELECT
            C.category_id,
            P.product_id,
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
        FROM
            orders AS O
            INNER JOIN order_details AS OD ON OD.order_id = O.order_id
            INNER JOIN products AS P ON P.product_id = OD.product_id
            INNER JOIN categories AS C ON C.category_id = P.category_id
        GROUP BY
            C.category_id,
            P.product_id
    ) AS ProductosConSuGananciaYCategoria
    INNER JOIN (
        SELECT
            ProductoConMayorGananciaPorCategoria.category_id,
            MAX(ProductoConMayorGananciaPorCategoria.ganancia) AS MaxGanancia
        FROM
            (
                SELECT
                    C.category_id,
                    P.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
                FROM
                    orders AS O
                    INNER JOIN order_details AS OD ON OD.order_id = O.order_id
                    INNER JOIN products AS P ON P.product_id = OD.product_id
                    INNER JOIN categories AS C ON C.category_id = P.category_id
                GROUP BY
                    C.category_id,
                    P.product_id
            ) AS ProductoConMayorGananciaPorCategoria
        GROUP BY
            ProductoConMayorGananciaPorCategoria.category_id
    ) AS MayorGananciaGeneradoPorCategoria ON MayorGananciaGeneradoPorCategoria.category_id = ProductosConSuGananciaYCategoria.category_id
    AND MayorGananciaGeneradoPorCategoria.MaxGanancia = ProductosConSuGananciaYCategoria.ganancia
GROUP BY
    ProductosConSuGananciaYCategoria.category_id 
    
//SACAMOS LA FECHA DONDE SE OBTUVO LA MAYOR GANANCIA DE UN DETERMINADO PRODUCTO
SELECT
    O.employee_id,
    P.product_id,
    O.order_date,
    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
FROM
    orders AS O
    INNER JOIN order_details AS OD ON OD.order_id = O.order_id
    INNER JOIN products AS P ON P.product_id = OD.product_id
    INNER JOIN categories AS C ON C.category_id = P.category_id
GROUP BY
    O.employee_id,
    P.product_id,
    O.order_date 
    
// SACAR EL PRODUCTO CON MAYOR GANANCIA PRO FECHA DE DETERMIANDADA REGION
SELECT
    Q3.*,
    Q4.region_id
FROM
    (
        SELECT
            Q2.product_id,
            Q2.ganancia,
            Q1.employee_id,
            Q1.order_date,
            Q1.category_id
        FROM
            (
                SELECT
                    FechaDondeSeObtuvoLaMayorGnanaciaDeUnProducto.product_id,
                    MAX(ganancia) AS Ganancia
                FROM
                    (
                        SELECT
                            O.employee_id,
                            P.product_id,
                            O.order_date,
                            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
                        FROM
                            orders AS O
                            INNER JOIN order_details AS OD ON OD.order_id = O.order_id
                            INNER JOIN products AS P ON P.product_id = OD.product_id
                            INNER JOIN categories AS C ON C.category_id = P.category_id
                        GROUP BY
                            O.employee_id,
                            P.product_id,
                            O.order_date
                    ) AS FechaDondeSeObtuvoLaMayorGnanaciaDeUnProducto
                GROUP BY
                    FechaDondeSeObtuvoLaMayorGnanaciaDeUnProducto.product_id
            ) AS Q2
            INNER JOIN (
                SELECT
                    O.employee_id,
                    P.product_id,
                    O.order_date,
                    MAX(C.category_id) AS category_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
                FROM
                    orders AS O
                    INNER JOIN order_details AS OD ON OD.order_id = O.order_id
                    INNER JOIN products AS P ON P.product_id = OD.product_id
                    INNER JOIN categories AS C ON C.category_id = P.category_id
                GROUP BY
                    O.employee_id,
                    P.product_id,
                    O.order_date
            ) AS Q1 ON Q1.product_id = Q2.product_id
            AND Q1.ganancia = Q2.ganancia
    ) AS Q3
    INNER JOIN (
        SELECT
            ET.employee_id,
            MAX(R.region_id) AS region_id
        FROM
            territories AS T
            INNER JOIN region AS R ON R.region_id = T.region_id
            INNER JOIN employee_territories AS ET ON ET.territory_id = T.territory_id
        GROUP BY
            ET.employee_id
    ) AS Q4 ON Q4.employee_id = Q3.employee_id 
    



/ / / / CREACION DE VISTAS 
CREATE VIEW ProductosConMayorGnanaciaPorCategoria AS 

CREATE VIEW ProductosConMayorVentaEnDeterminadaFechaPorRegion AS
SELECT
    *
FROM
    ProductosConMayorGnanaciaPorCategoria
SELECT
    *
FROM
    ProductosConMayorVentaEnDeterminadaFechaPorRegion 
    
CREATE VIEW ProductosConMayorGnanaciaPorCategoriaName AS
SELECT
    C.*,
    ProductosConMayorGnanaciaPorCategoria.product_ids
FROM
    ProductosConMayorGnanaciaPorCategoria
    INNER JOIN categories AS C ON C.category_id = ProductosConMayorGnanaciaPorCategoria.category_id 



CREATE OR REPLACE VIEW productosconmayorventaendeterminadafechaporregionname AS
SELECT p.product_name,
	MAX(p.product_id) AS product_id,
    MAX(q1.order_date) AS order_date,
    MAX(q1.category_id) AS category_id,
	MAX(r.region_id) AS region_id,
    r.region_description
   FROM ((productosconmayorventaendeterminadafechaporregion q1
     JOIN products p ON ((p.product_id = q1.product_id)))
     JOIN region r ON ((r.region_id = q1.region_id)))
	GROUP BY r.region_description, p.product_name;
    
    

CREATE VIEW AS
SELECT
    ProductosConSuGananciaYCategoria.category_id,
    ARRAY_AGG(ProductosConSuGananciaYCategoria.product_id) AS product_ids
FROM
    (
        SELECT
            C.category_id,
            P.product_id,
            SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
        FROM
            orders AS O
            INNER JOIN order_details AS OD ON OD.order_id = O.order_id
            INNER JOIN products AS P ON P.product_id = OD.product_id
            INNER JOIN categories AS C ON C.category_id = P.category_id
        GROUP BY
            C.category_id,
            P.product_id
    ) AS ProductosConSuGananciaYCategoria
    INNER JOIN (
        SELECT
            ProductoConMayorGananciaPorCategoria.category_id,
            MAX(ProductoConMayorGananciaPorCategoria.ganancia) AS MaxGanancia
        FROM
            (
                SELECT
                    C.category_id,
                    P.product_id,
                    SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS ganancia
                FROM
                    orders AS O
                    INNER JOIN order_details AS OD ON OD.order_id = O.order_id
                    INNER JOIN products AS P ON P.product_id = OD.product_id
                    INNER JOIN categories AS C ON C.category_id = P.category_id
                GROUP BY
                    C.category_id,
                    P.product_id
            ) AS ProductoConMayorGananciaPorCategoria
        GROUP BY
            ProductoConMayorGananciaPorCategoria.category_id
    ) AS MayorGananciaGeneradoPorCategoria ON MayorGananciaGeneradoPorCategoria.category_id = ProductosConSuGananciaYCategoria.category_id
    AND MayorGananciaGeneradoPorCategoria.MaxGanancia = ProductosConSuGananciaYCategoria.ganancia
GROUP BY
    ProductosConSuGananciaYCategoria.category_id

/ / RESULTADO FINA
SELECT
    Q1.category_name,
    R1.name AS Eastern,
    R2.name AS Western,
    R3.name AS Norther,
    R4.name AS Southern
FROM
    ProductosConMayorGnanaciaPorCategoriaName AS Q1
    LEFT JOIN (
        SELECT
            CONCAT(Q1.product_name, ' ', Q1.order_date) AS name,
            Q1.product_id
        FROM
            ProductosConMayorVentaEnDeterminadaFechaPorRegionName AS Q1
        WHERE
            Q1.region_id = 1
    ) AS R1 ON R1.product_id = ANY(Q1.product_ids)
    LEFT JOIN (
        SELECT
            CONCAT(Q1.product_name, ' ', Q1.order_date) AS name,
            Q1.product_id
        FROM
            ProductosConMayorVentaEnDeterminadaFechaPorRegionName AS Q1
        WHERE
            Q1.region_id = 2
    ) AS R2 ON R2.product_id = ANY(Q1.product_ids)
    LEFT JOIN (
        SELECT
            CONCAT(Q1.product_name, ' ', Q1.order_date) AS name,
            Q1.product_id
        FROM
            ProductosConMayorVentaEnDeterminadaFechaPorRegionName AS Q1
        WHERE
            Q1.region_id = 3
    ) AS R3 ON R3.product_id = ANY(Q1.product_ids)
    LEFT JOIN (
        SELECT
            CONCAT(Q1.product_name, ' ', Q1.order_date) AS name,
            Q1.product_id
        FROM
            ProductosConMayorVentaEnDeterminadaFechaPorRegionName AS Q1
        WHERE
            Q1.region_id = 4
    ) AS R4 ON R4.product_id = ANY(Q1.product_ids)