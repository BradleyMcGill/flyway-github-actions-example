CREATE TABLE [dbo].[users]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[username] [nvarchar] (255) NOT NULL,
[test] [nvarchar] (255) NOT NULL,
[email] [nvarchar] (255) NOT NULL,
[password_hash] [nvarchar] (255) NOT NULL,
[created_at] [datetime2] NOT NULL CONSTRAINT [DF_users_created_at] DEFAULT (getutcdate()),
[updated_at] [datetime2] NOT NULL CONSTRAINT [DF_users_updated_at] DEFAULT (getutcdate())
)
GO
ALTER TABLE [dbo].[users] ADD CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([id])
GO
ALTER TABLE [dbo].[users] ADD CONSTRAINT [UQ_users_username] UNIQUE NONCLUSTERED ([username])
GO
ALTER TABLE [dbo].[users] ADD CONSTRAINT [UQ_users_email] UNIQUE NONCLUSTERED ([email])
GO
CREATE NONCLUSTERED INDEX [idx_users_email] ON [dbo].[users] ([email])
GO
