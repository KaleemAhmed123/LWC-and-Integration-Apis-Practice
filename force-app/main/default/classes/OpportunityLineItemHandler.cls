public class OpportunityLineItemHandler {
  public static void countAllPrdoductForOpportunity(
    List<OpportunityLineItem> newList,
    List<OpportunityLineItem> oldList
  ) {
    Set<Id> accIds = new Set<Id>();
    if (newList != null) {
      for (OpportunityLineItem oli : newList) {
        if (oli.OpportunityId != null && oli.Opportunity.AccountId != null) {
          accIds.add(oli.Opportunity.AccountId);
        }
      }
    }
    if (oldList != null) {
      for (OpportunityLineItem oli : oldList) {
        if (oli.OpportunityId != null && oli.Opportunity.AccountId != null) {
          accIds.add(oli.Opportunity.AccountId);
        }
      }
    }

    List<Account> accList = [
      SELECT
        Id,
        Total_Related_Products__c,
        (
          SELECT Id, (SELECT Id FROM OpportunityLineItems)
          FROM Opportunities
        )
      FROM Account
      WHERE Id IN :accIds
    ];
    System.debug(accList);
    for (Account acc : accList) {
      for (Opportunity opp : acc.Opportunities) {
        acc.Total_Related_Products__c =
          acc.Total_Related_Products__c + opp.OpportunityLineItems.size();

        system.debug('Ran ot Not');
      }
    }

    update accList;
  }
}