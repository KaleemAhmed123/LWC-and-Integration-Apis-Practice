@RestResource(urlMapping='/contactput1')
global with sharing class ContactPut1 {
  @HttpPut
  global static void call() {
    RestRequest req = RestContext.request;
    Map<String, Object> reqBody = (Map<String, Object>) JSON.deserializeUntyped(
      req.requestBody.toString()
    );
    String conId = (String) reqBody.get('Id');
    Boolean isNew = (conId == null);

    if (!isNew && !ApiFieldValidation.isValidId(conId, '003')) {
      ApiErrorHandler.setError(400, 'Provide valid contact Id');
      return;
    }

    Contact con = new Contact();
    for (String field : reqBody.keySet()) {
      Object value = reqBody.get(field);
      if (!field.toLowerCase().contains('date')) {
        con.put(field, reqBody.get(field));
      } else {
        try {
          con.put(field, Date.valueOf((String) value));
        } catch (Exception e) {
          ApiErrorHandler.setError(
            400,
            'Invalid date format for field ' + field
          );
          return;
        }
      }
    }
    upsert con;

    if (isNew) {
      ApiResponseHandler.setResponse(
        201,
        'Contact Created Successfully: ' + con.Id
      );
    } else {
      ApiResponseHandler.setResponse(
        201,
        'Contact Updated Successfully: ' + con.Id
      );
    }
  }
}
