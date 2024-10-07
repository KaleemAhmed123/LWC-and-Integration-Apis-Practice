@RestResource(urlMapping='/accountput1')
global with sharing class AccountPut1 {
  @HttpPut
  global static void replaceAccount() {
    RestRequest req = RestContext.request;
    Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(
      req.requestBody.toString()
    );

    String accountId = (String) requestBody.get('Id');
    Boolean isNew = (accountId == null);
    // skipping !String.isBlank(Id) cause if doenot exist well create it
    // just not allowing wrong format
    if (!isNew && (!accountId.startsWith('001') || accountId.length() < 18)) {
      ApiErrorHandler.setError(400, 'Please provide a valid account Id.');
      return;
    }

    try {
      Account acc = new Account();
      for (String field : requestBody.keySet()) {
        acc.put(field, requestBody.get(field));
      }
      upsert acc;

      if (isNew)
        ApiResponseHandler.setResponse(
          201,
          'Account Inserted Successfully ' + acc.Id
        );
      else
        ApiResponseHandler.setResponse(
          202,
          'Account Updated Successfully ' + acc.Id
        );
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error' + ex.getMessage());
    }
  }
}
