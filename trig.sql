CREATE TRIGGER trg_dim
ON CustomerDim
AFTER INSERT
AS
BEGIN
    -- Declare a variable to hold the current date
    DECLARE @CurrentDate DATE = GETDATE();
    
    -- Update existing records to set the EffectiveEndDate and IsCurrent flag
    UPDATE cd
    SET EffectiveEndDate = DATEADD(DAY, -1, @CurrentDate),
        IsCurrent = 0
    FROM CustomerDim cd
    INNER JOIN inserted i ON cd.CustomerID = i.CustomerID
    WHERE cd.IsCurrent = 1
      AND cd.CustomerID = i.CustomerID;
    
    -- Insert new records with updated EffectiveStartDate and default values
    INSERT INTO CustomerDim (CustomerID, CustomerName, Address, EffectiveStartDate, EffectiveEndDate, IsCurrent)
    SELECT i.CustomerID, i.CustomerName, i.Address, @CurrentDate, '9999-12-31', 1
    FROM inserted i;
END;
GO
