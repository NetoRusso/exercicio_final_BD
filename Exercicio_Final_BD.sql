CREATE TABLE IF NOT EXISTS departamento (
	num_depto SERIAL NOT NULL,
	nome_depto VARCHAR(100) NOT NULL,
	CONSTRAINT num_depto_PK PRIMARY KEY (num_depto)
);

CREATE TABLE IF NOT EXISTS empregado (
	id SERIAL,
	matricula_empregado UUID DEFAULT gen_random_uuid() NOT NULL,
	nome_empregado VARCHAR(255) NOT NULL,
	salario DECIMAL(10,2),
	num_depto INT,
	CONSTRAINT id_PK PRIMARY KEY(id),
	CONSTRAINT num_depto_FK  FOREIGN KEY(num_depto) REFERENCES departamento(num_depto)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);


insert into departamento (nome_depto) VALUES 
	('Departamento pessoal'),
	('Departamento financeiro'),
	('Departamento Comercial'),
	('Departamento Juritico'),
	('Departamento de P&D'),
	('Departamento de Marketing')
;

insert into empregado (nome_empregado, salario, num_depto) values ('Farrell Fogden', 10355.36, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Anna-maria Quainton', 9365.59, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Terence Jacop', 8576.24, 6);
insert into empregado (nome_empregado, salario, num_depto) values ('Bruis Blackley', 8085.61, 2);
insert into empregado (nome_empregado, salario, num_depto) values ('Marion Dwane', 9121.71, 5);
insert into empregado (nome_empregado, salario, num_depto) values ('Aurel Tabourier', 7347.52, 5);
insert into empregado (nome_empregado, salario, num_depto) values ('Batholomew Crosskell', 9570.9, 2);
insert into empregado (nome_empregado, salario, num_depto) values ('Lorrie Peck', 10002.55, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Jeana Colebeck', 4955.21, 4);
insert into empregado (nome_empregado, salario, num_depto) values ('Steffane Garlinge', 10251.0, 2);
insert into empregado (nome_empregado, salario, num_depto) values ('Constance Keitley', 14995.66, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Allissa Kinney', 7878.84, 2);
insert into empregado (nome_empregado, salario, num_depto) values ('Leslie Jeandin', 13098.89, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Melisa Pybus', 7785.75, 6);
insert into empregado (nome_empregado, salario, num_depto) values ('Christoper De L''Isle', 5439.0, 2);
insert into empregado (nome_empregado, salario, num_depto) values ('Derry Thrush', 11751.98, 4);
insert into empregado (nome_empregado, salario, num_depto) values ('Graig Stenson', 9363.67, 2);
insert into empregado (nome_empregado, salario, num_depto) values ('Leta Vince', 12090.85, 4);
insert into empregado (nome_empregado, salario, num_depto) values ('Britteny Sitlinton', 10586.56, 5);
insert into empregado (nome_empregado, salario, num_depto) values ('Wandie Mattocks', 7826.17, 4);
insert into empregado (nome_empregado, salario, num_depto) values ('Mozes Lodden', 6650.6, 5);
insert into empregado (nome_empregado, salario, num_depto) values ('Arin Imlacke', 6815.06, 6);
insert into empregado (nome_empregado, salario, num_depto) values ('Carlye Cabel', 11203.61, 6);
insert into empregado (nome_empregado, salario, num_depto) values ('Beryl Benzi', 6704.51, 4);
insert into empregado (nome_empregado, salario, num_depto) values ('Papagena Alfonsetto', 5150.7, 2);
insert into empregado (nome_empregado, salario, num_depto) values ('Dedra Waylett', 11178.25, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Olivie Britian', 7077.91, 4);
insert into empregado (nome_empregado, salario, num_depto) values ('Edythe Hachard', 12811.84, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Chucho Lumsdon', 5335.41, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Bondon Bosence', 11564.99, 5);
insert into empregado (nome_empregado, salario, num_depto) values ('Roby Simnel', 7739.76, 3);
insert into empregado (nome_empregado, salario, num_depto) values ('Rebekkah Briat', 14364.94, 1);
insert into empregado (nome_empregado, salario, num_depto) values ('Debora Ritter', 8400.16, 2);
insert into empregado (nome_empregado, salario, num_depto) values ('Carmelina Inchbald', 8292.83, 3);
insert into empregado (nome_empregado, salario, num_depto) values ('Reggi Boards', 4301.9, 3);
insert into empregado (nome_empregado, salario, num_depto) values ('Leeann Takkos', 13925.62, 5);


SELECT * FROM empregado;

-- 1. Auditoria de Alterações:
--    - Crie um trigger que registre todas as inserções, atualizações e exclusões na tabela 
-- 	`empregado` em uma tabela de auditoria chamada `auditoria_empregado`. 
-- 	Esta tabela deve armazenar a ação realizada (`INSERT`, `UPDATE`, `DELETE`), 
-- 	a data/hora da ação e a matrícula do empregado afetado.


-- Cria a tabela de auditoria

CREATE TABLE IF NOT EXISTS auditoria_empregado (
    id SERIAL,
    acao VARCHAR(10) NOT NULL,
    data_hora TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    matricula_empregado UUID NOT NULL,
	CONSTRAINT id_auditoria_PK PRIMARY KEY(id)
);

-- Cria o trigger para auditar as alterações na tabela empregado

CREATE OR REPLACE FUNCTION audit_empregado()
RETURNS TRIGGER AS $$
BEGIN
	
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria_empregado (acao, matricula_empregado) 
		VALUES ('INSERT', NEW.matricula_empregado);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria_empregado (acao, matricula_empregado) 
		VALUES ('UPDATE', OLD.matricula_empregado);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria_empregado (acao, matricula_empregado) 
		VALUES ('DELETE', OLD.matricula_empregado);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria o trigger para a tabela empregado

CREATE TRIGGER audit_empregado_trigger
AFTER INSERT OR UPDATE OR DELETE ON empregado
FOR EACH ROW EXECUTE PROCEDURE audit_empregado();


SELECT * FROM auditoria_empregado
insert into empregado (nome_empregado, salario, num_depto) values 
	('Douglas Ferreira', 12752.25, 5);

select * from departamento


-- 2. Controle de Salário Máximo:
--    - Crie um trigger que impeça que um empregado receba um aumento de salário que 
-- 	exceda 20% do seu salário atual. 
-- 	Se um aumento maior que 20% for tentado, o trigger deve lançar uma exceção.


CREATE OR REPLACE FUNCTION verificar_aumento_salario() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salario > OLD.salario * 1.20 THEN
        RAISE EXCEPTION 'O aumento de salário não pode exceder 20%% do salário atual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_salario_maximo
BEFORE UPDATE ON EMPREGADO
FOR EACH ROW
WHEN (OLD.SALARIO IS DISTINCT FROM NEW.SALARIO)
EXECUTE FUNCTION verificar_aumento_salario();

select * from empregado;

update empregado
	set salario = 20000.00
	where id = 38;

-- 3. Histórico de Salário:
--    - Crie uma tabela `historico_salario` que armazene o histórico de salários dos 
-- 	empregados. Crie um trigger que insira um registro nesta tabela sempre que o 
-- 	salário de um empregado for atualizado.


-- Cria a tabela historico_salario

CREATE TABLE IF NOT EXISTS historico_salario (
    id SERIAL,
    matricula_empregado UUID NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    data_hora TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
	CONSTRAINT id_historico_PK PRIMARY KEY(id)
);

-- Cria o trigger para registrar o histórico de salários

CREATE OR REPLACE FUNCTION registrar_historico_salario()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO historico_salario (matricula_empregado, salario) VALUES (OLD.matricula_empregado, OLD.salario);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria o trigger para a tabela empregado

CREATE TRIGGER registrar_historico_salario_trigger
AFTER UPDATE ON empregado
FOR EACH ROW EXECUTE PROCEDURE registrar_historico_salario();

update empregado
	set salario = 1500.01
	where id = 38;

select * from empregado where id = 38;


-- 4. Atualização Automática de Idade:
--Crie um trigger que atualize automaticamente a idade dos empregados todos os anos, 
-- com base em sua data de nascimento armazenada na tabela `empregado`.

-- Adiciona a coluna data_nascimento à tabela empregado

ALTER TABLE empregado
ADD COLUMN data_nascimento DATE;
ALTER TABLE empregado
ADD COLUMN idade integer;


ALTER TABLE empregado DROP COLUMN idade;


-- Cria a função para atualizar a idade

CREATE OR REPLACE FUNCTION atualizar_idade()
RETURNS TRIGGER AS $$
BEGIN
    NEW.idade = EXTRACT(YEAR FROM AGE(NEW.data_nascimento));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Cria o trigger para atualizar a idade

CREATE TRIGGER atualizar_idade_trigger
BEFORE INSERT OR UPDATE ON empregado
FOR EACH ROW EXECUTE PROCEDURE atualizar_idade();

DROP TRIGGER atualizar_idade_trigger
select * from empregado;

CREATE TEMP TABLE tabela_datas_nascimento (
	id serial,
    data_nascimento DATE NOT NULL
);

insert into tabela_datas_nascimento (data_nascimento) values ('26-12-1980');
insert into tabela_datas_nascimento (data_nascimento) values ('26-12-1972');
insert into tabela_datas_nascimento (data_nascimento) values ('18-11-2000');
insert into tabela_datas_nascimento (data_nascimento) values ('04-06-1965');
insert into tabela_datas_nascimento (data_nascimento) values ('05-06-1961');
insert into tabela_datas_nascimento (data_nascimento) values ('03-08-1967');
insert into tabela_datas_nascimento (data_nascimento) values ('30-04-2005');
insert into tabela_datas_nascimento (data_nascimento) values ('28-01-1973');
insert into tabela_datas_nascimento (data_nascimento) values ('13-05-1982');
insert into tabela_datas_nascimento (data_nascimento) values ('15-06-1971');
insert into tabela_datas_nascimento (data_nascimento) values ('20-08-1980');
insert into tabela_datas_nascimento (data_nascimento) values ('16-07-1975');
insert into tabela_datas_nascimento (data_nascimento) values ('16-05-1971');
insert into tabela_datas_nascimento (data_nascimento) values ('13-01-1966');
insert into tabela_datas_nascimento (data_nascimento) values ('31-07-1985');
insert into tabela_datas_nascimento (data_nascimento) values ('15-08-1986');
insert into tabela_datas_nascimento (data_nascimento) values ('15-04-1979');
insert into tabela_datas_nascimento (data_nascimento) values ('19-02-1976');
insert into tabela_datas_nascimento (data_nascimento) values ('11-10-1961');
insert into tabela_datas_nascimento (data_nascimento) values ('10-12-1985');
insert into tabela_datas_nascimento (data_nascimento) values ('23-04-1967');
insert into tabela_datas_nascimento (data_nascimento) values ('11-11-1998');
insert into tabela_datas_nascimento (data_nascimento) values ('15-06-2000');
insert into tabela_datas_nascimento (data_nascimento) values ('13-03-2004');
insert into tabela_datas_nascimento (data_nascimento) values ('09-09-2005');
insert into tabela_datas_nascimento (data_nascimento) values ('29-08-1988');
insert into tabela_datas_nascimento (data_nascimento) values ('31-01-1967');
insert into tabela_datas_nascimento (data_nascimento) values ('21-07-1975');
insert into tabela_datas_nascimento (data_nascimento) values ('19-02-1973');
insert into tabela_datas_nascimento (data_nascimento) values ('03-01-1990');
insert into tabela_datas_nascimento (data_nascimento) values ('15-06-2001');
insert into tabela_datas_nascimento (data_nascimento) values ('20-12-1977');
insert into tabela_datas_nascimento (data_nascimento) values ('27-08-1984');
insert into tabela_datas_nascimento (data_nascimento) values ('08-11-1979');
insert into tabela_datas_nascimento (data_nascimento) values ('01-08-1983');
insert into tabela_datas_nascimento (data_nascimento) values ('03-09-1986');
insert into tabela_datas_nascimento (data_nascimento) values ('30-04-1984');
insert into tabela_datas_nascimento (data_nascimento) values ('25-06-2000');

UPDATE empregado
SET data_nascimento = (
    SELECT data_nascimento
    FROM tabela_datas_nascimento
    WHERE id.tabela_datas_nascimento = id.empregado
);

SELECT * FROM EMPREGADO where id = 38

UPDATE empregado
SET idade = idade +1
	where id = 38;


-- 5. Calcular Média Salarial por Departamento:
--    - Crie uma função que retorne a média salarial dos empregados em 
-- 	um determinado departamento. A função deve aceitar o número do 
-- 	departamento como parâmetro.


CREATE OR REPLACE FUNCTION media_salarial_por_departamento(num_depto_param INTEGER)
RETURNS DECIMAL(10,2) AS $$
BEGIN
    RETURN (
        SELECT AVG(salario)
        FROM empregado
        WHERE num_depto = num_depto_param
    );
END;
$$ LANGUAGE plpgsql;

SELECT media_salarial_por_departamento(1);

-- 6. Promoção em Massa:
--    - Crie uma função que receba um percentual e um número de departamento, 
-- 	e aumente o salário de todos os empregados nesse departamento pelo percentual fornecido.

CREATE OR REPLACE FUNCTION promover_em_massa (
	percentual DECIMAL(10,2), 
	num_depto_param INTEGER
	)
RETURNS VOID AS $$
BEGIN
    UPDATE empregado
    SET salario = salario * (1 + percentual / 100)
    WHERE num_depto = num_depto_param;
END;
$$ LANGUAGE plpgsql;


SELECT promover_em_massa(10, 6);

SELECT * FROM empregado
	ORDER BY num_depto;

-- 7. Função para Listar Empregados por Departamento:
-- Crie uma função que aceite o nome do departamento como 
-- 	parâmetro e retorne uma lista de todos os empregados que trabalham nesse departamento.

CREATE OR REPLACE FUNCTION listar_empregados_por_departamento(
	nome_depto_param VARCHAR(100))
RETURNS TABLE(
    id INTEGER,
    matricula_empregado UUID,
    nome_empregado VARCHAR(255),
    salario DECIMAL(10,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.matricula_empregado,
        e.nome_empregado,
        e.salario
    FROM empregado e
    JOIN departamento d ON e.num_depto = d.num_depto
    WHERE d.nome_depto = nome_depto_param;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM departamento
SELECT * FROM listar_empregados_por_departamento('Departamento de P&D');


-- 8. Visão de Empregados e Departamentos:
-- Crie uma view que combine informações da tabela `empregado` e `departamento`, 
-- mostrando o nome do empregado, seu salário e o nome do departamento.

CREATE OR REPLACE VIEW empregados_e_departamentos AS
SELECT 
    e.nome_empregado,
    e.salario,
    d.nome_depto
FROM 
    empregado e
JOIN 
    departamento d ON e.num_depto = d.num_depto;


-- Seleciona todos os dados da view

SELECT * FROM empregados_e_departamentos;

-- Seleciona apenas o nome do empregado e o nome do departamento

SELECT nome_empregado, nome_depto FROM empregados_e_departamentos;

-- Filtra os dados da view para mostrar apenas os empregados do departamento 


SELECT * FROM empregados_e_departamentos WHERE nome_depto = 'Departamento de Marketing';
SELECT * FROM departamento

-- 9. Visão de Empregados por Faixa Salarial:
--    - Crie uma view que categorize empregados em diferentes faixas salariais 
-- 	(por exemplo, abaixo de 2000, entre 2000 e 3000, acima de 3000) e 
-- 	liste os empregados em cada faixa.


CREATE OR REPLACE VIEW empregados_por_faixa_salarial AS
SELECT 
    e.nome_empregado,
    e.salario,
    CASE
        WHEN e.salario < 5000 THEN 'Abaixo de 5000'
        WHEN e.salario BETWEEN 5000 AND 10000 THEN 'Entre 5000 e 10000'
        ELSE 'Acima de 10000'
    END AS faixa_salarial
FROM 
    empregado e;


SELECT * FROM empregados_por_faixa_salarial;


-- 10. Visão de Empregados com Aumento Recente:
--     - Crie uma view que mostre todos os empregados que receberam um 
-- 	aumento salarial nos últimos 6 meses, incluindo a data do 
-- 	aumento e o novo salário.

CREATE VIEW empregados_com_aumento_recente AS
SELECT 
    e.nome_empregado,
    hs.data_hora AS data_aumento,
    hs.salario AS novo_salario
FROM 
    empregado e
JOIN 
    historico_salario hs ON e.matricula_empregado = hs.matricula_empregado
WHERE 
    hs.data_hora >= CURRENT_DATE - INTERVAL '6 months'
    AND hs.salario > e.salario;

SELECT * FROM empregados_com_aumento_recente;


-- 11. Gerenciamento de Projetos:
--     - Crie tabelas `projeto`, `participacao_projeto` e `empregado`. 
-- 	Crie triggers e views que gerenciem a alocação de empregados a projetos, 
-- 	registrem alterações nas participações e permitam visualizar todos os projetos 
-- 	de um empregado.

-- Tabela de Projetos

CREATE TABLE IF NOT EXISTS projeto (
    id SERIAL,
    nome_projeto VARCHAR(255) NOT NULL,
    descricao TEXT,
	CONSTRAINT id_projeto_PK PRIMARY KEY(id)
);


-- Tabela de Participação em Projetos

CREATE TABLE IF NOT EXISTS participacao_projeto (
    id SERIAL,
    projeto_id INT NOT NULL,
    empregado_id INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
	CONSTRAINT id_participacao_PK PRIMARY KEY(id),
	CONSTRAINT empregado_id_FK FOREIGN KEY (empregado_id)  REFERENCES empregado(id)
	ON DELETE CASCADE,
	CONSTRAINT projeto_id_FK FOREIGN KEY (projeto_id)  REFERENCES projeto(id)
	ON DELETE CASCADE
);

-- Trigger para registrar alterações na participação em projetos

CREATE OR REPLACE FUNCTION registrar_alteracao_participacao()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO historico_participacao (projeto_id, empregado_id, acao, data_hora) 
        VALUES (NEW.projeto_id, NEW.empregado_id, 'INSERIDO', NOW());
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO historico_participacao (projeto_id, empregado_id, acao, data_hora) 
        VALUES (OLD.projeto_id, OLD.empregado_id, 'ATUALIZADO', NOW());
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO historico_participacao (projeto_id, empregado_id, acao, data_hora) 
        VALUES (OLD.projeto_id, OLD.empregado_id, 'REMOVIDO', NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria o trigger para a tabela participacao_projeto

CREATE TRIGGER registrar_alteracao_participacao_trigger
AFTER INSERT OR UPDATE OR DELETE ON participacao_projeto
FOR EACH ROW EXECUTE PROCEDURE registrar_alteracao_participacao();

-- Tabela de histórico de participação em projetos

CREATE TABLE IF NOT EXISTS historico_participacao (
    id SERIAL,
    projeto_id INTEGER NOT NULL,
    empregado_id INTEGER NOT NULL,
    acao VARCHAR(20) NOT NULL,
    data_hora TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
	CONSTRAINT id_historico_participacao_PK PRIMARY KEY(id)
);

-- View para visualizar os projetos de um empregado

CREATE OR REPLACE VIEW projetos_do_empregado AS
SELECT 
    p.nome_projeto,
    pp.data_inicio,
    pp.data_fim
FROM 
    projeto p
JOIN 
    participacao_projeto pp ON p.id = pp.projeto_id
JOIN 
    empregado e ON pp.empregado_id = e.id
WHERE 
    e.id = 1; 

-- View para visualizar os empregados de um projeto

CREATE OR REPLACE VIEW empregados_do_projeto AS
SELECT 
    e.nome_empregado,
    pp.data_inicio,
    pp.data_fim
FROM 
    empregado e
JOIN 
    participacao_projeto pp ON e.id = pp.empregado_id
JOIN 
    projeto p ON pp.projeto_id = p.id
WHERE 
    p.id = 1;


-- 12. Controle de Férias:
--     - Crie uma tabela `ferias` para registrar os períodos de férias dos empregados. 
-- 	Crie triggers para garantir que as férias não se sobreponham e functions para 
-- 	calcular o total de dias de férias tirados por cada empregado.

-- Tabela de Férias

CREATE TABLE IF NOT EXISTS ferias (
    id SERIAL,
    empregado_id INTEGER NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    dias_ferias INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDENTE',
	CONSTRAINT id_ferias_PK PRIMARY KEY(id),
	CONSTRAINT empregado_id_FK FOREIGN KEY (empregado_id) REFERENCES empregado(id) 
	ON DELETE CASCADE
);

-- Trigger para verificar sobreposição de férias

CREATE OR REPLACE FUNCTION verificar_sobreposicao_ferias()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ferias f
        WHERE f.empregado_id = NEW.empregado_id
        AND (
            (NEW.data_inicio BETWEEN f.data_inicio AND f.data_fim)
            OR (NEW.data_fim BETWEEN f.data_inicio AND f.data_fim)
            OR (NEW.data_inicio <= f.data_inicio AND NEW.data_fim >= f.data_fim)
        )
        AND f.id != NEW.id
    ) THEN
        RAISE EXCEPTION 'As datas de férias se sobrepõem.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria o trigger para a tabela ferias

CREATE TRIGGER verificar_sobreposicao_ferias_trigger
BEFORE INSERT OR UPDATE ON ferias
FOR EACH ROW EXECUTE PROCEDURE verificar_sobreposicao_ferias();

-- Função para calcular o total de dias de férias tirados

CREATE OR REPLACE FUNCTION total_dias_ferias_tirados(empregado_id_param INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT SUM(dias_ferias)
        FROM ferias
        WHERE empregado_id = empregado_id_param
        AND status = 'APROVADO'
    );
END;
$$ LANGUAGE plpgsql;

-- Função para calcular o total de dias de férias restantes

CREATE OR REPLACE FUNCTION total_dias_ferias_restantes(empregado_id_param INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN 30 - total_dias_ferias_tirados(empregado_id_param);
END;
$$ LANGUAGE plpgsql;


-- 13. Auditoria de Acessos:
--     - Crie uma tabela `acesso_sistema` que registre cada acesso ao sistema por empregados. 
-- 	Crie uma função que insira um registro nesta tabela e um trigger 
-- 	que chame esta função sempre que um empregado se logar no sistema.


-- Tabela de Acesso ao Sistema

CREATE TABLE IF NOT EXISTS acesso_sistema (
    id SERIAL,
    empregado_id INTEGER NOT NULL ,
    data_hora TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
	CONSTRAINT id_acesso_PK PRIMARY KEY (id),
	CONSTRAINT empregado_id_FK FOREIGN KEY (empregado_id) 
	REFERENCES empregado(id) ON DELETE CASCADE
);

-- Função para registrar acesso ao sistema

CREATE OR REPLACE FUNCTION registrar_acesso_sistema()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO acesso_sistema (empregado_id) VALUES (NEW.id);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO acesso_sistema (empregado_id) VALUES (NEW.id);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO acesso_sistema (empregado_id) VALUES (OLD.id);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger para registrar acesso ao sistema

CREATE TRIGGER registrar_acesso_sistema_trigger
AFTER INSERT OR UPDATE OR DELETE ON empregado
FOR EACH ROW EXECUTE PROCEDURE registrar_acesso_sistema();


-- 14. Relatório de Desempenho:
--     - Crie uma view que mostre um relatório de desempenho dos empregados, 
-- 	combinando informações de tabelas `empregado`, `avaliacao_desempenho` e 
-- 	`projetos_concluidos`, exibindo a média de avaliações e a quantidade de 
-- 	projetos concluídos por empregado.

-- Tabela de Avaliação de Desempenho

CREATE TABLE IF NOT EXISTS avaliacao_desempenho (
    id SERIAL,
    empregado_id INTEGER NOT NULL,
    data_avaliacao DATE NOT NULL,
    nota_avaliacao DECIMAL(2,1) NOT NULL,
    CONSTRAINT id_avaliacao_PK PRIMARY KEY (id),
    CONSTRAINT empregado_id_FK FOREIGN KEY (empregado_id) 
	REFERENCES empregado(id) ON DELETE CASCADE
);

-- Tabela de Projetos Concluídos

CREATE TABLE IF NOT EXISTS projetos_concluidos (
    id SERIAL,
    empregado_id INTEGER NOT NULL,
    projeto_id INTEGER NOT NULL,
    data_conclusao DATE NOT NULL,
    CONSTRAINT id_projetos_concluidos_PK PRIMARY KEY (id),
    CONSTRAINT empregado_id_FK FOREIGN KEY (empregado_id) 
	REFERENCES empregado(id) ON DELETE CASCADE,
    CONSTRAINT projeto_id_FK FOREIGN KEY (projeto_id) 
	REFERENCES projeto(id) ON DELETE CASCADE
);

-- View para Relatório de Desempenho

CREATE OR REPLACE VIEW relatorio_desempenho AS
SELECT 
    e.nome_empregado,
    AVG(ad.nota_avaliacao) AS media_avaliacoes,
    COUNT(pc.id) AS projetos_concluidos
FROM 
    empregado e
LEFT JOIN 
    avaliacao_desempenho ad ON e.id = ad.empregado_id
LEFT JOIN 
    projetos_concluidos pc ON e.id = pc.empregado_id
GROUP BY 
    e.nome_empregado
ORDER BY 
    e.nome_empregado;




-- Inserindo dados de exemplo para teste

INSERT INTO avaliacao_desempenho (empregado_id, data_avaliacao, nota_avaliacao) VALUES
    (2, '2023-03-15', 4.5),
    (2, '2023-06-20', 4.0),
    (4, '2023-04-01', 3.8),
    (6, '2023-05-10', 4.8);

select * from projeto;

insert into projeto (nome_projeto, descricao) VALUES
	('Projeto Inclusão', 'Projeto sobre a inclusão'),
	('Projeto Flores', 'Projeto sobre as flores'),
	('Projeto Maromba', 'Projeto fitness'),
	('Projeto aguia', 'Projeto de alavancagem'),
	('projeto dev', 'Projeto de desenvolvimento')

INSERT INTO projetos_concluidos (empregado_id, projeto_id, data_conclusao) VALUES
    (2, 1, '2023-04-10'),
    (2, 2, '2023-07-05'),
    (4, 3, '2023-06-15'),
    (6, 4, '2023-05-20');





-- Consultando a view
SELECT * FROM relatorio_desempenho;
