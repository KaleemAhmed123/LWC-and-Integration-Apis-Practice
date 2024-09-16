public with sharing class fetchTopTenContacts {
    @AuraEnabled(cacheable=true)
    public static List<Contact> call() {
        return [SELECT LastName, FirstName, Email, Phone FROM Contact ORDER BY createdDate LIMIT 10];
    }
}