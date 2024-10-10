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
    if (!ApiFieldValidation.isValidId(accountId, '001')) {
      ApiErrorHandler.setError(400, 'Provide a valid Account Id.');
      return;
    }

    try {
      List<Opportunity> oppList = [
        SELECT Id, Name, StageName, CloseDate
        FROM Opportunity
        WHERE AccountId = :accountId AND StageName = 'Closed Won'
      ];

      ApiResponseHandler.setResponse(200, oppList);
    } catch (Exception e) {
      ApiErrorHandler.setError(500, 'Internal Error' + e.getMessage());
    }
  }
}
