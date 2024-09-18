public with sharing class getAccountsForSelect {
  //  @AuraEnabled(cacheable=false)
  //   public static List<String> call() {
  //     AggregateResult[] results = [SELECT Name FROM Account GROUP BY Name];
  //     List<String> uniqueNames = new List<String>();
  //     for (AggregateResult result : results) {
  //         uniqueNames.add((String)result.get('Name'));
  //     }
  //     system.debug(uniqueNames);
  //     return uniqueNames;
  //  }
  @AuraEnabled(cacheable=true)
  public static List<Account> getUniqueAccount() {
    return [SELECT Name FROM Account];
  }

  @AuraEnabled(cacheable=false)
  public static List<Contact> getRelatedContacts(String accId) {
    return [
      SELECT
        LastName,
        FirstName,
        Phone,
        AccountId,
        Account.Name,
        Account.Owner.Name
      FROM Contact
      WHERE AccountId = :accId
    ];
  }
}
