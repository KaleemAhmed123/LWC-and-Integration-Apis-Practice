// Fetch List of Accounts Based on Industry:
//  Write a web service that retrieves a list of Account records
//  that match a specific industry, provided as a parameter.
@RestResource(urlMapping='/accountc2')
global class accountc1 {
  @HttpGet
  global static void getAccById() {
    String Id = RestContext.request.params.get('Id');
    if (!ApiFieldValidation.isValidId(Id, '001')) {
      ApiErrorHandler.setError(400, 'Provide a valid Account Id.');
      return;
    }

    try {
      Account acc = [SELECT Name, Industry, Type FROM Account WHERE Id = :Id];
      ApiResponseHandler.setResponse(200, acc);
    } catch (QueryException e) {
      ApiErrorHandler.setError(400, 'Query Exception (May not be valid Id)');
    } catch (Exception e) {
      ApiErrorHandler.setError(500, 'Internal Server Error');
    }
  }
  global class RestException extends Exception {
  }
}
