--04.01
--(1)
insert into PlanInternet 
output inserted.codplan,inserted.nombre
values ('GOLD IV',110.00,'Solicitado por comité junio 2020')

--(SSMS)
select codplan,nombre from PlanInternet

--(2)
insert into PlanInternet 
output inserted.codplan,inserted.nombre
values 
('PREMIUM II',140.00,'Solicitado por comité junio 2020'),
('PREMIUM III',160.00,'Solicitado por comité junio 2020'),
('PREMIUM IV',180.00,'Solicitado por comité junio 2020')

--(3)descripcion,nombre,precioref

begin tran
	insert into PlanInternet(descripcion,nombre,precioref)
	output inserted.codplan,inserted.nombre
	--values('Solicitado por comité junio 2020','STAR I',190.00)
	--values(100,'STAR I',190.00)
	--values('Solicitado por comité junio 2020','STAR I','120.00')
rollback

select codplan,nombre,IDENT_CURRENT('PlanInternet') from PlanInternet

DBCC CHECKIDENT('PlanInternet',RESEED,10) /*Resetear columna IDENTITY*/

insert into PlanInternet(descripcion,nombre,precioref)
output inserted.codplan,inserted.nombre
values('Solicitado por comité junio 2020','STAR I',190.00)

--(4)
alter table PlanInternet add fechoraregistro datetime default getdate()

insert into PlanInternet(descripcion,nombre,precioref)
output inserted.codplan,inserted.nombre
values('Solicitado por comité junio 2020','STAR II',200.00)

select * from PlanInternet where codplan=12

alter table PlanInternet add estado bit default 0

insert into PlanInternet(descripcion,nombre,precioref,fechoraregistro)
output inserted.codplan,inserted.nombre
values('Solicitado por comité junio 2020','STAR III',210.00,'2021-02-21 09:24:00.000')

delete from PlanInternet where codplan in (15,16,17) /*Eliminar filas*/

DBCC CHECKIDENT('PlanInternet',RESEED,12) /*Resetear columna IDENTITY*/

select * from PlanInternet

--04.02
--a
select * from Zona_Carga --where 1=0
select * from Zona --where 1=0

/*Destino*/
insert into Zona(nombre,codubigeo,estado)
output inserted.codzona,inserted.nombre
/*Origen*/
select nombre,u.codubigeo as codubigeo,1--,zc.distrito,zc.provincia,zc.departamento,u.nom_dto,u.nom_prov,u.nom_dpto
from   Zona_Carga zc 
join   Ubigeo u 
on     upper(rtrim(ltrim(zc.distrito)))=upper(rtrim(ltrim(u.nom_dto))) and 
       upper(rtrim(ltrim(zc.provincia)))=upper(rtrim(ltrim(u.nom_prov))) and 
	   upper(rtrim(ltrim(zc.departamento)))=upper(rtrim(ltrim(u.nom_dpto)))
where  estado='ACTIVO'

--select IIF(' cheCras '='CHECRAS',1,0)

/*Origen 2 (Sin WHERE)*/
--select nombre,0 as codubigeo,
--       case 
--		   when estado='ACTIVO'   then 1
--		   when estado='INACTIVO' then 0
--		   else NULL
--	   end as estado
--from   Zona_Carga

--b

--create procedure usp_selZonas
alter procedure usp_selZonas
as
select nombre,u.codubigeo as codubigeo,0--,zc.distrito,zc.provincia,zc.departamento,u.nom_dto,u.nom_prov,u.nom_dpto
from   Zona_Carga zc 
join   Ubigeo u 
on     upper(rtrim(ltrim(zc.distrito)))=upper(rtrim(ltrim(u.nom_dto))) and 
       upper(rtrim(ltrim(zc.provincia)))=upper(rtrim(ltrim(u.nom_prov))) and 
	   upper(rtrim(ltrim(zc.departamento)))=upper(rtrim(ltrim(u.nom_dpto)))
where  estado='INACTIVO'

execute usp_selZonas

/*Destino*/
insert into Zona(nombre,codubigeo,estado)
/*Origen*/
execute usp_selZonas

select * from Zona 

--04.03

select * from Zona where codubigeo=18

--Cannot insert explicit value for identity column in table 'Zona' when IDENTITY_INSERT is set to OFF

set identity_insert Zona on   --Habilitar inserción sobre columna identity
insert into Zona(codzona,nombre,codubigeo,estado) values (12,'CAJATAMBO-A',18,1)
insert into Zona(codzona,nombre,codubigeo,estado) values (13,'CAJATAMBO-B',18,1)
insert into Zona(codzona,nombre,codubigeo,estado) values (14,'CAJATAMBO-C',18,1)
set identity_insert Zona off --Deshabilitar inserción sobre columna identity

select * from Zona 

--04.05

select * from Telefono
where codcliente=18 and tipo<>'LLA'

begin tran --SIEMPRE
	delete from Telefono
	output deleted.tipo,deleted.numero,deleted.codcliente,deleted.estado
	where codcliente=18 and tipo<>'LLA'
rollback   --DECLARAR

--04.07

select c.tipo_cliente,c.estado,u.cod_dpto,u.cod_prov,u.cod_dto
from Contrato co
inner join Cliente c on co.codcliente=c.codcliente and c.tipo_cliente='P' and c.estado=0
inner join Zona z on c.codzona=z.codzona
inner join Ubigeo u on z.codubigeo=u.codubigeo
where u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'

begin tran
	delete co
	output deleted.codcliente,deleted.codplan
	from Contrato co
	inner join Cliente c on co.codcliente=c.codcliente and c.tipo_cliente='P' and c.estado=0
	inner join Zona z on c.codzona=z.codzona
	inner join Ubigeo u on z.codubigeo=u.codubigeo
	where u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'
rollback

--04.09
select * from Cliente where codcliente=500

begin tran
	update Cliente
	set   numdoc='46173386',
	      nombres='DOMITILA CAMILA',
		  ape_paterno='LOPEZ',
		  ape_materno='MORALES',
		  fec_nacimiento='1980-01-09',
		  sexo='F',
		  email='DOMITILA_LOPEZ@GMAIL.COM',
		  direccion='URB. LOS CIPRESES M-24',
		  codzona=2
	output deleted.numdoc,inserted.numdoc,deleted.nombres,inserted.nombres,deleted.ape_paterno,inserted.ape_paterno,
	       deleted.ape_materno,inserted.ape_materno
	where codcliente=500
rollback

--04.11

--Contratos 5% dscto.
select co.* from Contrato co
inner Join PlanInternet p on co.codplan=p.codplan
where p.nombre in ('PLAN TOTAL I','PLAN TOTAL II','GOLD I','GOLD II','GOLD III','PREMIUM II') and co.periodo='Q'

--Contratos 10% dscto.
select co.* from Contrato co
inner Join PlanInternet p on co.codplan=p.codplan
where p.nombre in ('PLAN TOTAL I','PLAN TOTAL II','GOLD I','GOLD II','GOLD III','PREMIUM II') and co.periodo='M'

alter table Contrato add precionuevo decimal(6,2)

select * from Contrato

--Calcular nuevo precio

begin tran
  update co
  set  co.precionuevo=case when p.nombre in ('PLAN TOTAL I','PLAN TOTAL II','GOLD I','GOLD II','GOLD III','PREMIUM II') and co.periodo='Q'
						   then 0.95*p.precioref
						   when p.nombre in ('PLAN TOTAL I','PLAN TOTAL II','GOLD I','GOLD II','GOLD III','PREMIUM II') and co.periodo='M'
						   then 0.90*p.precioref
						   else 0.98*p.precioref
					  end
  output deleted.codcliente,deleted.codplan,deleted.precionuevo,inserted.precionuevo
  from Contrato co
  inner join PlanInternet p on co.codplan=p.codplan
rollback

--¿Quiénes son los clientes a los cuales no les conviene este nuevo precio?

select case when c.tipo_cliente='E' then razon_social
			when c.tipo_cliente='P' then c.nombres+' '+c.ape_paterno+' '+c.ape_materno
			else 'SIN DETALLE'
			end as CLIENTE,
			p.nombre as [PLAN],
			co.preciosol,
			co.precionuevo
from Contrato co
left join Cliente c on co.codcliente=c.codcliente
left join PlanInternet p on co.codplan=p.codplan
where preciosol<precionuevo

--¿Quiénes son los clientes detectados con un diferencial de S/50.00 a más entre el nuevo precio y el precio actual?
select case when c.tipo_cliente='E' then razon_social
			when c.tipo_cliente='P' then c.nombres+' '+c.ape_paterno+' '+c.ape_materno
			else 'SIN DETALLE'
			end as CLIENTE,
			p.nombre as [PLAN],
			co.preciosol,
			co.precionuevo,
			precionuevo-preciosol as diferencial
from Contrato co
left join Cliente c on co.codcliente=c.codcliente
left join PlanInternet p on co.codplan=p.codplan
where precionuevo-preciosol>=50