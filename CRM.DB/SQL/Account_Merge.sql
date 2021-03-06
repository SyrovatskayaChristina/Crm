USE [CrmDb]
GO
/****** Object:  StoredProcedure [dbo].[Account_Merge]    Script Date: Ср 27.05.20 10:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[Account_Merge]
	@Id bigint,
	@LeadId bigint,
	@CurrencyId int
as
begin 
merge 
	dbo.Account a
using 
	(values (@Id))p (Id) on a.Id = p.Id
when matched then 
   update set  LeadId = @LeadId ,
	 			CurrencyId = @CurrencyId,
	 			Timestamp = getdate()
when not matched then 
	insert (LeadId,
	 		CurrencyId,
	 		Balance,
	 		Timestamp,
			IsDeleted)

	values (@LeadId,
			@CurrencyId, 
			0,
			getdate(),
			0);
			select scope_identity();
end

-- exec Account_Merge 1, 32, 1
-- select * from dbo.Account where Id = 792
