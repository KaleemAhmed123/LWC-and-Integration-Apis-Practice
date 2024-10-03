// Retrieve Opportunity by Name:
// Build a web service to get an Opportunity record by providing the Opportunity Name.

@RestResource(urlMapping='/opportunityc1')
global class opportunityc1 {
  @HttpGet
  global static void getOppsByName() {
    String name = RestContext.request.params.get('name');

    if (name == null || name == '') {
      ApiErrorHandler.setError(400, 'Provide a name please. ');
      return;
    }

    String wildAddedName = '%' + name + '%';
    List<Opportunity> oppList = new List<Opportunity>();
    try {
      oppList = [
        SELECT Name, StageName, CloseDate, AccountId
        FROM Opportunity
        WHERE Name LIKE :wildAddedName
      ];
      RestResponse res = RestContext.response;
      res.statusCode = 200;
      res.responseBody = Blob.valueOf(JSON.serialize(oppList));
    } catch (Exception e) {
      ApiErrorHandler.setError(500, 'Internal Error');
    }
  }
  global class RestException extends Exception {
  }
}
