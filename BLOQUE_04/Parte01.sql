--04.01
--a
insert into PlanInternet 
output inserted.codplan,inserted.nombre
values ('GOLD IV',110.00,'Solicitado por comité junio 2020')

--b
select codplan,nombre from PlanInternet

--c
insert into PlanInternet 
output inserted.codplan,inserted.nombre
values 
('PREMIUM II',140.00,'Solicitado por comité junio 2020'),
('PREMIUM III',160.00,'Solicitado por comité junio 2020'),
('PREMIUM IV',180.00,'Solicitado por comité junio 2020')