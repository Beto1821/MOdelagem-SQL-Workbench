-- -----------------------------------------------------
-- Schema E-commerce - Versão Melhorada
-- -----------------------------------------------------
-- Opcional: Remova o esquema e crie novamente para garantir um ambiente limpo.
DROP DATABASE IF EXISTS `E-commerce`;
CREATE DATABASE IF NOT EXISTS `E-commerce` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `E-commerce`;

-- -----------------------------------------------------
-- Tabela `Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `Razao_social` VARCHAR(100) NOT NULL,
  `CNPJ` VARCHAR(18) NOT NULL UNIQUE,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idFornecedor`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(50) NOT NULL,
  `Descricao_produto` VARCHAR(255) NOT NULL,
  `Valor` DECIMAL(10,2) NOT NULL,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idProduto`),
  CONSTRAINT `chk_valor_positivo` CHECK (`Valor` > 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Fornecedor_has_Produto` (N:N entre Fornecedor e Produto)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fornecedor_has_Produto` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `Quantidade` INT NULL DEFAULT 0,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `chk_quantidade_fornecedor` CHECK (`Quantidade` >= 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Cliente` (Tabela Pai para Subtipagem)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `Endereco` VARCHAR(255) NULL,
  `Telefone` VARCHAR(20) NULL,
  `Email` VARCHAR(100) NULL,
  `Tipo_Cliente` ENUM('PF', 'PJ') NOT NULL COMMENT 'PF - Pessoa Física ou PJ - Pessoa Jurídica',
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idCliente`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Cliente CPF` (Subtipo PF)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente_CPF` (
  `Cliente_idCliente` INT NOT NULL,
  `CPF` VARCHAR(14) NOT NULL UNIQUE,
  `Data_de_Nascimento` DATE NULL,
  PRIMARY KEY (`Cliente_idCliente`),
  CONSTRAINT `fk_Cliente_CPF_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `chk_cpf_format` CHECK (CHAR_LENGTH(`CPF`) = 14)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Cliente CNPJ` (Subtipo PJ)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente_CNPJ` (
  `Cliente_idCliente` INT NOT NULL,
  `CNPJ` VARCHAR(18) NOT NULL UNIQUE,
  `Razao_Social` VARCHAR(100) NOT NULL,
  `Nome_Fantasia` VARCHAR(100) NULL,
  `Inscricao_Estadual` VARCHAR(20) NULL,
  PRIMARY KEY (`Cliente_idCliente`),
  CONSTRAINT `fk_Cliente_CNPJ_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `chk_cnpj_format` CHECK (CHAR_LENGTH(`CNPJ`) = 18)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Forma Pagamento` (Relacionamento 1:N com Cliente)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Forma_Pagamento` (
  `idForma_Pagamento` INT NOT NULL AUTO_INCREMENT,
  `Cliente_idCliente` INT NOT NULL,
  `Tipo_de_pagamento` ENUM('Cartão Crédito', 'Cartão Débito', 'PIX', 'Boleto', 'Transferência') NOT NULL,
  `Detalhe_pagamento` VARCHAR(255) NULL COMMENT 'Ex: final do cartão, chave pix, etc.',
  `Ativo` BOOLEAN DEFAULT TRUE,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idForma_Pagamento`),
  CONSTRAINT `fk_Forma_Pagamento_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `Status_pedido` ENUM('Aguardando Pagamento', 'Pago', 'Em Preparação', 'Enviado', 'Entregue', 'Cancelado') NOT NULL DEFAULT 'Aguardando Pagamento',
  `Descricao_pedido` TEXT NULL,
  `Cliente_idCliente` INT NOT NULL,
  `Frete` DECIMAL(10,2) NULL DEFAULT 0.00,
  `Status_entrega` ENUM('Aguardando Coleta', 'Coletado', 'Em Trânsito', 'Saiu para Entrega', 'Entregue', 'Tentativa de Entrega') NULL,
  `Codigo_rastreio` VARCHAR(50) NULL,
  `Status_pagamento` ENUM('Pendente', 'Aprovado', 'Rejeitado', 'Estornado') NOT NULL DEFAULT 'Pendente',
  `Tipo_de_pagamento` VARCHAR(45) NOT NULL,
  `Forma_Pagamento_idForma_Pagamento` INT NOT NULL,
  `Valor_Total` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idPedido`),
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pedido_Forma_Pagamento1`
    FOREIGN KEY (`Forma_Pagamento_idForma_Pagamento`)
    REFERENCES `Forma_Pagamento` (`idForma_Pagamento`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `chk_frete_positivo` CHECK (`Frete` >= 0),
  CONSTRAINT `chk_valor_total_positivo` CHECK (`Valor_Total` >= 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Pedido_has_Produto` (N:N entre Pedido e Produto)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pedido_has_Produto` (
  `Pedido_idPedido` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `Quantidade` INT NOT NULL DEFAULT 1,
  `Preco_Unitario` DECIMAL(10,2) NOT NULL,
  `Subtotal` DECIMAL(12,2) GENERATED ALWAYS AS (`Quantidade` * `Preco_Unitario`) STORED,
  PRIMARY KEY (`Pedido_idPedido`, `Produto_idProduto`),
  CONSTRAINT `fk_Pedido_has_Produto_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pedido_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `chk_quantidade_positiva` CHECK (`Quantidade` > 0),
  CONSTRAINT `chk_preco_unitario_positivo` CHECK (`Preco_Unitario` > 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `Local` VARCHAR(100) NOT NULL,
  `Descricao` VARCHAR(255) NULL,
  `Ativo` BOOLEAN DEFAULT TRUE,
  `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idEstoque`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Produto_has_Estoque` (N:N entre Produto e Estoque)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Produto_has_Estoque` (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `Quantidade` INT NOT NULL DEFAULT 0,
  `Quantidade_Minima` INT NULL DEFAULT 10,
  `data_atualizacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `Estoque` (`idEstoque`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `chk_quantidade_estoque` CHECK (`Quantidade` >= 0),
  CONSTRAINT `chk_quantidade_minima` CHECK (`Quantidade_Minima` >= 0)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Status Historico` (Relacionamento 1:N com Pedido)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Status_Historico` (
  `idStatus_Historico` INT NOT NULL AUTO_INCREMENT,
  `Pedido_idPedido` INT NOT NULL,
  `Status_Anterior` VARCHAR(45) NULL,
  `Status_Atual` VARCHAR(45) NOT NULL,
  `Observacao` TEXT NULL,
  `Usuario_Responsavel` VARCHAR(100) NULL,
  `Data_Alteracao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idStatus_Historico`),
  CONSTRAINT `fk_Status_Historico_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- CRIAÇÃO DE ÍNDICES PARA MELHOR PERFORMANCE
-- -----------------------------------------------------

-- Índices para busca por documentos
CREATE INDEX idx_cliente_cpf ON Cliente_CPF(CPF);
CREATE INDEX idx_cliente_cnpj ON Cliente_CNPJ(CNPJ);
CREATE INDEX idx_fornecedor_cnpj ON Fornecedor(CNPJ);

-- Índices para busca por status e datas
CREATE INDEX idx_pedido_status ON Pedido(Status_pedido);
CREATE INDEX idx_pedido_data_criacao ON Pedido(data_criacao);
CREATE INDEX idx_status_historico_data ON Status_Historico(Data_Alteracao);

-- Índices para relacionamentos frequentes
CREATE INDEX idx_pedido_cliente ON Pedido(Cliente_idCliente);
CREATE INDEX idx_forma_pagamento_cliente ON Forma_Pagamento(Cliente_idCliente);
CREATE INDEX idx_produto_categoria ON Produto(categoria);

-- Índices compostos para consultas específicas
CREATE INDEX idx_pedido_status_data ON Pedido(Status_pedido, data_criacao);
CREATE INDEX idx_produto_estoque_quantidade ON Produto_has_Estoque(Produto_idProduto, Quantidade);

-- -----------------------------------------------------
-- TRIGGERS PARA AUTOMATIZAÇÃO
-- -----------------------------------------------------

-- Trigger para atualizar valor total do pedido
DELIMITER $$
CREATE TRIGGER tr_atualizar_valor_total_pedido
    AFTER INSERT ON Pedido_has_Produto
    FOR EACH ROW
BEGIN
    UPDATE Pedido 
    SET Valor_Total = (
        SELECT COALESCE(SUM(Subtotal), 0) + COALESCE(Frete, 0)
        FROM Pedido_has_Produto 
        WHERE Pedido_idPedido = NEW.Pedido_idPedido
    )
    WHERE idPedido = NEW.Pedido_idPedido;
END$$

-- Trigger para registrar mudanças de status
CREATE TRIGGER tr_registrar_mudanca_status
    AFTER UPDATE ON Pedido
    FOR EACH ROW
BEGIN
    IF OLD.Status_pedido != NEW.Status_pedido THEN
        INSERT INTO Status_Historico (Pedido_idPedido, Status_Anterior, Status_Atual)
        VALUES (NEW.idPedido, OLD.Status_pedido, NEW.Status_pedido);
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- VIEWS ÚTEIS PARA CONSULTAS
-- -----------------------------------------------------

-- View para dados completos do cliente
CREATE VIEW vw_cliente_completo AS
SELECT 
    c.idCliente,
    c.Nome,
    c.Endereco,
    c.Telefone,
    c.Email,
    c.Tipo_Cliente,
    CASE 
        WHEN c.Tipo_Cliente = 'PF' THEN cpf.CPF
        WHEN c.Tipo_Cliente = 'PJ' THEN cnpj.CNPJ
        ELSE NULL
    END AS Documento,
    c.data_criacao
FROM Cliente c
LEFT JOIN Cliente_CPF cpf ON c.idCliente = cpf.Cliente_idCliente
LEFT JOIN Cliente_CNPJ cnpj ON c.idCliente = cnpj.Cliente_idCliente;

-- View para relatório de vendas
CREATE VIEW vw_relatorio_vendas AS
SELECT 
    p.idPedido,
    c.Nome AS Cliente,
    p.Status_pedido,
    p.Valor_Total,
    p.data_criacao AS Data_Pedido,
    COUNT(pp.Produto_idProduto) AS Quantidade_Itens
FROM Pedido p
JOIN Cliente c ON p.Cliente_idCliente = c.idCliente
LEFT JOIN Pedido_has_Produto pp ON p.idPedido = pp.Pedido_idPedido
GROUP BY p.idPedido, c.Nome, p.Status_pedido, p.Valor_Total, p.data_criacao;

-- View para controle de estoque
CREATE VIEW vw_controle_estoque AS
SELECT 
    pr.idProduto,
    pr.Descricao_produto,
    pr.categoria,
    e.Local AS Estoque_Local,
    pe.Quantidade AS Quantidade_Atual,
    pe.Quantidade_Minima,
    CASE 
        WHEN pe.Quantidade <= pe.Quantidade_Minima THEN 'CRÍTICO'
        WHEN pe.Quantidade <= (pe.Quantidade_Minima * 1.5) THEN 'BAIXO'
        ELSE 'NORMAL'
    END AS Status_Estoque
FROM Produto pr
JOIN Produto_has_Estoque pe ON pr.idProduto = pe.Produto_idProduto
JOIN Estoque e ON pe.Estoque_idEstoque = e.idEstoque
WHERE e.Ativo = TRUE;