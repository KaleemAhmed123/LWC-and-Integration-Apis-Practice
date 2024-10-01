public class VendorOpportunityValidationHandler {    
    public static void oneVendorRequired(List<Opportunity> newList) {
        Set<Id> oppIds = new Set<Id>();
        for(Opportunity opp: newList) 
            oppIds.add(opp.Id);
        
        // TODO: Use oldmap to deal with the same value stuff and avoid trigger
        
        Map<Id, Integer> mp = new Map<Id, Integer>();        
        List<Vendor__c> vList = [SELECT Id, Opportunity__c FROM Vendor__c WHERE Opportunity__c IN :oppIds];
        
        // case jab ek bhi vendor na ho (single case)
        if(vList.size() == 0) {
            for(Opportunity opp: newList) {
                if(opp.StageName != 'Prospecting' && opp.StageName != 'Qualification')
                    opp.addError('One Vendor is required.');
            }
        }
        
        for(Vendor__c it: vList) {
            if(mp.containsKey(it.Opportunity__c)) {
                mp.put(it.Opportunity__c, mp.get(it.Opportunity__c) + 1);
            } else {
                mp.put(it.Opportunity__c, 1);
            }
        }
        
        for(Opportunity opp: newList) {
            if(opp.StageName != 'Prospecting' && opp.StageName != 'Qualification' && mp.get(opp.id) == null) {
                opp.addError('One Vendor is required...');
            }
        }
        
        system.debug('Reached till here....');
    }
    
}