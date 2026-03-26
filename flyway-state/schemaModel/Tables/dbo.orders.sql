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
ALTER TABLE [dbo].[orders] ADD CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED ([id])
GO
CREATE NONCLUSTERED INDEX [idx_orders_user_id] ON [dbo].[orders] ([user_id])
GO
CREATE NONCLUSTERED INDEX [idx_orders_status] ON [dbo].[orders] ([status])
GO
ALTER TABLE [dbo].[orders] ADD CONSTRAINT [FK_orders_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id])
GO
