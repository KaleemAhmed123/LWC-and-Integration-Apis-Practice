public class OpportunityLineItemHelper {
    public static void updateAccountProductCount(List<OpportunityLineItem> newLineItems, List<OpportunityLineItem> oldLineItems) {
        Set<Id> opportunityIds = new Set<Id>();

        if (newLineItems != null) {
            for (OpportunityLineItem oli : newLineItems) {
                opportunityIds.add(oli.OpportunityId);
            }
        }
        
        if (oldLineItems != null) {
            for (OpportunityLineItem oli : oldLineItems) {
                opportunityIds.add(oli.OpportunityId);
            }
        }

        Map<Id, Integer> opportunityProductCountMap = new Map<Id, Integer>();

        // Insert, Delete dono ko handle karne ke liye because neWList ya oldList par loop se ek miss hoga
        List<OpportunityLineItem> relatedLineItems = [SELECT Id, OpportunityId FROM OpportunityLineItem 
                                                      		WHERE OpportunityId IN :opportunityIds];
        
        for (OpportunityLineItem oli : relatedLineItems) {
            if (opportunityProductCountMap.containsKey(oli.OpportunityId)) {
                opportunityProductCountMap.put(oli.OpportunityId, opportunityProductCountMap.get(oli.OpportunityId) + 1);
            } else {
                opportunityProductCountMap.put(oli.OpportunityId, 1);
            }
        }

        // Map to store the sum of products for each Account
        Map<Id, Integer> accountProductCountMap = new Map<Id, Integer>();

        // Retrieve Opportunities with their parent Accounts
        List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity WHERE Id IN :opportunityIds];
        for (Opportunity opp : opportunities) {
            Integer productCount = opportunityProductCountMap.get(opp.Id) != null ? opportunityProductCountMap.get(opp.Id) : 0;
            if (accountProductCountMap.containsKey(opp.AccountId)) {
                accountProductCountMap.put(opp.AccountId, accountProductCountMap.get(opp.AccountId) + productCount);
            } else {
                accountProductCountMap.put(opp.AccountId, productCount);
            }
        }  

        // List to store Accounts to be updated
        List<Account> accountsToUpdate = new List<Account>();

        // Retrieve existing Accounts and update the product count
        for (Account acc : [SELECT Id, Total_Related_Products__c FROM Account WHERE Id IN :accountProductCountMap.keySet()]) {
            acc.Total_Related_Products__c = accountProductCountMap.get(acc.Id);
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}