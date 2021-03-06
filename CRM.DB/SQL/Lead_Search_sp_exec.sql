drop proc if exists dbo.Lead_Search_sp_exec
go

create proc dbo.Lead_Search_sp_exec
		@Id bigint = null,
		@IdOperator int = null,
		@IdEnd int = null,
		@FirstName nvarchar(100) = null,
		@FirstNameOperator int = null,
		@LastName nvarchar(100) = null,
		@LastNameOperator int = null,
		@Patronymic nvarchar(100) = null,
		@PatronymicOperator int = null,
		@BirthDate datetime2(7) = null,
		@BirthDateOperator int = null,		
		@BirthDateDateEnd datetime2(7) = null,
		@Phone nvarchar(30) = null,
		@PhoneOperator int = null,
		@Email nvarchar(100) = null,
		@EmailOperator int = null,
		@Login nvarchar(100) = null,
		@LoginOperator int = null,
		@CityId int = null,
		@CitiesValues nvarchar(100) = null,
		@RegistrationDate datetime2(7) = null,
		@RegistrationDateOperator int = null,
		@RegistrationDateEnd datetime2(7) = null,
		@IsDeletedInclude bit = 0,
		@AccountId  bigint = null
as 
begin 
	declare @sql nvarchar(max),
			@ParameterDef nvarchar(max),
			@OperatorId nvarchar(30),
			@OperatorFirstName nvarchar(30),
			@OperatorLastName nvarchar(30),
			@OperatorPatronymic nvarchar(30),
			@OperatorBirthDate nvarchar(30),
			@OperatorPhone nvarchar(30),
			@OperatorEmail nvarchar(30),
			@OperatorLogin nvarchar(30),
			@OperatorRegistrationDate nvarchar(30)

	set @ParameterDef = '@Id bigint,
						@IdOperator int,
						@IdEnd int,
						@CityId int,
						@CitiesValues nvarchar(100),
						@FirstName nvarchar(100),
						@FirstNameOperator int,
						@LastName nvarchar(100),
						@LastNameOperator int,
						@Patronymic nvarchar(100),
						@PatronymicOperator int,
						@BirthDate datetime2(7),
						@BirthDateOperator int,		
						@BirthDateDateEnd datetime2(7),
						@RegistrationDate datetime2(7),
						@RegistrationDateOperator int,
						@RegistrationDateEnd datetime2(7),
						@Phone nvarchar(30),
						@PhoneOperator int,
						@Email nvarchar(100),
						@EmailOperator int,
						@Login nvarchar(100),
						@LoginOperator int,
						@IsDeletedInclude bit,
						@AccountId  bigint '
	set @sql = N' select	
				l.Id,
				l.FirstName,
				l.LastName,
				l.Patronymic,
				l.BirthDate,
				l.Phone,
				l.Email,
				l.Login,
				l.RegistrationDate,
				l.LastUpdateDate,
				l.IsDeleted,
				l.CityId,
				c.Id,
				c.Name,
				a.Id,
				a.Balance,
				cur.Id,
				cur.Code,
				cur.Name
		
				from dbo.[Lead] l
				inner join dbo.City c on c.Id = l.CityId
				left join dbo.Account a on a.LeadId = l.Id
				left join dbo.Currency cur on a.CurrencyId = cur.Id
				where 1 = 1 '

	set @OperatorId	= case @IdOperator
						when 1 then ' < '
						when 2 then ' > '
						else ' = '
						end					
	set @OperatorBirthDate = case @BirthDateOperator
						when 1 then ' < '
						when 2 then ' > '
						else ' = '
						end
	set @OperatorRegistrationDate = case @RegistrationDateOperator
						when 1 then ' < '
						when 2 then ' > '
						else ' = '
						end
	set @OperatorFirstName	= case @FirstNameOperator
						when 3 then ' like '
						else ' = '
						end
	set @OperatorLastName	= case @LastNameOperator
						when 3 then ' like '
						else ' = '
						end
	set @OperatorPatronymic	= case @PatronymicOperator
						when 3 then ' like '
						else ' = '
						end
	set @OperatorPhone	= case @PhoneOperator
						when 3 then ' like '
						else ' = '
						end
	set @OperatorEmail	= case @EmailOperator
						when 3 then ' like '
						else ' = '
						end
	set @OperatorLogin	= case @LoginOperator
						when 3 then ' like '
						else ' = '
						end
									  
	if @Id is not null and @Id != 0 and @IdEnd is null
	set @sql=@sql + N'and l.Id ' + @OperatorId + ' @Id '

	if @Id is not null and @Id != 0 and @IdEnd is not null and @IdEnd != 0 
	set @sql=@sql + N'and l.Id between @Id and @IdEnd '
	
	if @FirstName is not null and @FirstName <> ''
	set @sql=@sql + N'and l.FirstName' + @OperatorFirstName +' @FirstName '

	if @LastName is not null and @LastName != ''
	set @sql=@sql + N'and l.LastName'+ @OperatorLastName + ' @LastName ' 

	if @Patronymic is not null and @Patronymic != ''
	set @sql=@sql + N'and l.Patronymic'+ @OperatorPatronymic + ' @Patronymic '

	if @Phone is not null and @Phone != ''
	set @sql=@sql + N'and l.Phone'+ @OperatorPhone + '@Phone '

	if @Email is not null and @Email != ''
	set @sql=@sql + N'and l.Email' + @OperatorEmail + ' @Email ' 
	 
	if @Login is not null and @Login != ''
	set @sql=@sql + N'and l.Login'+ @OperatorLogin + ' @Login ' 

	if @BirthDate is not null and @BirthDate != '' and @BirthDateDateEnd is null
	set @sql=@sql + N'and l.BirthDate' + @OperatorBirthDate + '@BirthDate '
	
	if @BirthDate is not null and @BirthDate != '' and @BirthDateDateEnd is not null 
	set @sql=@sql + N'and l.BirthDate between @BirthDate and @BirthDateDateEnd '
	
	if @RegistrationDate is not null and @RegistrationDate != '' and @RegistrationDateEnd is null 
	set @sql=@sql + N'and l.RegistrationDate' + @OperatorRegistrationDate + ' @RegistrationDate '
	
	if @RegistrationDate is not null and @RegistrationDate != '' and @RegistrationDateEnd is not null and @RegistrationDateEnd != ''
	set @sql=@sql + N'and l.RegistrationDate between @RegistrationDate and @RegistrationDateEnd '	

	if @IsDeletedInclude = 0
	set @sql=@sql + N'and l.IsDeleted = 0'

	if @IsDeletedInclude = 1 
	set @sql=@sql + N'and l.IsDeleted = 1'

	if @CityId is not null and @CityId != 0 and @CitiesValues is null
	set @sql=@sql + N'and c.Id = @CityId '
	
	if @CitiesValues is not null and @CitiesValues != ''
	set @sql=@sql + N'and c.Id in ( '+ @CitiesValues +' ) '
	
	if @AccountId is not null and @AccountId != ''
	set @sql=@sql + N'and a.Id = @AccountId '


	print @sql

	EXEC sp_Executesql @SQL, @ParameterDef, 
							@Id =@Id, 
							@IdOperator = @IdOperator, 
							@IdEnd = @IdEnd, 
							@FirstName = @FirstName, 
							@FirstNameOperator = @FirstNameOperator, 
							@LastName = @LastName, 
							@LastNameOperator = @LastNameOperator, 
							@Patronymic = @Patronymic,
							@PatronymicOperator = @PatronymicOperator,
							@BirthDate = @BirthDate,
							@BirthDateOperator = @BirthDateOperator,		
							@BirthDateDateEnd = @BirthDateDateEnd,
							@Phone = @Phone,
							@PhoneOperator = @PhoneOperator,
							@Email = @Email,
							@EmailOperator = @EmailOperator,
							@Login = @Login,
							@LoginOperator = @LoginOperator,
							@RegistrationDate = @RegistrationDate,
							@RegistrationDateOperator = @RegistrationDateOperator,
							@RegistrationDateEnd = @RegistrationDateEnd,
							@CityId = @CityId,
							@CitiesValues = @CitiesValues,
							@IsDeletedInclude = @IsDeletedInclude,
							@AccountId  = @AccountId 
end 

-- @Id
-- exec [dbo].[Lead_Search_sp_exec] @Id = 1254280, @IdEnd =1254283
-- exec [dbo].[Lead_Search_sp_exec] @Id = 100, @IdOperator = 1
--@CityId
-- exec [dbo].[Lead_Search_sp_exec] @CityId = 3
-- exec [dbo].[Lead_Search_sp_exec] @CitiesValues = '1, 2'
-- exec [dbo].[Lead_Search_sp_exec] 101
-- @FirstName
-- exec [dbo].[Lead_Search_sp_exec] @FirstName = 'Бела'
-- exec [dbo].[Lead_Search_sp_exec] @FirstName = '%ана', @FirstNameOperator = 3 
-- @LastName
-- exec [dbo].[Lead_Search_sp_exec] @LastName = 'Файнс'
-- exec [dbo].[Lead_Search_sp_exec] @LastName = '%мова', @LastNameOperator = 3 
-- exec [dbo].[Lead_Search_sp_exec] @Id = 1254218, @IdOperator = 2, @LastName = '%мова', @LastNameOperator = 3 
-- @Patronymic
-- exec [dbo].[Lead_Search_sp_exec] @Patronymic = 'Алексеевна'
-- exec [dbo].[Lead_Search_sp_exec] @Patronymic = '%еевна', @PatronymicOperator = 3
-- exec [dbo].[Lead_Search_sp_exec] @Patronymic = 'Петрович', '1997-05-17', 2
--@BirthDate
-- exec [dbo].[Lead_Search_sp_exec] @BirthDate = '1956-03-10' 
-- exec [dbo].[Lead_Search_sp_exec] @BirthDate = '1960-01-01' , @BirthDateOperator = 1
-- exec [dbo].[Lead_Search_sp_exec] @BirthDate = '2001-01-01' , @BirthDateOperator = 2
-- exec [dbo].[Lead_Search_sp_exec] @BirthDate = '1997-05-01', @BirthDateDateEnd ='1997-05-02'
--@RegistrationDate
-- exec [dbo].[Lead_Search_sp_exec] @RegistrationDate = '2020-04-20'
-- exec [dbo].[Lead_Search_sp_exec] @RegistrationDate= '2020-01-01', @RegistrationDateOperator = 2
--@Phone
-- exec [dbo].[Lead_Search_sp_exec] @Phone = '+7-923-2606848'
-- exec [dbo].[Lead_Search_sp_exec] @Phone ='%606848', @PhoneOperator = 3
--@Email
-- exec [dbo].[Lead_Search_sp_exec] @Email = 'blpgctV@gmail.com'
-- exec [dbo].[Lead_Search_sp_exec] @Email = 'blpgct%', @EmailOperator = 3
--@Login
-- exec [dbo].[Lead_Search_sp_exec] @Login = 'Tcgplbyl25'
-- exec [dbo].[Lead_Search_sp_exec] @Login = 'Tcga%', @LoginOperator = 3
--@AccountId 
-- exec [dbo].[Lead_Search_sp_exec] @AccountId  = 45
--@IsDeletedInclude
-- exec [dbo].[Lead_Search_sp_exec] @AccountId = 787, @IsDeletedInclude = 1
-- exec [dbo].[Lead_Search_sp_exec] @IsDeletedInclude = 1


-- set statistics time on exec [dbo].[Lead_Search_sp_exec] @Id = 1200000, @IdOperator = 2, @LastName = '%ва', @LastNameOperator = 3, @Patronymic = '%вна', @PatronymicOperator = 3, @RegistrationDate= '2020-01-01', @RegistrationDateOperator = 2, @Email = '%fgdgdgmail.com', @EmailOperator = 3 set statistics time off


