SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating [dbo].[orders]'
GO
CREATE TABLE [dbo].[orders]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[user_id] [int] NOT NULL,
[total_amount] [decimal] (10, 2) NOT NULL,
[status] [nvarchar] (50) NOT NULL CONSTRAINT [DF_orders_status] DEFAULT ('pending'),
[created_at] [datetime2] NOT NULL CONSTRAINT [DF_orders_created_at] DEFAULT (getutcdate()),
[updated_at] [datetime2] NOT NULL CONSTRAINT [DF_orders_updated_at] DEFAULT (getutcdate())
)
GO
PRINT N'Creating primary key [PK_orders] on [dbo].[orders]'
GO
ALTER TABLE [dbo].[orders] ADD CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED ([id])
GO
PRINT N'Creating index [idx_orders_status] on [dbo].[orders]'
GO
CREATE NONCLUSTERED INDEX [idx_orders_status] ON [dbo].[orders] ([status])
GO
PRINT N'Creating index [idx_orders_user_id] on [dbo].[orders]'
GO
CREATE NONCLUSTERED INDEX [idx_orders_user_id] ON [dbo].[orders] ([user_id])
GO
PRINT N'Creating [dbo].[users]'
GO
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
PRINT N'Creating primary key [PK_users] on [dbo].[users]'
GO
ALTER TABLE [dbo].[users] ADD CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([id])
GO
PRINT N'Creating index [idx_users_email] on [dbo].[users]'
GO
CREATE NONCLUSTERED INDEX [idx_users_email] ON [dbo].[users] ([email])
GO
PRINT N'Adding constraints to [dbo].[users]'
GO
ALTER TABLE [dbo].[users] ADD CONSTRAINT [UQ_users_email] UNIQUE NONCLUSTERED ([email])
GO
PRINT N'Adding constraints to [dbo].[users]'
GO
ALTER TABLE [dbo].[users] ADD CONSTRAINT [UQ_users_username] UNIQUE NONCLUSTERED ([username])
GO
PRINT N'Adding foreign keys to [dbo].[orders]'
GO
ALTER TABLE [dbo].[orders] ADD CONSTRAINT [FK_orders_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id])
GO

