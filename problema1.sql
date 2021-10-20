--1a
ALTER TABLE public.persons
   ADD COLUMN first_name character varying(256);

ALTER TABLE public.persons
    ADD COLUMN last_name character varying(256);
	
--1b
select persons_id, split_part(name, ' ', 1), split_part(name, ' ', 2) from persons;

--1c
do
$$
declare
	cur cursor for select persons_id, split_part(name, ' ', 1) as nome,
				split_part(name, ' ', 2) as cognome from persons ;
begin
	for temp_record in cur loop
		update persons set first_name = temp_record.nome, last_name = temp_record.cognome
		where persons_id = temp_record.persons_id;
end loop;
end$$;

select persons_id, first_name, last_name from persons;

--1d
ALTER TABLE public.persons DROP COLUMN name;
