--4a
CREATE OR REPLACE function extractCognome( cognome persons.last_name%TYPE)
returns char(3)
AS 
$$
DECLARE

  consonanti text;
  string_finale char(3);
  
BEGIN

	select upper(trim(cognome)) into cognome;
	select translate(cognome, 'AEIOUaeiou'' ', '') into consonanti;
	
	if length(consonanti) >= 3 then
		select substring(consonanti from 1 for 3) into string_finale;
		
	elsif length(consonanti) < 3 then
		select rpad(consonanti,3,'X') into string_finale;
		
	end if;
	
return string_finale;

end
$$
language plpgsql;

select extractcognome('Cuoccio');

CREATE OR REPLACE function extractNome( nome persons.first_name%TYPE)
returns char(3)
as 
$$
declare

	consonanti text;
	string_finale char(3);
	
begin

	select upper(trim(nome)) into nome;
	select translate(nome,'AEIOUaeiou'' ','') into consonanti;
	
	if length( consonanti ) >= 4 then
		select concat(substring(consonanti from 1 for 1),substring(consonanti from 3 for 1),substring(consonanti from 4 for 1)) into string_finale;
	
	elsif length(consonanti) = 3 then
		select substring(consonanti from 1 for 3) into string_finale;
	
	elsif length(consonanti) < 3 then
		select rpad(consonanti,3,'X') into string_finale;
		
	end if;
	
return string_finale;

end
$$
language plpgsql;

select extractnome('Alessio');


--4b
CREATE OR REPLACE FUNCTION lettera_mese (data_nascita persons.data_di_nascita%TYPE)
RETURNS char(1)
AS 
$$
DECLARE 
   mese_nascita int; 
   month_decode char[] := ARRAY[ 'a', 'b', 'c', 'd', 'e', 'h', 'l', 'm', 'p', 'r', 's', 't'];

BEGIN

  mese_nascita := EXTRACT(month FROM data_nascita);
  
  RETURN upper(month_decode[mese_nascita]);
  
END
$$
LANGUAGE plpgsql;

select lettera_mese('1996-04-11');


--4c
create or replace function extractAnnoMeseGiornoSesso(data_nascita persons.data_di_nascita%TYPE, sex persons.sex%TYPE)
returns char(5)
AS 
$$
DECLARE
 a integer;
 m char := lettera_mese(data_nascita);
 g integer;
 
BEGIN

	a := to_char( data_nascita, 'yy' );
	g := EXTRACT( day FROM data_nascita );

	IF sex like 'F' THEN
    	g := g + 40;
		
  	END IF;

RETURN lpad( a::text, 2, '0' )
       || m
       || lpad( g::text, 2, '0' );
	   
END
$$
LANGUAGE plpgsql;

select extractannomesegiornosesso('1996-04-11', 'M');


--4d
create or replace function getCodiceCat(vCity persons.birth_place%TYPE)
returns varchar
as
$$
declare
cod varchar;

begin

	select codice_catastale
	into cod
	from codice_catastale
	where city = vCity or citta = vCity;
	
return cod;

END
$$
LANGUAGE plpgsql;

select getCodiceCat('Bitonto')


--4e
create or replace function creaCF15(cognome persons.last_name%TYPE, nome persons.first_name%TYPE, sesso persons.sex%TYPE, luogo persons.birth_place%TYPE, v_data_nascita persons.data_di_nascita%TYPE)
returns char(15)
as
$$
declare 
	cf varchar;
	
begin

	select CONCAT(extractcognome(cognome), extractnome(nome), extractAnnoMeseGiornoSesso(v_data_nascita, sesso), getCodiceCat(luogo)) into cf;

return cf;

END
$$
LANGUAGE plpgsql;

select creacf15('Cuoccio', 'Alessio', 'M', 'Bitonto', '1996-04-11');


--4f
create or replace function carattereControllo(stringa char(15))
returns char(16)
as
$$
declare
	lettera_pari char(1);
	lettera_dispari char(1);
	lettera_finale char(1);
	somma_pari integer;
	somma_dispari integer;
	i integer;
	valore integer;
	totale integer;
	risultato integer;
	
begin

	somma_pari = 0;
	somma_dispari = 0;
	risultato = 0;

	for i in 1..(select length(stringa)) loop
	
		if (select mod(i,2) = 1) then
		
			select substring(stringa from i for 1) into lettera_dispari;
			
			case
				when lettera_dispari = 'A' or lettera_dispari = '0' then valore = 1;
				when lettera_dispari = 'B' or lettera_dispari = '1' then valore = 0;
				when lettera_dispari = 'C' or lettera_dispari = '2' then valore = 5;
				when lettera_dispari = 'D' or lettera_dispari = '3' then valore = 7;
				when lettera_dispari = 'E' or lettera_dispari = '4' then valore = 9;
				when lettera_dispari = 'F' or lettera_dispari = '5' then valore = 13;
				when lettera_dispari = 'G' or lettera_dispari = '6' then valore = 15;
				when lettera_dispari = 'H' or lettera_dispari = '7' then valore = 17;
				when lettera_dispari = 'I' or lettera_dispari = '8' then valore = 19;
				when lettera_dispari = 'J' or lettera_dispari = '9' then valore = 21;
				when lettera_dispari = 'K' then valore = 2;
				when lettera_dispari = 'L' then valore = 4;
				when lettera_dispari = 'M' then valore = 18;
				when lettera_dispari = 'N' then valore = 20;
				when lettera_dispari = 'O' then valore = 11;
				when lettera_dispari = 'P' then valore = 3;
				when lettera_dispari = 'Q' then valore = 6;
				when lettera_dispari = 'R' then valore = 8;
				when lettera_dispari = 'S' then valore = 12;
				when lettera_dispari = 'T' then valore = 14;
				when lettera_dispari = 'U' then valore = 16;
				when lettera_dispari = 'V' then valore = 10;
				when lettera_dispari = 'W' then valore = 22;
				when lettera_dispari = 'X' then valore = 25;
				when lettera_dispari = 'Y' then valore = 24;
				when lettera_dispari = 'Z' then valore = 23;
			end case;
			
			somma_dispari = somma_dispari + valore;
	
		else
		
			select substring(stringa from i for 1) into lettera_pari;
	
				case
					when lettera_pari = 'A' or lettera_pari = '0' then valore = 0;
					when lettera_pari = 'B' or lettera_pari = '1' then valore = 1;
					when lettera_pari = 'C' or lettera_pari = '2' then valore = 2;
					when lettera_pari = 'D' or lettera_pari = '3' then valore = 3;
					when lettera_pari = 'E' or lettera_pari = '4' then valore = 4;
					when lettera_pari = 'F' or lettera_pari = '5' then valore = 5;
					when lettera_pari = 'G' or lettera_pari = '6' then valore = 6;
					when lettera_pari = 'H' or lettera_pari = '7' then valore = 7;
					when lettera_pari = 'I' or lettera_pari = '8' then valore = 8;
					when lettera_pari = 'J' or lettera_pari = '9' then valore = 9;
					when lettera_pari = 'K' then valore = 10;
					when lettera_pari = 'L' then valore = 11;
					when lettera_pari = 'M' then valore = 12;
					when lettera_pari = 'N' then valore = 13;
					when lettera_pari = 'O' then valore = 14;
					when lettera_pari = 'P' then valore = 15;
					when lettera_pari = 'Q' then valore = 16;
					when lettera_pari = 'R' then valore = 17;
					when lettera_pari = 'S' then valore = 18;
					when lettera_pari = 'T' then valore = 19;
					when lettera_pari = 'U' then valore = 20;
					when lettera_pari = 'V' then valore = 21;
					when lettera_pari = 'W' then valore = 22;
					when lettera_pari = 'X' then valore = 23;
					when lettera_pari = 'Y' then valore = 24;
					when lettera_pari = 'Z' then valore = 25;
			end case;
	
		somma_pari = somma_pari + valore;
		
	end if;
	
end loop;

		totale = somma_dispari + somma_pari;
		risultato = (totale) - (((totale)/26) * 26);
		
		case
			when risultato = 0 then lettera_finale = 'A';
			when risultato = 1 then lettera_finale = 'B';
			when risultato = 2 then lettera_finale = 'C';
			when risultato = 3 then lettera_finale = 'D';
			when risultato = 4 then lettera_finale = 'E';
			when risultato = 5 then lettera_finale = 'F';
			when risultato = 6 then lettera_finale = 'G';
			when risultato = 7 then lettera_finale = 'H';
			when risultato = 8 then lettera_finale = 'I';
			when risultato = 9 then lettera_finale = 'J';
			when risultato = 10 then lettera_finale = 'K';
			when risultato = 11 then lettera_finale = 'L';
			when risultato = 12 then lettera_finale = 'M';
			when risultato = 13 then lettera_finale = 'N';
			when risultato = 14 then lettera_finale = 'O';
			when risultato = 15 then lettera_finale = 'P';
			when risultato = 16 then lettera_finale = 'Q';
			when risultato = 17 then lettera_finale = 'R';
			when risultato = 18 then lettera_finale = 'S';
			when risultato = 19 then lettera_finale = 'T';
			when risultato = 20 then lettera_finale = 'U';
			when risultato = 21 then lettera_finale = 'V';
			when risultato = 22 then lettera_finale = 'W';
			when risultato = 23 then lettera_finale = 'X';
			when risultato = 24 then lettera_finale = 'Y';
			when risultato = 25 then lettera_finale = 'Z';
	end case;
	
return CONCAT(stringa, lettera_finale);

end
$$
language plpgsql;

select carattereControllo('CCCLSS96D11A893');


--4g
ALTER TABLE public.persons
    ADD COLUMN codice_fiscale character varying(16);
	
	
	
--4h
create or replace procedure creaCodiceFiscale16()
language plpgsql
as $$
declare
	cur cursor for select * from persons;
	cf16 char(16);
begin

for i in cur loop
	update persons set codice_fiscale = carattereControllo(creacf15(i.last_name, i.first_name, i.sex, i.birth_place, i.data_di_nascita))
	where i.persons_id = persons_id;
end loop;

end$$;

call creaCodiceFiscale16();


