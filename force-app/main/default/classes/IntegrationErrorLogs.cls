global class IntegrationErrorLogs {
  public static String logError(
    String status,
    String errorMessage,
    String source,
    Exception ex,
    String recordId
  ) {
    Interation_logs__c logEntry = new Interation_logs__c();
    try {
      logEntry.Status__c = status;
      logEntry.Error_Message__c = errorMessage;
      logEntry.Source__c = source;
      logEntry.Record_Id__c = recordId;
      logEntry.Created_Date__c = System.now();
      logEntry.Stack_Trace__c = (ex != null) ? ex.getStackTraceString() : null;
      logEntry.Error_Type__c = classifyError(ex);
      logEntry.User__c = UserInfo.getUserId();
      logEntry.Resolved__c = false;
      insert logEntry;
    } catch (Exception e) {
      System.debug('Failed to create error log: ' + e.getMessage());
    }
    return logEntry.Id;
  }

  private static String classifyError(Exception ex) {
    if (ex instanceof DmlException) {
      return 'DML';
    } else if (ex instanceof NullPointerException) {
      return 'NullPointerException';
    } else if (ex instanceof QueryException) {
      return 'QueryException';
    } else if (ex instanceof CalloutException) {
      return 'Callout';
    } else {
      return 'Unknown';
    }
  }
}
