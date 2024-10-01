public with sharing class queryAccount {
  @AuraEnabled
  public static List<Account> call(String query) {
    try {
      String wildAdded = '%' + query + '%';
      List<Account> accList = [
        SELECT Name, Phone, Rating, Website, AccountNumber
        FROM Account
        WHERE Name LIKE :wildAdded
      ];
      return accList;
    } catch (Exception e) {
      System.debug(e.getMessage());
      throw new AuraHandledException(e.getMessage());
    }
  }
}