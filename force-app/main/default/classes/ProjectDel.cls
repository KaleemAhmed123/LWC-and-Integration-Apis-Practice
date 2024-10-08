@RestResource(urlMapping='/projectdel/*')
global with sharing class ProjectDel {
  @HttpDelete
  global static void deleteProject() {
    RestRequest req = RestContext.request;
    String Id = req.requestURI.substringAfterLast('/');

    if (String.isBlank(Id) || !Id.startsWith('a00')) {
      ApiErrorHandler.setError(400, 'Provide valid project Id.');
      return;
    }

    try {
      Project__c toDel = [SELECT Id FROM Project__c WHERE Id = :Id];
      delete toDel;
      ApiResponseHandler.setResponse(200, 'Successfully deleted.');
    } catch (QueryException qe) {
      ApiErrorHandler.setError(400, 'No Record found with this Id.');
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error ' + ex.getMessage());
    }
  }
}
