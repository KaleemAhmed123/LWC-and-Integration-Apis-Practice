@RestResource(urlMapping='/accountdel1')
global with sharing class AccountDelete1 {
  @HttpDelete
  global static void call() {
    RestRequest req = RestContext.request;
    try {
      wrapper accToDel = (wrapper) JSON.deserialize(
        req.requestBody.toString(),
        wrapper.class
      );
      DeleteChildRecordClass.deleteChildRecords(accToDel.Id, 'Account');
      ApiResponseHandler.setResponse(202, 'Account deleted successfully');
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error' + ex.getMessage());
    }
  }
  public class wrapper {
    String Id;
  }
}
