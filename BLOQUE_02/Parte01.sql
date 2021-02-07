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

--02.10

--a
select * from TipoDocumento where codtipo=3

select IIF(codtipo=3,'RUC','OTRO TIPO') as TIPO_DOC, 
       numdoc as NUM_DOC,
	   razon_social as RAZON_SOCIAL,
	   codzona as CODZONA,
	   fec_inicio as FEC_INICIO
from   Cliente
--where  tipo_cliente='E' and (codzona=1 or codzona=3 or codzona=5 or codzona=7)
where  tipo_cliente='E' and codzona IN (1,3,5,7) 
order by razon_social desc

--b
select IIF(codtipo=3,'RUC','OTRO TIPO') as TIPO_DOC, 
       numdoc as NUM_DOC,
	   razon_social as RAZON_SOCIAL,
	   codzona as CODZONA,
	   fec_inicio as FEC_INICIO
from   Cliente
--where  tipo_cliente='E' and fec_inicio IN ('1998-01-01','1998-01-02'......) 
where  tipo_cliente='E' and fec_inicio between '1998-01-01' and '1998-12-31'
order by fec_inicio desc /*DESC(Más reciente al más antiguo)|ASC(Más antiguo al más reciente)*/

--02.12
select rtrim(ltrim('  DEV MASTER PERU  '))

select IIF(codtipo=1,'LE o DNI','OTRO') as TIPO_DOC,
       numdoc as NUM_DOC,
	   concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) as CLIENTE
from   Cliente
where  tipo_cliente='P' and 
--a.Nombre completo inicie en 'A' [nombres in ('ALBERTO','ANABEL','AMADO',......)]
--concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE 'A%'
--b.Nombre completo contiene la secuencia 'AMA' ['AMANDA','MAMANI','CAMA']
--concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '%AMA%'
--c.Nombre completo finaliza en 'AN'('ROMAN').
--concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '%AN'
--e.Nombre completo contenga la secuencia 'ARI' desde la 2° posición ([A-Z]ARI)
--concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '_ARI%'
--f.Nombre completo tenga como antepenúltimo carácter la 'M' ('...M..).
--concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '%M__'
--h.Nombre completo inicie y finalice con una vocal (a,e,i,o,u).
--concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '[aeiou]%[aeiou]'
--i Nombre completo inicie y finalice con una consonante.
--concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '[^aeiou]%[^aeiou]'
--j.Nombre inicie con una vocal y finalice con una consonante.
concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '[aeiou]%[^aeiou]'

--02.13

--SELECT: Solo Columnas GROUP BY | funciones agrupadoras
select  codzona as ZONA,
        estado as ESTADO,
		count(codcliente) as TOT_CLIENTES,
		min(fec_inicio)   as MIN_FEC_INICIO,
		max(fec_inicio)   as MAX_FEC_INICIO,
		case 
			when count(codcliente) between 0 and 19 then 'TOTAL_INFERIOR'
		    when count(codcliente) between 20 and 39 then 'TOTAL_MEDIO'
			when count(codcliente)>=40 then 'TOTAL_SUPERIOR'
		else 'SIN MENSAJE'
		end as MENSAJE
from Cliente
where tipo_cliente='E'
group by codzona,estado
having count(codcliente)>10

--02.15

select  
--Modificar el reporte para sólo mostrar las primeras 15 combinaciones con mayor número de total clientes
        --top(15)      
--Modificar el reporte para sólo mostrar el primer 15% de combinaciones con mayor número de total clientes=top(4)=15%*22=3.3=4
        top(15) percent
        estado as ESTADO,
		codzona as ZONA,
		count(codcliente)  as TOT_CLIENTES,
		min(rtrim(ltrim(ape_paterno)))   as MIN_APE_PAT,
		max(ltrim(rtrim(ape_paterno)))   as MAX_APE_PAT,
		case 
			when count(codcliente) between 0 and 14 then 'INFERIOR'
		    when count(codcliente) between 15 and 29 then 'MEDIO'
			when count(codcliente)>=30 then 'SUPERIOR'
		else 'SIN MENSAJE'
		end as MENSAJE
from Cliente
where tipo_cliente='P'
group by estado,codzona
order by TOT_CLIENTES desc