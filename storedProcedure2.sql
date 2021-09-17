/*
Data una tabella SCARICO_MERCI:

tipo_merce	descrizione	quantità	costo_unita
auto		parti auto	30		5
furgone		parti furgone	15		7
camion		parti camion	3		11

creare una stored procedure principale che contenga stored procedure secondarie (una per tipologia merce) che 

popoli, partendo da SCARICO_MERCI, delle tabelle di appoggio auto, furgone, camion così strutturate:

auto
quantità	costo_unità	totale
30		5		150

furgone
quantità	costo_unità	totale
15		7		105

camion
quantità	costo_unità	totale
3
*/

CREATE TABLE public.scarico_merci(
    tipo_merce character varying,
    descrizione character varying,
    quantita double precision,
    costo_unita double precision);
	
INSERT INTO public.scarico_merci values 
	('auto', 'parti auto', 30, 5),
	('furgone', 'parti furgone', 15, 7),
	('camion', 'parti camion', 3, 11);


CREATE TABLE public.auto(
    quantita double precision,
    costo_unita double precision,
    totale double precision);

CREATE TABLE public.furgone(
    quantita double precision,
    costo_unita double precision,
    totale double precision);

CREATE TABLE public.camion(
    quantita double precision,
    costo_unita double precision,
    totale double precision);
	
	
create or replace procedure insertAuto()
language plpgsql
as $$
begin
	INSERT INTO public.auto (quantita, costo_unita, totale)
	SELECT quantita, costo_unita, quantita*costo_unita
	FROM public.scarico_merci
	WHERE tipo_merce LIKE 'auto';
end; $$	

create or replace procedure insertFurgone()
language plpgsql
as $$
begin
	INSERT INTO public.furgone (quantita, costo_unita,totale)
	SELECT quantita, costo_unita, quantita*costo_unita
	FROM public.scarico_merci
	WHERE tipo_merce LIKE 'furgone';
end; $$	

create or replace procedure insertCamion()
language plpgsql
as $$
begin
	INSERT INTO public.camion (quantita, costo_unita,totale)
	SELECT quantita, costo_unita, quantita*costo_unita
	FROM public.scarico_merci
	WHERE tipo_merce LIKE 'camion';
end; $$	

create or replace procedure insertMerci()
language plpgsql
as $$
begin
	call insertAuto();
	call insertCamion();
	call insertFurgone();
end; $$	

call insertMerci();




