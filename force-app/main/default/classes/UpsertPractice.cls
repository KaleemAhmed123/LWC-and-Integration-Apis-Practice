public class UpsertPractice {
  public static void Practice() {
    List<Account> accList = [SELECT id, name FROM Account LIMIT 10];

    for (Account it : accList) {
      it.name += 'Dummy';
    }

    Account acc1 = new Account();

    acc1.name = 'Kaleem Ahmed';
    acc1.id = '001dM00000HuQ2sQBX';
    Account acc2 = new Account();
    acc2.name = 'Kaleem Ahmed';
    acc2.id = '001dM00000HuQ2sQBX';

    accList.add(acc1);
    accList.add(acc2);

    upsert accList;
    System.debug('Succesfull');

    for (Account it : accList) {
      System.debug(it.name);
    }
    System.debug(accList.size());
  }
}