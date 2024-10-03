@RestResource(urlMapping='/projectp2')
global with sharing class CustomObjectApi2 {
  @HttpPatch
  global static void updateProperties() {
    RestResponse res = RestContext.response;

    try {
      RestRequest req = RestContext.request;
      ProjectWrapper pwr = (ProjectWrapper) JSON.deserialize(
        req.requestBody.toString(),
        ProjectWrapper.class
      );

      if (
        String.isBlank(pwr.Id) ||
        !pwr.Id.startsWith('a00') ||
        pwr.Id.length() < 18
      ) {
        ApiErrorHandler.setError(400, 'Pleade Provide valid project Id');
        return;
      }

      Project__c newProject = new Project__c(
        Id = pwr.Id,
        Budget__c = pwr.budget,
        Status__c = pwr.status,
        Owner__c = pwr.owner
      );

      update newProject;

      res.statusCode = 202;
      res.responseBody = Blob.valueOf(JSON.serialize(newProject));
    } catch (DmlException dmlex) {
      ApiErrorHandler.setError(500, 'DML Error: ' + dmlex.getMessage());
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error: ' + ex.getMessage());
    }
  }

  public class ProjectWrapper {
    String Id;
    Decimal budget;
    String status;
    String owner;
  }
}
