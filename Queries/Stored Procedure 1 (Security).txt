
-- Create a stored procedure to insert into Product (only for Managers)
CREATE PROCEDURE InsertProduct
    @Name VARCHAR(30),
    @Price DECIMAL
AS
BEGIN
    IF IS_MEMBER('Manager') = 1
    BEGIN
        INSERT INTO Product (Name, Price) VALUES (@Name, @Price);
    END
    ELSE
    BEGIN
        RAISERROR (15600, -1, -1, 'Insufficient Permission');
    END
END;

