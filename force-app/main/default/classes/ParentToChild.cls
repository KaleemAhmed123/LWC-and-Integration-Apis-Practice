public class ParentToChild {
	public void practice() {
        
        List<Account> acc = [SELECT Name, Tier__c, 
                             (SELECT Name, Email, Title FROM Contacts WHERE Name LIKE '%Kaleem%' AND Title != NULL) 
                             FROM Account WHERE Name = 'Kaleem'];

        for(Account it: acc) {
            System.debug('Account Detail ==> ' + it);
            
            Integer counter = 0;
            if(!it.Contacts.isEmpty()) {
                for (Contact contact : it.Contacts) {
                    // System.debug('Contact ' + ( counter + 1));
                    System.debug('\nContact Name: ' + contact.Name + '\nContact Email: ' + contact.Email + '\nContact Title: ' + contact.Title);
                    counter++;
                }
            }
        }
        
    }
}