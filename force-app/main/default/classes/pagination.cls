@RestResource(urlMapping='/pagination')
global class pagination {
	@HttpGet
    global static void call() {
        String objName = RestContext.request.params.get('obj');
        String pageSize = RestContext.request.params.get('pagesize');
        String pageNumber = RestContext.request.params.get('pagenumber');

        if(objName == null || objName == '') {
            ApiErrorHandler.setError(400, 'Please provide an object');
            return;
        }
        if(pageSize == null || pageSize == '') {
            ApiErrorHandler.setError(400, 'Please provide page size');
            return;
        }
        if(pageNumber == null || pageNumber == '') {
            ApiErrorHandler.setError(400, 'Please provide page number');
            return;
        }
        
        String countQuery = 'SELECT COUNT() FROM ' + objName;
        Integer totalRecords = Database.countQuery(countQuery);
        Integer maxPageNumber = (Integer.valueOf(totalRecords) + Integer.valueOf(pageSize) - 1) / Integer.valueOf(pageSize); 
        
        if (Integer.valueOf(pageSize) > totalRecords) {
            ApiErrorHandler.setError(400, 'Page size exceeds total records');
            return;
        }
        if (Integer.valueOf(pageNumber) > maxPageNumber) {
            ApiErrorHandler.setError(400, 'Page number exceeds total pages');
            return;
        }

        Integer skip = (Integer.valueOf(pageNumber) - 1)*Integer.valueOf(pageSize);
        String query = 'SELECT Id, Name FROM ' +  objName + ' ORDER BY createdDate DESC' + ' LIMIT ' + pageSize + ' OFFSET ' + skip;
        
        List<sObject> records = Database.query(query);
        RestResponse res = RestContext.response;
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serialize(records));
    }
	global class RestException extends Exception {}
}