USE [CrmDb]
GO
/****** Object:  StoredProcedure [dbo].[Account_SelectByID]    Script Date: Ср 27.05.20 10:39:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[Account_SelectByID]
		@Id bigint
as
begin
	select	
		a.Id,
		a.Balance,
		a.CurrencyId,	
		a.LeadId,
		a.Timestamp,
		a.IsDeleted,
		c.Id,
		c.Name,
		c.Code
	from dbo.[Account] a
	left join dbo.Currency c on a.CurrencyId = c.Id
	where a.Id = @Id and a.IsDeleted = 0
end
