@RestResource(urlMapping='/contactpch1')
global with sharing class contactpch1 {
  @HttpPatch
  global static void updateEmailAndTitle() {
    RestResponse res = RestContext.response;

    try {
      RestRequest req = RestContext.request;
      contactWrapper conwrp = (contactWrapper) JSON.deserialize(
        req.requestBody.toString(),
        contactWrapper.class
      );

      if (String.isBlank(conwrp.Email)) {
        ApiErrorHandler.setError(400, 'Provide Email plz');
        return;
      }

      if (String.isBlank(conwrp.Title)) {
        ApiErrorHandler.setError(400, 'Provide Title plz');
        return;
      }
      if (
        (String.isBlank(conwrp.Id) || !conwrp.Id.startsWith('003')) &&
        (conwrp.Id.length() != 18 &&
        conwrp.Id.length() != 15)
      ) {
        ApiErrorHandler.setError(400, 'Provide valid contact Id plz');
        return;
      }

      Contact con = [SELECT Id FROM Contact WHERE Id = :conwrp.Id];

      Contact updateCon = new Contact(
        Id = conwrp.Id,
        Title = conwrp.Title,
        Email = conwrp.Email
      );
      update updateCon;

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
    String Id;
    String Email;
    String Title;
  }
}
