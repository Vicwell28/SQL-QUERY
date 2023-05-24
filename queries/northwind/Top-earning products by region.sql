-- OBTERNER EL PRODUCTO MAS VENDIDO POR REGION
SELECT
  OD.*,
  (OD.quantity * OD.unit_price * (1 - OD.discount)) AS total,
  O.*,
  R.*
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
  ) AS R ON R.employee_id = O.employee_id --PRODUCTOS VENDIDOS POR REGION + ARREGLO DE LOS EMPLEADOS
SELECT
  R.region_ids,
  OD.product_id,
  SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total,
  SUM(OD.quantity),
  ARRAY_AGG(O.employee_id)
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
GROUP BY
  R.region_ids,
  OD.product_id -- PRODUCTOS VENDIDOS POR CADA EMPLEADO
SELECT
  O.employee_id,
  OD.product_id,
  SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_ventas_dinero,
  SUM(OD.quantity) AS total_ventas_cantidad
FROM
  order_details AS OD
  INNER JOIN orders AS O ON O.order_id = OD.order_id
GROUP BY
  O.employee_id,
  OD.product_id --UTILZIANDO LA CLAUSULA PARTITION PARA AGRUPAR POR 
SELECT
  employee_id,
  product_id,
  total_ventas_dinero,
  total_ventas_cantidad
FROM
  (
    SELECT
      O.employee_id,
      OD.product_id,
      SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_ventas_dinero,
      SUM(OD.quantity) AS total_ventas_cantidad,
      MAX(SUM(OD.quantity)) OVER (PARTITION BY O.employee_id) AS max_total_ventas_cantidad
    FROM
      order_details AS OD
      INNER JOIN orders AS O ON O.order_id = OD.order_id
    GROUP BY
      O.employee_id,
      OD.product_id
  ) AS RES
WHERE
  total_ventas_cantidad = max_total_ventas_cantidad;

--UTILZIANDO LA CLAUSULA PARTITION PARA AGRUPAR POR 
SELECT
  employee_id,
  product_id,
  total_ventas_dinero,
  total_ventas_cantidad
FROM
  (
    SELECT
      O.employee_id,
      OD.product_id,
      SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_ventas_dinero,
      SUM(OD.quantity) AS total_ventas_cantidad,
      MAX(
        SUM(OD.quantity * OD.unit_price * (1 - OD.discount))
      ) OVER (PARTITION BY O.employee_id) AS max_total_ventas_dinero
    FROM
      order_details AS OD
      INNER JOIN orders AS O ON O.order_id = OD.order_id
    GROUP BY
      O.employee_id,
      OD.product_id
  ) AS RES
WHERE
  total_ventas_dinero = max_total_ventas_dinero;

-- PRODUCTO MAS VENDIDO POR CADA EMPLEADO
SELECT
  OD.product_id,
  SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_cantidad_dinero,
  SUM(OD.quantity) AS total_cantidad_unidades
FROM
  order_details AS OD
  INNER JOIN orders AS O ON O.order_id = OD.order_id
WHERE
  O.employee_id = 1
GROUP BY
  OD.product_id
ORDER BY
  total_cantidad_dinero DESC
LIMIT
  1
SELECT
  RES.employee_id,
  RES.product_id,
  RES.total_ventas_dinero,
  RES.total_ventas_cantidad,
  R.*
FROM
  (
    SELECT
      O.employee_id,
      OD.product_id,
      SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_ventas_dinero,
      SUM(OD.quantity) AS total_ventas_cantidad,
      MAX(
        SUM(OD.quantity * OD.unit_price * (1 - OD.discount))
      ) OVER (PARTITION BY O.employee_id) AS max_total_ventas_dinero
    FROM
      order_details AS OD
      INNER JOIN orders AS O ON O.order_id = OD.order_id
    GROUP BY
      O.employee_id,
      OD.product_id
  ) AS RES
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
  ) AS R ON R.employee_id = RES.employee_id
WHERE
  total_ventas_dinero = max_total_ventas_dinero;

SELECT
  RES.employee_id,
  RES.product_id,
  RES.total_ventas_dinero,
  RES.total_ventas_cantidad,
  R.*
FROM
  (
    SELECT
      O.employee_id,
      OD.product_id,
      SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_ventas_dinero,
      SUM(OD.quantity) AS total_ventas_cantidad,
      MAX(
        SUM(OD.quantity * OD.unit_price * (1 - OD.discount))
      ) OVER (PARTITION BY O.employee_id) AS max_total_ventas_dinero
    FROM
      order_details AS OD
      INNER JOIN orders AS O ON O.order_id = OD.order_id
    GROUP BY
      O.employee_id,
      OD.product_id
  ) AS RES
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
  ) AS R ON R.employee_id = RES.employee_id
WHERE
  total_ventas_dinero = max_total_ventas_dinero;

---FINAL
SELECT
  region.region_description,
  products.product_name,
  RES.total_cantidad,
  TO_CHAR(RES.max, 'L9,999,999.99')
FROM
  (
    SELECT
      empleadosporregion.region_ids,
      OD.product_id,
      SUM(OD.quantity * OD.unit_price * (1 - OD.discount)) AS total_dinero,
      SUM(OD.quantity) AS total_cantidad,
      MAX(
        SUM(OD.quantity * OD.unit_price * (1 - OD.discount))
      ) OVER (PARTITION BY empleadosporregion.region_ids)
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
  ) AS RES
  INNER JOIN region ON region.region_id = RES.region_ids
  INNER JOIN products ON products.product_id = RES.product_id
WHERE
  RES.total_dinero = RES.max