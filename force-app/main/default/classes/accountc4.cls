// Get Account and Related Contacts: Write an Apex web service to fetch an Account record
// and all its related Contact records using the Account ID.
@RestResource(urlMapping='/accountc4')
global class accountc4 {
  @HttpGet
  global static void getAccountWithContacts() {
    String Id = RestContext.request.params.get('Id');

    if (!ApiFieldValidation.isValidId(Id, '001')) {
      ApiErrorHandler.setError(400, 'Please Provide Account Id.');
      return;
    }
    Account acc;
    try {
      acc = [
        SELECT Name, Id, (SELECT LastName, FirstName FROM Contacts)
        FROM Account
        WHERE Id = :Id
      ];
      ApiResponseHandler.setResponse(200, acc);
    } catch (Exception e) {
      ApiErrorHandler.setError(500, 'Internal Error');
    }
  }
  global class RestException extends Exception {
  }
}
