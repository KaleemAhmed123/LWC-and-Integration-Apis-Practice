@RestResource(urlMapping='/projectp2')
global with sharing class CustomObjectApi2 {
  @HttpPatch
  global static void updateProperties() {
    try {
      RestRequest req = RestContext.request;
      ProjectWrapper pwr = (ProjectWrapper) JSON.deserialize(
        req.requestBody.toString(),
        ProjectWrapper.class
      );

      if (!ApiFieldValidation.isValidId(pwr.Id, 'a00')) {
        ApiErrorHandler.setError(400, 'Pleade Provide valid project Id');
        return;
      }
      if (pwr.budget == null) {
        ApiErrorHandler.setError(400, 'Pleade Provide project budget.');
        return;
      }
      if (String.isBlank(pwr.status)) {
        ApiErrorHandler.setError(400, 'Pleade Provide project status.');
        return;
      }
      // owner not required
      Project__c pj = [
        SELECT Id, Budget__c, Status__c, Owner__c
        FROM Project__c
        WHERE Id = :pwr.Id
      ];
      pj.Budget__c = pwr.budget;
      pj.Status__c = pwr.status;
      pj.Owner__c = pwr.owner;
      update pj;

      ApiResponseHandler.setResponse(202, pj);
    } catch (DmlException dmlex) {
      ApiErrorHandler.setError(500, 'DML Error: ' + dmlex.getMessage());
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error: ' + ex.getMessage());
    }
  }

  public class ProjectWrapper {
    public String Id;
    public Decimal budget;
    public String status;
    public String owner;
  }
}
