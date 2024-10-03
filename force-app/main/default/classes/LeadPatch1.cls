@RestResource(urlMapping='/leadpch1')
global with sharing class LeadPatch1 {
  @HttpPatch
  global static void updateLeadStatus() {
    RestResponse res = RestContext.response;

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

      List<Lead> updatedLeads = new List<Lead>();
      for (String leadId : leadWpd.Ids) {
        Lead updatedLead = new Lead(Id = leadId, Status = leadWpd.Status);
        updatedLeads.add(updatedLead);
      }

      update updatedLeads;

      res.statusCode = 202;
      res.responseBody = Blob.valueOf(
        JSON.serialize('Status updated on leads succesfully')
      );
    } catch (Exception ex) {
      ApiErrorHandler.setError(500, 'Internal Errorr' + ex.getMessage());
    }
  }

  public class LeadWrapper {
    List<String> Ids;
    String Status;
  }
}
