@RestResource(urlMapping='/taskp1')
global with sharing class TaskCustomApi1 {
  @HttpPost
  global static void call() {
    RestResponse res = RestContext.response;

    try {
      RestRequest req = RestContext.request;
      TaskWrapper twr = (TaskWrapper) JSON.deserialize(
        req.requestBody.toString(),
        TaskWrapper.class
      );

      if (twr.status == null || twr.priority == null || twr.subject == null) {
        ApiErrorHandler.setError(
          400,
          'Must Enter status, priority and subject'
        );
        return;
      }

      Task newTask = new Task(
        Subject = twr.subject,
        Priority = twr.priority,
        Status = twr.status
      );
      insert newTask;
      ApiResponseHandler.setResponse(201, newTask);
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Errror' + ex.getMessage());
    }
  }

  public class TaskWrapper {
    String subject;
    String priority;
    String status;
    // String assignedTo;
  }
}

// subject, priority, status and assigned to

