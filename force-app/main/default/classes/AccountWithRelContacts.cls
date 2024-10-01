public class AccountWithRelContacts {
    public static void first() {
        List<Account> AccList = [SELECT Name, (SELECT LastName FROM Contacts) FROM Account LIMIT 10];
        
        for(Account acc: AccList) {
            System.debug(acc.name);
            
            for(Contact con: acc.Contacts) {
                 System.debug(con.LastName);
            }
            // insert new Contact()
        }
    }
}