-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-01-25 16:34:19.019

-- tables
-- Table: Batch
CREATE TABLE Batch (
    BatchID int  NOT NULL,
    ProductionDate date  NOT NULL,
    Quantity int  NOT NULL,
    ProductID int  NOT NULL,
    CONSTRAINT Batch_pk PRIMARY KEY (BatchID)
);

-- Table: Customer
CREATE TABLE Customer (
    CustomerID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    ContactInfo varchar(100)  NOT NULL,
    Preferences varchar(100)  NULL,
    CONSTRAINT Customer_pk PRIMARY KEY (CustomerID)
);

-- Table: CustomerFeedback
CREATE TABLE CustomerFeedback (
    FeedbackID int  NOT NULL,
    Date date  NOT NULL,
    Comment int  NOT NULL,
    ProductID int  NOT NULL,
    CustomerID int  NOT NULL,
    CONSTRAINT CustomerFeedback_pk PRIMARY KEY (FeedbackID)
);

-- Table: Department
CREATE TABLE Department (
    DepartmentID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    Adress varchar(100)  NOT NULL,
    CONSTRAINT Department_pk PRIMARY KEY (DepartmentID)
);

-- Table: Employee
CREATE TABLE Employee (
    EmployeeId int  NOT NULL,
    Name varchar(100)  NOT NULL,
    Position varchar(100)  NOT NULL,
    HireDate varchar(100)  NOT NULL,
    Salary money  NOT NULL,
    DepartmentID int  NOT NULL,
    CONSTRAINT Employee_pk PRIMARY KEY (EmployeeId)
);

-- Table: Ingridient
CREATE TABLE Ingridient (
    IngredientID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    Description varchar(100)  NOT NULL,
    Allergen varchar(100)  NULL,
    SupplierID int  NOT NULL,
    CONSTRAINT Ingridient_pk PRIMARY KEY (IngredientID)
);

-- Table: MarkCompaing
CREATE TABLE MarkCompaing (
    CompaingID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    startdate date  NOT NULL,
    enddate date  NOT NULL,
    TargetDemografic varchar(100)  NOT NULL,
    CONSTRAINT MarkCompaing_pk PRIMARY KEY (CompaingID)
);

-- Table: ProductIngredient
CREATE TABLE ProductIngredient (
    ProductIngredientID int  NOT NULL,
    ProductID int  NOT NULL,
    IngredientID int  NOT NULL,
    CONSTRAINT ProductIngredient_pk PRIMARY KEY (ProductIngredientID)
);

-- Table: QualityTest
CREATE TABLE QualityTest (
    TestID int  NOT NULL,
    Date date  NOT NULL,
    TestRes int  NOT NULL,
    BatchID int  NOT NULL,
    CONSTRAINT QualityTest_pk PRIMARY KEY (TestID)
);

-- Table: Supplier
CREATE TABLE Supplier (
    SupplierID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    ContactInfo varchar(100)  NOT NULL,
    Adress varchar(100)  NOT NULL,
    CONSTRAINT Supplier_pk PRIMARY KEY (SupplierID)
);

-- Table: product
CREATE TABLE product (
    ProductID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    LaunchDate date  NOT NULL,
    Type varchar(100)  NOT NULL,
    EmployeeId int  NOT NULL,
    CONSTRAINT product_pk PRIMARY KEY (ProductID)
);

-- Table: productinCompaing
CREATE TABLE productinCompaing (
    ProductInCompaingID int  NOT NULL,
    ProductID int  NOT NULL,
    CompaingID int  NOT NULL,
    CONSTRAINT productinCompaing_pk PRIMARY KEY (ProductInCompaingID)
);

-- Table: sale
CREATE TABLE sale (
    SaleID int  NOT NULL,
    Date date  NOT NULL,
    ProductID int  NOT NULL,
    CustomerID int  NOT NULL,
    CONSTRAINT sale_pk PRIMARY KEY (SaleID)
);

-- End of file.

