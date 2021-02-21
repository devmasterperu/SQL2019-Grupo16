--05.01

--El total de contratos: 
select count(*) from Contrato
--El total de contratos pertenecientes a clientes empresa: 
select count(*) from Contrato co
inner join Cliente c on co.codcliente=c.codcliente and c.tipo_cliente='E'
--El total de contratos pertenecientes a clientes persona: 
select count(*) from Contrato co
inner join Cliente c on co.codcliente=c.codcliente and c.tipo_cliente='P'
--El total de contratos pertenecientes a clientes de tipo desconocido: 
select count(*) from Contrato co
left join Cliente c on co.codcliente=c.codcliente
where c.tipo_cliente is null

/*Consulta padre*/
select (select count(*) from Contrato) as TOT_C,						 --Consulta_hija
	   (select count(*) from Contrato co inner join Cliente c 
	    on co.codcliente=c.codcliente and c.tipo_cliente='E') as TOT_C_E,--Consulta_hija
	   (select count(*) from Contrato co inner join Cliente c 
	    on co.codcliente=c.codcliente and c.tipo_cliente='P') as TOT_C_P,--Consulta_hija
	   (select count(*) from Contrato co left join Cliente c 
	   on co.codcliente=c.codcliente
       where c.tipo_cliente is null) as TOT_C_O							 --Consulta_hija

--05.03

select replace('DEVMASTER PERU','ER','__')

/*Consulta padre*/
select codplan,replace(upper(nombre),' ','_') as [PLAN],
       (select count(*) from Contrato co where co.codplan=p.codplan) as TOTAL,--Consulta_hija
	   case 
	   --Consulta_hija
	   when (select count(*) from Contrato co where co.codplan=p.codplan) between 0 and 99 then 'Plan de baja demanda'
	   --Consulta_hija
	   when (select count(*) from Contrato co where co.codplan=p.codplan) between 100 and 199 then 'Plan de mediana demanda'
	   --Consulta_hija
	   when (select count(*) from Contrato co where co.codplan=p.codplan)>=200 then 'Plan de alta demanda'
	   else 'No es posible determinar'
	   end as MENSAJE
from   PlanInternet p
order by TOTAL