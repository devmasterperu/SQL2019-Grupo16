--CREATE DATABASE DEVWIFI16ED --Crear una base de datos.
USE DEVWIFI16ED             --Usar una base de datos.

/*
 * ER/Studio 8.0 SQL Code Generation
 * Company :      DEV MASTER PERU
 * Project :      DEV_WIFI_16ED.DM1
 * Author :       gmanriquev
 *
 * Date Created : Sunday, January 31, 2021 13:55:22
 * Target DBMS : Microsoft SQL Server 2008
 */

/* 
 * TABLE: Cliente 
 */

CREATE TABLE Cliente(
    codcliente        int             IDENTITY(1,1),
    codtipo           int             NOT NULL,
    numdoc            varchar(15)     NOT NULL,
    tipo_cliente      char(1)         NOT NULL,
    nombres           varchar(100)    NULL,
    ape_paterno       varchar(50)     NULL,
    ape_materno       varchar(50)     NULL,
    sexo              char(1)         NULL,
    fec_nacimiento    date            NULL,
    razon_social      varchar(100)    NULL,
    fec_inicio        date            NULL,
    direccion         varchar(250)    NOT NULL,
    email             varchar(320)    NULL,
    codzona           int             NOT NULL,
    estado            bit             NOT NULL,
    CONSTRAINT PK5 PRIMARY KEY NONCLUSTERED (codcliente)
)
go



IF OBJECT_ID('Cliente') IS NOT NULL
    PRINT '<<< CREATED TABLE Cliente >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Cliente >>>'
go

/* 
 * TABLE: Contrato 
 */

CREATE TABLE Contrato(
    codcliente          int              NOT NULL,
    codplan             int              NOT NULL,
    fec_contrato        date             NOT NULL,
    fec_baja            date             NULL,
    periodo             char(1)          NOT NULL,
    preciosol           decimal(6, 2)    NOT NULL,
    iprouter            varchar(16)      NOT NULL,
    ssis_red_wifi       varchar(50)      NULL,
    fec_registro        datetime         NOT NULL,
    fec_ultactualiza    datetime         NULL,
    estado              char(1)          NOT NULL,
    CONSTRAINT PK9 PRIMARY KEY NONCLUSTERED (codcliente, codplan, fec_contrato)
)
go



IF OBJECT_ID('Contrato') IS NOT NULL
    PRINT '<<< CREATED TABLE Contrato >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Contrato >>>'
go

/* 
 * TABLE: PlanInternet 
 */

CREATE TABLE PlanInternet(
    codplan        int              IDENTITY(1,1),
    nombre         varchar(50)      NOT NULL,
    precioref      decimal(6, 2)    NOT NULL,
    descripcion    varchar(100)     NULL,
    CONSTRAINT PK1 PRIMARY KEY NONCLUSTERED (codplan)
)
go



IF OBJECT_ID('PlanInternet') IS NOT NULL
    PRINT '<<< CREATED TABLE PlanInternet >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE PlanInternet >>>'
go

/* 
 * TABLE: Telefono 
 */

CREATE TABLE Telefono(
    tipo          varchar(3)     NOT NULL,
    numero        varchar(20)    NOT NULL,
    codcliente    int            NOT NULL,
    estado        bit            NOT NULL,
    CONSTRAINT PK6 PRIMARY KEY NONCLUSTERED (tipo, numero)
)
go



IF OBJECT_ID('Telefono') IS NOT NULL
    PRINT '<<< CREATED TABLE Telefono >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Telefono >>>'
go

/* 
 * TABLE: TipoDocumento 
 */

CREATE TABLE TipoDocumento(
    codtipo       int            IDENTITY(1,1),
    tipo_sunat    char(2)        NOT NULL,
    desc_larga    varchar(50)    NOT NULL,
    desc_corta    varchar(20)    NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY NONCLUSTERED (codtipo)
)
go



IF OBJECT_ID('TipoDocumento') IS NOT NULL
    PRINT '<<< CREATED TABLE TipoDocumento >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE TipoDocumento >>>'
go

/* 
 * TABLE: Ubigeo 
 */

CREATE TABLE Ubigeo(
    codubigeo    int            IDENTITY(1,1),
    cod_dpto     varchar(3)     NOT NULL,
    nom_dpto     varchar(50)    NOT NULL,
    cod_prov     varchar(3)     NOT NULL,
    nom_prov     varchar(50)    NOT NULL,
    cod_dto      char(3)        NOT NULL,
    nom_dto      varchar(80)    NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (codubigeo)
)
go



IF OBJECT_ID('Ubigeo') IS NOT NULL
    PRINT '<<< CREATED TABLE Ubigeo >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Ubigeo >>>'
go

/* 
 * TABLE: Zona 
 */

CREATE TABLE Zona(
    codzona      int             IDENTITY(1,1),
    nombre       varchar(100)    NOT NULL,
    codubigeo    int             NOT NULL,
    estado       bit             NOT NULL,
    CONSTRAINT PK4 PRIMARY KEY NONCLUSTERED (codzona)
)
go



IF OBJECT_ID('Zona') IS NOT NULL
    PRINT '<<< CREATED TABLE Zona >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Zona >>>'
go

/* 
 * TABLE: Cliente 
 */

ALTER TABLE Cliente ADD CONSTRAINT RefZona2 
    FOREIGN KEY (codzona)
    REFERENCES Zona(codzona)
go

ALTER TABLE Cliente ADD CONSTRAINT RefTipoDocumento4 
    FOREIGN KEY (codtipo)
    REFERENCES TipoDocumento(codtipo)
go


/* 
 * TABLE: Contrato 
 */

ALTER TABLE Contrato ADD CONSTRAINT RefPlanInternet7 
    FOREIGN KEY (codplan)
    REFERENCES PlanInternet(codplan)
go

ALTER TABLE Contrato ADD CONSTRAINT RefCliente9 
    FOREIGN KEY (codcliente)
    REFERENCES Cliente(codcliente)
go


/* 
 * TABLE: Telefono 
 */

ALTER TABLE Telefono ADD CONSTRAINT RefCliente5 
    FOREIGN KEY (codcliente)
    REFERENCES Cliente(codcliente)
go


/* 
 * TABLE: Zona 
 */

ALTER TABLE Zona ADD CONSTRAINT RefUbigeo1 
    FOREIGN KEY (codubigeo)
    REFERENCES Ubigeo(codubigeo)
go


