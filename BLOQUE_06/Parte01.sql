--06.01
--TABLAS_DERIVADAS
select co.codplan as CODPLAN,codcliente,preciosol as PRECIO,
rco.presum,rco.preprom,rco.pretot,rco.premin,rco.premax
from Contrato co
left join
(
 select codplan,sum(preciosol) as presum,avg(preciosol) as preprom,
 count(*) as pretot,min(preciosol) as premin,max(preciosol) as premax
 from Contrato
 group by codplan
) rco on co.codplan=rco.codplan
order by CODPLAN asc,PRECIO asc

--OVER+FUNCIONES_GRUPO

select co.codplan as CODPLAN,codcliente,preciosol as PRECIO,
sum(preciosol) over(partition by co.codplan) as PRE_SUM,
avg(preciosol) over(partition by co.codplan) as PRE_PROM,
count(*)       over(partition by co.codplan) as PRE_TOT,
min(preciosol) over(partition by co.codplan) as PRE_MIN,
max(preciosol) over(partition by co.codplan) as PRE_MAX
from Contrato co
order by CODPLAN asc,PRECIO asc

--VISTAS
create view vw_contratos_grupo as
select co.codplan as CODPLAN,codcliente,preciosol as PRECIO,
sum(preciosol) over(partition by co.codplan) as PRE_SUM,
avg(preciosol) over(partition by co.codplan) as PRE_PROM,
count(*)       over(partition by co.codplan) as PRE_TOT,
min(preciosol) over(partition by co.codplan) as PRE_MIN,
max(preciosol) over(partition by co.codplan) as PRE_MAX
from Contrato co

select * from vw_contratos_grupo
order by CODPLAN asc,PRECIO asc

--06.03

--CONSULTA
select codcliente as CODIGO,razon_social as EMPRESA,fec_inicio as FEC_INICIO,
row_number() over(order by fec_inicio asc) as RN,
rank()       over(order by fec_inicio asc) as RK,
dense_rank() over(order by fec_inicio asc) as DRK,
NTILE(5)     over(order by fec_inicio asc) as N5
from Cliente
where tipo_cliente='E'
order by fec_inicio asc

--FUNCION_VALOR_TABLA
create function uf_clientes_empresa() returns table
as 
return
	select codcliente as CODIGO,razon_social as EMPRESA,fec_inicio as FEC_INICIO,
	row_number() over(order by fec_inicio asc) as RN,
	rank()       over(order by fec_inicio asc) as RK,
	dense_rank() over(order by fec_inicio asc) as DRK,
	NTILE(5)     over(order by fec_inicio asc) as N5
	from Cliente
	where tipo_cliente='E'

select * from uf_clientes_empresa()
order by fec_inicio asc

--06.05

--TABLAS_DERIVADAS
select c.codcliente as CODIGO,
concat(c.nombres,' ',c.ape_paterno+' ',c.ape_materno) as CLIENTE,
c.codzona as ZONA,
isnull(rt.total,0) as N_TEL,
row_number() over(partition by c.codzona order by isnull(rt.total,0) asc) as R1,
rank()       over(partition by c.codzona order by isnull(rt.total,0) asc) as R2,
dense_rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R3,
ntile(4)     over(partition by c.codzona order by isnull(rt.total,0) asc) as R4
from Cliente c
left join 
(
  select codcliente,count(numero) as total
  from Telefono
  group by codcliente
) rt on c.codcliente=rt.codcliente
where tipo_cliente='P'
order by ZONA asc,N_TEL asc

--CTES
with cte_rt as
(
  select codcliente,count(numero) as total
  from Telefono
  group by codcliente
) 
select c.codcliente as CODIGO,
concat(c.nombres,' ',c.ape_paterno+' ',c.ape_materno) as CLIENTE,
c.codzona as ZONA,
isnull(rt.total,0) as N_TEL,
row_number() over(partition by c.codzona order by isnull(rt.total,0) asc) as R1,
rank()       over(partition by c.codzona order by isnull(rt.total,0) asc) as R2,
dense_rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R3,
ntile(4)     over(partition by c.codzona order by isnull(rt.total,0) asc) as R4
from Cliente c
left join  cte_rt rt on c.codcliente=rt.codcliente
where tipo_cliente='P'
order by ZONA asc,N_TEL asc

--06.07

--TABLAS_DERIVADAS
select c.codcliente as #,razon_social as CLIENTE,codzona as ZONA,isnull(rco.total,0) as TOTAL,
row_number()                    over(partition by codzona order by isnull(rco.total,0)) as E1,
lag(razon_social,1,'SIN DATO')  over(partition by codzona order by isnull(rco.total,0)) as E2,
lead(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rco.total,0)) as E3,
first_value(razon_social)       over(partition by codzona order by isnull(rco.total,0)) as E4,
last_value(razon_social)        over(partition by codzona order by isnull(rco.total,0)) as E5,
first_value(fec_inicio)       over(partition by codzona order by isnull(rco.total,0)) as E6,
last_value(fec_inicio)        over(partition by codzona order by isnull(rco.total,0)) as E7
from Cliente c
left join
(
	select codcliente,count(*) as total 
	from Contrato 
	group by codcliente
) rco on c.codcliente=rco.codcliente
where tipo_cliente='E'
order by ZONA asc, TOTAL asc

--CTES
with cte_rco as
(
	select codcliente,count(*) as total 
	from Contrato 
	group by codcliente
) 
select c.codcliente as #,razon_social as CLIENTE,codzona as ZONA,isnull(rco.total,0) as TOTAL,
row_number()                    over(partition by codzona order by isnull(rco.total,0)) as E1,
lag(razon_social,1,'SIN DATO')  over(partition by codzona order by isnull(rco.total,0)) as E2,
lead(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rco.total,0)) as E3,
first_value(razon_social)       over(partition by codzona order by isnull(rco.total,0)) as E4,
last_value(razon_social)        over(partition by codzona order by isnull(rco.total,0)) as E5,
first_value(fec_inicio)       over(partition by codzona order by isnull(rco.total,0)) as E6,
last_value(fec_inicio)        over(partition by codzona order by isnull(rco.total,0)) as E7
from Cliente c
left join cte_rco rco on c.codcliente=rco.codcliente
where tipo_cliente='E'
order by ZONA asc, TOTAL asc

--FUNCION_VALOR_TABLA
create function uf_cliente_contrato() returns table
as return
	with cte_rco as
	(
		select codcliente,count(*) as total 
		from Contrato 
		group by codcliente
	) 
	select c.codcliente as #,razon_social as CLIENTE,codzona as ZONA,isnull(rco.total,0) as TOTAL,
	row_number()                    over(partition by codzona order by isnull(rco.total,0)) as E1,
	lag(razon_social,1,'SIN DATO')  over(partition by codzona order by isnull(rco.total,0)) as E2,
	lead(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rco.total,0)) as E3,
	first_value(razon_social)       over(partition by codzona order by isnull(rco.total,0)) as E4,
	last_value(razon_social)        over(partition by codzona order by isnull(rco.total,0)) as E5,
	first_value(fec_inicio)         over(partition by codzona order by isnull(rco.total,0)) as E6,
	last_value(fec_inicio)          over(partition by codzona order by isnull(rco.total,0)) as E7
	from Cliente c
	left join cte_rco rco on c.codcliente=rco.codcliente
	where tipo_cliente='E'

select * from uf_cliente_contrato()
order by ZONA asc, TOTAL asc