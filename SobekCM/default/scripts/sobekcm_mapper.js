﻿//#region Declarations

//global defines (do not change here)
var overlaysCurrentlyDisplayed;         //holds marker for overlays on map
var pageMode;                           //holds the page/viewer type
var mapCenter;                          //used to center map on load
var mapControlsOnMap;                   //by default, are map controls displayed (true/false)
var defaultDisplayDrawingMangerTool;    //by default, is the drawingmanger displayed (true/false)
var toolboxDisplayed;                   //by default, is the toolbox displayed (true/false)
var toolbarOpen;                        //by default, is the toolbar open (yes/no)
var kmlOn;                              //by default, is kml layer on (yes/no)
var kmlLayer;                           //must be pingable by google
var defaultZoomLevel;                   //zoom level, starting
var maxZoomLevel;                       //max zoom out, default (21=lowest level, 1=highest level)
var minZoomLevel_Terrain;               //max zoom in, terrain
var minZoomLevel_Satellite;             //max zoom in, sat + hybrid
var minZoomLevel_Roadmap;               //max zoom in, roadmap (default)
var minZoomLevel_BlockLot;              //max zoom in, used for special layers not having default of roadmap
var isCustomOverlay;                    //used to determine if other overlays (block/lot etc) //unknown
var preservedRotation;                  //rotation, default
var knobRotationValue;                  //rotation to display by default 
var preserveOpacity;                    //opacity, default value (0-1,1=opaque)
var strictBounds;                       //set the bounds for this google map instance
var overlaysOnMap = [];                 //holds all overlays
var csoi = 0;                           //hold current saved overlay index
var pendingOverlaySave = false;         //hold the marker to indicate if we need to save the overlay (this prevents a save if we already saved)
var oomCount = 0;                       //counts how many overlays are on the map
var searchCount = 0;                    //interates how many searches
var degree = 0;                         //initializing degree
var firstMarker = 0;                    //used to iterate if marker placement was the first (to prevent duplicates)
var overlayCount = 0;                   //iterater
var mapInBounds;                        //is the map in bounds
var searchResult;                       //will contain object
var circleCenter;                       //hold center point of circle
var markerCenter;                       //hold center of marker
var placerType;                         //type of data (marker,overlay,poi)
var poiType = [];                       //typle of poi (marker, circle, rectangle, polygon, polyline)
var poiKML = [];                        //pou kml layer (or other geographic info)
var poi_i = -1;                         //increment the poi count (used to make IDs and such)
var poiObj = [];                        //poi object placholder
var poiCoord = [];                      //poi coord placeholder
var poiDesc = [];                       //desc poi placeholder
var infowindow = [];                    //poi infowindow
var label = [];                         //used as label of poi
var globalPolyline;                     //unknown
var geocoder;                           //must define before use
var rectangle;                          //must define before use
var firstDraw = 0;                      //used to increment first drawing of rectangle
var getCoord;                           //used to store coords from marker
var itemMarker;                         //hold current item marker
var savingMarkerCenter;                 //holds marker coords to save
var CustomOverlay;                      //does nothing
var cCoordsFrozen = "no";               //used to freeze/unfreeze coordinate viewer
var incomingOverlayBounds = [];         //defined in c# to js on page
var incomingOverlaySourceURL = [];      //defined in c# to js on page
var incomingOverlayRotation = [];       //defined in c# to js on page
var ghostOverlayRectangle = [];         //holds ghost overlay rectangles (IE overlay hotspots)
var workingOverlayIndex = null;         //holds the index of the overlay we are working with (and saving)
var currentlyEditing = "no";            //tells us if we are editing anything
var currentTopZindex = 5;               //current top zindex (used in displaying overlays over overlays)
var savingOverlayIndex = [];            //holds index of the overlay we are saving
var savingOverlaySourceURL = [];        //hold the source url of the overlay to save
var savingOverlayBounds = [];           //holds bounds of the overlay we are saving
var savingOverlayRotation = [];         //holds rotation of the overlay we are saving
var ghosting = {                        //define options for ghosting (IE being invisible)
    strokeOpacity: 0.0,                 //make border invisible
    fillOpacity: 0.0,                   //make fill transparent
    editable: false,                    //sobek standard
    draggable: false,                   //sobek standard
    zindex: 5                           //perhaps higher?
};
var editable = {                        //define options for visible and editable
    editable: true,                     //sobek standard
    draggable: true,                    //sobek standard
    strokeOpacity: 0.2,                 //sobek standard
    strokeWeight: 1,                    //sobek standard
    fillOpacity: 0.0,                   //sobek standard 
    zindex: 5                           //sobek standard
};
strictBounds = new google.maps.LatLngBounds(                            //set the bounds for this google map instance (temp to fix unknown issue where would not set dynamicaly)
    new google.maps.LatLng(29.78225755812941, -81.4306640625),
    new google.maps.LatLng(29.99181288866604, -81.1917114257)
);
CustomOverlay.prototype = new google.maps.OverlayView(); //used to display custom overlay

//#endregion

function setupInterface(collection) {

    //displayIncomingOverlays();

    switch (collection) {

        case "default":
            mapCenter = new google.maps.LatLng(29.6480, -82.3482);                  //used to center map on load
            mapControlsOnMap = true;                                                //by default, are map controls displayed (true/false)
            defaultDisplayDrawingMangerTool = false;                                //by default, is the drawingmanger displayed (true/false)
            toolboxDisplayed = true;                                                //by default, is the toolbox displayed (true/false)
            toolbarOpen = "yes";                                                    //by default, is the toolbar open (yes/no)
            kmlOn = "no";                                                           //by default, is kml layer on (yes/no)
            kmlLayer = new google.maps.KmlLayer("http://hlmatt.com/uf/kml/5.kml");  //must be pingable by google
            defaultZoomLevel = 13;                                                  //zoom level, starting
            maxZoomLevel = 2;                                                       //max zoom out, default (21=lowest level, 1=highest level)
            minZoomLevel_Terrain = 15;                                              //max zoom in, terrain
            minZoomLevel_Satellite = 20;                                            //max zoom in, sat + hybrid
            minZoomLevel_Roadmap = 21;                                              //max zoom in, roadmap (default)
            minZoomLevel_BlockLot = 19;                                             //max zoom in, used for special layers not having default of roadmap
            isCustomOverlay = false;                                                //used to determine if other overlays (block/lot etc) //unknown
            preservedRotation = 0;                                                  //rotation, default
            knobRotationValue = 0;                                                  //rotation to display by default 
            preserveOpacity = 0.75;                                                 //opacity, default value (0-1,1=opaque)
            var strictBounds = null;                                                //set the bounds for this google map instance (set to null for no bounds)
            break;
        case "stAugustine":
            mapCenter = new google.maps.LatLng(29.8944, -81.3147);                  //used to center map on load
            mapControlsOnMap = true;                                                //by default, are map controls displayed (true/false)
            defaultDisplayDrawingMangerTool = false;                                //by default, is the drawingmanger displayed (true/false)
            toolboxDisplayed = true;                                                //by default, is the toolbox displayed (true/false)
            toolbarOpen = "yes";                                                    //by default, is the toolbar open (yes/no)
            kmlOn = "no";                                                           //by default, is kml layer on (yes/no)
            kmlLayer = new google.maps.KmlLayer("http://hlmatt.com/uf/kml/5.kml");  //must be pingable by google
            defaultZoomLevel = 14;                                                  //zoom level, starting
            maxZoomLevel = 10;                                                      //max zoom out, default (21=lowest level, 1=highest level)
            minZoomLevel_Terrain = 15;                                              //max zoom in, terrain
            minZoomLevel_Satellite = 20;                                            //max zoom in, sat + hybrid
            minZoomLevel_Roadmap = 21;                                              //max zoom in, roadmap (default)
            minZoomLevel_BlockLot = 19;                                             //max zoom in, used for special layers not having default of roadmap
            isCustomOverlay = false;                                                //used to determine if other overlays (block/lot etc) //unknown
            preservedRotation = 0;                                                  //rotation, default
            knobRotationValue = 0;                                                  //rotation to display by default 
            preserveOpacity = 0.35;                                                 //opacity, default value (0-1,1=opaque)
            strictBounds = new google.maps.LatLngBounds(                            //set the bounds for this google map instance
                new google.maps.LatLng(29.78225755812941, -81.4306640625),
                new google.maps.LatLng(29.99181288866604, -81.1917114257)
            );
            break;
        case "custom":
            mapCenter = new google.maps.LatLng(29.6480, -82.3482);                  //used to center map on load
            mapControlsOnMap = true;                                                //by default, are map controls displayed (true/false)
            defaultDisplayDrawingMangerTool = false;                                //by default, is the drawingmanger displayed (true/false)
            toolboxDisplayed = true;                                                //by default, is the toolbox displayed (true/false)
            toolbarOpen = "yes";                                                    //by default, is the toolbar open (yes/no)
            kmlOn = "no";                                                           //by default, is kml layer on (yes/no)
            kmlLayer = new google.maps.KmlLayer("http://hlmatt.com/uf/kml/5.kml");  //must be pingable by google
            defaultZoomLevel = 13;                                                  //zoom level, starting
            maxZoomLevel = 10;                                                      //max zoom out, default (21=lowest level, 1=highest level)
            minZoomLevel_Terrain = 15;                                              //max zoom in, terrain
            minZoomLevel_Satellite = 20;                                            //max zoom in, sat + hybrid
            minZoomLevel_Roadmap = 21;                                              //max zoom in, roadmap (default)
            minZoomLevel_BlockLot = 19;                                             //max zoom in, used for special layers not having default of roadmap
            isCustomOverlay = false;                                                //used to determine if other overlays (block/lot etc) //unknown
            preservedRotation = 0;                                                  //rotation, default
            knobRotationValue = 0;                                                  //rotation to display by default 
            preserveOpacity = 0.75;                                                 //opacity, default value (0-1,1=opaque)
            strictBounds = new google.maps.LatLngBounds(                            //set the bounds for this google map instance
                new google.maps.LatLng(29.21570636285318, -82.87811279296875),
                new google.maps.LatLng(30.07978967039041, -81.76300048828125)
            );
            break;
    }
}              //setup everything

var collectionTypeToLoad = "stAugustine";           //define collection settings to load
setupInterface(collectionTypeToLoad);               //start the whole thing

//#region Localization library 
var L_Marker = "Marker";
var L_Circle = "Circle";
var L_Rectangle = "Rectangle";
var L_Polygon = "Polygon";
var L_Line = "Line";
var L1 = "SobekCM Plugin <a href=\"#\">Report a Sobek Error</a>"; //copyright node
var L2 = "lat: <a id=\"cLat\"></a><br/>long: <a id=\"cLong\"></a>"; //lat long of cursor position tool
var L3 = "Description (Optional)"; //describe poi box
var L4 = "Geolocation Service Failed."; //geolocation buttons error message
var L5 = "Returned to Bounds!"; //tesbounds();
var L6 = "Could not find location. Either the format you entered is invalid or the location is outside of the map bounds."; //codeAddress();
var L7 = "Error: Overlay image source cannot contain a ~ or |"; //createSavedOverlay();
var L8 = "Error: Description cannot contain a ~ or |"; //poiGetDesc(id);
var L9 = "Item Cleared!"; //buttonClearItem();
var L10 = "Overlay Cleared!"; //buttonClearOverlay();
var L11 = "POI Set Cleared!"; //buttonClearPOI();
var L12 = "Nothing Happened!"; //HandleResult(arg);
var L13 = "Item Saved!"; //HandleResult(arg);
var L14 = "Overlay Saved!"; //HandleResult(arg);
var L15 = "POI Set Saved!"; //HandleResult(arg);
var L16 = "Cannot Zoom Out Further"; //checkZoomLevel();
var L17 = "Cannot Zoom In Further"; //checkZoomLevel();
var L18 = "Using Search Results as Location"; //marker complete listener
//#endregion                                            

//#region Define google map objects

google.maps.visualRefresh = true; //Enable the visual refresh (new gmaps)

//set the google map instance options
//supporting url: https://developers.google.com/maps/documentation/javascript/controls
var gmapPageDivId = "googleMap"; //get page div where google maps is to reside
var gmapOptions = {
    disableDefaultUI: false,                                    //set to false to start from a clean slate of map controls
    zoom: defaultZoomLevel,                                     //starting zoom level
    minZoom: maxZoomLevel,                                      //highest zoom out level
    center: mapCenter,                                          //default center point
    mapTypeId: google.maps.MapTypeId.ROADMAP,                   //default map type to display
    streetViewControl: false,                                   //is streetview active?
    tilt: 0,                                                    //set to 0 to disable 45 degree tilt
    zoomControl: true,                                          //is zoom control active?
    zoomControlOptions: {
        style: google.maps.ZoomControlStyle.SMALL,              //zoom control style
        position: google.maps.ControlPosition.LEFT_TOP          //zoom control position 
    },
    panControl: true,                                           //pan control active
    panControlOptions: {
        position: google.maps.ControlPosition.LEFT_TOP          //pan control position
    },
    mapTypeControl: true,                                       //map layer control active
    mapTypeControlOptions: {
        style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,   //map layer control style
        position: google.maps.ControlPosition.RIGHT_TOP         //map layer control position
    },
    styles:                                                     //turn off all poi stylers (supporting url: https://developers.google.com/maps/documentation/javascript/reference#MapTypeStyleFeatureType)
    [
        {
            featureType: "poi", //poi
            elementType: "all", //or labels
            stylers: [{ visibility: "off" }]
        },
        //{
        //    featureType: "all", //poi
        //    elementType: "all", //labels
        //    stylers: [{ invert_lightness: "true" }]
        //},
        {
            featureType: "transit", //poi
            elementType: "labels", //labels
            stylers: [{ visibility: "off" }]
        }
    ]
    
};

//define drawing manager for this google maps instance
//support url: https://developers.google.com/maps/documentation/javascript/3.exp/reference#DrawingManager
var drawingManager = new google.maps.drawing.DrawingManager({
    //drawingMode: google.maps.drawing.OverlayType.MARKER, //set default/start type
    drawingControl: false,
    drawingControlOptions: {
        position: google.maps.ControlPosition.TOP_CENTER,
        drawingModes: [
          google.maps.drawing.OverlayType.MARKER,
          google.maps.drawing.OverlayType.CIRCLE,
          google.maps.drawing.OverlayType.RECTANGLE,
          google.maps.drawing.OverlayType.POLYGON,
          google.maps.drawing.OverlayType.POLYLINE
        ]
    },
    markerOptions: {
        draggable: true,
        zIndex: 5
    },
    circleOptions: {
        editable: true,
        draggable: true,
        zIndex: 5
    },
    polygonOptions: {
        editable: true,
        draggable: true,
        zIndex: 5
    },
    polylineOptions: {
        editable: true,
        draggable: true,
        zIndex: 5
    },
    rectangleOptions: {
        editable: true,
        draggable: true,
        zIndex: 5
    }
});

//define custom copyright control
//supporting url: https://developers.google.com/maps/documentation/javascript/controls#CustomControls
var copyrightNode = document.createElement('div');
copyrightNode.id = 'copyright-control';
copyrightNode.style.fontSize = '10px';
copyrightNode.style.color = '#333333';
copyrightNode.style.fontFamily = 'Arial, sans-serif';
copyrightNode.style.margin = '0 2px 2px 0';
copyrightNode.style.whiteSpace = 'nowrap';
copyrightNode.index = 0;
copyrightNode.style.backgroundColor = '#FFFFFF';
copyrightNode.style.opacity = 0.75;
copyrightNode.innerHTML = L1; //localization copyright

//define cursor lat long tool custom control
//supporting url: https://developers.google.com/maps/documentation/javascript/controls#CustomControls
var cursorLatLongTool = document.createElement('div');
cursorLatLongTool.id = 'cursorLatLongTool';
cursorLatLongTool.style.fontSize = '10px';
cursorLatLongTool.style.color = '#333333';
cursorLatLongTool.style.fontFamily = 'Arial, sans-serif';
cursorLatLongTool.style.margin = '0 2px 2px 0';
cursorLatLongTool.style.whiteSpace = 'nowrap';
cursorLatLongTool.index = 0;
cursorLatLongTool.style.backgroundColor = '#FFFFFF';
cursorLatLongTool.style.opacity = 0.75;
cursorLatLongTool.innerHTML = L2; //localization cursor lat/long tool

//buffer zone top left (used to push map controls down)
//supporting url: https://developers.google.com/maps/documentation/javascript/controls#CustomControls
toolbarBufferZone1 = document.createElement('div');
toolbarBufferZone1.id = 'toolbarBufferZone1';
toolbarBufferZone1.style.height = '50px';

//buffer zone top right
//supporting url: https://developers.google.com/maps/documentation/javascript/controls#CustomControls
toolbarBufferZone2 = document.createElement('div');
toolbarBufferZone2.id = 'toolbarBufferZone2';
toolbarBufferZone2.style.height = '50px';

//#endregion

//#region Supporting JS

$(function () {
    $("#toolbox").draggable({ handle: ".toolbar" });
    $("#toolboxTabs").accordion({ active: 0, icons: false, heightStyle: "content" });
    $("#toolbar_toggle1").tooltip();
    $("#toolbar_toggle2").tooltip();
    $("#toolbar_reset").tooltip();
    $("#toolbar_toggleControls").tooltip();
    $("#toolbar_toggletoolbox").tooltip();
    $("#toolbar_layerRoadmap").tooltip();
    $("#toolbar_layerSatellite").tooltip();
    $("#toolbar_layerTerrain").tooltip();
    $("#toolbar_layerControls").tooltip();
    $("#toolbar_layerHybrid").tooltip();
    $("#toolbar_layerCustom").tooltip();
    $("#toolbar_layerReset").tooltip();
    $("#toolbar_zoomIn").tooltip();
    $("#toolbar_zoomReset").tooltip();
    $("#toolbar_zoomOut").tooltip();
    $("#toolbar_panUp").tooltip();
    $("#toolbar_panDown").tooltip();
    $("#toolbar_panReset").tooltip();
    $("#toolbar_panLeft").tooltip();
    $("#toolbar_panRight").tooltip();
    $("#toolbar_manageItem").tooltip();
    $("#toolbar_manageOverlay").tooltip();
    $("#toolbar_managePOI").tooltip();
    $("#toolbar_find").tooltip();
    $("#toolbar_search").tooltip();
    $("#toolbox_locate").tooltip();
    $("#toolbox_find").tooltip();
    $("#toolbox_search").tooltip();
    $("#toolbox_reset").tooltip();
    $("#toolbox_toggleControls").tooltip();
    $("#toolbox_layerRoadmap").tooltip();
    $("#toolbox_layerSatellite").tooltip();
    $("#toolbox_layerTerrain").tooltip();
    $("#toolbox_layerControls").tooltip();
    $("#toolbox_layerHybrid").tooltip();
    $("#toolbox_layerCustom").tooltip();
    $("#toolbox_layerReset").tooltip();
    $("#toolbox_zoomIn").tooltip();
    $("#toolbox_zoomReset").tooltip();
    $("#toolbox_zoomOut").tooltip();
    $("#toolbox_panUp").tooltip();
    $("#toolbox_panDown").tooltip();
    $("#toolbox_panReset").tooltip();
    $("#toolbox_panLeft").tooltip();
    $("#toolbox_panRight").tooltip();
    $("#toolbox_manageItem").tooltip();
    $("#toolbox_manageOverlay").tooltip();
    $("#toolbox_managePOI").tooltip();
    $("#toolbox_placeItem").tooltip();
    $("#toolbox_placeOverlay").tooltip();
    $("#toolbox_placePOI").tooltip();
    $("#toolbox_poiMarker").tooltip();
    $("#toolbox_poiCircle").tooltip();
    $("#toolbox_poiRectangle").tooltip();
    $("#toolbox_poiPolygon").tooltip();
    $("#toolbox_poiLine").tooltip();
    $("#address1").tooltip();
    $("#address2").tooltip();
    $("#search1").tooltip();
    $("#search2").tooltip();
    $("#collectionSearchInput").tooltip();
    $("#collectionSearchImage").tooltip();
    $("#rotationKnob").tooltip();
    $("#rotationClockwise").tooltip();
    $("#rotationReset").tooltip();
    $("#rotationCounterClockwise").tooltip();
    $("#transparency").tooltip();
    $("#rgItem").tooltip();
    $("#posItem").tooltip();
    $("#placeItem").tooltip();
    $("#descItem").tooltip();
    $("#saveItem").tooltip();
    $("#placeOverlay").tooltip();
    $("#saveOverlay").tooltip();
    $("#placePOI").tooltip();
    $("#descPOI").tooltip();
    $("#savePOI").tooltip();
    $("#tool2").tooltip();
    $("#tool3").tooltip();
    $("#tool4").tooltip();
    $("#item_getUserLocation").tooltip();
    $("#overlay_getUserLocation").tooltip();
    $("#poi_getUserLocation").tooltip();
    $("#clearItem").tooltip();
    $("#clearOverlay").tooltip();
    $("#clearPOI").tooltip();
    //$(".selector").tooltip({ content: "Awesome title!" });

});                               //jquery elements (tooltips)
function buttonSaveItem() {
    if (savingMarkerCenter != null) {
        alert("saving location: " + savingMarkerCenter); //grab coords from gmaps js
        //createSavedItem(markerCenter);
        displayMessage("saved");
    } else {
        displayMessage("nothing to save");
    }
}                     //just calls create saved item
function buttonSaveOverlay() {
    if (savingOverlayIndex.length) {
        for (var i = 0; i < savingOverlayIndex.length; i++) {
            alert("saving overlay: " + savingOverlayIndex[i] + "\nsource: " + savingOverlaySourceURL[i] + "\nbounds: " + savingOverlayBounds[i] + "\nrotation: " + savingOverlayRotation[i]);
            createSavedOverlay(savingOverlayIndex[i], savingOverlaySourceURL[i], savingOverlayBounds[i], savingOverlayRotation[i]); //send overlay to the server
            //ghostOverlayRectangle[savingOverlayIndex[i]].setOptions(ghosting); //set rectangle to ghosting
        }
        displayMessage("saved");
    } else {
        displayMessage("nothing to save");
    }

}                  //just calls create saved overlay
function buttonSavePOI() {
    if (poiObj.length > 0) {
        createSavedPOI();
        displayMessage("saved");
    } else {
        displayMessage("nothing to save");
    }
}                      //just calls create saved poi
function createSavedItem(coordinates) {
    var messageType = "item"; //define what message type it is
    //assign data
    var data = messageType + "|" + coordinates + "|";
    var dataPackage = data + "~";
    CallServer(dataPackage);
}                    //create a package to send to server to save item location
function createSavedOverlay(index, source, bounds, rotation) {
    var temp = source;
    if (temp.contains("~") || temp.contains("|")) { //check to make sure reserve characters are not there
        displayMessage(L7);
    }

    var messageType = "overlay"; //define what message type it is
    var data = messageType + "|" + index + "|" + bounds + "|" + source + "|" + rotation + "|";

    var dataPackage = data + "~";
    //CallServer(dataPackage); //not yet working
}                 //create a package to send to server to save overlay
function createSavedPOI() {
    var dataPackage = "";
    for (var i = 0; i < poiObj.length; i++) {
        switch (poiType[i]) {
            case "marker":
                poiKML[i] = poiObj[i].getPosition().toString();
                break;
            case "circle":
                poiKML[i] = poiObj[i].getCenter() + ",";
                poiKML[i] += poiObj[i].getRadius();
                break;
            case "rectangle":
                poiKML[i] = poiObj[i].getBounds().toString();
                break;
            case "polygon":
                poiObj[i].getPath().forEach(function (latLng) {
                    poiKML[i] += latLng; //NOTE: this has a non standard coordinate separator
                });
                break;
            case "polyline":
                poiObj[i].getPath().forEach(function (latLng) {
                    poiKML[i] += latLng; //NOTE: this has a non standard coordinate separator
                });
                break;
            case "deleted":
                //nothing to do here
                break;
        }
        var data = "poi|" + poiType[i] + "|" + poiDesc[i] + "|" + poiKML[i] + "|";
        dataPackage += data + "~";
    }
    alert("saving poi set: "+dataPackage);
    //CallServer(dataPackage);
}                     //create a package to send to the server to save poi
function poiEditMe(id) {
    poiObj[id].setMap(map);
    if (poiType[id] == "marker") {
        infowindow[id].open(map, poiObj[id]);
    } else {
        infowindow[id].setMap(map);
    }
}                        //open the infowindow of a poi
function poiHideMe(id) {
    poiObj[id].setMap(null);
    infowindow[id].setMap(null);
    label[id].setMap(null);
    document.getElementById("poiToggle" + id).innerHTML = "<img src=\"" + baseURL + "default/images/mapper/add.png\" onclick=\"poiShowMe(" + id + ");\" />";
}                        //hide poi on map
function poiShowMe(id) {
    poiObj[id].setMap(map);
    infowindow[id].setMap(map);
    label[id].setMap(map);
    document.getElementById("poiToggle" + id).innerHTML = "<img src=\"" + baseURL + "default/images/mapper/sub.png\" onclick=\"poiHideMe(" + id + ");\" />";
}                        //show poi on map
function poiDeleteMe(id) {
    poiObj[id].setMap(null);
    poiObj[id] = null;
    poiType[id] = "deleted";
    var strg = "#poi" + id; //create <li> poi string
    $(strg).remove(); //remove <li>
    infowindow[id].setMap(null);
    label[id].setMap(null);
}                      //delete poi from map and list
function poiGetDesc(id) {

    var temp = document.getElementById("poiDesc" + id).value;
    if (temp.contains("~") || temp.contains("|")) {
        displayMessage(L8);
    } else {
        poiDesc[id] = document.getElementById("poiDesc" + id).value;
    }
}                       //get the poi desc
function searchResultDeleteMe() {
    searchResult.setMap(null);
    $("#searchResult").remove();
}               //delete search results from map and list
function action1() {
    $("#toolboxTabs").accordion({ active: 2 }); //open edit overlay tab
}                            //open tab 2
function action2() {
    $("#toolboxTabs").accordion({ active: 3 }); //open edit overlay tab
}                            //open tab 3
function action3() {
    $("#toolboxTabs").accordion({ active: 4 }); //open edit overlay tab
}                            //open tab 4
function buttonClearItem() {
    itemMarker.setMap(null); //delete marker form map
    itemMarker = null;
    savingMarkerCenter = null; //reset stored coords to save
    document.getElementById('posItem').value = ""; //reset lat/long in tab
    document.getElementById('rgItem').value = ""; //reset address in tab
    displayMessage(L9); //say all is reset
}                    //clear item location
function buttonClearOverlay() {
    //does nothing
    displayMessage("Nothing to clear");
    //displayMessage(L10);
}                 //clear overlays
function buttonClearPOI() {
    for (var i = 0; i < poiObj.length; i++) {
        if (poiObj[i] != null) {
            poiObj[i].setMap(null);
            poiObj[i] = null;
        }
        infowindow[i].setMap(null);
        infowindow[i] = null;
        label[i].setMap(null);
        label[i] = null;
        var strg = "#poi" + i; //create <li> poi string
        $(strg).remove(); //remove <li>
    }
    poiObj = [];
    poi_i = -1;
    displayMessage(L11);
}                     //clear all pois
function HandleResult(arg) {
    switch (arg) {
        case "0":
            displayMessage(L12);
            break;
        case "1":
            displayMessage(L13);
            break;
        case "2":
            displayMessage(L14);
            break;
        case "3":
            displayMessage(L15);
            break;
    }
}                    //callback message board
function DisplayCursorCoords(arg) {
    cCoord.innerHTML = arg;
}             //used for lat/long tool
function displayMessage(message) {
    //create message
    var messageText = "<p class=\"message\">";
    messageText += message; //assign incoming message to text
    messageText += "</p>";
    document.getElementById("messageContainer").innerHTML = messageText; //assign to element

    //show message
    document.getElementById("messageContainer").style.display = "block"; //display element

    //fade message out
    setTimeout(function () {
        $("#messageContainer").fadeOut("slow", function () {
            $("#messageContainer").hide();
        });
    }, 3000); //after 3 sec
}              //display an inline message
function checkZoomLevel() {
    var currentZoomLevel = map.getZoom();
    var currentMapType = map.getMapTypeId();
    if (currentZoomLevel == maxZoomLevel) {
        displayMessage(L16);
    } else {
        switch (currentMapType) {
            case "roadmap": //roadmap and default
                if (currentZoomLevel == minZoomLevel_Roadmap) {
                    displayMessage(L17);
                }
                break;
            case "satellite": //sat
                if (currentZoomLevel == minZoomLevel_Satellite) {
                    displayMessage(L17);
                }
                break;
            case "hybrid": //sat
                if (currentZoomLevel == minZoomLevel_Satellite) {
                    displayMessage(L17);
                }
                break;
            case "terrain": //terrain only
                if (currentZoomLevel == minZoomLevel_Terrain) {
                    displayMessage(L17);
                }
                break;
        }
        if (isCustomOverlay == true) {
            if (currentZoomLevel == minZoomLevel_BlockLot) {
                displayMessage(L17);
            }
        }
    }
}                     //check the zoom level
$(function () {
    $("#overlayTransparencySlider").slider({
        animate: true,
        range: "min",
        value: preserveOpacity,
        orientation: "vertical",
        min: 0.00,
        max: 1.00,
        step: 0.01,
        slide: function (event, ui) {
            var selection = $("#overlayTransparencySlider").slider("value");
            var div = document.getElementById("overlay" + workingOverlayIndex);
            div.style.opacity = selection;
            preserveOpacity = selection;
        }
    });
});                               //jquery transparency slider
$(function ($) {
    $(".knob").knob({
        change: function (value) {
            knobRotationValue = value; //assign knob value
            if (value > 180) {
                knobRotationValue = ((knobRotationValue - 360) * (1)); //used to correct for visual effect of knob error
                //knobRotationValue = ((knobRotationValue-180)*(-1));
            }
            preservedRotation = knobRotationValue; //reassign
            keepRotate(preservedRotation); //send to display fcn of rotation
            
        }
    });

});                              //for rotation knob
function keepRotate(degreeIn) {
    currentlyEditing = "yes"; //used to signify we are editing this overlay
    $(function () {
        $("#overlay" + workingOverlayIndex).rotate(degreeIn);
    });
}                 //maintain specific rotation
function rotate(degreeIn) {
    currentlyEditing = "yes"; //used to signify we are editing this overlay
    degree = preservedRotation;
    degree += degreeIn;
    if (degreeIn != 0) {
        $(function () {
            $("#overlay" + workingOverlayIndex).rotate(degree); //assign overlay to defined rotation
        });
    } else { //if rotation is 0, reset rotation
        $(function () {
            degree = 0;
            $("#overlay" + workingOverlayIndex).rotate(degree);
        });
    }
    preservedRotation = degree; //preserve rotation value
}                     //variable rotation fcn
function hide(what) {
    $(what).hide();
}                           //hide somethign using jquery
function show(what) {
    $(what).show();
}                           //display something using jquery
function d(message) {
    document.getElementById("debugger").innerHTML += "-- " + message + "<br />";
}                           //debugger tool
function polygonCenter(poly) {
    var lowx,
        highx,
        lowy,
        highy,
        lats = [],
        lngs = [],
        vertices = poly.getPath();

    for (var i = 0; i < vertices.length; i++) {
        lngs.push(vertices.getAt(i).lng());
        lats.push(vertices.getAt(i).lat());
    }

    lats.sort();
    lngs.sort();
    lowx = lats[0];
    highx = lats[vertices.length - 1];
    lowy = lngs[0];
    highy = lngs[vertices.length - 1];
    center_x = lowx + ((highx - lowx) / 2);
    center_y = lowy + ((highy - lowy) / 2);
    return (new google.maps.LatLng(center_x, center_y));
}                  //get the center lat/long of a polygon
function testBounds() {
    if (strictBounds != null) {
        if (strictBounds.contains(map.getCenter())) {
            mapInBounds = "yes";
        } else {
            mapInBounds = "no";
            map.panTo(mapCenter); //recenter
            displayMessage(L5);
        }
    }
}                         //test the map bounds
function finder(stuff) {

    if (stuff.length > 0) {
        codeAddress("lookup", stuff);
    } else {
        //do nothing and keep quiet
    }
}                        //search the gmaps for a location (lat/long or address)
function searcher(stuff) {

    if (stuff.length > 0) {
        displayMessage("No collection to search");
    } else {
        //do nothing and keep quiet
    }
}                      //search the collection for something
function toggletoolbox(value) {
    switch (value) {

        case 1:
            $("#toolboxTabs").hide();
            document.getElementById("toolbox").style.height = "17px";
            break;
        case 2:
            $("#toolboxTabs").show();
            document.getElementById("toolbox").style.height = "auto";
            break;
        case 3:
            $("#toolbox").hide();
            toolboxDisplayed = false;
            break;
        case 4:
            if (toolboxDisplayed == true) {
                $("#toolbox").hide();
                toolboxDisplayed = false;
            } else {
                $("#toolbox").show();
                toolboxDisplayed = true;
            }
            break;
    }

}                 //toggle toolbox
function Toggle(what) {
    //toggle it
    if (toolbarOpen == "yes") {
        $(what).hide();
        toolbarOpen = "no";
        $("#container_toggle_toolbar1").hide();
        $("#container_toggle_toolbar2").show();
    } else {
        $(what).show();
        toolbarOpen = "yes";
        $("#container_toggle_toolbar1").show();
        $("#container_toggle_toolbar2").hide();
    }

}                         //used to toggle toolbar
function toggleAllMapControlsTool() {
    if (mapControlsOnMap == false) { //not present
        map.setOptions({
            zoomControl: true,
            zoomControlOptions: { style: google.maps.ZoomControlStyle.SMALL, position: google.maps.ControlPosition.LEFT_TOP },
            panControl: true,
            panControlOptions: { position: google.maps.ControlPosition.LEFT_TOP },
            mapTypeControl: true,
            mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU, position: google.maps.ControlPosition.RIGHT_TOP }
        });
        mapControlsOnMap = true;
    } else { //present
        map.setOptions({
            zoomControl: false,
            panControl: false,
            mapTypeControl: false
        });
        mapControlsOnMap = false;
    }
}           //display/destroy map controls and drawing manager tool
function codeAddress(type, geo) {
    var bounds = map.getBounds(); //get the current map bounds (should not be greater than the bounding box)
    geocoder.geocode({ 'address': geo, 'bounds': bounds }, function (results, status) { //geocode the lat/long of incoming with a bias towards the bounds
        if (status == google.maps.GeocoderStatus.OK) { //if it worked
            map.setCenter(results[0].geometry.location); //set the center of map to the results
            testBounds(); //test to make sure we are indeed in the bounds (have to do this because gmaps only allows for a BIAS of bounds and is not strict)
            if (mapInBounds == "yes") { //if it is inside bounds
                if (searchCount > 0) { //check to see if this is the first time searched, if not
                    searchResult.setMap(null); //set old search result to not display on map
                } else { //if it is the first time
                    searchCount++; //just interate
                }
                searchResult = new google.maps.Marker({ //create a new marker
                    map: map, //add to current map
                    position: results[0].geometry.location //set position to search results
                });
                document.getElementById("search_results").innerHTML = "<div id=\"searchResult\">" + geo + " <a href=\"#\" onclick=\"searchResultDeleteMe();\"><img src=\"" + baseURL + "default/images/mapper/delete.png\"/></a></div><br\>"; //add list div
            } else { //if location found was outside strict map bounds...
                displayMessage("Could not find within bounds."); //say so
            }

        } else { //if the entire geocode did not work
            alert(L6); //localization...
        }
    });
}               //get the location of a lat/long or address
function codeLatLng(latlng) {
    if (geocoder) {
        geocoder.geocode({ 'latLng': latlng }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                if (results[1]) {
                    document.getElementById("rgItem").innerHTML = results[0].formatted_address;
                }
                else {
                    document.getElementById("rgItem").innerHTML = "Geocoder failed due to: " + status;
                    document.getElementById("rgItem").innerHTML = "";
                }
            }
        });
    }
}                   //get the nearest human reabable location from lat/long
function useSearchAsItemLocation() {
    placerType = "item";                        //this tells listeners what to do
    itemMarker = new google.maps.Marker({
        map: map,
        position: searchResult.getPosition(),   //assign to prev search result location
        draggable: true
    });

    firstMarker++;                              //prevent redraw
    searchResult.setMap(null);                  //delete search result from map
    $("#searchResult").remove();                //delete search result form list
    itemMarker.setMap(map);                     //set itemMarker location icon to map
    document.getElementById('posItem').value = itemMarker.getPosition(); //get the lat/long of item marker and put it in the item location tab
    codeLatLng(itemMarker.getPosition());       //get the reverse geo address for item location and put in location tab
    savingMarkerCenter = itemMarker.getPosition(); //store coords to save

    //add listener for new item marker (can only add once the itemMarker is created)
    google.maps.event.addListener(itemMarker, 'dragend', function () {
        document.getElementById('posItem').value = itemMarker.getPosition(); //get lat/long
        codeLatLng(itemMarker.getPosition());   //get address
        savingMarkerCenter = itemMarker.getPosition(); //store coords to save
    });

}            //assign search location pin to item location

//#endregion

function initialize() {
    //initialize google map objects
    map = new google.maps.Map(document.getElementById(gmapPageDivId), gmapOptions);                             //initialize map    
    map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(copyrightNode);                                 //initialize custom copyright
    map.controls[google.maps.ControlPosition.BOTTOM_LEFT].push(cursorLatLongTool);                              //initialize cursor lat long tool
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(toolbarBufferZone1);                                //initialize spacer
    map.controls[google.maps.ControlPosition.TOP_RIGHT].push(toolbarBufferZone2);                               //intialize spacer
    drawingManager.setMap(map);                                                                                 //initialize drawing manager
    geocoder = new google.maps.Geocoder();                                                                      //initialize geocoder
  
    //#region Map Control Listeners

    //zoom in/out listeners
    google.maps.event.addDomListener(document.getElementById("toolbar_zoomIn"), 'click', function () {
        var currentZoom = map.getZoom();
        map.setZoom(currentZoom + 1);
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_zoomReset"), 'click', function () {
        map.setZoom(defaultZoomLevel);
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_zoomOut"), 'click', function () {
        var currentZoom = map.getZoom();
        map.setZoom(currentZoom - 1);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_zoomIn"), 'click', function () {
        var currentZoom = map.getZoom();
        map.setZoom(currentZoom + 1);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_zoomReset"), 'click', function () {
        map.setZoom(defaultZoomLevel);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_zoomOut"), 'click', function () {
        var currentZoom = map.getZoom();
        map.setZoom(currentZoom - 1);
    });

    //pan control listeners
    google.maps.event.addDomListener(document.getElementById("toolbar_panUp"), 'click', function () {
        map.panBy(0, -100);
        testBounds();
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_panDown"), 'click', function () {
        map.panBy(0, 100);
        testBounds();
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_panLeft"), 'click', function () {
        map.panBy(-100, 0);
        testBounds();
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_panRight"), 'click', function () {
        map.panBy(100, 0);
        testBounds();
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_panReset"), 'click', function () {
        map.panTo(mapCenter);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_panUp"), 'click', function () {
        map.panBy(0, -100);
        testBounds();
        movedBy = -100;
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_panDown"), 'click', function () {
        map.panBy(0, 100);
        testBounds();
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_panLeft"), 'click', function () {
        map.panBy(-100, 0);
        testBounds();
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_panRight"), 'click', function () {
        map.panBy(100, 0);
        testBounds();
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_panReset"), 'click', function () {
        map.panTo(mapCenter);
    });

    //map type layer listeners
    google.maps.event.addDomListener(document.getElementById("toolbar_layerRoadmap"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_layerSatellite"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_layerTerrain"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_layerHybrid"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.HYBRID);
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_layerCustom"), 'click', function () {
        if (kmlOn == "no") {
            kmlLayer.setMap(map);
            kmlOn = "yes";
        } else {
            kmlLayer.setMap(null);
            kmlOn = "no";
        }
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_layerReset"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_layerRoadmap"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_layerSatellite"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_layerTerrain"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_layerHybrid"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.HYBRID);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_layerCustom"), 'click', function () {
        if (kmlOn == "no") {
            kmlLayer.setMap(map);
            kmlOn = "yes";
        } else {
            kmlLayer.setMap(null);
            kmlOn = "no";
        }
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_layerReset"), 'click', function () {
        map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
    });
    
    //#endregion
    
    //#region Other Listeners

    //actions listeners
    google.maps.event.addDomListener(document.getElementById("toolbar_manageItem"), 'click', function () {
        show(toolbox);
        toggletoolbox(2);
        toolboxDisplayed = true;
        placerType = "item";
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_manageOverlay"), 'click', function () {
        show(toolbox);
        toggletoolbox(2);
        toolboxDisplayed = true;
        placerType = "overlay";
    });
    google.maps.event.addDomListener(document.getElementById("toolbar_managePOI"), 'click', function () {
        drawingManager.setOptions({ drawingControl: true, drawingControlOptions: {
            position: google.maps.ControlPosition.RIGHT_TOP,
            drawingModes: [
                google.maps.drawing.OverlayType.MARKER,
                google.maps.drawing.OverlayType.CIRCLE,
                google.maps.drawing.OverlayType.RECTANGLE,
                google.maps.drawing.OverlayType.POLYGON,
                google.maps.drawing.OverlayType.POLYLINE
            ]
        }});
        show(toolbox);
        toggletoolbox(2);
        toolboxDisplayed = true;
        placerType = "poi";
    });
    
    //place something action listeners
    google.maps.event.addDomListener(document.getElementById("toolbox_placeItem"), 'click', function () {
        if (searchCount > 0 && itemMarker == null) {
            useSearchAsItemLocation();
            displayMessage(L18);
        } else {
            drawingManager.setDrawingMode(google.maps.drawing.OverlayType.MARKER);
            placerType = "item";
        }
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_placeOverlay"), 'click', function () {
        placerType = "overlay";
        if (pageMode == "edit") {
            pageMode = "view";
            if (savingOverlayIndex.length > 0) {
                for (var i = 0; i < savingOverlayIndex.length; i++) {
                    ghostOverlayRectangle[savingOverlayIndex[i]].setOptions(ghosting); //set rectangle to ghosting    
                }
            }
            displayMessage("Overlay Editting Turned Off");
        } else {
            pageMode = "edit";
            displayMessage("Overlay Editting Turned On");
        }
        //toggleOverlayEditor(); 
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_placePOI"), 'click', function () {
        drawingManager.setOptions({ drawingControl: true, drawingControlOptions: { position: google.maps.ControlPosition.RIGHT_TOP, drawingModes: [google.maps.drawing.OverlayType.MARKER, google.maps.drawing.OverlayType.CIRCLE, google.maps.drawing.OverlayType.RECTANGLE, google.maps.drawing.OverlayType.POLYGON, google.maps.drawing.OverlayType.POLYLINE] } });
        placerType = "poi";
    });
        
    //geolocation buttons
    google.maps.event.addDomListener(document.getElementById("item_getUserLocation"), 'click', function () {
        drawingManager.setDrawingMode(google.maps.drawing.OverlayType.MARKER);
        placerType = "item";
        // Try W3C Geolocation
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var userLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
                map.setCenter(userLocation);
                testBounds();
                markerCenter = userLocation;
                itemMarker = new google.maps.Marker({
                    position: markerCenter,
                    map: map
                });
                itemMarker.setMap(map);
                document.getElementById('posItem').value = markerCenter;
                savingMarkerCenter = itemMarker.getPosition(); //store coords to save
            });
            
        }else {
            alert(L4);
        }
        drawingManager.setDrawingMode(null);
    });
    google.maps.event.addDomListener(document.getElementById("overlay_getUserLocation"), 'click', function () {
        placerType = "overlay";
        // Try W3C Geolocation
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var userLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
                map.setCenter(userLocation);
                testBounds();
            });

        } else {
            alert(L4);
        }
    });
    google.maps.event.addDomListener(document.getElementById("poi_getUserLocation"), 'click', function () {
        //drawingManager.setDrawingMode(google.maps.drawing.OverlayType.MARKER);
        placerType = "poi";
        // Try W3C Geolocation
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var userLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
                map.setCenter(userLocation);
                testBounds();
                //var marker = new google.maps.Marker({
                //    position: userLocation,
                //    map: map
                //});
                //marker.setMap(map);
            });

        } else {
            alert(L4);
        }
        //drawingManager.setDrawingMode(null);
    });
    
    //tools
    google.maps.event.addDomListener(document.getElementById("toolbar_toggleControls"), 'click', function () {
        toggleAllMapControlsTool();
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_toggleControls"), 'click', function () {
        toggleAllMapControlsTool();
    });
    
    //poi place items
    google.maps.event.addDomListener(document.getElementById("toolbox_poiMarker"), 'click', function () {
        placerType = "poi";
        drawingManager.setDrawingMode(google.maps.drawing.OverlayType.MARKER);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_poiCircle"), 'click', function () {
        placerType = "poi";
        drawingManager.setDrawingMode(google.maps.drawing.OverlayType.CIRCLE);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_poiRectangle"), 'click', function () {
        placerType = "poi";
        drawingManager.setDrawingMode(google.maps.drawing.OverlayType.RECTANGLE);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_poiPolygon"), 'click', function () {
        placerType = "poi";
        drawingManager.setDrawingMode(google.maps.drawing.OverlayType.POLYGON);
    });
    google.maps.event.addDomListener(document.getElementById("toolbox_poiLine"), 'click', function () {
        placerType = "poi";
        drawingManager.setDrawingMode(google.maps.drawing.OverlayType.POLYLINE);
    });

    //save modified items
    google.maps.event.addDomListener(document.getElementById("saveItem"), 'click', function () {
        //do something?
        //this is done in the other js file
    });             //save Item
    google.maps.event.addDomListener(document.getElementById("saveOverlay"), 'click', function () {
        //2do: send saved overlay to db/xml
        //displayMessage("Not yet tied into an actual Sobek item.");
        //buttonSaveOverlay(); //called in default page itself

    });          //save and reset overlay
    google.maps.event.addDomListener(document.getElementById("savePOI"), 'click', function () {
        //do something?
        //this is done in the other js file
    });              //save poi

    //initialize drawingmanger listeners
    google.maps.event.addListener(drawingManager, 'markercomplete', function (marker) {
        testBounds(); //are we still in the bounds 
        if (placerType == "item") {
            //used to prevent multi markers
            if (firstMarker > 0) {
                itemMarker.setMap(null);
                drawingManager.setDrawingMode(null); //only place one at a time
            } else {
                firstMarker++;
            }
            itemMarker = marker; //assign globally
            document.getElementById('posItem').value = itemMarker.getPosition();
            savingMarkerCenter = itemMarker.getPosition(); //store coords to save
            codeLatLng(itemMarker.getPosition());
        }

        if (placerType == "poi") {
            poi_i++;

            label[poi_i] = new MarkerWithLabel({
                position: marker.getPosition(), //position of real marker
                map: map,
                zIndex: 2,
                labelContent: poi_i + 1, //the current user count
                labelAnchor: new google.maps.Point(15, 0),
                labelClass: "labels", // the CSS class for the label
                labelStyle: { opacity: 0.75 },
                icon: {} //initialize to nothing so no marker shows
            });

            poiObj[poi_i] = marker;
            poiType[poi_i] = "marker";
            var poiId = poi_i + 1;
            var poiDescTemp = L_Marker;
            document.getElementById("poiList").innerHTML += "<div id=\"poi" + poi_i + "\" class=\"poiListItem\"> " + poiId + ". " + poiDescTemp +
                " <div class=\"poiActionButton\"><a href=\"#\" onclick=\"poiEditMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/edit.png\"/></a>" +
                " <a id=\"poiToggle" + poi_i + "\" href=\"#\"><img src=\"" + baseURL + "default/images/mapper/sub.png\" onclick=\"poiHideMe(" + poi_i + ");\" /></a>" +
                " <a href=\"#\" onclick=\"poiDeleteMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/delete.png\"/></a></div></div>";
            var contentString = "<textarea id=\"poiDesc" + poi_i + "\" class=\"descPOI\" placeholder=\"" + L3 + "\"></textarea> <br/>" +
                " <a href=\"#\" class=\"buttonPOIDesc\" id=\"poiGetDesc\" onClick=\"poiGetDesc(" + poi_i + ");\">Save</a>";
            infowindow[poi_i] = new google.maps.InfoWindow({
                content: contentString,
                pixelOffset: new google.maps.Size(0, 0)
            });
            infowindow[poi_i].open(map, poiObj[poi_i]);
        }

        google.maps.event.addListener(marker, 'dragstart', function () {
            
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) { 
                    if (poiObj[i] == this) {
                        infowindow[i].setMap(null);
                        label[i].setMap(null);
                    }
                }
            }
        });
        google.maps.event.addListener(marker, 'dragend', function () {
            if (placerType == "item") {
                document.getElementById('posItem').value = marker.getPosition();
                codeLatLng(marker.getPosition());
            }
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setOptions({ position: marker.getPosition(), pixelOffset: new google.maps.Size(0, -40) });
                        infowindow[i].open(map);
                        label[i].setPosition(marker.getPosition());
                        label[i].setMap(map);
                    }
                }
            }
        });
        google.maps.event.addListener(marker, 'click', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setOptions({ position: marker.getPosition(), pixelOffset: new google.maps.Size(0, -40) });
                        infowindow[i].open(map);
                    }
                }
            }
        });
    });
    google.maps.event.addListener(drawingManager, 'circlecomplete', function (circle) {
        testBounds();
        if (placerType == "poi") {
            poi_i++;

            label[poi_i] = new MarkerWithLabel({
                position: circle.getCenter(), //position of real marker
                zIndex: 2,
                map: map,
                labelContent: poi_i + 1, //the current user count
                labelAnchor: new google.maps.Point(15, 0),
                labelClass: "labels", // the CSS class for the label
                labelStyle: { opacity: 0.75 },
                icon: {} //initialize to nothing so no marker shows
            });

            var poiId = poi_i + 1;
            poiObj[poi_i] = circle;
            poiType[poi_i] = "circle";
            var poiDescTemp = L_Circle;
            document.getElementById("poiList").innerHTML += "<div id=\"poi" + poi_i + "\" class=\"poiListItem\"> " + poiId + ". " + poiDescTemp + " <div class=\"poiActionButton\"><a href=\"#\" onclick=\"poiEditMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/edit.png\"/></a> <a id=\"poiToggle" + poi_i + "\" href=\"#\"><img src=\"" + baseURL + "default/images/mapper/sub.png\" onclick=\"poiHideMe(" + poi_i + ");\" /></a> <a href=\"#\" onclick=\"poiDeleteMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/delete.png\"/></a></div></div>";
            var contentString = "<textarea id=\"poiDesc" + poi_i + "\" class=\"descPOI\" placeholder=\"" + L3 + "\"></textarea> <br/> <a href=\"#\" class=\"buttonPOIDesc\" id=\"poiGetDesc\" onClick=\"poiGetDesc(" + poi_i + ");\">Save</a>";
            infowindow[poi_i] = new google.maps.InfoWindow({
                content: contentString
            });
            infowindow[poi_i].setPosition(circle.getCenter());
            infowindow[poi_i].open(map);
        }

        google.maps.event.addListener(circle, 'dragstart', function () {

            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setMap(null);
                        label[i].setMap(null);
                    }
                }
            }
        });
        google.maps.event.addListener(circle, 'drag', function () {
            //used to get the center point for lat/long tool
            circleCenter = circle.getCenter();
            var str = circle.getCenter().toString();
            var cLatV = str.replace("(", "").replace(")", "").split(",", 1);
            var cLongV = str.replace(cLatV, "").replace("(", "").replace(")", "").replace(",", ""); //is this better than passing into array?s
            if (cLatV.indexOf("-") != 0) {
                latH = "N";
            } else {
                latH = "S";
            }
            if (cLongV.indexOf("-") != 0) {
                longH = "W";
            } else {
                longH = "E";
            }
            cLat.innerHTML = cLatV + " (" + latH + ")";
            cLong.innerHTML = cLongV + " (" + longH + ")";           
        });
        google.maps.event.addListener(circle, 'dragend', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(circle.getCenter());
                        infowindow[i].open(map);
                        label[i].setPosition(circle.getCenter());
                        label[i].setMap(map);
                    }
                }
            }
        });
        google.maps.event.addListener(circle, 'click', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(circle.getCenter());
                        infowindow[i].open(map);
                    }
                }
            }
        });
    });
    google.maps.event.addListener(drawingManager, 'rectanglecomplete', function (rectangle) {
        
        testBounds();                                   //check the bounds to make sure you havent strayed too far away

        if (placerType == "poi") {
            poi_i++;

            label[poi_i] = new MarkerWithLabel({
                position: rectangle.getBounds().getCenter(), //position of real marker
                zIndex: 2,
                map: map,
                labelContent: poi_i + 1, //the current user count
                labelAnchor: new google.maps.Point(15, 0),
                labelClass: "labels", // the CSS class for the label
                labelStyle: { opacity: 0.75 },
                icon: {} //initialize to nothing so no marker shows
            });

            var poiId = poi_i + 1;
            poiObj[poi_i] = rectangle;
            poiType[poi_i] = "rectangle";
            var poiDescTemp = L_Rectangle;
            document.getElementById("poiList").innerHTML += "<div id=\"poi" + poi_i + "\" class=\"poiListItem\"> " + poiId + ". " + poiDescTemp + " <div class=\"poiActionButton\"><a href=\"#\" onclick=\"poiEditMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/edit.png\"/></a> <a id=\"poiToggle" + poi_i + "\" href=\"#\"><img src=\"" + baseURL + "default/images/mapper/sub.png\" onclick=\"poiHideMe(" + poi_i + ");\" /></a> <a href=\"#\" onclick=\"poiDeleteMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/delete.png\"/></a></div></div>";
            var contentString = "<textarea id=\"poiDesc" + poi_i + "\" class=\"descPOI\" placeholder=\"" + L3 + "\"></textarea> <br/> <a href=\"#\" class=\"buttonPOIDesc\" id=\"poiGetDesc\" onClick=\"poiGetDesc(" + poi_i + ");\">Save</a>";
            infowindow[poi_i] = new google.maps.InfoWindow({
                content: contentString
            });
            infowindow[poi_i].setPosition(rectangle.getBounds().getCenter());
            infowindow[poi_i].open(map);
        }
        
        google.maps.event.addListener(rectangle, 'bounds_changed', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(rectangle.getBounds().getCenter());
                        infowindow[i].setMap(map);
                        label[i].setPosition(rectangle.getBounds().getCenter());
                        label[i].setMap(map);
                    }
                }   
            }
        });
        google.maps.event.addListener(rectangle, 'dragstart', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setMap(null);
                        label[i].setMap(null);
                    }
                }
            }
        });
        google.maps.event.addListener(rectangle, 'drag', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setMap(null);
                        label[i].setMap(null);
                    }
                }
            }
            //used to get center point for lat/long tool
            var str = rectangle.getBounds().getCenter().toString();
            var cLatV = str.replace("(", "").replace(")", "").split(",", 1);
            var cLongV = str.replace(cLatV, "").replace("(", "").replace(")", "").replace(",", "");
            if (cLatV.indexOf("-") != 0) {
                latH = "N";
            } else {
                latH = "S";
            }
            if (cLongV.indexOf("-") != 0) {
                longH = "W";
            } else {
                longH = "E";
            }
            cLat.innerHTML = cLatV + " (" + latH + ")";
            cLong.innerHTML = cLongV + " (" + longH + ")";
        });
        google.maps.event.addListener(rectangle, 'dragend', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(rectangle.getBounds().getCenter());
                        infowindow[i].open(map);
                        label[i].setPosition(rectangle.getBounds().getCenter());
                        label[i].setMap(map);
                    }
                }
            }
        });
        google.maps.event.addListener(rectangle, 'click', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(rectangle.getBounds().getCenter());
                        infowindow[i].open(map);
                    }
                }
            }
        });
        
    });
    google.maps.event.addListener(drawingManager, 'polygoncomplete', function (polygon) {
        testBounds();
        if (placerType == "poi") {
            poi_i++;

            label[poi_i] = new MarkerWithLabel({
                position: polygonCenter(polygon), //position of real marker
                zIndex: 2,
                map: map,
                labelContent: poi_i + 1, //the current user count
                labelAnchor: new google.maps.Point(15, 0),
                labelClass: "labels", // the CSS class for the label
                labelStyle: { opacity: 0.75 },
                icon: {} //initialize to nothing so no marker shows
            });

            var poiId = poi_i + 1;
            poiObj[poi_i] = polygon;
            poiType[poi_i] = "polygon";
            var poiDescTemp = L_Polygon;
            document.getElementById("poiList").innerHTML += "<div id=\"poi" + poi_i + "\" class=\"poiListItem\"> " + poiId + ". " + poiDescTemp + " <div class=\"poiActionButton\"><a href=\"#\" onclick=\"poiEditMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/edit.png\"/></a> <a id=\"poiToggle" + poi_i + "\" href=\"#\"><img src=\"" + baseURL + "default/images/mapper/sub.png\" onclick=\"poiHideMe(" + poi_i + ");\" /></a> <a href=\"#\" onclick=\"poiDeleteMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/delete.png\"/></a></div></div>";
            var contentString = "<textarea id=\"poiDesc" + poi_i + "\" class=\"descPOI\" placeholder=\"" + L3 + "\"></textarea> <br/> <a href=\"#\" class=\"buttonPOIDesc\" id=\"poiGetDesc\" onClick=\"poiGetDesc(" + poi_i + ");\">Save</a>";
            infowindow[poi_i] = new google.maps.InfoWindow({
                content: contentString
            });
            infowindow[poi_i].setPosition(polygonCenter(polygon));
            infowindow[poi_i].open(map);
        }
        google.maps.event.addListener(polygon.getPath(), 'set_at', function () { //if bounds change
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(polygonCenter(polygon));
                        infowindow[i].setMap(map);
                        label[i].setPosition(polygonCenter(polygon));
                        label[i].setMap(null);
                    }
                }
            }
        });
        google.maps.event.addListener(polygon, 'dragstart', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setMap(null);
                        label[i].setMap(null);
                    }
                }
            }
        });
        google.maps.event.addListener(polygon, 'drag', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setMap(null);
                        label[i].setMap(null);
                    }
                }
            }
            //used for lat/long tool
            var str = polygonCenter(polygon).toString();
            var cLatV = str.replace("(", "").replace(")", "").split(",", 1);
            var cLongV = str.replace(cLatV, "").replace("(", "").replace(")", "").replace(",", ""); //is this better than passing into array?s
            if (cLatV.indexOf("-") != 0) {
                latH = "N";
            } else {
                latH = "S";
            }
            if (cLongV.indexOf("-") != 0) {
                longH = "W";
            } else {
                longH = "E";
            }
            cLat.innerHTML = cLatV + " (" + latH + ")";
            cLong.innerHTML = cLongV + " (" + longH + ")";
        });
        google.maps.event.addListener(polygon, 'dragend', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(polygonCenter(polygon));
                        infowindow[i].open(map);
                        label[i].setPosition(polygonCenter(polygon));
                        label[i].setMap(map);
                    }
                }
            }
        });
        google.maps.event.addListener(polygon, 'click', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(polygonCenter(polygon));
                        infowindow[i].open(map);
                    }
                }
            }
        });
    });
    google.maps.event.addListener(drawingManager, 'polylinecomplete', function (polyline) {
        testBounds();
        if (placerType == "poi") {
            poi_i++;
            var poiId = poi_i + 1;
            poiObj[poi_i] = polyline;
            poiType[poi_i] = "polyline";
            var poiDescTemp = L_Line;
            document.getElementById("poiList").innerHTML += "<div id=\"poi" + poi_i + "\" class=\"poiListItem\"> " + poiId + ". " + poiDescTemp + " <div class=\"poiActionButton\"><a href=\"#\" onclick=\"poiEditMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/edit.png\"/></a> <a id=\"poiToggle" + poi_i + "\" href=\"#\"><img src=\"" + baseURL + "default/images/mapper/sub.png\" onclick=\"poiHideMe(" + poi_i + ");\" /></a> <a href=\"#\" onclick=\"poiDeleteMe(" + poi_i + ");\"><img src=\"" + baseURL + "default/images/mapper/delete.png\"/></a></div></div>";
            var contentString = "<textarea id=\"poiDesc" + poi_i + "\" class=\"descPOI\" placeholder=\"" + L3 + "\"></textarea> <br/> <a href=\"#\" class=\"buttonPOIDesc\" id=\"poiGetDesc\" onClick=\"poiGetDesc(" + poi_i + ");\">Save</a>";
            infowindow[poi_i] = new google.maps.InfoWindow({
                content: contentString
            });
            var bounds = new google.maps.LatLngBounds;
            polyline.getPath().forEach(function (latLng) { bounds.extend(latLng); });
            var polylineCenter = bounds.getCenter();
            infowindow[poi_i].setPosition(polylineCenter);
            infowindow[poi_i].open(map);

            label[poi_i] = new MarkerWithLabel({
                position: polylineCenter, //position of real marker
                zIndex: 2,
                map: map,
                labelContent: poiId, //the current user count
                labelAnchor: new google.maps.Point(15, 0),
                labelClass: "labels", // the CSS class for the label
                labelStyle: { opacity: 0.75 },
                icon: {} //initialize to nothing so no marker shows
            });

        }
        google.maps.event.addListener(polyline.getPath(), 'set_at', function () { //what is path?
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        var bounds = new google.maps.LatLngBounds;
                        polyline.getPath().forEach(function (latLng) { bounds.extend(latLng); });
                        var polylineCenter = bounds.getCenter();
                        infowindow[i].setPosition(polylineCenter);
                        infowindow[i].setMap(map);
                        label[i].setPosition(polylineCenter);
                        label[i].setMap(map);
                    }
                }
                
            }
        });
        google.maps.event.addListener(polyline, 'dragstart', function () {
            if (placerType == "poi") {
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setMap(null);
                        label[i].setMap(null);
                    }
                }
            }
        });
        google.maps.event.addListener(polyline, 'drag', function () {
            //used for lat/long tooll
            var bounds = new google.maps.LatLngBounds;
            polyline.getPath().forEach(function (latLng) { bounds.extend(latLng); });
            var polylineCenter = bounds.getCenter();
            var str = polylineCenter.toString();
            var cLatV = str.replace("(", "").replace(")", "").split(",", 1);
            var cLongV = str.replace(cLatV, "").replace("(", "").replace(")", "").replace(",", ""); //is this better than passing into array?s
            if (cLatV.indexOf("-") != 0) {
                latH = "N";
            } else {
                latH = "S";
            }
            if (cLongV.indexOf("-") != 0) {
                longH = "W";
            } else {
                longH = "E";
            }
            cLat.innerHTML = cLatV + " (" + latH + ")";
            cLong.innerHTML = cLongV + " (" + longH + ")";
        });
        google.maps.event.addListener(polyline, 'dragend', function () {
            if (placerType == "poi") {
                var bounds = new google.maps.LatLngBounds;
                polyline.getPath().forEach(function (latLng) { bounds.extend(latLng); });
                var polylineCenter = bounds.getCenter();
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(polylineCenter);
                        infowindow[i].open(map);
                        label[i].setPosition(polylineCenter);
                        label[i].setMap(map);
                    }
                }
                
            }
        });
        google.maps.event.addListener(polyline, 'click', function () {
            if (placerType == "poi") {
                var bounds = new google.maps.LatLngBounds;
                polyline.getPath().forEach(function (latLng) { bounds.extend(latLng); });
                var polylineCenter = bounds.getCenter();
                for (var i = 0; i < poiObj.length; i++) {
                    if (poiObj[i] == this) {
                        infowindow[i].setPosition(polylineCenter);
                        infowindow[i].open(map);
                    }
                }
                
            }
        });
    });
    
    //initialize various listeners
    google.maps.event.addListener(map, 'rightclick', function () {
        drawingManager.setDrawingMode(null); //reset drawing manager no matter what
    });                                           //on right click stop drawing thing
    google.maps.event.addDomListener(map, 'mousemove', function (point) {

        if (cCoordsFrozen == "no") {
            //cCoord.innerHTML = point.latLng.toString(); //directly inject into page
            var str = point.latLng.toString();
            var cLatV = str.replace("(", "").replace(")", "").split(",", 1);
            var cLongV = str.replace(cLatV, "").replace("(", "").replace(")", "").replace(",", ""); //is this better than passing into array?s
            if (cLatV.indexOf("-") != 0) {
                latH = "N";
            } else {
                latH = "S";
            }
            if (cLongV.indexOf("-") != 0) {
                longH = "W";
            } else {
                longH = "E";
            }

            cLat.innerHTML = cLatV + " (" + latH + ")";
            cLong.innerHTML = cLongV + " (" + longH + ")";
        }
        
    });                                    //used to display cursor location via lat/long
    google.maps.event.addListener(map, 'dragend', function () {
        testBounds();
    });                                              //drag listener (for boundary test)
    google.maps.event.addListener(map, 'zoom_changed', function () {
        checkZoomLevel();
    });                                         //check the zoom level display message if out limits

    //#endregion

    $("#footer_item_wrapper").remove(); //temp to remove footer
    
    initOverlays(); //initialize all the incoming overlays (the fcn is written via c#)
    
    //keypress shortcuts/actions
    window.onkeypress = keypress;
    function keypress(e) {
        var keycode = null;
        if (window.event) {
            keycode = window.event.keyCode;
        } else if (e) {
            keycode = e.which;
        }
        switch (keycode) {
            case 122: //z
                if (navigator.appName == "Microsoft Internet Explorer") {
                    var copyString = cLat.innerHTML;
                    copyString += ", " + cLong.innerHTML;
                    window.clipboardData.setData("Text", copyString);
                    displayMessage("Coordinates Copied To Clipboard");
                } else {
                    if (cCoordsFrozen == "no") {
                        //freeze
                        cCoordsFrozen = "yes";
                        displayMessage("Coordinates Viewer Frozen");                      
                    } else {
                        //unfreeze
                        cCoordsFrozen = "no";
                        displayMessage("Coordinates Viewer UnFrozen");
                    }  
                }
            break;
            case 111: //o
                if (overlaysCurrentlyDisplayed == true) {
                    displayMessage("Hiding Overlays");
                    for (var i = 0; i < incomingOverlayBounds.length; i++) {    //go through and display overlays as long as there is an overlay to display
                        overlaysOnMap[i].setMap(null);                          //hide the overlay from the map
                        ghostOverlayRectangle[i].setMap(null);                  //hide ghost from map
                        overlaysCurrentlyDisplayed = false;                     //mark that overlays are not on the map
                    }
                } else {
                    displayMessage("Showing Overlays");
                    for (var i = 0; i < incomingOverlayBounds.length; i++) {   //go through and display overlays as long as there is an overlay to display
                        overlaysOnMap[i].setMap(map);                          //set the overlay to the map
                        ghostOverlayRectangle[i].setMap(map);                  //set to map
                        overlaysCurrentlyDisplayed = true;                     //mark that overlays are on the map
                    }
                }
                
            break;
        }
    }

}                         //on page load functions (mainly google map event listeners)

//Displays all the overlays sent from the C# code. Also calls displayGhostOverlayRectangle.
function displayIncomingOverlays() {
    for (var i = 0; i < incomingOverlayBounds.length; i++) {                                                                                //go through and display overlays as long as there is an overlay to display
        overlaysOnMap[i] = new CustomOverlay(i, incomingOverlayBounds[i], incomingOverlaySourceURL[i], map, incomingOverlayRotation[i]);    //create overlay with incoming
        overlaysOnMap[i].setMap(map);                                                                                                       //set the overlay to the map
        setGhostOverlay(i, incomingOverlayBounds[i]);                                                                                       //set hotspot on top of overlay
    }
    overlaysCurrentlyDisplayed = true;
}

function setGhostOverlay(ghostIndex, ghostBounds) {
    
    //create ghost directly over an overlay
    ghostOverlayRectangle[ghostIndex] = new google.maps.Rectangle();        //init ghost
    ghostOverlayRectangle[ghostIndex].setOptions(ghosting);                 //set ghosting 
    ghostOverlayRectangle[ghostIndex].setBounds(ghostBounds);               //set bounds
    ghostOverlayRectangle[ghostIndex].setMap(map);                          //set to map
    
    //create listener for if clicked
    google.maps.event.addListener(ghostOverlayRectangle[ghostIndex], 'click', function () {
        if (pageMode == "edit") {
            if (currentlyEditing == "yes") {                                                            //if editing is being done, save
                cacheSaveOverlay(ghostIndex);                                                           //trigger a cache of current working overlay
                ghostOverlayRectangle[workingOverlayIndex].setOptions(ghosting);                        //set rectangle to ghosting
                currentlyEditing = "no";                                                                //reset editing marker
                preservedRotation = 0;                                                                  //reset preserved rotation
            }
            if (currentlyEditing == "no") {                                                             //if editing is not being done, start editing
                $("#toolbox").show();                                                                   //show the toolbox
                toolboxDisplayed = true;                                                                //mark that the toolbox is open
                $("#toolboxTabs").accordion({ active: 3 });                                             //open edit overlay tab in toolbox
                currentlyEditing = "yes";                                                               //enable editing marker
                workingOverlayIndex = ghostIndex;                                                       //set this overay as the one being e
                ghostOverlayRectangle[ghostIndex].setOptions(editable);                                 //show ghost
                currentTopZindex++;                                                                     //iterate top z index
                document.getElementById("overlay" + ghostIndex).style.zIndex = currentTopZindex;        //bring overlay to front
                ghostOverlayRectangle[ghostIndex].setOptions({ zIndex: currentTopZindex });             //bring ghost to front
                for (var i = 0; i < savingOverlayIndex.length; i++) {                                   //set rotation if the overlay was previously saved
                    if (ghostIndex == savingOverlayIndex[i]) {
                        preservedRotation = savingOverlayRotation[i];
                    }
                }
            }
        }
    });
    
    //set listener for bounds changed
    google.maps.event.addListener(ghostOverlayRectangle[ghostIndex], 'bounds_changed', function () {
        if (pageMode == "edit") {
            overlaysOnMap[ghostIndex].setMap(null);                                                                                                                                 //hide previous overlay
            overlaysOnMap[ghostIndex] = null;                                                                                                                                       //delete previous overlay values
            overlaysOnMap[ghostIndex] = new CustomOverlay(ghostIndex, ghostOverlayRectangle[ghostIndex].getBounds(), incomingOverlaySourceURL[ghostIndex], map, preservedRotation); //redraw the overlay within the new bounds
            overlaysOnMap[ghostIndex].setMap(map);                                                                                                                                  //set the overlay with new bounds to the map
            currentlyEditing = "yes";                                                                                                                                               //enable editing marker
            cacheSaveOverlay(ghostIndex);                                                                                                                                           //trigger a cache of current working overlay
        }
    });

}

//Stores the overlays to save and their associated data
function cacheSaveOverlay(index) {
    savingOverlayIndex[csoi] = workingOverlayIndex;                                         //set overlay index to save
    savingOverlaySourceURL[csoi] = incomingOverlaySourceURL[workingOverlayIndex];           //set source url to save
    savingOverlayBounds[csoi] = ghostOverlayRectangle[workingOverlayIndex].getBounds();     //set bounds to save
    savingOverlayRotation[csoi] = preservedRotation;                                        //set rotation to save
    if (savingOverlayIndex[csoi] != index) {                                                
        csoi++;                                                                             //iterate the current save overlay index   
    }
}

//Starts the creation of a custom overlay div which contains a rectangular image.
//Supporting URL: https://developers.google.com/maps/documentation/javascript/overlays#CustomOverlays
function CustomOverlay(id, bounds, image, map, rotation) {
    overlayCount++;                 //iterate how many overlays have been drawn
    this.bounds_ = bounds;          //set the bounds
    this.image_ = image;            //set source url
    this.map_ = map;                //set to map
    preservedRotation = rotation;   //set the rotation
    this.div_ = null;               //defines a property to hold the image's div. We'll actually create this div upon receipt of the onAdd() method so we'll leave it null for now.
    this.index_ = id;               //set the index/id of this overlay
}

//Continues support for adding an custom overlay
//Supporting URL: https://developers.google.com/maps/documentation/javascript/overlays#CustomOverlays
// Note: an overlay's receipt of onAdd() indicates that the map's panes are now available for attaching the overlay to the map via the DOM.
CustomOverlay.prototype.onAdd = function () {
  
    // Create the DIV and set some basic attributes.
    var div = document.createElement("div");
    div.id = "overlay" + this.index_;
    div.style.borderStyle = 'none';
    div.style.borderWidth = '0px';
    div.style.position = 'absolute';
    div.style.opacity = preserveOpacity;

    // Create an IMG element and attach it to the DIV.
    var img = document.createElement('img');
    img.src = this.image_;
    img.style.width = '100%';
    img.style.height = '100%';
    img.style.position = 'absolute';
    div.appendChild(img);

    // Set the overlay's div_ property to this DIV
    this.div_ = div;

    // We add an overlay to a map via one of the map's panes.
    // We'll add this overlay to the overlayLayer pane.
    var panes = this.getPanes();
    panes.overlayLayer.appendChild(div);
};

//Continues support for adding an custom overlay
//Supporting URL: https://developers.google.com/maps/documentation/javascript/overlays#CustomOverlays
CustomOverlay.prototype.draw = function () {
    // Size and position the overlay. We use a southwest and northeast
    // position of the overlay to peg it to the correct position and size.
    // We need to retrieve the projection from this overlay to do this.
    var overlayProjection = this.getProjection();

    // Retrieve the southwest and northeast coordinates of this overlay
    // in latlngs and convert them to pixels coordinates.
    // We'll use these coordinates to resize the DIV.
    var sw = overlayProjection.fromLatLngToDivPixel(this.bounds_.getSouthWest());
    var ne = overlayProjection.fromLatLngToDivPixel(this.bounds_.getNorthEast());

    // Resize the image's DIV to fit the indicated dimensions.
    var div = this.div_;
    div.style.left = sw.x + 'px';
    div.style.top = ne.y + 'px';
    div.style.width = (ne.x - sw.x) + 'px';
    div.style.height = (sw.y - ne.y) + 'px';

    //for a preserved rotation
    if (preservedRotation != 0) {
        keepRotate(preservedRotation);
    }
    
};

//Not currently used
//Supporting URL: https://developers.google.com/maps/documentation/javascript/overlays#CustomOverlays
CustomOverlay.prototype.onRemove = function () {
    this.div_.parentNode.removeChild(this.div_);
    this.div_ = null;
};

//start this whole mess once the google map is loaded
google.maps.event.addDomListener(window, 'load', initialize);