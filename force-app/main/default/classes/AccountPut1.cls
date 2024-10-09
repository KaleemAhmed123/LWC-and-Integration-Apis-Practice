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

    if (!isNew && !ApiFieldValidation.isValidId(accountId, '001')) {
      ApiErrorHandler.setError(400, 'Please provide a valid account Id.');
      return;
    }

    try {
      Account acc = new Account();
      for (String field : requestBody.keySet()) {
        Object value = requestBody.get(field);

        if (!field.toLowerCase().contains('date')) {
          acc.put(field, requestBody.get(field));
        } else {
          try {
            acc.put(field, Date.valueOf((String) value));
          } catch (Exception e) {
            ApiErrorHandler.setError(
              400,
              'Invalid date format for field ' + field
            );
            return;
          }
        }
      }
      Account checkAcc = [SELECT Id FROM Account WHERE Id = :accountId];
      upsert acc;

      if (isNew) {
        ApiResponseHandler.setResponse(
          201,
          'Account Inserted Successfully ' + acc.Id
        );
      } else {
        ApiResponseHandler.setResponse(
          202,
          'Account Updated Successfully ' + acc.Id
        );
      }
    } catch (QueryException ex) {
      ApiErrorHandler.setError(
        400,
        'QueryExeption Error (Id may be wrong too)' + ex.getMessage()
      );
    } catch (Exception ex) {
      IntegrationErrorLogs.logError(
        'Failed',
        'Error while processing account',
        'AccountPut1.replaceAccount',
        ex,
        accountId
      );
      ApiErrorHandler.setError(500, 'Internal Error: ' + ex.getMessage());
    }
  }
}
