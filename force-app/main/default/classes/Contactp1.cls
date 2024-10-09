@RestResource(urlMapping='/contactp1')
global with sharing class Contactp1 {
  @HttpPost
  global static void createAccounts() {
    try {
      RestRequest req = RestContext.request;
      ContactWrapper con = (ContactWrapper) JSON.deserialize(
        req.requestBody.toString(),
        ContactWrapper.class
      );

      if (String.isBlank(req.requestBody.toString())) {
        ApiErrorHandler.setError(400, 'Body is empty.');
        return;
      }
      if (String.isBlank(con.LastName)) {
        ApiErrorHandler.setError(400, 'Enter LastName.');
        return;
      }
      if (!ApiFieldValidation.isValidId(con.AccountId, '001')) {
        ApiErrorHandler.setError(400, 'Enter a valid Account Id.');
        return;
      }
      // query ex me le jaega
      Account parent = [SELECT Id FROM Account WHERE Id = :con.AccountId];

      Contact newCon = new Contact(
        LastName = con.LastName,
        FirstName = con.FirstName,
        Email = con.Email,
        AccountId = con.AccountId
      );
      insert newCon;
      ApiResponseHandler.setResponse(201, newCon);
    } catch (QueryException qe) {
      ApiErrorHandler.setError(
        500,
        'No Account with this parent Id. || ' + qe.getMessage()
      );
    } catch (Exception ex) {
      ApiErrorHandler.setError(
        500,
        'Internal Error. ' + ex.getMessage() + ex.getLineNumber()
      );
    }
  }

  public class ContactWrapper {
    public String LastName;
    public String FirstName;
    public String Email;
    public String AccountId;
  }
}
