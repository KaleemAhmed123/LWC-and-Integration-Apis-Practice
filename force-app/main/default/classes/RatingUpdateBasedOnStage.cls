public class RatingUpdateBasedOnStage {
  public static void updateAccountRating(
    List<Opportunity> oppList,
    Map<Id, Opportunity> oldMap
  ) {
    Set<Id> accIds = new Set<Id>();
    for (Opportunity opp : oppList) {
      // new jo insert hue h
      if (oldMap == null && opp.AccountId != null)
        accIds.add(opp.AccountId);
      // jinke stageName Update hue h 'Closed Won'
      else if (
        opp.StageName != oldMap?.get(opp.id).StageName &&
        opp.StageName == 'Closed Won'
      )
        accIds.add(opp.AccountId);
    }

    List<Account> accList = [
      SELECT Rating, (SELECT Id, StageName FROM Opportunities)
      FROM Account
      WHERE Id IN :accIds
    ];

    for (Account acc : accList) {
      acc.Rating = 'Cold';
      for (Opportunity opp : acc.Opportunities) {
        if (opp.StageName == 'Closed Won')
          acc.Rating = 'Hot';
      }
    }

    update accList;
  }
}