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