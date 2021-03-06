USE [CrmDb]
GO
/****** Object:  StoredProcedure [dbo].[Account_AddMany]    Script Date: Ср 27.05.20 10:39:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
ALTER proc [dbo].[Account_AddMany]	 
		
as 
begin 
	declare	@LeadId bigint,
			@CurrencyId int,
			@Balance money,
			@Timestamp datetime2(7),
			@IsDeleted bit,
			@Counter int,
			@AccCounter int

	set @Counter = 0	
	set @AccCounter = 0	

	declare	LeadId_Cursor cursor for
	select l.Id
	from dbo.[Lead] l
	where l.Id > 155 and l.Id < 161

	open LeadId_Cursor

	fetch next from LeadId_Cursor
	into @LeadId

	while @@fetch_status = 0
	begin	
		fetch next from LeadId_Cursor 
		into @LeadId

		set @AccCounter = (select (ROUND(1+(RAND(CHECKSUM(NEWID()))*15),0)))

		while @AccCounter > 0
		begin
			set @CurrencyId = (select (ROUND(1+(RAND(CHECKSUM(NEWID()))*4),0)))
			set @Balance = (select (ROUND(1000+(RAND(CHECKSUM(NEWID()))*1000000),0)))
			set @Timestamp = (select dateadd(day, rand(checksum(newid()))*(1+datediff(day, '2015-01-01', '2020-05-05')), '2015-01-01'))
			set @IsDeleted = (SELECT CAST(ROUND(RAND(),0) AS BIT))
			insert into dbo.Account
					(LeadId,
	 				CurrencyId,
	 				Balance,
	 				Timestamp,
					IsDeleted)
			values (@LeadId,
					@CurrencyId, 
					@Balance,
					@Timestamp,
					@IsDeleted);
			set @AccCounter = @AccCounter - 1
		end
	end
	close LeadId_Cursor;  
    deallocate LeadId_Cursor; 
end 

-- exec dbo.Account_AddMany	