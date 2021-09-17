create table tabella1 (
	nome varchar,
	cognome varchar);

create table tabella2 (
	nome varchar,
	cognome varchar);
	
create table tabella3 (
	nome varchar,
	cognome varchar);

insert into tabella1 values 
		('david', 'beckham'),
		('aldo', 'neri'),
		('anna', 'rossi'),
		('jane', 'rossi'),
		('ursula', 'nera'),
		('pippo', 'baudo'),
		('deva', 'bellucci');
		
create or replace function smistaDati()
returns void
LANGUAGE plpgsql
as
$$
declare 
	cur CURSOR FOR select nome, cognome from tabella1;
	v_nome tabella1.nome%type;
	v_cognome tabella1.cognome%type;
	count int;
	i int;
	
	
BEGIN
	i = 1;
	count = (select count(*) from tabella1);
	
	open cur;
	loop
		i = i+1;
			fetch cur into v_nome, v_cognome;
			if v_cognome = 'rossi' THEN 
				insert into tabella2 values 
						(v_nome, v_cognome);
			else insert into tabella3 values 
						(v_nome, v_cognome);
end if;
			
			exit when i>count;
	end loop;
	close cur;

END $$;

select smistaDati();

select * from tabella2;
select * from tabella3;




create or replace function pari_dispari(numero integer)
returns integer
language plpgsql
as
$$
declare

	v_number varchar := numero :: varchar;
	v_temp varchar;
	v_temp_convert integer;
	number_output integer;
	number_cifre integer;
	i int;
	
begin

	select length(v_number) into number_cifre;
	i = 0;
	for i in 1..number_cifre loop
	
	select substr(v_number,i,1)
	into v_temp;
	
	v_temp_convert := v_temp :: integer;
	
	if (v_temp_convert % 2 = 0) then
	
	v_temp_convert = v_temp_convert + 2;
	
	else
	
	v_temp_convert = v_temp_convert + 1;
	
	end if;
	
	select concat(number_output,v_temp_convert) 
	into number_output;
	
	exit when i > number_cifre;
	
end loop;
return number_output;
end $$;

select pari_dispari(1568);



create or replace function deleteChar (string varchar)
returns varchar
language plpgsql
as
$$
declare
temp varchar;
output varchar;
count integer;
i int;
begin
select length(string) into count;
i = 0;
for i in 1..count loop
select substr(string,i,1) into temp;
if (i % 2 = 1) then
select concat(output, temp) into output;
end if;
exit when i = count;
end loop;
return output;
end $$;

select deleteChar('Hello World')









create or replace function countTab ()
returns varchar
language plpgsql
as
$$
declare
countTab1 integer;
countTab2 integer;
countTab3 integer;
somma integer;
output varchar;

begin

select count(*) from actor into countTab1;
select count(*) from address into countTab2;
select count(*) from category into countTab3;

somma = countTab1 + countTab2 + countTab3;

output = concat(countTab1::varchar, ' ', countTab2::varchar, ' ', countTab3::varchar, ' ', somma::varchar);

return output;
end $$;

select countTab();

select t1.count1, t2.count2, t3.count3, (t1.count1+t2.count2+t3.count3) as somma 
from (select count(*) as count1 from actor)as t1,
	(select count(*) as count2 from address) as t2,
	(select count(*) as count3 from category) as t3;

