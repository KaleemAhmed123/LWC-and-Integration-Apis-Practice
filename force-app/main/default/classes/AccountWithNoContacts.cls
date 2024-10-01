public class AccountWithNoContacts {
    public static void demo() {

        List<Account> accList = [SELECT Name FROM Account WHERE Id NOT IN 
                                 (SELECT AccountId FROM Contact)];
        
        // System.debug(accList);
        
        String Field = 'Name, Type ';
        String Pattern = '%test%';
        
        String Query = 'SELECT ' + Field + 'FROM Account WHERE Name LIKE: Pattern';
        
        System.debug(Database.Query(Query));
        String ans = 'Hello :Pattern';
        
        
    }
}