# Google-Maps-integration!

 
## About

This is an assessment shows the Distance, Travel Time, and cost of Travel built using Salesforce Lightning Web Components and SLDS style.
It does rely on third party apis and you can have full control over its datasource provided with an api key.

## File struture:

<br> force-app/main/default/classes : This folder has four classes </br>
<br> 1.  Address Search Controller class</br>
<br> 2. Google Map calculation of Direction,Travel Time, and cost of Travel class </br>
<br> 3. Look Up search Result class</br>
<br> 4. Place finder Results class </br>

force-app/main/default/lwc/advancedMapLookUp : This is the Parent Component for the main framework of the LWC.

force-app/main/default/lwc/lookup: This is the Child Component used for the search suggestions


The lookup component provides the following features:

## Requirements: 
<br />
* Display a webpage that allows the user to enter an origin address and a destination address. The LWC should use the Google Maps API to autocomplete the addresses as the user types.

* When the user clicks the "Get Directions" button, the webpage calls an Apex class using JavaScript to pass the address information.

* The Apex class should use the Google Maps API to calculate the distance and travel time between the origin and destination addresses.

* The Apex class should also calculate the cost of travel, based on a fixed rate per mile for different modes of transportation (i.e: flying, driving). The rates should be stored in a Custom Metadata Type.

* The Apex class should pass the distance, travel time, and cost of travel back to the LWC.

* The LWC should display the distance, travel time, and cost of travel to the user.

* Important! The Apex class should include a variable called `vHash` where your full name is assigned in Base64 encoding. Your name should not appear in plaintext. Example (John Doe):
    “String vHash = ‘Sm9obiBEb2U=’;”.
    
* Include passing unit tests with Http Mock.

## Demo
![](GoogleMap_2.png)
===================
![](GoogleMaps_1.png)
===================
![](GoogleMaps_3.png)
  Custom Metadata Type:
  ![](Images/Image_1.png)
  ===============
  ![](Images/Image_2.png)
  
  


