

-- Procedure to remove expired log files that say NO WORK
ALTER PROCEDURE [dbo].[SobekCM_Builder_Expire_Log_Entries]
	@Retain_For_Days int
AS 
BEGIN
	-- Calculate the expiration date time
	declare @expiredate datetime;
	set @expiredate = dateadd(day, (-1 * @Retain_For_Days), getdate());
	set @expiredate = dateadd(hour, -1 * datepart(hour,@expiredate), @expiredate);
	
	-- Delete all logs from before this time
	delete from SobekCM_Builder_Log
	where ( LogDate <= @expiredate )
	  and ( LogType = 'No Work' );

END;
GO





-- Procedure returns builder logs, by date range and/or by bibid_vid
CREATE PROCEDURE SobekCM_Builder_Log_Search
	@startdate datetime,
	@enddate datetime,
	@bibid_vid varchar(20)
AS
BEGIN

	-- Set the start date and end date if they are null
	if ( @startdate is null ) set @startdate = '1/1/2000';
	if ( @enddate is null ) set @enddate = dateadd(day, 1, getdate());

	-- If the @bibid_vid is NULL or empty, than this is only a date search
	if ( len(coalesce(@bibid_vid,'')) = 0 )
	begin
		-- Date search only
		select BuilderLogID, RelatedBuilderLogID, LogDate, BibID_VID, LogType, LogMessage, SuccessMessage, METS_Type
		from SobekCM_Builder_Log
		where ( LogDate >= @startdate )
		  and ( LogDate <= @enddate )
		order by LogDate ASC;

		return;
	end;

	-- Is this a LIKE search, or an exact search?
	if ( charindex('%', @bibid_vid ) > 0 )
	begin
		-- This is a LIKE expression
		select BuilderLogID, RelatedBuilderLogID, LogDate, BibID_VID, LogType, LogMessage, SuccessMessage, METS_Type
		from SobekCM_Builder_Log
		where ( LogDate >= @startdate )
		  and ( LogDate <= @enddate )
		  and ( BibID_VID like @bibid_vid )
		order by LogDate ASC;
	end
	else
	begin
		-- This is an EXACT match
		select BuilderLogID, RelatedBuilderLogID, LogDate, BibID_VID, LogType, LogMessage, SuccessMessage, METS_Type
		from SobekCM_Builder_Log
		where ( LogDate >= @startdate )
		  and ( LogDate <= @enddate )
		  and ( BibID_VID = @bibid_vid )
		order by LogDate ASC;
	end;
END;
GO