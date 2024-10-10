@RestResource(urlMapping='/contactpch1')
global with sharing class contactpch1 {
  @HttpPatch
  global static void updateEmailAndTitle() {
    try {
      RestRequest req = RestContext.request;
      contactWrapper conwrp = (contactWrapper) JSON.deserialize(
        req.requestBody.toString(),
        contactWrapper.class
      );

      if (
        String.isBlank(conwrp.Email) ||
        !ApiFieldValidation.isValidEmail(conwrp.Email)
      ) {
        ApiErrorHandler.setError(400, 'Provide a valid Email plz.');
        return;
      }
      if (String.isBlank(conwrp.Title)) {
        ApiErrorHandler.setError(400, 'Provide Title plz');
        return;
      }
      if (!ApiFieldValidation.isValidId(conwrp.Id, '003')) {
        ApiErrorHandler.setError(400, 'Provide valid a contact Id plz.');
        return;
      }

      Contact con = [SELECT Id FROM Contact WHERE Id = :conwrp.Id];
      con.Title = conwrp.Title;
      con.Email = conwrp.Email;
      update con;

      ApiResponseHandler.setResponse(
        202,
        'Email and Title updated Successfully to ' +
          conwrp.Email +
          ' and ' +
          conwrp.Title
      );
    } catch (QueryException ex) {
      ApiErrorHandler.setError(
        400,
        'Query Error: Not a valid Id' + ex.getMessage()
      );
      return;
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error ' + ex.getMessage());
      return;
    }
  }

  public class contactWrapper {
    public String Id;
    public String Email;
    public String Title;
  }
}
