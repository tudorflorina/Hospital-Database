CREATE TABLE Pacient (
     CNP CHAR(13) CONSTRAINT pk_pacient PRIMARY KEY,
     nume VARCHAR(25) CONSTRAINT nn_nume NOT NULL,
     prenume VARCHAR(25) NOT NULL,
     sex CHAR(2),
     data_nastere Date
);
CREATE TABLE Doctor (
     cod_doctor CHAR(13) CONSTRAINT pk_doctor PRIMARY KEY,
     nume_doctor VARCHAR(25) NOT NULL,
     data_angajare Date,
     specialitate VARCHAR(25),
     sectia VARCHAR(25)
 );
 CREATE TABLE Afectiune (
     cod_boala CHAR(10) CONSTRAINT pk_afectiune PRIMARY KEY,
     denumire_boala VARCHAR(25),
     cod_tratament CHAR(10)
);
CREATE TABLE Diagnostic (
     cod_diagnostic CHAR(10) CONSTRAINT pk_diagnostic PRIMARY KEY,
     cod_boala CHAR(10) CONSTRAINT fk_diagnostic_1 REFERENCES Afectiune(cod_boala),
     CNP CHAR(13) CONSTRAINT fk_diagnostic_2 REFERENCES Pacient(CNP),
     data Date,
     cod_doctor CHAR(13) CONSTRAINT fk_diagnostic_3 REFERENCES Doctor(cod_doctor)
 );
CREATE TABLE Tratament (
     cod_tratament CHAR(10) CONSTRAINT pk_tratament PRIMARY KEY,
     data_incepere Date NOT NULL,
     data_terminare Date NOT NULL,
     cod_diagnostic CHAR(10) CONSTRAINT fk_tratament REFERENCES Diagnostic(cod_diagnostic)
);
CREATE TABLE Internari (
     cod_internare CHAR(10) CONSTRAINT pk_internari PRIMARY KEY,
     data_internare Date NOT NULL,
     data_externare Date NOT NULL,
     cod_diagnostic CHAR(10) CONSTRAINT fk_internari REFERENCES Diagnostic(cod_diagnostic),
     salon char(5)
);
CREATE TABLE Alergie (
     cod_alergie CHAR(10) CONSTRAINT pk_alergie PRIMARY KEY,
     CNP CHAR(13) CONSTRAINT fk_alergie REFERENCES Pacient(CNP)
);

INSERT INTO Pacient(CNP, nume, prenume, sex, data_nastere) values ('5263485975214', 'Ionel', 'Marcel', 'm', to_date('21-09-1998', 'dd-mm-yyyy'));
INSERT INTO Pacient(CNP, nume, prenume, sex, data_nastere) values ('6854523847251', 'Ioana', 'Mihaela', 'f', to_date('22-08-1995', 'dd-mm-yyyy'));
INSERT INTO Pacient(CNP, nume, prenume, sex, data_nastere) values ('2658745123658', 'Maria', 'Mirela', 'f', to_date('28-08-1997', 'dd-mm-yyyy'));


INSERT INTO Doctor values ('258' , 'Mihailescu' , to_date('05-08-2015','dd-mm-yyyy'), 'neurolog', 'neurologie');
INSERT INTO Doctor values ('289' , 'Ionescu' , to_date('10-09-2014','dd-mm-yyyy'), 'chirurg', 'chirurgie');
INSERT INTO Doctor values ('301' , 'Tudor' , to_date('08-10-2016','dd-mm-yyyy'), 'cardiolog', 'cardiologie');


INSERT INTO Afectiune values ('25698', 'apendicita' , '24156');
INSERT INTO Afectiune values ('35689', 'tensiune' , '36857');
INSERT INTO Afectiune values ('45875', 'scleroza' , '59864');


INSERT INTO Diagnostic values ('2568' , '25698', '5263485975214' , to_date('20-12-2021', 'dd-mm-yyyy'), '289');
INSERT INTO Diagnostic values ('3587', '35689','6854523847251' ,to_date('21-12-2021', 'dd-mm-yyyy') , '301');
INSERT INTO Diagnostic values ('6895', '45875','2658745123658' , to_date('10-12-2021', 'dd-mm-yyyy') , '258');


INSERT INTO Tratament values ('14253' , to_date('20-12-2021', 'dd-mm-yyyy'), to_date('25-12-2021', 'dd-mm-yyyy'), '2568');
INSERT INTO Tratament values ('36251' , to_date('21-12-2021', 'dd-mm-yyyy'), to_date('30-12-2021', 'dd-mm-yyyy'), '3587');
INSERT INTO Tratament values ('74856' , to_date('10-12-2021', 'dd-mm-yyyy'), to_date('25-02-2022', 'dd-mm-yyyy'), '6895');


INSERT INTO Internari values ('25' , to_date('20-12-2021', 'dd-mm-yyyy'), to_date('30-12-2021', 'dd-mm-yyyy'),'2568','5');
INSERT INTO Internari values ('36' , to_date('21-12-2021', 'dd-mm-yyyy') , to_date('31-12-2021', 'dd-mm-yyyy'),'3587','10');
INSERT INTO Internari values ('28' , to_date('10-12-2021', 'dd-mm-yyyy'), to_date('15-03-2022', 'dd-mm-yyyy'),'6895', '13');


INSERT INTO Alergie values ('123' ,'5263485975214');
INSERT INTO Alergie values ('124' ,'6854523847251');
INSERT INTO Alergie values ('125' ,'2658745123658');


-- 5 operatii de actualizare
--1
--pacientilor cu numele mihaela sa li se schimbe numele cu cel al pacientilor al caror cnp se termina in 658
UPDATE Pacient
SET nume= (SELECT nume FROM Pacient WHERE CNP LIKE '%658')
WHERE prenume LIKE 'Mihaela';


--2
--sa se schimne deminerea bolii inastigmatism pacientilor care au codul tratamentului 59864
UPDATE Afectiune
SET denumire_boala='astigmatism'
WHERE cod_tratament LIKE '59864';


--3
--sa se schimbe numele pacientului in florina celor ce s-au nascut in 95
UPDATE Pacient 
SET nume = 'Florina'
WHERE data_nastere LIKE '%%95';

--4
--sa se schimbe numele pacientului in clementa, pacientului care are aceeasi data de nastere cu cea a pacientului maria
UPDATE Pacient 
SET nume= 'Clementa'
WHERE EXTRACT (YEAR FROM data_nastere) = (SELECT EXTRACT (YEAR FROM data_nastere) FROM Pacient  WHERE nume LIKE 'Maria');

--5
INSERT INTO Pacient(CNP, nume, prenume, sex, data_nastere) values ('1423647561', 'Andrei', 'Tudor', 'm', to_date('15-09-2009', 'dd-mm-yyyy'));


--5 interogari

--1
--sa se afiseze intr-un tabel numele, prenumele, data de nastere si codul diagnosticelor pacientilor
SELECT p.nume, p.prenume, p.data_nastere , d.cod_diagnostic
FROM Pacient p JOIN  Diagnostic d
ON p.CNP=d.CNP; 


--2
--sa se afiseze codul boii aferent fiecarui  cod_diagnostic
SELECT cnp,
CASE
    WHEN cod_diagnostic=2568 THEN 'cod_boala este 25698'
    WHEN cod_diagnostic=6895 THEN 'cod_boala este 35689'
    ELSE 'cod_boala este 45875'
END
FROM Diagnostic;

--3
--sa se afiseze intr-un tabel numele prenumele cnp-ul, sex-ul si denimirea bolii fiecarui pacient 
SELECT p.nume, p.prenume, p.CNP, p.sex, a.denumire_boala
FROM (Afectiune a JOIN Diagnostic d ON a.cod_boala=d.cod_boala) JOIN Pacient p on d.CNP=p.CNP;


--4
--sa se afiseze numarul pacientilor
SELECT COUNT(CNP) AS numar_pacienti
FROM Pacient;


--5
--sa se afiseze numele si prenumele pacientilor al caror cod_diagnostic incepe cu 2
SELECT nume, prenume
FROM Pacient p JOIN  Diagnostic d 
ON p.CNP=d.CNP
WHERE d.cod_diagnostic LIKE '2%%%';


--5 interogari a datelor utilizand subcereri

--1
--sa se afiseze numele prenumele si cnp ul pacientului care are data in care a fost pus diagnosticul 20-dec-21
SELECT nume,prenume, cnp
FROM Pacient 
WHERE cnp = (SELECT cnp
                FROM Diagnostic
                WHERE data = '20-dec-21');


--2
--sa se afiseze numele prenumele si cnp ul pacientului cu cod_tratament incepand cu 142
SELECT p.nume, p.prenume, p.cnp 
FROM Pacient p JOIN Diagnostic d
ON d.cod_diagnostic=(SELECT cod_diagnostic
                        FROM Tratament
                        WHERE cod_tratament LIKE '142%')
                    AND
                    p.cnp=d.cnp;


--3
--sa se afiseze numele prenumele si cnp ul pacientilor ce au doctorul cu specialitatea neurolog
SELECT p.nume, p.prenume, p.cnp, d.cod_doctor, dr.nume_doctor 
FROM Pacient p, Doctor dr, Diagnostic d
WHERE p.cnp=d.cnp AND dr.cod_doctor=(SELECT cod_doctor
                                    FROM Doctor 
                                    WHERE specialitate LIKE 'neurolog')
                  AND dr.cod_doctor=d.cod_doctor;


--4
--sa se scrie codul diagnosticului pacientului ce are cod_alergie=124
SELECT cod_diagnostic
FROM Alergie a, Pacient p, Diagnostic d
WHERE d.cnp=p.cnp AND p.cnp=(SELECT cnp
                             FROM Alergie 
                             WHERE cod_alergie=124)
                  AND p.cnp=a.cnp;


--5
--sa se afiseze data internarii pacientului ce sufera de scleroza si numele doctorului ce il trateaza
SELECT i.data_internare, dr.nume_doctor
FROM Internari i, Doctor dr, Pacient p, Diagnostic d, Afectiune a
WHERE p.cnp=d.cnp AND d.cod_boala= (SELECT cod_boala
                                    FROM Afectiune
                                    WHERE denumire_boala LIKE 'scleroza')
                 AND d.cod_boala=a.cod_boala
                 AND d.cod_doctor=dr.cod_doctor
                 AND d.cod_diagnostic=i.cod_diagnostic;


--3 operatii creare tabele virtuale

--1
--sa se creeze o tabela virtuala prin care sa se afiseze pacientii ce au medic al carui nume incepe cu litera T
CREATE VIEW v_pacienti_doctor_t
AS SELECT nume, prenume
   FROM Pacient p, Diagnostic d, Doctor dr
   WHERE p.cnp=d.cnp AND d.cod_doctor=(SELECT cod_doctor
                                       FROM Doctor
                                       WHERE nume_doctor LIKE 'M%')
                     AND d.cod_doctor=dr.cod_doctor;


--2
--sa se creeze o tabela virtuala in care sa se afiseze pacientii ce au fost internati in luna decembrie indiferent de an
CREATE VIEW v_pacienti_internati_dec
AS SELECT p.nume, p.prenume, p.cnp
   FROM Pacient p, Diagnostic d , Internari i
   WHERE p.cnp=d.cnp AND d.cod_diagnostic IN (SELECT cod_diagnostic 
                                           FROM Internari
                                           WHERE data_internare LIKE '%-DEC-%')
                     AND d.cod_diagnostic=i.cod_diagnostic;


--3
--sa se creeze o tabela virtuala in care sa se afiseze codul tratamentului pacientului ce are cod_alergie=125 si sa se afiseze si data externarii acestuia 

CREATE VIEW v_pacienti_tratament_alergie
AS SELECT t.cod_tratament, i.data_internare
   FROM Pacient p, Diagnostic d, Tratament t, Alergie a, Internari i
   WHERE p.cnp=(SELECT cnp
                FROM Alergie
                WHERE cod_alergie=125)
         AND 
         p.cnp=d.cnp
         AND 
         a.cnp=d.cnp
         AND
         d.cod_diagnostic=t.cod_diagnostic
         AND 
         d.cod_diagnostic=i.cod_diagnostic
         AND
         i.cod_diagnostic=t.cod_diagnostic;


--2 operatii cu tabelele virtuale

--1 
--sa se afiseze numele pacientului care arre cnp ul de forma 52% folosindu se tabela v_pacienti_internati_dec
SELECT nume
FROM v_pacienti_internati_dec
WHERE cnp LIKE '52%';


--2
--cu ajutorul tabelei virtuale v_pacienti_tratament_alergie sa se afiseze data de internare a pacientului ce are codul tratamentului 74856
SELECT data_internare
FROM v_pacienti_tratament_alergie 
WHERE cod_tratament=74856;

