public class CreateThreeRecord {
    @AuraEnabled
    public static Account createRecord(String accName, String accPhone, String conLastName, 
                                    String conFirstName, String conEmail, String oppName,
                                    Date oppCloseDate, String oppStageName) {

        Account acc = new Account(Name = accName, Phone = accPhone);
		Contact con = new Contact(LastName = conLastName, FirstName = conFirstName, Email = conEmail);
        Opportunity opp = new Opportunity(Name = oppName, CloseDate = oppCloseDate, StageName = oppStageName);

		system.debug(accPhone);
        try {
            insert acc;
            con.AccountId = acc.Id;
            opp.AccountId = acc.id;
            
            if(acc.Id != null) {
				insert con;
            	insert opp;                
            }
            
            // String targetIdToPass = String(acc.Id);
            acc = [SELECT Id, OwnerId FROM Account WHERE Id = :acc.Id];
            
            EmailNotificationService.sendEmail(new List<String>{con.Email});
            EmailNotificationService.sendNotification(new Set<String>{acc.OwnerId}, acc.Id);
            
        } catch (Exception e) {
            delete acc;
            system.debug('Rolling back account.');
        }



		
        System.debug('All records created successfully: Account, Contact, and Opportunity.');
		return acc;
    }
}