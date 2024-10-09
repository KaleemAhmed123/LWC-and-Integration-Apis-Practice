@RestResource(urlMapping='/customobj1')
global with sharing class CustomObjectApi1 {
  @HttpPost
  global static void call() {
    try {
      RestRequest req = RestContext.request;
      ProjectWrapper pwr = (ProjectWrapper) JSON.deserialize(
        req.requestBody.toString(),
        ProjectWrapper.class
      );

      Date startDate, endDate;
      try {
        startDate = Date.valueOf(pwr.startDate);
        endDate = Date.valueOf(pwr.endDate);
      } catch (Exception ex) {
        ApiErrorHandler.setError(
          400,
          'Must Enter a valid Date format yyyy-mm-dd'
        );
        return;
      }
      if (String.isBlank(pwr.status)) {
        ApiErrorHandler.setError(400, 'Must Enter project status.');
        return;
      }
      if (String.isBlank(pwr.budget)) {
        ApiErrorHandler.setError(400, 'Must Enter Project Budget');
        return;
      }

      // project type and owner not required so not applying validations

      Project__c newProject = new Project__c(
        Start_Date__c = startDate,
        End_Date__c = endDate,
        Budget__c = Decimal.valueOf(pwr.budget),
        Status__c = pwr.status,
        Owner__c = pwr.owner,
        Project_Type__c = pwr.projectType
      );

      insert newProject;

      ApiResponseHandler.setResponse(201, newProject);
    } catch (DmlException dmlex) {
      ApiErrorHandler.setError(500, 'DML Error: ' + dmlex.getMessage());
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error: ' + ex.getMessage());
    }
  }

  public class ProjectWrapper {
    String startDate;
    String endDate;
    String budget;
    String status;
    String owner;
    String projectType;
  }
}

// better approach would be to make data type as string
// cast them using valueOf method and show error that its invalid format

// Because its a bad request nor internal error but we're returning 500
// TODO: do some research on it

/*
@RestResource(urlMapping='/projectp1')
global with sharing class CustomObjectApi {
  @HttpPost
  global static void call() {
    RestResponse res = RestContext.response;

    try {
      RestRequest req = RestContext.request;
      ProjectWrapper pwr = (ProjectWrapper) JSON.deserialize(
        req.requestBody.toString(),
        ProjectWrapper.class
      );

      if (String.isBlank(pwr.startDate)) {
        ApiErrorHandler.setError(400, 'Must Enter Start Date');
        return;
      }
      if (String.isBlank(pwr.endDate)) {
        ApiErrorHandler.setError(400, 'Must Enter End Date');
        return;
      }
      if (String.isBlank(pwr.budget)) {
        ApiErrorHandler.setError(400, 'Must Enter Project Budget');
        return;
      }

      Date startDate;
      Date endDate;
      Decimal budgetAmount;

      try {
        startDate = Date.valueOf(pwr.startDate);
        endDate = Date.valueOf(pwr.endDate);
        budgetAmount = Decimal.valueOf(pwr.budget);
      } catch (Exception e) {
        ApiErrorHandler.setError(400, 'Invalid Date or Budget format');
        return;
      }

      Project__c newProject = new Project__c(
        Start_Date__c = startDate,
        End_Date__c = endDate,
        Budget__c = budgetAmount,
        Status__c = pwr.status
      );

      insert newProject;

      res.statusCode = 201;
      res.responseBody = Blob.valueOf(JSON.serialize(newProject));
    } catch (DmlException dmlex) {
      ApiErrorHandler.setError(500, 'DML Error: ' + dmlex.getMessage());
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error: ' + ex.getMessage());
    }
  }

  public class ProjectWrapper {
    String startDate;
    String endDate;
    String budget;
    String status;
  }
}
*/

