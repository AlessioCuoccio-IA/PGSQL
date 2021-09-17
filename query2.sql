CREATE TABLE persona(
	codFis varchar(16),
	nome varchar(30),
	dataNascita date,
	CFMadre varchar(16),
	CFPadre varchar(16));
	
CREATE TABLE matrimonio(
	codiceMatr serial,
	CFMoglie varchar(16),
	CFMarito varchar(16),
	data date,
	numeroInvitati numeric);
	
CREATE TABLE testimoni(
	codiceMatr serial,
	CFTestimone varchar(16));
	
--1) estrarre tutti i matrimoni del 2010

	SELECT	*	
	FROM	matrimonio	
	WHERE	data BETWEEN '1/1/2010'	AND	'31/12/2010';


--2) Estrarre i dati dei genitori delle persone che si sono sposate nel 2010

SELECT	p1.*
FROM	persona	p1,	persona	p2	
WHERE	(p1.codFis = p2.CFMadre	OR p1.codFis = p2.CFPadre)	AND (p2.CodFis IN
	(SELECT	CFMoglie
	FROM	matrimonio
	WHERE	data BETWEEN '1/1/2010'	AND '31/12/2010') 
OR	p2.CodFis	IN
	(SELECT	CFMarito
	FROM	matrimonio
	WHERE	data BETWEEN '1/1/2010'	AND '31/12/2010'))
	
	
--3) Coppie di persone sposate dopo la nascita di più di 3 [loro] figli.

SELECT	CFMoglie,CFMarito	
FROM	matrimonio m	
WHERE	(SELECT	COUNT(*)
		FROM	persona p
		WHERE	p.CFMadre = m.CFMoglie
		AND	p.CFPadre = m.CFMarito
		AND	p.DataNascita < m.Data) > 3	


--4) Matrimoni in cui entrambi i coniugi erano precedentemente sposati.

SELECT	*	
FROM	matrimonio m	
WHERE	CFMoglie IN
	(SELECT	CFMoglie
	FROM	matrimonio	m1
	WHERE	m1.CFMoglie = m.CFMoglie
		AND	m1. data < m.data)
AND	CFMarito IN
	(SELECT	CFMarito
	FROM	matrimonio	m2
	WHERE	m2.CFMarito = m.CFMarito
		AND	m2.data < m.data)
		
		
--5) Estrarre i nomi delle coppie di individui sposati che risultano entrambi figli di genitori sposati tra loro

SELECT p1.Nome, p2.Nome
FROM matrimonio m, persona p1, persona p2
WHERE m.CFMoglie = p1.CodFis AND m.CFMarito = P2.CodFis AND CFMoglie IN
	(SELECT CodFis
	FROM persona p, matrimonio m1
	WHERE m1.CFMoglie = p.CFMadre
	  AND m1.CFMarito = p.CFPadre)
AND CFMarito IN
	(SELECT CodFis
	FROM persona p, matrimonio m1
	WHERE m1.CFMoglie = p.CFMadre
	  AND m1.CFMarito = p.CFPadre)


--6) Estrarre le persone sposate figlie di persone non sposate tra loro

SELECT *
FROM persona p, matrimonio m
WHERE (p.CodFis = m.CFMoglie OR p.CodFis = m.CFMarito) AND
	(SELECT count(*)
	FROM matrimonio m1
	WHERE m1.CFMoglie = p.CFMadre AND m1.CFMarito = P.CFPadre)=0


--7) Estrarre i matrimoni che sono nel primo 20% per numero di invitati

SELECT *
FROM matrimonio m
WHERE (SELECT count(*)
FROM matrimonio m1
WHERE m1.numeroInvitati >= m.numeroInvitati) <= 0.2 * (SELECT count(*) FROM Matrimonio);
