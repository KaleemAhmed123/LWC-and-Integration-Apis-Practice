// Fetch List of Accounts Based on Industry:
//  Write a web service that retrieves a list of Account records 
//  that match a specific industry, provided as a parameter.
@RestResource(urlMapping='/accountc3')
global class accountc3 {
    @HttpGet
    global static void getAccByIndustry() {
        String industry = RestContext.request.params.get('industry');
        List<Account> accList = new List<Account>();
        if(industry == null || industry == '') {
			ApiErrorHandler.setError(400, 'Please provide Industry');
            return;
        }
        
        try {
            accList = [SELECT Name, Industry, Type FROM Account WHERE Industry = :industry];
            RestResponse res = RestContext.response;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(accList));
            
            
        } catch(Exception e) {
            ApiErrorHandler.setError(500, 'Internal Server Error');
        }
    }
    global class RestException extends Exception{}
}