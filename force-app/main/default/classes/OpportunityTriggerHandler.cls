public class OpportunityTriggerHandler {
  public static void updateCountAndSum(
    List<Opportunity> currList,
    List<Opportunity> oldList,
    Map<Id, Opportunity> oldMap
  ) {
    Set<Id> accIds = new Set<Id>();
    // insert case
    if (currList != null) {
      for (Opportunity opp : currList) {
        // update case
        if (opp.AccountId != null && opp.Amount != oldMap?.get(opp.id)?.Amount)
          accIds.add(opp.AccountId);
        // insert case
        else if (opp.AccountId != null && opp.Amount != null)
          accIds.add(opp.AccountId);
      }
    }
    // delete case
    if (oldList != null) {
      for (Opportunity opp : oldList) {
        if (opp.AccountId != null && opp.Amount != null)
          accIds.add(opp.AccountId);
      }
    }

    List<Account> accList = [
      SELECT
        Id,
        Related_Opportunity__c,
        Total_Amount_of_Opportunities__c,
        Average_Opportunity_Amount__c,
        (SELECT Id, Amount, Name FROM Opportunities)
      FROM Account
      WHERE Id IN :accIds
    ];

    for (Account acc : accList) {
      Decimal sum = 0, avg = 0, count = acc.Opportunities.size();
      for (Opportunity opp : acc.Opportunities) {
        System.debug(opp.Name);
        if (opp.Amount != null)
          sum += (opp.Amount);
      }

      acc.Total_Amount_of_Opportunities__c = sum;
      acc.Average_Opportunity_Amount__c = sum / count;
      acc.Related_Opportunity__c = count;

      system.debug(acc.Related_Opportunity__c);
    }
    // system.debug(accList);

    if (accList.size() > 0)
      update accList;
  }

  /*  private static String getLimitsMessage() {
     * 
     * 		Limits.getLimitCpuTime() and similarly other for getting the max limit you can use
     * 
            String message = 'CPU time: ' + Limits.getCpuTime();
            message += '\nDML statements: ' + Limits.getDmlStatements();
            message += '\nDML rows: ' + Limits.getDmlRows();
            message += '\nSOQL queries: ' + Limits.getQueries();
            message += '\nSOQL query rows: ' + Limits.getQueryRows();
            return message;
    	}

	*/

  public static void insertRelatedProduct(List<Opportunity> oppList) {
    System.debug('I am running');

    List<Product2> prodList = new List<Product2>();
    List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();

    Pricebook2 prb = [
      SELECT Id
      FROM Pricebook2
      WHERE Name = 'For Custom Product'
    ];

    Pricebook2 standardPricebook = [
      SELECT Id
      FROM Pricebook2
      WHERE IsStandard = TRUE
      LIMIT 1
    ];

    for (Opportunity opp : oppList) {
      Product2 pr = new Product2(Name = opp.Name, IsActive = true);
      prodList.add(pr);
    }

    if (!prodList.isEmpty()) {
      insert prodList;
    }

    List<PricebookEntry> stdPbeList = new List<PricebookEntry>(); // for every product
    // creating std pbentry for each prod
    for (Product2 pr : prodList) {
      PricebookEntry standardPbe = new PricebookEntry(
        Pricebook2Id = standardPricebook.Id, // standard wali hai custom ka nahi pata
        Product2Id = pr.Id,
        UnitPrice = 100,
        IsActive = true
      );
      stdPbeList.add(standardPbe);
    }

    if (!stdPbeList.isEmpty()) {
      insert stdPbeList;
    }

    // creating my Custom pbEntry records
    List<PricebookEntry> customPbeList = new List<PricebookEntry>();
    for (Product2 pr : prodList) {
      PricebookEntry customPbe = new PricebookEntry(
        Pricebook2Id = prb.Id,
        Product2Id = pr.Id,
        UnitPrice = 150,
        IsActive = true
      );
      customPbeList.add(customPbe);
    }

    if (!customPbeList.isEmpty()) {
      insert customPbeList;
    }

    List<Opportunity> newOppList = new List<Opportunity>();
    for (Opportunity opp : oppList) {
      // clone(preserveId, isDeepClone, preserveReadonlyTimestamps, preserveAutonumber)
      Opportunity temp = opp.clone(true, true, true, true);
      Opportunity temp2 = opp; // or add all give same reference
      system.debug('==> Same Reference ' + (opp === temp ? 'Yes' : 'No'));
      system.debug('==> Same Reference ' + (opp === temp2 ? 'Yes' : 'No'));

      temp.Pricebook2Id = prb.Id;
      newOppList.add(temp);
    }

    // update hi hoga same ref hai
    update newOppList;
    // ordered hai so it is accessible
    for (Integer i = 0; i < oppList.size(); i++) {
      OpportunityLineItem oli = new OpportunityLineItem(
        OpportunityId = oppList[i].Id,
        PricebookEntryId = customPbeList[i].Id,
        Quantity = 1,
        UnitPrice = customPbeList[i].UnitPrice,
        // ListPrice = customPbeList[i].UnitPrice,
        ServiceDate = System.Today()
      );
      oliList.add(oli);
    }

    if (!oliList.isEmpty()) {
      insert oliList;
    }

    System.debug('==> Pahuch Gye Yaha Tak.............');
  }
}