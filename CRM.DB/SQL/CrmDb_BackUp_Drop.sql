drop proc if exists dbo.CrmDb_BackUp_Drop
go

create proc dbo.CrmDb_BackUp_Drop
as
begin
	drop database if exists CrmDb_Restored 
end