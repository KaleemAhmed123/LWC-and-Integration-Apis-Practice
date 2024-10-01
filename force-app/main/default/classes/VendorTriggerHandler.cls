public class VendorTriggerHandler {
    
    public static void populateVendor_NameToStandardName(List<Vendor__c> newList) {
        for(Vendor__c vnd: newList) {
            // Still gettting the error
            vnd.Name = vnd.Vendor_Name__c;
        }
    }
    
    public static void sameNameNotAllowed(List<Vendor__c> newList) {
        Set<Id> oppIds = new Set<Id>();
        for(Vendor__c vnd: newList) 
            oppIds.add(vnd.Opportunity__c);
        
        Map<Id, Set<String>> mp = new Map<Id, Set<String>>();        
        List<Vendor__c> vList = [SELECT Id, Opportunity__c, Vendor_Name__c FROM Vendor__c WHERE Opportunity__c IN :oppIds];
        
        if(vList.isEmpty())
            return;
        
        for(Vendor__c it: vList) {
            if(mp.containsKey(it.Opportunity__c)) {
                mp.get(it.Opportunity__c).add(it.Vendor_Name__c);
            } else {
                mp.put(it.Opportunity__c, new Set<String>{it.Vendor_Name__c});
            }
        }
        
        for(Vendor__c vnd: newList) {
            if(mp.get(vnd.Opportunity__c).contains(vnd.Vendor_Name__c)) {
                vnd.adderror('Vendor with the same name not allowed..');
            }
        }
        
        
        
        
        system.debug('Reached till here....');
    }
    
    public static void preventLastVendorDeletioon(List<Vendor__c> oldList) {
        Set<Id> oppIds = new Set<Id>();
        Map<Id, Boolean> mp = new Map<Id, Boolean>();
        for(Vendor__c it: oldList)
            oppIds.add(it.Opportunity__c);
        
		List<Opportunity> parentWithSiblings = [SELECT Id, StageName, (SELECT Id FROM Vendors__r) FROM Opportunity WHERE Id IN: oppIds];
        for(Opportunity opp: parentWithSiblings) {
            if(opp.Vendors__r.size() == 1 && opp.stageName != 'Prospecting' && opp.stageName != 'Qualification') {
                mp.put(opp.Id, true);
            } else {
                mp.put(opp.Id, false);
            }
        }
        
        for(Vendor__c it: oldList) {
            if(mp.get(it.Opportunity__c)) {
                it.addError('You can\'t delete last vendor on this Stage.');
            }
        }
    }
}