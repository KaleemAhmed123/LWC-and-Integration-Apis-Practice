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
      Task newTask = new Task(
        Subject = twr.subject,
        Priority = twr.priority,
        Status = twr.status
      );
      insert newTask;

      res.statusCode = 201;
      res.responseBody = Blob.valueOf(JSON.serialize(newTask));
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

