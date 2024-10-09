@RestResource(urlMapping='/taskp1')
global with sharing class TaskCustomApi1 {
  @HttpPost
  global static void call() {
    try {
      RestRequest req = RestContext.request;
      TaskWrapper twr = (TaskWrapper) JSON.deserialize(
        req.requestBody.toString(),
        TaskWrapper.class
      );

      if (twr.status == null || twr.priority == null || twr.subject == null) {
        ApiErrorHandler.setError(
          400,
          'Must Enter status, priority and subject.'
        );
        return;
      }
      if (!ApiFieldValidation.isValidId(twr.LeadId, '00Q')) {
        ApiErrorHandler.setError(400, 'Must Enter a valid Lead Id.');
        return;
      }

      Task newTask = new Task(
        Subject = twr.subject,
        Priority = twr.priority,
        Status = twr.status,
        WhoId = twr.LeadId
      );
      insert newTask;
      ApiResponseHandler.setResponse(201, newTask);
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Errror' + ex.getMessage());
    }
  }

  public class TaskWrapper {
    public String subject;
    public String priority;
    public String status;
    public String LeadId;
  }
}

// subject, priority, status and assigned to

