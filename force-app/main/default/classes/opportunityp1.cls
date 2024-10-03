@RestResource(urlMapping='/opportunityp1')
global with sharing class opportunityp1 {
  @HttpPost
  global static void createOpps() {
    RestResponse res = RestContext.response;
    try {
      RestRequest req = RestContext.request;

      List<OpportunityWrapper> oppWrapperList = (List<OpportunityWrapper>) JSON.deserialize(
        req.requestBody.toString(),
        List<OpportunityWrapper>.class
      );

      List<Opportunity> OpportunitiesToInsert = new List<Opportunity>();
      for (OpportunityWrapper oppwrapped : oppWrapperList) {
        if (
          oppwrapped.Name == null ||
          oppwrapped.CloseDate == null ||
          oppwrapped.StageName == null
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
          CloseDate = Date.valueOf(oppwrapped.CloseDate)
        );
        OpportunitiesToInsert.add(opp);
      }

      if (!OpportunitiesToInsert.isEmpty()) {
        insert OpportunitiesToInsert;
        res.statusCode = 201;
        res.responseBody = Blob.valueOf('Opportunities inserted succesfully');
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
    public String CloseDate;
  }
}
