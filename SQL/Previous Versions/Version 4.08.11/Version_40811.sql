-- THIS GOES FROM 4_08_10 to 4_08_11


-- Add the main web content table
IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SobekCM_WebContent'))
BEGIN
	CREATE TABLE [dbo].[SobekCM_WebContent](
		[WebContentID] [int] IDENTITY(1,1) NOT NULL,
		[Level1] [varchar](100) NOT NULL,
		[Level2] [varchar](100) NULL,
		[Level3] [varchar](100) NULL,
		[Level4] [varchar](100) NULL,
		[Level5] [varchar](100) NULL,
		[Level6] [varchar](100) NULL,
		[Level7] [varchar](100) NULL,
		[Level8] [varchar](100) NULL,
		[Deleted] bit NOT NULL default('false'),
		[Title] nvarchar(255) NULL,
		[Summary] nvarchar(1000) NULL
	 CONSTRAINT [PK_SobekCM_WebContent] PRIMARY KEY CLUSTERED 
	(
		[WebContentID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY];
END;
GO

-- Just double check these columns were added
if ( NOT EXISTS (select * from sys.columns where Name = N'Title' and Object_ID = Object_ID(N'SobekCM_WebContent')))
BEGIN
	ALTER TABLE [dbo].SobekCM_WebContent add Title nvarchar(255) null;
END;
GO

-- Just double check these columns were added
if ( NOT EXISTS (select * from sys.columns where Name = N'Summary' and Object_ID = Object_ID(N'SobekCM_WebContent')))
BEGIN
	ALTER TABLE [dbo].SobekCM_WebContent add Summary nvarchar(1000) null;
END;
GO


-- Add the main web content table
IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SobekCM_WebContent_Milestones'))
BEGIN
	CREATE TABLE [dbo].[SobekCM_WebContent_Milestones](
		[WebContentMilestoneID] [int] IDENTITY(1,1) NOT NULL,
		[WebContentID] [int] NOT NULL,
		[Milestone] [nvarchar](max) NOT NULL,
		[MilestoneDate] [date] NOT NULL,
		[MilestoneUser] [nvarchar](100) NOT NULL,
	 CONSTRAINT [PK_SobekCM_WebContent_Milestones] PRIMARY KEY CLUSTERED 
	(
		[WebContentMilestoneID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

	
	ALTER TABLE [dbo].[SobekCM_WebContent_Milestones]  WITH CHECK ADD  CONSTRAINT [FK_SobekCM_WebContent_Milestones_SobekCM_WebContent] FOREIGN KEY([WebContentID])
	REFERENCES [dbo].[SobekCM_WebContent] ([WebContentID]);
END;
GO

-- Add column to reference back to the SobekCM_Web_Content table
if ( NOT EXISTS (select * from sys.columns where Name = N'WebContentID' and Object_ID = Object_ID(N'SobekCM_WebContent_Statistics')))
BEGIN
	ALTER TABLE [dbo].SobekCM_WebContent_Statistics add WebContentID int;
END;
GO

-- Drop index, if it exists (it shouldn't though)
if ( EXISTS ( select 1 from sys.indexes WHERE name='IX_SobekCM_WebContent_Levels' AND object_id = OBJECT_ID('SobekCM_WebContent')))
	DROP INDEX [IX_SobekCM_WebContent_Levels] ON [dbo].[SobekCM_WebContent]
GO

/****** Object:  Index [IX_SobekCM_WebContent_Levels]    Script Date: 6/4/2015 6:54:09 AM ******/
CREATE NONCLUSTERED INDEX [IX_SobekCM_WebContent_Levels] ON [dbo].[SobekCM_WebContent]
(
	[Level1] ASC,
	[Level2] ASC,
	[Level3] ASC,
	[Level4] ASC,
	[Level5] ASC,
	[Level6] ASC,
	[Level7] ASC,
	[Level8] ASC
)
INCLUDE ( 	[WebContentID], [Deleted], [Title], [Summary])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- Drop index, if it exists (it shouldn't though)
if ( EXISTS ( select 1 from sys.indexes WHERE name='IX_SobekCM_WebContent_Milestones_Date_ID' AND object_id = OBJECT_ID('SobekCM_WebContent_Milestones')))
	DROP INDEX IX_SobekCM_WebContent_Milestones_Date_ID ON [dbo].SobekCM_WebContent_Milestones
GO

/****** Object:  Index [IX_SobekCM_WebContent_Milestones_Date_ID]    Script Date: 6/4/2015 6:55:43 AM ******/
CREATE NONCLUSTERED INDEX [IX_SobekCM_WebContent_Milestones_Date_ID] ON [dbo].[SobekCM_WebContent_Milestones]
(
	[WebContentID] ASC,
	[MilestoneDate] ASC
)
INCLUDE ( 	[MilestoneUser]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- Drop index, if it exists (it shouldn't though)
if ( EXISTS ( select 1 from sys.indexes WHERE name='IX_SobekCM_WebContent_Stats_ID' AND object_id = OBJECT_ID('SobekCM_WebContent_Statistics')))
	DROP INDEX IX_SobekCM_WebContent_Stats_ID ON [dbo].SobekCM_WebContent_Statistics
GO


/****** Object:  Index [IX_SobekCM_WebContent_Stats_ID]    Script Date: 6/4/2015 7:08:06 AM ******/
CREATE NONCLUSTERED INDEX [IX_SobekCM_WebContent_Stats_ID] ON [dbo].[SobekCM_WebContent_Statistics]
(
	[WebContentID] ASC
)
INCLUDE ( 	[Year],
	[Month],
	[Hits],
	[Hits_Complete]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



-- Esure the SobekCM_WebContent_Add stored procedure exists
IF object_id('SobekCM_WebContent_Add') IS NULL EXEC ('create procedure dbo.SobekCM_WebContent_Add as select 1;');
GO

-- Add a new web content page
ALTER PROCEDURE SobekCM_WebContent_Add
	@Level1 varchar(100),
	@Level2 varchar(100),
	@Level3 varchar(100),
	@Level4 varchar(100),
	@Level5 varchar(100),
	@Level6 varchar(100),
	@Level7 varchar(100),
	@Level8 varchar(100),
	@UserName nvarchar(100),
	@Title nvarchar(255),
	@Summary nvarchar(1000),
	@WebContentID int output
AS
BEGIN	
	-- Is there a match already for this?
	if ( EXISTS ( select 1 from SobekCM_WebContent where Level1=@Level1 and Level2=@Level2 and Level3=@Level3 and Level4=@Level4 and Level5=@Level5 and Level6=@Level6 and Level7=@Level7 and Level8=@Level8 ))
	begin
		-- Get the web content id
		set @WebContentID = ( select WebContentID from SobekCM_WebContent where Level1=@Level1 and Level2=@Level2 and Level3=@Level3 and Level4=@Level4 and Level5=@Level5 and Level6=@Level6 and Level7=@Level7 and Level8=@Level8 );

		-- Ensure the title and summary are correct
		update SobekCM_WebContent set Title=@Title, Summary=@Summary where WebContentID=@WebContentID;
		
		-- Was this previously deleted?
		if ( EXISTS ( select 1 from SobekCM_WebContent where Deleted='true' and WebContentID=@WebContentID ))
		begin
			-- Undelete this 
			update SobekCM_WebContent
			set Deleted='false'
			where WebContentID = @WebContentID;

			-- Mark this in the milestones then
			insert into SobekCM_WebContent_Milestones ( WebContentID, Milestone, MilestoneDate, MilestoneUser )
			values ( @WebContentID, 'Restored previously deleted page', getdate(), @UserName );
		end;
	end
	else
	begin
		-- Add the new web content then
		insert into SobekCM_WebContent ( Level1, Level2, Level3, Level4, Level5, Level6, Level7, Level8, Title, Summary, Deleted )
		values ( @Level1, @Level2, @Level3, @Level4, @Level5, @Level6, @Level7, @Level8, @Title, @Summary, 'false' );

		-- Get the new ID for this
		set @WebContentID = SCOPE_IDENTITY();

		-- Now, add this to the milestones table
		insert into SobekCM_WebContent_Milestones ( WebContentID, Milestone, MilestoneDate, MilestoneUser )
		values ( @WebContentID, 'Add new page', getdate(), @UserName );
	end;
END;
GO


-- Esure the SobekCM_WebContent_Edit stored procedure exists
IF object_id('SobekCM_WebContent_Edit') IS NULL EXEC ('create procedure dbo.SobekCM_WebContent_Edit as select 1;');
GO

-- Edit basic information on an existing web content page
ALTER PROCEDURE SobekCM_WebContent_Edit
	@WebContentID int,
	@UserName nvarchar(100),
	@Title nvarchar(255),
	@Summary nvarchar(1000)
AS
BEGIN	
	-- Make the change
	update SobekCM_WebContent
	set Title=@Title, Summary=@Summary
	where WebContentID=@WebContentID;
END;
GO


-- Esure the SobekCM_WebContent_Get_Page stored procedure exists
IF object_id('SobekCM_WebContent_Get_Page') IS NULL EXEC ('create procedure dbo.SobekCM_WebContent_Get_Page as select 1;');
GO

-- Get basic details about an existing web content page
ALTER PROCEDURE SobekCM_WebContent_Get_Page
	@Level1 varchar(100),
	@Level2 varchar(100),
	@Level3 varchar(100),
	@Level4 varchar(100),
	@Level5 varchar(100),
	@Level6 varchar(100),
	@Level7 varchar(100),
	@Level8 varchar(100)
AS
BEGIN	
	-- Return the couple of requested pieces of information
	select top 1 W.WebContentID, W.Title, W.Summary, W.Deleted, M.MilestoneDate, M.MilestoneUser
	from SobekCM_WebContent W left outer join
	     SobekCM_WebContent_Milestones M on W.WebContentID=M.WebContentID
	where ( Level1=@Level1 and Level2=@Level2 and Level3=@Level3 and Level4=@Level4 and Level5=@Level5 and Level6=@Level6 and Level7=@Level7 and Level8=@Level8 )
	order by M.MilestoneDate DESC;
END;
GO

-- Esure the SobekCM_WebContent_Add_Milestone stored procedude exists
IF object_id('SobekCM_WebContent_Add_Milestone') IS NULL EXEC ('create procedure dbo.SobekCM_WebContent_Add_Milestone as select 1;');
GO

-- Add a new milestone to an existing web content page
ALTER PROCEDURE SobekCM_WebContent_Add_Milestone
	@WebContentID int,
	@Milestone nvarchar(max),
	@MilestoneUser nvarchar(100)
AS
BEGIN

	-- Insert milestone
	insert into SobekCM_WebContent_Milestones ( WebContentID, Milestone, MilestoneUser, MilestoneDate )
	values ( @WebContentID, @Milestone, @MilestoneUser, getdate());

END;
GO



-- Esure the SobekCM_WebContent_Delete stored procedude exists
IF object_id('SobekCM_WebContent_Delete') IS NULL EXEC ('create procedure dbo.SobekCM_WebContent_Delete as select 1;');
GO

-- Delete an existing web content page (and mark in the milestones)
ALTER PROCEDURE SobekCM_WebContent_Delete
	@WebContentID int,
	@Reason nvarchar(max),
	@MilestoneUser nvarchar(100)
AS
BEGIN

	-- Mark web page as deleted
	update SobekCM_WebContent
	set Deleted='true'
	where WebContentID=@WebContentID;

	-- Add a milestone for this
	if (( @Reason is not null ) and ( len(@Reason) > 0 ))
	begin
		insert into SobekCM_WebContent_Milestones ( WebContentID, Milestone, MilestoneUser, MilestoneDate )
		values ( @WebContentID, 'Page Deleted - ' + @Reason, @MilestoneUser, getdate());
	end
	else
	begin
		insert into SobekCM_WebContent_Milestones ( WebContentID, Milestone, MilestoneUser, MilestoneDate )
		values ( @WebContentID, 'Page Deleted', @MilestoneUser, getdate());
	end;

END;
GO

-- Esure the SobekCM_WebContent_Get_Usage stored procedude exists
IF object_id('SobekCM_WebContent_Get_Usage') IS NULL EXEC ('create procedure dbo.SobekCM_WebContent_Get_Usage as select 1;');
GO

-- Get the usage stats for a webcontent page (by ID)
ALTER PROCEDURE SobekCM_WebContent_Get_Usage
	@WebContentID int
AS
BEGIN

	-- Get all stats
	select [Year], [Month], Hits, Hits_Complete
	from SobekCM_WebContent_Statistics
	where WebContentID=@WebContentID
	order by [Year], [Month];

END;
GO

-- Esure the SobekCM_WebContent_Get_Milestones stored procedude exists
IF object_id('SobekCM_WebContent_Get_Milestones') IS NULL EXEC ('create procedure dbo.SobekCM_WebContent_Get_Milestones as select 1;');
GO

-- Get the milestones for a webcontent page (by ID)
ALTER PROCEDURE SobekCM_WebContent_Get_Milestones
	@WebContentID int
AS
BEGIN

	-- Get all milestones
	select Milestone, MilestoneDate, MilestoneUser
	from SobekCM_WebContent_Milestones
	where WebContentID=@WebContentID
	order by MilestoneDate;

END;
GO

-- Esure the SobekCM_WebContent_Get_Recent_Changes stored procedude exists
IF object_id('SobekCM_WebContent_Get_Recent_Changes') IS NULL EXEC ('create procedure dbo.SobekCM_WebContent_Get_Recent_Changes as select 1;');
GO

-- Get the list of recent changes to all web content pages
ALTER PROCEDURE SobekCM_WebContent_Get_Recent_Changes
AS
BEGIN

	-- Get all milestones
	select W.WebContentID, W.Level1, W.Level2, W.Level3, W.Level4, W.Level5, W.Level6, W.Level7, W.Level8, MilestoneDate, MilestoneUser, Milestone, W.Title
	from SobekCM_WebContent_Milestones M, SobekCM_WebContent W
	order by MilestoneDate DESC;

END;
GO


-- Stored procedure to save the basic item aggregation information
ALTER PROCEDURE [dbo].[SobekCM_Save_Item_Aggregation]
	@aggregationid int,
	@code varchar(20),
	@name nvarchar(255),
	@shortname nvarchar(100),
	@description nvarchar(1000),
	@thematicHeadingId int,
	@type varchar(50),
	@isactive bit,
	@hidden bit,
	@display_options varchar(10),
	@map_search tinyint,
	@map_display tinyint,
	@oai_flag bit,
	@oai_metadata nvarchar(2000),
	@contactemail varchar(255),
	@defaultinterface varchar(10),
	@externallink nvarchar(255),
	@parentid int,
	@username varchar(100),
	@languageVariants varchar(500),
	@newaggregationid int output
AS
begin transaction

	-- Set flag to see if this was basically just created (either new or undeleted)
	declare @newly_added bit;
	set @newly_added = 'false';

   -- If the aggregation id is less than 1 then this is for a new aggregation
   if ((@aggregationid  < 1 ) and (( select COUNT(*) from SobekCM_Item_Aggregation where Code=@code ) = 0 ))
   begin

		-- Insert a new row
		insert into SobekCM_Item_Aggregation(Code, [Name], Shortname, Description, ThematicHeadingID, [Type], isActive, Hidden, DisplayOptions, Map_Search, Map_Display, OAI_Flag, OAI_Metadata, ContactEmail, HasNewItems, DefaultInterface, External_Link, DateAdded, LanguageVariants )
		values(@code, @name, @shortname, @description, @thematicHeadingId, @type, @isActive, @hidden, @display_options, @map_search, @map_display, @oai_flag, @oai_metadata, @contactemail, 'false', @defaultinterface, @externallink, GETDATE(), @languageVariants );

		-- Get the primary key
		set @newaggregationid = @@identity;
       
		-- insert the CREATED milestone
		insert into [SobekCM_Item_Aggregation_Milestones] ( AggregationID, Milestone, MilestoneDate, MilestoneUser )
		values ( @newaggregationid, 'Created', getdate(), @username );

		-- Since this was a brand new, set flag
		set @newly_added='true';
   end
   else
   begin

	  -- Add special code to indicate if this aggregation was undeleted
	  if ( exists ( select 1 from SobekCM_Item_Aggregation where Code=@Code and Deleted='true'))
	  begin
		declare @deletedid int;
		set @deletedid = ( select aggregationid from SobekCM_Item_Aggregation where Code=@Code );

		-- insert the UNDELETED milestone
		insert into [SobekCM_Item_Aggregation_Milestones] ( AggregationID, Milestone, MilestoneDate, MilestoneUser )
		values ( @deletedid, 'Created (undeleted as previously existed)', getdate(), @username );

		-- Since this was undeleted, let's make sure this collection isn't linked 
		-- to any parent collections
		delete from SobekCM_Item_Aggregation_Hierarchy
		where ChildID=@deletedid;

		-- Since this was UNDELETED, set flag
		set @newly_added='true';
	  end;

      -- Update the existing row
      update SobekCM_Item_Aggregation
      set  
		Code = @code,
		[Name] = @name,
		ShortName = @shortname,
		[Description] = @description,
		ThematicHeadingID = @thematicHeadingID,
		[Type] = @type,
		isActive = @isactive,
		Hidden = @hidden,
		DisplayOptions = @display_options,
		Map_Search = @map_search,
		Map_Display = @map_display,
		OAI_Flag = @oai_flag,
		OAI_Metadata = @oai_metadata,
		ContactEmail = @contactemail,
		DefaultInterface = @defaultinterface,
		External_Link = @externallink,
		Deleted = 'false',
		DeleteDate = null,
		LanguageVariants = @languageVariants
      where AggregationID = @aggregationid or Code = @code;

      -- Set the return value to the existing id
      set @newaggregationid = ( select aggregationid from SobekCM_Item_Aggregation where Code=@Code );

   end;

	-- Was a parent id provided
	if ( isnull(@parentid, -1 ) > 0 )
	begin
		-- Now, see if the link to the parent exists
		if (( select count(*) from SobekCM_Item_Aggregation_Hierarchy H where H.ParentID = @parentid and H.ChildID = @newaggregationid ) < 1 )
		begin			
			insert into SobekCM_Item_Aggregation_Hierarchy ( ParentID, ChildID )
			values ( @parentid, @newaggregationid );
		end;

		-- If this was newly added (new or undeleted), ensure permissions copied over from parent
		if ( @newly_added = 'true' )
		begin
			-- Add individual user permissions first
			insert into mySobek_User_Edit_Aggregation ( UserID, AggregationID, CanSelect, CanEditItems, 
				IsCurator, IsAdmin, CanEditMetadata, CanEditBehaviors, CanPerformQc, 
				CanUploadFiles, CanChangeVisibility, CanDelete )
			select UserID, @newaggregationid, CanSelect, CanEditItems, 
				IsCurator, IsAdmin, CanEditMetadata, CanEditBehaviors, CanPerformQc, 
				CanUploadFiles, CanChangeVisibility, CanDelete
			from mySobek_User_Edit_Aggregation A
			where ( AggregationID = @parentid )
			  and ( not exists ( select * from mySobek_User_Edit_Aggregation L where L.UserID=A.UserID and L.AggregationID=@newaggregationid ))
			  and (    ( CanEditMetadata='true' ) 
	                or ( CanEditBehaviors='true' )
	                or ( CanPerformQc='true' )
	                or ( CanUploadFiles='true' )
	                or ( CanChangeVisibility='true' )
	                or ( IsCurator='true' )
	                or ( IsAdmin='true' ));

			-- Add user group permissions next 
			insert into mySobek_User_Group_Edit_Aggregation ( UserGroupID, AggregationID, CanSelect, CanEditItems, 
				IsCurator, IsAdmin, CanEditMetadata, CanEditBehaviors, CanPerformQc, 
				CanUploadFiles, CanChangeVisibility, CanDelete )
			select UserGroupID, @newaggregationid, CanSelect, CanEditItems, 
				IsCurator, IsAdmin, CanEditMetadata, CanEditBehaviors, CanPerformQc, 
				CanUploadFiles, CanChangeVisibility, CanDelete
			from mySobek_User_Group_Edit_Aggregation A
			where ( AggregationID = @parentid )
			  and ( not exists ( select * from mySobek_User_Group_Edit_Aggregation L where L.UserGroupID=A.UserGroupID and L.AggregationID=@newaggregationid ))
			  and (    ( CanEditMetadata='true' ) 
	                or ( CanEditBehaviors='true' )
	                or ( CanPerformQc='true' )
	                or ( CanUploadFiles='true' )
	                or ( CanChangeVisibility='true' )
	                or ( IsCurator='true' )
	                or ( IsAdmin='true' ));
		end;
	end;

commit transaction;
GO



-- Esure the SobekCM_Save_Item_Behaviors_Minimal exists
IF object_id('SobekCM_Save_Item_Behaviors_Minimal') IS NULL EXEC ('create procedure dbo.SobekCM_Save_Item_Behaviors_Minimal as select 1;');
GO

-- Saves the behavior information about an item in this library
-- Written by Mark Sullivan 
ALTER PROCEDURE [dbo].[SobekCM_Save_Item_Behaviors_Minimal]
	@ItemID int,
	@TextSearchable bit,
	@Viewer1_TypeID int,
	@Viewer1_Label nvarchar(50),
	@Viewer1_Attribute nvarchar(250),
	@Viewer2_TypeID int,
	@Viewer2_Label nvarchar(50),
	@Viewer2_Attribute nvarchar(250),
	@Viewer3_TypeID int,
	@Viewer3_Label nvarchar(50),
	@Viewer3_Attribute nvarchar(250),
	@Viewer4_TypeID int,
	@Viewer4_Label nvarchar(50),
	@Viewer4_Attribute nvarchar(250),
	@Viewer5_TypeID int,
	@Viewer5_Label nvarchar(50),
	@Viewer5_Attribute nvarchar(250),
	@Viewer6_TypeID int,
	@Viewer6_Label nvarchar(50),
	@Viewer6_Attribute nvarchar(250)
AS
begin transaction

	--Update the main item
	update SobekCM_Item
	set TextSearchable = @TextSearchable
	where ( ItemID = @ItemID );
	
	-- Add the first viewer information
	if (( @Viewer1_TypeID > 0 ) and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer1_TypeID )))
	begin
		-- Insert this viewer information
		insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
		values ( @ItemID, @Viewer1_TypeID, @Viewer1_Attribute, @Viewer1_Label );
	end;
	
	-- Add the second viewer information
	if (( @Viewer2_TypeID > 0 ) and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer2_TypeID )))
	begin
		-- Insert this viewer information
		insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
		values ( @ItemID, @Viewer2_TypeID, @Viewer2_Attribute, @Viewer2_Label );
	end;
	
	-- Add the third viewer information
	if (( @Viewer3_TypeID > 0 ) and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer3_TypeID )))
	begin
		-- Insert this viewer information
		insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
		values ( @ItemID, @Viewer3_TypeID, @Viewer3_Attribute, @Viewer3_Label );
	end;
	
	-- Add the fourth viewer information
	if (( @Viewer4_TypeID > 0 ) and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer4_TypeID )))
	begin
		-- Insert this viewer information
		insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
		values ( @ItemID, @Viewer4_TypeID, @Viewer4_Attribute, @Viewer4_Label );
	end;
	
	-- Add the fifth viewer information
	if (( @Viewer5_TypeID > 0 ) and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer5_TypeID )))
	begin
		-- Insert this viewer information
		insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
		values ( @ItemID, @Viewer5_TypeID, @Viewer5_Attribute, @Viewer5_Label );
	end;
	
	-- Add the first viewer information
	if (( @Viewer6_TypeID > 0 ) and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer6_TypeID )))
	begin
		-- Insert this viewer information
		insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
		values ( @ItemID, @Viewer6_TypeID, @Viewer6_Attribute, @Viewer6_Label );
	end;

commit transaction
GO

GRANT EXECUTE ON [dbo].[SobekCM_Save_Item_Behaviors_Minimal] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_Save_Item_Behaviors_Minimal] to sobek_builder;
GRANT EXECUTE ON [dbo].[SobekCM_Statistics_Aggregate] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_Statistics_Aggregate] to sobek_builder;
GRANT EXECUTE ON [dbo].[SobekCM_WebContent_Add] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_WebContent_Edit] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_WebContent_Get_Page] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_WebContent_Add_Milestone] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_WebContent_Delete] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_WebContent_Get_Usage] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_WebContent_Get_Milestones] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_WebContent_Get_Recent_Changes] to sobek_user;
GO



/****** Object:  StoredProcedure [dbo].[SobekCM_Metadata_Search_Paged2]    Script Date: 12/20/2013 05:43:37 ******/
-- Perform metadata search 
ALTER PROCEDURE [dbo].[SobekCM_Metadata_Search_Paged]
	@link1 int,
	@term1 nvarchar(255),
	@field1 int,
	@link2 int,
	@term2 nvarchar(255),
	@field2 int,
	@link3 int,
	@term3 nvarchar(255),
	@field3 int,
	@link4 int,
	@term4 nvarchar(255),
	@field4 int,
	@link5 int,
	@term5 nvarchar(255),
	@field5 int,
	@link6 int,
	@term6 nvarchar(255),
	@field6 int,
	@link7 int,
	@term7 nvarchar(255),
	@field7 int,
	@link8 int,
	@term8 nvarchar(255),
	@field8 int,
	@link9 int,
	@term9 nvarchar(255),
	@field9 int,
	@link10 int,
	@term10 nvarchar(255),
	@field10 int,
	@include_private bit,
	@aggregationcode varchar(20),	
	@daterange_start bigint,
	@daterange_end bigint,
	@pagesize int, 
	@pagenumber int,
	@sort int,
	@minpagelookahead int,
	@maxpagelookahead int,
	@lookahead_factor float,
	@include_facets bit,
	@facettype1 smallint,
	@facettype2 smallint,
	@facettype3 smallint,
	@facettype4 smallint,
	@facettype5 smallint,
	@facettype6 smallint,
	@facettype7 smallint,
	@facettype8 smallint,
	@total_items int output,
	@total_titles int output,
	@all_collections_items int output,
	@all_collections_titles int output	
AS
BEGIN
	-- No need to perform any locks here, especially given the possible
	-- length of this search
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	-- Field#'s indicate which metadata field (if any).  These are numbers from the 
	-- SobekCM_Metadata_Types table.  A field# of -1, means all fields are included.
	
	-- Link#'s indicate if this is an AND-joiner ( intersect ) or an OR-joiner ( union )
	-- 0 = AND, 1 = OR, 2 = AND NOT
	
	-- Examples of using this procedure are:
	-- exec SobekCM_Metadata_Search 'haiti',1,0,'kesse',4,0,'',0
	-- This searches for materials which have haiti in the title AND kesse in the creator
	
	-- exec SobekCM_Metadata_Search 'haiti',1,1,'kesse',-1,0,'',0
	-- This searches for materials which have haiti in the title OR kesse anywhere
	
	-- Create the temporary table variables first
	-- Create the temporary table to hold all the item id's
	create table #TEMPZERO ( ItemID int primary key );
	create table #TEMP_ITEMS ( ItemID int primary key, fk_TitleID int, Hit_Count int, SortDate bigint );
		    
	-- declare both the sql query and the parameter definitions
	declare @SQLQuery AS nvarchar(max);
	declare @rankselection AS nvarchar(1000);
    declare @ParamDefinition AS NVarchar(2000);
		
    -- Determine the aggregationid
	declare @aggregationid int;
	set @aggregationid = coalesce(( select AggregationID from SobekCM_Item_Aggregation where Code=@aggregationcode ), -1);
	
	-- Get the sql which will be used to return the aggregation-specific display values for all the items in this page of results
	declare @item_display_sql nvarchar(max);
	if ( @aggregationid < 0 )
	begin
		select @item_display_sql=coalesce(Browse_Results_Display_SQL, 'select S.ItemID, S.Publication_Date, S.Creator, S.[Publisher.Display], S.Format, S.Edition, S.Material, S.Measurements, S.Style_Period, S.Technique, S.[Subjects.Display], S.Source_Institution, S.Donor from SobekCM_Metadata_Basic_Search_Table S, @itemtable T where S.ItemID = T.ItemID;')
		from SobekCM_Item_Aggregation
		where Code='all';
	end
	else
	begin
		select @item_display_sql=coalesce(Browse_Results_Display_SQL, 'select S.ItemID, S.Publication_Date, S.Creator, S.[Publisher.Display], S.Format, S.Edition, S.Material, S.Measurements, S.Style_Period, S.Technique, S.[Subjects.Display], S.Source_Institution, S.Donor from SobekCM_Metadata_Basic_Search_Table S, @itemtable T where S.ItemID = T.ItemID;')
		from SobekCM_Item_Aggregation
		where AggregationID=@aggregationid;
	end;
	
    -- Set value for filtering privates
	declare @lower_mask int;
	set @lower_mask = 0;
	if ( @include_private = 'true' )
	begin
		set @lower_mask = -256;
	end;
	    
    -- Start to build the main bulk of the query   
	set @SQLQuery = '';
	
	-- Start with the date range information, if this includes a date range search
	if ( @daterange_end > 0 )
	begin
		set @SQLQuery = 'L.SortDate > ' + cast(@daterange_start as nvarchar(12)) + ' and L.SortDate < ' +  cast(@daterange_end as nvarchar(12)) + ' and ';	
	end;
    
    -- Was a field listed?
    if (( @field1 > 0 ) and ( @field1 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
    begin
		-- Was this an AND, OR, or AND NOT?
		if ( @link1 = 2 ) set @SQLQuery = @SQLQuery + ' not';

		-- Get the name of this column then
		declare @field1_name varchar(100);
		set @field1_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field1 );

		-- Add this search then
		set @SQLQuery = @SQLQuery + ' contains ( ' + @field1_name + ', @innerterm1 )';
	end
	else
	begin
		-- Search the full citation then
		set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm1 )';	
	end;
            
    -- Start to build the query which will do ranking over the results which match this search
    set @rankselection = @term1;

	-- Add the second term, if there is one
	if (( LEN( ISNULL(@term2,'')) > 0 ) and (( @link2 = 0 ) or ( @link2 = 1 ) or ( @link2 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link2 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link2 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link2 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field2 > 0 ) and ( @field2 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field2_name varchar(100);
			set @field2_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field2 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field2_name + ', @innerterm2 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm2 )';	
		end;			
		
		-- Build the ranking query
		if ( @link2 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term2;	
		end
	end;    
	
	-- Add the third term, if there is one
	if (( LEN( ISNULL(@term3,'')) > 0 ) and (( @link3 = 0 ) or ( @link3 = 1 ) or ( @link3 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link3 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link3 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link3 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field3 > 0 ) and ( @field3 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field3_name varchar(100);
			set @field3_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field3 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field3_name + ', @innerterm3 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm3 )';	
		end;	
		
		-- Build the ranking query
		if ( @link3 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term3;		
		end
	end;   
	
	-- Add the fourth term, if there is one
	if (( LEN( ISNULL(@term4,'')) > 0 ) and (( @link4 = 0 ) or ( @link4 = 1 ) or ( @link4 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link4 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link4 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link4 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field4 > 0 ) and ( @field4 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field4_name varchar(100);
			set @field4_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field4 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field4_name + ', @innerterm4 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm4 )';	
		end;	
			
		-- Build the ranking query
		if ( @link4 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term4;		
		end
	end;
	
	-- Add the fifth term, if there is one
	if (( LEN( ISNULL(@term5,'')) > 0 ) and (( @link5 = 0 ) or ( @link5 = 1 ) or ( @link5 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link5 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link5 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link5 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field5 > 0 ) and ( @field5 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field5_name varchar(100);
			set @field5_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field5 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field5_name + ', @innerterm5 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm5 )';	
		end;
			
		-- Build the ranking query
		if ( @link5 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term5;		
		end
	end;
	
	-- Add the sixth term, if there is one
	if (( LEN( ISNULL(@term6,'')) > 0 ) and (( @link6 = 0 ) or ( @link6 = 1 ) or ( @link6 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link6 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link6 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link6 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field6 > 0 ) and ( @field6 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field6_name varchar(100);
			set @field6_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field6 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field6_name + ', @innerterm6 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm6 )';	
		end;
		
		-- Build the ranking query
		if ( @link6 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term6;		
		end
	end; 
	
	-- Add the seventh term, if there is one
	if (( LEN( ISNULL(@term7,'')) > 0 ) and (( @link7 = 0 ) or ( @link7 = 1 ) or ( @link7 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link7 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link7 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link7 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field7 > 0 ) and ( @field7 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field7_name varchar(100);
			set @field7_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field7 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field7_name + ', @innerterm7 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm7 )';	
		end;
		
		-- Build the ranking query
		if ( @link7 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term7;		
		end
	end;
	
	-- Add the eighth term, if there is one
	if (( LEN( ISNULL(@term8,'')) > 0 ) and (( @link8 = 0 ) or ( @link8 = 1 ) or ( @link8 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link8 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link8 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link8 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field8 > 0 ) and ( @field8 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field8_name varchar(100);
			set @field8_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field8 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field8_name + ', @innerterm8 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm8 )';	
		end;
		
		-- Build the ranking query
		if ( @link8 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term8;		
		end
	end;
	
	-- Add the ninth term, if there is one
	if (( LEN( ISNULL(@term9,'')) > 0 ) and (( @link9 = 0 ) or ( @link9 = 1 ) or ( @link9 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link9 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link9 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link9 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field9 > 0 ) and ( @field9 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field9_name varchar(100);
			set @field9_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field9 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field9_name + ', @innerterm9 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm9 )';	
		end;
		
		-- Build the ranking query
		if ( @link9 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term9;		
		end
	end;
	
	-- Add the tenth term, if there is one
	if (( LEN( ISNULL(@term10,'')) > 0 ) and (( @link10 = 0 ) or ( @link10 = 1 ) or ( @link10 = 2 )))
	begin	
		-- Was this an AND, OR, or AND NOT?
		if ( @link10 = 0 ) set @SQLQuery = @SQLQuery + ' and';
		if ( @link10 = 1 ) set @SQLQuery = @SQLQuery + ' or';
		if ( @link10 = 2 ) set @SQLQuery = @SQLQuery + ' and not';
		
		-- Was a field listed?
		if (( @field10 > 0 ) and ( @field10 in ( select MetadataTypeID from SobekCM_Metadata_Types )))
		begin
			-- Get the name of this column then
			declare @field10_name varchar(100);
			set @field10_name = ( select REPLACE(MetadataName, ' ', '_') from SobekCM_Metadata_Types where MetadataTypeID = @field10 );

			-- Add this search then
			set @SQLQuery = @SQLQuery + ' contains ( ' + @field10_name + ', @innerterm10 )';
		end
		else
		begin
			-- Search the full citation then
			set @SQLQuery = @SQLQuery + ' contains ( FullCitation, @innerterm10 )';	
		end;
		
		-- Build the ranking query
		if ( @link10 != 2 )
		begin
			set @rankselection = @rankselection + ' or ' + @term10;		
		end		
	end;
	
	-- Add the recompile option
	--set @SQLQuery = @SQLQuery + ' option (RECOMPILE)';

    -- Add the first term and start to build the query which will provide the items which match the search
    declare @mainquery nvarchar(max);
    set @mainquery = 'select L.Itemid from SobekCM_Metadata_Basic_Search_Table AS L';
    
    -- Do we need to limit by aggregation id as well?
    if ( @aggregationid > 0 )
    begin
		set @mainquery = @mainquery + ' join SobekCM_Item_Aggregation_Item_Link AS A ON ( A.ItemID = L.ItemID ) and ( A.AggregationID = ' + CAST( @aggregationid as varchar(5) ) + ')';   
    end    
    
    -- Add the full text search portion here
    set @mainquery = @mainquery + ' where ' + @SQLQuery;
	
	-- Set the parameter definition
	set @ParamDefinition = ' @innerterm1 nvarchar(255), @innerterm2 nvarchar(255), @innerterm3 nvarchar(255), @innerterm4 nvarchar(255), @innerterm5 nvarchar(255), @innerterm6 nvarchar(255), @innerterm7 nvarchar(255), @innerterm8 nvarchar(255), @innerterm9 nvarchar(255), @innerterm10 nvarchar(255)';
		
	-- Execute this stored procedure
	insert #TEMPZERO execute sp_Executesql @mainquery, @ParamDefinition, @term1, @term2, @term3, @term4, @term5, @term6, @term7, @term8, @term9, @term10;

	-- DEBUG
	--declare @tempzero_count int;
	--set @tempzero_count = (select count(*) from #TEMPZERO );
	--print '-- #TEMPZERO count = ' + cast(@tempzero_count as varchar(10));
			
	-- Perform ranking against the items and insert into another temporary table 
	-- with all the possible data elements needed for applying the user's sort
	insert into #TEMP_ITEMS ( ItemID, fk_TitleID, SortDate, Hit_Count )
	select I.ItemID, I.GroupID, SortDate=isnull( I.SortDate,-1), isnull(KEY_TBL.RANK, 0 )
	from #TEMPZERO AS T1 inner join
		 SobekCM_Item as I on T1.ItemID=I.ItemID left outer join
		 CONTAINSTABLE(SobekCM_Metadata_Basic_Search_Table, FullCitation, @rankselection ) AS KEY_TBL on KEY_TBL.[KEY] = T1.ItemID
	where ( I.Deleted = 'false' )
      and ( I.IP_Restriction_Mask >= @lower_mask )	
      and ( I.IncludeInAll = 'true' );    

	-- DEBUG
	-- print '-- @rankselection = ' + @rankselection;
	-- select * from #TEMP_ITEMS;
	-- declare @tempitems_count int;
	-- set @tempitems_count = ( select count(*) from #TEMP_ITEMS);
	-- print '-- ##TEMP_ITEMS count = ' + cast(@tempitems_count as varchar(10));

	-- Determine the start and end rows
	declare @rowstart int;
	declare @rowend int;
	set @rowstart = (@pagesize * ( @pagenumber - 1 )) + 1;
	set @rowend = @rowstart + @pagesize - 1; 
	
	-- If there were no results at all, check the count in the entire library
	if ( ( select COUNT(*) from #TEMP_ITEMS ) = 0 )
	begin
		-- Set the items and titles correctly
		set @total_items = 0;
		set @total_titles = 0;
		
		-- If there was an aggregation id, just return the counts for the whole library
		if ( @aggregationid > 0 )	
		begin
		
			-- Truncate the table and repull the data
			truncate table #TEMPZERO;
			
			-- Query against ALL aggregations this time
			declare @allquery nvarchar(max);
			set @allquery = 'select L.Itemid from SobekCM_Metadata_Basic_Search_Table AS L where ' + @SQLQuery;
			
			-- Execute this stored procedure
			insert #TEMPZERO execute sp_Executesql @allquery, @ParamDefinition, @term1, @term2, @term3, @term4, @term5, @term6, @term7, @term8, @term9, @term10;
			
			-- Get all items in the entire library then		  
			insert into #TEMP_ITEMS ( ItemID, fk_TitleID )
			select I.ItemID, I.GroupID
			from #TEMPZERO T1, SobekCM_Item I
			where ( T1.ItemID = I.ItemID )
			  and ( I.Deleted = 'false' )
			  and ( I.IP_Restriction_Mask >= @lower_mask )	
			  and ( I.IncludeInAll = 'true' );  
			  
			-- Return these counts
			select @all_collections_items=COUNT(*), @all_collections_titles=COUNT(distinct fk_TitleID)
			from #TEMP_ITEMS;
		end;
		
		-- Drop the big temporary table
		drop table #TEMPZERO;
	
	end
	else
	begin	
	
		-- Drop the big temporary table
		drop table #TEMPZERO;	
		
		-- Create the temporary item table variable for paging purposes
		declare @TEMP_PAGED_ITEMS TempPagedItemsTableType;
		  
		-- There are essentially two major paths of execution, depending on whether this should
		-- be grouped as items within the page requested titles ( sorting by title or the basic
		-- sorting by rank, which ranks this way ) or whether each item should be
		-- returned by itself, such as sorting by individual publication dates, etc..
		
		if ( @sort < 10 )
		begin	
			-- create the temporary title table definition
			declare @TEMP_TITLES table ( TitleID int, BibID varchar(10), RowNumber int );	
			
			-- Return these counts
			select @total_items=COUNT(*), @total_titles=COUNT(distinct fk_TitleID)
			from #TEMP_ITEMS;
			
			-- Now, calculate the actual ending row, based on the ration, page information,
			-- and the lookahead factor
			if (( @total_items > 0 ) and ( @total_titles > 0 ))
			begin		
				-- Compute equation to determine possible page value ( max - log(factor, (items/title)/2))
				declare @computed_value int;
				select @computed_value = (@maxpagelookahead - CEILING( LOG10( ((cast(@total_items as float)) / (cast(@total_titles as float)))/@lookahead_factor)));
				
				-- Compute the minimum value.  This cannot be less than @minpagelookahead.
				declare @floored_value int;
				select @floored_value = 0.5 * ((@computed_value + @minpagelookahead) + ABS(@computed_value - @minpagelookahead));
				
				-- Compute the maximum value.  This cannot be more than @maxpagelookahead.
				declare @actual_pages int;
				select @actual_pages = 0.5 * ((@floored_value + @maxpagelookahead) - ABS(@floored_value - @maxpagelookahead));

				-- Set the final row again then
				set @rowend = @rowstart + ( @pagesize * @actual_pages ) - 1; 
			end;	
					  
			-- Create saved select across titles for row numbers
			with TITLES_SELECT AS
				(	select GroupID, G.BibID, 
						ROW_NUMBER() OVER (order by case when @sort=0 THEN (SUM(Hit_COunt)/COUNT(*)) end DESC,
													case when @sort=1 THEN G.SortTitle end ASC,												
													case when @sort=2 THEN BibID end ASC,
													case when @sort=3 THEN BibID end DESC) as RowNumber
					from #TEMP_ITEMS I, SobekCM_Item_Group G
					where I.fk_TitleID = G.GroupID
					group by G.GroupID, G.BibID, G.SortTitle )

			-- Insert the correct rows into the temp title table	
			insert into @TEMP_TITLES ( TitleID, BibID, RowNumber )
			select GroupID, BibID, RowNumber
			from TITLES_SELECT
			where RowNumber >= @rowstart
			  and RowNumber <= @rowend;
		
			-- Return the title information for this page
			select RowNumber as TitleID, T.BibID, G.GroupTitle, G.ALEPH_Number as OPAC_Number, G.OCLC_Number, isnull(G.GroupThumbnail,'') as GroupThumbnail, G.[Type], isnull(G.Primary_Identifier_Type,'') as Primary_Identifier_Type, isnull(G.Primary_Identifier, '') as Primary_Identifier
			from @TEMP_TITLES T, SobekCM_Item_Group G
			where ( T.TitleID = G.GroupID )
			order by RowNumber ASC;
			
			-- Get the item id's for the items related to these titles
			insert into @TEMP_PAGED_ITEMS
			select ItemID, RowNumber
			from @TEMP_TITLES T, SobekCM_Item I
			where ( T.TitleID = I.GroupID );			  
			
			-- Return the basic system required item information for this page of results
			select T.RowNumber as fk_TitleID, I.ItemID, VID, Title, IP_Restriction_Mask, coalesce(I.MainThumbnail,'') as MainThumbnail, coalesce(I.Level1_Index, -1) as Level1_Index, coalesce(I.Level1_Text,'') as Level1_Text, coalesce(I.Level2_Index, -1) as Level2_Index, coalesce(I.Level2_Text,'') as Level2_Text, coalesce(I.Level3_Index,-1) as Level3_Index, coalesce(I.Level3_Text,'') as Level3_Text, isnull(I.PubDate,'') as PubDate, I.[PageCount], coalesce(I.Link,'') as Link, coalesce( Spatial_KML, '') as Spatial_KML, coalesce(COinS_OpenURL, '') as COinS_OpenURL		
			from SobekCM_Item I, @TEMP_PAGED_ITEMS T
			where ( T.ItemID = I.ItemID )
			order by T.RowNumber, Level1_Index, Level2_Index, Level3_Index;			
								
			-- Return the aggregation-specific display values for all the items in this page of results
			execute sp_Executesql @item_display_sql, N' @itemtable TempPagedItemsTableType READONLY', @TEMP_PAGED_ITEMS; 		

		end
		else
		begin		
			-- Since these sorts make each item paired with a single title row,
			-- number of items and titles are equal
			select @total_items=COUNT(*), @total_titles=COUNT(*)
			from #TEMP_ITEMS; 
			
			-- In addition, always return the max lookahead pages
			set @rowend = @rowstart + ( @pagesize * @maxpagelookahead ) - 1; 
			
			-- Create saved select across items for row numbers
			with ITEMS_SELECT AS
			 (	select I.ItemID, 
					ROW_NUMBER() OVER (order by case when @sort=10 THEN isnull(SortDate,9223372036854775807)  end ASC,
												case when @sort=11 THEN isnull(SortDate,-1) end DESC) as RowNumber
					from #TEMP_ITEMS I
					group by I.ItemID, SortDate )
						  
			-- Insert the correct rows into the temp item table	
			insert into @TEMP_PAGED_ITEMS ( ItemID, RowNumber )
			select ItemID, RowNumber
			from ITEMS_SELECT
			where RowNumber >= @rowstart
			  and RowNumber <= @rowend;
			  
			-- Return the title information for this page
			select RowNumber as TitleID, G.BibID, G.GroupTitle, G.ALEPH_Number as OPAC_Number, G.OCLC_Number, isnull(G.GroupThumbnail,'') as GroupThumbnail, G.[Type], isnull(G.Primary_Identifier_Type,'') as Primary_Identifier_Type, isnull(G.Primary_Identifier, '') as Primary_Identifier
			from @TEMP_PAGED_ITEMS T, SobekCM_Item I, SobekCM_Item_Group G
			where ( T.ItemID = I.ItemID )
			  and ( I.GroupID = G.GroupID )
			order by RowNumber ASC;
			
			-- Return the basic system required item information for this page of results
			select T.RowNumber as fk_TitleID, I.ItemID, VID, Title, IP_Restriction_Mask, coalesce(I.MainThumbnail,'') as MainThumbnail, coalesce(I.Level1_Index, -1) as Level1_Index, coalesce(I.Level1_Text,'') as Level1_Text, coalesce(I.Level2_Index, -1) as Level2_Index, coalesce(I.Level2_Text,'') as Level2_Text, coalesce(I.Level3_Index,-1) as Level3_Index, coalesce(I.Level3_Text,'') as Level3_Text, isnull(I.PubDate,'') as PubDate, I.[PageCount], coalesce(I.Link,'') as Link, coalesce( Spatial_KML, '') as Spatial_KML, coalesce(COinS_OpenURL, '') as COinS_OpenURL		
			from SobekCM_Item I, @TEMP_PAGED_ITEMS T
			where ( T.ItemID = I.ItemID )
			order by T.RowNumber, Level1_Index, Level2_Index, Level3_Index;			
			
			-- Return the aggregation-specific display values for all the items in this page of results
			execute sp_Executesql @item_display_sql, N' @itemtable TempPagedItemsTableType READONLY', @TEMP_PAGED_ITEMS; 

		end;

		-- Return the facets if asked for
		if ( @include_facets = 'true' )
		begin	
			if (( LEN( isnull( @aggregationcode, '')) = 0 ) or ( @aggregationcode = 'all' ))
			begin
				-- Build the aggregation list
				select A.Code, A.ShortName, Metadata_Count=Count(*)
				from SobekCM_Item_Aggregation A, SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item I, #TEMP_ITEMS T
				where ( T.ItemID = I.ItemID )
				  and ( I.ItemID = L.ItemID )
				  and ( L.AggregationID = A.AggregationID )
				  and ( A.Hidden = 'false' )
				  and ( A.isActive = 'true' )
				  and ( A.Include_In_Collection_Facet = 'true' )
				group by A.Code, A.ShortName
				order by Metadata_Count DESC, ShortName ASC;	
			end;
			
			-- Return the FIRST facet
			if ( @facettype1 > 0 )
			begin
				-- Return the first 100 values
				select MetadataValue, Metadata_Count
				from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
						from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
						where ( U.ItemID = I.ItemID )
						  and ( U.MetadataTypeID = @facettype1 )
						group by U.MetadataID
						order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
				where M.MetadataID = F.MetadataID
				order by Metadata_Count DESC, MetadataValue ASC;
			end;
			
			-- Return the SECOND facet
			if ( @facettype2 > 0 )
			begin
				-- Return the first 100 values
				select MetadataValue, Metadata_Count
				from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
						from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
						where ( U.ItemID = I.ItemID )
						  and ( U.MetadataTypeID = @facettype2 )
						group by U.MetadataID
						order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
				where M.MetadataID = F.MetadataID
				order by Metadata_Count DESC, MetadataValue ASC;
			end;
			
			-- Return the THIRD facet
			if ( @facettype3 > 0 )
			begin
				-- Return the first 100 values
				select MetadataValue, Metadata_Count
				from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
						from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
						where ( U.ItemID = I.ItemID )
						  and ( U.MetadataTypeID = @facettype3 )
						group by U.MetadataID
						order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
				where M.MetadataID = F.MetadataID
				order by Metadata_Count DESC, MetadataValue ASC;
			end;
			
			-- Return the FOURTH facet
			if ( @facettype4 > 0 )
			begin
				-- Return the first 100 values
				select MetadataValue, Metadata_Count
				from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
						from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
						where ( U.ItemID = I.ItemID )
						  and ( U.MetadataTypeID = @facettype4 )
						group by U.MetadataID
						order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
				where M.MetadataID = F.MetadataID
				order by Metadata_Count DESC, MetadataValue ASC;
			end;
			
			-- Return the FIFTH facet
			if ( @facettype5 > 0 )
			begin
				-- Return the first 100 values
				select MetadataValue, Metadata_Count
				from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
						from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
						where ( U.ItemID = I.ItemID )
						  and ( U.MetadataTypeID = @facettype5 )
						group by U.MetadataID
						order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
				where M.MetadataID = F.MetadataID
				order by Metadata_Count DESC, MetadataValue ASC;
			end;
			
			-- Return the SIXTH facet
			if ( @facettype6 > 0 )
			begin
				-- Return the first 100 values
				select MetadataValue, Metadata_Count
				from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
						from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
						where ( U.ItemID = I.ItemID )
						  and ( U.MetadataTypeID = @facettype6 )
						group by U.MetadataID
						order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
				where M.MetadataID = F.MetadataID
				order by Metadata_Count DESC, MetadataValue ASC;
			end;
			
			-- Return the SEVENTH facet
			if ( @facettype7 > 0 )
			begin
				-- Return the first 100 values
				select MetadataValue, Metadata_Count
				from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
						from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
						where ( U.ItemID = I.ItemID )
						  and ( U.MetadataTypeID = @facettype7 )
						group by U.MetadataID
						order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
				where M.MetadataID = F.MetadataID
				order by Metadata_Count DESC, MetadataValue ASC;
			end;
			
			-- Return the EIGHTH facet
			if ( @facettype8 > 0 )
			begin
				-- Return the first 100 values
				select MetadataValue, Metadata_Count
				from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
						from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
						where ( U.ItemID = I.ItemID )
						  and ( U.MetadataTypeID = @facettype8 )
						group by U.MetadataID
						order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
				where M.MetadataID = F.MetadataID
				order by Metadata_Count DESC, MetadataValue ASC;
			end;
		end; -- End overall FACET block
	end; -- End else statement entered if there are any results to return
	
	-- return the query string as well, for debuggins
	select Query = @mainquery;
	select RankSelection = @rankselection;
	
	-- drop the temporary tables
	drop table #TEMP_ITEMS;
	
	Set NoCount OFF;
			
	If @@ERROR <> 0 GoTo ErrorHandler;
    Return(0);
  
ErrorHandler:
    Return(@@ERROR);
	
END;
GO



-- Procedure returns the items by a coordinate search
ALTER PROCEDURE [dbo].[SobekCM_Get_Items_By_Coordinates]
	@lat1 float,
	@long1 float,
	@lat2 float,
	@long2 float,
	@include_private bit,
	@aggregationcode varchar(20),
	@pagesize int, 
	@pagenumber int,
	@sort int,	
	@minpagelookahead int,
	@maxpagelookahead int,
	@lookahead_factor float,
	@include_facets bit,
	@facettype1 smallint,
	@facettype2 smallint,
	@facettype3 smallint,
	@facettype4 smallint,
	@facettype5 smallint,
	@facettype6 smallint,
	@facettype7 smallint,
	@facettype8 smallint,
	@total_items int output,
	@total_titles int output
AS
BEGIN

	-- No need to perform any locks here
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- Create the temporary tables first
	-- Create the temporary table to hold all the item id's
	create table #TEMPSUBZERO ( ItemID int );
	create table #TEMPZERO ( ItemID int );
	create table #TEMP_ITEMS ( ItemID int, fk_TitleID int, SortDate bigint, Spatial_KML varchar(4000), Spatial_KML_Distance float );

	-- Is this really just a point search?
	if (( isnull(@lat2,1000) = 1000 ) or ( isnull(@long2,1000) = 1000 ) or (( @lat1=@lat2 ) and ( @long1=@long2 )))
	begin

		-- Select all matching item ids
		insert into #TEMPZERO
		select distinct(itemid) 
		from SobekCM_Item_Footprint
		where (( Point_Latitude = @lat1 ) and ( Point_Longitude = @long1 ))
		   or (((( Rect_Latitude_A >= @lat1 ) and ( Rect_Latitude_B <= @lat1 )) or (( Rect_Latitude_A <= @lat1 ) and ( Rect_Latitude_B >= @lat1)))
	        and((( Rect_Longitude_A >= @long1 ) and ( Rect_Longitude_B <= @long1 )) or (( Rect_Longitude_A <= @long1 ) and ( Rect_Longitude_B >= @long1 ))));

	end
	else
	begin

		-- Select all matching item ids by rectangle
		insert into #TEMPSUBZERO
		select distinct(itemid)
		from SobekCM_Item_Footprint
		where ((( Point_Latitude <= @lat1 ) and ( Point_Latitude >= @lat2 )) or (( Point_Latitude >= @lat1 ) and ( Point_Latitude <= @lat2 )))
		  and ((( Point_Longitude <= @long1 ) and ( Point_Longitude >= @long2 )) or (( Point_Longitude >= @long1 ) and ( Point_Longitude <= @long2 )));
		
		-- Select rectangles which OVERLAP with this rectangle
		insert into #TEMPSUBZERO
		select distinct(itemid)
		from SobekCM_Item_Footprint
		where (((( Rect_Latitude_A >= @lat1 ) and ( Rect_Latitude_A <= @lat2 )) or (( Rect_Latitude_A <= @lat1 ) and ( Rect_Latitude_A >= @lat2 )))
			or ((( Rect_Latitude_B >= @lat1 ) and ( Rect_Latitude_B <= @lat2 )) or (( Rect_Latitude_B <= @lat1 ) and ( Rect_Latitude_B >= @lat2 ))))
		  and (((( Rect_Longitude_A >= @long1 ) and ( Rect_Longitude_A <= @long2 )) or (( Rect_Longitude_A <= @long1 ) and ( Rect_Longitude_A >= @long2 )))
			or ((( Rect_Longitude_B >= @long1 ) and ( Rect_Longitude_B <= @long2 )) or (( Rect_Longitude_B <= @long1 ) and ( Rect_Longitude_B >= @long2 ))));
		
		-- Select rectangles that INCLUDE this rectangle by picking overlaps with one point
		insert into #TEMPSUBZERO
		select distinct(itemid)
		from SobekCM_Item_Footprint
		where ((( @lat1 <= Rect_Latitude_A ) and ( @lat1 >= Rect_Latitude_B )) or (( @lat1 >= Rect_Latitude_A ) and ( @lat1 <= Rect_Latitude_B )))
		  and ((( @long1 <= Rect_Longitude_A ) and ( @long1 >= Rect_Longitude_B )) or (( @long1 >= Rect_Longitude_A ) and ( @long1 <= Rect_Longitude_B )));

		-- Make sure uniqueness applies here as well
		insert into #TEMPZERO
		select distinct(itemid)
		from #TEMPSUBZERO;
	end;
	
	-- Determine the start and end rows
	declare @rowstart int;
	declare @rowend int; 
	set @rowstart = (@pagesize * ( @pagenumber - 1 )) + 1;
	set @rowend = @rowstart + @pagesize - 1; 

	-- Set value for filtering privates
	declare @lower_mask int;
	set @lower_mask = 0;
	if ( @include_private = 'true' )
	begin
		set @lower_mask = -256;
	end;

	-- Determine the aggregationid
	declare @aggregationid int;
	set @aggregationid = coalesce(( select AggregationID from SobekCM_Item_Aggregation where Code=@aggregationcode ), -1);

	-- Get the sql which will be used to return the aggregation-specific display values for all the items in this page of results
	declare @item_display_sql nvarchar(max);
	if ( @aggregationid < 0 )
	begin
		select @item_display_sql=coalesce(Browse_Results_Display_SQL, 'select S.ItemID, S.Publication_Date, S.Creator, S.[Publisher.Display], S.Format, S.Edition, S.Material, S.Measurements, S.Style_Period, S.Technique, S.[Subjects.Display], S.Source_Institution, S.Donor from SobekCM_Metadata_Basic_Search_Table S, @itemtable T where S.ItemID = T.ItemID order by T.RowNumber;')
		from SobekCM_Item_Aggregation
		where Code='all';
	end
	else
	begin
		select @item_display_sql=coalesce(Browse_Results_Display_SQL, 'select S.ItemID, S.Publication_Date, S.Creator, S.[Publisher.Display], S.Format, S.Edition, S.Material, S.Measurements, S.Style_Period, S.Technique, S.[Subjects.Display], S.Source_Institution, S.Donor from SobekCM_Metadata_Basic_Search_Table S, @itemtable T where S.ItemID = T.ItemID order by T.RowNumber;')
		from SobekCM_Item_Aggregation
		where AggregationID=@aggregationid;
	end;
			
	-- Was an aggregation included?
	if ( LEN(ISNULL( @aggregationcode,'' )) > 0 )
	begin	
		-- Look for matching the provided aggregation
		insert into #TEMP_ITEMS ( ItemID, fk_TitleID, SortDate, Spatial_KML, Spatial_KML_Distance )
		select I.ItemID, I.GroupID, SortDate=isnull( I.SortDate,-1), Spatial_KML=isnull(Spatial_KML,''), Spatial_KML_Distance
		from #TEMPZERO T1, SobekCM_Item I, SobekCM_Item_Aggregation_Item_Link CL
		where ( CL.ItemID = I.ItemID )
		  and ( CL.AggregationID = @aggregationid )
		  and ( I.Deleted = 'false' )
		  and ( T1.ItemID = I.ItemID )
		  and ( I.IP_Restriction_Mask >= @lower_mask );
	end
	else
	begin	
		-- Look for matching the provided aggregation
		insert into #TEMP_ITEMS ( ItemID, fk_TitleID, SortDate, Spatial_KML, Spatial_KML_Distance )
		select I.ItemID, I.GroupID, SortDate=isnull( I.SortDate,-1), Spatial_KML=isnull(Spatial_KML,''), Spatial_KML_Distance
		from #TEMPZERO T1, SobekCM_Item I
		where ( I.Deleted = 'false' )
		  and ( T1.ItemID = I.ItemID )
		  and ( I.IP_Restriction_Mask >= @lower_mask );
	end;
	
	-- Create the temporary item table variable for paging purposes
	declare @TEMP_PAGED_ITEMS TempPagedItemsTableType;
	
	-- There are essentially THREE major paths of execution, depending on whether this should
	-- be grouped as items within the page requested titles ( sorting by title or the basic
	-- sorting by rank, which ranks this way ) or whether each item should be
	-- returned by itself, such as sorting by individual publication dates, etc..
	-- The default sort for this search is by spatial coordiantes, in which case the same 
	-- title should appear multiple times, if the items in the volume have different coordinates
	
	if ( @sort = 0 )
	begin
		-- create the temporary title table definition
		create table #TEMP_TITLES_ITEMS ( TitleID int, BibID varchar(10), RowNumber int, Spatial_KML varchar(4000), Spatial_Distance float );
		
		-- Compute the number of seperate titles/coordinates
		select fk_TitleID, (COUNT(Spatial_KML)) as assign_value
		into #TEMP1
		from #TEMP_ITEMS I
		group by fk_TitleID, Spatial_KML;
		
		-- Get the TOTAL count of spatial_kmls
		select @total_titles = isnull(SUM(assign_value), 0) from #TEMP1;
		drop table #TEMP1;
		
		-- Total items is simpler to computer
		select @total_items = COUNT(*) from #TEMP_ITEMS;	
		
		-- For now, always return the max lookahead pages
		set @rowend = @rowstart + ( @pagesize * @maxpagelookahead ) - 1; 
		
		-- Create saved select across titles for row numbers
		with TITLES_SELECT AS
			(	select GroupID, G.BibID, Spatial_KML, Spatial_KML_Distance,
					ROW_NUMBER() OVER (order by Spatial_KML_Distance ASC, Spatial_KML ASC) as RowNumber
				from #TEMP_ITEMS I, SobekCM_Item_Group G
				where I.fk_TitleID = G.GroupID
				group by G.GroupID, G.BibID, G.SortTitle, Spatial_KML, Spatial_KML_Distance )

		-- Insert the correct rows into the temp title table	
		insert into #TEMP_TITLES_ITEMS ( TitleID, BibID, RowNumber, Spatial_KML, Spatial_Distance )
		select GroupID, BibID, RowNumber, Spatial_KML, Spatial_KML_Distance
		from TITLES_SELECT
		where RowNumber >= @rowstart
		  and RowNumber <= @rowend;
		  
		-- Return the title information for this page
		select RowNumber as TitleID, T.BibID, G.GroupTitle, G.ALEPH_Number as OPAC_Number, G.OCLC_Number, isnull(G.GroupThumbnail,'') as GroupThumbnail, G.[Type], isnull(G.Primary_Identifier_Type,'') as Primary_Identifier_Type, isnull(G.Primary_Identifier, '') as Primary_Identifier, Spatial_KML, Spatial_Distance
		from #TEMP_TITLES_ITEMS T, SobekCM_Item_Group G
		where ( T.TitleID = G.GroupID )
		order by RowNumber ASC;
		
		-- Get the item id's for the items related to these titles (using rownumber as the new group id)
		insert into @TEMP_PAGED_ITEMS
		select I.ItemID, RowNumber
		from #TEMP_TITLES_ITEMS T, #TEMP_ITEMS M, SobekCM_Item I
		where ( T.TitleID = M.fk_TitleID )
		  and ( M.ItemID = I.ItemID )
		  and ( M.Spatial_KML = T.Spatial_KML )
		  and ( M.Spatial_KML_Distance = T.Spatial_Distance );  
			
		-- Return the basic system required item information for this page of results
		select T.RowNumber as fk_TitleID, I.ItemID, VID, Title, IP_Restriction_Mask, coalesce(I.MainThumbnail,'') as MainThumbnail, coalesce(I.Level1_Index, -1) as Level1_Index, coalesce(I.Level1_Text,'') as Level1_Text, coalesce(I.Level2_Index, -1) as Level2_Index, coalesce(I.Level2_Text,'') as Level2_Text, coalesce(I.Level3_Index,-1) as Level3_Index, coalesce(I.Level3_Text,'') as Level3_Text, isnull(I.PubDate,'') as PubDate, I.[PageCount], coalesce(I.Link,'') as Link, coalesce( Spatial_KML, '') as Spatial_KML, coalesce(COinS_OpenURL, '') as COinS_OpenURL		
		from SobekCM_Item I, @TEMP_PAGED_ITEMS T
		where ( T.ItemID = I.ItemID )
		order by T.RowNumber, Level1_Index, Level2_Index, Level3_Index;			
								
		-- Return the aggregation-specific display values for all the items in this page of results
		execute sp_Executesql @item_display_sql, N' @itemtable TempPagedItemsTableType READONLY', @TEMP_PAGED_ITEMS; 
		
		-- drop the temporary table
		drop table #TEMP_TITLES_ITEMS;	
	end;
	
	if ((@total_titles > 0 ) and ((( @sort < 10 ) and ( @sort > 0 ))))
	begin	
		-- create the temporary title table definition
		create table #TEMP_TITLES ( TitleID int, BibID varchar(10), RowNumber int );
		
		-- Get the total counts
		select @total_items=COUNT(*), @total_titles=COUNT(distinct fk_TitleID)
		from #TEMP_ITEMS; 
		
		-- Now, calculate the actual ending row, based on the ration, page information,
		-- and the lookahead factor
		
		-- Compute equation to determine possible page value ( max - log(factor, (items/title)/2))
		declare @computed_value int;
		select @computed_value = (@maxpagelookahead - CEILING( LOG10( ((cast(@total_items as float)) / (cast(@total_titles as float)))/@lookahead_factor)));
		
		-- Compute the minimum value.  This cannot be less than @minpagelookahead.
		declare @floored_value int;
		select @floored_value = 0.5 * ((@computed_value + @minpagelookahead) + ABS(@computed_value - @minpagelookahead));
		
		-- Compute the maximum value.  This cannot be more than @maxpagelookahead.
		declare @actual_pages int;
		select @actual_pages = 0.5 * ((@floored_value + @maxpagelookahead) - ABS(@floored_value - @maxpagelookahead)); 

		-- Set the final row again then
		set @rowend = @rowstart + ( @pagesize * @actual_pages ) - 1; 		
				  
		-- Create saved select across titles for row numbers
		with TITLES_SELECT AS
			(	select GroupID, G.BibID, 
					ROW_NUMBER() OVER (order by case when @sort=1 THEN G.SortTitle end ASC,											
												case when @sort=2 THEN BibID end ASC,
											    case when @sort=3 THEN BibID end DESC) as RowNumber
				from #TEMP_ITEMS I, SobekCM_Item_Group G
				where I.fk_TitleID = G.GroupID
				group by G.GroupID, G.BibID, G.SortTitle )

		-- Insert the correct rows into the temp title table	
		insert into #TEMP_TITLES ( TitleID, BibID, RowNumber )
		select GroupID, BibID, RowNumber
		from TITLES_SELECT
		where RowNumber >= @rowstart
		  and RowNumber <= @rowend;
	
		-- Return the title information for this page
		select RowNumber as TitleID, T.BibID, G.GroupTitle, G.ALEPH_Number, G.OCLC_Number, isnull(G.GroupThumbnail,'') as GroupThumbnail, G.[Type], isnull(G.Primary_Identifier_Type,'') as Primary_Identifier_Type, isnull(G.Primary_Identifier, '') as Primary_Identifier
		from #TEMP_TITLES T, SobekCM_Item_Group G
		where ( T.TitleID = G.GroupID )
		order by RowNumber ASC;
		
		-- Get the item id's for the items related to these titles
		insert into @TEMP_PAGED_ITEMS
		select ItemID, RowNumber
		from #TEMP_TITLES T, SobekCM_Item I
		where ( T.TitleID = I.GroupID );			  
			
		-- Return the basic system required item information for this page of results
		select T.RowNumber as fk_TitleID, I.ItemID, VID, Title, IP_Restriction_Mask, coalesce(I.MainThumbnail,'') as MainThumbnail, coalesce(I.Level1_Index, -1) as Level1_Index, coalesce(I.Level1_Text,'') as Level1_Text, coalesce(I.Level2_Index, -1) as Level2_Index, coalesce(I.Level2_Text,'') as Level2_Text, coalesce(I.Level3_Index,-1) as Level3_Index, coalesce(I.Level3_Text,'') as Level3_Text, isnull(I.PubDate,'') as PubDate, I.[PageCount], coalesce(I.Link,'') as Link, coalesce( Spatial_KML, '') as Spatial_KML, coalesce(COinS_OpenURL, '') as COinS_OpenURL		
		from SobekCM_Item I, @TEMP_PAGED_ITEMS T
		where ( T.ItemID = I.ItemID )
		order by T.RowNumber, Level1_Index, Level2_Index, Level3_Index;			
								
		-- Return the aggregation-specific display values for all the items in this page of results
		execute sp_Executesql @item_display_sql, N' @itemtable TempPagedItemsTableType READONLY', @TEMP_PAGED_ITEMS; 	
		
		-- drop the temporary table
		drop table #TEMP_TITLES;
	end;
	
	if ( @sort >= 10 )
	begin	
		-- Since these sorts make each item paired with a single title row,
		-- number of items and titles are equal
		select @total_items=COUNT(*), @total_titles=COUNT(*)
		from #TEMP_ITEMS; 
		
		-- In addition, always return the max lookahead pages
		set @rowend = @rowstart + ( @pagesize * @maxpagelookahead ) - 1; 
		
		-- Create saved select across items for row numbers
		with ITEMS_SELECT AS
		 (	select I.ItemID, 
				ROW_NUMBER() OVER (order by case when @sort=10 THEN SortDate end ASC,
											case when @sort=11 THEN SortDate end DESC) as RowNumber
				from #TEMP_ITEMS I
				group by I.ItemID, SortDate )
					  
		-- Insert the correct rows into the temp item table	
		insert into @TEMP_PAGED_ITEMS ( ItemID, RowNumber )
		select ItemID, RowNumber
		from ITEMS_SELECT
		where RowNumber >= @rowstart
		  and RowNumber <= @rowend;
		  
		-- Return the title information for this page
		select RowNumber as TitleID, G.BibID, G.GroupTitle, G.ALEPH_Number, G.OCLC_Number, isnull(G.GroupThumbnail,'') as GroupThumbnail, G.[Type], isnull(G.Primary_Identifier_Type,'') as Primary_Identifier_Type, isnull(G.Primary_Identifier, '') as Primary_Identifier
		from @TEMP_PAGED_ITEMS T, SobekCM_Item I, SobekCM_Item_Group G
		where ( T.ItemID = I.ItemID )
		  and ( I.GroupID = G.GroupID )
		order by RowNumber ASC;
		
		-- Return the basic system required item information for this page of results
		select T.RowNumber as fk_TitleID, I.ItemID, VID, Title, IP_Restriction_Mask, coalesce(I.MainThumbnail,'') as MainThumbnail, coalesce(I.Level1_Index, -1) as Level1_Index, coalesce(I.Level1_Text,'') as Level1_Text, coalesce(I.Level2_Index, -1) as Level2_Index, coalesce(I.Level2_Text,'') as Level2_Text, coalesce(I.Level3_Index,-1) as Level3_Index, coalesce(I.Level3_Text,'') as Level3_Text, isnull(I.PubDate,'') as PubDate, I.[PageCount], coalesce(I.Link,'') as Link, coalesce( Spatial_KML, '') as Spatial_KML, coalesce(COinS_OpenURL, '') as COinS_OpenURL		
		from SobekCM_Item I, @TEMP_PAGED_ITEMS T
		where ( T.ItemID = I.ItemID )
		order by T.RowNumber, Level1_Index, Level2_Index, Level3_Index;			
			
		-- Return the aggregation-specific display values for all the items in this page of results
		execute sp_Executesql @item_display_sql, N' @itemtable TempPagedItemsTableType READONLY', @TEMP_PAGED_ITEMS; 
	end;
	
	-- Return the facets if asked for
	if ( @include_facets = 'true' )
	begin	
		-- Only return the aggregation codes if this was a search across all collections	
		if (( LEN( isnull( @aggregationcode, '')) = 0 ) or ( @aggregationcode='all'))
		begin
			-- Build the aggregation list
			select A.Code, A.ShortName, Metadata_Count=Count(*)
			from SobekCM_Item_Aggregation A, SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item I, #TEMP_ITEMS T
			where ( T.ItemID = I.ItemID )
			  and ( I.ItemID = L.ItemID )
			  and ( L.AggregationID = A.AggregationID )
			  and ( A.Hidden = 'false' )
			  and ( A.isActive = 'true' )
			  and ( A.Include_In_Collection_Facet = 'true' )
			group by A.Code, A.ShortName
			order by Metadata_Count DESC, ShortName ASC;	
		end;	
		
		-- Return the FIRST facet
		if ( @facettype1 > 0 )
		begin
			-- Return the first 100 values
			select MetadataValue, Metadata_Count
			from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
					from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
					where ( U.ItemID = I.ItemID )
					  and ( U.MetadataTypeID = @facettype1 )
					group by U.MetadataID
					order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
			where M.MetadataID = F.MetadataID
			order by Metadata_Count DESC, MetadataValue ASC;
		end;
		
		-- Return the SECOND facet
		if ( @facettype2 > 0 )
		begin
			-- Return the first 100 values
			select MetadataValue, Metadata_Count
			from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
					from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
					where ( U.ItemID = I.ItemID )
					  and ( U.MetadataTypeID = @facettype2 )
					group by U.MetadataID
					order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
			where M.MetadataID = F.MetadataID
			order by Metadata_Count DESC, MetadataValue ASC;
		end;
		
		-- Return the THIRD facet
		if ( @facettype3 > 0 )
		begin
			-- Return the first 100 values
			select MetadataValue, Metadata_Count
			from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
					from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
					where ( U.ItemID = I.ItemID )
					  and ( U.MetadataTypeID = @facettype3 )
					group by U.MetadataID
					order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
			where M.MetadataID = F.MetadataID
			order by Metadata_Count DESC, MetadataValue ASC;
		end;	
		
		-- Return the FOURTH facet
		if ( @facettype4 > 0 )
		begin
			-- Return the first 100 values
			select MetadataValue, Metadata_Count
			from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
					from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
					where ( U.ItemID = I.ItemID )
					  and ( U.MetadataTypeID = @facettype4 )
					group by U.MetadataID
					order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
			where M.MetadataID = F.MetadataID
			order by Metadata_Count DESC, MetadataValue ASC;
		end;
		
		-- Return the FIFTH facet
		if ( @facettype5 > 0 )
		begin
			-- Return the first 100 values
			select MetadataValue, Metadata_Count
			from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
					from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
					where ( U.ItemID = I.ItemID )
					  and ( U.MetadataTypeID = @facettype5 )
					group by U.MetadataID
					order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
			where M.MetadataID = F.MetadataID
			order by Metadata_Count DESC, MetadataValue ASC;
		end;
		
		-- Return the SIXTH facet
		if ( @facettype6 > 0 )
		begin
			-- Return the first 100 values
			select MetadataValue, Metadata_Count
			from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
					from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
					where ( U.ItemID = I.ItemID )
					  and ( U.MetadataTypeID = @facettype6 )
					group by U.MetadataID
					order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
			where M.MetadataID = F.MetadataID
			order by Metadata_Count DESC, MetadataValue ASC;
		end;
		
		-- Return the SEVENTH facet
		if ( @facettype7 > 0 )
		begin
			-- Return the first 100 values
			select MetadataValue, Metadata_Count
			from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
					from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
					where ( U.ItemID = I.ItemID )
					  and ( U.MetadataTypeID = @facettype7 )
					group by U.MetadataID
					order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
			where M.MetadataID = F.MetadataID
			order by Metadata_Count DESC, MetadataValue ASC;
		end;
		
		-- Return the EIGHTH facet
		if ( @facettype8 > 0 )
		begin
			-- Return the first 100 values
			select MetadataValue, Metadata_Count
			from (	select top(100) U.MetadataID, Metadata_Count = COUNT(*)
					from #TEMP_ITEMS I, Metadata_Item_Link_Indexed_View U with (NOEXPAND)
					where ( U.ItemID = I.ItemID )
					  and ( U.MetadataTypeID = @facettype8 )
					group by U.MetadataID
					order by Metadata_Count DESC ) F, SobekCM_Metadata_Unique_Search_Table M
			where M.MetadataID = F.MetadataID
			order by Metadata_Count DESC, MetadataValue ASC;
		end;
	end;

	-- drop the temporary tables
	drop table #TEMP_ITEMS;
	drop table #TEMPZERO;
	drop table #TEMPSUBZERO;

END;
GO

if (( select count(*) from SobekCM_Database_Version ) = 0 )
begin
	insert into SobekCM_Database_Version ( Major_Version, Minor_Version, Release_Phase )
	values ( 4, 8, '11' );
end
else
begin
	update SobekCM_Database_Version
	set Major_Version=4, Minor_Version=8, Release_Phase='11';
end;
GO
