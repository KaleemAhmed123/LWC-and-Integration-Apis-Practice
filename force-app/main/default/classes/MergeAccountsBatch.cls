public class MergeAccountsBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Name, Id FROM Account 
            ORDER BY Name ASC
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> acc) {
        if (acc.isEmpty()) return; 
	
        for (Integer i = 0; i < acc.size() - 1; i++) {
            if ( acc[i].Name == acc[i + 1].Name) {
                System.debug(acc[i]);
                // Database.merge(acc[i], acc[i + 1]);
            }
        }
        
        System.debug(' ==>  Execut..');
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(' ==>  Done..');
    }
}