public class SumOfRelOppForAnAccount {
    public static void demo() {
        List<AggregateResult> agr = [SELECT AccountId, Sum(Amount) totalAmount FROM 
                                     Opportunity WHERE Amount != NULL GROUP BY AccountId HAVING SUM(Amount) > 20000000];
        
        
        //for(AggregateResult it: agr) {
        //    System.debug((Integer) it.get('totalAmount') +  (String) it.get('AccountId'));
       // }
       // 
       Map<Id, Decimal> mp = new Map<Id, Decimal>();
        for(AggregateResult it: agr) {
            mp.put((Id)it.get('AccountId'), (Decimal)it.get('totalAmount'));
        }
        
        List<Account> acList = [SELECT Name FROM Account WHERE Id IN :mp.keySet()];
        
        for(Account acc: acList) {
            System.Debug(acc.name + ' ' + mp.get(acc.id));

        }
        
    }
}