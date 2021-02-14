

--3.1
select codcliente from Cliente       --1000
select codplan from PlanInternet     --5

select codcliente,codplan
from   Cliente,PlanInternet          --5000

--a
select codcliente,codplan
from Cliente cross join PlanInternet --5000

--b
select codcliente from Cliente where tipo_cliente='E' --400
select codplan    from PlanInternet     --5

select codcliente,codplan
from   Cliente cross join PlanInternet 
where  tipo_cliente='E'                --2000

--03.02

select codzona as CODZONA,nombre as ZONA,estado as ESTADO,
u.cod_dpto+u.cod_prov+u.cod_dto as UBIGEO,
--La Zona HUACHO-I del ubigeo 150801 se encuentra ACTIVA.
'La Zona '+nombre+' del ubigeo '+u.cod_dpto+u.cod_prov+u.cod_dto+' se encuentra '+IIF(estado=1,'ACTIVA','INACTIVA U OTRO ESTADO') as MENSAJE
from Zona z inner join Ubigeo u on z.codubigeo=u.codubigeo

--03.04

select top(100)
       t.desc_corta as TIPO_DOC,c.numdoc as NUM_DOC,
       concat(rtrim(ltrim(c.nombres)),' ',rtrim(ltrim(c.ape_paterno)),' ',rtrim(ltrim(c.ape_materno))) as NOMBRE_COMPLETO,
	   c.fec_nacimiento as FECHA_NAC,
	   c.direccion as DIRECCION,
	   z.nombre as ZONA
from Cliente c
--inner join TipoDocumento t on c.codtipo=t.codtipo and c.tipo_cliente='P' and c.estado=1
--inner join Zona z on c.codzona=z.codzona
inner join TipoDocumento t on c.codtipo=t.codtipo 
inner join Zona z on c.codzona=z.codzona
where c.tipo_cliente='P' and c.estado=1
order by NOMBRE_COMPLETO asc