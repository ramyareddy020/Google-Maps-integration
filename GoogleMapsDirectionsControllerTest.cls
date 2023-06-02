@isTest
private class GoogleMapsDirectionsControllerTest {
    @isTest
    static void testCalculateDirections() {
        // Set up test data
        String originAddress = 'Origin Address';
        String destinationAddress = 'Destination Address';

        // Set the mock HTTP response
        system.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the calculateDirections method
        GoogleMapsDirectionsController.Directions result = GoogleMapsDirectionsController.calculateDirections(originAddress, destinationAddress);

        // Verify the result
        System.assertEquals('10.2 km', result.distance);
        System.assertEquals('30 mins', result.travelTime);
        System.assertEquals('$20.40', result.costOfTravel);
    }

    // Inner class for generating mock HTTP response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            // Create mock response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"routes": [{"legs": [{"distance": {"text": "10.2 km"}, "duration": {"text": "30 mins"}}]}]}');
            response.setStatusCode(200);
            return response;
        }
    }
}