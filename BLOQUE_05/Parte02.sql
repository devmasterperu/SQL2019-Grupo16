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