public class getQueriesAccount {
    @AuraEnabled
    public static List<Account> getAccounts(String searched) {
        string wildAdded = '%' + searched + '%';
        return [SELECT Id, Name, Type, Phone FROM Account WHERE Name Like :wildAdded];
    }
}