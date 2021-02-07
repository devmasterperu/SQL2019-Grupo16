--Esto es un comentario
/*
  Esto es un comentario
  multilinea.
*/

--Cálculos 

select 10+5,'Hola'+'SQL Server','10'+5
select 10-5,5-10
select 10*5,5*10
select 10/5,5/10     --Modulo
select 10%5,5%10,9%2 --Resto

--Elementos de un SELECT

select codubigeo,
       count(codzona) as total   /*PASO_05|COLUMNAS_EXPRESIONES*/
from   Zona                      /*PASO_01|TABLA(S)*/
where  estado=1                  /*PASO_02|PREDICADO*/
group by codubigeo               /*PASO_03|GRUPOS*/
having count(codzona)>1          /*PASO_04|PREDICADO_GRUPO*/
order by total desc              /*PASO_06|ORDENAMIENTO*/

--Expresiones CASE
--ORDER BY

select * from Ubigeo
--order by codubigeo desc   /*ASC(Menor a mayor)|DESC (Mayor a menor)*/
--order by nom_dto desc     /*ASC(A-Z)|DESC(Z-A)*/
order by cod_dpto,cod_prov

--WHERE

select * from PlanInternet
--02.01
declare @n1 int=5
declare @n2 int=7

--select @n1+@n2,@n1-@n2,@n1*@n2,@n1/@n2,@n1%@n2

select 'n1'=@n1,'n2'=@n2,'F(n1,n2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)

--02.03

select nom_dpto from Ubigeo
select distinct nom_dpto from Ubigeo

select codubigeo from Zona
select distinct codubigeo from Zona

select nom_dpto,nom_prov from Ubigeo
select distinct nom_dpto,nom_prov from Ubigeo

select nom_dpto,nom_prov,nom_dto from Ubigeo
select distinct nom_dpto,nom_prov,nom_dto from Ubigeo

--02.04

Select nombre as ZONA,'CODIGO UBIGEO'=codubigeo,estado ESTADO,
       case when estado=1 then 'Zona activa' else 'Zona inactiva'
	   end as [MENSAJE ESTADO],
	   IIF(estado=1,'Zona activa','Zona inactiva') as [MENSAJE ESTADO 2] 
from   Zona
where codubigeo=1

--02.06
--select cast(round(50/3.647,2) as decimal(6,2))
declare @tc decimal(6,2)=3.647

select nombre as [PLAN],precioref as PRECIO_SOL,
       cast(round(precioref/@tc,2) as decimal(6,2)) as PRECIO_DOL,
       case 
		   when precioref>=0  and precioref<70  then '[0,70>'
		   when precioref>=70 and precioref<100 then '[70,100>'
		   when precioref>=100					then '[100, +>'
		   else                                      'Sin rango'
	   end as RANGO_SOL
from   PlanInternet

--02.08

--a. 
Select codzona as CODZONA,nombre as ZONA,'CODIGO UBIGEO'=codubigeo,estado ESTADO,
       case when estado=1 then 'Zona activa' else 'Zona inactiva'
	   end as [MENSAJE ESTADO]
from   Zona
where  estado=1 and codubigeo=1 /*Se muestran solo aquellos con predicado VERDADERO*/
order by codzona desc

--b.
Select codzona as CODZONA,nombre as ZONA,'CODIGO UBIGEO'=codubigeo,estado ESTADO,
       case when estado=1 then 'Zona activa' else 'Zona inactiva'
	   end as [MENSAJE ESTADO]
from   Zona
where  estado=1 and codubigeo=1 /*Se muestran solo aquellos con predicado VERDADERO*/
order by nombre desc

--c
Select codzona as CODZONA,nombre as ZONA,'CODIGO UBIGEO'=codubigeo,estado ESTADO,
       case when estado=1 then 'Zona activa' else 'Zona inactiva'
	   end as [MENSAJE ESTADO]
from   Zona
where  estado=0 or codubigeo=1 /*Se muestran solo aquellos con predicado VERDADERO*/
order by estado asc

--d
Select codzona as CODZONA,nombre as ZONA,'CODIGO UBIGEO'=codubigeo,estado ESTADO,
       case when estado=1 then 'Zona activa' else 'Zona inactiva'
	   end as [MENSAJE ESTADO]
from   Zona
where  estado=1 or codubigeo=1 /*Se muestran solo aquellos con predicado VERDADERO*/
order by codubigeo desc,nombre asc

--e
Select codzona as CODZONA,nombre as ZONA,'CODIGO UBIGEO'=codubigeo,estado ESTADO,
       case when estado=1 then 'Zona activa' else 'Zona inactiva'
	   end as [MENSAJE ESTADO]
from   Zona
--where  NOT(estado=1 and codubigeo=1) /*Se muestran solo aquellos con predicado VERDADERO*/
where  NOT(estado=1) or NOT(codubigeo=1) /*Se muestran solo aquellos con predicado VERDADERO*/
order by codzona asc