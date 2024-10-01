public class ContactTriggerHandler {
  public static void preventDuplicateEmail(
    List<Contact> newConList,
    List<Contact> oldConList,
    Map<Id, Contact> newMap,
    Map<Id, Contact> oldMap
  ) {
      
      
    Set<Id> parentIds = new Set<Id>();
    for (Contact con : newConList) {
      if (con.AccountId != null) {
        parentIds.add(con.AccountId);
      }
    }

    List<Contact> conList = [
      SELECT Id, AccountId, Email
      FROM Contact
      WHERE AccountId IN :parentIds
    ];
      
      
      // [123, 234, ()]

      // {id: <abc@gmail.com, xyz@gmail.com>}
    Map<Id, Set<String>> accToContact = new Map<Id, Set<String>>();

    for (Contact con : conList) {
      if (!accToContact.containsKey(con.AccountId)) {
        accToContact.put(con.AccountId, new Set<String>());
      }
      if (con.Email != null) {
        accToContact.get(con.AccountId).add(con.Email);
      }
    }

    // newList me new dups possible hai
    for (Contact con : newConList) {
      if (
        con.Email != null &&
        accToContact.get(con.AccountId) != null &&
        con.Email != oldMap?.get(con.Id).Email &&
        accToContact.get(con.AccountId).contains(con.Email)
      ) {
        con.addError('Duplicate Email Not Allowed In Same Parent Account.');
      } else {
        accToContact.get(con.AccountId).add(con.Email);
      }
    }
  }

  public static void updateIsIntel(
    List<Contact> newConList,
    List<Contact> oldConList,
    Map<Id, Contact> newMap,
    Map<Id, Contact> oldMap
  ) {
    Set<Id> accIds = new Set<Id>();
    for (Contact con : newConList) {
      if (con.AccountId != null)
        accIds.add(con.AccountId);
    }

    List<Account> accList = [
      SELECT Id, Is_Intel__c, (SELECT Is_Dead__c FROM Contacts)
      FROM Account
      WHERE Id IN :accIds
    ];

    for (Account acc : accList) {
      Decimal isDeadCounter = 0, size = acc.Contacts.size();
      for (Contact con : acc.Contacts) {
        if (con.Is_Dead__c == true)
          isDeadCounter++;
      }
      System.debug(isDeadCounter);

      if (isDeadCounter / size > 0.75)
        acc.Is_Intel__c = true;
    }

    if (!accList.isEmpty())
      update accList;
  }

  public static void updateCountInParent(
    List<Contact> newConList,
    List<Contact> oldConList,
    Map<Id, Contact> newMap,
    Map<Id, Contact> oldMap
  ) {
    Set<Id> accIds = new Set<Id>();
    // need to write a lot of condition
    // just run two loop and add both if AccountId isn't NULL;
    /*for(Contact con: conList) {
            if(oldMap == NULL && con.AccountId != NULL)
            	accIds.add(con.AccountId);
            Id oldId = oldMap.get(con.id).AccountId;
            if(con.AccountId != oldId) {
                if(con.AccountId != NULL)
                	accIds.add(con.AccountId);
                if(oldId != NULL)
                	accIds.add(oldId);
            }   
        }*/

    if (newConList != null) {
      for (Contact con : newConList) {
        if (con.AccountId != null)
          accIds.add(con.AccountId);
      }
    }
    if (oldConList != null) {
      for (Contact con : oldConList) {
        if (con.AccountId != null)
          accIds.add(con.AccountId);
      }
    }

    List<Account> accList = [
      SELECT Id, Related_Contacts__c, (SELECT Id FROM Contacts)
      FROM Account
      WHERE Id IN :accIds
    ];
    for (Account acc : accList) {
      acc.Related_Contacts__c = acc.Contacts.size();
    }

    update accList;
  }
}