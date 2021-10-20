--3a
ALTER TABLE public.persons
    ADD COLUMN data_di_nascita date;
	
--3b
create or replace procedure formatoData()
language plpgsql
as
$$
declare 
cur cursor for select persons_id, birth_date from persons;
data_nascita date;
begin
for temp_rec in cur loop
select to_date(temp_rec.birth_date,'YYYYMMDD') into data_nascita;
update persons set data_di_nascita = data_nascita where persons_id = temp_rec.persons_id;
end loop;
end$$;

call formatoData();