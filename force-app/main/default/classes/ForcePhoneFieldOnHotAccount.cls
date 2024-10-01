public class ForcePhoneFieldOnHotAccount {
    public static void forcePhoneField(List<Account> newAccount, Map<Id, Account> oldMap) {
        for(Account acc: newAccount) {
            if(acc.Rating == 'Hot' && acc.Rating != oldMap?.get(acc.id).Rating && acc.Phone == NULL) {
                acc.addError('Must Enter Phone Field');
            }
        }
    }
}