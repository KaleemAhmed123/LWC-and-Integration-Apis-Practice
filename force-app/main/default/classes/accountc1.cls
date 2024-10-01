// Fetch List of Accounts Based on Industry:
//  Write a web service that retrieves a list of Account records 
//  that match a specific industry, provided as a parameter.
@RestResource(urlMapping='/accountc2')
global class accountc1 {
    @HttpGet
    global static void getAccById() {
        String Id = RestContext.request.params.get('Id');
         if(Id == null || Id == '' ) {
            ApiErrorHandler.setError(400, 'Account Id is empty');
            return;
        }
        if(!Id.StartsWith('001') || Id.length() < 18) {
            ApiErrorHandler.setError(400, 'Account Id starts with 001 and length should be 18');
            return;
        }
        
        try {
            Account acc = [SELECT Name, Industry, Type FROM Account WHERE Id = :Id];
            RestResponse res = RestContext.response;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(acc));
        } catch(Exception e) {
            ApiErrorHandler.setError(500, 'Internal Server Error');
        }
    }
    global class RestException extends Exception{}
}