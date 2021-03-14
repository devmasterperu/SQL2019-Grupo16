--UNION

select 'V1','V2','V3'
union
select 'V1','V2','V3'
union
select 'V1','V2','V3'

select 'V1','V2','V3'
union
select 'V1','V2','V3'
union
select 'V1','V2','V4'

--UNION ALL

select 'V1','V2','V3'
union all
select 'V1','V2','V3'
union all
select 'V1','V2','V3'

--UNION + UNION ALL

select 'V1','V2','V3'
union
select 'V1','V2','V3'
--'V1','V2','V3'
union all
select 'V1','V2',NULL

select 'V1','V2','V3'
union all
select 'V1','V2',convert(varchar(8),getdate(),112)

select 'V1','V2',getdate()
union all
select 'V1','V2','2021-03-14'

select cast('DEVMASTER' as datetime)

--06.09

--select * from DevWifi2019..Ubigeo
--select * from DevWifi2019.comercial.Ubigeo

--a
create view vw_Ubigeos
as
select cod_dpto,cod_prov,cod_dto from DEVWIFI16ED.dbo.Ubigeo
UNION ALL
select cod_dpto,cod_prov,cod_dto from DevWifi2019.comercial.Ubigeo

select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
from vw_Ubigeos

--b
alter view vw_Ubigeos_I
as
select cod_dpto,cod_prov,cod_dto from DEVWIFI16ED.dbo.Ubigeo
UNION 
select cod_dpto,cod_prov,cod_dto from DevWifi2019.comercial.Ubigeo
UNION
select '00','00','00'

select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
from vw_Ubigeos_I

create function uf_Ubigeos_I() returns table as
return
	select cod_dpto,cod_prov,cod_dto from DEVWIFI16ED.dbo.Ubigeo
	UNION 
	select cod_dpto,cod_prov,cod_dto from DevWifi2019.comercial.Ubigeo
	UNION
	select '00','00','00'

select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
from uf_Ubigeos_I()

--INTERSECT

select 'A','B','C'
intersect
select 'A','B','C'

select 'A','B','C'
intersect
select 'A','B','D'

--EXCEPT

select 'A','B','C'
except
select 'A','B','D'

select 'A','B','D'
except
select 'A','B','C'

select 'A','B','C'
except
select 'A','B','C'

--06.11
select tipo,numero,codcliente,estado from DEVWIFI16ED.dbo.Telefono
where tipo='WSP' and numero='963065267' and codcliente=3 and estado=1

select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
where tipo='WSP' and numero='963065267' and codcliente=3 and estado=1

--a
with cte_telefono as
(
select tipo,numero,codcliente,estado from DEVWIFI16ED.dbo.Telefono
intersect
select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
)
select tipo as TIPO,numero as NUMERO,ct.codcliente as CODIGO,ct.estado as ESTADO,
coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN DETALLE') as CLIENTE,
row_number() over(partition by ct.codcliente order by ct.numero asc) as POSICION
from cte_telefono ct
left join Cliente c on ct.codcliente=c.codcliente

--B

--EN DBO PERO NO EN COMERCIAL
select tipo,numero,codcliente,estado from DEVWIFI16ED.dbo.Telefono
except
select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono

--EN COMERCIAL PERO NO EN DBO
select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
except
select tipo,numero,codcliente,estado from DEVWIFI16ED.dbo.Telefono 
go

select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
where tipo='SMS' and NUMERO='900670335' and codcliente=1 and estado=1

select tipo,numero,codcliente,estado from DEVWIFI16ED.dbo.Telefono 
where tipo='SMS' and NUMERO='900670335' and codcliente=1 and estado=1

with cte_telefono_e as
(
select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
except
select tipo,numero,codcliente,estado from DEVWIFI16ED.dbo.Telefono 
)
select tipo as TIPO,numero as NUMERO,ct.codcliente as CODIGO,ct.estado as ESTADO,
coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN DETALLE') as CLIENTE,
row_number() over(partition by ct.codcliente order by ct.numero asc) as POSICION
from cte_telefono_e ct
left join Cliente c on ct.codcliente=c.codcliente