@RestResource(urlMapping='/leadpch1')
global with sharing class LeadPatch1 {
  @HttpPatch
  global static void updateLeadStatus() {
    RestRequest req = RestContext.request;
    try {
      LeadWrapper leadWpd = (LeadWrapper) JSON.deserialize(
        req.requestBody.toString(),
        LeadWrapper.class
      );

      if (String.isBlank(leadWpd.Status)) {
        ApiErrorHandler.setError(400, 'Please Enter New Status Value.');
        return;
      }
      if (leadWpd.Ids == null || leadWpd.Ids.size() == 0) {
        ApiErrorHandler.setError(400, 'Please Enter Some Ids.');
        return;
      }

      List<String> wrongIds = new List<String>();
      List<Lead> leadToBeUpdatedList = new List<Lead>();
      for (String leadId : leadWpd.Ids) {
        // apply individual validation here
        // show that this this id is wrong
        if (
          String.isBlank(leadId) ||
          !leadId.startsWith('00Q') ||
          leadId.length() < 18
        ) {
          wrongIds.add(leadId);
        } else {
          Lead leadToBeUpdated = new Lead(Id = leadId, Status = leadWpd.Status);
          leadToBeUpdatedList.add(leadToBeUpdated);
        }
      }

      update leadToBeUpdatedList;

      ApiResponseHandler.setResponse(
        202,
        'Lead Status Updated Successfully, following Ids are not valid: ' +
        wrongIds
      );
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Errorr' + ex.getMessage());
    }
  }

  public class LeadWrapper {
    public List<String> Ids;
    public String Status;
  }
}
