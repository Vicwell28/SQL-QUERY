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

    REALIZAR UNA CONSULTA DONDE MUESTRE LOS PRODUCTOS CON MAS GANANCIAS QUE OBTUVIERON POR CATEGORIA,
    Y EN QUE AÑO DE PROUDJO ESA VENTA,
    POR REGION.




