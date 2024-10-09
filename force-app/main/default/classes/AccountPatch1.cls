@RestResource(urlMapping='/accountpch1')
global with sharing class AccountPatch1 {
  @HttpPatch
  global static void updatePhone() {
    RestResponse res = RestContext.response;

    try {
      RestRequest req = RestContext.request;
      accWrapper accWrapped = (accWrapper) JSON.deserialize(
        req.requestBody.toString(),
        accWrapper.class
      );

      if (!ApiFieldValidation.isValidId(accWrapped.Id, '001')) {
        ApiErrorHandler.setError(400, 'Provide a valid Account Id');
        return;
      }
      if (String.isBlank(accWrapped.Phone)) {
        ApiErrorHandler.setError(400, 'Provide Phone Plz.');
        return;
      }

      Account acc = [SELECT Id, Phone FROM Account WHERE Id = :accWrapped.Id];
      acc.Phone = accWrapped.Phone;
      update acc;

      ApiResponseHandler.setResponse(
        202,
        'Phone Update successfully to ' + accWrapped.Phone
      );
    } catch (QueryException qex) {
      ApiErrorHandler.setError(
        400,
        'Query Exception or no Account with the given Id. || ' +
        qex.getMessage()
      );
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error ' + ex.getMessage());
    }
  }

  public class accWrapper {
    String Phone;
    String Id;
  }
}
