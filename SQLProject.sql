--Stored Procedure 1: Add a New Batch
--Use Case Scenario: Add a New Batch
--Actor: Production Manager
--Main Use Case Scenario
--1.Production Manager starts the use case by providing the ProductionDate, Quantity, and ProductID.
--2.System checks whether the product exists.
--3.System generates a new BatchID.
--4.System inserts a new record into the Batch table with the provided details and generated BatchID.
--Alternative Scenarios
--2.1. Product does not exist. System returns an exception.

CREATE PROCEDURE AddBatch
    @ProductionDate DATE,
    @Quantity INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM product WHERE ProductID = @ProductID)
    BEGIN
        RAISERROR('Product does not exist', 16, 1);
        RETURN;
    END

    DECLARE @BatchID INT = (SELECT ISNULL(MAX(BatchID), 0) + 1 FROM Batch);

    INSERT INTO Batch (BatchID, ProductionDate, Quantity, ProductID)
    VALUES (@BatchID, @ProductionDate, @Quantity, @ProductID);
END


--Stored Procedure 2: Update Employee Salary
--Use Case Scenario: Update Employee Salary
--Actor: HR Manager
--Main Use Case Scenario
--1.HR Manager starts the use case by providing the EmployeeId and NewSalary.
--2.System checks whether the employee exists.
--3.System validates that the new salary is above the minimum threshold.
--4.System updates the salary of the employee in the Employee table.
--Alternative Scenarios
--2.1. Employee does not exist. System returns an exception. 3.1. Salary is below the minimum threshold. System returns an exception.

CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeId INT,
    @NewSalary MONEY
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Employee WHERE EmployeeId = @EmployeeId)
    BEGIN
        RAISERROR('Employee does not exist', 16, 1);
        RETURN;
    END

    IF @NewSalary < 30000
    BEGIN
        RAISERROR('Salary must be at least 30000', 16, 1);
        RETURN;
    END

    UPDATE Employee
    SET Salary = @NewSalary
    WHERE EmployeeId = @EmployeeId;
END

--Stored Procedure 3: List Customer Feedback for a Product 
--Use Case Scenario: List Customer Feedback for a Product
--Actor: Customer Service Manager
--Main Use Case Scenario
--1.Customer Service Manager starts the use case by providing the ProductID.
--2.System retrieves all customer feedback from the CustomerFeedback table for the specified product.
--3.System iterates through each feedback entry and prints its details.
--4.System completes the procedure.
--Alternative Scenarios
--2.1. No feedback found for the specified product. System prints a message indicating no feedback is available.

CREATE PROCEDURE ListCustomerFeedbackForProduct
    @ProductID INT
AS
BEGIN
    DECLARE @FeedbackID INT, @Date DATE, @Comment INT, @CustomerID INT;
    DECLARE FeedbackCursor CURSOR FOR
    SELECT FeedbackID, Date, Comment, CustomerID
    FROM CustomerFeedback
    WHERE ProductID = @ProductID;

    OPEN FeedbackCursor;

    FETCH NEXT FROM FeedbackCursor INTO @FeedbackID, @Date, @Comment, @CustomerID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'FeedbackID: ' + CAST(@FeedbackID AS VARCHAR(10)) + 
              ', Date: ' + CAST(@Date AS VARCHAR(10)) + 
              ', Comment: ' + CAST(@Comment AS VARCHAR(10)) + 
              ', CustomerID: ' + CAST(@CustomerID AS VARCHAR(10));

        FETCH NEXT FROM FeedbackCursor INTO @FeedbackID, @Date, @Comment, @CustomerID;
    END

    CLOSE FeedbackCursor;
    DEALLOCATE FeedbackCursor;
END

--Trigger 1: Prevent Deletion of Employees in Departments
--Use Case Scenario: Prevent Deletion of Last Employee in a Department
--Actor: Database Administrator
--Main Use Case Scenario
--1.Database Administrator attempts to delete an employee.
--2.System checks if the employee being deleted is the last employee in their department.
--3.If the department would be left without employees, system prevents the deletion.
--Alternative Scenarios
--2.1. Employee is not the last one in the department. System allows the deletion to proceed.

	CREATE TRIGGER PreventLastEmployeeDeletion
ON Employee
AFTER DELETE
AS
BEGIN
    DECLARE @DepartmentID INT;
    DECLARE DeletedEmployeesCursor CURSOR FOR
    SELECT DepartmentID FROM Deleted;

    OPEN DeletedEmployeesCursor;
    FETCH NEXT FROM DeletedEmployeesCursor INTO @DepartmentID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF (SELECT COUNT(*) FROM Employee WHERE DepartmentID = @DepartmentID) = 0
        BEGIN
            RAISERROR('Cannot delete the last employee in a department', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        FETCH NEXT FROM DeletedEmployeesCursor INTO @DepartmentID;
    END

    CLOSE DeletedEmployeesCursor;
    DEALLOCATE DeletedEmployeesCursor;
END

--Trigger 2: Prevent Deletion of Products in Active Marketing Campaigns
--Use Case Scenario: Prevent Deletion of Products in Active Marketing Campaigns
--Actor: Database Administrator
--Main Use Case Scenario
--1.Database Administrator attempts to delete a product.
--2.System checks if the product is part of any active marketing campaign.
--3.If the product is part of an active campaign, system prevents the deletion.
--Alternative Scenarios
--2.1. Product is not part of any active campaign. System allows the deletion to proceed.


CREATE TRIGGER PreventDeleteActiveCampaignProduct
ON product
AFTER DELETE
AS
BEGIN
    DECLARE @ProductID INT;
    DECLARE @CurrentDate DATE = GETDATE();

    DECLARE DeletedProductsCursor CURSOR FOR
    SELECT ProductID FROM Deleted;

    OPEN DeletedProductsCursor;
    FETCH NEXT FROM DeletedProductsCursor INTO @ProductID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        IF EXISTS (
            SELECT 1
            FROM productinCompaing pc
            JOIN MarkCompaing mc ON pc.CompaingID = mc.CompaingID
            WHERE pc.ProductID = @ProductID
            AND mc.startdate <= @CurrentDate
            AND mc.enddate >= @CurrentDate
        )
        BEGIN
            RAISERROR('This product cannot be deleted as it is part of an active marketing campaign.', 16, 1, @ProductID);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        FETCH NEXT FROM DeletedProductsCursor INTO @ProductID;
    END

    CLOSE DeletedProductsCursor;
    DEALLOCATE DeletedProductsCursor;
END