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

--02.01
declare @n1 int=5
declare @n2 int=7

--select @n1+@n2,@n1-@n2,@n1*@n2,@n1/@n2,@n1%@n2

select 'n1'=@n1,'n2'=@n2,'F(n1,n2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)
