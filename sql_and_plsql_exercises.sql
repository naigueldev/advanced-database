CREATE TABLE Professor(
codigo int PRIMARY KEY,
nome varchar(50),
titulacao varchar(80));

CREATE TABLE Disciplina (
id int PRIMARY KEY,
nome varchar(50),
nhoras numeric(6,2)
);

CREATE TABLE Turma (
codigo int PRIMARY KEY,
nivel int,
id int,
FOREIGN KEY(id) REFERENCES Disciplina (id)
);

CREATE TABLE Aluno (
matricula int PRIMARY KEY,
nome varchar(50),
sexo varchar(1),
codigo int,
FOREIGN KEY(codigo) REFERENCES Turma (codigo)
);

CREATE TABLE ministra (
codigo int,
id int,
semestre varchar(3),
FOREIGN KEY(codigo) REFERENCES Professor (codigo),
FOREIGN KEY(id) REFERENCES Disciplina (id),
PRIMARY KEY(codigo,id)
);


  ALTER TABLE Turma ALTER COLUMN nivel TYPE varchar(3); 
  ALTER TABLE Ministra ALTER COLUMN semestre TYPE varchar(6);

----------- DADOS ---------------------

insert into professor(codigo, nome, titulacao)values(50,'Doroteia','Especialista');
insert into professor(codigo, nome, titulacao)values(51,'Maysa','Mestre');
insert into professor(codigo, nome, titulacao)values(52,'Procopio','Doutor');
insert into professor(codigo, nome, titulacao)values(53,'Wilma','Mestre');

insert into disciplina(id, nome, nhoras)values(1, 'Banco de Dados II', 60);
insert into disciplina(id, nome, nhoras)values(2, 'Programação OO', 60);
insert into disciplina(id, nome, nhoras)values(3, 'Projeto de Banco de Dados', 60);
insert into disciplina(id, nome, nhoras)values(4, 'Projeto de Dados', 30);

insert into turma(codigo, nivel,id)values(20, 'I',2);
insert into turma(codigo, nivel,id)values(21, 'II',1);
insert into turma(codigo, nivel,id)values(22, 'III',1);
insert into turma(codigo, nivel,id)values(23, 'IV',3);
insert into turma(codigo, nivel,id)values(24, 'I',1);

insert into aluno(matricula, nome, sexo,codigo)values(10, 'Bety', 'F', 20);
insert into aluno(matricula, nome, sexo,codigo)values(11, 'Getulio', 'M',22);
insert into aluno(matricula, nome, sexo,codigo)values(12, 'Analis', 'F',22);
insert into aluno(matricula, nome, sexo,codigo)values(13, 'Terezinha', 'F',21);
insert into aluno(matricula, nome, sexo,codigo)values(14, 'Teodoro', 'M',23);

insert into ministra(codigo, id, semestre)values(53, 3, '2017/1');
insert into ministra(codigo, id, semestre)values(51, 1, '2018/1');
insert into ministra(codigo, id, semestre)values(52, 1, '2017/2');
insert into ministra(codigo, id, semestre)values(53, 2, '2018/1');
insert into ministra(codigo, id, semestre)values(51, 3, '2018/1');
insert into ministra(codigo, id, semestre)values(52, 2, '2017/2');
insert into ministra(codigo, id, semestre)values(51, 4, '2018/1');


1 - Quantos alunos estão matriculados na turma do nível "III"
SELECT aluno.matricula, aluno.nome
FROM aluno INNER JOIN turma ON
turma.codigo = aluno.codigo
INNER JOIN disciplina ON
disciplina.id = turma.id
WHERE disciplina.nome = 'Banco de Dados II'
  
2- Nome e a matrícula dos alunos que estão fazendo a disciplina de Banco de Dados II

SELECT aluno.matricula, aluno.nome
FROM aluno INNER JOIN turma ON
turma.codigo = aluno.codigo
INNER JOIN disciplina ON
disciplina.id = turma.id
WHERE disciplina.nome = 'Banco de Dados II'

3 - Listar os professores (nome e titulacao) da disciplina de Banco De Dados II
SELECT p.nome, p.titulacao 
FROM professor p
INNER JOIN ministra m ON p.codigo = m.codigo 
INNER JOIN disciplina d ON d.id = m.id
WHERE UPPER(d.nome) = 'BANCO DE DADOS II'

ILIKE = Nao diferencia maiusculas e minusculas

4 - Listar os professores e suas disciplinas ordenadas por semestre em ordem crescente
SELECT p.nome, d.nome 
FROM professor p
INNER JOIN ministra m ON p.codigo = m.codigo 
INNER JOIN disciplina d ON d.id = m.id
ORDER BY m.semestre


5 - Somar o numero de horas que sao ministradas pelo professor Procopio, independente do semestre
SELECT SUM(nhoras)
FROM disciplina d
INNER JOIN ministra m ON d.id = m.id
INNER JOIN professor p ON m.codigo = p.codigo
WHERE UPPER(p.nome) = 'PROCOPIO'
6 - Listar o nome de alunos matriculados em cada disciplina do semestre 2018/1
SELECT a.nome , d.nome , m.semestre
FROM aluno a
INNER JOIN turma t ON t.codigo = a.codigo
INNER JOIN disciplina d ON d.id = t.id
INNER JOIN ministra m ON m.id = d.id
WHERE m.semestre = '2018/1'


7 - Listar o nome dos professores que ministram disciplinas, 
com o nhoras maior que a carga horaria da disciplina de Projeto de Banco de Dados


SELECT p.nome, d.nome, d.nhoras
FROM professor p
INNER JOIN ministra m ON p.codigo = m.codigo
INNER JOIN disciplina d ON d.id = m.id
WHERE d.nhoras >=
(SELECT d.nhoras
FROM disciplina d
WHERE UPPER(d.nome) = 'PROJETO DE BANCO DE DADOS')

-- ALL = todos
-- ANY = Qualquer

SELECT nhoras
FROM disciplina
WHERE nome = 'Projeto de Banco de Dados'

8 - Faça uma consulta para listar o nome das disciplinas que tem 3 ou mais alunos matriculados
SELECT d.nome, count(a.matricula) as NumALUNOS
FROM disciplina d
INNER JOIN turma t ON d.id = t.id
INNER JOIN aluno a ON a.codigo = t.codigo
GROUP BY d.nome
HAVING count(a.matricula) > 2


9 Faça uma consulta para listar o codigo das turmas que nao possuem alunos

SELECT t.codigo
FROM turma t
FULL JOIN aluno a ON a.codigo = t.codigo
WHERE a.nome is null

-- FULL JOIN 
-- INNER JOIN
-- LEFT JOIN
-- RIGHT JOIN
-- SELF JOIN


10 - Faca uma consulta para listar o numero de alunos matriculados por semestre, em ordem decrescente de alunos

SELECT count(a.matricula) as QtdAlunos, m.semestre
FROM aluno a
INNER JOIN turma t ON a.codigo = t.codigo
INNER JOIN disciplina d ON t.id = d.id
INNER JOIN ministra m ON d.id = m.id
GROUP BY m.semestre
ORDER BY QtdAlunos DESC

11 - Faca uma visao para listar o nome do professor, nome e numero de horas das disciplinas
e seu respectivo semestre

Depois faça uma consulta nesta visao para listar o numero de disciplinas ofertadas em cada semestre

CREATE VIEW vwProfessores AS
	SELECT p.nome AS PROFESSOR , d.nome AS DISCIPLINA, d.nhoras , m.semestre
		FROM professor p
		INNER JOIN ministra m ON m.codigo = p.codigo
		INNER JOIN disciplina d ON m.id = d.id

SELECT count(disciplina), semestre
FROM vwProfessores
GROUP BY semestre

CREATE TABLE formacao(
id int NOT NULL,
data date,
professor int
);

ALTER TABLE formacao
ADD Constraint pk_formacao PRIMARY KEY (id);

ALTER TABLE formacao
ADD Constraint fk_formacao FOREIGN KEY (professor) REFERENCES professor(codigo);

CREATE SEQUENCE id_seq
INCREMENT BY 3
START WITH 7
MINVALUE 1
MAXVALUE 999;

ALTER TABLE formacao ALTER COLUMN id SET DEFAULT NEXTVAL('id_seq');

INSERT INTO formacao (data,professor) VALUES ('07/03/1990',50);
INSERT INTO formacao (data,professor) VALUES (current_date,51);
INSERT INTO formacao (data,professor) VALUES (current_date,52);
INSERT INTO formacao (data,professor) VALUES (current_date,53);

SELECT * FROM formacao

CREATE TABLE teste(
	registro int DEFAULT NEXTVAL('id_seq') primary key,
    nome varchar(30)
);

INSERT INTO teste(nome) values('Betty');

select * from teste

ALTER SEQUENCE id_seq RESTART WITH 200;

INSERT INTO teste(nome) values('jOAO');

SELECT nextval('id_seq');

INSERT INTO professor(codigo,nome,titulacao) 
values(55,(SELECT nome FROM aluno where matricula = 12),'sem formacao');

SELECT * FROM professor

UPDATE professor
SET nome = (SELECT nome || ' Santos' FROM aluno WHERE matricula = 12)
WHERE codigo = 53



-- AULA 6 DE MARCO 2018

INSERT INTO formacao(data,professor) values('12/10/1998', 53);
INSERT INTO formacao(data,professor) values('12/09/2008', 52);

SELECT 
	CASE
		WHEN EXTRACT(MONTH FROM f.data) = 1 THEN 'JANEIRO'
        WHEN EXTRACT(MONTH FROM f.data) = 2 THEN 'FEVEREIRO'
        WHEN EXTRACT(MONTH FROM f.data) = 3 THEN 'MARÇO'
        WHEN EXTRACT(MONTH FROM f.data) = 4 THEN 'ABRIL'
        WHEN EXTRACT(MONTH FROM f.data) = 5 THEN 'MAIO'
        WHEN EXTRACT(MONTH FROM f.data) = 6 THEN 'JUNHO'
        WHEN EXTRACT(MONTH FROM f.data) = 7 THEN 'JULHO'
        WHEN EXTRACT(MONTH FROM f.data) = 8 THEN 'AGOSTO'
        WHEN EXTRACT(MONTH FROM f.data) = 9 THEN 'SETEMBRO'
        WHEN EXTRACT(MONTH FROM f.data) = 10 THEN 'OUTUBRO'
        WHEN EXTRACT(MONTH FROM f.data) = 11 THEN 'NOVEMBRO'
        WHEN EXTRACT(MONTH FROM f.data) = 12 THEN 'DEZEMBRO'
     ELSE 'Outro mês'
     END as mes,
     COUNT(p.codigo) as N_PROF
FROM professor p INNER JOIN formacao f ON
p.codigo = f.professor
GROUP BY EXTRACT(MONTH FROM f.data)
ORDER BY  COUNT(p.codigo)


SELECT codigo, nome, titulacao
FROM professor
ORDER BY 3 DESC
-- ordena pela terceira coluna

-- ORACLE SQL DEVELOPER
CREATE TABLE funcionarios(
  codigo number,
  nome varchar2(20),
  salario number(10,2),
  primary key (codigo)
);

INSERT INTO funcionarios values(1,'Ana',2100.00);
INSERT INTO funcionarios values(2,'Maria',1210.89);
INSERT INTO funcionarios values(3,'Joao',3500.00);

CREATE TABLE gerente as
SELECT * FROM funcionarios
WHERE salario > 2000

DESCRIBE gerente

select * from gerente

DECLARE
  a NUMBER;
  b VARCHAR2(20);
  c NUMBER(8,2);
BEGIN
  SELECT codigo,nome,salario INTO a,b,c
  from funcionarios
  where salario > 2000;
  insert into funcionarios values(a+10,b,c+100);
END;



DECLARE
  a NUMBER;
  b VARCHAR2(20);
  c NUMBER(8,2);
BEGIN
  SELECT codigo,nome,salario INTO a,b,c
  from funcionarios
  where salario > 2150;
  IF a = 1 THEN
  insert into funcionarios values(50,'Estágio', 800);
  ELSE
  insert into funcionarios values(51,'Supervisor', 2000);
  END if;
END;

select * from funcionarios;

--- EXEMPLO PROCEDURE

CREATE  OR REPLACE PROCEDURE p_mensagem IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Olá, testando procedimento');
END p_mensagem;

SET SERVEROUTPUT ON;

EXEC p_mensagem;


CREATE OR REPLACE PROCEDURE p_aumentaSalario(cod NUMBER) IS
BEGIN
  update funcionarios
  set salario = salario * 1.10
  where codigo = cod;
END p_aumentaSalario;

select * from funcionarios;

EXEC p_aumentaSalario(1);


--- EXEMPLO DE FUNCAO ---

CREATE FUNCTION retangulo_area(lado FLOAT)
RETURN NUMBER IS 
BEGIN
  RETURN lado * lado;
END;

SELECT retangulo_area(10) from dual;

CREATE OR REPLACE FUNCTION get_salario(n VARCHAR2)
RETURN NUMBER IS novonome NUMBER;
BEGIN
  SELECT salario INTO novonome
  FROM funcionarios 
  where nome = n;
  RETURN(novonome);
END;

SELECT get_salario('Joao') from dual;

SELECT * from funcionarios;


------------------ LOOPS --------------LOOPS---------------------------LOOPS------------------------------LOOPS-----------

CREATE TABLE dados(
  numero number NOT NULL,
  denominacao VARCHAR2(8)
);

ALTER TABLE dados ADD CONSTRAINT pk_dados primary key(numero);



DECLARE
  v NUMBER;
  descricao VARCHAR2(8);
BEGIN
  v:=0;
  LOOP
    v:= v+1;
  EXIT WHEN v > 20;
    IF MOD(v,2)=0 THEN
      descricao := 'par';
    ELSE
      descricao := 'impar';
    END IF;
    INSERT INTO dados(numero,denominacao)values(v,descricao);
  END LOOP;
END;

SELECT * FROM dados;



-- WHILE LOOP
DECLARE
  v NUMBER;
  descricao VARCHAR2(8);
BEGIN
  v:=21;
  WHILE v < 40 LOOP
    IF MOD(v,2)=0 THEN
      descricao := 'par';
    ELSE
      descricao := 'impar';
    END IF;
    INSERT INTO dados(numero,denominacao)values(v,descricao);
    v:= v+1;
  END LOOP;
END;

SELECT * FROM dados;

DELETE from dados WHERE numero > 20;


-- FOR

DECLARE
  v NUMBER;
  descricao VARCHAR2(8);
BEGIN
  FOR v IN 40..60 LOOP
    IF MOD(v,2)=0 THEN
      descricao := 'par';
    ELSE
      descricao := 'impar';
    END IF;
    INSERT INTO dados(numero,denominacao)values(v,descricao);
  END LOOP;
END;






-- Exemplo de PROCEDURE com Exceções

select * from conta;

UPDATE conta
SET saldo = 190
WHERE numero = 7382;

CREATE OR REPLACE PROCEDURE testaExcecao (nc in number) IS
  a NUMBER(6,2);
  erro EXCEPTION;
  BEGIN
    SELECT saldo INTO a FROM conta WHERE numero = nc;
    IF (a > 150) THEN
      a := a+1;
      DBMS_OUTPUT.PUT_LINE('Feito o acrescimento!');
    ELSE
      raise erro;
    END IF;
    
    EXCEPTION
      WHEN erro THEN
        RAISE_APPLICATION_ERROR(-20001, 'Condição não cumprida!');
  END testaExcecao;
  
  SET SERVEROUTPUT ON;
  EXEC testaExcecao(7382);
  
  select * from conta;
  
 

 -- Procedimento que realiza a operacao de deposito em uma conta válida.
  -- Também faz o saque se houver saldo
  
  CREATE SEQUENCE seq_id
  increment by 1
  start WITH 1;

  CREATE OR REPLACE PROCEDURE fazOperacao (op in VARCHAR, v in NUMBER, fone in varchar, nc in int, cli in int) IS
  x INT;
  erro EXCEPTION;
  BEGIN
  SELECT numero INTO x FROM conta WHERE numero = nc;
  IF (x is null) THEN
  RAISE erro;
  ELSIF (op='D') and (x is not null) THEN
  insert into operacao values(seq_id.nextval,op,v,current_date,fone,nc,cli);
    update conta set saldo = saldo + v WHERE numero = nc;
      ELSE
      x:=1;
      END IF;
      EXCEPTION 
      WHEN erro THEN 
      RAISE_APPLICATION_ERROR(-20001, 'Conta não existe!');
      END fazOperacao;



      EXEC fazOperacao('D',400,'98766765',9070,111);
      select * from operacao
      select * from conta
      select * from conta
      select * from USER_sequences;


------- EFETUAR SAQUE DA CONTA

CREATE OR REPLACE PROCEDURE fazOperacao (op in VARCHAR, v in NUMBER, fone in varchar, nc in int, cli in int) IS
    x INT;
    erro EXCEPTION;
    semsaldo EXCEPTION;
  BEGIN
    SELECT saldo INTO x FROM conta WHERE numero = nc;
    IF (x is null) THEN
      RAISE erro;
    ELSIF (op='S') and (x is not null)  and (x >= v) THEN
      insert into operacao values(seq_id.nextval,op,v,current_date,fone,nc,cli);
      update conta set saldo = saldo - v WHERE numero = nc;
    ELSIF (x < v) THEN
      RAISE semsaldo;
    ELSE
      x:=1;
    END IF;
    EXCEPTION 
      WHEN erro THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Conta não existe!');
      WHEN semsaldo THEN 
        RAISE_APPLICATION_ERROR(-20003, 'Saldo Insuficiente!');
  END fazOperacao;
  
  select * from conta
  select * from cliente
  EXEC fazOperacao('S',400,'98766765',9070,22);
  
   select * from operacao


   
 
    -- PROCEDIMENTO PARA PREENCHER DADOS NA TABELA contacliente
   CREATE OR REPLACE FUNCTION f_verificarenda(c int)
   RETURN NUMBER IS
    varR NUMBER; limite NUMBER;
   BEGIN
    select renda into varR from cliente where codigo = c;
    IF( (varR > 500) and (varR <= 3000) ) THEN
      limite := 900;
    ELSIF( (varR > 3000) and (varR <= 8000) ) THEN
      limite := 1600;
    ELSIF( (varR > 8000) ) THEN
      limite := 2400;
    ELSE
      limite := 300;
    END IF;
  RETURN (limite);
  END f_verificarenda;
   
   select * from cliente;
   select f_verificarenda(21) from dual;
   
   CREATE OR REPLACE PROCEDURE p_ctacli (cli in int) IS
    r1 INT := 0;
   BEGIN 
    select count(*) INTO r1 from contacliente;
    IF (r1 = 0) THEN
      INSERT INTO contacliente(codigocliente, numeroconta,datacriacao,limite)
      VALUES(cli,(SELECT numero FROM conta WHERE ROWNUM <= 1),current_date, f_verificarenda(cli));
    ELSE
      INSERT INTO contacliente(codigocliente, numeroconta,datacriacao,limite)
      VALUES(cli,(SELECT c.numero FROM conta c LEFT JOIN contacliente cc on
      c.numero = cc.numeroconta
      WHERE cc.numeroconta is null AND ROWNUM <= 1),current_date, f_verificarenda(cli));
    END IF;
   END p_ctacli;
   
   EXEC p_ctacli(21);
   
   EXEC p_ctacli(22);
   select * from cliente;
   select * from contacliente;
   
  
  
   -- Baseado nesta base de dados, faça a descrição de um problema (regra de negócio)
-- e elabore um PROCEDURE (que usa uma função) para resolver o problema.

-- REGRA DE NEGÓCIO: 
-- Atualizar o limite da conta de um cliente de acordo com a sua renda.


   CREATE OR REPLACE FUNCTION f_atualiza_limite(nivel VARCHAR2)
   RETURN VARCHAR2 IS
    var NUMBER;
   BEGIN
    select renda into varR from cliente where codigo = c;
    IF( (varR > 500) and (varR <= 3000) ) THEN
      limite := 900;
    ELSIF( (varR > 3000) and (varR <= 8000) ) THEN
      limite := 1600;
    ELSIF( (varR > 8000) ) THEN
      limite := 2400;
    ELSE
      limite := 300;
    END IF;
  RETURN (limite);
  END f_verificarenda;
   
   select * from cliente;
   select f_verificarenda(21) from dual;
   
   CREATE OR REPLACE PROCEDURE p_atualiza_limite (cli in int , nova_renda in NUMBER) IS
    ren INT := 0;
    erro EXCEPTION;
   BEGIN 
    select renda INTO ren from cliente where codigo = cli;
    IF (cli is null) THEN
      RAISE erro;
    ELSIF (ren != nova_renda)  THEN
      IF (nova_renda > ren) THEN
        INSERT INTO contacliente(codigocliente, numeroconta,datacriacao,limite)
        VALUES(cli,(SELECT numeroconta FROM contacliente WHERE codigocliente = 21),current_date, f_verificarenda(cli));
      END IF;
      
    ELSE
      INSERT INTO contacliente(codigocliente, numeroconta,datacriacao,limite)
      VALUES(cli,(SELECT c.numero FROM conta c LEFT JOIN contacliente cc on
      c.numero = cc.numeroconta
      WHERE cc.numeroconta is null AND ROWNUM <= 1),current_date, f_verificarenda(cli));
    END IF;
   END p_ctacli;
   
   EXEC p_ctacli(21);
   
   