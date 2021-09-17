/* REGISTA ( Nome, DataNascita, Nazionalità )
ATTORE ( Nome, DataNascita, Nazionalità )
INTERPRETA ( Attore, Film, Personaggio )
FILM ( Titolo, NomeRegista, Anno)
PROIEZIONE ( NomeCin, CittàCin, TitoloFilm )
CINEMA ( Città, NomeCinema, #Sale, #Posti ) */

DROP TABLE IF EXISTS regista;
CREATE TABLE regista(
	nomeRegista varchar(50),
	dataNascita date,
	nazionalita varchar(50)
);

DROP TABLE IF EXISTS film;
CREATE TABLE film(
	titoloFilm varchar(100),
	nomeRegista varchar(50),
	anno integer
);


DROP TABLE IF EXISTS attore;
CREATE TABLE attore(
	nomeAttore varchar(50),
	dataNascita date,
	nazionalita varchar(50)
);

DROP TABLE IF EXISTS interpreta;
CREATE TABLE interpreta(
	nomeAttore varchar(50),
	titoloFilm varchar(100),
	personaggio varchar(30)
);

DROP TABLE IF EXISTS cinema;
CREATE TABLE cinema(
	cittaCinema varchar(50),
	nomeCinema varchar(50),
	sale numeric,
	posti numeric
);

DROP TABLE IF EXISTS proiezione;
CREATE TABLE proiezione(
	nomeCinema varchar(50),
	cittaCinema varchar(50),
	titoloFilm varchar(100)
);



/* 1 Selezionare le Nazionalità dei registi che hanno diretto
qualche film nel 1992 ma non hanno diretto alcun film
nel 1993 */

	select regista.nazionalita
	from regista natural join film
	where film.anno = 1992 and not film.anno = 1993;


/* 2 Nomi dei registi che hanno diretto nel 1993 più film di quanti
ne avevano diretti nel 1992 */

	SELECT NomeRegista
	FROM FILM F
	WHERE Anno=1993
	GROUP BY NomeRegista
		HAVING count(*) >
		 ( SELECT count(*)
		 FROM FILM AS F1
		 WHERE F1.NomeRegista=F.NomeRegista
		 AND Anno=1992)
		 
		 
/* 3 Le date di nascita dei registi che hanno diretto
film in proiezione sia a Torino sia a Milano */

	select distinct NomeRegista, DataNascita
	from REGISTA natural join FILM
	where titoloFilm in ( SELECT titoloFilm
		 FROM PROIEZIONE
		 WHERE cittaCinema='Milano')
		 AND titoloFilm in ( SELECT TitoloFilm
		 FROM PROIEZIONE
		 WHERE cittaCinema='Torino')


/* 4 Film proiettati nel maggior numero di cinema di Milano */
	SELECT TitoloFilm, count(*) AS NumeroCinema
	FROM PROIEZIONE
	WHERE cittaCinema='Milano'
	GROUP BY TitoloFilm
	HAVING count(*) >= ALL
		 ( SELECT count(*)
		 FROM PROIEZIONE
		 WHERE cittaCinema='Milano'
		GROUP BY TitoloFilm)

/* 5 Trovare gli attori che hanno interpretato più
personaggi in uno stesso film */

select distinct P1.nomeAttore
from INTERPRETA P1 , INTERPRETA P2
where P1.nomeAttore = P2.nomeAttore
 and P1.titoloFilm = P2.titoloFilm
 and P1.Personaggio <> P2.Personaggio
 
/* 6 Trovare i film in cui recita un solo attore che
però interpreta più personaggi */

SELECT titoloFilm
 FROM INTERPRETA
 GROUP BY titoloFilm
 HAVING count(*) > 1
 AND count(distinct nomeAttore) = 1
 
-- 1) Attori italiani che non hanno mai recitato con altri italiani
SELECT nomeAttore
FROM attore a1
WHERE nazionalita = 'Italiana' AND a1.nomeAttore not in (
	SELECT i1.nomeAttore
	FROM interpreta i1, interpreta i2, attore a2
	WHERE i1.titoloFilm = i2.titoloFilm
	AND i2.nomeAttore = a2.nomeAttore
	AND a2.nomeAttore <> a1.nomeAttore
	AND a2.nazionalita = 'Italiana' )


-- 2) I film di registi italiani in cui non recita nessun italiano
select titoloFilm
from film natural join  regista
where nazionalita = 'Italiana' and titoloFilm NOT IN (
	select titoloFilm
	from interpreta natural join attore
	where nazionalita = 'Italiana' ) 


-- 3) Registi che hanno recitato in almeno un loro film
SELECT DISTINCT nomeRegista
FROM film natural join interpreta
WHERE nomeRegista = nomeAttore


-- 4) I registi che hanno recitato in almeno 4 loro film
--	interpretandovi un totale di almeno 5 personaggi diversi
select nomeRegista
from film natural join interpreta
where nomeRegista = nomeAttore
group by nomeRegista
having count( distinct titoloFilm ) >= 4 and
 count( distinct personaggio ) >= 5 