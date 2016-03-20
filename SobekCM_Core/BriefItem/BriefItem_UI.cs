﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace SobekCM.Core.BriefItem
{
    /// <summary> Data about a brief digital object item that is 
    /// computed once by the user interface and stored in the user interface
    /// cache for subsequent needs </summary>
    public class BriefItem_UI
    {
        private Dictionary<string, string> viewerCodesDictionary;  

        public List<string> Viewers_By_Priority { get; set; } 

        public List<string> Viewers_Menu_Order { get; set; }

        public void Add_Viewer_Code(string Code, string ViewerType )
        {
            // Ensure dictionary is not null
            if (viewerCodesDictionary == null)
                viewerCodesDictionary = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

            // Add this viewer code
            viewerCodesDictionary[Code] = ViewerType;
        }

        /// <summary> Gets the controlle viewer type string, based on the requested viewer code </summary>
        /// <param name="ViewerCode"> Viewer code, related to this request </param>
        /// <returns> Viewer type value </returns>
        public string Get_Viewer_Type(string ViewerCode)
        {
            // If the viewer is empty or null, just return the first
            if (!String.IsNullOrEmpty(ViewerCode))
            {
                // If there is an exact match, then return the view type
                if (viewerCodesDictionary.ContainsKey(ViewerCode))
                    return viewerCodesDictionary[ViewerCode];

                // If the viewer code has numbers, look for a more fuzzy match
                if ((ViewerCode.IndexOf("0") >= 0) || (ViewerCode.IndexOf("1") >= 0) || (ViewerCode.IndexOf("2") >= 0) ||
                    (ViewerCode.IndexOf("3") >= 0) || (ViewerCode.IndexOf("4") >= 0) || (ViewerCode.IndexOf("5") >= 0) ||
                    (ViewerCode.IndexOf("6") >= 0) || (ViewerCode.IndexOf("7") >= 0) || (ViewerCode.IndexOf("8") >= 0) ||
                    (ViewerCode.IndexOf("8") >= 0))
                {
                    // Build the fuzzy match viewer code
                    StringBuilder builder = new StringBuilder();
                    foreach (char thisChar in ViewerCode)
                    {
                        if (Char.IsNumber(thisChar))
                        {
                            if ((builder.Length == 0) || (builder[builder.Length - 1] != '#'))
                                builder.Append('#');
                        }
                        else
                        {
                            builder.Append(thisChar);
                        }
                    }

                    // Was THAT a match?
                    if (viewerCodesDictionary.ContainsKey(builder.ToString()))
                        return viewerCodesDictionary[builder.ToString()];
                }
            }

            // Just return the FIRST viewer then if there was a viewer
            if ( Viewers_By_Priority.Count > 0 )
                return Viewers_By_Priority[0];

            // If no viewers, that is in ERROR.. but return the CITATION only .. for now at least
            return "CITATION";
        }



    }
}