public class ContactListController {
    @AuraEnabled
    public static List<Contact> getContactList(Id recordId) {
        List<Contact> contactList = [SELECT Id, FirstName, LastName, Email, Phone, AccountId 
                                     FROM Contact WHERE AccountId =:recordId];
        
        for(Contact c: contactList) {
            system.debug(c);
        }
        
        return contactList;
    }
}