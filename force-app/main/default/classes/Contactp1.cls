@RestResource(urlMapping='/contactp1')
global with sharing class Contactp1 {
  @HttpPost
  global static void createAccounts() {
    RestResponse res = RestContext.response;
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
      if (con.LastName == null || con.LastName == '') {
        ApiErrorHandler.setError(400, 'Enter LastName.');
        return;
      }
      if (
        con.AccountId == null ||
        con.AccountId == '' ||
        !con.AccountId.startsWith('001') ||
        con.AccountId.length() < 18
      ) {
        ApiErrorHandler.setError(400, 'Account Id is not correct.');
        return;
      }
      Contact newCon = new Contact(
        LastName = con.LastName,
        FirstName = con.FirstName,
        Email = con.Email,
        AccountId = con.AccountId
      );
      insert newCon;
      res.statusCode = 201;
      res.responseBody = Blob.valueOf(JSON.serialize(newCon));
    } catch (DmlException dmlEx) {
      ApiErrorHandler.setError(500, 'Internal Error.');
    }
  }

  public class ContactWrapper {
    public String LastName;
    public String FirstName;
    public String Email;
    public String AccountId;
  }
}
