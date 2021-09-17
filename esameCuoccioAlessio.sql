CREATE TABLE iban(
	id		int,
	nazione		varchar(2),
	cin		varchar(3),	
	abi		varchar(5),
	cab 		varchar(5),
	cc		varchar(12),
	iban		varchar(27)
	);
	
INSERT INTO iban(id,nazione,cin,abi,cab,cc,iban)
	VALUES(1,'IT','60X','5533','1414','9999',null),
		(2,'IT','60X','5533','1515','99099',null),
		(3,'IT','60X','5533','1616','999099',null),
		(4,'IT','60X','5533','1717','90999',null);
		

CREATE OR REPLACE PROCEDURE creazioneIban()
LANGUAGE plpgsql
AS
$$
DECLARE
	cursore CURSOR FOR (SELECT * FROM iban);
	row record;
	result varchar;
BEGIN
	OPEN cursore;
		LOOP
		FETCH cursore INTO row;
		EXIT WHEN NOT FOUND;
			SELECT concat(row.nazione,row.cin,(lpad(row.abi,5,'0')),(lpad(row.cab,5,'0')),(lpad(row.cc,12,'0'))) 
				INTO result FROM iban;
			UPDATE iban SET iban = result 
			WHERE row.nazione = nazione
				AND row.cin = cin
				AND row.abi = abi
				AND row.cab = cab
				AND row.cc = cc;
		END LOOP;
	CLOSE cursore;
END;$$

call creazioneIban();

select * from iban;