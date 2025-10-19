-- -----------------------------------------------------
-- Schema E-commerce
-- -----------------------------------------------------
-- Opcional: Remova o esquema e crie novamente para garantir um ambiente limpo.
DROP DATABASE IF EXISTS `E-commerce`;
CREATE DATABASE IF NOT EXISTS `E-commerce` DEFAULT CHARACTER SET utf8 ;
USE `E-commerce`;

-- -----------------------------------------------------
-- Tabela `Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `Razao_social` VARCHAR(45) NOT NULL,
  `CNPJ` VARCHAR(45) NOT NULL UNIQUE,
  PRIMARY KEY (`idFornecedor`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NOT NULL,
  `Descricao_produto` VARCHAR(45) NOT NULL,
  `Valor` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`idProduto`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Fornecedor_has_Produto` (N:N entre Fornecedor e Produto)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fornecedor_has_Produto` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `Quantidade` INT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Cliente` (Tabela Pai para Subtipagem)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Endereco` VARCHAR(45) NULL,
  `Tipo_Cliente` VARCHAR(5) NOT NULL COMMENT 'PF ou PJ',
  PRIMARY KEY (`idCliente`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Cliente CPF` (Subtipo PF)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente_CPF` (
  `Cliente_idCliente` INT NOT NULL, -- PK e FK
  `CPF` VARCHAR(14) NOT NULL UNIQUE,
  `Data_de_Nascimento` DATE NULL,
  PRIMARY KEY (`Cliente_idCliente`),
  CONSTRAINT `fk_Cliente_CPF_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Cliente CNPJ` (Subtipo PJ)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente_CNPJ` (
  `Cliente_idCliente` INT NOT NULL, -- PK e FK
  `CNPJ` VARCHAR(18) NOT NULL UNIQUE,
  `Razao_Social` VARCHAR(100) NOT NULL,
  `Nome_Fantasia` VARCHAR(100) NULL,
  PRIMARY KEY (`Cliente_idCliente`),
  CONSTRAINT `fk_Cliente_CNPJ_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Forma Pagamento` (Relacionamento 1:N com Cliente)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Forma_Pagamento` (
  `idForma_Pagamento` INT NOT NULL AUTO_INCREMENT,
  `Cliente_idCliente` INT NOT NULL,
  `Tipo_de_pagamento` VARCHAR(50) NOT NULL,
  `Detalhe_pagamento` VARCHAR(255) NULL COMMENT 'Ex: final do cartao, chave pix, etc.',
  PRIMARY KEY (`idForma_Pagamento`),
  CONSTRAINT `fk_Forma_Pagamento_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `Status_pedido` VARCHAR(45) NOT NULL COMMENT 'Status atual do pedido (Ex: Processando, Enviado, Entregue)',
  `Descricao_pedido` VARCHAR(45) NULL,
  `Cliente_idCliente` INT NOT NULL,
  `Frete` DECIMAL(10,2) NULL,
  `Status_entrega` VARCHAR(45) NULL,
  `Codigo_rastreio` VARCHAR(45) NULL,
  `Status_pagamento` VARCHAR(45) NOT NULL,
  `Tipo_de_pagamento` VARCHAR(45) NOT NULL, -- Manter para registro histórico
  `Forma_Pagamento_idForma_Pagamento` INT NOT NULL COMMENT 'FK para a forma de pagamento usada neste pedido',
  PRIMARY KEY (`idPedido`),
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Forma_Pagamento1`
    FOREIGN KEY (`Forma_Pagamento_idForma_Pagamento`)
    REFERENCES `Forma_Pagamento` (`idForma_Pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Pedido_has_Produto` (N:N entre Pedido e Produto)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pedido_has_Produto` (
  `Pedido_idPedido` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `Quantidade` INT NOT NULL,
  PRIMARY KEY (`Pedido_idPedido`, `Produto_idProduto`),
  CONSTRAINT `fk_Pedido_has_Produto_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `Local` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEstoque`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Produto_has_Estoque` (N:N entre Produto e Estoque)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Produto_has_Estoque` (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `Quantidade` INT NOT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `Estoque` (`idEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela `Status Historico` (Relacionamento 1:N com Pedido)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Status_Historico` (
  `idStatus_Historico` INT NOT NULL AUTO_INCREMENT,
  `Pedido_idPedido` INT NOT NULL,
  `Status` VARCHAR(45) NOT NULL COMMENT 'Ex: Aguardando coleta, Coletado, Em rota, Entregue',
  `Data_Alteracao` DATETIME NOT NULL,
  PRIMARY KEY (`idStatus_Historico`),
  CONSTRAINT `fk_Status_Historico_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;
