insert into public.anagrafica_dipendenti values ('cf11111111111111', 'alessio', 'cuoccio', '10/01/2020');
insert into public.anagrafica_dipendenti values ('cf22222222222222', 'pippo', 'rossi', '10/04/2020');
insert into public.anagrafica_dipendenti values ('cf33333333333333', 'paperino', 'bianchi', '10/07/2020');

CREATE TABLE public.copy_anagrafica_dipendenti (LIKE public.anagrafica_dipendenti INCLUDING ALL);

insert into public.anagrafica_fornitori values ('cf55555555555555', 'giancarlo', 'magalli', '10/01/2020');
insert into public.anagrafica_fornitori values ('cf66666666666666', 'luca', 'pesti', '10/04/2020');
insert into public.anagrafica_fornitori values ('cf77777777777777', 'marco', 'gialli', '10/07/2020');
insert into public.anagrafica_fornitori values ('cf88888888888888', 'arturo', 'brachetti', '10/10/2020');

CREATE TABLE public.copy_anagrafica_fornitori (LIKE public.anagrafica_fornitori INCLUDING ALL);

insert into public.contabilita values (01, 01, 2000, '10/01/2020');
insert into public.contabilita values (02, 02, 1000, '10/04/2020');
insert into public.contabilita values (03, 03, 5000, '10/07/2020');
insert into public.contabilita values (04, 04, 800, '10/10/2020');

CREATE TABLE public.copy_contabilita (LIKE public.contabilita INCLUDING ALL);

insert into public.magazzino values (01, 'merce01', 2, '10/01/2020');
insert into public.magazzino values (02, 'merce02', 1, '10/04/2020');
insert into public.magazzino values (03, 'merce03', 5, '10/07/2020');
insert into public.magazzino values (04, 'merce04', 0.80, '10/10/2020');

CREATE TABLE public.copy_magazzino (LIKE public.magazzino INCLUDING ALL);

insert into public.parco_auto values (123, 'marca1', 'modello1', '10/01/2020');
insert into public.parco_auto values (456, 'marca2', 'modello2', '10/04/2020');
insert into public.parco_auto values (789, 'marca3', 'modello3', '10/07/2020');
insert into public.parco_auto values (147, 'marca4', 'modello4', '10/10/2020');

CREATE TABLE public.copy_parco_auto (LIKE public.parco_auto INCLUDING ALL);


create or replace procedure copyDip(dataInizio date, dataFine date)
language plpgsql
as $$
begin
INSERT INTO public.copy_anagrafica_dipendenti SELECT * FROM public.anagrafica_dipendenti
WHERE data_assunzione BETWEEN dataInizio AND dataFine;
end; $$


create or replace procedure copyFor(dataInizio date, dataFine date)
language plpgsql
as $$
begin
INSERT INTO public.copy_anagrafica_fornitori SELECT * FROM public.anagrafica_fornitori
WHERE data_primo_ordine BETWEEN dataInizio AND dataFine;
end; $$


create or replace procedure copyCont(dataInizio date, dataFine date)
language plpgsql
as $$
begin
INSERT INTO public.copy_contabilita SELECT * FROM public.contabilita
WHERE data_operazione BETWEEN dataInizio AND dataFine;
end; $$


create or replace procedure copyMag(dataInizio date, dataFine date)
language plpgsql
as $$
begin
INSERT INTO public.copy_magazzino SELECT * FROM public.magazzino
WHERE data_entrata BETWEEN dataInizio AND dataFine;
end; $$

create or replace procedure copyPar(dataInizio date, dataFine date)
language plpgsql
as $$
begin
INSERT INTO public.copy_parco_auto SELECT * FROM public.parco_auto
WHERE data_acquisto BETWEEN dataInizio AND dataFine;
end; $$


create or replace procedure copyDB(dataInizio date, dataFine date)
language plpgsql
as $$
begin
call copyDip(dataInizio, dataFine);
call copyFor(dataInizio, dataFine);
call copyCont(dataInizio, dataFine);
call copyMag(dataInizio, dataFine);
call copyPar(dataInizio, dataFine);
end; $$

call copyDB('01/04/2020', '30/06/2020');
