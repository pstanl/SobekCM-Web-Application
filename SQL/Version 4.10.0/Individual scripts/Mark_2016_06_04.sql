
-- Modifies the item behaviors in a mass update for all items in 
-- a particular item group
ALTER PROCEDURE [dbo].[SobekCM_Mass_Update_Item_Behaviors]
	@GroupID int,
	@IP_Restriction_Mask smallint,
	@CheckoutRequired bit,
	@Dark_Flag bit,
	@Born_Digital bit,
	@AggregationCode1 varchar(20),
	@AggregationCode2 varchar(20),
	@AggregationCode3 varchar(20),
	@AggregationCode4 varchar(20),
	@AggregationCode5 varchar(20),
	@AggregationCode6 varchar(20),
	@AggregationCode7 varchar(20),
	@AggregationCode8 varchar(20),
	@HoldingCode varchar(20),
	@SourceCode varchar(20),
	@Icon1_Name varchar(50),
	@Icon2_Name varchar(50),
	@Icon3_Name varchar(50),
	@Icon4_Name varchar(50),
	@Icon5_Name varchar(50),
	@Viewer1_Type varchar(50),
	@Viewer1_Label nvarchar(50),
	@Viewer1_Attribute nvarchar(250),
	@Viewer2_Type varchar(50),
	@Viewer2_Label nvarchar(50),
	@Viewer2_Attribute nvarchar(250),
	@Viewer3_Type varchar(50),
	@Viewer3_Label nvarchar(50),
	@Viewer3_Attribute nvarchar(250),
	@Viewer4_Type varchar(50),
	@Viewer4_Label nvarchar(50),
	@Viewer4_Attribute nvarchar(250),
	@Viewer5_Type varchar(50),
	@Viewer5_Label nvarchar(50),
	@Viewer5_Attribute nvarchar(250),
	@Viewer6_Type varchar(50),
	@Viewer6_Label nvarchar(50),
	@Viewer6_Attribute nvarchar(250)
AS
begin transaction

	--Update the main item's flags if provided
	if ( @IP_Restriction_Mask is not null )
	begin
		update SobekCM_Item
		set IP_Restriction_Mask=@IP_Restriction_Mask
		where ( GroupID = @GroupID );
	end;
	
	if ( @CheckoutRequired is not null )
	begin
		update SobekCM_Item
		set CheckoutRequired=@CheckoutRequired
		where ( GroupID = @GroupID );
	end;
	
	if ( @Dark_Flag is not null )
	begin
		update SobekCM_Item
		set Dark=@Dark_Flag
		where ( GroupID = @GroupID );
	end;
	
	if ( @Born_Digital is not null )
	begin
		update SobekCM_Item
		set Born_Digital=@Born_Digital
		where ( GroupID = @GroupID );
	end;
	
	-- Only do icon stuff if the first icon has length
	if ( len( isnull( @Icon1_Name, '' )) > 0 ) 
	begin

		-- Clear the links to all existing icons
		delete from SobekCM_Item_Icons 
		where exists (  select *
						from SobekCM_Item
						where ( SobekCM_Item.GroupID=@GroupID )
						  and ( SobekCM_Item.ItemID = SobekCM_Item_Icons.ItemID ));
		
		-- Add the first icon to this object  (this requires the icons have been pre-established )
		declare @IconID int;
		if ( len( isnull( @Icon1_Name, '' )) > 0 ) 
		begin
			-- Get the Icon ID for this icon
			select @IconID = IconID from SobekCM_Icon where Icon_Name = @Icon1_Name;

			-- Tie this item to this icon
			if ( ISNULL(@IconID,-1) > 0 )
			begin
				insert into SobekCM_Item_Icons ( ItemID, IconID, [Sequence] )
				select ItemID, @IconID, 1 from SobekCM_Item I where I.GroupID=@GroupID;
			end;
		end;

		-- Add the second icon to this object  (this requires the icons have been pre-established )
		if ( len( isnull( @Icon2_Name, '' )) > 0 ) 
		begin
			-- Get the Icon ID for this icon
			select @IconID = IconID from SobekCM_Icon where Icon_Name = @Icon2_Name;

			-- Tie this item to this icon
			if ( ISNULL(@IconID,-1) > 0 )
			begin
				insert into SobekCM_Item_Icons ( ItemID, IconID, [Sequence] )
				select ItemID, @IconID, 2 from SobekCM_Item I where I.GroupID=@GroupID;
			end;
		end;

		-- Add the third icon to this object  (this requires the icons have been pre-established )
		if ( len( isnull( @Icon3_Name, '' )) > 0 ) 
		begin
			-- Get the Icon ID for this icon
			select @IconID = IconID from SobekCM_Icon where Icon_Name = @Icon3_Name;

			-- Tie this item to this icon
			if ( ISNULL(@IconID,-1) > 0 )
			begin
				insert into SobekCM_Item_Icons ( ItemID, IconID, [Sequence] )
				select ItemID, @IconID, 3 from SobekCM_Item I where I.GroupID=@GroupID;
			end;
		end;

		-- Add the fourth icon to this object  (this requires the icons have been pre-established )
		if ( len( isnull( @Icon4_Name, '' )) > 0 ) 
		begin
			-- Get the Icon ID for this icon
			select @IconID = IconID from SobekCM_Icon where Icon_Name = @Icon4_Name;
			
			-- Tie this item to this icon
			if ( ISNULL(@IconID,-1) > 0 )
			begin
				insert into SobekCM_Item_Icons ( ItemID, IconID, [Sequence] )
				select ItemID, @IconID, 4 from SobekCM_Item I where I.GroupID=@GroupID;
			end;
		end;

		-- Add the fifth icon to this object  (this requires the icons have been pre-established )
		if ( len( isnull( @Icon5_Name, '' )) > 0 ) 
		begin
			-- Get the Icon ID for this icon
			select @IconID = IconID from SobekCM_Icon where Icon_Name = @Icon5_Name;

			-- Tie this item to this icon
			if ( ISNULL(@IconID,-1) > 0 )
			begin
				insert into SobekCM_Item_Icons ( ItemID, IconID, [Sequence] )
				select ItemID, @IconID, 5 from SobekCM_Item I where I.GroupID=@GroupID;
			end;
		end;
	end;
	
	-- Only modify the aggregation codes if they have length
	if ( LEN ( ISNULL( @AggregationCode1, '')) > 0 )
	begin
	
		-- Clear all links to aggregations
		delete from SobekCM_Item_Aggregation_Item_Link 
		where exists ( select * from SobekCM_Item I where I.GroupID=@GroupID and I.ItemID=SobekCM_Item_Aggregation_Item_Link.ItemID );

		-- Add all of the aggregations
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @AggregationCode1;
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @AggregationCode2;
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @AggregationCode3;
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @AggregationCode4;
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @AggregationCode5;
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @AggregationCode6;
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @AggregationCode7;
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @AggregationCode8;

	end;

	-- Check for Holding Institution Code
	declare @AggregationID int;
	if ( len ( isnull ( @HoldingCode, '' ) ) > 0 )
	begin
		-- Does this institution already exist?
		if (( select count(*) from SobekCM_Item_Aggregation where Code = @HoldingCode ) = 0 )
		begin
			-- Add new institution
			insert into SobekCM_Item_Aggregation ( Code, [Name], ShortName, Description, ThematicHeadingID, [Type], isActive, Hidden, DisplayOptions, Map_Search, Map_Display, OAI_Flag, ContactEmail, HasNewItems )
			values ( @HoldingCode, 'Added automatically', 'Added automatically', 'Added automatically', -1, 'Institution', 'false', 'true', '', 0, 0, 'false', '', 'false' );
		end;
		
		-- Add the link to this holding code ( and any legitimate parent aggregations )
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @HoldingCode;
	end;

	-- Check for Source Institution Code
	if ( len ( isnull ( @SourceCode, '' ) ) > 0 )
	begin
		-- Does this institution already exist?
		if (( select count(*) from SobekCM_Item_Aggregation where Code = @SourceCode ) = 0 )
		begin
			-- Add new institution
			insert into SobekCM_Item_Aggregation ( Code, [Name], ShortName, Description, ThematicHeadingID, [Type], isActive, Hidden, DisplayOptions, Map_Search, Map_Display, OAI_Flag, ContactEmail, HasNewItems )
			values ( @SourceCode, 'Added automatically', 'Added automatically', 'Added automatically', -1, 'Institution', 'false', 'true', '', 0, 0, 'false', '', 'false' );
		end;

		-- Add the link to this holding code ( and any legitimate parent aggregations )
		exec [SobekCM_Mass_Update_Item_Aggregation_Link] @GroupID, @SourceCode;
	end;
		
	-- Add the first viewer information, if provided
	if ( len(coalesce(@Viewer1_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer1_TypeID int;
		set @Viewer1_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer1_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer1_TypeID > 0 )
		begin
			-- Insert this viewer information to all items, where it does not already exist
			insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
			select I.ItemID, @Viewer1_TypeID, @Viewer1_Attribute, @Viewer1_Label 
			from SobekCM_Item I 
			where ( I.GroupID=@GroupID )
				and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=I.ItemID and ItemViewTypeID=@Viewer1_TypeID ))
		end
	end;

	-- Add the second viewer information, if provided
	if ( len(coalesce(@Viewer2_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer2_TypeID int;
		set @Viewer2_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer2_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer2_TypeID > 0 )
		begin
			-- Insert this viewer information to all items, where it does not already exist
			insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
			select I.ItemID, @Viewer2_TypeID, @Viewer2_Attribute, @Viewer2_Label 
			from SobekCM_Item I 
			where ( I.GroupID=@GroupID )
				and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=I.ItemID and ItemViewTypeID=@Viewer2_TypeID ))
		end
	end;

	-- Add the third viewer information, if provided
	if ( len(coalesce(@Viewer3_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer3_TypeID int;
		set @Viewer3_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer3_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer3_TypeID > 0 )
		begin
			-- Insert this viewer information to all items, where it does not already exist
			insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
			select I.ItemID, @Viewer3_TypeID, @Viewer3_Attribute, @Viewer3_Label 
			from SobekCM_Item I 
			where ( I.GroupID=@GroupID )
				and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=I.ItemID and ItemViewTypeID=@Viewer3_TypeID ))
		end
	end;

	-- Add the fourth viewer information, if provided
	if ( len(coalesce(@Viewer4_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer4_TypeID int;
		set @Viewer4_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer4_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer4_TypeID > 0 )
		begin
			-- Insert this viewer information to all items, where it does not already exist
			insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
			select I.ItemID, @Viewer4_TypeID, @Viewer4_Attribute, @Viewer4_Label 
			from SobekCM_Item I 
			where ( I.GroupID=@GroupID )
				and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=I.ItemID and ItemViewTypeID=@Viewer4_TypeID ))
		end
	end;

	-- Add the fifth viewer information, if provided
	if ( len(coalesce(@Viewer5_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer5_TypeID int;
		set @Viewer5_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer5_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer5_TypeID > 0 )
		begin
			-- Insert this viewer information to all items, where it does not already exist
			insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
			select I.ItemID, @Viewer5_TypeID, @Viewer5_Attribute, @Viewer5_Label 
			from SobekCM_Item I 
			where ( I.GroupID=@GroupID )
				and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=I.ItemID and ItemViewTypeID=@Viewer5_TypeID ))
		end
	end;

	-- Add the sixth viewer information, if provided
	if ( len(coalesce(@Viewer6_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer6_TypeID int;
		set @Viewer6_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer6_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer6_TypeID > 0 )
		begin
			-- Insert this viewer information to all items, where it does not already exist
			insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
			select I.ItemID, @Viewer6_TypeID, @Viewer6_Attribute, @Viewer6_Label 
			from SobekCM_Item I 
			where ( I.GroupID=@GroupID )
				and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=I.ItemID and ItemViewTypeID=@Viewer6_TypeID ))
		end
	end;

commit transaction;
GO


-- Add or update existing viewers for an item
-- NOTE: This does not delete any existing viewers
ALTER PROCEDURE [dbo].[SobekCM_Add_Item_Viewers] 
	@ItemID int,
	@Viewer1_Type varchar(50),
	@Viewer1_Label nvarchar(50),
	@Viewer1_Attribute nvarchar(250),
	@Viewer2_Type varchar(50),
	@Viewer2_Label nvarchar(50),
	@Viewer2_Attribute nvarchar(250),
	@Viewer3_Type varchar(50),
	@Viewer3_Label nvarchar(50),
	@Viewer3_Attribute nvarchar(250),
	@Viewer4_Type varchar(50),
	@Viewer4_Label nvarchar(50),
	@Viewer4_Attribute nvarchar(250),
	@Viewer5_Type varchar(50),
	@Viewer5_Label nvarchar(50),
	@Viewer5_Attribute nvarchar(250),
	@Viewer6_Type varchar(50),
	@Viewer6_Label nvarchar(50),
	@Viewer6_Attribute nvarchar(250)
AS
BEGIN 

	
	-- Add the first viewer information, if provided
	if ( len(coalesce(@Viewer1_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer1_TypeID int;
		set @Viewer1_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer1_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer1_TypeID > 0 )
		begin
			-- Does this already exist?
			if ( exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer1_TypeID ))
			begin
				-- Update this viewer information
				update SobekCM_Item_Viewers
				set Attribute=@Viewer1_Attribute, Label=@Viewer1_Label, Exclude='false'
				where ( ItemID = @ItemID )
				  and ( ItemViewTypeID = @Viewer1_TypeID );
			end
			else
			begin
				-- Insert this viewer information
				insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
				values ( @ItemID, @Viewer1_TypeID, @Viewer1_Attribute, @Viewer1_Label );
			end;
		end;
	end;
	
	-- Add the second viewer information, if provided
	if ( len(coalesce(@Viewer2_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer2_TypeID int;
		set @Viewer2_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer2_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer2_TypeID > 0 )
		begin
			-- Does this already exist?
			if ( exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer2_TypeID ))
			begin
				-- Update this viewer information
				update SobekCM_Item_Viewers
				set Attribute=@Viewer2_Attribute, Label=@Viewer2_Label, Exclude='false'
				where ( ItemID = @ItemID )
				  and ( ItemViewTypeID = @Viewer2_TypeID );
			end
			else
			begin
				-- Insert this viewer information
				insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
				values ( @ItemID, @Viewer2_TypeID, @Viewer2_Attribute, @Viewer2_Label );
			end;
		end;
	end;
	
	-- Add the third viewer information, if provided
	if ( len(coalesce(@Viewer3_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer3_TypeID int;
		set @Viewer3_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer3_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer3_TypeID > 0 )
		begin
			-- Does this already exist?
			if ( exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer3_TypeID ))
			begin
				-- Update this viewer information
				update SobekCM_Item_Viewers
				set Attribute=@Viewer3_Attribute, Label=@Viewer3_Label, Exclude='false'
				where ( ItemID = @ItemID )
					and ( ItemViewTypeID = @Viewer3_TypeID );
			end
			else
			begin
				-- Insert this viewer information
				insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
				values ( @ItemID, @Viewer3_TypeID, @Viewer3_Attribute, @Viewer3_Label );
			end;
		end;
	end;
	
	-- Add the fourth viewer information, if provided
	if ( len(coalesce(@Viewer4_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer4_TypeID int;
		set @Viewer4_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer4_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer4_TypeID > 0 )
		begin
			-- Does this already exist?
			if ( exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer4_TypeID ))
			begin
				-- Update this viewer information
				update SobekCM_Item_Viewers
				set Attribute=@Viewer4_Attribute, Label=@Viewer4_Label, Exclude='false'
				where ( ItemID = @ItemID )
				  and ( ItemViewTypeID = @Viewer4_TypeID );
			end
			else
			begin
				-- Insert this viewer information
				insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
				values ( @ItemID, @Viewer4_TypeID, @Viewer4_Attribute, @Viewer4_Label );
			end;
		end;
	end;
	
	-- Add the fifth viewer information, if provided
	if ( len(coalesce(@Viewer5_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer5_TypeID int;
		set @Viewer5_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer5_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer5_TypeID > 0 )
		begin
			-- Does this already exist?
			if ( exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer5_TypeID ))
			begin
				-- Update this viewer information
				update SobekCM_Item_Viewers
				set Attribute=@Viewer5_Attribute, Label=@Viewer5_Label, Exclude='false'
				where ( ItemID = @ItemID )
				  and ( ItemViewTypeID = @Viewer5_TypeID );
			end
			else
			begin
				-- Insert this viewer information
				insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
				values ( @ItemID, @Viewer5_TypeID, @Viewer5_Attribute, @Viewer5_Label );
			end;
		end;
	end;
	
	-- Add the sixth viewer information, if provided
	if ( len(coalesce(@Viewer6_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer6_TypeID int;
		set @Viewer6_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer6_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer6_TypeID > 0 )
		begin
			-- Does this already exist?
			if ( exists ( select 1 from SobekCM_Item_Viewers where ItemID=@ItemID and ItemViewTypeID=@Viewer6_TypeID ))
			begin
				-- Update this viewer information
				update SobekCM_Item_Viewers
				set Attribute=@Viewer6_Attribute, Label=@Viewer6_Label, Exclude='false'
				where ( ItemID = @ItemID )
				  and ( ItemViewTypeID = @Viewer6_TypeID );
			end
			else
			begin
				-- Insert this viewer information
				insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
				values ( @ItemID, @Viewer6_TypeID, @Viewer6_Attribute, @Viewer6_Label );
			end;
		end;
	end;
END;
GO


-- Remove an existing viewer for an item
-- NOTE: This does not delete any existing viewers
ALTER PROCEDURE [dbo].[SobekCM_Remove_Item_Viewers] 
	@ItemID int,
	@Viewer1_Type varchar(50),
	@Viewer2_Type varchar(50),
	@Viewer3_Type varchar(50),
	@Viewer4_Type varchar(50),
	@Viewer5_Type varchar(50),
	@Viewer6_Type varchar(50)
AS
BEGIN 

	-- Exclude the first viewer
	if ( len(coalesce(@Viewer1_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer1_TypeID int;
		set @Viewer1_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer1_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer1_TypeID > 0 )
		begin
			update SobekCM_Item_Viewers 
			set Exclude='true' 
			where ItemID=@ItemID and ItemViewTypeID=@Viewer1_TypeID;
		end;
	end;

	-- Exclude the second viewer
	if ( len(coalesce(@Viewer2_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer2_TypeID int;
		set @Viewer2_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer2_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer2_TypeID > 0 )
		begin
			update SobekCM_Item_Viewers 
			set Exclude='true' 
			where ItemID=@ItemID and ItemViewTypeID=@Viewer2_TypeID;
		end;
	end;

	-- Exclude the third viewer
	if ( len(coalesce(@Viewer3_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer3_TypeID int;
		set @Viewer3_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer3_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer3_TypeID > 0 )
		begin
			update SobekCM_Item_Viewers 
			set Exclude='true' 
			where ItemID=@ItemID and ItemViewTypeID=@Viewer3_TypeID;
		end;
	end;

	-- Exclude the fourth viewer
	if ( len(coalesce(@Viewer4_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer4_TypeID int;
		set @Viewer4_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer4_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer4_TypeID > 0 )
		begin
			update SobekCM_Item_Viewers 
			set Exclude='true' 
			where ItemID=@ItemID and ItemViewTypeID=@Viewer4_TypeID;
		end;
	end;

	-- Exclude the fifth viewer
	if ( len(coalesce(@Viewer5_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer5_TypeID int;
		set @Viewer5_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer5_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer5_TypeID > 0 )
		begin
			update SobekCM_Item_Viewers 
			set Exclude='true' 
			where ItemID=@ItemID and ItemViewTypeID=@Viewer5_TypeID;
		end;
	end;

	-- Exclude the sixth viewer
	if ( len(coalesce(@Viewer6_Type, '')) > 0 )
	begin
		-- Get the primary key for this viewer type
		declare @Viewer6_TypeID int;
		set @Viewer6_TypeID = coalesce(( select ItemViewTypeID from SobekCM_Item_Viewer_Types where ViewType = @Viewer6_Type ), -1 );

		-- Only continue if that viewer type was found
		if ( @Viewer6_TypeID > 0 )
		begin
			update SobekCM_Item_Viewers 
			set Exclude='true' 
			where ItemID=@ItemID and ItemViewTypeID=@Viewer6_TypeID;
		end;
	end;
END;
GO


/****** Object:  Index [IX_SobekCM_Item_Viewer_Types_ViewType]    Script Date: 6/4/2016 12:33:10 PM ******/
CREATE NONCLUSTERED INDEX [IX_SobekCM_Item_Viewer_Types_ViewType] ON [dbo].[SobekCM_Item_Viewer_Types]
(
	[ViewType] ASC
)
INCLUDE ( 	[ItemViewTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

