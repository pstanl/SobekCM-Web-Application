var spanArrayObjects;
var spanArray;

// Function to set the full screen mode 
function qc_set_fullscreen() {
	var y = $("#allThumbnailsOuterDiv1").offset().top;

	var window_height = $(window).height();
	var new_height = window_height - y - 63;

	$("#allThumbnailsOuterDiv1").height(new_height);
}

function Configure_QC( MaxPageCount ) {
    //get the list of all the thumbnail spans on the page
    spanArrayObjects = $("#allThumbnailsOuterDiv").children();

    spanArray = new Array();

    //get the spanIDs from the array of span objects 
    var j = 0;
    for (var i = 0; i < spanArrayObjects.length; i++)
    {
        if (spanArrayObjects[i].id.indexOf('span') == 0)
        {
            spanArray[j++] = spanArrayObjects[i].id;
        }
    }
}


//Updates the division types when a "New Division" checkbox is checked/unchecked
function UpdateDivDropdown(CheckBoxID) {
    var index = CheckBoxID.replace("newDivType", '');
    var checkBoxElement = document.getElementById(CheckBoxID);
    var selectDivTypeElement = document.getElementById('selectDivType' + index);
    var textDivNameElement = document.getElementById('txtDivName' + index);
    
    // Check the state of the checkbox 
    if (checkBoxElement.checked == true) {
        // This is the start of a new division, so enable the div-type controls
        selectDivTypeElement.disabled = false;
        textDivNameElement.disabled = false;
    } else {
        // This is no longer the beginning of a new division 
        selectDivTypeElement.disabled = true;

        // Enable the text div element, depending on if the curernt div can be named
        if (selectDivTypeElement.value.indexOf('!') == 0)
            textDivNameElement.disabled = false;
        else
            textDivNameElement.disabled = true;

        //update the subsequent divs
        var i = spanArray.indexOf('span' + index);

        // Since this is the first span on the page, set to MAIN.
        // Really, this needs to look up a hidden value in case this was not the first
        // page of thumbnails
        var divTypeToSet = 'Main';
        var divNameToSet = '';

        if (i > 0) {
            // Get the divtype from the previous division
            var previousSelectDivId = spanArray[i - 1].replace('span', 'selectDivType');
            divTypeToSet = document.getElementById(previousSelectDivId).value;
            var previousDivNameId = spanArray[i - 1].replace('span', 'txtDivName');
            divNameToSet = document.getElementById(previousDivNameId).value;
        }


        //set the page division type of all pages till the start of the next div
        while ((i < spanArray.length) && (document.getElementById(spanArray[i].replace('span', 'selectDivType')).disabled == true))
        {
            document.getElementById(spanArray[i].replace('span', 'selectDivType')).value = divTypeToSet;
            document.getElementById(spanArray[i].replace('span', 'txtDivName')).value = divNameToSet;
            if (divNameToSet.length > 0) {
                document.getElementById(spanArray[i].replace('span', 'divNameTableRow')).className = 'txtNamedDivVisible';
            } else {
                document.getElementById(spanArray[i].replace('span', 'divNameTableRow')).className = 'txtNamedDivHidden';
            }
            i++;
        }
    }
}

//Change all subsequent division types when one div type is changed. Also update the named division type textboxes as appropriate
function DivisionTypeChanged(SelectID)
{
    var index = SelectID.replace('selectDivType', '');
    var divisionTypeElement = document.getElementById(SelectID);

    var i = spanArray.indexOf('span' + index) + 1;
	var currVal = divisionTypeElement.value;

	//if the new Division type selected is a nameable div
	if (divisionTypeElement.value.indexOf('!') == 0)
	{
	    document.getElementById('divNameTableRow' + index).className = 'txtNamedDivVisible';

	    //Make the name textboxes of all other pages of this div visible
	    while ((i < spanArray.length) && (document.getElementById(spanArray[i].replace('span','selectDivType')).disabled==true))
	    {
	        document.getElementById(spanArray[i].replace('span', 'selectDivType')).value = currVal;
	        document.getElementById(spanArray[i].replace('span','txtDivName')).disabled = true;
	        document.getElementById(spanArray[i].replace('span','divNameTableRow')).className = 'txtNamedDivVisible';
	        i++;
	    }
	}
	else if(currVal.indexOf('!')==-1)
	{
	    //else if the division type selected is not a nameable div
	    //Hide the name textbox for this page
	    document.getElementById('divNameTableRow' + index).className = 'txtNamedDivHidden';
	
	    //Hide the name textboxes of all the other pages of this division type
	    while ((i < spanArray.length) && (document.getElementById(spanArray[i].replace('span', 'selectDivType')).disabled == true))
	    {
	        document.getElementById(spanArray[i].replace('span', 'selectDivType')).value = currVal;
	        document.getElementById(spanArray[i].replace('span', 'txtDivName')).value = '';
	        document.getElementById(spanArray[i].replace('span', 'divNameTableRow')).className = 'txtNamedDivHidden';
	        i++;
	    }
	}
}


//Update the division name through the textboxes of the division type when changed in one
function DivNameTextChanged(TextboxID)
{
    var index = TextboxID.replace('txtDivName', '');
    var divisionNameElement = document.getElementById(TextboxID);
    var i = spanArray.indexOf('span' + index) + 1;
    var currVal = divisionNameElement.value;
  
    //Update the textboxes of the same division after this one
    while ((i < spanArray.length) && (document.getElementById(spanArray[i].replace('span', 'selectDivType')).disabled == true)) {
        document.getElementById(spanArray[i].replace('span', 'txtDivName')).value = currVal;
	    i++;
    }
}

//Autonumber subsequent textboxes on changing one textbox value
//parameter textboxID = the ID of the pagination textbox changed by the user
//parameter mode: the autonumbering mode passed in from the qc itemviewer. 0:auto number all the pages of the entire item, 1: all the pages of the current division only, 
//2: No auto numbering
//parameter MaxPageCount: the max number of pages for the current item in qc. This refers to all the pages, not just the ones displayed on the screen (though this makes no difference from the javascript point of view.)

function PaginationTextChanged(TextboxID, Mode)
{

    //Mode '0': Autonumber all the thumbnail page names till the end
    //Mode '1': Autonumber all the thumbnail pages till the start of the next div
    //Mode '2': No autonumber

    if (Mode == '2')
        return;
    
    var textboxValue = document.getElementById(TextboxID).value;
    var index = TextboxID.replace('textbox', '');
	var lastNumber = textboxValue.split(" ")[(textboxValue.split(" ").length-1)];
	
	var textOnlyLastBox=document.getElementById('Autonumber_text_without_number');
	var numberOnlyLastBox=document.getElementById('Autonumber_number_only');
	
//	lastNumber = lastNumber.toUpperCase().trim();
	var matches = lastNumber.match(/\d+/g);
	var varRomanMatches = true;
	var isRomanLower=true;

    // Look for any potential roman numeral matches at the end of the string
	for(var x=0;x<lastNumber.length;x++)
	{
	    var c=lastNumber.charAt(x);
	    if("IVXLCDM".indexOf(c)==-1 && "ivxlcdm".indexOf(c)==-1)
	    {
		    varRomanMatches=false;
	    }
	}

    // Was there a match for numbers in the last portion?
	if (matches != null) 
	{
	   //if the number is at the end of the string, with a space before
	   if(matches.length == lastNumber.length)
	   {
	        //Set the QC form hidden variable with this mode
	        document.getElementById('autonumber_mode_from_form').value = Mode;
	        document.getElementById('Autonumber_number_system').value = 'decimal';
	        textOnlyLastBox.value = textboxValue.substr(0, textboxValue.length - matches.length);
	        var number = parseInt(lastNumber);
			for(var i=spanArray.indexOf('span' + index)+1; i < spanArray.length;i++)
			{
			    // If this is MODE 1, then look to see if this is the beginnnig of a new division
			    if ((Mode == '1') && (document.getElementById(spanArray[i].replace('span', 'selectDivType')).disabled == false))
			        break;

                // Determine and save the next numeric value
			    number++;
			    numberOnlyLastBox.value = number.toString();
			    
			    var inLoopTextBoxElment = document.getElementById(spanArray[i].replace('span', 'textbox'));
			    inLoopTextBoxElment.value = textOnlyLastBox.value + number;
			}

	        var hidden_filename = document.getElementById(spanArray[spanArray.length - 1].replace('span', 'filename'));
			document.getElementById('Autonumber_last_filename').value=hidden_filename.value;
	   }//end if
	}//end if
	else if(varRomanMatches==true)
	{
	   //alert('Possible roman numeral detected');
	   var romanToNumberError="No error";
	   
	   for(var x=0;x<lastNumber.length;x++)
		{
		  var c=lastNumber.charAt(x);
		  if("IVXLCDM".indexOf(c)>-1)
		  {
			  isRomanLower=false;
		  }
		  else
		  {
			 isRomanLower =true;
		  }
		}
//	   alert(isRomanLower);
	   
   
		var roman = lastNumber.toUpperCase().trim();
		
		if(roman.split('V').length>2||roman.split('L').length>2||roman.split('D').length>2)
		{
			romanToNumberError="Repeated use of V,L or D";
		}	  
		//Rule 1-check that a single letter is not repeated more than thrice
		var count=1;
		var last='Z';
		for(var x=0;x<roman.length;x++)
		{
		  //Duplicate?
		  if(roman.charAt(x)==last)
		  {
			count++;
			if(count==4)
			{
			  romanToNumberError="Single letter repeated more than thrice";
			}

		  }
		  else
		  {
			  count=1;
			  last = roman.charAt(x);
		  }
		}

		//Create an arraylist containing the values
		var ptr=0;
		var values = new Array();
		var maxDigit=1000;
		var digit=0;
		var nextDigit=0;
		
		while (ptr<roman.length)
		{
		  //Base value of digit
		  var numeral=roman.charAt(ptr);
		  switch(numeral)
		  {
		   case "I":
			 digit=1;
			 break;
		   case "V":
			 digit=5;
			 break;
		   case "X":
			  digit=10;
			  break;
		   case "L":
			digit=50;
			break;
		   case "C":
			 digit=100;
			 break;
		  case "D":
			  digit=500;
			  break;
		   case "M":
			  digit=1000;
			  break;
		  
		  }
		 //Check for subtractive combination: A small valued numeral may be placed to the left of a larger value. When this occurs, the smaller numeral is subtracted
		 //from the larger. Also, the subtracted digit must be at least 1/10th the value of the larger numeral and must be either I,X or C
		 if(digit>maxDigit)		 
		 {
		   romanToNumberError="Smaller value incorrectly placed next to a larger value numeral";
		 }
		 
		 //Next digit
		 var nextDigit=0;
		 if(ptr<roman.length-1)
		 {
		  var nextNumeral=roman.charAt(ptr+1);
		  switch(nextNumeral)
		  {
		   case "I":
			 nextDigit=1;
			 break;
		   case "V":
			 nextDigit=5;
			 break;
		   case "X":
			  nextDigit=10;
			  break;
		   case "L":
			nextDigit=50;
			break;
		   case "C":
			 nextDigit=100;
			 break;
		  case "D":
			  nextDigit=500;
			  break;
		   case "M":
			  nextDigit=1000;
			  break;
		  
		  }
		  if(nextDigit>digit)
		  {
			if("IXC".indexOf(numeral)==-1 || nextDigit>(digit*10) || roman.split(numeral).length>3)
			  {
			   romanToNumberError="Rule of subtractive combination violated";
			  }
			  maxDigit=digit-1;
			  digit=nextDigit-digit;
			  ptr++;
		  }
		  
		 }
		 values.push(digit);
		 //next digit
		 ptr++;
//		  alert(values);
		
		
		}
		//Going left to right - the value should not increase
		for(var i=0;i<values.length-1;i++)
		{
		  if(values[i]<values[i+1])
		  {
			romanToNumberError="Larger valued numeral(pair) found to the right of a smaller value";
		  }
		}
		
		//Larger numerals should be placed to the left of smaller numerals
		var total=0;
		for(var i=0;i<values.length;i++)
		{
		  total=total+values[i];
		}
		
		if((typeof total)=="number" && (romanToNumberError=="No error"))
		{

		   //Set the QC form hidden variable with this mode
		   var hidden_autonumber_mode = document.getElementById('autonumber_mode_from_form');
		   hidden_autonumber_mode.value = '0';
//		   alert('after setting the autonumber mode hidden variable');
		   
		   var hidden_number_system = document.getElementById('Autonumber_number_system');
		   hidden_number_system.value='roman';

		 
		  //Now autonumber all the remaining textboxes of the document

  
		  for(var i=spanArray.indexOf('span'+TextboxID.split('textbox')[1])+1;i<=spanArray.length;i++)
			{
			  total++;

			  //If MODE 1: Check for the start of a new division
			  if ((Mode == '1') && (document.getElementById(spanArray[i].replace('span', 'selectDivType')).disabled == false))
			        break;
			  if(document.getElementById(spanArray[i].replace('span','textbox')))
			  {
			  
				var number=total;
				//alert('before beginning reconversion');
				//Convert decimal "total" back to a roman numeral
				
				//Set up the key-value arrays
				var values=[1000,900,500,400,100,90,50,40,10,9,5,4,1];
				var numerals=["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"];
				
				//initialize the string
				var result="";
				
				for(var x=0;x<13;x++)
				{
				  //If the number being converted is less than the current key value, append the corresponding numeral or numerical pair to the resultant string
				  while(number>=values[x])
				  {
					number=number-values[x];
					result=result+numerals[x];
					
				  }
				}
				
//				alert(result);
				if(isRomanLower)
				{
				  result=result.toLowerCase();
				}
				
				//End conversion to roman numeral

//				alert((document.getElementById(textboxID).value.length)-(lastNumber.length)-1);
				document.getElementById(spanArray[i].replace('span','textbox')).value = 
				 document.getElementById(TextboxID).value.substr(0,((document.getElementById(TextboxID).value.length)-(lastNumber.length))-1)+' '+result;
			  }//end if
			}//end for
		}
	}
}//end function


//Assign the 'main thumbnail' to the selected thumbnail span
function PickMainThumbnail(SpanID)
{
	//Cursor currently set to the "Pick Main Thumbnail" cursor?
	if($('body').css('cursor').indexOf("thumbnail_cursor")>-1)
	{
	    var pageIndex = SpanID.replace('span', '');
	    
        // Set the hidden value
	    document.getElementById('Main_Thumbnail_File').value = document.getElementById('filename' + pageIndex).value;

	    // Reset the cursor
	    ResetCursorToDefault(-1);
	    
        // Ensure no other spans are set
	    for (var i = 0; i < spanArray.length; i++) {
	        if (document.getElementById(spanArray[i].replace('span', 'spanImg')).className == 'pickMainThumbnailIconSelected') {
	            document.getElementById(spanArray[i].replace('span', 'spanImg')).className = 'pickMainThumbnailIcon';
	            break;
	        }
	    }         

	    // Set the new thumbnail in the user interface
	    document.getElementById('spanImg' + pageIndex).className = 'pickMainThumbnailIconSelected';
	}
    return false;
}

//Show the QC Icons below the thumbnail on mouseover
function showQcPageIcons(SpanID)
{
    var qcPageIconsSpan = SpanID.replace('span', 'qcPageOptions');
    document.getElementById(qcPageIconsSpan).className = "qcPageOptionsSpanHover";
}

//Hide the QC Icon bar below the thumbnail on mouseout
function hideQcPageIcons(SpanID)
{
    var qcPageIconsSpan = SpanID.replace('span', 'qcPageOptions');
    document.getElementById(qcPageIconsSpan).className = "qcPageOptionsSpan";
}

//Show the error icon on mouseover
function showErrorIcon(SpanID)
{
    var qcErrorIconSpanName = SpanID.replace('span', 'error');
    var qcErrorIconSpan = document.getElementById(qcErrorIconSpanName);
    if ( qcErrorIconSpan != null )
	    qcErrorIconSpan.className = "errorIconSpanHover";
}

//Hide the error icon on mouseout
function hideErrorIcon(SpanID)
{
    var qcErrorIconSpanName = SpanID.replace('span', 'error');
    var qcErrorIconSpan = document.getElementById(qcErrorIconSpanName);
    if (qcErrorIconSpan != null)
	    qcErrorIconSpan.className = "errorIconSpan";
}

//Change the cursor to the custom cursor for Selecting a Main Thumbnail
//On clicking on the "Pick Main Thumbnail" icon in the menu bar
function ChangeMouseCursor(MaxPageCount)
{
	//If this cursor is already set, change back to default
	if($('body').css('cursor').indexOf("thumbnail_cursor")>-1)
	{
	    //Remove custom cursor classes if any
	    $('body').removeClass('qcPickMainThumbnailCursor');
	    $('body').removeClass('qcMovePagesCursor');
	    $('body').removeClass('qcDeletePagesCursor');

	    //Reset to default
	    $('body').addClass('qcResetMouseCursorToDefault');
	
	    //Clear and hide all the 'move' checkboxes, in case currently visible
	    for(var i=0;i<MaxPageCount; i++)
	    {
	        if(document.getElementById('chkMoveThumbnail'+i))
	        {
		        document.getElementById('chkMoveThumbnail'+i).checked=false;
	            document.getElementById('chkMoveThumbnail' + i).className = 'chkMoveThumbnailHidden';
	        }
	    }
	    
	    //Also re-hide the button for moving multiple pages in case previously made visible
	    document.getElementById('divMoveOnScroll').className='qcDivMoveOnScrollHidden';
	    document.getElementByOd('divDeleteMoveOnScroll').className = 'qcDivDeleteButtonHidden';
	    
	    //Hide all the left/right arrows for moving pages
	    for(var i=0; i<MaxPageCount; i++)
	    {
		    if(document.getElementById('movePageArrows'+i))
			    document.getElementById('movePageArrows'+i).className = 'movePageArrowIconHidden';
	    }
	}
	else
	{
		//Remove the default cursor style class, and any other custom class first before setting this one, 
		//otherwise it will override the custom cursor class
		$('body').removeClass('qcResetMouseCursorToDefault');
		$('body').removeClass('qcMovePagesCursor');
		$('body').removeClass('qcDeletePagesCursor');
		
		//Set the custom cursor
		$('body').addClass('qcPickMainThumbnailCursor');

		//Clear and hide all the 'move' checkboxes, in case currently visible
		for(var i=0;i<MaxPageCount; i++)
		{
		    if(document.getElementById('chkMoveThumbnail'+i))
		    {
			    document.getElementById('chkMoveThumbnail'+i).checked=false;
				document.getElementById('chkMoveThumbnail'+i).className='chkMoveThumbnailHidden';
			}
    	}

		//Also re-hide the button for moving multiple pages in case previously made visible
		document.getElementById('divMoveOnScroll').className='qcDivMoveOnScrollHidden';
		document.getElementById('divDeleteMoveOnScroll').className = 'qcDivDeleteButtonHidden';
		
		 //Hide all the left/right arrows for moving pages
		for(var i=0; i<MaxPageCount; i++)
		{
		    if(document.getElementById('movePageArrows'+i))
			    document.getElementById('movePageArrows'+i).className = 'movePageArrowIconHidden';
		}
	}	
}

function ResetCursorToDefault(MaxPageCount)
{
	//Remove custom cursor classes if any
	$('body').removeClass('qcPickMainThumbnailCursor');
	$('body').removeClass('qcMovePagesCursor');
	$('body').removeClass('qcDeletePagesCursor');

	//Reset to default
	$('body').addClass('qcResetMouseCursorToDefault');
	
	//Clear and hide all the 'move' checkboxes, in case currently visible
	for(var i=0;i<MaxPageCount; i++)
	{
	    if(document.getElementById('chkMoveThumbnail'+i))
	    {
		    document.getElementById('chkMoveThumbnail'+i).checked=false;
		    document.getElementById('chkMoveThumbnail' + i).className = 'chkMoveThumbnailHidden';
	    }
	}
    
	//Also re-hide the button for moving multiple pages in case previously made visible
	document.getElementById('divMoveOnScroll').className='qcDivMoveOnScrollHidden';
	document.getElementById('divDeleteMoveOnScroll').className = 'qcDivDeleteButtonHidden';
	
	 //Hide all the left/right arrows for moving pages
	for(var i=0; i<MaxPageCount; i++)
	{
	    if(document.getElementById('movePageArrows'+i))
		    document.getElementById('movePageArrows'+i).className = 'movePageArrowIconHidden';
	}
}

//Change cursor: move pages
function MovePages(MaxPageCount)
{
    //If this cursor is already set, change back to default
    if ($('body').css('cursor').indexOf("move_pages_cursor") > -1) {
        // See if any checkboxes are currently checked
        var checked_found = 0;
        for (var j = 0; j < spanArray.length; j++) {
            var checkbox = document.getElementById(spanArray[j].replace('span', 'chkMoveThumbnail'));
            if (checkbox.checked) checked_found++;
        }

        if (checked_found == 0) {
            cancel_move_pages();
            } else {
            popup('form_qcmove');
        }
    }
    else
    {
        //Remove the default cursor style class first before setting the custom one, 
        //otherwise it will override the custom cursor class
        $('body').removeClass('qcResetMouseCursorToDefault');
        $('body').removeClass('qcPickMainThumbnailCursor');
        $('body').removeClass('qcDeletePagesCursor');

        //First change the cursor
        $('body').addClass('qcMovePagesCursor');

       //Unhide all the checkboxes
	    for(var i=0;i<MaxPageCount; i++)
	    {
		    if(document.getElementById('chkMoveThumbnail'+i))
		    {
		      document.getElementById('chkMoveThumbnail'+i).className='chkMoveThumbnailVisible';
		    }
	    }
    }
    return false;
}


function DeletePages(MaxPageCount)
{
    //Change the mouse cursor, unhide all the checkboxes
    //If this cursor is already set, change back to default
    if ($('body').css('cursor').indexOf("delete_cursor") > -1) {
        DeleteSelectedPages();
    }
    else
    {
        //Remove the default cursor style class first before setting the custom one, 
        //otherwise it will override the custom cursor class
        $('body').removeClass('qcResetMouseCursorToDefault');
        $('body').removeClass('qcPickMainThumbnailCursor');
        $('body').removeClass('qcMovePagesCursor');

        //First change the cursor
        $('body').addClass('qcDeletePagesCursor');

        //Unhide all the checkboxes
        for (var i = 0; i < MaxPageCount; i++)
        {
            if (document.getElementById('chkMoveThumbnail' + i)) 
                document.getElementById('chkMoveThumbnail' + i).className = 'chkMoveThumbnailVisible';
        }
    }

    return false;
}


//Make the thumbnails sortable
function MakeSortable1()
{
    var startPosition;
    var newPosition; 

    $("#allThumbnailsOuterDiv").sortable({containment: 'parent',
		start: function(event, ui) {
		    startPosition = spanArray.indexOf($(ui.item).attr('id'));
		},
		stop: function(event, ui)
		{
		    // Pull a new spanArray
		    var newSpanArray = new Array();
		    //get the list of all the thumbnail spans on the page
		    spanArrayObjects = $("#allThumbnailsOuterDiv").children();

		    //get the spanIDs from the array of span objects 
		    var j = 0;
		    for (var i = 0; i < spanArrayObjects.length; i++) {
		        if (spanArrayObjects[i].id.indexOf('span') == 0) {
		            newSpanArray[j++] = spanArrayObjects[i].id;
		        }
		    }

		    var spanID = $(ui.item).attr('id');
		    newPosition = newSpanArray.indexOf($(ui.item).attr('id'));

			// if position has been changed, update the page division correspondingly
			if(startPosition != newPosition)
			{
			    //get the spanID of the current span being dragged & dropped
				var pageIndex = spanID.replace('span','');										
													   		    
			    // Get the two most important spans (one being moved and NEXT after the move)
				var movedSpan = document.getElementById('newDivType' + pageIndex);
			    var movedFromSpanName = spanArray[startPosition];
			    var movedFromSpanCheckBox = document.getElementById(movedFromSpanName.replace('span', 'newDivType'));
													
				//If the span being moved is the start of a new Div 															
			    if (movedSpan.checked == true)
				{
				    //alert('Moving a new division page');
                    //If the original next div is not the start of a new division, make it the beginning
			        if ((movedFromSpanCheckBox != null) && (movedFromSpanCheckBox.checked == false))
			        {
			            // Set next original page as new division
			            movedFromSpanCheckBox.checked = true;
			            
		            
                        // Set the division type on the next original page and then set as enabled
			            var divTypeSelectElement = document.getElementById(movedFromSpanName.replace('span', 'selectDivType'));
			            divTypeSelectElement.disabled = false;
			            divTypeSelectElement.value = document.getElementById('selectDivType' + pageIndex).value;

						//Update the division name textbox
			            if (divTypeSelectElement.value.index('!') == 0)
						{
			                document.getElementById(movedFromSpanName.replace('span','divNameTableRow')).className = 'txtNamedDivVisible';
			                document.getElementById(movedFromSpanName.replace('span', 'txtDivName')).disabled = false;
			                document.getElementById(movedFromSpanName.replace('span', 'txtDivName')).value = '';
						}
						else
			            {
			                document.getElementById(movedFromSpanName.replace('span', 'divNameTableRow')).className = 'txtNamedDivHidden';
			                document.getElementById(movedFromSpanName.replace('span', 'txtDivName')).disabled = true;
			                document.getElementById(movedFromSpanName.replace('span', 'txtDivName')).value = '';
						}
				    }
			    }
			    
			    // Since we are done with dealing with the OLD position, we will begin to use the
			    // new array of spans on the page, which reflects the new positioning
			    spanArray = newSpanArray;
			    
			    var movedSpanDivTypeElement = document.getElementById('selectDivType' + pageIndex);
													
				//CASE 1: 
			    // If the new position is position 0: This happens if the user moves the page 
			    // to the very beginning of the thumbnails.  In this case, MOVE the div info 
			    // from the first thumbnail to this one.
			    if (newPosition == 0) {
			        // Get the id for the second span (previously the first thumbnail)
			        var previousFirstID = spanArray[1].replace('span', '');

			        //Make the moved div the start of a new div
			        document.getElementById('newDivType' + pageIndex).checked = true;
			        //Enable the moved div's DivType dropdown
			        movedSpanDivTypeElement.disabled = false;

			        //Set the moved div's DivType value to that of the one it is replacing
			        movedSpanDivTypeElement.value = document.getElementById('selectDivType' + previousFirstID).value;

			        //Unmark the replaced div's NewDiv Checkbox (and disable the dropdown)
			        document.getElementById('newDivType' + previousFirstID).checked = false;
			        document.getElementById('selectDivType' + previousFirstID).disabled = true;
			        document.getElementById('txtDivName' + previousFirstID).disabled = true;

			        //If this is now a named div, update the division name textbox
			        if (movedSpanDivTypeElement.value.indexOf('!') == 0) {
			            document.getElementById('divNameTableRow' + pageIndex).className = 'txtNamedDivVisible';
			            document.getElementById('txtDivName' + pageIndex).value = document.getElementById('txtDivName' + previousFirstID).value;
			            document.getElementById('txtDivName' + pageIndex).disabled = false;
			        } else {
			            document.getElementById('divNameTableRow' + pageIndex).className = 'txtNamedDivHidden';
			            document.getElementById('txtDivName' + pageIndex).value = '';
			            document.getElementById('txtDivName' + pageIndex).disabled = true;
			        }
			    }

			    //else
			    //CASE 2: Span moved to any location other than 0
			    else if (newPosition > 0) {
    		        //Moved span's DivType = preceding Div's Div type
			        movedSpanDivTypeElement.value = document.getElementById(spanArray[newPosition - 1].replace('span', 'selectDivType')).value;

			        // Moved span != start of a new Division
			        document.getElementById('newDivType' + pageIndex).checked = false;
			        movedSpanDivTypeElement.disabled = true;
			        document.getElementById('txtDivName' + pageIndex).disabled = true;

			        //If this is now a named div, update the division name textbox
			        if (movedSpanDivTypeElement.value.indexOf('!') == 0)
			        {
			            document.getElementById('divNameTableRow' + pageIndex).className = 'txtNamedDivVisible';
			            document.getElementById('txtDivName' + pageIndex).value = document.getElementById(spanArray[newPosition - 1].replace('span', 'txtDivName')).value;

			        } else {
			            document.getElementById('divNameTableRow' + pageIndex).className = 'txtNamedDivHidden';
			            document.getElementById('txtDivName' + pageIndex).value = '';
			        }
			    } //end else if		
			}//end if(startPosition!=newPosition)
        },placeholder: "ui-state-highlight"});
									 
    $("#allThumbnailsOuterDiv").disableSelection();
}

//Cancel function: set the hidden field(s) accordingly
function behaviors_cancel_form() 
{
	document.getElementById('QC_behaviors_request').value = 'cancel';
	document.itemNavForm.submit();
	return false;
}

//Save function: set the hidden field(s) accordingly
function behaviors_save_form() 
{
	document.getElementById('QC_behaviors_request').value = 'save';
	document.itemNavForm.submit();
	return false;
}

//Turn On/Off the autosave option
function changeAutoSaveOption()
{
   var linkID = document.getElementById('autosaveLink');
   var hiddenfield = document.getElementById('Autosave_Option');
   var hiddenfield_behavior = document.getElementById('QC_behaviors_request');
	hiddenfield_behavior.value = 'save';

	if(linkID.innerHTML=='Turn Off Autosave')
	{
	  linkID.innerHTML = 'Turn On Autosave';
	  hiddenfield.value = 'false';
//	  alert(hiddenfield.value);
	}
	else
	{
	 linkID.innerHTML = 'Turn Off Autosave';
	 hiddenfield.value = 'true';
	}
	
	//Submit the form
	document.itemNavForm.submit();
	return false;
}

//Called from the main form every three minutes
function qc_auto_save()
{

	jQuery('form').each(function() {
		var hiddenfield = document.getElementById('QC_behaviors_request');
		hiddenfield.value = 'autosave';

		var thisURL =window.location.href.toString();
		// For each form on the page, pass the form data via an ajax POST to
		// the save action
		$.ajax({
					url: thisURL,
					data: 'autosave=true&'+jQuery(this).serialize(),
					type: 'POST',
					async: true,
					success: function(data)
					{
						 //Update the time of saving
						  var currdate = new Date();
						  var hours = currdate.getHours();
						  var minutes = currdate.getMinutes();
						  var ampm = hours >= 12 ? 'PM' : 'AM';
						  hours = hours%12;
						  hours = hours?hours:12;
						  hours = hours<10?'0'+hours:hours;
						  minutes=minutes<10?'0'+minutes:minutes;
						  var time = hours+":"+minutes+' '+ampm;
						  
						  var timeToDisplay = "Saved at "+time;
				//		  $("#displayTimeSaved").text(timeToDisplay);
							
							return false;
		 
					}// end successful POST function
				}); // end jQuery ajax call
	}); // end setting up the autosave on every form on the page
}


//When any 'move page' checkbox is checked/unchecked

function chkMoveThumbnailChanged(chkBoxID, MaxPageCount)
{
    var checked = false;
    document.getElementById('divMoveOnScroll').className = 'qcDivMoveOnScrollHidden';
    document.getElementById('divDeleteMoveOnScroll').className = 'qcDivDeleteButtonHidden';
    
    //Hide all the left/right arrows for moving pages
    for (var i = 0; i < MaxPageCount; i++)
    {
        if (document.getElementById('movePageArrows' + i))
            document.getElementById('movePageArrows' + i).className = 'movePageArrowIconHidden';
    }

    //If a checkbox has been checked, and the move_thumbnails cursor is currently set
    if (document.getElementById(chkBoxID).checked == true && $('body').css('cursor').indexOf("move_pages_cursor") > -1) {
        document.getElementById('divMoveOnScroll').className = 'qcDivMoveOnScroll';
        for (var i = 0; i < MaxPageCount; i++) {
            if (document.getElementById('movePageArrows' + i))
                document.getElementById('movePageArrows' + i).className = 'movePageArrowIconVisible';

        }
    } else if (document.getElementById(chkBoxID).checked == true && $('body').css('cursor').indexOf("delete_cursor") > -1) {
        document.getElementById('divDeleteMoveOnScroll').className = 'qcDivDeleteButton';

    } else {
        //Check if there is any other checked checkbox on the screen
        for (var i = 0; i < MaxPageCount; i++) {
            if ((document.getElementById('chkMoveThumbnail' + i)) && document.getElementById('chkMoveThumbnail' + i).checked == true) {

                checked = true;
            }
        }

        if (checked == true && $('body').css('cursor').indexOf("move_pages_cursor") > -1)
        {
            document.getElementById('divMoveOnScroll').className = 'qcDivMoveOnScroll';
            //Unhide the left/right arrows for moving pages
            for (var i = 0; i < MaxPageCount; i++)
            {
                if (document.getElementById('movePageArrows' + i))
                    document.getElementById('movePageArrows' + i).className = 'movePageArrowIconVisible';
            }

        } else if (checked == true && $('body').css('cursor').indexOf("delete_cursor") > -1) {
            document.getElementById('divDeleteMoveOnScroll').className = 'qcDivDeleteButton';
        } else {
            document.getElementById('divDeleteMoveOnScroll').className = 'qcDivDeleteButtonHidden';
            document.getElementById('divMoveOnScroll').className = 'qcDivMoveOnScrollHidden';
        }
    }
}


// ------------------ Functions for the Move-Selected-Pages Popup Form---------------------//


//Disable\enable the select dropdowns based on the radio button selected
function rbMovePagesChanged(rbValue)
{
  if(rbValue=='After')
	{
	  document.getElementById('selectDestinationPageList1').disabled=false;
	  document.getElementById('selectDestinationPageList2').disabled=true;
	}
	else if(rbValue=='Before')
	{
	  document.getElementById('selectDestinationPageList2').disabled=false;
	  document.getElementById('selectDestinationPageList1').disabled=true;
	}
}


//Update the popup form based on the target page filename and relative position passed in
function update_popup_form(pageID,before_after)
{
  //alert(pageID+before_after);
  if(before_after=='After')
  {
	if(document.getElementById('selectDestinationPageList1'))
	{
	 // alert(before_after);
	  document.getElementById('rbMovePages1').checked=true;
	  document.getElementById('selectDestinationPageList1').disabled=false;
	  document.getElementById('selectDestinationPageList2').disabled=true;	
	  //Change the dropdown selected option as well
	  var ddl = document.getElementById('selectDestinationPageList1');
		var opts = ddl.options.length;
		
		for (var i=0; i<opts; i++)
		{
			if (ddl.options[i].text == pageID)
			{
			  ddl.selectedIndex = i;
			}
		}	
	  
	}
  }
  else if(before_after=='Before')
  {
	if(document.getElementById('selectDestinationPageList1'))
	{
	  document.getElementById('rbMovePages2').checked=true;
	  document.getElementById('selectDestinationPageList1').disabled=true;
	  document.getElementById('selectDestinationPageList2').disabled=false;	

	  //Change the dropdown selected option as well
	   var ddl = document.getElementById('selectDestinationPageList2');
		var opts = ddl.options.length;
		for (var i=0; i<opts; i++)
		{
			if (ddl.options[i].text == pageID)
			{
				ddl.selectedIndex = i;
				
			}
		}	  
	}
  }
}

//Move the selected pages
function cancel_move_pages() {

    if ($('#form_qcmove').css('display') != 'none') {
        popdown('form_qcmove');
    }

    ResetCursorToDefault(-1);

    // Reset and hide all the checkboxes as well
    for (var j = 0; j < spanArray.length; j++) {
        var checkbox = document.getElementById(spanArray[j].replace('span', 'chkMoveThumbnail'));
        checkbox.checked = false;
        checkbox.className = 'chkMoveThumbnailHidden';
        
        document.getElementById('movePageArrows' + j).className = 'movePageArrowIconHidden';
    }

    return false;
}

//Move the selected pages
function move_pages_submit()
{
   // alert('in function move_pages_submit');
	 var hidden_request = document.getElementById('QC_behaviors_request');
	 var hidden_action = document.getElementById('QC_move_relative_position');
	 var hidden_destination = document.getElementById('QC_move_destination');
	 var file_name='';
	 
	 hidden_request.value='move_selected_pages';
	 hidden_action.value = '';
	 hidden_destination.value=file_name;
	 
	 //if 'Before' selected, change to corresponding 'After' unless 'Before' 0th option is selected
	 if(document.getElementById('rbMovePages2').checked==true)
	 {
	   if(document.getElementById('selectDestinationPageList2').selectedIndex>0)
	   { 
		 var ddl=document.getElementById('selectDestinationPageList2');
		 var selIndex = ddl.selectedIndex-1;
		 hidden_action.value = 'After';
		 hidden_destination.value = ddl.options[selIndex].value;
	   //  alert(hidden_destination.value);
	   }
	   else
	   {
		 hidden_action.value = 'Before';
		 var ddl=document.getElementById('selectDestinationPageList2');
		 hidden_destination.value = ddl.options[ddl.selectedIndex].value;
		// alert(hidden_destination.value);
	   }
	   
	 }
	 
	 //else assign the selected 'After' values to the hidden variables
	 else
	 {
	   hidden_action.value = 'After';
	   var ddl=document.getElementById('selectDestinationPageList1');
	   var selIndex = ddl.selectedIndex;
	   hidden_destination.value = ddl.options[selIndex].value;
	//   alert(hidden_destination.value);
	 }
	 
	 document.itemNavForm.submit();
	 return false;
}


//--------------------End of Functions for the Move-Selected-Pages Popup Form----------------//


function ImageDeleteClicked(Filename) {
	var input_box = confirm("Are you sure you want to delete this page and apply all changes up to this point?");
	if (input_box == true) {
	    document.getElementById('QC_behaviors_request').value = 'delete_page';
	    document.getElementById('QC_affected_file').value = Filename;
		document.itemNavForm.submit();
	}
	return false;
}


function DeleteSelectedPages() {
    
    // See if any checkboxes are currently checked
    var checked_found = 0;
    for (var j = 0; j < spanArray.length; j++) {
        var checkbox = document.getElementById(spanArray[j].replace('span', 'chkMoveThumbnail'));
        if (checkbox.checked) checked_found++;
    }

    if (checked_found == 0) {
        ResetCursorToDefault(-1);

        // Reset and hide all the checkboxes as well
        for (var j = 0; j < spanArray.length; j++) {
            var checkbox = document.getElementById(spanArray[j].replace('span', 'chkMoveThumbnail'));
            checkbox.checked = false;
            checkbox.className = 'chkMoveThumbnailHidden';
        }

    } else {
        var input_box = confirm("Are you sure you want to delete these " + checked_found + " pages and apply all changes up to this point?");
        if (input_box == true) {

            document.getElementById('QC_behaviors_request').value = 'delete_selected_pages';
            document.itemNavForm.submit();
        } else {
            ResetCursorToDefault(-1);

            // Reset and hide all the checkboxes as well
            for (var j = 0; j < spanArray.length; j++) {
                var checkbox = document.getElementById(spanArray[j].replace('span', 'chkMoveThumbnail'));
                checkbox.checked = false;
                checkbox.className = 'chkMoveThumbnailHidden';
            }
        }
    }
    
	return false;
}

// Function is called when user clicks COMPLETE
function save_submit_form() {
    document.getElementById('QC_behaviors_request').value = 'complete';
	document.itemNavForm.submit();
	return false;
}
 
//Set the appropriate hidden variable for postback when the user selects the Clear_Pagination option
function ClearPagination() {
    document.getElementById('QC_behaviors_request').value = 'clear_pagination';
    document.itemNavForm.submit();
    return false;
}


//Set the appropriate hidden variable for postback when the user selects the Clear_Pagination option
function ClearReorderPagination() {
    document.getElementById('QC_behaviors_request').value = 'clear_reorder';
    document.itemNavForm.submit();
    return false;
}

function UploadNewPageImages(url) {
    var input_box = confirm("Are you sure you want to add more page images?   Any unsaved changes will be lost.");
    if (input_box == true) {
        window.location.href = url;
    }
    return false;
}
