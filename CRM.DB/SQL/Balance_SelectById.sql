drop proc if exists dbo.Balance_SelectById
go

create proc dbo.Balance_SelectById
		@Id bigint
as
begin
	select	
		a.Balance
	from dbo.[Account] a
	where a.Id = @Id and a.IsDeleted = 0
end
