--Carga de planes
--INSERT INTO (Registrar data)
--INSERT INTO TABLA_1(COL1,COL2,COL3) VALUES (VALUE1,VALUE2,VALUE3)
--IDENTITY(1,1): DESDE EL 1 E INCREMENTA 1.
Use DEVWIFI16ED
go
--insert into dbo.PlanInternet(nombre,precioref,descripcion)
--values ('PLAN TOTAL I',50,'Plan anterior ESTANDAR I')
insert into PlanInternet(nombre,precioref,descripcion) values ('PLAN TOTAL I',50,'Plan anterior ESTANDAR I')
go
insert into PlanInternet(nombre,precioref,descripcion) values ('PLAN TOTAL II',60,'Plan anterior ESTANDAR II')
go
insert into PlanInternet(nombre,precioref,descripcion) values ('GOLD I',70,'Plan nuevo')
go
insert into PlanInternet(nombre,precioref,descripcion) values ('GOLD II',90,'Plan nuevo')
go
insert into PlanInternet(nombre,precioref,descripcion) values ('GOLD III',100,'Plan nuevo')
go

select * from PlanInternet