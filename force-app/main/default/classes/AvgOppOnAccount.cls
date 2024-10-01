public class AvgOppOnAccount {
    public static void result() {
        // Account.Name cant be used here directly
        List<AggregateResult> oppList = [SELECT AVG(Amount) avgAmount , AccountId
                                          FROM Opportunity 
                                          GROUP BY AccountId 
                                          HAVING SUM(Amount) > 2000000];
        
        for (AggregateResult opp : oppList) {
            Decimal avgAmount = (Decimal) opp.get('avgAmount');
            System.debug(avgAmount);
        }
    }
}