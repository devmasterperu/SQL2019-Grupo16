--CTES

--Relación de empleados+jefes con CTE (Solo aquellos con jefatura)

/*
with cte_emp as
(
	select empid,mgrid,title,firstname,lastname 
	from HR.Employees
	where mgrid is not null
)
select 
emp.title,
emp.firstname+' '+emp.lastname as Employee,
jef.firstname+' '+jef.lastname as Boss
from cte_emp emp
inner join cte_emp jef on emp.mgrid=jef.empid

select 
emp.title,
emp.firstname+' '+emp.lastname as Employee,
jef.firstname+' '+jef.lastname as Boss
from (
	select empid,mgrid,title,firstname,lastname 
	from HR.Employees
	where mgrid is not null
) emp
inner join 
(
	select empid,mgrid,title,firstname,lastname 
	from HR.Employees
	where mgrid is not null
) jef on emp.mgrid=jef.empid
*/

--05.05

select cast(round(167*100.00/941,2) as decimal(6,2))

select 
nombre as [PLAN],
(select count(codplan) from Contrato co where co.codplan=p.codplan) as [TOTAL-P],
(select count(*) from Contrato) as [TOTAL],
cast(
	round(
		(select count(codplan) from Contrato co where co.codplan=p.codplan)*100.00/
		(select count(*) from Contrato),
		2)
	as decimal(6,2)
) as [PORCENTAJE]
from PlanInternet p
order by [PORCENTAJE] desc

--05.07

--set statistics io off

--SUBCONSULTAS_SELECT

select nombre,
(select count(*) from Contrato co where co.codplan=p.codplan) as [CO-TOTAL],
isnull((select avg(preciosol) from Contrato co where co.codplan=p.codplan),0.00) as [CO-PROM],
isnull((select min(fec_contrato) from Contrato),'9999-12-31') as [CO-ANTIGUO],
isnull((select max(fec_contrato) from Contrato),'9999-12-31') as [CO-RECIENTE]
from PlanInternet p
order by [CO-TOTAL] desc

--SUBCONSULTAS_FROM

select nombre,
isnull(rp.total,0) as [CO-TOTAL],
isnull(rp.prom,0.00) as [CO-PROM],
isnull(rp.antiguo,'9999-12-31') as [CO-ANTIGUO],
isnull(rp.reciente,'9999-12-31') as [CO-RECIENTE]
from PlanInternet p
left join
(
select codplan,count(*) as total,avg(preciosol) as prom,min(fec_contrato) as antiguo,max(fec_contrato) as reciente
from Contrato
group by codplan
) rp on p.codplan=rp.codplan
order by [CO-TOTAL] desc

--CTEs

set statistics io off

with cte_rp as
(
	select codplan,count(*) as total,avg(preciosol) as prom,min(fec_contrato) as antiguo,max(fec_contrato) as reciente
	from Contrato
	group by codplan
)
select nombre,
isnull(rp.total,0) as [CO-TOTAL],
isnull(rp.prom,0.00) as [CO-PROM],
isnull(rp.antiguo,'9999-12-31') as [CO-ANTIGUO],
isnull(rp.reciente,'9999-12-31') as [CO-RECIENTE]
from PlanInternet as p
left join cte_rp  as rp on p.codplan=rp.codplan
order by [CO-TOTAL] desc

--05.09

--TABLAS_DERIVADAS

select c.codcliente as [COD-CLIENTE],
	   upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
	   isnull(rt.[tot-te],0) as [TOT-TE],
	   isnull(rco.[tot-co],0) as [TOT-CO]
from   Cliente c
left join
(
select codcliente,count(*) as [tot-te]
from Telefono
where estado=1
group by codcliente
) rt on c.codcliente=rt.codcliente
left join
(
select codcliente,count(*) as [tot-co]
from Contrato
where estado=1
group by codcliente
) rco on c.codcliente=rco.codcliente
where  tipo_cliente='P'
order by [TOT-TE] asc,[TOT-CO] asc

--CTES

with cte_rt as 
(
	select codcliente,count(*) as [tot-te]
	from Telefono
	where estado=1
	group by codcliente
),
cte_rco as 
(
	select codcliente,count(*) as [tot-co]
	from Contrato
	where estado=1
	group by codcliente
)
select c.codcliente as [COD-CLIENTE],
	   upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
	   isnull(rt.[tot-te],0) as [TOT-TE],
	   isnull(rco.[tot-co],0) as [TOT-CO]
from   Cliente c
left join cte_rt  as rt on c.codcliente=rt.codcliente
left join cte_rco as rco on c.codcliente=rco.codcliente
where  tipo_cliente='P'
order by [TOT-TE] asc,[TOT-CO] asc

--VISTAS

--create view vw_clientes as
alter view vw_clientes as
with cte_rt as 
(
	select codcliente,count(*) as [tot-te]
	from Telefono
	where estado=1
	group by codcliente
),
cte_rco as 
(
	select codcliente,count(*) as [tot-co]
	from Contrato
	where estado=1
	group by codcliente
)
select c.codcliente as [COD-CLIENTE],
       c.codzona as [COD-ZONA],
	   upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
	   isnull(rt.[tot-te],0) as [TOT-TE],
	   isnull(rco.[tot-co],0) as [TOT-CO],
	   getdate() as [FEC-CONSULTA]
from   Cliente c
left join cte_rt  as rt on c.codcliente=rt.codcliente
left join cte_rco as rco on c.codcliente=rco.codcliente
where  tipo_cliente='P'

select c.[CLIENTE],z.nombre 
from vw_clientes c
inner join Zona z on c.[COD-ZONA]=z.codzona
order by [TOT-TE] asc,[TOT-CO] asc

--FUNCION_VALOR_TABLA

create function uf_cliente(@codcliente int) returns table as
return
	--declare @codcliente int=700;
	with cte_rt as 
	(
		select codcliente,count(*) as [tot-te]
		from Telefono
		where estado=1
		group by codcliente
	),
	cte_rco as 
	(
		select codcliente,count(*) as [tot-co]
		from Contrato
		where estado=1
		group by codcliente
	)
	select c.codcliente as [COD-CLIENTE],
		   c.codzona as [COD-ZONA],
		   upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
		   isnull(rt.[tot-te],0) as [TOT-TE],
		   isnull(rco.[tot-co],0) as [TOT-CO],
		   getdate() as [FEC-CONSULTA]
	from   Cliente c
	left join cte_rt  as rt on c.codcliente=rt.codcliente
	left join cte_rco as rco on c.codcliente=rco.codcliente
	where  tipo_cliente='P' and c.codcliente=@codcliente;

select * from uf_cliente(700)

--FUNCION_VALOR_TABLA_DESDE_TD

create function uf_cliente_v2(@codcliente int) returns table as
return 
	select c.codcliente as [COD-CLIENTE],
		   upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
		   isnull(rt.[tot-te],0) as [TOT-TE],
		   isnull(rco.[tot-co],0) as [TOT-CO]
	from   Cliente c
	left join
	(
	select codcliente,count(*) as [tot-te]
	from Telefono
	where estado=1
	group by codcliente
	) rt on c.codcliente=rt.codcliente
	left join
	(
	select codcliente,count(*) as [tot-co]
	from Contrato
	where estado=1
	group by codcliente
	) rco on c.codcliente=rco.codcliente
	where  tipo_cliente='P' and c.codcliente=@codcliente

select * from uf_cliente_v2(700)

--VISTA_DESDE_TD
create view vw_clientes_v2 
as
select c.codcliente as [COD-CLIENTE],
	upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
	isnull(rt.[tot-te],0) as [TOT-TE],
	isnull(rco.[tot-co],0) as [TOT-CO]
	from   Cliente c
	left join
	(
	select codcliente,count(*) as [tot-te]
	from Telefono
	where estado=1
	group by codcliente
	) rt on c.codcliente=rt.codcliente
	left join
	(
	select codcliente,count(*) as [tot-co]
	from Contrato
	where estado=1
	group by codcliente
	) rco on c.codcliente=rco.codcliente
	where  tipo_cliente='P'

select * from vw_clientes_v2

--05.10

--TOT-TE. # teléfonos. Mostrar 0 para valores desconocidos.
--TOT-LLA. # teléfonos del tipo ‘LLA’. Mostrar 0 para valores desconocidos.
--TOT-SMS. # teléfonos del tipo ‘SMS’. Mostrar 0 para valores desconocidos.
--TOT-WSP. #teléfonos del tipo ‘WSP’. Mostrar 0 para valores desconocidos.

--TOT-TE
select codcliente,count(*) as total
from Telefono
group by codcliente

--TOT-LLA
select codcliente,count(*) as total
from Telefono
where tipo='LLA'
group by codcliente

--TOT-SMS
select codcliente,count(*) as total
from Telefono
where tipo='SMS'
group by codcliente

--TOT-WSP
select codcliente,count(*) as total
from Telefono
where tipo='WSP'
group by codcliente

--TABLAS_DERIVADAS

select c.codcliente as CODIGO,razon_social as EMPRESA,
isnull(rt.total,0) as [TOT-TE],
isnull(rlla.total,0) as [TOT-LLA],
isnull(rsms.total,0) as [TOT-SMS],
isnull(rwsp.total,0) as [TOT-WSP]
from  Cliente c
left join 
(
	select codcliente,count(*) as total
	from Telefono
	group by codcliente
) rt on c.codcliente=rt.codcliente 
left join
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='LLA'
	group by codcliente
) rlla on c.codcliente=rlla.codcliente
left join
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='SMS'
	group by codcliente
) rsms on c.codcliente=rsms.codcliente
left join
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='WSP'
	group by codcliente
) rwsp on c.codcliente=rwsp.codcliente
where tipo_cliente='E'
order by [TOT-TE] desc,[TOT-LLA] desc

--CTES
with cte_rt as 
(
	select codcliente,count(*) as total
	from Telefono
	group by codcliente
),
cte_lla as
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='LLA'
	group by codcliente
),
cte_sms as
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='SMS'
	group by codcliente
),
cte_wsp as
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='WSP'
	group by codcliente
)
select c.codcliente as CODIGO,razon_social as EMPRESA,
isnull(rt.total,0) as [TOT-TE],
isnull(rlla.total,0) as [TOT-LLA],
isnull(rsms.total,0) as [TOT-SMS],
isnull(rwsp.total,0) as [TOT-WSP]
from  Cliente c
left join cte_rt  as rt on c.codcliente=rt.codcliente 
left join cte_lla as rlla on c.codcliente=rlla.codcliente
left join cte_sms as rsms on c.codcliente=rsms.codcliente
left join cte_wsp as rwsp on c.codcliente=rwsp.codcliente
where tipo_cliente='E'
order by [TOT-TE] desc,[TOT-LLA] desc

--FUNCION_VALOR_TABLE
alter function uf_cliente_empresa(@codcliente int) returns table as
return
	with cte_rt as 
	(
		select codcliente,count(*) as total
		from Telefono
		group by codcliente
	),
	cte_lla as
	(
		select codcliente,count(*) as total
		from Telefono
		where tipo='LLA'
		group by codcliente
	),
	cte_sms as
	(
		select codcliente,count(*) as total
		from Telefono
		where tipo='SMS'
		group by codcliente
	),
	cte_wsp as
	(
		select codcliente,count(*) as total
		from Telefono
		where tipo='WSP'
		group by codcliente
	)
	select c.codcliente as CODIGO,razon_social as EMPRESA,
	isnull(rt.total,0) as [TOT-TE],
	isnull(rlla.total,0) as [TOT-LLA],
	isnull(rsms.total,0) as [TOT-SMS],
	isnull(rwsp.total,0) as [TOT-WSP]
	from  Cliente c
	left join cte_rt  as rt on c.codcliente=rt.codcliente 
	left join cte_lla as rlla on c.codcliente=rlla.codcliente
	left join cte_sms as rsms on c.codcliente=rsms.codcliente
	left join cte_wsp as rwsp on c.codcliente=rwsp.codcliente
	where tipo_cliente='E' and c.codcliente=@codcliente

select * from uf_cliente_empresa(39)
--order by [TOT-TE] desc,[TOT-LLA] desc

--05.12

--SUBCONSULTAS
select coalesce(NULL,'DATO2',NULL,'DATO4')
select eomonth(getdate())

select coalesce(c.nombres+' '+c.ape_paterno+' '+c.ape_materno,c.razon_social,'SIN DATO') as CLIENTE,
coalesce(p.nombre,'SIN DATO') as [PLAN],
coalesce(co.fec_contrato,'9999-12-31') as FECHA,
coalesce(co.preciosol,0.00) as PRECIO,
cast(round((select avg(preciosol) from Contrato co where co.estado=1),2) as decimal(7,2)) as PROMEDIO,
eomonth(getdate()) as F_CIERRE
from Contrato co
left join PlanInternet p on co.codplan=p.codplan
left join Cliente c on co.codcliente=c.codcliente
where co.preciosol>(
					select avg(preciosol) 
					from Contrato co
					where co.estado=1
				   )
order by PRECIO desc

--VISTAS
create view vw_contratos as
select coalesce(c.nombres+' '+c.ape_paterno+' '+c.ape_materno,c.razon_social,'SIN DATO') as CLIENTE,
coalesce(p.nombre,'SIN DATO') as [PLAN],
coalesce(co.fec_contrato,'9999-12-31') as FECHA,
coalesce(co.preciosol,0.00) as PRECIO,
cast(round((select avg(preciosol) from Contrato co where co.estado=1),2) as decimal(7,2)) as PROMEDIO,
eomonth(getdate()) as F_CIERRE
from Contrato co
left join PlanInternet p on co.codplan=p.codplan
left join Cliente c on co.codcliente=c.codcliente
where co.preciosol>(
					select avg(preciosol) 
					from Contrato co
					where co.estado=1
				   )

select * from vw_contratos
order by PRECIO desc

--FUNCION_VALOR_TABLA
create function uf_contratos() returns table
as
return
	select coalesce(c.nombres+' '+c.ape_paterno+' '+c.ape_materno,c.razon_social,'SIN DATO') as CLIENTE,
	coalesce(p.nombre,'SIN DATO') as [PLAN],
	coalesce(co.fec_contrato,'9999-12-31') as FECHA,
	coalesce(co.preciosol,0.00) as PRECIO,
	cast(round((select avg(preciosol) from Contrato co where co.estado=1),2) as decimal(7,2)) as PROMEDIO,
	eomonth(getdate()) as F_CIERRE
	from Contrato co
	left join PlanInternet p on co.codplan=p.codplan
	left join Cliente c on co.codcliente=c.codcliente
	where co.preciosol>(
						select avg(preciosol) 
						from Contrato co
						where co.estado=1
					   )

select * from uf_contratos()
order by PRECIO desc

--SUBCONSULTAS_HAVING

--¿Cuales son los planes que tienen precioprom mayor al preciprom de todos los planes?

--Preciprom de los planes
select avg(precioprom) 
from
(
	select codplan,avg(precionuevo) as precioprom
	from Contrato
	group by codplan
) rp

select codplan,avg(precionuevo) as precioprom
from Contrato
group by codplan
having avg(precionuevo)>(
							select avg(precioprom) 
							from
							(
								select codplan,avg(precionuevo) as precioprom
								from Contrato
								group by codplan
							) rp
						)
order by precioprom