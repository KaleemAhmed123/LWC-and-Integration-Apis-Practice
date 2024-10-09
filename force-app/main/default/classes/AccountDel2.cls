@RestResource(urlMapping='/accountdel2')
global with sharing class AccountDel2 {
  @HttpDelete
  global static void deleteRec() {
    RestRequest req = RestContext.request;
    String id = req.params.get('Id');
    String cascade = req.params.get('cascade');
    String cascadeMessage = '';

    List<Account> delAcc = [SELECT Id, Name FROM Account WHERE Id = :Id];

    // 001dM00001vrRdSQA
    if (
      !String.isBlank(Id) && !Id.startsWith('001') ||
      (id.length() != 18 &&
      id.length() != 15)
    ) {
      ApiErrorHandler.setError(500, 'Invalid Account ID!');
      return;
    }
    try {
      Account acc = [
        SELECT id, name, (SELECT ID FROM Contacts)
        FROM Account
        WHERE Id = :id
        LIMIT 1
      ];
      if (cascade == 'off') {
        for (contact con : acc.contacts) {
          con.AccountId = null;
        }
        for (Opportunity opp : acc.Opportunities) {
          opp.AccountId = null;
        }
        update acc.contacts;
        update acc.Opportunities;
        cascadeMessage = 'Related records exist now standalone with no Parent Account.';
      }

      delete acc;

      // If we try to access the deleted record with the Id it does not return null
      // rather it throws error an query Exception Error
      // query error: "List has no rows for assignment to SObject"
      // Account acc2Queried = [SELECT Id FROM Account WHERE Id = :Id];

      /* if (acc2Queried == null) {
        ApiResponseHandler.setResponse(
          200,
          'Account With Id: ' + Id + ' Deleted Successfully. ' + cascadeMessage
        );
      }
      */
      if (delAcc.size() > 0) {
        ApiResponseHandler.setResponse(
          200,
          'Account With Id: ' + Id + ' Deleted Successfully. ' + cascadeMessage
        );
      } else {
        ApiErrorHandler.setError(500, 'Error in deleting account. ');
        return;
      }
    } catch (QueryException e) {
      ApiErrorHandler.setError(500, 'Query Error ' + e.getMessage());
    } catch (Exception e) {
      ApiErrorHandler.setError(500, 'Internal Error ' + e.getMessage());
    }
  }
}
