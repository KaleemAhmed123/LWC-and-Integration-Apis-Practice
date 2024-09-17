public with sharing class newRelatedContact {
    @AuraEnabled(cacheable=false)
    public static Contact call(String firstName, String lastName, String title,
                                     Date birthday, String email, String phone, 
                                    String leadSource, Boolean isDead, Id accountId ){
        Contact con;
        try {
            con = new Contact(AccountId = accountId, FirstName = firstName, LastName= lastName, 
                                Title = title, Birthdate = birthday, Email = email,
                                 Phone = phone, LeadSource = leadSource, Is_Dead__c = isDead);
            insert con;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return con;
    }
}