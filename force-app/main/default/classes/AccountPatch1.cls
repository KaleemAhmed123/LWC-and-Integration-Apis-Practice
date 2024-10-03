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

      if (String.isBlank(accWrapped.Id)) {
        ApiErrorHandler.setError(400, 'Provide Account Id');
        return;
      }
      if (String.isBlank(accWrapped.Phone)) {
        ApiErrorHandler.setError(400, 'Provide Phone Plz.');
        return;
      }

      Account acc = new Account(Id = accWrapped.Id, Phone = accWrapped.Phone);
      update acc;

      res.statusCode = 202;
      res.responseBody = Blob.valueOf(
        JSON.serialize('Phone Update successfully to ' + accWrapped.Phone)
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
