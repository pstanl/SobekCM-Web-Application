﻿#region Using directives

using System;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;
using SobekCM.Resource_Object;
using SobekCM.Resource_Object.Database;
using SobekCM.Library.Application_State;
using SobekCM.Library.Citation.Template;
using SobekCM.Library.HTML;
using SobekCM.Library.MainWriters;
using SobekCM.Library.MemoryMgmt;
using SobekCM.Library.Navigation;
using SobekCM.Library.Users;

#endregion

namespace SobekCM.Library.MySobekViewer
{
    /// <summary> Class allows an authenticated user to change the behaviors for all the items within a single title </summary>
    /// <remarks> This class extends the <see cref="abstract_MySobekViewer"/> class.<br /><br />
    /// MySobek Viewers are used for registration and authentication with mySobek, as well as performing any task which requires
    /// authentication, such as online submittal, metadata editing, and system administrative tasks.<br /><br />
    /// During a valid html request, the following steps occur:
    /// <ul>
    /// <li>Application state is built/verified by the <see cref="Application_State.Application_State_Builder"/> </li>
    /// <li>Request is analyzed by the <see cref="Navigation.SobekCM_QueryString_Analyzer"/> and output as a <see cref="SobekCM_Navigation_Object"/> </li>
    /// <li>Main writer is created for rendering the output, in his case the <see cref="Html_MainWriter"/> </li>
    /// <li>The HTML writer will create the necessary subwriter.  Since this action requires authentication, an instance of the  <see cref="MySobek_HtmlSubwriter"/> class is created. </li>
    /// <li>The mySobek subwriter creates an instance of this viewer to display the behaviors for mass updating</li>
    /// <li>This viewer uses the <see cref="SobekCM.Library.Citation.Template.Template"/> class to display the correct elements for editing </li>
    /// </ul></remarks>
    public class Mass_Update_Items_MySobekViewer : abstract_MySobekViewer
    {
        private readonly SobekCM_Item item;
        private readonly Template template;

        #region Constructor

        /// <summary> Constructor for a new instance of the Mass_Update_Items_MySobekViewer class </summary>
        /// <param name="User"> Authenticated user information </param>
        /// <param name="Current_Mode"> Mode / navigation information for the current request</param>
        /// <param name="Current_Item"> Individual digital resource to be edited by the user </param>
        /// <param name="Code_Manager"> Code manager contains the list of all valid aggregation codes </param>
        /// <param name="Tracer">Trace object keeps a list of each method executed and important milestones in rendering</param>
        public Mass_Update_Items_MySobekViewer(User_Object User, SobekCM_Navigation_Object Current_Mode, SobekCM_Item Current_Item,  Aggregation_Code_Manager Code_Manager, Custom_Tracer Tracer) : base(User)
        {
            Tracer.Add_Trace("Mass_Update_Items_MySobekViewer.Constructor", String.Empty);
            currentMode = Current_Mode;

            // Since this is a mass update, just create a new empty item with the GroupID included
            // from the provided item
            SobekCM_Item emptyItem = new SobekCM_Item {BibID = Current_Item.BibID};
            emptyItem.Web.GroupID = Current_Item.Web.GroupID;
            emptyItem.Bib_Info.Source.Code = String.Empty;
            emptyItem.Behaviors.CheckOut_Required_Is_Null = true;
            emptyItem.Behaviors.IP_Restriction_Membership_Is_Null = true;
            emptyItem.Behaviors.Dark_Flag_Is_Null = true;
            item = emptyItem;           

            // If the user cannot edit this item, go back
            if (!user.Can_Edit_This_Item(Current_Item))
            {
                currentMode.My_Sobek_Type = My_Sobek_Type_Enum.Home;
                HttpContext.Current.Response.Redirect(currentMode.Redirect_URL());
            }

            const string TEMPLATE_CODE = "massupdate";
            template = Cached_Data_Manager.Retrieve_Template(TEMPLATE_CODE, Tracer);
            if (template != null)
            {
                Tracer.Add_Trace("Mass_Update_Items_MySobekViewer.Constructor", "Found template in cache");
            }
            else
            {
                Tracer.Add_Trace("Mass_Update_Items_MySobekViewer.Constructor", "Reading template file");

                // Read this template
                Template_XML_Reader reader = new Template_XML_Reader();
                template = new Template();
                reader.Read_XML(SobekCM_Library_Settings.Base_MySobek_Directory + "templates\\defaults\\" + TEMPLATE_CODE + ".xml", template, true);

                // Add the current codes to this template
                template.Add_Codes(Code_Manager);

                // Save this into the cache
                Cached_Data_Manager.Store_Template(TEMPLATE_CODE, template, Tracer);
            }

            // See if there was a hidden request
            string hidden_request = HttpContext.Current.Request.Form["behaviors_request"] ?? String.Empty;

            // If this was a cancel request do that
            if (hidden_request == "cancel")
            {
                currentMode.Mode = Display_Mode_Enum.Item_Display;
                HttpContext.Current.Response.Redirect(currentMode.Redirect_URL());
            }
            else if (hidden_request == "save")
            {
                // Save these changes to bib
                template.Save_To_Bib(item, user, 1);

                // Save the behaviors
                SobekCM_Database.Save_Behaviors(item, false, true );

                // Store on the caches (to replace the other)
                Cached_Data_Manager.Remove_Digital_Resource_Objects(item.BibID, Tracer);

                // Forward
                currentMode.Mode = Display_Mode_Enum.Item_Display;
                HttpContext.Current.Response.Redirect(currentMode.Redirect_URL());
            }
        }

        #endregion

        /// <summary> Property indicates the standard navigation to be included at the top of the page by the
        /// main MySobek html subwriter. </summary>
        /// <value> This returns none since this viewer writes all the necessary navigational elements </value>
        /// <remarks> This is set to NONE if the viewer will write its own navigation and ADMIN if the standard
        /// administrative tabs should be included as well.  </remarks>
        public override MySobek_Included_Navigation_Enum Standard_Navigation_Type
        {
            get
            {
                return MySobek_Included_Navigation_Enum.NONE;
            }
        }

        /// <summary> Title for the page that displays this viewer, this is shown in the search box at the top of the page, just below the banner </summary>
        /// <value> This returns the value 'Mass Update Behaviors' </value>
        public override string Web_Title
        {
            get
            {
                return "Mass Update Behaviors";
            }
        }

        /// <summary> Add the HTML to be displayed in the main SobekCM viewer area (outside of the forms)</summary>
        /// <param name="Output"> Textwriter to write the HTML for this viewer</param>
        /// <param name="Tracer">Trace object keeps a list of each method executed and important milestones in rendering</param>
        /// <remarks> This class does nothing, since the interface list is added as controls, not HTML </remarks>
        public override void Write_HTML(TextWriter Output, Custom_Tracer Tracer)
        {
            Tracer.Add_Trace("Mass_Update_Items_MySobekViewer.Write_HTML", "Do nothing");
        }

        /// <summary> Add the HTML to be displayed in the main SobekCM viewer area </summary>
        /// <param name="Output"> Textwriter to write the HTML for this viewer</param>
        /// <param name="Tracer">Trace object keeps a list of each method executed and important milestones in rendering</param>
        /// <remarks> This class does nothing, since the individual metadata elements are added as controls, not HTML </remarks>
        public override void Add_HTML_In_Main_Form(TextWriter Output, Custom_Tracer Tracer)
        {
            Tracer.Add_Trace("Mass_Update_Items_MySobekViewer.Add_HTML_In_Main_Form", "");

            Output.WriteLine("<!-- Hidden field is used for postbacks to add new form elements (i.e., new name, new other titles, etc..) -->");
            Output.WriteLine("<input type=\"hidden\" id=\"behaviors_request\" name=\"behaviors_request\" value=\"\" />");

            Output.WriteLine("<!-- Mass_Update_Items_MySobekViewer.Add_HTML_In_Main_Form -->");
            Output.WriteLine("<div class=\"SobekText\">");
            Output.WriteLine("  <br />");

            Output.WriteLine("  <b>Change the behavior of all items belonging to this group</b>");
            Output.WriteLine("    <ul>");
            Output.WriteLine("      <li>Enter any behaviors you would like to have propogate through all the items within this item group.and press the SAVE button when complete.</li>");
            Output.WriteLine("      <li>Clicking on the green plus button ( <img class=\"repeat_button\" src=\"" + currentMode.Base_URL + "default/images/new_element_demo.jpg\" /> ) will add another instance of the element, if the element is repeatable.</li>");
            Output.WriteLine("      <li>Click <a href=\"" + SobekCM_Library_Settings.Help_URL(currentMode.Base_URL) + "help/behaviors\" target=\"_EDIT_INSTRUCTIONS\">here for detailed instructions</a> on mass updating behaviors online.</li>");

            Output.WriteLine("     </ul>");
            Output.WriteLine("</div>");
            Output.WriteLine();

            Output.WriteLine("<a name=\"template\"> </a>");
            Output.WriteLine("<br />");
            Output.WriteLine("<div class=\"ViewsBrowsesRow\">");
            Output.WriteLine(Selected_Tab_Start + "BEHAVIORS" + Selected_Tab_End + " ");
            Output.WriteLine("</div>");
            Output.WriteLine("<div class=\"SobekEditPanel\">");
            Output.WriteLine("<!-- Add SAVE and CANCEL buttons to top of form -->");
            Output.WriteLine("<script src=\"" + currentMode.Base_URL + "default/scripts/sobekcm_metadata.js\" type=\"text/javascript\"></script>");
            Output.WriteLine("<table width=\"100%\">");
            Output.WriteLine("  <tr>");
            Output.WriteLine("    <td width=\"480px\">&nbsp;</td>");
            Output.WriteLine("    <td align=\"right\">");
            Output.WriteLine("      <a onmousedown=\"behaviors_cancel_form(); return false;\"><img style=\"cursor: pointer;\" border=\"0px\" src=\"" + currentMode.Base_URL + "design/skins/" + currentMode.Base_Skin + "/buttons/cancel_button_g.gif\" alt=\"CANCEL\" /></a> &nbsp; &nbsp; ");
            Output.WriteLine("      <a onmousedown=\"behaviors_save_form(); return false;\"><img style=\"cursor: pointer;\" border=\"0px\" src=\"" + currentMode.Base_URL + "design/skins/" + currentMode.Base_Skin + "/buttons/save_button_g.gif\" alt=\"SAVE\" /></a>");
            Output.WriteLine("    </td>");
            Output.WriteLine("    <td width=\"20px\">&nbsp;</td>");
            Output.WriteLine("  </tr>");
            Output.WriteLine("</table>");

            bool isMozilla = false;
            if (currentMode.Browser_Type.ToUpper().IndexOf("FIREFOX") >= 0)
                isMozilla = true;

            template.Render_Template_HTML(Output, item, currentMode.Skin == currentMode.Default_Skin ? currentMode.Skin.ToUpper() : currentMode.Skin, isMozilla, user, currentMode.Language, Translator, currentMode.Base_URL, 1);

            // Add the second buttons at the bottom of the form
            Output.WriteLine("<!-- Add SAVE and CANCEL buttons to bottom of form -->");
            Output.WriteLine("<table width=\"100%\">");
            Output.WriteLine("  <tr>");
            Output.WriteLine("    <td width=\"480px\">&nbsp;</td>");
            Output.WriteLine("    <td align=\"right\">");
            Output.WriteLine("      <a onmousedown=\"behaviors_cancel_form(); return false;\"><img style=\"cursor: pointer;\" border=\"0px\" src=\"" + currentMode.Base_URL + "design/skins/" + currentMode.Base_Skin + "/buttons/cancel_button_g.gif\" alt=\"CANCEL\" /></a> &nbsp; &nbsp; ");
            Output.WriteLine("      <a onmousedown=\"behaviors_save_form(); return false;\"><img style=\"cursor: pointer;\" border=\"0px\" src=\"" + currentMode.Base_URL + "design/skins/" + currentMode.Base_Skin + "/buttons/save_button_g.gif\" alt=\"SAVE\" /></a>");
            Output.WriteLine("    </td>");
            Output.WriteLine("    <td width=\"20px\">&nbsp;</td>");
            Output.WriteLine("  </tr>");
            Output.WriteLine("</table>");
            Output.WriteLine("</div>");
            Output.WriteLine("<br />");
        }

        /// <summary> Add the HTML to be added near the top of the page for those viewers that implement pop-up forms for data retrieval </summary>
        /// <param name="Output"> Textwriter to write the pop-up form HTML for this viewer </param>
        /// <param name="Tracer"> Trace object keeps a list of each method executed and important milestones in rendering</param>
        /// <remarks> This adds any popup divisions for form metadata elements </remarks>
        public override void Add_Popup_HTML(TextWriter Output, Custom_Tracer Tracer)
        {
            Tracer.Add_Trace("Mass_Update_Items_MySobekViewer.Add_Popup_HTML", "Add any popup divisions for form elements");

            // Add the hidden field
            Output.WriteLine();
        }

        #region Method to add the controls to web page

        /// <summary> Add controls directly to the form, either to the main control area or to the file upload placeholder </summary>
        /// <param name="placeHolder"> Main place holder to which all main controls are added </param>
        /// <param name="uploadFilesPlaceHolder"> Place holder is used for uploading file </param>
        /// <param name="Tracer"> Trace object keeps a list of each method executed and important milestones in rendering</param>
        public override void Add_Controls(PlaceHolder placeHolder, PlaceHolder uploadFilesPlaceHolder, Custom_Tracer Tracer)
        {
            Tracer.Add_Trace("Mass_Update_Items_MySobekViewer.Add_Controls", "Do nothing");
        }

        #endregion
    }
}



