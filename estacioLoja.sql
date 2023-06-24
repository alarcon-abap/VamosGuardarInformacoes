use Loja;
go

-- Cria a tabela Usuario no banco Loja
CREATE TABLE Usuario (id_user int IDENTITY(1,1) PRIMARY KEY, 
logon varchar(3) not null,
senha varchar(3) not null,
);

-- Inserindo dados na tabela de Usuário
INSERT INTO Usuario(logon, senha)
VALUES ('op2', 'op2')

select * from Usuario;

--------------------------------------------------------------------------

-- Cria a tabela Produto no banco Loja
CREATE TABLE Produto (id_produto int IDENTITY(1,1) PRIMARY KEY, 
nome varchar(255) not null,
quantidade integer not null,
preco_venda float
);

-- Inserindo dados na tabela de Produto
INSERT INTO Produto(nome, quantidade, preco_venda)
VALUES ('Limão', 152, 3.88)
	   
DELETE FROM Produto WHERE nome='Maçã';

ALTER TABLE Produto
DROP COLUMN preco_venda;

ALTER TABLE Produto
ADD preco_venda float;

UPDATE Produto
SET preco_venda = 5.25
WHERE nome = 'Banana';

select * from Produto;

--------------------------------------------------------------
			
-- Cria a tabela Pessoa no banco Loja
CREATE TABLE Pessoa (id_pessoa int IDENTITY(1,1) PRIMARY KEY, 
nome_pessoa varchar(255) not null,
logradouro varchar(255) null,
cidade varchar(255) null,
estado char(2) null,
telefone varchar(11),
email varchar(255)
);
GO

INSERT INTO Pessoa (nome_pessoa, logradouro, cidade, estado, telefone, email)
VALUES ('Wallace Tavares', 'Rua Ana Augusta', 'São Paulo', 'SP', '11991052555', 'w.tavares@gmail.com'),
	   ('Ricardo Alarcon', 'Rua Dr Cristiano', 'São Paulo', 'SP', '11991054554', 'r.alarcon@gmail.com')

INSERT INTO Pessoa (nome_pessoa, logradouro, cidade, estado, telefone, email)
VALUES ('Tintas Carrão', 'Rua Roxa', 'São Paulo', 'SP', '1127814777', 'tintas@outlook.com'),
	   ('Pneus Trindade', 'Rua Dom Pedro Silva', 'São Paulo', 'SP', '1127814777', 'p.trindade@gmail.com')

select * from Pessoa;
select * from Pessoa_Juridica;

----------------------------------------------------------------

-- Cria a tabela Pessoa Física no banco Loja
CREATE TABLE Pessoa_Fisica (
id_pessoa_fisica int IDENTITY(1,1) not null, 
id_pessoa int not null,
tipo_documento varchar(20) not null,
numero_documento varchar(50) not null,
data_expedicao date not null,
data_validade date null,
CONSTRAINT PK_Pessoa_Documento PRIMARY KEY (id_pessoa_fisica),
CONSTRAINT FK_Pessoa_Documento FOREIGN KEY (id_pessoa)
REFERENCES Pessoa(id_pessoa)
);
GO

INSERT INTO Pessoa_Fisica (id_pessoa, tipo_documento, numero_documento, data_expedicao, data_validade)
VALUES (7, 'CPF', '155094775-40', '2003/05/23', ''), 
	   (8, 'CPF', '033055785-60', '2013/05/23', '');

select * from Pessoa_Fisica;

-----------------------------------------------------------------------------------

-- Cria a tabela Pessoa Jurídica no banco Loja
CREATE TABLE Pessoa_Juridica (
id_pessoa_juridica int IDENTITY(1,1) not null, 
id_pessoa int not null,
tipo_documento varchar(20) not null,
numero_documento varchar(50) not null,
data_expedicao date not null,
data_validade date null,
CONSTRAINT PK_Pessoa_Juridica PRIMARY KEY (id_pessoa_juridica),
CONSTRAINT FK_Pessoa_Juridica FOREIGN KEY (id_pessoa)
REFERENCES Pessoa(id_pessoa)
);
GO

INSERT INTO Pessoa_Juridica (id_pessoa, tipo_documento, numero_documento, data_expedicao, data_validade)
VALUES (9, 'CNPJ', '21263258000144', '2013/05/23', ''),
	   (10, 'CNPJ', '25263558000199', '2013/05/23', '');

UPDATE Pessoa_Juridica
SET numero_documento = '48686801000999'
WHERE id_pessoa = 10;


select * from Pessoa_Juridica;

----------------------------------------------------------

-- Movimentação de compra e venda
CREATE TABLE Movimentacao (
id_movimento int IDENTITY(1,1) not null, 
id_usuario int not null,
id_pessoa int not null,
id_produto int not null,
quantidade integer not null,
tipo char(1),
valor_unitario float
CONSTRAINT PK_Movimentacao PRIMARY KEY (id_movimento),
CONSTRAINT FK_User FOREIGN KEY (id_usuario)
REFERENCES Usuario(id_user),
CONSTRAINT FK_People FOREIGN KEY (id_pessoa)
REFERENCES Pessoa(id_pessoa),
CONSTRAINT FK_Product FOREIGN KEY (id_produto)
REFERENCES Produto(id_produto)
);
GO

INSERT INTO Movimentacao(id_usuario, id_pessoa, id_produto, quantidade, tipo, valor_unitario)
VALUES (1, 5, 16, 52, 'E', 5.90)

DELETE FROM Movimentacao WHERE id_pessoa=2;
	   
UPDATE Movimentacao
SET id_pessoa = 5
WHERE id_movimento = 2;

select * from Movimentacao;
select * from Usuario;
select * from Pessoa_Juridica;
select * from Pessoa;
select * from Produto;
----------------------------------------------------------------------------------------------------------

-- Efetuar as seguintes consultas sobre os dados inseridos:
-- Dados completos de pessoas físicas.
select * from Pessoa_Fisica;
-- Dados completos de pessoas juridica.
select * from Pessoa_Juridica;

-- Movimentações de entrada, com produto, fornecedor, quantidade, preço unitário e valor total.
select p.nome_pessoa, m.id_produto, m.id_pessoa, m.quantidade, m.valor_unitario, (m.quantidade * m.valor_unitario) valor_total
from Movimentacao as m
Join Pessoa as p on (m.id_pessoa = p.id_pessoa)
where m.tipo = 'E';

select * from Movimentacao where tipo = 'E';
select * from Pessoa;

-- Movimentações de entrada, com produto, cliente, quantidade, preço unitário e valor total.
select p.nome_pessoa, m.id_produto, m.id_pessoa, m.quantidade, m.valor_unitario, (m.quantidade * m.valor_unitario) valor_total
from Movimentacao as m
Join Pessoa as p on (m.id_pessoa = p.id_pessoa)
where m.tipo = 'S';

-- Movimentações somatória de quantidade por produto agrupado.
select id_produto, SUM(quantidade) Quantidade, SUM(quantidade * valor_unitario) QuantidadeValor
from Movimentacao
group by id_produto;

--  Valor médio do produto por fornecedor
select id_produto, SUM(quantidade * valor_unitario) / SUM(quantidade) as MediaCompra
from Movimentacao
where tipo = 'E'
group by id_produto;

--  Valor médio do produto por cliente
select id_produto, SUM(quantidade * valor_unitario) / SUM(quantidade) as MediaVenda
from Movimentacao as m
where tipo = 'S'
group by id_produto;



select * from Movimentacao;
select * from Produto;
select * from Pessoa;
