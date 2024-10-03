@RestResource(urlMapping='/opportunityp1')
global with sharing class opportunityp1 {
  @HttpPost
  global static void createOpps() {
    RestResponse res = RestContext.response;

    try {
      RestRequest req = RestContext.request;
      if (String.isBlank(req.requestBody.toString())) {
        ApiErrorHandler.setError(400, 'Body is empty');
        return;
      }
      List<OpportunityWrapper> oppWrapperList = (List<OpportunityWrapper>) JSON.deserialize(
        req.requestBody.toString(),
        List<OpportunityWrapper>.class
      );

      if (oppWrapperList == null || oppWrapperList.size() == 0) {
        ApiErrorHandler.setError(
          400,
          'Please enter one or more opportunities.'
        );
        return;
      }

      List<Opportunity> OpportunitiesToInsert = new List<Opportunity>();
      for (OpportunityWrapper oppwrapped : oppWrapperList) {
        if (
          String.isBlank(oppwrapped.Name) ||
          String.isBlank(oppwrapped.StageName) ||
          oppwrapped.CloseDate == null
        ) {
          ApiErrorHandler.setError(
            400,
            'Must Enter Name, CloseDate and StageName.'
          );
          return;
        }

        Opportunity opp = new Opportunity(
          Name = oppwrapped.name,
          StageName = oppwrapped.StageName,
          CloseDate = oppwrapped.CloseDate
        );
        OpportunitiesToInsert.add(opp);
      }

      if (!OpportunitiesToInsert.isEmpty()) {
        insert OpportunitiesToInsert;

        ApiResponseHandler.setResponse(
          201,
          'Opportunities inserted succesfully'
        );
      }
    } catch (DmlException dmlEx) {
      ApiErrorHandler.setError(500, 'DML Error : ' + dmlEx.getMessage());
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal error : ' + ex.getMessage());
    }
  }

  public class OpportunityWrapper {
    public String Name;
    public String StageName;
    public Date CloseDate;
  }
}
