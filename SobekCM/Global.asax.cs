﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using SobekCM.Library;
using SobekCM.Library.Aggregations;
using SobekCM.Library.Application_State;
using SobekCM.Library.Settings;
using SobekCM.Library.Skins;

namespace SobekCM
{
	public class Global : System.Web.HttpApplication
	{
		// Values used by the SobekCM Library, as well as the SobekCM Web Application
		public static Checked_Out_Items_List Checked_List;
		public static Aggregation_Code_Manager Codes;
		public static Dictionary<string, string> Collection_Aliases;
		public static Dictionary<string, Wordmark_Icon> Icon_List;
		public static IP_Restriction_Ranges IP_Restrictions;
		public static Item_Lookup_Object Item_List;
		public static DateTime? Last_Refresh;
		public static Recent_Searches Search_History;
		public static SobekCM_Skin_Collection Skins;
		public static Statistics_Dates Stats_Date_Range;
		public static List<Thematic_Heading> Thematic_Headings;
		public static Language_Support_Info Translation;
		public static Portal_List URL_Portals;
		public static Dictionary<string, Mime_Type_Info> Mime_Types;

		protected void Application_Start(object sender, EventArgs e)
		{

		}

		protected void Session_Start(object sender, EventArgs e)
		{

		}

		protected void Application_BeginRequest(object sender, EventArgs e)
		{

		}

		protected void Application_AuthenticateRequest(object sender, EventArgs e)
		{

		}

		protected void Application_Error(object Sender, EventArgs E)
		{
			// Get the exception
			Exception objErr = Server.GetLastError();
			if (objErr == null)
				return;

			objErr = objErr.GetBaseException();

			try
			{
				// Justs clear the error for a number of common errors, caused by invalid requests to the server
				if ((objErr.Message.IndexOf("potentially dangerous") >= 0) || (objErr.Message.IndexOf("a control with id ") >= 0) || (objErr.Message.IndexOf("Padding is invalid and cannot be removed") >= 0) || (objErr.Message.IndexOf("This is an invalid webresource request") >= 0) ||
					((objErr.Message.IndexOf("File") >= 0) && (objErr.Message.IndexOf("does not exist") >= 0)))
				{
					// Clear the error
					Server.ClearError();
				}
				else
				{
					try
					{
						StreamWriter writer = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\temp\\exceptions.txt", true);
						writer.WriteLine();
						writer.WriteLine("Error Caught in Application_Error event ( " + DateTime.Now.ToString() + ")");
						writer.WriteLine("User Host Address: " + Request.UserHostAddress);
						writer.WriteLine("Requested URL: " + Request.Url);
						if (objErr is SobekCM_Traced_Exception)
						{
							SobekCM_Traced_Exception sobekException = (SobekCM_Traced_Exception)objErr;

							writer.WriteLine("Error Message: " + sobekException.InnerException.Message);
							writer.WriteLine("Stack Trace: " + objErr.StackTrace);
							writer.WriteLine("Error Message:" + sobekException.InnerException.StackTrace);
							writer.WriteLine();
							writer.WriteLine(sobekException.Trace_Route);
						}
						else
						{

							writer.WriteLine("Error Message: " + objErr.Message);
							writer.WriteLine("Stack Trace: " + objErr.StackTrace);
						}

						writer.WriteLine();
						writer.WriteLine("------------------------------------------------------------------");
						writer.Flush();
						writer.Close();
					}
					catch (Exception)
					{
						// Nothing else to do here.. no other known way to log this error
					}
				}
			}
			catch (Exception)
			{
				// Nothing else to do here.. no other known way to log this error
			}
			finally
			{
				// Clear the error
				Server.ClearError();

				string error_message = objErr.Message;
				if (objErr is SobekCM_Traced_Exception)
				{
					SobekCM_Traced_Exception sobekException = (SobekCM_Traced_Exception)objErr;
					error_message = sobekException.InnerException.Message;

				}

				try
				{
					if ((HttpContext.Current.Request.UserHostAddress == "127.0.0.1") || (HttpContext.Current.Request.UserHostAddress == HttpContext.Current.Request.ServerVariables["LOCAL_ADDR"]) || (HttpContext.Current.Request.Url.ToString().IndexOf("localhost") >= 0))
					{
						Response.Redirect("error_echo.html?text=" + error_message.Replace(" ", "_").Replace("&", "and").Replace("?", ""), false);
					}
					else
					{
						// Forward if there is a place to forward to.
						if (!String.IsNullOrEmpty(SobekCM_Library_Settings.System_Error_URL))
						{
							Response.Redirect(SobekCM_Library_Settings.System_Error_URL, false);
						}
						else
						{
							Response.Redirect("http://ufdc.ufl.edu/sobekcm/missing_config", false);
						}
					}
				}
				catch (Exception)
				{
					// Nothing else to do here.. no other known way to log this error
				}
			}

		}

		protected void Session_End(object sender, EventArgs e)
		{

		}

		protected void Application_End(object sender, EventArgs e)
		{

		}
	}
}