public with sharing class ThreeRecordAtOnceLWC {
  @AuraEnabled
  public static String call(
    String accName,
    String accPhone,
    String accDesc,
    String conFirstName,
    String conLastName,
    String conEmail,
    String oppName,
    String oppStage,
    Date oppCloseDate
  ) {
    Account acc = new Account(
      Name = accName,
      Phone = accPhone,
      Description = accDesc
    );
    insert acc;

    if (acc != null && acc.Id != null) {
      Contact con = new Contact(
        LastName = conLastName,
        FirstName = conFirstName,
        Email = conEmail,
        AccountId = acc.Id
      );

      Opportunity opp = new Opportunity(
        Name = oppName,
        StageName = oppStage,
        CloseDate = oppCloseDate,
        AccountId = acc.Id
      );

      try {
        insert con;
        insert opp;
      } catch (Exception e) {
        System.debug(
          'Error inserting Contact or Opportunity: ' + e.getMessage()
        );
      }
    } else {
      throw new AuraHandledException('Account creation failed.');
    }

    return acc.Id;
  }
}