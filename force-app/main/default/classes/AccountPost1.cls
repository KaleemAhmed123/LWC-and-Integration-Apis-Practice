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
          ApiErrorHandler.setError(400, 'Account name required.');
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
        ApiResponseHandler.setResponse(201, 'Accounts inserted Successfully.');
      }
    } catch (DmlException dmlEx) {
      ApiErrorHandler.setError(400, 'Failed : ' + dmlEx.getMessage());
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal error : ' + ex.getMessage());
    }
  }

  public class AccountWrapper {
    public String name;
    public String phone;
    public String industry;
  }
}
