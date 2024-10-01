public with sharing class AccountLwcController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getLatestAccounts() {
        List<Account> accList = new List<Account>();
        try {
            accList = [SELECT Id, Name, Owner.Name, Type, Phone FROM Account
                        ORDER BY CreatedDate DESC LIMIT 10];
        } catch (Exception e) {
            system.debug(e.getMessage());
        } 
        return accList;
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getQueriesAccount(String query) {
        String wildAdded = '%' + query + '%';
        List<Account> accList = new List<Account>();
        try {
            accList = [SELECT Id, Name, Industry, Phone FROM Account 
                            WHERE Name LIKE :wildAdded];
        } catch (Exception e) {
            system.debug(e.getMessage());
        } 
        return accList;
    }
}