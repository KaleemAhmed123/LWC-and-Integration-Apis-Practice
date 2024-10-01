public class soqlPractice {
  public static void demo() {
    List<Account> accList = [
      SELECT Name, id
      FROM Account
      WHERE Name LIKE '%Test%'
      ORDER BY LastModifiedDate
      LIMIT 10
    ];

    for (Account acc : accList) {
      System.debug('===> ' + acc.Name);
    }
  }
}

// last modified first max 10