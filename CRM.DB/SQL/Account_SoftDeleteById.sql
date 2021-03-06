USE [CrmDb]
GO
/****** Object:  StoredProcedure [dbo].[Account_SoftDeleteById]    Script Date: Ср 27.05.20 10:40:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[Account_SoftDeleteById]
        @Id bigint
as
begin
	update dbo.[Account]
	set IsDeleted = 1,
		Timestamp = getdate()
	where Id = @Id
end

--exec Account_SoftDeleteById 5