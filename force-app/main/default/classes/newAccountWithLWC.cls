public with sharing class newAccountWithLWC {
    @AuraEnabled(cacheable=false)
    public static Account call(String name, String rating, String phone, String website, Date lastPurchaseDate, Boolean isIntel) {
        Account acc = new Account(
            Name = name,
            Phone = phone,
            Website = website,
            Rating = rating,
            Last_Purchase_Date__c = lastPurchaseDate,
            Is_Intel__c= isIntel

        );
        
        try {
            insert acc;
            System.debug('Successfulll..');
        } catch (DmlException e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Account creation failed: ' + e.getMessage());
        }
        
        return acc;
    }
}