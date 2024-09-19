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
    // Create Account
    Account acc = new Account(
      Name = accName,
      Phone = accPhone,
      Description = accDesc
    );
    insert acc;

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

    // isse flow nahi rukna so try catch
    try {
      insert con;
      insert opp;
    } catch (Exception e) {
      // throw new AuraHandledException('Error  : ' + e.getMessage());
      system.debug('Only account got created');
    }

    return acc.Id;
  }
}
