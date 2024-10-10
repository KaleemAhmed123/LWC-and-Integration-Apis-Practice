// Fetch List of Accounts Based on Industry:
//  Write a web service that retrieves a list of Account records
//  that match a specific industry, provided as a parameter.
@RestResource(urlMapping='/accountc3')
global class accountc3 {
  @HttpGet
  global static void getAccByIndustry() {
    String industry = RestContext.request.params.get('industry');
    List<Account> accList = new List<Account>();
    if (String.isBlank(industry)) {
      ApiErrorHandler.setError(400, 'Please provide a valid Industry.');
      return;
    }

    try {
      accList = [
        SELECT Name, Industry, Type
        FROM Account
        WHERE Industry = :industry
      ];
      ApiResponseHandler.setResponse(200, accList);
    } catch (QueryException e) {
      ApiErrorHandler.setError(
        400,
        'Query Exception (May not ba a valid industry.)'
      );
    } catch (Exception e) {
      ApiErrorHandler.setError(500, 'Internal Server Error');
    }
  }
  global class RestException extends Exception {
  }
}
