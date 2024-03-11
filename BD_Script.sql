CREATE TABLE usuario (
	id INTEGER AUTO_INCREMENT,
	nome VARCHAR(255),
	email VARCHAR(255),
	password VARCHAR(50),
	PRIMARY KEY(id)
);

CREATE TABLE atividade (
	id INTEGER AUTO_INCREMENT,
	titulo VARCHAR(255),
    descricao VARCHAR(255),
    dia DATE,
    PRIMARY KEY(id)
);

CREATE TABLE usuario_atividade (
	usuario_id INTEGER,
    atividade_id INTEGER,
    entrega DATE,
    nota DECIMAL,
    FOREIGN KEY(usuario_id) REFERENCES usuario(id),
    FOREIGN KEY(atividade_id) REFERENCES atividade(id)
);

