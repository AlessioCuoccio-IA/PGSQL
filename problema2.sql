--2a
select birth_place
from persons 
where  not EXISTS (select city from codice_catastale where city = birth_place or citta = birth_place);

--2b
CREATE TABLE persons_bck ( like persons including all);

--2c
create or replace procedure spostaCampi()
language plpgsql
as
$$
declare
cur cursor for select *
				from persons 
				where  not EXISTS (select city from codice_catastale where city = persons.birth_place or citta = persons.birth_place);
begin
for temp_record in cur loop
	insert into persons_bck (birth_place,
							birth_date,
							sex,
							phone,
							email,
							first_name,
							last_name) values (temp_record.birth_place,
											  temp_record.birth_date,
											  temp_record.sex,
											  temp_record.phone,
											  temp_record.email,
											  temp_record.first_name,
											  temp_record.last_name);
											  
		delete from persons where persons_id = temp_record.persons_id;
end loop;
end$$;

call spostaCampi();
		
