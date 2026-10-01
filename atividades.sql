-- Atividade 1
DROP FUNCTION IF EXISTS dobro;
DELIMITER $$

CREATE FUNCTION dobro(numero INT)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN numero * 2;
END $$
DELIMITER ;

SELECT dobro(10) AS resultado;
-----------------------------------------------
-- Atividade 2

DELIMITER $$
CREATE FUNCTION situacao_aluno(media DECIMAL(5,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  IF media >= 6 THEN
    RETURN 'Aprovado';
  ELSEIF media >= 4 THEN
    RETURN 'Recuperação';
  ELSE
    RETURN 'Reprovado';
  END IF;
END $$
DELIMITER ;

SELECT situacao_aluno(8) AS resultado_aprovado;
SELECT situacao_aluno(5) AS resultado_recuperacao;
SELECT situacao_aluno(3) AS resultado_reprovado;
-----------------------------------------------------

-- Atividade 3

CREATE TABLE  alunos (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    data_nascimento DATE
);

INSERT  INTO alunos (id, nome, data_nasc) VALUES
(1, 'Ana', '2000-05-10'),
(2, 'Bruno', '2010-08-15'),
(3, 'Carla', '1998-03-20');

DELIMITER $$
CREATE PROCEDURE buscar_alunos_por_idade(IN idade_minima INT)
BEGIN
    SELECT
        nome,
        YEAR(CURDATE()) - YEAR(data_nasc) AS idade
    FROM alunos
    WHERE YEAR(CURDATE()) - YEAR(data_nasc) >= idade_minima;
END$$
DELIMITER ;

CALL buscar_alunos_por_idade(18);
----------------------------------------------------------------------
-- Atividade 4

-- 4- Procedure de atualização

CREATE TABLE aluno (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    nota DECIMAL(5,2)
);

INSERT INTO aluno (id, nome, nota) VALUES
(1, 'Ana Silva', 7.50),
(2, 'Bruno Costa', 5.00),
(3, 'Carla Souza', 9.20),
(4, 'Diego Lima', 6.80),
(5, 'Elisa Rocha', 4.30);

DELIMITER $$

CREATE PROCEDURE aumentar_nota(
    IN id_aluno INT,
    IN valor_aumento DECIMAL(5,2)
)
BEGIN
    UPDATE alunos
    SET nota = nota + valor_aumento
    WHERE id = id_aluno;
END$$

DELIMITER ;

CALL aumentar_nota(5, 1.5);
SELECT * FROM alunos WHERE id = 5;
--------------------------------------------------------------------
-- Atividade 5
-- Tabela nova para este exercício
CREATE TABLE alunos_nota (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    nota1 DECIMAL(5,2),
    nota2 DECIMAL(5,2)
);

INSERT INTO alunos_nota (id, nome, nota1, nota2) VALUES
(1, 'Ana Silva', 7.50, 8.00),
(2, 'Bruno Costa', 5.00, 4.50),
(3, 'Carla Souza', 9.20, 8.80),
(4, 'Diego Lima', 6.80, 7.20),
(5, 'Elisa Rocha', 4.30, 5.80);
-- 1- FUNCTION `calcular_media`
DELIMITER $$

CREATE FUNCTION calcular_media(nota1 DECIMAL(5,2), nota2 DECIMAL(5,2))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE media DECIMAL(5,2);
    SET media = (nota1 + nota2) / 2;
    RETURN media;
END$$

DELIMITER ;

-- 2- PROCEDURE `mostrar_situacao`
DELIMITER $$

CREATE PROCEDURE mostrar_situacao(IN id_aluno INT)
BEGIN
    DECLARE v_nome VARCHAR(100);
    DECLARE v_nota1 DECIMAL(5,2);
    DECLARE v_nota2 DECIMAL(5,2);
    DECLARE v_media DECIMAL(5,2);
    DECLARE v_situacao VARCHAR(20);

    SELECT nome, nota1, nota2
    INTO v_nome, v_nota1, v_nota2
    FROM alunos_notas
    WHERE id = id_aluno;

    SET v_media = calcular_media(v_nota1, v_nota2);

    IF v_media >= 6 THEN
        SET v_situacao = 'Aprovado';
    ELSE
        SET v_situacao = 'Reprovado';
    END IF;

    SELECT
        v_nome AS Nome,
        v_nota1 AS Nota1,
        v_nota2 AS Nota2,
        v_media AS Media,
        v_situacao AS Situacao;
END$$

DELIMITER ;
-- Test
CALL mostrar_situacao(4);
