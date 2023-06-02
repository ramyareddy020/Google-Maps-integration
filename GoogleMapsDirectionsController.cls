public with sharing class GoogleMapsDirectionsController {
    // Define your full name in Base64 encoding
    //String vHash = 'Sm9obiBEb2U=';
    public class Directions {
        @AuraEnabled public String distance;
        @AuraEnabled public String travelTime;
        @AuraEnabled public String costOfTravel;
        
        public Directions(String distance, String travelTime, String cost) {
            this.distance = distance;
            this.travelTime = travelTime;
            this.costOfTravel = costOfTravel;
    }
}
    String vHash = EncodingUtil.base64Encode(Blob.valueOf('Ramya Reddy'));


    @AuraEnabled(cacheable=true)
    public static Directions calculateDirections(String originAddress, String destinationAddress) {
        
        // Call the Google Maps API to calculate distance, travel time, and cost of travel
         String apiUrl = 'https://maps.googleapis.com/maps/api/directions/json';
        String apiKey = 'yourkey'; // Replace with your actual API key
        
        // Set the request parameters
        String requestUrl = apiUrl + '?origin=' + EncodingUtil.urlEncode(originAddress , 'UTF-8')
                            + '&destination=' + EncodingUtil.urlEncode(destinationAddress , 'UTF-8')
                            + '&key=' + apiKey;
 
     
        // Make the API call
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestUrl);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = new Http().send(request);
        // Parse the API response
		if (response.getStatusCode() == 200) {
    // Process the response and extract the required data
    String responseBody = response.getBody();
    
    // Parse the JSON response
    Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
    
    // Extract distance and travel time from the response
    List<Object> routes = (List<Object>) responseMap.get('routes');
    if (routes != null && !routes.isEmpty()) {
        Map<String, Object> route = (Map<String, Object>) routes[0];
        List<Object> legs = (List<Object>) route.get('legs');
        if (legs != null && !legs.isEmpty()) {
            Map<String, Object> leg = (Map<String, Object>) legs[0];
            Map<String, Object> distanceMap = (Map<String, Object>) leg.get('distance');
            Map<String, Object> durationMap = (Map<String, Object>) leg.get('duration');
            
            String distance = (String) distanceMap.get('text');
            String travelTime = (String) durationMap.get('text');
            
           List<Transportation_Rate__mdt> rates = [SELECT Mode_of_Transportation_c__c, Rate_per_Mile_c__c FROM Transportation_Rate__mdt];
                // Example distance
        			Decimal rate = 0;  
            for (Transportation_Rate__mdt rateRecord : rates) {
                if (rateRecord.Mode_of_Transportation_c__c == 'Air') {
                    rate = rateRecord.Rate_per_Mile_c__c;
                    break;
                }
            }
            Decimal numericDistance = Decimal.valueOf(distance.replaceAll('[^0-9.]+', ''));
            Decimal costOfTravel = numericDistance * rate;
            String costFormatted = '$' + costOfTravel.setScale(2);
            
            // Create a Directions object with the retrieved results
            Directions directions = new Directions(distance, travelTime, costFormatted);
            
            // Return the Directions object
            return directions;
        }
    }
    
    // Handle case where response does not contain the expected data
    System.debug('Unable to extract required data from API response');
    return null;
} else {
    // Handle the API call failure
    System.debug('API call failed with status code: ' + response.getStatusCode());
    return null;
}
    }
    }