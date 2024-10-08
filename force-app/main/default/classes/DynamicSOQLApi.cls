@RestResource(urlMapping='/dynamic/*')
global class DynamicSOQLApi {
  @HttpGet
  global static List<sObject> call() {
    try {
      String objName = RestContext.request.requestURI.substringAfterLast('/');
      Map<String, String> queryParams = RestContext.request.params;
      if (queryParams.size() == 0) {
        String query = 'SELECT Id FROM ' + objName + ' LIMIT 10';
        return Database.query(query);
      }

      List<String> selectFields = new List<String>();
      List<String> conditions = new List<String>();
      for (String key : queryParams.keySet()) {
        selectFields.add(key);
        String value = queryParams.get(key);
        conditions.add(key + ' = \'' + String.escapeSingleQuotes(value) + '\'');
      }

      String query =
        'SELECT ' +
        String.join(selectFields, ', ') +
        ' FROM ' +
        objName;
      if (conditions.size() > 0) {
        query += ' WHERE ' + String.join(conditions, ' AND ');
      }

      system.debug('query is: ' + query);
      List<sObject> result = Database.query(query);
      return result;
    } catch (Exception e) {
      ApiErrorHandler.setError(500, 'Internal error' + e.getMessage());
    }
  }

  global class RestException extends Exception {
  }
}
