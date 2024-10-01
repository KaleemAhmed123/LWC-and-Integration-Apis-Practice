public class AccountTriggerHandler {
    public static void insertOpportunityAndContact(List<Account> newList) {
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        system.debug(Trigger.old);
        system.debug(Trigger.new);
        
        
        for(Account acc: newList) {
            Contact newContact = new Contact(LastName = acc.Name, AccountId = acc.id);
            conList.add(newContact);
            Opportunity newOpportunity = new Opportunity(Name = acc.Name, StageName = 'New', CloseDate = System.today(), AccountId = acc.id);
            oppList.add(newOpportunity);
        }
        
                
        system.debug(conList);
        system.debug(oppList);
        
        insert conList;
        insert oppList;

    }
}