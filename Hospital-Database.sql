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

--SGBD PROJECT

--PL/SQL
--Structuri de control
--Cursori impliciti
--Cursori expliciti


--Structuri de control
--1 Pentru codul de boala introdus de la tastatura sa se afiseze denumirea bolii corespondenta lui conform urmatoarei scheme


--apendicita-->scolioza
--tensiune-->laringita
--daca nu este nici tensiune nici apendicita se va afisa in febra
DECLARE 
v_denumire_boala afectiune.denumire_boala%TYPE;
v_cod_boala afectiune.cod_boala%TYPE;
BEGIN 
SELECT denumire_boala, cod_boala INTO v_denumire_boala, v_cod_boala
FROM afectiune
WHERE cod_boala = '&a';
IF v_denumire_boala = 'apendicita'
THEN v_denumire_boala := 'scolioza';
ELSIF v_denumire_boala = 'tensiune'
THEN v_denumire_boala :='laringita';
ELSE v_denumire_boala := 'febra';
END IF;
DBMS_OUTPUT.PUT_LINE('Noua denumire a bolii pacientului cu codul  ' || v_cod_boala || 'este  ' || v_denumire_boala);
END;
/



--2 Sa se adauge un anumit numar de zile la data de terminare a tratamentului in functie de denumirea_bolii unui pacient introdusa de ka tastatura dupa schema urmatoare
--daca sufera de apendicita se adauga 5 zile
--daca sufera de tensiune se adauga 3 zile
--daca sufera de scleroza se adauga 10 zile
--**doar se afiseaza rezultatul marit cu numarul respectiv de zile nu se modifica


DECLARE
v_data_terminare tratament.data_terminare%TYPE;
v_denumire_boli afectiune.denumire_boala%TYPE;
BEGIN
SELECT t.data_terminare, a.denumire_boala INTO v_data_terminare, v_denumire_boli
FROM tratament t JOIN afectiune a
ON a.cod_tratament = t.cod_tratament
WHERE  a.denumire_boala = '&a';
IF v_denumire_boli = 'apendicita'
THEN v_data_terminare := v_data_terminare + 5;
ELSIF v_denumire_boli = 'tensiune'
THEN v_data_terminare := v_data_terminare + 3;
ELSE v_data_terminare := v_data_terminare + 10;
END IF;
DBMS_OUTPUT.PUT_LINE('Noua data de terminare a tratamentului pentru boala ' || v_denumire_boli || 'este  ' || v_data_terminare);
END;
/


--Cursor explicit
--3 Utilizati un cursor parametrizat pentru a prelua numele, codul si vechimea medicilor al caror cod este adaugat de la tastatura


DECLARE 
    CURSOR c(p_cod_doctor doctor.cod_doctor%TYPE) IS
            SELECT nume_doctor, cod_doctor, ROUND((SYSDATE-data_angajare)/365) vechime
            FROM doctor
            WHERE cod_doctor = p_cod_doctor;
    

r c%ROWTYPE;
    v_cod_doctor doctor.cod_doctor%TYPE :=&a;
BEGIN 
    OPEN c (v_cod_doctor);
    LOOP
        FETCH c INTO r;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(r.nume_doctor || r.cod_doctor || r.vechime);
    END LOOP;
    CLOSE c;

END;
/


--4   Sa se afiseze toti pacientii spitalului si doctorii lor


DECLARE
CURSOR c IS
    SELECT p.nume, p.prenume, p.sex, p.data_nastere, p.cnp
    FROM pacient p, diagnostic d
    WHERE p.cnp = d.cnp;
r c%ROWTYPE;
v_nume_doctor doctor.nume_doctor%TYPE;
BEGIN
    OPEN c;
        LOOP
            FETCH c INTO r;
            EXIT WHEN c%NOTFOUND;
            SELECT dr.nume_doctor INTO v_nume_doctor
            FROM doctor dr, pacient p, diagnostic d
            WHERE p.cnp=d.cnp AND
                  d.cod_doctor = dr.cod_doctor AND
                  r.cnp=d.cnp;
            DBMS_OUTPUT.PUT_LINE(r.nume ||' '|| r.prenume ||' '|| r.sex ||' '|| r.data_nastere ||' '|| 'are doctorul' ||' '|| v_nume_doctor);
        END LOOP;
    CLOSE c;
END;
/


--5 Utilizati un cursor prin care sa se afiseze primii 2 pacienti internati in spital

DECLARE 
CURSOR c IS
SELECT COUNT(d.cnp) , p.nume, p.prenume

FROM pacient p , diagnostic d
WHERE p.cnp = d.cnp
GROUP BY d.cnp, p.nume, p.prenume
ORDER BY COUNT(d.cnp) desc;
r c%ROWTYPE;
BEGIN
OPEN c;
LOOP
FETCH c INTO r;

EXIT WHEN c%ROWCOUNT>2;
DBMS_OUTPUT.PUT_LINE(r.nume || ' ' || r.prenume);
END LOOP;
CLOSE c;
END;
/



--Cursor implicit
--6 Pentru pacientii de sex feminin sa se adauge 2 zile la data de nastere



DECLARE

BEGIN
UPDATE pacient
SET data_nastere =data_nastere+2
WHERE sex = 'f';

IF SQL%NOTFOUND THEN 
    DBMS_OUTPUT.PUT_LINE('Nu exista pacienti de sex feminin');
ELSE
    DBMS_OUTPUT.PUT_LINE('S-a modificat data de nastere pentru'|| SQL%ROWCOUNT || ' pacienti');
END IF;

COMMIT;
END;
/


--7 Pentru doctorii ce au codul mai mic de 290 sa se adauge o luna de vechime
DECLARE

BEGIN
UPDATE doctor
SET data_angajare = data_angajare + 30
WHERE cod_doctor < 290;

IF SQL%NOTFOUND THEN 
    DBMS_OUTPUT.PUT_LINE('Nu exista doctori ce au codul mai mic de 290');
ELSE
    DBMS_OUTPUT.PUT_LINE('S-a modificat data de angajare pentru' || SQL%ROWCOUNT || 'doctori');
END IF;

COMMIT;

END;
/


--8 Sa se modifice cnp-ul pacientului cu numele Andrei

BEGIN
UPDATE Pacient
SET cnp = '123456789012'
where nume = 'Andrei';
IF SQL%NOTFOUND THEN
DBMS_OUTPUT.PUT_LINE ('Nu exista acest pacient');
END IF;

END;


--Exceptii explicite

--1 Într-un bloc PL/SQL utilizați un cursor parametrizat pentru a prelua numele, varsta pacientilor ce au un anumit sex m/f/n
--
--deschideți cursorul prin indicarea ca parametru a unei variabile de substituție, a cărei valoare să fie citită de la tastatură;
--parcurgeți cursorul și afișați informațiile solicitate pentru acei pacienti care au sexul precizat;
--afișați numărul total de pacienti parcurși;
--în cazul în care nu există sexul indicat, se va invoca o excepție, care se va trata corespunzător;
--în cazul în care nu există pacienti cu acel sex, se va invoca o excepție, care se va trata corespunzător.

DECLARE
  CURSOR c (p_sex pacient.sex%TYPE) IS 
              SELECT nume, prenume,  ROUND((SYSDATE-data_nastere)/365) varsta
              FROM pacient
              WHERE sex = p_sex;
  r c%ROWTYPE;
  v_sex pacient.sex%TYPE := '&a';
  nu_exista_pacient EXCEPTION;
  sexul_nu_exista EXCEPTION;
BEGIN
  OPEN c (v_sex);
  LOOP
    FETCH c INTO r;
    EXIT WHEN c%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(r.nume||' ' ||r.prenume||' ' || r.varsta);
  END LOOP;
  
  IF c%ROWCOUNT=0 AND (v_sex = 'm' OR v_sex = 'f' OR v_sex = 'n') THEN 
    RAISE nu_exista_pacient;
  END IF;
  
  IF v_sex != 'm' AND v_sex != 'f' AND v_sex != 'n' THEN
    RAISE sexul_nu_exista;
  END IF;
  
  CLOSE c;
EXCEPTION
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Nu exista sexul');
  
WHEN nu_exista_pacient THEN DBMS_OUTPUT.PUT_LINE('Exista sexul, dar niciun pacient nu il are');
  WHEN sexul_nu_exista THEN DBMS_OUTPUT.PUT_LINE('Sexul introdus de la tastatura nu exista');
END;
/


--2. Într-un bloc PL/SQL citiți de la tastatură identificatorul unei boli. Afișați denumirea bolii care are acel cod.
--

--afișați denumirea bolii;  apendicita/tensiune/scolioza/scleroza
--dacă boala nu există, tratați excepția cu o rutină de tratare corespunzătoare;
--daca boala exista, dar niciun pacient nu o are, tratati exceptia
--tratați orice altă excepție cu o rutină de tratare corespunzătoare.

DECLARE
  CURSOR c(p_cod_boala afectiune.cod_boala%TYPE) IS
      SELECT denumire_boala
      FROM afectiune
      WHERE cod_boala = p_cod_boala;
  r c%ROWTYPE;
  v_denumire_boala afectiune.denumire_boala%TYPE;
  v_cod afectiune.cod_boala%TYPE := &a;
  boala_nu_exista EXCEPTION;
  boala_nu_este_inregistrata EXCEPTION;
BEGIN  
  SELECT denumire_boala INTO v_denumire_boala
  FROM afectiune
  WHERE cod_boala = v_cod;

  OPEN c(v_cod);
  LOOP
    FETCH c INTO r;
    EXIT WHEN c%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Boala: '|| v_denumire_boala );
  END LOOP;
  


  IF c%ROWCOUNT=0 AND (v_denumire_boala = 'apendicita' OR v_denumire_boala = 'scleroza' OR v_denumire_boala = 'tensiune' OR v_denumire_boala = 'scolioza') THEN
    RAISE boala_nu_este_inregistrata;
  END IF;
    
    
  IF v_denumire_boala != 'apendicita' AND v_denumire_boala != 'scleroza' AND v_denumire_boala != 'tensiune' AND v_denumire_boala != 'scolioza' THEN 
    RAISE boala_nu_exista;
  END IF;
  
  CLOSE c;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Nu exista boala');
  WHEN boala_nu_exista THEN DBMS_OUTPUT.PUT_LINE('Boala nu exista');
  WHEN boala_nu_este_inregistrata THEN DBMS_OUTPUT.PUT_LINE('Boala exista dar niciun pacient nu o are');
END;
/


--Exceptii implicite


--1 Sa se modifice data de angajare cu o zi in plus a doctorului al carui cod este introdus de la tastatura 
DECLARE
  nu_exista_doctor EXCEPTION;
BEGIN 
  UPDATE doctor
  SET data_angajare = data_angajare +1
  WHERE cod_doctor = &a;
  IF SQL%NOTFOUND THEN 
    RAISE nu_exista_doctor;
  END IF;
EXCEPTION
  WHEN nu_exista_doctor THEN DBMS_OUTPUT.PUT_LINE('Nu exista doctor ce are codul introdus de dumneavoastra');
END;
/


--2 Sa se modifice data de terminare a tratamentului al carui cod este introdus de la tastatura cu  zile

DECLARE
  nu_exista_tratament EXCEPTION;
BEGIN 
  UPDATE tratament
  SET data_terminare = data_terminare +5
 

 WHERE cod_tratament = &a;
  IF SQL%ROWCOUNT=0 THEN 
    RAISE nu_exista_tratament;
  END IF;
EXCEPTION
  WHEN nu_exista_tratament THEN DBMS_OUTPUT.PUT_LINE('Nu exista tratament ce are codul introdus de dumneavoastra');
END;
/


--Proceduri  /   Functii   /    Pachete

--3 proceduri

--1)Construiti procedura Termen_tratament care sa calculeze si sa afiseze durata fiecarui tratament într-un an indicat ca parametru de intrare. Apelati procedura.
CREATE OR REPLACE PROCEDURE Termen_tratament(p_an IN NUMBER)
AS
    CURSOR c(p_an NUMBER) IS
        SELECT data_terminare-data_incepere durata
        FROM tratament
        WHERE EXTRACT(YEAR FROM data_terminare)=p_an;
    r c%ROWTYPE;
    anul_nu_exista EXCEPTION;
BEGIN 
    OPEN c (p_an);
  LOOP
    FETCH c INTO r;
    EXIT WHEN c%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(r.durata);
    END LOOP;
    
    IF c%rowcount = 0 THEN 
    RAISE anul_nu_exista;
    END IF;
    
    CLOSE C;
EXCEPTION
    

WHEN anul_nu_exista THEN DBMS_OUTPUT.PUT_LINE('Nu s-au realizat tratamente in acel an!');    
END;
/

EXECUTE Termen_tratament(2021);



--2)Sa se creeze o procedura prin care sa se modifice numele pacientului dat ca parametru si sa se insereze un nou pacient ale carui date sunt introduse de la tastatura

CREATE OR REPLACE PROCEDURE set_pacient(p_nume IN pacient.nume%TYPE)
AS
    v_cnp pacient.cnp%TYPE:= &a;
    v_nume pacient.nume%TYPE:='&b';
    v_prenume pacient.prenume%TYPE:='&c';
    v_sex pacient.sex%TYPE:='&d';
    v_data_nastere pacient.data_nastere%TYPE:='&e';
    v_nume_nou pacient.nume%TYPE:='&f';
    nu_exista EXCEPTION;
BEGIN
    INSERT INTO Pacient(CNP, nume, prenume, sex, data_nastere) values (v_cnp, v_nume, v_prenume, v_sex, v_data_nastere);

    UPDATE pacient
    SET nume= v_nume_nou
    WHERE nume=p_nume;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE nu_exista;
    ELSE
        DBMS_OUTPUT.PUT_LINE('ok');
    END IF;
EXCEPTION
    WHEN nu_exista THEN DBMS_OUTPUT.PUT_LINE('Nu exista pacientul cu acest nume');


END;
/

EXECUTE set_pacient('Ionel');



--3)Apelati functia Calcul_varsta în cadrul unei proceduri, Varsta_pacienti, prin care se vor parcurge toti pacientii, în scopul afisarii varstei fiecaruia.

CREATE OR REPLACE PROCEDURE Varsta_pacienti
AS
    CURSOR c IS SELECT CONCAT(CONCAT(nume,' '), prenume) nume, Calcul_varsta(nume) varsta FROM pacient;
    r c%ROWTYPE;
    atentie EXCEPTION;
BEGIN
    OPEN c;
  LOOP
    FETCH c INTO r;
    EXIT WHEN c%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(r.nume || ',' || r.varsta);
  END LOOP;
  
  IF c%ROWCOUNT=0 THEN
    RAISE atentie;
  END IF;
  
  CLOSE c;
  
  EXCEPTION
  WHEN atentie THEN DBMS_OUTPUT.PUT_LINE('Nu exista pacienti internati');
END;
/



EXECUTE Varsta_pacienti;



--3 functii

--1)Construiti functia Calcul_varsta care sa returneze varsta pacientului al carui cod este dat ca parametru de intrare. Tratati cazul în care angajatul indicat nu exista.


CREATE OR REPLACE FUNCTION Calcul_varsta(p_nume IN pacient.nume%TYPE)
RETURN number
AS
    v_varsta number;
BEGIN
    SELECT ROUND((SYSDATE-data_nastere)/365) INTO v_varsta
    FROM pacient
    WHERE nume = p_nume;
    
    RETURN v_varsta;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;

END;
/

DECLARE 
    v_varsta number;
BEGIN
    v_varsta:=Calcul_varsta('Maria');
    IF v_varsta IS NULL THEN 
        
DBMS_OUTPUT.PUT_LINE('Nu exista pacientul');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_varsta);
    END IF;
END;
/


--2)Sa se afiseze durata de cand este angajat un anumit doctor, al carui cod este dat de la tastatura

CREATE OR REPLACE FUNCTION Calcul_vechime_munca(p_cod_doctor IN doctor.cod_doctor%TYPE)
RETURN number
AS
    v_vechime_doctor number;
BEGIN
    SELECT ROUND((SYSDATE-data_angajare)/365) INTO v_vechime_doctor
    FROM doctor
    WHERE cod_doctor = p_cod_doctor;
    
    RETURN v_vechime_doctor;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;

END;
/

DECLARE 
    v_vechime_doctor number;
BEGIN
    v_vechime_doctor:=Calcul_vechime_munca(258);
    IF v_vechime_doctor IS NULL THEN 
        DBMS_OUTPUT.PUT_LINE('Nu exista doctor ce are codul introdus de dumneavoastra');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_vechime_doctor);
    END IF;
END;

/


--3)Sa se afiseze salonul in care se afla pacientul al carui nume este introdus de la tastatura
CREATE OR REPLACE FUNCTION get_salon(p_nume IN pacient.nume%TYPE)
RETURN NUMBER
AS
    v_salon NUMBER;
BEGIN
    SELECT i.salon INTO v_salon
    FROM internari i,diagnostic d, pacient p
    WHERE i.cod_diagnostic=d.cod_diagnostic
          AND
          p.cnp=d.cnp
          AND
          p.nume=p_nume;
    RETURN v_salon;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
    
END;
/

DECLARE 
    v_salon number;
BEGIN
    v_salon:=get_salon('Costache');
    IF v_salon IS NULL THEN 
        DBMS_OUTPUT.PUT_LINE('Nu exista pacient internat cu numele specificat de dumneavoastra');
    ELSE
       
 DBMS_OUTPUT.PUT_LINE(v_salon);
    END IF;
END;
/
    

--2 Pachete
--pachetul 1

--Sa se creeze un pachet care sa contina:
--    -o procedura care sa afiseze numar de pacienti internati intr-un anumit an dat ca parametru
--    -o proceudra prin care pentru un anumit pacient sa se afiseze durata tratamentului pe care il are
--    -sa se trateze exceptiile posibile
SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE pachet1 AS
PROCEDURE get_nr_pacienti(p_nr number);
PROCEDURE get_zile_tratament(p_id IN pacient.cnp%TYPE);
END;

CREATE OR REPLACE PACKAGE BODY pachet1 AS
PROCEDURE get_nr_pacienti(p_nr number)
AS
v_nr_pacienti NUMBER;
BEGIN
SELECT COUNT(p.cnp) INTO v_nr_pacienti
FROM pacient p, tratament t, diagnostic d
WHERE EXTRACT(YEAR FROM t.data_terminare) = p_nr
      AND
      p.cnp = d.cnp
      AND
      d.cod_diagnostic = t.cod_diagnostic;
DBMS_OUTPUT.PUT_LINE('In anul ales s-au internat'||v_nr_pacienti||'pacienti');
EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Nu s-au gasit date');
END;

PROCEDURE get_zile_tratament(p_id IN pacient.cnp%TYPE)
IS
v_zile NUMBER;

BEGIN
SELECT (t.data_terminare-t.data_incepere) INTO v_zile
FROM tratament t, diagnostic d, pacient p
WHERE p.cnp=p_id
      AND
      p.cnp = d.cnp
      AND
      d.cod_diagnostic = t.cod_diagnostic;
DBMS_OUTPUT.PUT_LINE(v_zile);
EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Nu exista pacientul');
END;

END pachet1;
/

BEGIN
pachet1.get_nr_pacienti(2021);
END;

BEGIN 
pachet1.get_zile_tratament(5263485975214);
END;



--pachetul 2
--Sa se creeze un pachet care sa contina"
--   -o functie care sa returneze cati pacienti au o anumita afectiune, aceasta fiind identificata dupa codul sau
--   -o procedura care sa returneze numele pacientului ce este prealuat de doctorul al carui cod este introdus de la tastatura
--   -sa se trateze exceptiile!

SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE pachet2 AS
FUNCTION get_nr_pacienti_afectiune(p_cod IN afectiune.cod_boala%TYPE) RETURN number;
PROCEDURE get_nume_pacient(p_cod_doctor IN doctor.cod_doctor%TYPE);
END;
/
CREATE OR REPLACE PACKAGE BODY pachet2 AS

FUNCTION get_nr_pacienti_afectiune(p_cod IN afectiune.cod_boala%TYPE)
RETURN number
AS
    v_nr_pacienti number;
BEGIN
    SELECT COUNT(p.cnp) INTO v_nr_pacienti
    FROM pacient p, diagnostic d, afectiune a
    WHERE a.cod_boala = p_cod
          AND
          p.cnp = d.cnp
          AND
          a.cod_boala = d.cod_boala;
    
    RETURN v_nr_pacienti;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;

END;

PROCEDURE get_nume_pacient(p_cod_doctor IN doctor.cod_doctor%TYPE)
AS
v_nume_pacient VARCHAR2(40);
BEGIN
SELECT CONCAT(CONCAT(p.nume, ' '),p.prenume)  INTO v_nume_pacient
FROM pacient p, doctor dr, diagnostic d
WHERE dr.cod_doctor = p_cod_doctor
      AND
      p.cnp = d.cnp
      AND
      d.cod_doctor = dr.cod_doctor;
DBMS_OUTPUT.PUT_LINE('Numele pacientului este'||v_nume_pacient);
EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Nu s-a gasit pacientul');
END;


END pachet2;
/

DECLARE
   
RESULT number;

BEGIN
   RESULT := pachet2.get_nr_pacienti_afectiune (25698);
   DBMS_OUTPUT.PUT_LINE(RESULT);
END;

BEGIN 
pachet2.get_nume_pacient(258);
END;


-3 declansatori

--1) Sa se realizeze un declansator care sa nu permita ca ziua de incepere a tratamentului sa fie mai mare decat ziua de terminare a tratamentului
CREATE OR REPLACE TRIGGER diferenta_date
BEFORE UPDATE OR INSERT ON Tratament
FOR EACH ROW
WHEN (NEW.data_incepere>NEW.data_terminare)
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid!');
END;

INSERT INTO Tratament values ('14283' , to_date('20-12-2023', 'dd-mm-yyyy'), to_date('25-12-2021', 'dd-mm-yyyy'), '2568');



--2) Sa se creeze un declansator care sa nu permita introducerea unui cnp cu o lungime diferita de 13 cifre

CREATE OR REPLACE TRIGGER nr_cnp
BEFORE INSERT OR UPDATE OF cnp ON pacient
FOR EACH ROW
BEGIN
    IF ( LENGTH(:new.cnp) != 4) THEN
        RAISE_APPLICATION_ERROR(-20000,'CNP invalid!');
    END IF;
END;


INSERT INTO Pacient(CNP, nume, prenume, sex, data_nastere) values ('5263485975', 'Ionel', 'Marcel', 'm', to_date('21-09-1998', 'dd-mm-yyyy'));


--3)  Sa se creeze un declansator care sa nu permita inserarea unei date de incepere a tratamentului mai mare decat ziua curenta

CREATE OR REPLACE TRIGGER zi_incepere
BEFORE INSERT OR UPDATE OF data_incepere ON tratament
FOR EACH ROW
BEGIN
IF :new.data_incepere > SYSDATE
THEN  raise_application_error(-20003,'Data intordusa invalida!');
END IF;
END;


/


INSERT INTO Tratament values ('74856' , to_date('10-12-2023', 'dd-mm-yyyy'), to_date('25-02-2024', 'dd-mm-yyyy'), '6895');
