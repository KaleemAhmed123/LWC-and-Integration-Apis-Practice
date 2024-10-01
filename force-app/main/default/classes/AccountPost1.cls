@RestResource(urlMapping='/accountp1')
global with sharing class AccountPost1 {
  @HttpPost
  global static void createAccounts() {
    RestResponse res = RestContext.response;
    try {
      RestRequest req = RestContext.request;

      List<AccountWrapper> awrList = (List<AccountWrapper>) JSON.deserialize(
        req.requestBody.toString(),
        List<AccountWrapper>.class
      );

      List<Account> accountsToInsert = new List<Account>();
      for (AccountWrapper awr : awrList) {
        if (String.isBlank(awr.name)) {
          setResponse(400, 'Account name required.');
          return;
        }
        Account acc = new Account(
          Name = awr.name,
          Phone = awr.phone,
          Industry = awr.industry
        );
        accountsToInsert.add(acc);
      }

      if (!accountsToInsert.isEmpty()) {
        insert accountsToInsert;
        setResponse(201, 'Accounts successfully created.');
      }
    } catch (DmlException dmlEx) {
      setResponse(400, 'Failed : ' + dmlEx.getMessage());
    } catch (Exception ex) {
      setResponse(500, 'Internal error : ' + ex.getMessage());
    }
  }

  public class AccountWrapper {
    public String name;
    public String phone;
    public String industry;
  }

  private static void setResponse(Integer statusCode, String message) {
    RestResponse res = RestContext.response;
    res.statusCode = statusCode;
    res.responseBody = Blob.valueOf(
      JSON.serialize(new ResponseWrapper(message))
    );
  }

  public class ResponseWrapper {
    public String message;
    public ResponseWrapper(String message) {
      this.message = message;
    }
  }
}