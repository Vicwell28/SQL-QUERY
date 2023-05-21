/*
PostgreSQL Backup
Database: pubs/public
Backup Time: 2023-05-09 19:46:09
*/

DROP TABLE IF EXISTS "public"."_authors";
DROP TABLE IF EXISTS "public"."_discounts";
DROP TABLE IF EXISTS "public"."_employee";
DROP TABLE IF EXISTS "public"."_jobs";
DROP TABLE IF EXISTS "public"."_publishers";
DROP TABLE IF EXISTS "public"."_roysched";
DROP TABLE IF EXISTS "public"."_sales";
DROP TABLE IF EXISTS "public"."_stores";
DROP TABLE IF EXISTS "public"."_titleauthor";
DROP TABLE IF EXISTS "public"."_titles";
DROP FUNCTION IF EXISTS "public"."proc_acciones(v_pagina varchar, fecha_inicio timestamp, fecha_fin timestamp)";
DROP FUNCTION IF EXISTS "public"."proc_acciones_general(fecha_inicio timestamp, fecha_fin timestamp)";
DROP FUNCTION IF EXISTS "public"."proc_con_sin_aseguradora(v_inicio timestamp, v_fin timestamp)";
DROP FUNCTION IF EXISTS "public"."proc_cotiza_aseguradora(v_inicio timestamp, v_fin timestamp)";
DROP FUNCTION IF EXISTS "public"."proc_cotizaciones(v_inicio timestamp, v_fin timestamp)";
DROP FUNCTION IF EXISTS "public"."proc_emision_aseguradora(v_inicio timestamp, v_fin timestamp)";
DROP FUNCTION IF EXISTS "public"."proc_emisiones(v_inicio timestamp, v_fin timestamp)";
DROP FUNCTION IF EXISTS "public"."proc_total_aseguradora(v_inicio timestamp, v_fin timestamp)";
CREATE TABLE "_authors" (
  "au_id" varchar(11) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "au_lname" varchar(14) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "au_fname" varchar(11) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "phone" varchar(12) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "address" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "city" varchar(14) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "state" varchar(2) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "zip" int4,
  "contract" int2
)
;
ALTER TABLE "_authors" OWNER TO "postgres";
CREATE TABLE "_discounts" (
  "discounttype" varchar(17) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "stor_id" varchar(4) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "lowqty" varchar(3) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "highqty" varchar(4) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "discount" numeric(4,2) DEFAULT NULL::numeric
)
;
ALTER TABLE "_discounts" OWNER TO "postgres";
CREATE TABLE "_employee" (
  "emp_id" varchar(9) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "fname" varchar(9) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "minit" varchar(1) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "lname" varchar(9) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "job_id" int2,
  "job_lvl" int2,
  "pub_id" int2,
  "hire_date" int4
)
;
ALTER TABLE "_employee" OWNER TO "postgres";
CREATE TABLE "_jobs" (
  "job_id" int2,
  "job_desc" varchar(28) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "min_lvl" int2,
  "max_lvl" int2
)
;
ALTER TABLE "_jobs" OWNER TO "postgres";
CREATE TABLE "_publishers" (
  "pub_id" int2,
  "pub_name" varchar(21) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "city" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "state" varchar(2) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "country" varchar(7) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;
ALTER TABLE "_publishers" OWNER TO "postgres";
CREATE TABLE "_roysched" (
  "title_id" varchar(6) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "lorange" int4,
  "hirange" int4,
  "royalty" int2
)
;
ALTER TABLE "_roysched" OWNER TO "postgres";
CREATE TABLE "_sales" (
  "stor_id" int2,
  "ord_num" varchar(8) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "ord_date" int4,
  "qty" int2,
  "payterms" varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "title_id" varchar(6) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;
ALTER TABLE "_sales" OWNER TO "postgres";
CREATE TABLE "_stores" (
  "stor_id" int2,
  "stor_name" varchar(36) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "stor_address" varchar(19) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "city" varchar(9) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "state" varchar(2) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "zip" int4
)
;
ALTER TABLE "_stores" OWNER TO "postgres";
CREATE TABLE "_titleauthor" (
  "au_id" varchar(11) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "title_id" varchar(6) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "au_ord" int2,
  "royaltyper" int2
)
;
ALTER TABLE "_titleauthor" OWNER TO "postgres";
CREATE TABLE "_titles" (
  "title_id" varchar(6) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "title" varchar(63) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "type" varchar(12) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "pub_id" int2,
  "price" numeric(4,2) DEFAULT NULL::numeric,
  "advance" numeric(7,2) DEFAULT NULL::numeric,
  "royalty" int2,
  "ytd_sales" int4,
  "notes" varchar(179) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying
)
;
ALTER TABLE "_titles" OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "proc_acciones"("v_pagina" varchar, "fecha_inicio" timestamp, "fecha_fin" timestamp)
  RETURNS TABLE("accion" varchar, "total" int8) AS $BODY$
                  begin
                    return query select au.accion, count(distinct token) as total
                    from accion_usuarios as au
                    where pagina = v_pagina and date(created_at) between fecha_inicio and fecha_fin
                    group by au.accion;
                  end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "proc_acciones"("v_pagina" varchar, "fecha_inicio" timestamp, "fecha_fin" timestamp) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "proc_acciones_general"("fecha_inicio" timestamp, "fecha_fin" timestamp)
  RETURNS TABLE("accion" varchar, "total" int8) AS $BODY$
                  begin
                    return query select distinct au.pagina as accion, count(au.token) as total
                    from accion_usuarios as au
                    where (date(au.created_at) between fecha_inicio and fecha_fin) and au.accion='btn-final'
                    group by au.pagina;
                  end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "proc_acciones_general"("fecha_inicio" timestamp, "fecha_fin" timestamp) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "proc_con_sin_aseguradora"("v_inicio" timestamp, "v_fin" timestamp)
  RETURNS TABLE("con" int8, "sin" int8) AS $BODY$
                  begin
                      return query select count(nullif(c."cotizacion_id", 0)) as con, 
											count(*) - count(nullif(c."cotizacion_id", 0)) as sin
                      from opcionales o
                      left join cotizas c on c.session=o.session
                      where o.session != '00001' and date(o.created_at) between v_inicio and v_fin;
                  end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "proc_con_sin_aseguradora"("v_inicio" timestamp, "v_fin" timestamp) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "proc_cotiza_aseguradora"("v_inicio" timestamp, "v_fin" timestamp)
  RETURNS TABLE("id" int4, "aseguradora" varchar, "total" int8) AS $BODY$
                  begin
                      return query  select ca."Id", ca."Abr" as aseguradora, count(c.id) as total 
                      from companias_activas ca
                      left join cotizas c on ca."Id" = c.compania and c.cotizacion_id != 0
                      left join opcionales as o on c.session=o.session
                      and date(o.created_at) between v_inicio and v_fin
                      group by ca."Id", ca."Abr";
                  end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "proc_cotiza_aseguradora"("v_inicio" timestamp, "v_fin" timestamp) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "proc_cotizaciones"("v_inicio" timestamp, "v_fin" timestamp)
  RETURNS TABLE("id" int4, "session" varchar, "aseguradora" varchar, "cotiza_aseg" varchar, "nombre" text, "email" varchar, "telefono" varchar, "cp" int4, "edad" int4, "cotizacion" varchar, "marca" varchar, "modelo" varchar, "tipo" varchar, "creada" timestamp, "tipo_paquete" text, "tipo_pago" text) AS $BODY$
                  begin
                      return query select c.id, c.session, coalesce(ca."Abr", 'sin aseguradora') as aseguradora, coalesce(c.compania_cotizacion::varchar,'-') as cotiza_aseg,
                      concat(coalesce(dt.ap_paterno, ''), ' ', coalesce(dt.ap_materno, ''),' ', coalesce(dt.primer_nombre, ''), ' ', coalesce(dt.segundo_nombre, '')) as nombre,
                      coalesce(dt.email,'-') as email, coalesce(dt.telefono::varchar,'-') as telefono, o.cp, o.edad, coalesce(c.cotizacion_id::varchar, '-') as cotizacion,
                      o.marca, o.modelo, o.submarca as tipo, c.created_at as creada,
                      coalesce ( nullif ( pq."display_name", '' ), pq."Descripcion" ) as tipo_paquete,
                      coalesce ( nullif ( fp."display_name", '' ), fp."Descripcion" ) as tipo_pago
                      from opcionales o 
                      left join dato_usuarios dt on dt.session=o.session
                      left join cotizas c on c.session=dt.session
                      left join companias_activas as ca on ca."Id"=c.compania
                      inner join paquetes as pq on pq."Id"= c.paquete
                      inner join forma_pagos fp on fp."Id"= c.forma_pago
                      where o.created_at between v_inicio and v_fin
                      order by c.created_at desc;
                  end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "proc_cotizaciones"("v_inicio" timestamp, "v_fin" timestamp) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "proc_emision_aseguradora"("v_inicio" timestamp, "v_fin" timestamp)
  RETURNS TABLE("id" int4, "aseguradora" varchar, "total" int8) AS $BODY$
                  begin
                      return query select ca."Id", ca."Abr" as aseguradora, count(p.id) as total 
                      from companias_activas ca
                      left join cotizas c on ca."Id" = c.compania
                      left join polizas p on c.session = p.session and p.cotizacion_id != 0
                      left join opcionales as o on c.session = o.session
                      and date(o.created_at) between v_inicio and v_fin
                      group by ca."Id", ca."Abr";
                  end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "proc_emision_aseguradora"("v_inicio" timestamp, "v_fin" timestamp) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "proc_emisiones"("v_inicio" timestamp, "v_fin" timestamp)
  RETURNS TABLE("id" int4, "session" varchar, "aseguradora" varchar, "cotiza_aseg" varchar, "nombre" text, "email" varchar, "telefono" varchar, "cp" int4, "edad" int4, "cotizacion" varchar, "marca" varchar, "modelo" varchar, "tipo" varchar, "poliza" varchar, "poliza_est" varchar, "poliza_url" text, "creada" timestamp, "pago_url" varchar, "revisa_url" varchar, "vigencia_inicial" text, "vigencia_final" text, "cliente" varchar, "tarjeta" text, "estado_tarjeta" bool, "prima_total" float4, "aseg_total" float4, "primer_pago" float4, "aseg_inicial" float4, "pagos_sub" float4, "aseg_sub" float4, "proximo_pago" text, "recibos" text, "recibo_actual" int4, "tipo_paquete" text, "tipo_pago" text) AS $BODY$
                  begin
                      return query select c.id, c.session, coalesce(ca."Abr", 'sin aseguradora') as aseguradora, coalesce(c.compania_cotizacion,'-') as cotiza_aseg,
                      concat(coalesce(dt.ap_paterno, ''), ' ', coalesce(dt.ap_materno, ''),' ', coalesce(dt.primer_nombre, ''), ' ', coalesce(dt.segundo_nombre, '')) as nombre,
                      coalesce(dt.email,'-') as email, coalesce(dt.telefono::varchar,'-') as telefono, o.cp, o.edad, coalesce(c.cotizacion_id::varchar, '-') as cotizacion,
                      o.marca, o.modelo, o.submarca as tipo, coalesce(p.poliza, '-') as poliza, coalesce(p.poliza_estevane, '-') as poliza_est, coalesce(p.poliza_url, '-') as poliza_url, 
                      p.created_at as creada, coalesce(p.pago_url, '-') as pago_url, coalesce(p.revisa_url, '-') as revisa_url,
                      to_char(p.vigencia_inicial,'YYYY-MM-DD') as vigencia_inicial, to_char(p.vigencia_final,'YYYY-MM-DD') as vigencia_final,
                      coalesce(p.id_cliente, '-') as cliente, coalesce ( nullif ( p."id_tarjeta", '0' ), '-' ) as tarjeta,
                      p.estado_tarjeta, c.prima_total, c.aseg_total, c.primer_pago, c.aseg_inicial, c.pagos_sub, 
                      c.aseg_sub, coalesce(to_char(c.proximo_pago,'YYYY-MM-DD'), '-') as proximo_pago,  
                      coalesce ( concat(c.recibo_actual, ' de ', c.numero_recibos), '-' ) as recibos, c.recibo_actual,
                      coalesce ( nullif ( pq."display_name", '' ), pq."Descripcion" ) as tipo_paquete,
                      coalesce ( nullif ( fp."display_name", '' ), fp."Descripcion" ) as tipo_pago
                      from polizas p inner join dato_usuarios dt on dt.session=p.session
                      inner join opcionales o on dt.session=o.session
                      left join cotizas c on c.session=p.session
                      inner join companias_activas as ca on ca."Id"=c.compania
                      inner join paquetes as pq on pq."Id" = c.paquete
                      inner join forma_pagos fp on fp."Id" = c.forma_pago
                      where p.created_at between v_inicio and v_fin
                      order by p.created_at desc;
                  end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "proc_emisiones"("v_inicio" timestamp, "v_fin" timestamp) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "proc_total_aseguradora"("v_inicio" timestamp, "v_fin" timestamp)
  RETURNS TABLE("id" int4, "aseguradora" varchar, "visitantes" int8, "cotizaciones" int8, "emisiones" int8) AS $BODY$
                  begin
                      return query select ca."Id", ca."Abr" as aseguradora, count(c.id) as visitantes,  
                      count(nullif(c."cotizacion_id", 0)) as cotizaciones, 
                      count(nullif(p."cotizacion_id", 0)) as emisiones 
                      from companias_activas ca
                      left join cotizas c on ca."Id" = c.compania
                      left join polizas p on c.session = p.session
                      left join opcionales as o on c.session = o.session
                      and date(o.created_at) between v_inicio and v_fin
                      group by ca."Id", ca."Abr";
                  end; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "proc_total_aseguradora"("v_inicio" timestamp, "v_fin" timestamp) OWNER TO "postgres";
BEGIN;
LOCK TABLE "public"."_authors" IN SHARE MODE;
DELETE FROM "public"."_authors";
INSERT INTO "public"."_authors" ("au_id","au_lname","au_fname","phone","address","city","state","zip","contract") VALUES ('172-32-1176', 'White', 'Johnson', '408 496-7223', '10932 Bigge Rd.', 'Menlo Park', 'CA', 94025, 1),('213-46-8915', 'Green', 'Marjorie', '415 986-7020', '309 63rd St. #411', 'Oakland', 'CA', 94618, 1),('238-95-7766', 'Carson', 'Cheryl', '415 548-7723', '589 Darwin Ln.', 'Berkeley', 'CA', 94705, 1),('267-41-2394', 'OLeary', 'Michael', '408 286-2428', '22 Cleveland Av. #14', 'San Jose', 'CA', 95128, 1),('274-80-9391', 'Straight', 'Dean', '415 834-2919', '5420 College Av.', 'Oakland', 'CA', 94609, 1),('341-22-1782', 'Smith', 'Meander', '913 843-0462', '10 Mississippi Dr.', 'Lawrence', 'KS', 66044, 0),('409-56-7008', 'Bennet', 'Abraham', '415 658-9932', '6223 Bateman St.', 'Berkeley', 'CA', 94705, 1),('427-17-2319', 'Dull', 'Ann', '415 836-7128', '3410 Blonde St.', 'Palo Alto', 'CA', 94301, 1),('472-27-2349', 'Gringlesby', 'Burt', '707 938-6445', 'PO Box 792', 'Covelo', 'CA', 95428, 1),('486-29-1786', 'Locksley', 'Charlene', '415 585-4620', '18 Broadway Av.', 'San Francisco', 'CA', 94130, 1),('527-72-3246', 'Greene', 'Morningstar', '615 297-2723', '22 Graybar House Rd.', 'Nashville', 'TN', 37215, 0),('648-92-1872', 'Blotchet-Halls', 'Reginald', '503 745-6402', '55 Hillsdale Bl.', 'Corvallis', 'OR', 97330, 1),('672-71-3249', 'Yokomoto', 'Akiko', '415 935-4228', '3 Silver Ct.', 'Walnut Creek', 'CA', 94595, 1),('712-45-1867', 'del Castillo', 'Innes', '615 996-8275', '2286 Cram Pl. #86', 'Ann Arbor', 'MI', 48105, 1),('722-51-5454', 'DeFrance', 'Michel', '219 547-9982', '3 Balding Pl.', 'Gary', 'IN', 46403, 1),('724-08-9931', 'Stringer', 'Dirk', '415 843-2991', '5420 Telegraph Av.', 'Oakland', 'CA', 94609, 0),('724-80-9391', 'MacFeather', 'Stearns', '415 354-7128', '44 Upland Hts.', 'Oakland', 'CA', 94612, 1),('756-30-7391', 'Karsen', 'Livia', '415 534-9219', '5720 McAuley St.', 'Oakland', 'CA', 94609, 1),('807-91-6654', 'Panteley', 'Sylvia', '301 946-8853', '1956 Arlington Pl.', 'Rockville', 'MD', 20853, 1),('846-92-7186', 'Hunter', 'Sheryl', '415 836-7128', '3410 Blonde St.', 'Palo Alto', 'CA', 94301, 1),('893-72-1158', 'McBadden', 'Heather', '707 448-4982', '301 Putnam', 'Vacaville', 'CA', 95688, 0),('899-46-2035', 'Ringer', 'Anne', '801 826-0752', '67 Seventh Av.', 'Salt Lake City', 'UT', 84152, 1),('998-72-3567', 'Ringer', 'Albert', '801 826-0752', '67 Seventh Av.', 'Salt Lake City', 'UT', 84152, 1)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_discounts" IN SHARE MODE;
DELETE FROM "public"."_discounts";
INSERT INTO "public"."_discounts" ("discounttype","stor_id","lowqty","highqty","discount") VALUES ('Initial Customer', '', '', '', 10.50),('Volume Discount', '', '100', '1000', 6.70),('Customer Discount', '8042', '', '', 5.00)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_employee" IN SHARE MODE;
DELETE FROM "public"."_employee";
INSERT INTO "public"."_employee" ("emp_id","fname","minit","lname","job_id","job_lvl","pub_id","hire_date") VALUES ('A-C71970F', 'Aria', '', 'Cruz', 10, 87, 1389, 19911026),('A-R89858F', 'Annette', '', 'Roulet', 6, 152, 9999, 19900221),('AMD15433F', 'Ann', 'M', 'Devon', 3, 200, 9952, 19910716),('ARD36773F', 'Anabela', 'R', 'Domingues', 8, 100, 877, 19930127),('CFH28514M', 'Carlos', 'F', 'Hernadez', 5, 211, 9999, 19890421),('CGS88322F', 'Carine', 'G', 'Schmitt', 13, 64, 1389, 19920707),('DBT39435M', 'Daniel', 'B', 'Tonini', 11, 75, 877, 19900101),('DWR65030M', 'Diego', 'W', 'Roel', 6, 192, 1389, 19911216),('ENL44273F', 'Elizabeth', 'N', 'Lincoln', 14, 35, 877, 19900724),('F-C16315M', 'Francisco', '', 'Chang', 4, 227, 9952, 19901103),('GHT50241M', 'Gary', 'H', 'Thomas', 9, 170, 736, 19880809),('H-B39728F', 'Helen', '', 'Bennett', 12, 35, 877, 19890921),('HAN90777M', 'Helvetius', 'A', 'Nagy', 7, 120, 9999, 19930319),('HAS54740M', 'Howard', 'A', 'Snyder', 12, 100, 736, 19881119),('JYL26161F', 'Janine', 'Y', 'Labrune', 5, 172, 9901, 19910526),('KFJ64308F', 'Karin', 'F', 'Josephs', 14, 100, 736, 19921017),('KJJ92907F', 'Karla', 'J', 'Jablonski', 9, 170, 9999, 19940311),('L-B31947F', 'Lesley', '', 'Brown', 7, 120, 877, 19910213),('LAL21447M', 'Laurence', 'A', 'Lebihan', 5, 175, 736, 19900603),('M-L67958F', 'Maria', '', 'Larsson', 7, 135, 1389, 19920327),('M-P91209M', 'Manuel', '', 'Pereira', 8, 101, 9999, 19890109),('M-R38834F', 'Martine', '', 'Rance', 9, 75, 877, 19920205),('MAP77183M', 'Miguel', 'A', 'Paolino', 11, 112, 1389, 19921207),('MAS70474F', 'Margaret', 'A', 'Smith', 9, 78, 1389, 19880929),('MFS52347M', 'Martin', 'F', 'Sommer', 10, 165, 736, 19900413),('MGK44605M', 'Matti', 'G', 'Karttunen', 6, 220, 736, 19940501),('MJP25939M', 'Maria', 'J', 'Pontes', 5, 246, 1756, 19890301),('MMS49649F', 'Mary', 'M', 'Saveley', 8, 175, 736, 19930629),('PCM98509F', 'Patricia', 'C', 'McKenna', 11, 150, 9999, 19890801),('PDI47470M', 'Palle', 'D', 'Ibsen', 7, 195, 736, 19930509),('PHF38899M', 'Peter', 'H', 'Franken', 10, 75, 877, 19920517),('PMA42628M', 'Paolo', 'M', 'Accorti', 13, 35, 877, 19920827),('POK93028M', 'Pirkko', 'O', 'Koskitalo', 10, 80, 9999, 19931129),('PSA89086M', 'Pedro', 'S', 'Afonso', 14, 89, 1389, 19901224),('PSP68661F', 'Paula', 'S', 'Parente', 8, 125, 1389, 19940119),('PTC11962M', 'Philip', 'T', 'Cramer', 2, 215, 9952, 19891111),('PXH22250M', 'Paul', 'X', 'Henriot', 5, 159, 877, 19930819),('R-M53550M', 'Roland', '', 'Mendel', 11, 150, 736, 19910905),('RBM23061F', 'Rita', 'B', 'Muller', 5, 198, 1622, 19931009),('SKO22412M', 'Sven', 'K', 'Ottlieb', 5, 150, 1389, 19910405),('TPO55093M', 'Timothy', 'P', 'ORourke', 13, 100, 736, 19880619),('VPA30890F', 'Victoria', 'P', 'Ashworth', 6, 140, 877, 19900913),('Y-L77953M', 'Yoshi', '', 'Latimer', 12, 32, 1389, 19890611)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_jobs" IN SHARE MODE;
DELETE FROM "public"."_jobs";
INSERT INTO "public"."_jobs" ("job_id","job_desc","min_lvl","max_lvl") VALUES (1, 'New Hire - Job not specified', 10, 10),(2, 'Chief Executive Officer', 200, 250),(3, 'Business Operations Manager', 175, 225),(4, 'Chief Financial Officier', 175, 250),(5, 'Publisher', 150, 250),(6, 'Managing Editor', 140, 225),(7, 'Marketing Manager', 120, 200),(8, 'Public Relations Manager', 100, 175),(9, 'Acquisitions Manager', 75, 175),(10, 'Productions Manager', 75, 165),(11, 'Operations Manager', 75, 150),(12, 'Editor', 25, 100),(13, 'Sales Representative', 25, 100),(14, 'Designer', 25, 100)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_publishers" IN SHARE MODE;
DELETE FROM "public"."_publishers";
INSERT INTO "public"."_publishers" ("pub_id","pub_name","city","state","country") VALUES (736, 'New Moon Books', 'Boston', 'MA', 'USA'),(877, 'Binnet & Hardley', 'Washington', 'DC', 'USA'),(1389, 'Algodata Infosystems', 'Berkeley', 'CA', 'USA'),(1622, 'Five Lakes Publishing', 'Chicago', 'IL', 'USA'),(1756, 'Ramona Publishers', 'Dallas', 'TX', 'USA'),(9901, 'GGG&G', 'M?nchen', '', 'Germany'),(9952, 'Scootney Books', 'New York', 'NY', 'USA'),(9999, 'Lucerne Publishing', 'Paris', '', 'France')
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_roysched" IN SHARE MODE;
DELETE FROM "public"."_roysched";
INSERT INTO "public"."_roysched" ("title_id","lorange","hirange","royalty") VALUES ('BU1032', 0, 5000, 10),('PC1035', 10001, 50000, 18),('BU2075', 0, 1000, 10),('PS2091', 1001, 5000, 12),('PS2106', 5001, 10000, 14),('MC3021', 10001, 12000, 22),('TC3218', 14001, 50000, 24),('PC8888', 0, 5000, 10),('PS7777', 0, 5000, 10),('PS3333', 15001, 50000, 16),('BU1111', 8001, 10000, 14),('PS1372', 40001, 50000, 18)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_sales" IN SHARE MODE;
DELETE FROM "public"."_sales";
INSERT INTO "public"."_sales" ("stor_id","ord_num","ord_date","qty","payterms","title_id") VALUES (6380, '722a', 19940913, 3, 'Net 60', 'PS2091'),(7066, 'A2976', 19930524, 50, 'Net 30', 'PC8888'),(7066, 'QA7442.3', 19940913, 75, 'ON invoice', 'PS2091'),(7067, 'D4482', 19940914, 10, 'Net 60', 'PS2091'),(7067, 'P2121', 19920615, 40, 'Net 30', 'TC3218'),(7131, 'N914008', 19940914, 20, 'Net 30', 'PS2091'),(7131, 'P3087a', 19930529, 25, 'Net 60', 'PS7777'),(7896, 'QQ2299', 19931028, 15, 'Net 60', 'BU7832'),(8042, '423LL922', 19940914, 15, 'ON invoice', 'MC3021'),(8042, 'P723', 19930311, 25, 'Net 30', 'BU1111')
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_stores" IN SHARE MODE;
DELETE FROM "public"."_stores";
INSERT INTO "public"."_stores" ("stor_id","stor_name","stor_address","city","state","zip") VALUES (6380, 'Eric the Read Books', '788 Catamaugus Ave.', 'Seattle', 'WA', 98056),(7066, 'Barnums', '567 Pasadena Ave.', 'Tustin', 'CA', 92789),(7067, 'News & Brews', '577 First St.', 'Los Gatos', 'CA', 96745),(7131, 'Doc-U-Mat: Quality Laundry and Books', '24-A Avogadro Way', 'Remulade', 'WA', 98014),(7896, 'Fricative Bookshop', '89 Madison St.', 'Fremont', 'CA', 90019),(8042, 'Bookbeat', '679 Carson St.', 'Portland', 'OR', 89076)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_titleauthor" IN SHARE MODE;
DELETE FROM "public"."_titleauthor";
INSERT INTO "public"."_titleauthor" ("au_id","title_id","au_ord","royaltyper") VALUES ('172-32-1176', 'PS3333', 1, 100),('213-46-8915', 'BU2075', 1, 100),('238-95-7766', 'PC1035', 1, 100),('267-41-2394', 'BU1111', 2, 40),('267-41-2394', 'TC7777', 2, 30),('274-80-9391', 'BU7832', 1, 100),('409-56-7008', 'BU1032', 1, 60),('427-17-2319', 'PC8888', 1, 50),('472-27-2349', 'TC7777', 3, 30),('486-29-1786', 'PC9999', 1, 100),('648-92-1872', 'TC4203', 1, 100),('672-71-3249', 'TC7777', 1, 40),('712-45-1867', 'MC2222', 1, 100),('722-51-5454', 'MC3021', 1, 75),('724-80-9391', 'PS1372', 2, 25),('756-30-7391', 'PS1372', 1, 75),('807-91-6654', 'TC3218', 1, 100),('846-92-7186', 'PC8888', 2, 50),('899-46-2035', 'MC3021', 2, 25),('998-72-3567', 'PS2091', 1, 50)
;
COMMIT;
BEGIN;
LOCK TABLE "public"."_titles" IN SHARE MODE;
DELETE FROM "public"."_titles";
INSERT INTO "public"."_titles" ("title_id","title","type","pub_id","price","advance","royalty","ytd_sales","notes") VALUES ('BU1032', 'The Busy Executives Database Guide', 'business', 1389, 19.99, 5000.00, 10, 4095, 'An overview of available database systems with emphasis on common business applications. Illustrated.'),('BU1111', 'Cooking with Computers: Surreptitious Balance Sheets', 'business', 1389, 11.95, 5000.00, 10, 3876, 'Helpful hints on how to use your electronic resources to the best advantage.'),('BU2075', 'You Can Combat Computer Stress!', 'business', 736, 2.99, 10125.00, 24, 18722, 'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.'),('BU7832', 'Straight Talk About Computers', 'business', 1389, 19.99, 5000.00, 10, 4095, 'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.'),('MC2222', 'Silicon Valley Gastronomic Treats', 'mod_cook', 877, 19.99, 0.00, 12, 2032, 'Favorite recipes for quick, easy, and elegant meals.'),('MC3021', 'The Gourmet Microwave', 'mod_cook', 877, 2.99, 15000.00, 24, 22246, 'Traditional French gourmet recipes adapted for modern microwave cooking.'),('PC1035', 'But Is It User Friendly?', 'popular_comp', 1389, 22.95, 7000.00, 16, 8780, 'A survey of software for the naive user, focusing on the friendliness of each.'),('PC8888', 'Secrets of Silicon Valley', 'popular_comp', 1389, 20.00, 8000.00, 10, 4095, 'Muckraking reporting on the worlds largest computer hardware and software manufacturers.'),('PC9999', 'Computer ', 'psychology', 877, 21.59, 7000.00, 10, 375, 'A must for the specialist, this book examines the difference between those who hate and fear computers and those who dont.'),('PS1372', 'Computer Phobic AND Non-Phobic Individuals: Behavior Variations', 'psychology', 877, 21.59, 7000.00, 10, 375, 'A must for the specialist, this book examines the difference between those who hate and fear computers and those who dont.'),('PS2091', 'Is Anger the Enemy?', 'psychology', 736, 10.95, 2275.00, 12, 2045, 'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.'),('PS2106', 'Life Without Fear', 'psychology', 736, 7.00, 6000.00, 10, 111, 'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.'),('PS3333', 'Prolonged Data Deprivation: Four Case Studies', 'psychology', 736, 19.99, 2000.00, 10, 4072, 'What happens when the data runs dry?  Searching evaluations of information-shortage effects.'),('PS7777', 'Emotional Security: A New Algorithm', 'psychology', 736, 7.99, 4000.00, 10, 3336, 'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.'),('TC3218', 'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean', 'trad_cook', 877, 20.95, 7000.00, 10, 375, 'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.'),('TC4203', 'Fifty Years in Buckingham Palace Kitchens', 'trad_cook', 877, 11.95, 4000.00, 14, 15096, 'More anecdotes from the Queens favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.'),('TC7777', 'Sushi, Anyone?', 'trad_cook', 877, 14.99, 8000.00, 10, 4095, 'Detailed instructions on how to make authentic Japanese sushi in your spare time.')
;
COMMIT;
