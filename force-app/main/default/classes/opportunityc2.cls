// Retrieve Closed-Won Opportunities by Account: 
// Develop a web service to retrieve all closed-won Opportunities for a specific Account 
// by passing the Account ID as input.
/* @RestResource(urlMapping='/getWonOpporunity/*')
global class opportunity1 {
    @HttpGet
    global static List<Opportunity> getWonOpps() {
    	String Id = RestContext.request.requestURI.substringAfterLast('/');
        List<Opportunity> oppList = new List<Opportunity>();
        try {
            oppList = [SELECT Name, StageName, CloseDate FROM Opportunity
                       			WHERE AccountId = :Id AND StageName = 'Closed Won'];
            // RestContext.response.addHeader('Opportunity-Count', String.valueOf(oppList.size()));
        }  catch(Exception e) {
            throw new RestException('Errror ' + e.getMessage());
        }
        
        return oppList;
    }
    global class RestException extends Exception{}
}

*/

@RestResource(urlMapping='/getWonOpportunity')
global class opportunityc2 {
    @HttpGet
    global static void getWonOpps() {
        String accountId = RestContext.request.params.get('accountId');
        if(accountId == null || accountId == '' ) {
            ApiErrorHandler.setError(400, 'Account Id is empty');
            return;
        }
        if(!accountId.StartsWith('001') || accountId.length() < 18) {
            ApiErrorHandler.setError(400, 'Account Id starts with 001 and length should be 18');
            return;
        }
        
        try {
            List<Opportunity> oppList = [SELECT Id, Name, StageName, CloseDate 
                                         	FROM Opportunity WHERE AccountId = :accountId 
                                         		AND StageName = 'Closed Won'];
            
            RestResponse res = RestContext.Response;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(Json.serialize(oppList));
        } catch (Exception e) {
            ApiErrorHandler.setError(500, 'Internal Error');
        }
    }

    global class RestException extends Exception {}
}