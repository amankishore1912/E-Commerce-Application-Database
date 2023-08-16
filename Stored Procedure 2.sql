-- Create stored procedure to retrieve sensitive order data
CREATE PROCEDURE GetSensitiveOrderData
    @UserID INT
AS
BEGIN
    IF IS_MEMBER('Admin') = 1 OR USER_ID() = @UserID
    BEGIN
        SELECT * FROM Orders;
    END
    ELSE
    BEGIN
        RAISERROR (15600, -1, -1, 'Insufficient Permission');
    END
END;