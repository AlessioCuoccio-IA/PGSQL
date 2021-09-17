CREATE TABLE public.autoveicoli (
	targa varchar(7) PRIMARY KEY,
	marca varchar(30),
	modello varchar(30),
	classe char(1) CHECK (classe = 'A' OR classe = 'B' OR classe = 'C')
);

INSERT INTO public.autoveicoli VALUES
	('targa01', 'Fiat', 'Panda', 'A'),
	('targa02', 'Jeep', 'Renegade', 'B'),
	('targa03', 'BMW', 'Serie 5', 'C');
	
INSERT INTO public.autoveicoli VALUES
	('targa04', 'Mercedes', 'Classe A', 'A');
	
CREATE TABLE public.optional (
	nome varchar PRIMARY KEY
);

INSERT INTO public.optional VALUES
	('aria condizionata'),
	('cerchi in lega'),
	('tettuccio');
	
CREATE TABLE public.possiede (
	targa varchar(7) REFERENCES autoveicoli(targa),
	nome varchar REFERENCES optional(nome),
	PRIMARY KEY (targa, nome)
); 

INSERT INTO public.possiede VALUES 
	('targa01', 'aria condizionata'),
	('targa02', 'aria condizionata'),
	('targa02', 'cerchi in lega'),
	('targa03', 'aria condizionata'),
	('targa03', 'tettuccio');
	
	
CREATE TABLE public.cliente (
	cf varchar(16) PRIMARY KEY,
	nome varchar(30),
	cognome varchar(30),
	dataNascita date
);

INSERT INTO public.cliente VALUES
	('codicefiscale001', 'nome1', 'cognome1', '05/03/1973'),
	('codicefiscale002', 'nome2', 'cognome2', '10/08/1994'),
	('codicefiscale003', 'nome3', 'cognome3', '25/11/1990');
	
CREATE TABLE public.prenotazioni
(
    codNoleggio serial PRIMARY KEY,
	tipoNoleggio char(1) CHECK (tipoNoleggio = 'D' OR tipoNoleggio = 'T'),
    targa character varying(7),
    cf character varying(16),
    inizioPrevistoNoleggio date,
    finePrevistoNoleggio date,
    inizioEffettivoNoleggio date,
    fineEffettivoNoleggio date,
	FOREIGN KEY(targa) REFERENCES autoveicoli(targa),
	FOREIGN KEY(cf) REFERENCES cliente(cf)
);

INSERT INTO public.prenotazioni (targa, tipoNoleggio, cf, inizioPrevistoNoleggio, finePrevistoNoleggio, inizioEffettivoNoleggio, fineEffettivoNoleggio) VALUES
	('targa01', 'D', 'codicefiscale001', '30/08/2021', '05/09/2021', '30/08/2021', '06/09/2021');
	
INSERT INTO public.prenotazioni (targa, tipoNoleggio, cf, inizioPrevistoNoleggio, finePrevistoNoleggio, inizioEffettivoNoleggio) VALUES	
	('targa02', 'D', 'codicefiscale002', '06/09/2021', '08/09/2021', '06/09/2021');
	
INSERT INTO public.prenotazioni (targa, tipoNoleggio, cf, inizioPrevistoNoleggio, finePrevistoNoleggio) VALUES	
	('targa03', 'D', 'codicefiscale003', '10/09/2021', '15/09/2021');
	
-- VERIFICARE SE UNA DETERMINATA AUTO E' DISPONIBILE IN BASE ALLE CARATTERISTICHE DEL CLIENTE
-- TRAMITE FUNZIONE

create or replace function verificaDisponibilita(v_classe char(1), dataInizio date, dataFine date, v_optional varchar[])
   returns table (r_targa varchar(7), r_marca varchar, r_modello varchar, r_classe char, r_optional varchar)
   language plpgsql
  as
$$
declare 


begin
return query 
	select *
	
		from  autoveicoli natural join possiede
		where autoveicoli.classe = 'B'
			AND (possiede.nome = v_optional[1]
				 OR possiede.nome = v_optional[2])
			AND NOT EXISTS (SELECT targa from prenotazioni WHERE dataInizio BETWEEN inizioPrevistoNoleggio AND finePrevistoNoleggio
				   												OR dataFine BETWEEN inizioPrevistoNoleggio AND finePrevistoNoleggio);
		
		
end;
$$

select verificaDisponibilita('A', '01/03/2021', '10/03/2021', '{"aria condizionata", "cerchi in lega"}');



CREATE OR REPLACE FUNCTION verificaRitardo()
RETURNS TABLE (r_targa varchar(7), r_cf varchar(16))
language plpgsql
  as
$$
declare 

begin
return query 
	select targa, cf
	from prenotazioni
	where fineEffettivoNoleggio is null		
		AND (finePrevistoNoleggio + 7) >= CURRENT_DATE
		AND inizioEffettivoNoleggio IS NOT null;
end;
$$

select verificaRitardo();

