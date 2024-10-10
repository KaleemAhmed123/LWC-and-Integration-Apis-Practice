@RestResource(urlMapping='/pagination')
global class pagination {
  @HttpGet
  global static void call() {
    String objName = RestContext.request.params.get('obj');
    String pageSize = RestContext.request.params.get('pagesize');
    String pageNumber = RestContext.request.params.get('pagenumber');
    Integer pageSizeInteger = Integer.valueOf(pageSize);
    Integer pageNumberInteger = Integer.valueOf(pageNumber);

    if (String.isBlank(objName)) {
      ApiErrorHandler.setError(400, 'Please provide an object');
      return;
    }
    if (String.isBlank(pageSize)) {
      ApiErrorHandler.setError(400, 'Please provide page size');
      return;
    }
    if (String.isBlank(pageNumber)) {
      ApiErrorHandler.setError(400, 'Please provide page number');
      return;
    }

    String countQuery = 'SELECT COUNT() FROM ' + objName;
    Integer totalRecords = Integer.valueOf(Database.countQuery(countQuery));
    Integer maxPageNumber =
      (totalRecords + pageSizeInteger - 1) / pageSizeInteger;

    if (pageSizeInteger > totalRecords) {
      ApiErrorHandler.setError(400, 'Page size exceeds total records');
      return;
    }
    if (pageNumberInteger > maxPageNumber) {
      ApiErrorHandler.setError(400, 'Page number exceeds total pages');
      return;
    }

    Integer skip = (pageNumberInteger - 1) * pageSizeInteger;
    String query =
      'SELECT Id, Name FROM ' +
      objName +
      ' ORDER BY createdDate DESC' +
      ' LIMIT ' +
      pageSize +
      ' OFFSET ' +
      skip;

    List<sObject> records = Database.query(query);
    ApiResponseHandler.setResponse(200, records);
  }
  global class RestException extends Exception {
  }
}
