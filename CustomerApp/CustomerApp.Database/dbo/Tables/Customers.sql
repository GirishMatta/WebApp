CREATE TABLE [dbo].[Customers] (
    [CustomerID]   INT            IDENTITY (1, 1) NOT NULL,
    [CustomerName] NVARCHAR (100) NOT NULL,
    [City]         NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_dbo.Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);

