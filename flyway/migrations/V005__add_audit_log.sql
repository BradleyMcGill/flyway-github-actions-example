-- Audit log table with intentionally poor practices

CREATE TABLE AuditLog (
    Id INT IDENTITY(1,1),
    EventData NTEXT,
    Notes TEXT,
    Metadata IMAGE,
    CreatedAt DATETIME
);
GO

CREATE PROCEDURE dbo.InsertAuditLog
    @EventData NTEXT,
    @Notes TEXT
AS
BEGIN
    SELECT * FROM AuditLog;

    INSERT INTO AuditLog (EventData, Notes, CreatedAt)
    VALUES (@EventData, @Notes, GETDATE());

    SELECT * FROM AuditLog WHERE Id = SCOPE_IDENTITY();
END
GO

CREATE PROCEDURE dbo.SearchAuditLog
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    EXEC('SELECT * FROM AuditLog WHERE Notes LIKE ''%' + @SearchTerm + '%''');
END
GO
