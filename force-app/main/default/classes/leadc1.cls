// Retrieve All Leads Created in the Last 7 Days:
// Create a web service that fetches all Lead records created in the last 7 days.
@RestResource(urlMapping='/lastweekLeads')
global class leadc1 {
  @HttpGet
  global static void getLastWeekLeads() {
    Date lastWeekDate = System.today() - 7;
    try {
      List<Lead> leadList = [
        SELECT Name, Company, Title
        FROM Lead
        WHERE createdDate >= :lastWeekDate
        ORDER BY createdDate DESC
      ];
      RestResponse res = RestContext.response;
      ApiResponseHandler.setResponse(200, leadList);
    } catch (Exception e) {
      ApiErrorHandler.setError(500, 'Internal Error');
    }
  }
  global class RestException extends Exception {
  }
}
