public class SetPractice {
    Public static void setInAccc() {
        
        List<Account> accList = [SELECT id, name FROM Account];
        List<Account> accList2 = new List<Account>();
        
        accList2.addAll(accList);
        
        // accList2.addAll(accList);   // this is also reference (weird)

        //Set<Account> st = new Set<Account>();
        
        for(Account it: accList) {
            it.name = it.name + 'dummmy';
			 System.debug('First Account ==>  '+it.name);

        } 
        System.debug('Next Accounts ==>  ');

        //for(Account it: st) {
        //    System.debug('Unique Account ==>  '+it);
        //} 
        for(Account it: accList2) {
            System.debug('Second Account ==>  '+it.name);
        }
        
    }
}