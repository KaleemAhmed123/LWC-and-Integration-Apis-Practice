@RestResource(urlMapping='/opportunitypch1')
global with sharing class OpportunityPch1 {
  @HttpPatch
  global static void updateStageName() {
    RestResponse res = RestContext.response;

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
      if (
        String.isBlank(oppWpd.Id) ||
        !oppWpd.Id.startsWith('006') ||
        oppWpd.Id.length() < 18
      ) {
        ApiErrorHandler.setError(400, 'Provide valid opportunity Id plz');
        return;
      }

      Opportunity updateOpp = new Opportunity(
        Id = oppWpd.Id,
        StageName = oppWpd.StageName
      );
      update updateOpp;

      res.statusCode = 202;
      res.responseBody = Blob.valueOf(JSON.serialize(updateOpp));
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Error' + ex.getMessage());
    }
  }

  public class oppWrapper {
    String StageName;
    String Id;
  }
}
