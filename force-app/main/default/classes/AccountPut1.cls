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
        Object value = requestBody.get(field);

        // System.debug(value instanceof Date); //f
        // System.debug(value instanceof String); //t

        if (field.toLowerCase().contains('date')) {
          System.debug(field.toLowerCase().contains('date') + ' ---> ' + field);

          // best practice is to use any casting valueOf function inside try

          try {
            // (String) value imp to avoid invalid format error
            acc.put(field, Date.valueOf((String) value)); //wtf
          } catch (Exception e) {
            ApiErrorHandler.setError(
              400,
              'Invalid date format for field ' + e.getMessage() + field
            );
            return;
          }
        } else {
          acc.put(field, requestBody.get(field));
        }
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

// way to check type
/* 
    try {
        Account acc = new Account();

        // Get the field describe map for Account
        Map<String, Schema.SObjectField> fieldDescribeMap = Schema.SObjectType.Account.fields.getMap();

        for (String field : requestBody.keySet()) {
            // Check if the field exists on Account
            if (fieldDescribeMap.containsKey(field)) {
                Schema.DisplayType fieldType = fieldDescribeMap.get(field).getDescribe().getType();

                // Handle Date and DateTime fields separately
                if (fieldType == Schema.DisplayType.Date) {
                    acc.put(field, Date.valueOf((String) requestBody.get(field)));
                } else if (fieldType == Schema.DisplayType.DateTime) {
                    acc.put(field, DateTime.valueOf((String) requestBody.get(field)));
                } else {
                    acc.put(field, requestBody.get(field));
                }
            }
        }

        upsert acc;

        if (isNew) {
            ApiResponseHandler.setResponse(201, 'Account Inserted Successfully ' + acc.Id);
        } else {
            ApiResponseHandler.setResponse(202, 'Account Updated Successfully ' + acc.Id);
        }
    } catch (Exception ex) {
        ApiErrorHandler.setError(500, 'Internal Error' + ex.getMessage());
    }
*/

