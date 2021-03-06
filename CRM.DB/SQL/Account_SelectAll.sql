USE [CrmDb]
GO
/****** Object:  StoredProcedure [dbo].[Account_SelectAll]    Script Date: Ср 27.05.20 10:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Account_SelectAll]
as
begin
	select
		a.Id,
		a.LeadId,
		a.Balance,
		a.Timestamp,
		a.CurrencyId as 'Id',
		a.IsDeleted,
		c.Name,
		c.Code
	from dbo.Account a
	left join dbo.Currency c on c.Id=a.CurrencyId
	where IsDeleted = 0
end