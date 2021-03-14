--07.01

--VARIABLES

declare @n1 int=5,@n2 int=7

select 'F(N1, N2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)

--PROCEDIMIENTO ALMACENADO

create procedure dbo.usp_SelPolinomio(@n1 int,@n2 int)
as
begin
	select 'F(N1, N2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)
end

exec    dbo.usp_SelPolinomio 5,7
execute dbo.usp_SelPolinomio 5,7
execute dbo.usp_SelPolinomio 7,5
execute dbo.usp_SelPolinomio @n1=5,@n2=7
execute dbo.usp_SelPolinomio @n2=7,@n1=5

--FUNCION_ESCALAR

create function dbo.ufn_SelPolinomio(@n1 int,@n2 int) returns integer
as
begin
	return power(@n1,2)+10*@n1*@n2+power(@n2,2)
end

alter function dbo.ufn_SelPolinomio(@n1 int,@n2 int) returns integer
as
begin 
    declare @resultado int=(select power(@n1,2)+10*@n1*@n2+power(@n2,2))
	/*Más instrucciones*/
	return  @resultado
end

select dbo.ufn_SelPolinomio(5,7) as 'F(N1,N2)'

select codplan,codcliente,dbo.ufn_SelPolinomio(codplan,codcliente) as 'F(N1,N2)' from Contrato

--07.03

--VARIABLES

declare @tipo varchar(3)='WSP'
declare @mensaje varchar(500)='Hola,muchas gracias por su preferencia. Tenemos excelentes promociones para usted'

select tipo as TIPO,numero as TELEFONO,@mensaje as MENSAJE
from   Telefono
where  estado=1 and tipo=@tipo

--select *,'Hola, no olvide realizar el pago de su servicio de Internet' from Telefono
--where estado=1 and tipo=@tipo

--PROCEDIMIENTO_ALMACENADO

create procedure dbo.USP_REPORTE_TEL( @tipo varchar(3),@mensaje varchar(500))
as
--declare @tipo varchar(3)='WSP'
--declare @mensaje varchar(500)='Hola,muchas gracias por su preferencia. Tenemos excelentes promociones para usted'
begin
	select tipo as TIPO,numero as TELEFONO,@mensaje as MENSAJE
	from   Telefono
	where  estado=1 and tipo=@tipo
end

EXECUTE USP_REPORTE_TEL 
        @tipo= 'LLA', 
        @mensaje= 'Hola, no olvide realizar el pago de su servicio de Internet hasta el 31/03'

EXECUTE USP_REPORTE_TEL 
        @tipo= 'SMS', 
        @mensaje= 'Hola,muchas gracias por su preferencia. Tenemos excelentes promociones para usted'

EXECUTE USP_REPORTE_TEL 
        @tipo= 'WSP', 
        @mensaje= 'Hola,hasta el 15/07 recibe un 20% de descuento en tu facturación'

alter procedure dbo.USP_REPORTE_TEL( @tipo varchar(3),@mensaje varchar(500))
as
begin
	select tipo as TIPO,numero as TELEFONO,
	       coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'Cliente')+@mensaje as MENSAJE
	from   Telefono t
	left join Cliente c on t.codcliente=c.codcliente
	where  t.estado=1 and tipo=@tipo
end

EXECUTE USP_REPORTE_TEL 
        @tipo= 'LLA', 
        @mensaje= ' no olvide realizar el pago de su servicio de Internet hasta el 31/03'

--07.05

--Crear tabla Configuraciones

create table dbo.Configuracion
(
	codconfiguracion int identity(1,1) primary key,
	nombre varchar(500)  not null,
	valor  varchar(1000) not null
)

insert into dbo.Configuracion values ('RAZON_SOCIAL_DEVWIFI','DEV MASTER PERÚ SAC')
go
insert into dbo.Configuracion values ('RUC_DEVWIFI','20602275320')
go
select codconfiguracion,nombre,valor from Configuracion

-- VARIABLES

declare @codcliente int=20000

if exists(select codcliente from Cliente where codcliente=@codcliente)
begin
	select 
	(select valor from Configuracion where nombre='RAZON_SOCIAL_DEVWIFI') as RAZON_SOCIAL_DEVWIFI,
	(select valor from Configuracion where nombre='RUC_DEVWIFI') as RUC_DEVWIFI,
	getdate() as [CONSULTA AL],
	coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN DETALLE') as CLIENTE,
	isnull(direccion,'SIN DETALLE') as DIRECCION,
	isnull(z.nombre,'SIN DETALLE')  as NOMBRE_ZONA
	from Cliente c
	left join Zona z on c.codzona=z.codzona
	where codcliente=@codcliente
end
else
begin
	select 'El cliente no ha sido encontrado en la Base de Datos'
end
--PROCEDIMIENTO_ALMACENADO

alter procedure USP_SELCLIENTE(@codcliente int) as
--declare @codcliente int=700
begin
	if exists(select codcliente from Cliente where codcliente=@codcliente)
	begin
		select 
		(select valor from Configuracion where nombre='RAZON_SOCIAL_DEVWIFI') as RAZON_SOCIAL_DEVWIFI,
		(select valor from Configuracion where nombre='RUC_DEVWIFI') as RUC_DEVWIFI,
		getdate() as [CONSULTA AL],
		coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN DETALLE') as CLIENTE,
		isnull(direccion,'SIN DETALLE') as DIRECCION,
		isnull(z.nombre,'SIN DETALLE')  as NOMBRE_ZONA
		from Cliente c
		left join Zona z on c.codzona=z.codzona
		where codcliente=@codcliente
	end
	else
	begin
		select 'El cliente no ha sido encontrado en la Base de Datos'
	end
end

EXECUTE USP_SELCLIENTE @codcliente=100
EXECUTE USP_SELCLIENTE @codcliente=700
EXECUTE USP_SELCLIENTE @codcliente=20000

--07.06

--VARIABLES
declare @cod_dpto varchar(3)='9',
	    @nom_dpto varchar(50)='DPTO9',
		@cod_prov varchar(3)='9',
		@nom_prov varchar(50)='PROV9',
		@cod_dto  char(3)='10',
		@nom_dto  varchar(80)='DTO10'

if not exists(select codubigeo from Ubigeo where cod_dpto=@cod_dpto and cod_prov=@cod_prov and cod_dto=@cod_dto)
begin
	insert into dbo.Ubigeo(cod_dpto,nom_dpto,cod_prov,nom_prov,cod_dto,nom_dto)
	values (@cod_dpto,@nom_dpto,@cod_prov,@nom_prov,@cod_dto,@nom_dto)

	select 'Ubigeo insertado' as mensaje,IDENT_CURRENT('dbo.Ubigeo') as codubigeo
end
else
begin
	select 'Ubigeo existente' as mensaje,0 as codubigeo
end

select * from Ubigeo where cod_dpto='9' and cod_prov='9' and cod_dto='10'

--PROCEDIMIENTO ALMACENADO
create procedure dbo.USP_INSUBIGEO
@cod_dpto varchar(3),
@nom_dpto varchar(50),
@cod_prov varchar(3),
@nom_prov varchar(50),
@cod_dto  char(3),
@nom_dto  varchar(80)
as
begin
	if not exists(select codubigeo from Ubigeo where cod_dpto=@cod_dpto and cod_prov=@cod_prov and cod_dto=@cod_dto)
	begin
		insert into dbo.Ubigeo(cod_dpto,nom_dpto,cod_prov,nom_prov,cod_dto,nom_dto)
		values (@cod_dpto,@nom_dpto,@cod_prov,@nom_prov,@cod_dto,@nom_dto)

		select 'Ubigeo insertado' as mensaje,IDENT_CURRENT('dbo.Ubigeo') as codubigeo
	end
	else
	begin
		select 'Ubigeo existente' as mensaje,0 as codubigeo
	end
end

execute dbo.USP_INSUBIGEO @cod_dpto='11',@nom_dpto='D11',@cod_prov='11',@nom_prov='P11',@cod_dto='11',@nom_dto='DTO11'

select * from Ubigeo where codubigeo=21

go
declare @cod_dpto varchar(3)='9',
	    @nom_dpto varchar(50)='DPTO9',
		@cod_prov varchar(3)='9',
		@nom_prov varchar(50)='PROV9',
		@cod_dto  char(3)='10',
		@nom_dto  varchar(80)='DTO10'

insert into dbo.Ubigeo(cod_dpto,nom_dpto,cod_prov,nom_prov,cod_dto,nom_dto)
values (@cod_dpto,@nom_dpto,@cod_prov,@nom_prov,@cod_dto,@nom_dto)

select 'Ubigeo insertado' as mensaje,IDENT_CURRENT('dbo.Ubigeo') as codubigeo

select * from dbo.Ubigeo

--07.08

--VARIABLES

declare @codcliente int=400,
		@codtipo int=3,
		@numdoc varchar(15)='20602275320',
		@razon_social varchar(100)='DEV MASTER PERÚ SAC',
		@fec_inicio date='2020-01-01',
		@email varchar(320)='INFO@DEVMASTER.PE',
		@direccion varchar(250)='MZ.M LOTE 24 URB. LOS CIPRESES',
		@codzona int=3,
		@estado int=0

if exists(select codcliente from Cliente where tipo_cliente='E' and codcliente=@codcliente)
begin
		/*BEGIN TRAN*/
		update  c
		set		codtipo=@codtipo,
				numdoc=@numdoc,
				razon_social=@razon_social,
				fec_inicio=@fec_inicio,
				email=@email,
				direccion=@direccion,
				codzona=@codzona,
				estado=@estado
		from    Cliente c
		where   tipo_cliente='E' and codcliente=@codcliente
		/*ROLLBACK*/

		select 'Cliente empresa actualizado' as MENSAJE,@codcliente as CODCLIENTE
end
else
begin
		select 'No es posible identificar al cliente empresa a actualizar' as MENSAJE,@codcliente as CODCLIENTE
end

--codcliente	codtipo	numdoc	tipo_cliente	nombres	ape_paterno	ape_materno	sexo	fec_nacimiento	razon_social	fec_inicio	direccion	email	codzona	estado
--400	3	77884365091	E	NULL	NULL	NULL	NULL	NULL	EMPRESA 400	2001-09-29	CA. ALFONSO UGARTE	CONTACTO@EMPRESA400.PE	2	1
--400	3	20602275320	E	NULL	NULL	NULL	NULL	NULL	DEV MASTER PERÚ SAC	2020-01-01	MZ.M LOTE 24 URB. LOS CIPRESES	INFO@DEVMASTER.PE	3	0
select * from Cliente where codcliente=400

--PROCEDIMIENTO ALMACENADO

create procedure dbo.USP_UPDCliente
@codcliente int,
@codtipo int,
@numdoc varchar(15),
@razon_social varchar(100),
@fec_inicio date,
@email varchar(320),
@direccion varchar(250),
@codzona int,
@estado int
as
begin
	if exists(select codcliente from Cliente where tipo_cliente='E' and codcliente=@codcliente)
	begin
			/*BEGIN TRAN*/
			update  c
			set		codtipo=@codtipo,
					numdoc=@numdoc,
					razon_social=@razon_social,
					fec_inicio=@fec_inicio,
					email=@email,
					direccion=@direccion,
					codzona=@codzona,
					estado=@estado
			from    Cliente c
			where   tipo_cliente='E' and codcliente=@codcliente
			/*ROLLBACK*/

			select 'Cliente empresa actualizado' as MENSAJE,@codcliente as CODCLIENTE
	end
	else
	begin
			select 'No es posible identificar al cliente empresa a actualizar' as MENSAJE,@codcliente as CODCLIENTE
	end
end

execute dbo.USP_UPDCliente 
        @codcliente =400,
		@codtipo=3,
		@numdoc='20602275320',
		@razon_social='DEV MASTER PERÚ SAC',
		@fec_inicio='2020-01-01',
		@email='VENTAS@DEVMASTER.PE',
		@direccion='MZ.M LOTE 25 URB. LOS CIPRESES',
		@codzona=5,
		@estado=1

select * from Cliente where codcliente=400

--07.10

create procedure USP_DELTelefono(@tipo varchar(3),@numero varchar(20))
as
begin
	if exists(select 1 from Telefono where tipo=@tipo and numero=@numero)
	begin
		--BEGIN TRAN
		delete from dbo.Telefono
		where tipo=@tipo and numero=@numero
		--ROLLBACK
		select 'Teléfono eliminado' as MENSAJE,@tipo as TIPO,@numero as NUMERO
	end
	else
	begin
		select 'No es posible identificar al teléfono a eliminar' as MENSAJE,
		       'TTT' as TIPO,'999999999' as NUMERO
	end
end

select * from Telefono

EXECUTE USP_DELTelefono @tipo='LLA',@numero='915703551'
EXECUTE USP_DELTelefono @tipo='SMS',@numero='946909800'

select * from Telefono
where tipo='SMS' and numero='946909800'
