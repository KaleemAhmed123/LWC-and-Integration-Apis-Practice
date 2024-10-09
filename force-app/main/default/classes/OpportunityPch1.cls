@RestResource(urlMapping='/opportunitypch1')
global with sharing class OpportunityPch1 {
  @HttpPatch
  global static void updateStageName() {
    try {
      RestRequest req = RestContext.request;
      oppWrapper oppWpd = (oppWrapper) JSON.deserialize(
        req.requestBody.toString(),
        oppWrapper.class
      );

      if (String.isBlank(oppWpd.StageName)) {
        ApiErrorHandler.setError(400, 'Provide StageName plz');
        return;
      }
      if (!ApiFieldValidation.isValidId(oppWpd.Id, '006')) {
        ApiErrorHandler.setError(400, 'Provide valid opportunity Id plz');
        return;
      }

      Opportunity opp = [
        SELECT Id, StageName
        FROM Opportunity
        WHERE Id = :oppWpd.Id
      ];
      opp.StageName = oppWpd.StageName;
      update opp;

      ApiResponseHandler.setResponse(202, opp);
    } catch (QueryException ex) {
      ApiErrorHandler.setError(
        400,
        'Query Error: May not be a valid record Id. ||' + ex.getMessage()
      );
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error' + ex.getMessage());
    }
  }

  public class oppWrapper {
    String StageName;
    String Id;
  }
}
