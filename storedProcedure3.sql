create table contabilita (
	data date,
	descrizione text,
	segno_contabile varchar(1),
	importo numeric
)

INSERT INTO contabilita values 
	('01/01/2020', 'acquisto merce', '-', 200),
	('01/02/2020', 'vendita merce', '+', 500),
	
	('01/04/2020', 'acquisto merce', '-', 300),
	('01/05/2020', 'vendita merce', '+', 600),
	
	('01/07/2020', 'acquisto merce', '-', 400),
	('01/08/2020', 'vendita merce', '+', 700),
	
	('01/10/2020', 'acquisto merce', '-', 500),
	('01/11/2020', 'vendita merce', '+', 800);
	
DROP TABLE IF EXISTS I_trim_attivo;
CREATE TABLE I_trim_attivo (LIKE contabilita INCLUDING ALL);
DROP TABLE IF EXISTS II_trim_attivo;
CREATE TABLE II_trim_attivo (LIKE contabilita INCLUDING ALL);
DROP TABLE IF EXISTS III_trim_attivo;
CREATE TABLE III_trim_attivo (LIKE contabilita INCLUDING ALL);
DROP TABLE IF EXISTS IV_trim_attivo;
CREATE TABLE IV_trim_attivo (LIKE contabilita INCLUDING ALL);
DROP TABLE IF EXISTS I_trim_passivo;
CREATE TABLE I_trim_passivo (LIKE contabilita INCLUDING ALL);
DROP TABLE IF EXISTS II_trim_passivo;
CREATE TABLE II_trim_passivo (LIKE contabilita INCLUDING ALL);
DROP TABLE IF EXISTS III_trim_passivo;
CREATE TABLE III_trim_passivo (LIKE contabilita INCLUDING ALL);
DROP TABLE IF EXISTS IV_trim_passivo;
CREATE TABLE IV_trim_passivo (LIKE contabilita INCLUDING ALL);

create or replace procedure somma()
language plpgsql
as
$$
declare
	attivo numeric;
	passivo numeric;
	totale numeric;
begin
	select sum(importo) into attivo from I_trim_attivo;
	select sum(importo) into passivo from I_trim_passivo;
		totale = attivo-passivo;
		raise notice 'Il saldo del I trimestre è: %', totale;
	
	select sum(importo) into attivo from II_trim_attivo;
	select sum(importo) into passivo from II_trim_passivo;
		totale = attivo-passivo;
		raise notice 'Il saldo del II trimestre è: %', totale;
	
	select sum(importo) into attivo from III_trim_attivo;
	select sum(importo) into passivo from III_trim_passivo;
		totale = attivo-passivo;
		raise notice 'Il saldo del III trimestre è: %', totale;
	
	select sum(importo) into attivo from IV_trim_attivo;
	select sum(importo) into passivo from IV_trim_passivo;
		totale = attivo-passivo;
		raise notice 'Il saldo del IV trimestre è: %', totale;
	
end;$$

create or replace procedure saldo()
language plpgsql
as
$$
declare
	row record;
	cursore cursor for (select * from contabilita);
	
begin
	open cursore;
	loop
	fetch cursore into row;
	exit when not found;
	
	if row.data BETWEEN '01/01/2020' and '31/03/2020' and row.segno_contabile = '+' then 
		insert into I_trim_attivo values (row.data,row.descrizione,row.segno_contabile,row.importo);

	elseif row.data BETWEEN '01/01/2020' and '31/03/2020' and row.segno_contabile = '-' then
		insert into I_trim_passivo values (row.data,row.descrizione,row.segno_contabile,row.importo);

	elseif row.data BETWEEN '01/04/2020' and '30/06/2020' and row.segno_contabile = '+' then
		insert into II_trim_attivo values (row.data,row.descrizione,row.segno_contabile,row.importo);

	elseif row.data BETWEEN '01/04/2020' and '30/06/2020' and row.segno_contabile = '-' then
		insert into II_trim_passivo values (row.data,row.descrizione,row.segno_contabile,row.importo);

	elseif row.data BETWEEN '01/07/2020' and '30/09/2020' and row.segno_contabile = '+' then
		insert into III_trim_attivo values (row.data,row.descrizione,row.segno_contabile,row.importo);

	elseif row.data BETWEEN '01/07/2020' and '30/09/2020' and row.segno_contabile = '-' then
		insert into III_trim_passivo values (row.data,row.descrizione,row.segno_contabile,row.importo);

	elseif row.data BETWEEN '01/10/2020' and '31/12/2020' and row.segno_contabile = '+' then
		insert into IV_trim_attivo values (row.data,row.descrizione,row.segno_contabile,row.importo);

	elseif row.data BETWEEN '01/10/2020' and '31/12/2020' and row.segno_contabile = '-' then
		insert into IV_trim_passivo values (row.data,row.descrizione,row.segno_contabile,row.importo);

	end if;
	end loop;
	close cursore;
	call somma();
end;$$


call saldo();