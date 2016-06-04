


IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SobekCM_Extension'))
BEGIN
	CREATE TABLE [dbo].[SobekCM_Extension](
		[ExtensionID] [int] IDENTITY(1,1) NOT NULL,
		[Code] [nvarchar](50) NOT NULL,
		[Description] [nvarchar](max) NOT NULL,
		[CurrentVersion] [varchar](50) NOT NULL,
		[IsEnabled] [bit] NOT NULL,
		[EnabledDate] [datetime] NULL,
		[LicenseKey] [nvarchar](max) NULL,
		[UpgradeUrl] [nvarchar](255) NULL,
		[LatestVersion] [varchar](50) NULL,
	 CONSTRAINT [PK_SobekCM_Extension] PRIMARY KEY CLUSTERED 
	(
		[ExtensionID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'TabPage' and Object_ID = Object_ID(N'SobekCM_Settings')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Settings add TabPage nvarchar(75) null;
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'Heading' and Object_ID = Object_ID(N'SobekCM_Settings')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Settings add Heading nvarchar(75) null;
END;


if ( NOT EXISTS (select * from sys.columns where Name = N'Hidden' and Object_ID = Object_ID(N'SobekCM_Settings')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Settings add Hidden bit not null default('false');
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'Reserved' and Object_ID = Object_ID(N'SobekCM_Settings')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Settings add Reserved smallint not null default(0);
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'Help' and Object_ID = Object_ID(N'SobekCM_Settings')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Settings add Help varchar(max) null;
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'Options' and Object_ID = Object_ID(N'SobekCM_Settings')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Settings add Options varchar(max) null;
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'SettingID' and Object_ID = Object_ID(N'SobekCM_Settings')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Settings add SettingID int identity(1,1);
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'Dimensions' and Object_ID = Object_ID(N'SobekCM_Settings')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Settings add Dimensions varchar(100);
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'Description' and Object_ID = Object_ID(N'SobekCM_Builder_Module_Schedule')))
BEGIN
	ALTER TABLE SobekCM_Builder_Module_Schedule ADD [Description] varchar(250) not null default('');
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'OrderOverride' and Object_ID = Object_ID(N'SobekCM_Item_Viewers')))
BEGIN
	ALTER TABLE SobekCM_Item_Viewers ADD OrderOverride int null;
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'Exclude' and Object_ID = Object_ID(N'SobekCM_Item_Viewers')))
BEGIN
	ALTER TABLE SobekCM_Item_Viewers ADD Exclude bit not null default('false');
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'Order' and Object_ID = Object_ID(N'SobekCM_Item_Viewer_Types')))
BEGIN
	ALTER TABLE SobekCM_Item_Viewer_Types ADD [Order] int not null default(100);
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'DefaultView' and Object_ID = Object_ID(N'SobekCM_Item_Viewer_Types')))
BEGIN
	ALTER TABLE SobekCM_Item_Viewer_Types ADD [DefaultView] bit not null default('false');
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'MenuOrder' and Object_ID = Object_ID(N'SobekCM_Item_Viewers')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Item_Viewers add MenuOrder float null;
END;
GO

if ( NOT EXISTS (select * from sys.columns where Name = N'MenuOrder' and Object_ID = Object_ID(N'SobekCM_Item_Viewer_Types')))
BEGIN
	ALTER TABLE [dbo].SobekCM_Item_Viewer_Types add MenuOrder float not null default(1000);
END;
GO

-- Update all the settings
update SobekCM_Settings set TabPage='Deprecated', Heading='Deprecated', Hidden=0, Reserved=0, Options='true|false', Help='Help for Allow Page Image File Management' where Setting_Key='Allow Page Image File Management'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='Server share for the web application''s network location.\n\nExample: ''\\\\lib-sandbox\\Production\\''' where Setting_Key='Application Server Network'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='Base URL which points to the web application.\n\nExamples: ''http://localhost/sobekcm/'', ''http://ufdc.ufl.edu/'', etc..' where Setting_Key='Application Server URL'
update SobekCM_Settings set TabPage='Builder', Heading='Archive Settings', Hidden=0, Reserved=0, Help='Network location for the archive drop box.  If this is set to a value, the builder/bulk loader will place a copy of the package in this folder for archiving purposes.  This folder is where any of your archiving processes should look for new packages.' where Setting_Key='Archive DropBox'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag indicates if the page turner view should be added automatically to all items with four or more pages.' where Setting_Key='Builder Add PageTurner ItemViewer'
update SobekCM_Settings set TabPage='Deprecated', Heading='Deprecated', Hidden=0, Reserved=0, Help='IIS web log location (usually a network share) for the builder to read the logs and add the usage statistics to the database.' where Setting_Key='Builder IIS Logs Directory'
update SobekCM_Settings set TabPage='Builder', Heading='Status', Hidden=0, Reserved=0, Help='Help for Builder Last Message' where Setting_Key='Builder Last Message'
update SobekCM_Settings set TabPage='Builder', Heading='Status', Hidden=0, Reserved=0, Help='Help for Builder Last Run Finished' where Setting_Key='Builder Last Run Finished'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Options='10|30|365|99999', Help='Number of days the SobekCM Builder logs are retained.' where Setting_Key='Builder Log Expiration in Days'
update SobekCM_Settings set TabPage='Builder', Heading='Status', Hidden=0, Reserved=0, Options='STANDARD OPERATION|PAUSE REQUESTED|ABORT REQUESTED|NO BUILDER REQUESTED ', Help='Last flag set when the builder/bulk loader ran.' where Setting_Key='Builder Operation Flag'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Options='15|60|300|600', Help='Number of seconds the builder remains idle before checking for new incoming package again.' where Setting_Key='Builder Seconds Between Polls'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag indicates is usage emails should be sent automatically after the stats usage has been calculated and added to the database.' where Setting_Key='Builder Send Usage Emails'
update SobekCM_Settings set TabPage='Builder', Heading='Status', Hidden=0, Reserved=0, Help='Help for Builder Version' where Setting_Key='Builder Version'
update SobekCM_Settings set TabPage='Deprecated', Heading='Deprecated', Hidden=0, Reserved=0, Help='URL for the AppFabric Cache host machine, if a caching server/cluster is in use in this system.' where Setting_Key='Caching Server'
update SobekCM_Settings set TabPage='General Settings', Heading='Search Settings', Hidden=0, Reserved=0, Options='true|false', Help='When this is set to TRUE, users can remove a single search term from their current search.  Setting this to FALSE, makes the display slightly cleaner.' where Setting_Key='Can Remove Single Search Term'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Online Management Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag dictates if users can submit items online, or if this is disabled in this system.' where Setting_Key='Can Submit Edit Online'
update SobekCM_Settings set TabPage='Deprecated', Heading='Deprecated', Hidden=0, Reserved=0, Options='true|false', Help='Flag dictates if users can submit items online, or if this is disabled in this system.' where Setting_Key='Can Submit Items Online'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag dictates if users can submit items online, or if this is disabled in this system.' where Setting_Key='Convert Office Files to PDF'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag indicates if the builder/bulk loader should create the MARC feed by default when operating in background mode.' where Setting_Key='Create MARC Feed By Default'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='System Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag indicates if more refined user permissions can be assigned, such as if a user can edit behaviors of an item in a collection vs. a more general flag that says a RequestSpecificValues.Current_User can make all changes to an item in a collection.' where Setting_Key='Detailed User Permissions'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='System Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag indicates if non system administrators are temporarily barred from logging on.' where Setting_Key='Disable Standard User Logon Flag'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='System Settings', Hidden=0, Reserved=0, Help='Message displayed if non syste administrators are temporarily barred from logging on.' where Setting_Key='Disable Standard User Logon Message'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='System Settings', Hidden=0, Reserved=0, Help='URL for the document-level solr index.\n\nExample: ''http://localhost:8080/documents''' where Setting_Key='Document Solr Index URL'
update SobekCM_Settings set TabPage='General Settings', Heading='Email Settings', Hidden=0, Reserved=0, Dimensions='300', Help='Email address that emails from this system should utilize' where Setting_Key='Email Default From Address'
update SobekCM_Settings set TabPage='General Settings', Heading='Email Settings', Hidden=0, Reserved=0, Dimensions='300', Help='Display name to associate with emails sent from this system (otherwise the instance/portal name will be used)' where Setting_Key='Email Default From Name'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Email Setup', Hidden=0, Reserved=0, Options='DATABASE MAIL|SMTP DIRECT', Help='Indicated whether the database mail system or the SMTP direct email system should be utilizied' where Setting_Key='Email Method'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Email Setup', Hidden=0, Reserved=0, Dimensions='70', Help='If direct SMTP email sending is used, the port to utilize.  This must be numeric.' where Setting_Key='Email SMTP Port'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Email Setup', Hidden=0, Reserved=0, Help='If direct SMTP email sending is used, the server name to send emails to.' where Setting_Key='Email SMTP Server'
update SobekCM_Settings set TabPage='General Settings', Heading='Search Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag determines if the facets are collapsible like an accordian, or if they all start fully expanded.' where Setting_Key='Facets Collapsible'
update SobekCM_Settings set TabPage='Florida SUS Settings', Heading='General Settings', Hidden=1, Reserved=0, Help='Location for the builder/bulk loader to look for incoming Florida Dark Archive XML reports to process and add to the history of digital resources.' where Setting_Key='FDA Report DropBox'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='General Settings', Hidden=0, Reserved=0, Help='Regular expressions used to exclude files from being added by default to the downloads of resources.\n\nExample: ''((.*?)\\.(jpg|tif|jp2|jpx|bmp|jpeg|gif|png|txt|pro|mets|db|xml|bak|job)$|qc_error.html)''' where Setting_Key='Files To Exclude From Downloads'
update SobekCM_Settings set TabPage='General Settings', Heading='Help Settings', Hidden=0, Reserved=0, Help='URL used for the help pages when users request help on metadata elements during online submit and editing.\n\nExample (and default): ''http://sobekrepository.org/''' where Setting_Key='Help Metadata URL'
update SobekCM_Settings set TabPage='General Settings', Heading='Help Settings', Hidden=0, Reserved=0, Help='URL used for the main help pages about this system''s basic functionality.\n\nExample (and default): ''http://sobekrepository.org/''' where Setting_Key='Help URL'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='Network location to the content for all of the digital resources (images, metadata, etc.).\n\nExample: ''C:\\inetpub\\wwwroot\\UFDC Web\\SobekCM\\content\\'' or ''\\\\ufdc-images\\content\\''' where Setting_Key='Image Server Network'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='URL which points to the digital resource images.\n\nExample: ''http://localhost/sobekcm/content/'' or ''http://ufdcimages.uflib.ufl.edu/''' where Setting_Key='Image Server URL'
update SobekCM_Settings set TabPage='General Settings', Heading='Instance Settings', Hidden=0, Reserved=0, Options='true|false', Help='This option controls whether a PARTNERS option appears on the main system home page, assuming there are multiple institutional aggregations.' where Setting_Key='Include Partners On System Home'
update SobekCM_Settings set TabPage='General Settings', Heading='Instance Settings', Hidden=0, Reserved=0, Options='true|false', Help='This option controls whether a TREE VIEW option appears on the main system home page which displays all the active aggregations hierarchically in a tree view.' where Setting_Key='Include TreeView On System Home'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Image Settings', Hidden=0, Reserved=0, Dimensions='60', Help='Restriction on the size of the jpeg page images'' height (in pixels) when generated automatically by the builder/bulk loader.\n\nDefault: ''1000''' where Setting_Key='JPEG Height'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Image Settings', Hidden=0, Reserved=0, Dimensions='60', Help='Restriction on the size of the jpeg page images'' width (in pixels) when generated automatically by the builder/bulk loader.\n\nDefault: ''630''' where Setting_Key='JPEG Width'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='URL for the Aware JPEG2000 Server for displaying and zooming into JPEG2000 images.' where Setting_Key='JPEG2000 Server'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Options='Built-In IIPImage|None', Help='Type of the JPEG2000 server found at the URL above.' where Setting_Key='JPEG2000 Server Type'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Help='Kakadu JPEG2000 script will override the specifications used when creating zoomable images.\n\nIf this is blank, the default specifications will be used which match those used by the National Digital Newspaper Program and University of Florida Digital Collections.' where Setting_Key='Kakadu JPEG2000 Create Command'
update SobekCM_Settings set TabPage='Deprecated', Heading='Deprecated', Hidden=0, Reserved=0, Help='Network location for the share within which the builder/bulk loader logs should be copied to become web accessible.\n\nExample: ''\\\\lib-sandbox\\Design\\extra\\logs\\''' where Setting_Key='Log Files Directory'
update SobekCM_Settings set TabPage='Deprecated', Heading='Deprecated', Hidden=0, Reserved=0, Help='URL for the builder/bulk loader logs files.\n\nExample: ''http://ufdc.ufl.edu/design/extra/logs/''' where Setting_Key='Log Files URL'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Help='This is the network location to the SobekCM Builder''s main incoming folder.\n\nThis is used by the SMaRT tool when doing bulk imports from spreadsheet or MARC records.' where Setting_Key='Main Builder Input Folder'
update SobekCM_Settings set TabPage='Florida SUS Settings', Heading='General Settings', Hidden=1, Reserved=0, Help='Florida SUS state-wide catalog base URL for determining the number of physical holdings which match a given search.\n\nExample: ''http://solrcits.fcla.edu/citsZ.jsp?type=search&base=uf''' where Setting_Key='Mango Union Search Base URL'
update SobekCM_Settings set TabPage='Florida SUS Settings', Heading='General Settings', Hidden=1, Reserved=0, Help='Text to display the number of hits found in the Florida SUS-wide catalog.\n\nUse the value ''%1'' in the string where the number of hits should be inserted.\n\nExample: ''%1 matches found in the statewide catalog''' where Setting_Key='Mango Union Search Text'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Metadata Settings', Hidden=0, Reserved=0, Dimensions='60', Help='Cataloging source code for the 040 field, ( for example ''FUG'' for University of Florida )' where Setting_Key='MARC Cataloging Source Code'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Metadata Settings', Hidden=0, Reserved=0, Dimensions='60', Help='Location code for the 852 |a - if none is given the system abbreviation will be used. Otherwise, the system abbreviation will be put in the 852 |b field.' where Setting_Key='MARC Location Code'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Metadata Settings', Hidden=0, Reserved=0, Help='Agency responsible for reproduction, or primary agency associated with the SobekCM instance ( for the added 533 |c field )\n\nThis 533 is not added for born digital items.' where Setting_Key='MARC Reproduction Agency'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Metadata Settings', Hidden=0, Reserved=0, Help='Place of reproduction, or primary location associated with the SobekCM instance ( for the added 533 |b field ).\n\nThis 533 is not added for born digital items.' where Setting_Key='MARC Reproduction Place'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Metadata Settings', Hidden=0, Reserved=0, Help='XSLT file to use as a final transform, after the standard MarcXML file is written.\n\nThis only affects generated MarcXML ( for the feeds and OAI ) not the dispayed in-system MARC ( as of January 2015 ).  This file should appear in the config/users folder.' where Setting_Key='MARC XSLT File'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Help='Network location or share where any geneated MarcXML feed should be written.\n\nExample: ''\\\\lib-sandbox\\Data\\''' where Setting_Key='MarcXML Feed Location'
update SobekCM_Settings set TabPage='Builder', Heading='Builder Settings', Hidden=0, Reserved=0, Help='If you wish to utilize an OCR engine in the builder/bulk loader, add the command-line call to the engine here.\n\nUse %1 as a place holder for the ingoing image file name and %2 as a placeholder for the output text file name.\n\nExample: ''C:\\OCR\\Engine.exe -in %1 -out %2''' where Setting_Key='OCR Engine Command'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='URL for the resource-level solr index used when searching for matching pages within a single document.\n\nExample: ''http://localhost:8080/pages''' where Setting_Key='Page Solr Index URL'
update SobekCM_Settings set TabPage='Builder', Heading='Archive Settings', Hidden=0, Reserved=0, Help='Regular expression indicates which files should be deleted AFTER being archived by the builder/bulk loader.\n\nExample: ''(.*?)\\.(tif)''' where Setting_Key='PostArchive Files To Delete'
update SobekCM_Settings set TabPage='Builder', Heading='Archive Settings', Hidden=0, Reserved=0, Help='Regular expression indicates which files should be deleted BEFORE being archived by the builder/bulk loader.\n\nExample: ''(.*?)\\.(QC.jpg)''' where Setting_Key='PreArchive Files To Delete'
update SobekCM_Settings set TabPage='General Settings', Heading='Email Settings', Hidden=0, Reserved=0, Help='Email address which receives notification if personal information (such as Social Security Numbers) is potentially found while loading or post-processing an item.\n\nIf you are using multiple email addresses, seperate them with a semi-colon.\n\nExample: ''person1@corp.edu;person2@corp.edu''' where Setting_Key='Privacy Email Address'
update SobekCM_Settings set TabPage='General Settings', Heading='Email Settings', Hidden=0, Reserved=0, Options='Always|Never', Help='Flag indicates when emails should be sent after new item aggregations are added through the web interface.' where Setting_Key='Send Email On Added Aggregation'
update SobekCM_Settings set TabPage='Deprecated', Heading='Deprecated', Hidden=0, Reserved=0, Options='true|false', Help='Some system settings are only applicable to institutions which are part of the Florida State University System.  Setting this value to TRUE will show these settings, while FALSE will suppress them.\n\nIf this value is changed, you willl need to save the settings for it to reload and reflect the change.' where Setting_Key='Show Florida SUS Settings'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Dimensions='200', Help='IP address for the web server running this web repository software.\n\nThis is used for setting restricted or dark material to only be available for the web server, which then acts as a proxy/web server to serve that content to authenticated users.' where Setting_Key='SobekCM Web Server IP'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='System Settings', Hidden=0, Reserved=0, Help='License code (encrypted) for spreadsheet library' where Setting_Key='Spreadsheet Library License'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Caching Settings', Hidden=0, Reserved=0, Help='Location where the static files are located for providing the full citation and text for indexing, either on the same server as the web application or as a network share.\n\nIt is recommended that these files be on the same server as the web server, rather than remote storage, to increase the speed in which requests from search engine indexers can be fulfilled.\n\nExample: ''C:\\inetpub\\wwwroot\\UFDC Web\\SobekCM\\data\\''.' where Setting_Key='Static Pages Location'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='Indicates the general source of all the static resources, such as javascript, system default stylesheets, images, and included libraries.\n\nUsing CDN will result in better performance, but can only be used when users will have access to the database.\n\nThis actually indicates which configuration file to read to determine the base location of the default resources.' where Setting_Key='Static Resources Source'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Caching Settings', Hidden=0, Reserved=0, Options='true|false', Help='Flag indicates if the basic usage and item count information should be cached for up to 24 hours as static XML files written in the web server''s temp directory.\n\nThis should be enabled if your library is quite large as it can take a fair amount of time to retrieve this information and these screens are made available for search engine index robots for indexing.' where Setting_Key='Statistics Caching Enabled'
update SobekCM_Settings set TabPage='General Settings', Heading='Instance Settings', Hidden=0, Reserved=0, Dimensions='100', Help='Base abbreviation to be used when the system refers to itself to the RequestSpecificValues.Current_User, such as the main tabs to take a user to the home pages.\n\nThis abbreviation should be kept as short as possible.\n\nExamples: ''UFDC'', ''dLOC'', ''Sobek'', etc..' where Setting_Key='System Base Abbreviation'
update SobekCM_Settings set TabPage='General Settings', Heading='Instance Settings', Hidden=0, Reserved=0, Help='Overall name of the system, to be used when creating MARC records and in several other locations.' where Setting_Key='System Base Name'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='Base URL which points to the web application.\n\nExamples: ''http://localhost/sobekcm/'', ''http://ufdc.ufl.edu/'', etc..' where Setting_Key='System Base URL'
update SobekCM_Settings set TabPage='General Settings', Heading='Instance Settings', Hidden=0, Reserved=0, Help='Default system user interface language.  If the user''s HTML request does not include a language supported by the interface or which does not include specific translations for a field, this default language is utilized.' where Setting_Key='System Default Language'
update SobekCM_Settings set TabPage='General Settings', Heading='Email Settings', Hidden=0, Reserved=0, Help='Default email address for the system, which is sent emails when users opt to contact the administrators.\n\nThis can be changed for individual aggregations but at least one email is required for the overall system.\n\nIf you are using multiple email addresses, seperate them with a semi-colon.\n\nExample: ''person1@corp.edu;person2@corp.edu''' where Setting_Key='System Email'
update SobekCM_Settings set TabPage='General Settings', Heading='Email Settings', Hidden=0, Reserved=0, Help='Email address used when a critical system error occurs which may require investigation or correction.\n\nIf you are using multiple email addresses, seperate them with a semi-colon.\n\nExample: ''person1@corp.edu;person2@corp.edu''' where Setting_Key='System Error Email'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Image Settings', Hidden=0, Reserved=0, Dimensions='60', Help='Restriction on the size of the page image thumbnails'' height (in pixels) when generated automatically by the builder/bulk loader.\n\nDefault: ''300''' where Setting_Key='Thumbnail Height'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Image Settings', Hidden=0, Reserved=0, Dimensions='60', Help='Restriction on the size of the page image thumbnails'' width (in pixels) when generated automatically by the builder/bulk loader.\n\nDefault: ''150''' where Setting_Key='Thumbnail Width'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Online Management Settings', Hidden=0, Reserved=0, Dimensions='600|3', Help='List of non-image extensions which are allowed to be uploaded into a digital resource.\n\nList should be the extensions, with the period, separated by commas.\n\nExample: .aif,.aifc,.aiff,.au,.avi,.bz2,.c,.c++,.css,.dbf,.ddl,...' where Setting_Key='Upload File Types'
update SobekCM_Settings set TabPage='Digital Resource Settings', Heading='Online Management Settings', Hidden=0, Reserved=0, Dimensions='600', Help='List of page image extensions which are allowed to be uploaded into a digital resource to display as page images.\n\nList should be the extensions, with the period, separated by commas.\n\nExample: .txt,.tif,.jpg,.jp2,.pro' where Setting_Key='Upload Image Types'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Server Settings', Hidden=0, Reserved=0, Help='Location where packages are built by users during online submissions and metadata updates.\n\nThis generally needs to be on the web server and have appropriate access for read/write.\n\nIf nothing is indicated in this field, the system will automatically use the ''mySobek\\InProcess'' subfolder under the web application.' where Setting_Key='Web In Process Submission Location'
update SobekCM_Settings set TabPage='System / Server Settings', Heading='Caching Settings', Hidden=0, Reserved=0, Options='0|1|2|3|5|10|15', Help='This setting controls how long the client''s browser is instructed to cache the served web page.\n\nSetting this value higher removes the round-trip when requesting a recently requested page.  It also means that some changes may not be reflected until the refresh button is pressed.\n\nIn general, this setting is only applied to public-style pages, and not personalized pages, such as the bookshelf views.' where Setting_Key='Web Output Caching Minutes'
GO

delete from SobekCM_Settings where Setting_Key='Log Files Directory';
delete from SobekCM_Settings where Setting_Key='Log Files URL';
GO

if ( not exists ( select 1 from SobekCM_Settings where Setting_Key = 'Show Citation For Dark Items' ))
begin
	insert into SobekCM_Settings (Setting_Key, Setting_Value, TabPage, Heading, Hidden, Reserved, Help, Options, Dimensions )
	values ( 'Show Citation For Dark Items', 'true', 'Digital Resource Settings', 'Online Behavior', 0, 0, 'Flag indicates if the citation is displayed online for DARK items.', 'true|false', null );
end;
GO


update SobekCM_Item_Viewer_Types set ViewType='DATASET_CODEBOOK' where ViewType='Dataset Codebook';
update SobekCM_Item_Viewer_Types set ViewType='DATASET_REPORTS' where ViewType='Dataset Reports';
update SobekCM_Item_Viewer_Types set ViewType='DATASET_VIEWDATA' where ViewType='Dataset View Data';
update SobekCM_Item_Viewer_Types set ViewType='GOOGLE_MAP' where ViewType='Google Map';
update SobekCM_Item_Viewer_Types set ViewType='PAGE_TURNER' where ViewType='Page Turner';
update SobekCM_Item_Viewer_Types set ViewType='RELATED_IMAGES' where ViewType='Related Images';
update SobekCM_Item_Viewer_Types set ViewType='TEXT' where ViewType='Text';
update SobekCM_Item_Viewer_Types set ViewType='JPEG_TEXT_TWO_UP' where ViewType='JPEG/Text Two Up';
update SobekCM_Item_Viewer_Types set ViewType='HTML' where ViewType='HTML Viewer';
GO


insert into SobekCM_Item_Viewer_Types ( ViewType, [Order] )
select ViewType, [Priority]
from SobekCM_Item_Viewer_Priority P
where not exists ( select 1 from SobekCM_Item_Viewer_Types T where P.ViewType=T.ViewType );
GO

update SobekCM_Item_Viewer_Types 
set [Order] = ( select [Priority] from SobekCM_Item_Viewer_Priority P where P.ViewType = SobekCM_Item_Viewer_Types.ViewType )
where exists ( select 1 from SobekCM_Item_Viewer_Priority P where P.ViewType = SobekCM_Item_Viewer_Types.ViewType );
GO

-- Update the menu order
update SobekCM_Item_Viewer_Types set MenuOrder=100 + [Order] where MenuOrder=null or MenuOrder=1000;
GO

-- Set the page viewers to the end.. all together
update SobekCM_Item_Viewer_Types set MenuOrder=500.1 where ViewType='JPEG';
update SobekCM_Item_Viewer_Types set MenuOrder=500.2 where ViewType='JPEG2000';
update SobekCM_Item_Viewer_Types set MenuOrder=500.3 where ViewType='TEXT';
GO

-- Set the citation viewers all at the beginning.. together
update SobekCM_Item_Viewer_Types set MenuOrder=10.1 where ViewType='CITATION';
GO

if ( exists ( select 1 from SobekCM_Item_Viewer_Types where ViewType='MARC' ))
	update SobekCM_Item_Viewer_Types set MenuOrder=10.2 where ViewType='MARC';
else
	insert into SobekCM_Item_Viewer_Types ( ViewType, [Order], [DefaultView], [MenuOrder]) values ( 'MARC', 100, 0, 10.2 );
GO

if ( exists ( select 1 from SobekCM_Item_Viewer_Types where ViewType='METADATA' ))
	update SobekCM_Item_Viewer_Types set MenuOrder=10.3 where ViewType='METADATA';
else
	insert into SobekCM_Item_Viewer_Types ( ViewType, [Order], [DefaultView], [MenuOrder]) values ( 'METADATA', 100, 0, 10.3 );
GO

	if ( exists ( select 1 from SobekCM_Item_Viewer_Types where ViewType='USAGE' ))
	update SobekCM_Item_Viewer_Types set MenuOrder=10.4 where ViewType='USAGE';
else
	insert into SobekCM_Item_Viewer_Types ( ViewType, [Order], [DefaultView], [MenuOrder]) values ( 'USAGE', 100, 0, 10.4 );
GO

-- Next, show all other volumes
update SobekCM_Item_Viewer_Types set MenuOrder=20 where ViewType='ALL_VOLUMES';
GO

-- Next, show search
update SobekCM_Item_Viewer_Types set MenuOrder=30 where ViewType='SEARCH';
GO

-- Show related images last.. before the actual page images
update SobekCM_Item_Viewer_Types set MenuOrder=400 where ViewType='RELATED_IMAGES';
GO

-- Set default views
update SobekCM_Item_Viewer_Types set DefaultView=1 where ViewType='CITATION';
update SobekCM_Item_Viewer_Types set DefaultView=1 where ViewType='MARC';
update SobekCM_Item_Viewer_Types set DefaultView=1 where ViewType='METADATA';
update SobekCM_Item_Viewer_Types set DefaultView=1 where ViewType='USAGE';
update SobekCM_Item_Viewer_Types set DefaultView=1 where ViewType='ALL_VOLUMES';
update SobekCM_Item_Viewer_Types set DefaultView=1 where ViewType='RELATED_IMAGES';
update SobekCM_Item_Viewer_Types set DefaultView=1 where ViewType='JPEG';
update SobekCM_Item_Viewer_Types set DefaultView=1 where ViewType='JPEG2000';
GO

-- Add default views to all items in this library
insert into SobeKCM_Item_Viewers (ItemID, ItemViewTypeID, Attribute, Label )
select ItemID, ItemViewTypeID, '', ''
from SObekCM_Item I, SobekCM_Item_Viewer_Types T
where ( T.DefaultView=1 )
 and ( not exists ( select 1 from SobekCM_Item_Viewers where ItemID=I.ItemID and ItemViewTypeID=T.ItemViewTypeID ));
GO


-- If not present, add the usage stats computation set
if ( not exists ( select 1 from SobekCM_Builder_Module_Set where SetName = 'Usage statistics computation' ))
begin
	insert into SobekCM_Builder_Module_Set ( ModuleTypeID, SetName, SetOrder, [Enabled] )
	values ( 5, 'Usage statistics calculation', 1, 1 );
end;
GO
   
-- Get the usage stats setid
declare @usagesetid int;
set @usagesetid = ( select ModuleSetID from SobekCM_Builder_Module_Set where SetName = 'Usage statistics calculation' );

-- If not present, add the usage stats computation module
if ( not exists ( select 1 from SobekCM_Builder_Module where Class = 'SobekCM.Builder_Library.Modules.Schedulable.CalculateUsageStatisticsModule' ))
begin
	insert into SobekCM_Builder_Module ( ModuleSetID, ModuleDesc, Class, [Enabled], [Order] )
	values ( @usagesetid, 'Usage statistics calculation and usage email sends', 'SobekCM.Builder_Library.Modules.Schedulable.CalculateUsageStatisticsModule', 1, 1 );
end;


-- Get the usage stats setid
declare @usagemoduleid int;
set @usagemoduleid = ( select ModuleID from SobekCM_Builder_Module where Class = 'SobekCM.Builder_Library.Modules.Schedulable.CalculateUsageStatisticsModule' );


-- Insert the schedule for this one
if ( not exists ( select 1 from SobekCM_Builder_Module_Schedule where ModuleSetID=@usagesetid ))
begin
	insert into SobekCM_Builder_Module_Schedule ( ModuleSetID, DaysOfWeek, [Enabled], TimesOfDay, [Description] )
	values ( @usagesetid, 'M', 'true', '0600', 'Calculate the usage statistics' );
end;
GO

-- Insert other schedules, if not existing
if (( not exists ( select 1 from SobekCM_Builder_Module_Schedule where ModuleSetID=5  )) and ( exists ( select 1 from SobekCM_Builder_Module_Set where ModuleSetID=5 and ModuleTypeID=5 )))
begin
	insert into SobekCM_Builder_Module_Schedule ( ModuleSetID, DaysOfWeek, [Enabled], TimesOfDay, [Description] )
	values ( 5, 'MWF', 'true', '0530', 'Expire old builder logs' );
end;
GO

-- Insert other schedules, if not existing
if (( not exists ( select 1 from SobekCM_Builder_Module_Schedule where ModuleSetID=6  )) and ( exists ( select 1 from SobekCM_Builder_Module_Set where ModuleSetID=6 and ModuleTypeID=5 )))
begin
	insert into SobekCM_Builder_Module_Schedule ( ModuleSetID, DaysOfWeek, [Enabled], TimesOfDay, [Description] )
	values ( 6, 'MTWRF', 'true', '0900', 'Rebuild all aggregation browse files' );
end;
GO

-- Insert other schedules, if not existing
if (( not exists ( select 1 from SobekCM_Builder_Module_Schedule where ModuleSetID=7  )) and ( exists ( select 1 from SobekCM_Builder_Module_Set where ModuleSetID=7 and ModuleTypeID=5 )))
begin
	insert into SobekCM_Builder_Module_Schedule ( ModuleSetID, DaysOfWeek, [Enabled], TimesOfDay, [Description] )
	values ( 7, 'MTWRF', 'true', '2100', 'Send new item emails' );
end;
GO

-- Insert other schedules, if not existing
if (( not exists ( select 1 from SobekCM_Builder_Module_Schedule where ModuleSetID=8  )) and ( exists ( select 1 from SobekCM_Builder_Module_Set where ModuleSetID=8 and ModuleTypeID=5 )))
begin
	insert into SobekCM_Builder_Module_Schedule ( ModuleSetID, DaysOfWeek, [Enabled], TimesOfDay, [Description] )
	values ( 8, 'S', 'true', '2200', 'Solr/Lucene index optimization' );
end;
GO

-- Insert other schedules, if not existing
if (( not exists ( select 1 from SobekCM_Builder_Module_Schedule where ModuleSetID=9  )) and ( exists ( select 1 from SobekCM_Builder_Module_Set where ModuleSetID=9 and ModuleTypeID=5 )))
begin
	insert into SobekCM_Builder_Module_Schedule ( ModuleSetID, DaysOfWeek, [Enabled], TimesOfDay, [Description] )
	values ( 9, 'MWF', 'true', '2130', 'Update all cached aggregation browses' );
end;
GO

-- Ensure the SobekCM_Random_Item stored procedure exists
IF object_id('SobekCM_Random_Item') IS NULL EXEC ('create procedure dbo.SobekCM_Random_Item as select 1;');
GO


-- Choose a random item from the entire digital library
-- that is public
ALTER PROCEDURE [dbo].[SobekCM_Random_Item] AS
BEGIN

	-- Get the minimum and maximum ids
	declare @minid int;
	declare @maxid int;
	set @minid = ( select MIN(GroupID) from SobekCM_Item_Group where Deleted = 'false' );
	set @maxid = ( select MAX(GroupID) from SobekCM_Item_Group where Deleted = 'false' );

	-- Pick a random if
	declare @randomid int;
	set @randomid = -1;
	declare @attempt int;
	set @attempt = 0;

	-- Loop here for about 20 times (since this is so relatively cheap)
	while (( @attempt <= 20 ) and ( @randomid < 0 ))
	begin

		set @randomid = @minid + ( RAND() * (@maxid - @minid ));

		if ( not exists ( select * from SobekCM_Item_Group G where Deleted='false' and GroupID = @randomid and exists ( select 1 from SobekCM_Item I where I.GroupID=@randomid and I.Deleted='false' and I.IP_Restriction_Mask = 0 and I.Dark = 'false' and I.[PageCount] > 0)))
		begin
			set @randomid = -1;
		end;

		set @attempt = @attempt + 1;
	end;

	-- Sometimes, the process above does not generate any BibID, so use the brute force method
	if ( @randomid < 0 )
	begin

		-- Get a small sample of rows, and assign top value
		with sample_rows_ordered AS (
			select GroupID, newid() as randomid
			from SobekCM_Item_Group G
			where exists ( select 1 from SobekCM_Item I where I.GroupID=G.GroupID and I.Deleted='false' and I.IP_Restriction_Mask = 0 and I.Dark = 'false' and I.[PageCount] > 0)
		)
		select @randomid = (select top 1 GroupID from sample_rows_ordered order by randomid);

	end;

	-- With the bibid in hand, now select a random vid
	select top 1 BibID, VID
	from SobekCM_Item I, SobekCM_Item_Group G
	where ( I.Deleted = 'false' )
	  and ( I.IP_Restriction_Mask = 0 )
	  and ( I.Dark = 'false' )
	  and ( G.GroupID = @randomid )
	  and ( G.GroupID = I.GroupID )
	  and ( I.[PageCount] > 0 )
	order by newid();

END;
GO


-- Return a list of the OAI data to server through the OAI-PMH server
ALTER PROCEDURE [dbo].[SobekCM_Get_OAI_Data]
	@aggregationcode varchar(20),
	@data_code varchar(20),
	@from date,
	@until date,
	@pagesize int, 
	@pagenumber int,
	@include_data bit
AS
begin

	-- No need to perform any locks here
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- Do not need to maintain row counts
	SET NoCount ON;

	-- Create the temporary tables first
	-- Create the temporary table to hold all the item id's
		
	-- Determine the start and end rows
	declare @rowstart int;
	declare @rowend int; 
	set @rowstart = (@pagesize * ( @pagenumber - 1 )) + 1;
	
	-- Rowend is calculated normally, but then an additional item is
	-- added at the end which will be used to determine if a resumption
	-- token should be issued
	set @rowend = (@rowstart + @pagesize - 1) + 1; 
	
	-- Ensure there are date values
	if ( @from is null )
		set @from = CONVERT(date,'19000101');
	if ( @until is null )
		set @until = GETDATE();
	
	-- Is this for a single aggregation
	if (( @aggregationcode is not null ) and ( LEN(@aggregationcode) > 0 ) and ( @aggregationcode != 'all' ))
	begin	
		-- Determine the aggregationid
		declare @aggregationid int;
		set @aggregationid = ( select ISNULL(AggregationID,-1) from SobekCM_Item_Aggregation where Code=@aggregationcode );
			  
		-- Should the actual data be returned, or just the identifiers?
		if ( @include_data='true')
		begin
			-- Create saved select across items/title for row numbers
			with ITEMS_SELECT AS
			(	select BibID, I.ItemID, VID,
				ROW_NUMBER() OVER (order by O.OAI_Date ASC ) as RowNumber
				from SobekCM_Item I, SobekCM_Item_Aggregation_Item_Link CL, SobekCM_Item_Group G, SobekCM_Item_OAI O
				where ( CL.ItemID = I.ItemID )
				  and ( CL.AggregationID = @aggregationid )
				  and ( I.GroupID = G.GroupID )
				  and ( I.ItemID = O.ItemID )
				  and ( G.Suppress_OAI = 'false' )
				  and ( O.OAI_Date >= @from )
				  and ( O.OAI_Date <= @until )
				  and ( O.Data_Code = @data_code )
				  and ( I.Dark = 'false' )
				  and ( I.IP_Restriction_Mask = 0 )
			)
			-- Select the matching rows
			select BibID, T.VID, O.OAI_Data, O.OAI_Date
			from ITEMS_SELECT T, SobekCM_Item_OAI O
			where RowNumber >= @rowstart
			  and RowNumber <= @rowend
			  and T.ItemID = O.ItemID			  
			  and O.Data_Code = @data_code;		 
		end
		else
		begin
			-- Create saved select across titles for row numbers
			with ITEMS_SELECT AS
			(	select BibID, I.ItemID, VID,
				ROW_NUMBER() OVER (order by O.OAI_Date ASC ) as RowNumber
				from SobekCM_Item I, SobekCM_Item_Aggregation_Item_Link CL, SobekCM_Item_Group G, SobekCM_Item_OAI O
				where ( CL.ItemID = I.ItemID )
				  and ( CL.AggregationID = @aggregationid )
				  and ( I.GroupID = G.GroupID )
				  and ( I.ItemID = O.ItemID )
				  and ( G.Suppress_OAI = 'false' )
				  and ( O.OAI_Date >= @from )
				  and ( O.OAI_Date <= @until )
				  and ( O.Data_Code = @data_code )
				  and ( I.Dark = 'false' )				  
				  and ( I.IP_Restriction_Mask = 0 )
			)				
			-- Select the matching rows
			select BibID, T.VID, O.OAI_Date
			from ITEMS_SELECT T, SobekCM_Item_OAI O
			where RowNumber >= @rowstart
			  and RowNumber <= @rowend
			  and T.ItemID = O.ItemID
			  and O.Data_Code = @data_code;	
		end;		  
	end
	else
	begin
				  
		-- Should the actual data be returned, or just the identifiers?
		if ( @include_data='true')
		begin
			-- Create saved select across titles for row numbers
			with ITEMS_SELECT AS
			(	select BibID, I.ItemID, VID,
				ROW_NUMBER() OVER (order by O.OAI_Date ASC) as RowNumber
				from SobekCM_Item_Group G, SobekCM_Item I, SobekCM_Item_OAI O
				where ( G.GroupID = I.GroupID )
				  and ( I.ItemID = O.ItemID )
				  and ( G.Suppress_OAI = 'false' )
				  and ( O.OAI_Date >= @from )
				  and ( O.OAI_Date <= @until )
				  and ( O.Data_Code = @data_code )
				  and ( I.Dark = 'false' )				  
				  and ( I.IP_Restriction_Mask = 0 )
			)												
			-- Select the matching rows
			select BibID, T.VID, O.OAI_Data, O.OAI_Date
			from ITEMS_SELECT T, SobekCM_Item_OAI O
			where RowNumber >= @rowstart
			  and RowNumber <= @rowend
			  and T.ItemID = O.ItemID
			  and O.Data_Code = @data_code;				 
		end
		else
		begin
			-- Create saved select across titles for row numbers
			with ITEMS_SELECT AS
			(	select BibID, I.ItemID, VID,
				ROW_NUMBER() OVER (order by O.OAI_Date ASC) as RowNumber
				from SobekCM_Item_Group G, SobekCM_Item I, SobekCM_Item_OAI O
				where ( G.GroupID = I.GroupID )
				  and ( I.ItemID = O.ItemID )
				  and ( G.Suppress_OAI = 'false' )
				  and ( O.OAI_Date >= @from )
				  and ( O.OAI_Date <= @until )
				  and ( O.Data_Code = @data_code )
				  and ( I.Dark = 'false' )				  
				  and ( I.IP_Restriction_Mask = 0 )
			)										
			-- Select the matching rows
			select BibID, T.VID, O.OAI_Date
			from ITEMS_SELECT T, SobekCM_Item_OAI O
			where RowNumber >= @rowstart
			  and RowNumber <= @rowend
			  and T.ItemID = O.ItemID
			  and O.Data_Code = @data_code;	
		end;
	end;
end;
GO

-- Ensure the SobekCM_Aggregation_Change_Parent stored procedure exists
IF object_id('SobekCM_Aggregation_Change_Parent') IS NULL EXEC ('create procedure dbo.SobekCM_Aggregation_Change_Parent as select 1;');
GO

-- Procedure will change the parent aggregation for an aggregation
-- Usage: 
--         First argument is the code for the aggregation to move
--         Second argument is the code the new parent aggregation for the aggregation
--             specified in the first argument.
ALTER PROCEDURE SobekCM_Aggregation_Change_Parent
	@aggr_to_move varchar(20),
	@new_parent varchar(20)
AS
BEGIN 

	SET NOCOUNT ON;
	
	-- Declare the message object to return
	declare @returnMessage varchar(255);

	-- Ensure the parent exists
	if ( not exists ( select 1 from SobekCM_Item_Aggregation where Code=@aggr_to_move ))
	begin
		print 'INVALID: Aggregation code to move is invalid';
		select 'INVALID: Aggregation code to move is invalid' as [Message], -1 as AffectedItems;
		return;
	end;

	if ( not exists ( select 1 from SobekCM_Item_Aggregation where Code=@new_parent ))
	begin
		print 'INVALID: New parent aggregation code is invalid';
		select 'INVALID: New parent aggregation code is invalid' as [Message], -1 as AffectedItems;
		return;
	end;

	-- Get the primary keys for the aggregations
	declare @new_parent_id int;
	declare @aggr_id int;
	set @new_parent_id = ( select AggregationID from SobekCM_Item_Aggregation where Code=@new_parent );
	set @aggr_id = ( select AggregationID from SobekCM_Item_Aggregation where Code=@aggr_to_move );
	
	-- Ensure a circular aggregation hierarchy loop is not being created

	-- Build list of all the parents, grandparents, etc..  (up to ten levels)
	select ParentID, 0 as [Level] into #ParentCheck from SobekCM_Item_Aggregation_Hierarchy where ChildID=@new_parent_id;	
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 1 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID;
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 2 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID and [Level]=1;
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 3 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID and [Level]=2;
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 4 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID and [Level]=3;
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 5 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID and [Level]=4;
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 6 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID and [Level]=5;
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 7 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID and [Level]=6;
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 8 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID and [Level]=7;
	insert into #ParentCheck (ParentID, [Level]) select H.ParentID, 9 from SobekCM_Item_Aggregation_Hierarchy H, #ParentCheck P where H.ChildID=P.ParentID and [Level]=8;

	-- Ensure the aggregation id is not listed in the temp table, which would indicate
	-- that the aggregation is actually a parent of what would be the parent (i.e., circular)
	if ( exists ( select 1 from #ParentCheck where ParentID=@aggr_id ))
	begin
		print 'INVALID: Provided parent aggregation is in the child hierarchy of the aggregation.  Circular aggregation hierarchy is invalid.';
		select 'INVALID: Provided parent aggregation is in the child hierarchy of the aggregation.  Circular aggregation hierarchy is invalid.' as [Message], -1 as AffectedItems;
		return;
	end;

	-- drop the temporary table now 
	drop table #ParentCheck;

	-- The rest of this work should be done in a transaction
	begin transaction;

		-- Clear the parent(s) for the aggregation to move
		delete from SobekCM_Item_Aggregation_Hierarchy 
		where ChildID = @aggr_id;

		-- Add the new link
		insert into SobekCM_Item_Aggregation_Hierarchy ( ParentID, ChildID )
		values ( @new_parent_id, @aggr_id );
	
		-- Get the list of affected children
		select ItemID
		into #AffectedItems
		from SobekCM_Item_Aggregation_Item_Link 
		where AggregationID = @aggr_id;

		-- Remove previously implied links from the affected items
		delete from SobekCM_Item_Aggregation_Item_Link
		where ( impliedLink = 'true' )
		  and ( ItemID in ( select ItemID from #AffectedItems ));

		-- Rebuild the implied links

		-- Add back the first implied links
		insert into SobekCM_Item_Aggregation_Item_Link (ItemID, AggregationID, impliedLink )
		select distinct L.ItemID, H.ParentID, 'true'
		from SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item_Aggregation_Hierarchy H, SobekCM_Item_Aggregation A, #AffectedItems I
		where ( L.AggregationID = H.ChildID )
			and ( L.AggregationID = A.AggregationID )
			and ( I.ItemID = L.ItemID )
			and not exists ( select * from SobekCM_Item_Aggregation_Item_Link T where T.ItemID = L.ItemID and T.AggregationID = H.ParentID );

		-- Add back the second level of implied links
		insert into SobekCM_Item_Aggregation_Item_Link (ItemID, AggregationID, impliedLink )
		select distinct L.ItemID, H.ParentID, 'true'
		from SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item_Aggregation_Hierarchy H, SobekCM_Item_Aggregation A, #AffectedItems I
		where ( L.AggregationID = H.ChildID )
			and ( L.ImpliedLink = 'true' )
			and ( L.AggregationID = A.AggregationID )
			and ( I.ItemID = L.ItemID )
			and not exists ( select * from SobekCM_Item_Aggregation_Item_Link T where T.ItemID = L.ItemID and T.AggregationID = H.ParentID );

		-- Add back the third level of implied links
		insert into SobekCM_Item_Aggregation_Item_Link (ItemID, AggregationID, impliedLink )
		select distinct L.ItemID, H.ParentID, 'true'
		from SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item_Aggregation_Hierarchy H, SobekCM_Item_Aggregation A, #AffectedItems I
		where ( L.AggregationID = H.ChildID )
			and ( L.ImpliedLink = 'true' )
			and ( L.AggregationID = A.AggregationID )
			and ( I.ItemID = L.ItemID )
			and not exists ( select * from SobekCM_Item_Aggregation_Item_Link T where T.ItemID = L.ItemID and T.AggregationID = H.ParentID );

		-- Add back the fourth level of implied links
		insert into SobekCM_Item_Aggregation_Item_Link (ItemID, AggregationID, impliedLink )
		select distinct L.ItemID, H.ParentID, 'true'
		from SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item_Aggregation_Hierarchy H, SobekCM_Item_Aggregation A, #AffectedItems I
		where ( L.AggregationID = H.ChildID )
			and ( L.ImpliedLink = 'true' )
			and ( L.AggregationID = A.AggregationID )
			and ( I.ItemID = L.ItemID )
			and not exists ( select * from SobekCM_Item_Aggregation_Item_Link T where T.ItemID = L.ItemID and T.AggregationID = H.ParentID );

		-- Add back the fifth level of implied links
		insert into SobekCM_Item_Aggregation_Item_Link (ItemID, AggregationID, impliedLink )
		select distinct L.ItemID, H.ParentID, 'true'
		from SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item_Aggregation_Hierarchy H, SobekCM_Item_Aggregation A, #AffectedItems I
		where ( L.AggregationID = H.ChildID )
			and ( L.ImpliedLink = 'true' )
			and ( L.AggregationID = A.AggregationID )
			and ( I.ItemID = L.ItemID )
			and not exists ( select * from SobekCM_Item_Aggregation_Item_Link T where T.ItemID = L.ItemID and T.AggregationID = H.ParentID );

		-- Also, mark all affected items to be reprocessed
		update SobekCM_Item
		set AdditionalWorkNeeded='true'
		where ItemID in ( select ItemID from #AffectedItems );

	commit transaction;

	-- Get the count of affected items and return a success message
	print 'Aggregation parent changed successfully';
	select 'Aggregation parent changed successfully' as [Message], count(*) as AffectedItems
	from #AffectedItems;

	-- Drop the temporary table
	drop table #AffectedItems;

END;
GO


-- Procedure allows the distinct metadata values in an aggregation to be viewed
ALTER PROCEDURE [dbo].[SobekCM_Get_Metadata_Browse]
	@aggregation_code varchar(20),
	@metadata_name varchar(100),
	@item_count_to_use_cached int
AS
begin
	-- No need to perform any locks here.  A slightly dirty read won't hurt much
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	-- Get the metadata type id
	declare @metadatatypeid int;
	set @metadatatypeid = ( select ISNULL(MetadataTypeID, -1) from SobekCM_Metadata_Types where MetadataName = @metadata_name );

	-- Get the aggregation id
	declare @aggregationid int;
	set @aggregationid = ( select ISNULL(AggregationID, -1) from SobekCM_Item_Aggregation where Code=@aggregation_code );	

	print 'metadataid=' + cast(@metadatatypeid as varchar(3));
	print 'aggregationid=' + cast(@aggregationid as varchar(3));

	-- Seperate code for metadata browsing ALL ITEMS, versus by aggregation
	if (( LEN(@aggregation_code) = 0 ) or ( @aggregation_code='all' ))
	begin
		-- How many items exist?
		if ((( select COUNT(*) from SobekCM_Item where IP_Restriction_Mask >= 0 ) >= @item_count_to_use_cached ) and 
		    (( select count(*) from SobekCM_Item_Aggregation_Metadata_Link where AggregationID=@aggregationid and MetadataTypeID=@metadatatypeid ) > 0 ))
		begin
			-- Now get the distinct values from the cached table
			select L.MetadataID, MetadataValue
			from SobekCM_Item_Aggregation_Metadata_Link L, SobekCM_Metadata_Unique_Search_Table M
			where ( L.AggregationID = @aggregationid )
			  and ( L.MetadataID = M.MetadataID )
			  and ( L.MetadataTypeID = @metadatatypeid )	
			order by MetadataValue;
		end
		else
		begin
			-- Now get the distinct values by actually going through the item links, but this
			-- time do it irrespective of which aggregations items are linked to 
			select distinct(S.MetadataID), MetadataValue
			from SobekCM_Metadata_Unique_Search_Table S, SobekCM_Metadata_Unique_Link X, SobekCM_Item L
			where ( S.MetadataTypeID = @metadatatypeid )
			  and ( X.ItemID = L.ItemID )
			  and ( X.MetadataID = S.MetadataID )
			  and ( L.IP_Restriction_Mask >= 0 )
			order by MetadataValue;
		end;	
	end
	else
	begin

		-- How many items are linked to this aggregation?
		if ((( select COUNT(*) from SobekCM_Item_Aggregation_Item_Link where AggregationID = @aggregationid  ) >= @item_count_to_use_cached ) and 
		    (( select count(*) from SobekCM_Item_Aggregation_Metadata_Link where AggregationID=@aggregationid and MetadataTypeID=@metadatatypeid ) > 0 ))
		begin
			-- Now get the distinct values from the cached table
			select L.MetadataID, MetadataValue
			from SobekCM_Item_Aggregation_Metadata_Link L, SobekCM_Metadata_Unique_Search_Table M
			where ( L.AggregationID = @aggregationid )
			  and ( L.MetadataID = M.MetadataID )
			  and ( L.MetadataTypeID = @metadatatypeid )	
			order by MetadataValue;
		end
		else
		begin
			-- Now get the distinct values by actually going through the item links
			select distinct(S.MetadataID), MetadataValue
			from SobekCM_Metadata_Unique_Search_Table S, SobekCM_Metadata_Unique_Link X, SobekCM_Item_Aggregation_Item_Link L
			where ( S.MetadataTypeID = @metadatatypeid )
			  and ( X.ItemID = L.ItemID )
			  and ( X.MetadataID = S.MetadataID )
			  and ( L.AggregationID = @aggregationid )
			order by MetadataValue;
		end;
	end;
end;
GO

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

-- Ensure the SobekCM_Builder_Log_Search stored procedure exists
IF object_id('SobekCM_Builder_Log_Search') IS NULL EXEC ('create procedure dbo.SobekCM_Builder_Log_Search as select 1;');
GO

-- Procedure returns builder logs, by date range and/or by bibid_vid
ALTER PROCEDURE SobekCM_Builder_Log_Search
	@startdate datetime,
	@enddate datetime,
	@bibid_vid varchar(20),
	@include_no_work_entries bit
AS
BEGIN

	-- Set the start date and end date if they are null
	if ( @startdate is null ) set @startdate = '1/1/2000';
	if ( @enddate is null ) set @enddate = dateadd(day, 1, getdate());

	-- If the @bibid_vid is NULL or empty, than this is only a date search
	if ( len(coalesce(@bibid_vid,'')) = 0 )
	begin
		-- Date search only needs to pay attention to the 'include no work' flag
		if ( @include_no_work_entries = 'true' )
		begin
			-- Just return all the date ranged rows
			select BuilderLogID, RelatedBuilderLogID, LogDate, coalesce(BibID_VID,'') as BibID_VID, coalesce(LogType,'') as LogType, coalesce(LogMessage,'') as LogMessage, SuccessMessage, METS_Type
			from SobekCM_Builder_Log
			where ( LogDate >= @startdate )
			  and ( LogDate <= @enddate )
			order by LogDate DESC;
		end
		else
		begin
			-- Only include the rows that are NOT 'No Work'
			select BuilderLogID, RelatedBuilderLogID, LogDate, coalesce(BibID_VID,'') as BibID_VID, coalesce(LogType,'') as LogType, coalesce(LogMessage,'') as LogMessage, SuccessMessage, METS_Type
			from SobekCM_Builder_Log
			where ( LogDate >= @startdate )
			  and ( LogDate <= @enddate )
			  and ( LogType != 'No Work' )
			order by LogDate DESC;
		end;
		return;
	end;

	-- Is this a LIKE search, or an exact search?
	if ( charindex('%', @bibid_vid ) > 0 )
	begin
		-- This is a LIKE expression
		select BuilderLogID, RelatedBuilderLogID, LogDate, coalesce(BibID_VID,'') as BibID_VID, coalesce(LogType,'') as LogType, coalesce(LogMessage,'') as LogMessage, SuccessMessage, METS_Type
		from SobekCM_Builder_Log
		where ( LogDate >= @startdate )
		  and ( LogDate <= @enddate )
		  and ( BibID_VID like @bibid_vid )
		order by LogDate DESC;
	end
	else
	begin
		-- This is an EXACT match
		select BuilderLogID, RelatedBuilderLogID, LogDate, coalesce(BibID_VID,'') as BibID_VID, coalesce(LogType,'') as LogType, coalesce(LogMessage,'') as LogMessage, SuccessMessage, METS_Type
		from SobekCM_Builder_Log
		where ( LogDate >= @startdate )
		  and ( LogDate <= @enddate )
		  and ( BibID_VID = @bibid_vid )
		order by LogDate DESC;
	end;
END;
GO


-- Ensure the SobekCM_Builder_Get_Latest_Update stored procedure exists
IF object_id('SobekCM_Builder_Get_Latest_Update') IS NULL EXEC ('create procedure dbo.SobekCM_Builder_Get_Latest_Update as select 1;');
GO

-- Gets the latest and greatest for when the builder ran, version, etc.. and also scheduled task information to show
ALTER procedure [dbo].[SobekCM_Builder_Get_Latest_Update]
as
begin

	-- Get the latest status / builder values which are stored in the settings table
	select Setting_Key, Setting_Value, Help, Options
	from SobekCM_Settings
	where ( Hidden = 'false' )
	  and ( TabPage = 'Builder' )
	  and ( Heading = 'Status' )
	order by TabPage, Heading, Setting_Key;

	
	-- Return all the scheduled type modules, with the schedule and the last run info
	with last_run_cte ( ModuleScheduleID, LastRun) as 
	(
		select ModuleScheduleID, MAX([Timestamp])
		from SobekCM_Builder_Module_Scheduled_Run
		group by ModuleScheduleID
	)
	-- Return all the scheduled type modules, along with information on when it was last run
	select S.ModuleSetID, S.SetName, S.[Enabled] as SetEnabled, C.ModuleScheduleID, C.[Enabled] as ScheduleEnabled, C.DaysOfWeek, C.TimesOfDay, C.[Description], coalesce(L.LastRun,'') as LastRun, coalesce(R.Outcome,'') as Outcome, coalesce(R.[Message],'') as [Message]
	from SobekCM_Builder_Module_Set S inner join
		 SobekCM_Builder_Module_Type T on S.ModuleTypeID = T.ModuleTypeID inner join
		 SobekCM_Builder_Module_Schedule C on C.ModuleSetID = S.ModuleSetID left outer join
		 last_run_cte L on L.ModuleScheduleID = C.ModuleScheduleID left outer join
		 SobekCM_Builder_Module_Scheduled_Run R on R.ModuleSchedRunID=L.ModuleScheduleID and R.[Timestamp] = L.LastRun
	where T.TypeAbbrev = 'SCHD'
	order by C.[Description], S.SetOrder;

end;
GO



-- Ensure the SobekCM_Builder_Get_Incoming_Folder stored procedure exists
IF object_id('SobekCM_Builder_Get_Incoming_Folder') IS NULL EXEC ('create procedure dbo.SobekCM_Builder_Get_Incoming_Folder as select 1;');
GO

-- Get the information about a single incoming folder
ALTER PROCEDURE [dbo].[SobekCM_Builder_Get_Incoming_Folder] 
	@FolderId int
AS
BEGIN

	-- Return all the data about it 
	select IncomingFolderId, NetworkFolder, ErrorFolder, ProcessingFolder, Perform_Checksum_Validation, Archive_TIFF, Archive_All_Files,
		   Allow_Deletes, Allow_Folders_No_Metadata, Allow_Metadata_Updates, FolderName, BibID_Roots_Restrictions,
		   F.ModuleSetID, S.SetName
	from SobekCM_Builder_Incoming_Folders F left outer join 
	     SobekCM_Builder_Module_Set S on F.ModuleSetID=S.ModuleSetID
	where F.IncomingFolderId=@FolderId;

	-- Also return the modules linked to each (enabled) folder module set
	select S.ModuleSetID, S.SetName, M.[Assembly], M.Class, M.[Enabled], M.Argument1, M.Argument2, M.Argument3, M.ModuleDesc, M.[Order], S.[Enabled]
	from SobekCM_Builder_Incoming_Folders F inner join
		 SobekCM_Builder_Module_Set S on S.ModuleSetID=F.ModuleSetID inner join 
		 SobekCM_Builder_Module M on M.ModuleSetID=S.ModuleSetID 	 
	where F.IncomingFolderId=@FolderId
	order by M.[Order];

END;
GO



-- Ensure the SobekCM_Builder_Get_Folder_Module_Sets stored procedure exists
IF object_id('SobekCM_Builder_Get_Folder_Module_Sets') IS NULL EXEC ('create procedure dbo.SobekCM_Builder_Get_Folder_Module_Sets as select 1;');
GO

-- Procedure returns the names (and details) of all the module sets used for folders
ALTER PROCEDURE [dbo].[SobekCM_Builder_Get_Folder_Module_Sets]
as
begin

	-- Get the count of used folder modules
	with folder_modules_used ( ModuleSetID, UsedCount ) as
	( 
		select ModuleSetID, count(*) as UsedCount
		from SobekCM_Builder_Incoming_Folders 
		group by ModuleSetID
	) 
	select S.ModuleSetID, S.SetName, coalesce(U.UsedCount, 0) as UsedCount
	from SobekCM_Builder_Module_Set S inner join 
		 SobekCM_Builder_Module_Type T on S.ModuleTypeID=T.ModuleTypeID left outer join
		 folder_modules_used U on U.ModuleSetID=S.ModuleSetID
	where ( T.TypeAbbrev = 'FOLD' )
	  and ( S.[Enabled] = 1 )
	order by UsedCount DESC;

	-- Also return the modules linked to each (enabled) folder module set
	select S.ModuleSetID, S.SetName, M.[Assembly], M.Class, M.[Enabled], M.Argument1, M.Argument2, M.Argument3, M.ModuleDesc, M.[Order]
	from SobekCM_Builder_Module_Set S inner join 
		 SobekCM_Builder_Module_Type T on S.ModuleTypeID=T.ModuleTypeID inner join
		 SobekCM_Builder_Module M on M.ModuleSetID=S.ModuleSetID
	where ( T.TypeAbbrev = 'FOLD' )
	  and ( S.[Enabled] = 1 )
	order by S.ModuleSetID, M.[Order];

end;
GO


-- Add a new incoming folder for the builder/bulk loader, or edit
-- an existing incoming folder (by incoming folder id)
ALTER PROCEDURE [dbo].[SobekCM_Builder_Incoming_Folder_Edit]
	@IncomingFolderId int,
	@NetworkFolder varchar(255),
	@ErrorFolder varchar(255),
	@ProcessingFolder varchar(255),
	@Perform_Checksum_Validation bit,
	@Archive_TIFF bit,
	@Archive_All_Files bit,
	@Allow_Deletes bit,
	@Allow_Folders_No_Metadata bit,
	@FolderName nvarchar(150),
	@BibID_Roots_Restrictions varchar(255),
	@ModuleSetID int,
	@NewID int output
AS 
BEGIN

	-- Is this a new incoming folder?
	if (( select COUNT(*) from SobekCM_Builder_Incoming_Folders where IncomingFolderId=@IncomingFolderId ) = 0 )
	begin	
		-- Insert new incoming folder
		insert into SobekCM_Builder_Incoming_Folders ( NetworkFolder, ErrorFolder, ProcessingFolder, Perform_Checksum_Validation, Archive_TIFF, Archive_All_Files, Allow_Deletes, Allow_Folders_No_Metadata, FolderName, Allow_Metadata_Updates, BibID_Roots_Restrictions, ModuleSetID )
		values ( @NetworkFolder, @ErrorFolder, @ProcessingFolder, @Perform_Checksum_Validation, @Archive_TIFF, @Archive_All_Files, @Allow_Deletes, @Allow_Folders_No_Metadata, @FolderName, 'true', @BibID_Roots_Restrictions, @ModuleSetID );
		
		-- Save the new id
		set @NewID = @@Identity;
	end
	else
	begin
		-- update existing incoming folder
		update SobekCM_Builder_Incoming_Folders
		set NetworkFolder=@NetworkFolder, ErrorFolder=@ErrorFolder, ProcessingFolder=@ProcessingFolder, 
			Perform_Checksum_Validation=@Perform_Checksum_Validation, Archive_TIFF=@Archive_TIFF, 
			Archive_All_Files=@Archive_All_Files, Allow_Deletes=@Allow_Deletes, 
			Allow_Folders_No_Metadata=@Allow_Folders_No_Metadata, FolderName=@FolderName,
			BibID_Roots_Restrictions=@BibID_Roots_Restrictions, ModuleSetID=@ModuleSetID
		where IncomingFolderId = @IncomingFolderId;
		
		-- Just return the same id
		set @NewID = @IncomingFolderId;	
	end;
END;
GO

-- Routine returns all the BUILDER-specific settings
ALTER procedure [dbo].[SobekCM_Builder_Get_Settings]
	@include_disabled bit
as
begin

	-- Always return all the incoming folders
	select IncomingFolderId, NetworkFolder, ErrorFolder, ProcessingFolder, Perform_Checksum_Validation, Archive_TIFF, Archive_All_Files,
		   Allow_Deletes, Allow_Folders_No_Metadata, Allow_Metadata_Updates, FolderName, BibID_Roots_Restrictions,
		   F.ModuleSetID, S.SetName
	from SobekCM_Builder_Incoming_Folders F left outer join 
	     SobekCM_Builder_Module_Set S on F.ModuleSetID=S.ModuleSetID;

	-- Return all the non-scheduled type modules
	if ( @include_disabled = 'true' )
	begin
		select M.ModuleID, M.[Assembly], M.Class, M.ModuleDesc, M.Argument1, M.Argument2, M.Argument3, M.[Enabled], S.ModuleSetID, S.SetName, S.[Enabled] as SetEnabled, T.TypeAbbrev, T.TypeDescription
		from SobekCM_Builder_Module M, SobekCM_Builder_Module_Set S, SobekCM_Builder_Module_Type T
		where M.ModuleSetID = S.ModuleSetID
		  and S.ModuleTypeID = T.ModuleTypeID
		  and T.TypeAbbrev <> 'SCHD'
		order by TypeAbbrev, S.SetOrder, M.[Order];
	end
	else
	begin
		select M.ModuleID, M.[Assembly], M.Class, M.ModuleDesc, M.Argument1, M.Argument2, M.Argument3, M.[Enabled], S.ModuleSetID, S.SetName, S.[Enabled] as SetEnabled, T.TypeAbbrev, T.TypeDescription
		from SobekCM_Builder_Module M, SobekCM_Builder_Module_Set S, SobekCM_Builder_Module_Type T
		where M.ModuleSetID = S.ModuleSetID
		  and S.ModuleTypeID = T.ModuleTypeID
		  and M.[Enabled] = 'true'
		  and S.[Enabled] = 'true'
		  and T.TypeAbbrev <> 'SCHD'
		order by TypeAbbrev, S.SetOrder, M.[Order];
	end;

	-- Return all the scheduled type modules, with the schedule and the last run info
	if ( @include_disabled = 'true' )
	begin
		with last_run_cte ( ModuleScheduleID, LastRun) as 
		(
			select ModuleScheduleID, MAX([Timestamp])
			from SobekCM_Builder_Module_Scheduled_Run
			group by ModuleScheduleID
		)
		-- Return all the scheduled type modules, along with information on when it was last run
		select M.ModuleID, M.[Assembly], M.Class, M.ModuleDesc, M.Argument1, M.Argument2, M.Argument3, M.[Enabled], S.ModuleSetID, S.SetName, S.[Enabled] as SetEnabled, T.TypeAbbrev, T.TypeDescription, C.ModuleScheduleID, C.[Enabled] as ScheduleEnabled, C.DaysOfWeek, C.TimesOfDay, L.LastRun
		from SobekCM_Builder_Module M inner join
			 SobekCM_Builder_Module_Set S on M.ModuleSetID = S.ModuleSetID inner join
			 SobekCM_Builder_Module_Type T on S.ModuleTypeID = T.ModuleTypeID inner join
			 SobekCM_Builder_Module_Schedule C on C.ModuleSetID = S.ModuleSetID left outer join
			 last_run_cte L on L.ModuleScheduleID = C.ModuleScheduleID
		where T.TypeAbbrev = 'SCHD'
		order by TypeAbbrev, S.SetOrder, M.[Order];
	end 
	else
	begin
		with last_run_cte ( ModuleScheduleID, LastRun) as 
		(
			select ModuleScheduleID, MAX([Timestamp])
			from SobekCM_Builder_Module_Scheduled_Run
			group by ModuleScheduleID
		)
		-- Return all the scheduled type modules, along with information on when it was last run
		select M.ModuleID, M.[Assembly], M.Class, M.ModuleDesc, M.Argument1, M.Argument2, M.Argument3, M.[Enabled], S.ModuleSetID, S.SetName, S.[Enabled] as SetEnabled, T.TypeAbbrev, T.TypeDescription, C.ModuleScheduleID, C.[Enabled] as ScheduleEnabled, C.DaysOfWeek, C.TimesOfDay, L.LastRun
		from SobekCM_Builder_Module M inner join
			 SobekCM_Builder_Module_Set S on M.ModuleSetID = S.ModuleSetID inner join
			 SobekCM_Builder_Module_Type T on S.ModuleTypeID = T.ModuleTypeID inner join
			 SobekCM_Builder_Module_Schedule C on C.ModuleSetID = S.ModuleSetID left outer join
			 last_run_cte L on L.ModuleScheduleID = C.ModuleScheduleID
		where T.TypeAbbrev = 'SCHD'
		  and M.[Enabled] = 'true'
		  and S.[Enabled] = 'true'
		  and C.[Enabled] = 'true'
		order by TypeAbbrev, S.SetOrder, M.[Order];
	end;

end;
GO


-- Gets the list of all system-wide settings from the database, including the full list of all
-- metadata search fields, possible workflows, and all disposition data
ALTER PROCEDURE [dbo].[SobekCM_Get_Settings]
	@IncludeAdminViewInfo bit
AS
begin

	-- No need to perform any locks here.  A slightly dirty read won't hurt much
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	-- Get all the standard SobekCM settings
	if ( @IncludeAdminViewInfo = 'true' )
	begin
		select Setting_Key, Setting_Value, TabPage, Heading, Hidden, Reserved, Help, Options, SettingID, Dimensions
		from SobekCM_Settings
		where Hidden = 'false'
		order by TabPage, Heading, Setting_Key;
	end 
	else
	begin
		select Setting_Key, Setting_Value
		from SobekCM_Settings;
	end;

	-- Return all the metadata search fields
	select MetadataTypeID, MetadataName, SobekCode, SolrCode, DisplayTerm, FacetTerm, CustomField, canFacetBrowse
	from SobekCM_Metadata_Types
	order by DisplayTerm;

	-- Return all the possible workflow types
	select WorkFlowID, WorkFlowName, WorkFlowNotes, Start_Event_Number, End_Event_Number, Start_And_End_Event_Number, Start_Event_Desc, End_Event_Desc
	from Tracking_WorkFlow;

	-- Return all the possible disposition options
	select DispositionID, DispositionFuture, DispositionPast, DispositionNotes
	from Tracking_Disposition_Type;

	-- Always return all the incoming folders
	select IncomingFolderId, NetworkFolder, ErrorFolder, ProcessingFolder, Perform_Checksum_Validation, Archive_TIFF, Archive_All_Files,
		   Allow_Deletes, Allow_Folders_No_Metadata, Allow_Metadata_Updates, FolderName, BibID_Roots_Restrictions,
		   F.ModuleSetID, S.SetName
	from SobekCM_Builder_Incoming_Folders F left outer join 
	     SobekCM_Builder_Module_Set S on F.ModuleSetID=S.ModuleSetID;

	-- Return all the non-scheduled type modules
	select M.ModuleID, M.[Assembly], M.Class, M.ModuleDesc, M.Argument1, M.Argument2, M.Argument3, M.[Enabled], S.ModuleSetID, S.SetName, S.[Enabled] as SetEnabled, T.TypeAbbrev, T.TypeDescription
	from SobekCM_Builder_Module M, SobekCM_Builder_Module_Set S, SobekCM_Builder_Module_Type T
	where M.ModuleSetID = S.ModuleSetID
	  and S.ModuleTypeID = T.ModuleTypeID
	  and T.TypeAbbrev <> 'SCHD'
	order by TypeAbbrev, S.SetOrder, M.[Order];


	-- Return all the scheduled type modules, with the schedule and the last run info
	with last_run_cte ( ModuleScheduleID, LastRun) as 
	(
		select ModuleScheduleID, MAX([Timestamp])
		from SobekCM_Builder_Module_Scheduled_Run
		group by ModuleScheduleID
	)
	-- Return all the scheduled type modules, along with information on when it was last run
	select M.ModuleID, M.[Assembly], M.Class, M.ModuleDesc, M.Argument1, M.Argument2, M.Argument3, M.[Enabled], S.ModuleSetID, S.SetName, S.[Enabled] as SetEnabled, T.TypeAbbrev, T.TypeDescription, C.ModuleScheduleID, C.[Enabled] as ScheduleEnabled, C.DaysOfWeek, C.TimesOfDay, L.LastRun
	from SobekCM_Builder_Module M inner join
		 SobekCM_Builder_Module_Set S on M.ModuleSetID = S.ModuleSetID inner join
		 SobekCM_Builder_Module_Type T on S.ModuleTypeID = T.ModuleTypeID inner join
		 SobekCM_Builder_Module_Schedule C on C.ModuleSetID = S.ModuleSetID left outer join
		 last_run_cte L on L.ModuleScheduleID = C.ModuleScheduleID
	where T.TypeAbbrev = 'SCHD'
	order by TypeAbbrev, S.SetOrder, M.[Order];

end;
GO


-- Pull any additional item details before showing this item
ALTER PROCEDURE [dbo].[SobekCM_Get_Item_Statistics]
	@BibID varchar(10),
	@VID varchar(5)
AS
BEGIN

	-- No need to perform any locks here
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	-- Get the item id
	declare @itemid int;
	set @itemid = coalesce( ( select I.ItemID from SobekCM_Item I, SobekCM_Item_Group G where I.GroupID=G.GroupID and I.VID=@vid and G.BibiD=@bibid ), -1 );

	-- Get the item id
	declare @groupid int;
	set @groupid = coalesce( ( select G.GroupID from SobekCM_Item_Group G where G.BibiD=@bibid ), -1 );

	with item_month_years ([Month], [Year]) as 
	(
		select [Month], [Year] from SobekCM_Item_Group_Statistics G where G.GroupID=@groupID
		union
		select [Month], [Year] from SobekCM_Item_Statistics I where I.ItemID=@itemid
	)
	select M.[Year], M.[Month], coalesce(G.Hits,0) as Title_Views, coalesce(G.[Sessions],0) as Title_Visitors, coalesce(I.Hits,0) as [Views], coalesce(I.[Sessions],0) as Visitors
	from item_month_years M left outer join
		 SobekCM_Item_Statistics as I on I.[Month]=M.[Month] and I.[Year]=M.[Year] and I.ItemID=@itemid left outer join
		 SobekCM_Item_Group_Statistics as G on M.[Month]=G.[Month] and M.[Year]=G.[Year] and G.GroupID=@groupid
	order by [Year] ASC, [Month] ASC;			  
END;
GO

-- Ensure the Tracking_Get_Work_History stored procedure exists
IF object_id('Tracking_Get_Work_History') IS NULL EXEC ('create procedure dbo.Tracking_Get_Work_History as select 1;');
GO

-- Get the tracking work history against this item and the milestones
ALTER PROCEDURE [dbo].[Tracking_Get_Work_History]
	@bibid varchar(10),
	@vid varchar(5)
AS
BEGIN	

	-- No need to perform any locks here
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	-- Get the item id
	declare @itemid int;
	set @itemid = coalesce( ( select I.ItemID from SobekCM_Item I, SobekCM_Item_Group G where I.GroupID=G.GroupID and I.VID=@vid and G.BibiD=@bibid ), -1 );

	-- Get the item id
	declare @groupid int;
	set @groupid = coalesce( ( select G.GroupID from SobekCM_Item_Group G where G.BibiD=@bibid ), -1 );

	-- Return all the progress information for this volume
	select P.WorkFlowID, [Workflow Name]=WorkFlowName, [Completed Date]=isnull(CONVERT(CHAR(10), DateCompleted, 102),''), WorkPerformedBy=isnull(WorkPerformedBy, ''), Note=isnull(ProgressNote,'')
	from Tracking_Progress P, Tracking_Workflow W
	where (P.workflowid = W.workflowid)
	  and (P.ItemID = @itemid )
	order by DateCompleted ASC;		

	-- Return the milestones as well
	select CreateDate, Milestone_DigitalAcquisition, Milestone_ImageProcessing, Milestone_QualityControl, Milestone_OnlineComplete, Material_Received_Date, Disposition_Date from SobekCM_Item where ItemID=@itemid;
		
END
GO




-- Pull any additional item details before showing this item
ALTER PROCEDURE [dbo].[SobekCM_Get_Item_Details2]
	@BibID varchar(10),
	@VID varchar(5)
AS
BEGIN

	-- No need to perform any locks here
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- Was this for one item within a group?
	if ( LEN( ISNULL(@VID,'')) > 0 )
	begin	
	
		-- Only continue if there is ONE match
		if (( select COUNT(*) from SobekCM_Item I, SobekCM_Item_Group G where I.GroupID = G.GroupID and G.BibID = @BibID and I.VID = @VID ) = 1 )
		begin
			-- Get the itemid
			declare @ItemID int;
			select @ItemID = ItemID from SobekCM_Item I, SobekCM_Item_Group G where I.GroupID = G.GroupID and G.BibID = @BibID and I.VID = @VID;

			-- Return any descriptive tags
			select U.FirstName, U.NickName, U.LastName, G.BibID, I.VID, T.Description_Tag, T.TagID, T.Date_Modified, U.UserID, isnull([PageCount], 0) as Pages, ExposeFullTextForHarvesting
			from mySobek_User U, mySobek_User_Description_Tags T, SobekCM_Item I, SobekCM_Item_Group G
			where ( T.ItemID = @ItemID )
			  and ( I.ItemID = T.ItemID )
			  and ( I.GroupID = G.GroupID )
			  and ( T.UserID = U.UserID );
			
			-- Return the aggregation information linked to this item
			select A.Code, A.Name, A.ShortName, A.[Type], A.Map_Search, A.DisplayOptions, A.Items_Can_Be_Described, L.impliedLink, A.Hidden, A.isActive, ISNULL(A.External_Link,'') as External_Link
			from SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item_Aggregation A
			where ( L.ItemID = @ItemID )
			  and ( A.AggregationID = L.AggregationID );
		  
			-- Return information about the actual item/group
			select G.BibID, I.VID, G.File_Location, G.SuppressEndeca, 'true' as [Public], I.IP_Restriction_Mask, G.GroupID, I.ItemID, I.CheckoutRequired, Total_Volumes=(select COUNT(*) from SobekCM_Item J where G.GroupID = J.GroupID ),
				isnull(I.Level1_Text, '') as Level1_Text, isnull( I.Level1_Index, 0 ) as Level1_Index, 
				isnull(I.Level2_Text, '') as Level2_Text, isnull( I.Level2_Index, 0 ) as Level2_Index, 
				isnull(I.Level3_Text, '') as Level3_Text, isnull( I.Level3_Index, 0 ) as Level3_Index,
				G.GroupTitle, I.TextSearchable, Comments=isnull(I.Internal_Comments,''), Dark, G.[Type],
				I.Title, I.Publisher, I.Author, I.Donor, I.PubDate, G.ALEPH_Number, G.OCLC_Number, I.Born_Digital, 
				I.Disposition_Advice, I.Material_Received_Date, I.Material_Recd_Date_Estimated, I.Tracking_Box, I.Disposition_Advice_Notes, 
				I.Left_To_Right, I.Disposition_Notes, G.Track_By_Month, G.Large_Format, G.Never_Overlay_Record, I.CreateDate, I.SortDate, 
				G.Primary_Identifier_Type, G.Primary_Identifier, G.[Type] as GroupType, coalesce(I.MainThumbnail,'') as MainThumbnail,
				T.EmbargoEnd, coalesce(T.UMI,'') as UMI, T.Original_EmbargoEnd, coalesce(T.Original_AccessCode,'') as Original_AccessCode
			from SobekCM_Item as I inner join
				 SobekCM_Item_Group as G on G.GroupID=I.GroupID left outer join
				 Tracking_Item as T on T.ItemID=I.ItemID
			where ( I.ItemID = @ItemID );
		  
			-- Return any ticklers associated with this item
			select MetadataValue
			from SobekCM_Metadata_Unique_Search_Table M, SobekCM_Metadata_Unique_Link L
			where ( L.ItemID = @ItemID ) 
			  and ( L.MetadataID = M.MetadataID )
			  and ( M.MetadataTypeID = 20 );
			
			-- Return the viewers for this item
			select T.ViewType, V.Attribute, V.Label, coalesce(V.MenuOrder, T.MenuOrder) as MenuOrder, V.Exclude, coalesce(V.OrderOverride, T.[Order])
			from SobekCM_Item_Viewers V, SobekCM_Item_Viewer_Types T
			where ( V.ItemID = @ItemID )
			  and ( V.ItemViewTypeID = T.ItemViewTypeID )
			group by T.ViewType, V.Attribute, V.Label, coalesce(V.MenuOrder, T.MenuOrder), V.Exclude, coalesce(V.OrderOverride, T.[Order])
			order by coalesce(V.OrderOverride, T.[Order]) ASC;
				
			-- Return the icons for this item
			select Icon_URL, Link, Icon_Name, I.Title
			from SobekCM_Icon I, SobekCM_Item_Icons L
			where ( L.IconID = I.IconID ) 
			  and ( L.ItemID = @ItemID )
			order by Sequence;
			  
			-- Return any web skin restrictions
			select S.WebSkinCode
			from SobekCM_Item_Group_Web_Skin_Link L, SobekCM_Item I, SobekCM_Web_Skin S
			where ( L.GroupID = I.GroupID )
			  and ( L.WebSkinID = S.WebSkinID )
			  and ( I.ItemID = @ItemID )
			order by L.Sequence;
		end;		
	end
	else
	begin
		-- Return the aggregation information linked to this item
		select GroupTitle, BibID, G.[Type], G.File_Location, isnull(AGGS.Code,'') AS Code, G.GroupID, isnull(GroupThumbnail,'') as Thumbnail, G.Track_By_Month, G.Large_Format, G.Never_Overlay_Record, G.Primary_Identifier_Type, G.Primary_Identifier
		from SobekCM_Item_Group AS G LEFT JOIN
			 ( select distinct(A.Code),  G2.GroupID
			   from SobekCM_Item_Group G2, SobekCM_Item IL, SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item_Aggregation A
		       where IL.ItemID=L.ItemID 
		         and A.AggregationID=L.AggregationID
		         and G2.GroupID=IL.GroupID
		         and G2.BibID=@BibID
		         and G2.Deleted='false'
		       group by A.Code, G2.GroupID ) AS AGGS ON G.GroupID=AGGS.GroupID
		where ( G.BibID = @BibID )
		  and ( G.Deleted = 'false' );

		-- Return the individual volumes
		select I.ItemID, Title, Level1_Text=isnull(Level1_Text,''), Level1_Index=isnull(Level1_Index,-1), Level2_Text=isnull(Level2_Text, ''), Level2_Index=isnull(Level2_Index, -1), Level3_Text=isnull(Level3_Text, ''), Level3_Index=isnull(Level3_Index, -1), Level4_Text=isnull(Level4_Text, ''), Level4_Index=isnull(Level4_Index, -1), Level5_Text=isnull(Level5_Text, ''), Level5_Index=isnull(Level5_Index,-1), I.MainThumbnail, I.VID, I.IP_Restriction_Mask, I.SortTitle, I.Dark
		from SobekCM_Item I, SobekCM_Item_Group G
		where ( G.GroupID = I.GroupID )
		  and ( G.BibID = @bibid )
		  and ( I.Deleted = 'false' )
		  and ( G.Deleted = 'false' )
		order by Level1_Index ASC, Level1_Text ASC, Level2_Index ASC, Level2_Text ASC, Level3_Index ASC, Level3_Text ASC, Level4_Index ASC, Level4_Text ASC, Level5_Index ASC, Level5_Text ASC, Title ASC;

		-- Get list of icon ids
		select distinct(IconID)
		into #TEMP_ICON
		from SobekCM_Item_Icons II, SobekCM_Item It, SobekCM_Item_Group G
		where ( It.GroupID = G.GroupID )
			and ( G.BibID = @bibid )
			and ( It.Deleted = 0 )
			and ( II.ItemID = It.ItemID )
		group by IconID;

		-- Return icons
		select Icon_URL, Link, Icon_Name, Title
		from SobekCM_Icon I, (	select distinct(IconID)
								from SobekCM_Item_Icons II, SobekCM_Item It, SobekCM_Item_Group G
								where ( It.GroupID = G.GroupID )
							 	  and ( G.BibID = @bibid )
								  and ( It.Deleted = 0 )
								  and ( II.ItemID = It.ItemID )
								group by IconID) AS T
		where ( T.IconID = I.IconID );
		
		-- Return any web skin restrictions
		select S.WebSkinCode
		from SobekCM_Item_Group_Web_Skin_Link L, SobekCM_Item_Group G, SobekCM_Web_Skin S
		where ( L.GroupID = G.GroupID )
		  and ( L.WebSkinID = S.WebSkinID )
		  and ( G.BibID = @BibID )
		order by L.Sequence;
		
		-- Get the distinct list of all aggregations linked to this item
		select distinct( Code )
		from SobekCM_Item_Aggregation A, SobekCM_Item_Aggregation_Item_Link L, SobekCM_Item_Group G, SobekCM_Item I
		where ( I.ItemID = L.ItemID )
		  and ( I.GroupID = G.GroupID )
		  and ( G.BibID = @BibID )
		  and ( L.AggregationID = A.AggregationID );		
	end;
		
	-- Get the list of related item groups
	select B.BibID, B.GroupTitle, R.Relationship_A_to_B AS Relationship
	from SobekCM_Item_Group A, SobekCM_Item_Group_Relationship R, SobekCM_Item_Group B
	where ( A.BibID = @bibid ) 
	  and ( R.GroupA = A.GroupID )
	  and ( R.GroupB = B.GroupID )
	union
	select A.BibID, A.GroupTitle, R.Relationship_B_to_A AS Relationship
	from SobekCM_Item_Group A, SobekCM_Item_Group_Relationship R, SobekCM_Item_Group B
	where ( B.BibID = @bibid ) 
	  and ( R.GroupB = B.GroupID )
	  and ( R.GroupA = A.GroupID );
		  
END;
GO



-- Saves all the main data for a new item in a SobekCM library, 
-- including the serial hierarchy, behaviors, tracking, and basic item information
-- Written by Mark Sullivan ( January 2011 )
ALTER PROCEDURE [dbo].[SobekCM_Save_New_Item]
	@GroupID int,
	@VID varchar(5),
	@PageCount int,
	@FileCount int,
	@Title nvarchar(500),
	@SortTitle nvarchar(500), --NEW
	@AccessMethod int,
	@Link varchar(500),
	@CreateDate datetime,
	@PubDate nvarchar(100),
	@SortDate bigint,
	@Author nvarchar(1000),
	@Spatial_KML varchar(4000),
	@Spatial_KML_Distance float,
	@DiskSize_KB bigint,
	@Spatial_Display nvarchar(1000), 
	@Institution_Display nvarchar(1000), 
	@Edition_Display nvarchar(1000),
	@Material_Display nvarchar(1000),
	@Measurement_Display nvarchar(1000), 
	@StylePeriod_Display nvarchar(1000), 
	@Technique_Display nvarchar(1000), 
	@Subjects_Display nvarchar(1000), 
	@Donor nvarchar(250),
	@Publisher nvarchar(1000),
	@TextSearchable bit,
	@MainThumbnail varchar(100),
	@MainJPEG varchar(100),
	@IP_Restriction_Mask smallint,
	@CheckoutRequired bit,
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
	@Level1_Text varchar(255),
	@Level1_Index int,
	@Level2_Text varchar(255),
	@Level2_Index int,
	@Level3_Text varchar(255),
	@Level3_Index int,
	@Level4_Text varchar(255),
	@Level4_Index int,
	@Level5_Text varchar(255),
	@Level5_Index int,
	@VIDSource varchar(150),
	@CopyrightIndicator smallint, 
	@Born_Digital bit,
	@Dark bit,
	@Material_Received_Date datetime,
	@Material_Recd_Date_Estimated bit,
	@Disposition_Advice int,
	@Disposition_Advice_Notes varchar(150),
	@Internal_Comments nvarchar(1000),
	@Tracking_Box varchar(25),
	@Online_Submit bit,
	@User varchar(50),
	@UserNotes varchar(1000),
	@UserID_To_Link int,
	@ItemID int output,
	@New_VID varchar(5) output
AS
begin transaction

	-- Set the return VID value and itemid first
	set @New_VID = @VID;
	set @ItemID = -1;

	-- Verify this is a new item before doing anything
	if ( (	 select count(*) from SobekCM_Item I where ( I.VID = @VID ) and ( I.GroupID = @GroupID ))  =  0 )
	begin
	
		-- Verify the VID is a complete bibid, otherwise find the next one
		if ( LEN(@VID) < 5 )
		begin
			declare @next_vid_number int;

			-- Find the next vid number
			select @next_vid_number = isnull(CAST(MAX(VID) as int) + 1,-1)
			from SobekCM_Item
			where GroupID = @GroupID;
			
			-- If no matches to this BibID, just start at 00001
			if ( @next_vid_number < 0 )
			begin
				select @New_VID = '00001'
			end
			else
			begin
				select @New_VID = RIGHT('0000' + (CAST( @next_vid_number as varchar(5))), 5);	
			end;	
		end;

		-- Add the values to the main SobekCM_Item table first
		insert into SobekCM_Item ( VID, [PageCount], FileCount, Deleted, Title, SortTitle, AccessMethod, Link, CreateDate, PubDate, SortDate, Author, Spatial_KML, Spatial_KML_Distance, GroupID, LastSaved, Donor, Publisher, TextSearchable, MainThumbnail, MainJPEG, CheckoutRequired, IP_Restriction_Mask, Level1_Text, Level1_Index, Level2_Text, Level2_Index, Level3_Text, Level3_Index, Level4_Text, Level4_Index, Level5_Text, Level5_Index, Last_MileStone, VIDSource, Born_Digital, Dark, Material_Received_Date, Material_Recd_Date_Estimated, Disposition_Advice, Internal_Comments, Tracking_Box, Disposition_Advice_Notes, Spatial_Display, Institution_Display, Edition_Display, Material_Display, Measurement_Display, StylePeriod_Display, Technique_Display, Subjects_Display )
		values (  @New_VID, @PageCount, @FileCount, 0, @Title, @SortTitle, @AccessMethod, @Link, @CreateDate, @PubDate, @SortDate, @Author, @Spatial_KML, @Spatial_KML_Distance, @GroupID, GETDATE(), @Donor, @Publisher, @TextSearchable, @MainThumbnail, @MainJPEG, @CheckoutRequired, @IP_Restriction_Mask, @Level1_Text, @Level1_Index, @Level2_Text, @Level2_Index, @Level3_Text, @Level3_Index, @Level4_Text, @Level4_Index, @Level5_Text, @Level5_Index, 0, @VIDSource, @Born_Digital, @Dark, @Material_Received_Date, @Material_Recd_Date_Estimated, @Disposition_Advice, @Internal_Comments, @Tracking_Box, @Disposition_Advice_Notes, @Spatial_Display, @Institution_Display, @Edition_Display, @Material_Display, @Measurement_Display, @StylePeriod_Display, @Technique_Display, @Subjects_Display  );
		
		-- Get the item id identifier for this row
		set @ItemID = @@identity;	
		
		-- Set the milestones to complete if this is NON-PRIVATE, NON-DARK, and BORN DIGITAL
		if (( @IP_Restriction_Mask >= 0 ) and ( @Dark = 'false' ) and ( @Born_Digital = 'true' ))
		begin
			update SobekCM_Item
			set Last_MileStone = 4, Milestone_DigitalAcquisition = CreateDate, Milestone_ImageProcessing=CreateDate, Milestone_QualityControl=CreateDate, Milestone_OnlineComplete=CreateDate 
			where ItemID=@ItemID;		
		end;
				
		-- If a size was included, set that value
		if ( @DiskSize_KB > 0 )
		begin
			update SobekCM_Item set DiskSize_KB = @DiskSize_KB where ItemID=@ItemID;
		end;

		-- Finally set the volume count for this group correctly
		update SobekCM_Item_Group
		set ItemCount = ( select count(*) from SobekCM_Item I where ( I.GroupID = @GroupID ) and ( I.Deleted = 'false' ))
		where GroupID = @GroupID;
		
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
				values ( @ItemID, @IconID, 1 );
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
				values ( @ItemID, @IconID, 2 );
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
				values ( @ItemID, @IconID, 3 );
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
				values ( @ItemID, @IconID, 4 );
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
				values ( @ItemID, @IconID, 5 );
			end;
		end;

		-- Clear all links to aggregations
		delete from SobekCM_Item_Aggregation_Item_Link where ItemID = @ItemID;

		-- Add all of the aggregations
		exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @AggregationCode1;
		exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @AggregationCode2;
		exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @AggregationCode3;
		exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @AggregationCode4;
		exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @AggregationCode5;
		exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @AggregationCode6;
		exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @AggregationCode7;
		exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @AggregationCode8;
		
		-- Create one string of all the aggregation codes
		declare @aggregationCodes varchar(100);
		set @aggregationCodes = rtrim(isnull(@AggregationCode1,'') + ' ' + isnull(@AggregationCode2,'') + ' ' + isnull(@AggregationCode3,'') + ' ' + isnull(@AggregationCode4,'') + ' ' + isnull(@AggregationCode5,'') + ' ' + isnull(@AggregationCode6,'') + ' ' + isnull(@AggregationCode7,'') + ' ' + isnull(@AggregationCode8,''));
	
		-- Update matching items to have the aggregation codes value
		update SobekCM_Item set AggregationCodes = @aggregationCodes where ItemID=@ItemID;

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
			exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @HoldingCode;
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
			exec SobekCM_Save_Item_Item_Aggregation_Link @ItemID, @SourceCode;
		end;
		
		-- Clear the links to all existing viewers
		delete from SobekCM_Item_Viewers where ItemID=@ItemID;

		-- Add all the default views
		insert into SobekCM_Item_Viewers ( ItemID, ItemViewTypeID, Attribute, Label )
		select @ItemID, ItemViewTypeID, '', ''
		from SobekCM_Item_Viewer_Types
		where DefaultView = 'true';
		
		-- Add the workhistory for this item being loaded
		if ( @Online_Submit = 'true' )
		begin
			-- Add progress for online submission completed
			insert into Tracking_Progress ( ItemID, WorkFlowID, DateCompleted, WorkPerformedBy, ProgressNote, WorkingFilePath )
			values ( @itemid, 29, getdate(), @user, @usernotes, '' );
		end
		else
		begin  
			-- Add progress for bulk loaded into the system through the Builder
			insert into Tracking_Progress ( ItemID, WorkFlowID, DateCompleted, WorkPerformedBy, ProgressNote, WorkingFilePath )
			values ( @itemid, 40, getdate(), @user, @usernotes, '' );	
		end;		
		
		-- Link this to the user?
		if ( @UserID_To_Link >= 1 )
		begin
			-- Link this user to the bibid, if not already linked
			if (( select COUNT(*) from mySobek_User_Bib_Link where UserID=@UserID_To_Link and GroupID = @groupid ) = 0 )
			begin
				insert into mySobek_User_Bib_Link ( UserID, GroupID )
				values ( @UserID_To_Link, @groupid );
			end;
			
			-- First, see if this user already has a folder named 'Submitted Items'
			declare @userfolderid int
			if (( select count(*) from mySobek_User_Folder where UserID=@UserID_To_Link and FolderName='Submitted Items') > 0 )
			begin
				-- Get the existing folder id
				select @userfolderid = UserFolderID from mySobek_User_Folder where UserID=@UserID_To_Link and FolderName='Submitted Items';
			end
			else
			begin
				-- Add this folder
				insert into mySobek_User_Folder ( UserID, FolderName, isPublic )
				values ( @UserID_To_Link, 'Submitted Items', 'false' );

				-- Get the new id
				select @userfolderid = @@identity;
			end;
			
			-- Add a new link then
			insert into mySobek_User_Item( UserFolderID, ItemID, ItemOrder, UserNotes, DateAdded )
			values ( @userfolderid, @itemid, 1, '', getdate() );
			
			-- Also link using the newer system, which links for statistical reporting, etc..
			-- This will likely replace the 'submitted items' folder technique from above
			insert into mySobek_User_Item_Link( UserID, ItemID, RelationshipID )
			values ( @UserID_To_Link, @ItemID, 1 );
		
		end;
	end;

commit transaction;
GO



GRANT EXECUTE ON SobekCM_Aggregation_Change_Parent to sobek_user;
GO

GRANT EXECUTE ON [dbo].[SobekCM_Builder_Get_Latest_Update] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_Builder_Get_Latest_Update] to sobek_builder;
GO


GRANT EXECUTE ON [dbo].SobekCM_Builder_Get_Folder_Module_Sets to sobek_user;
GRANT EXECUTE ON [dbo].SobekCM_Builder_Get_Folder_Module_Sets to sobek_builder;
GO

GRANT EXECUTE ON [dbo].SobekCM_Builder_Incoming_Folder_Delete to sobek_user;
GRANT EXECUTE ON [dbo].SobekCM_Builder_Incoming_Folder_Delete to sobek_builder;
GO

GRANT EXECUTE ON [dbo].SobekCM_Builder_Incoming_Folder_Edit to sobek_user;
GRANT EXECUTE ON [dbo].SobekCM_Builder_Incoming_Folder_Edit to sobek_builder;
GO

GRANT EXECUTE ON [dbo].[SobekCM_Builder_Get_Incoming_Folder] to sobek_user;
GRANT EXECUTE ON [dbo].[SobekCM_Builder_Get_Incoming_Folder] to sobek_builder;
GO

GRANT EXECUTE ON [dbo].[Tracking_Get_Work_History] to sobek_user;
GO