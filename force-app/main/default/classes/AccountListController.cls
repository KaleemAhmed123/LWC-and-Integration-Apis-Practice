public class AccountListController {
    // public List<Integer> pageSizeOptions { get;set; }
    public Integer pageSize { get; set; }
    public String currAlphabet { get; set; }
    public List<Account> accounts { get; set; }
    public List<String> alphabetList { get; set; }

    public AccountListController() {
        // pageSizeOptions = new List<Integer> {1,2,3,4,5,10};
        alphabetList = new List<String> {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
        // pageSize = 1; 
        // currAlphabet = 'a';
        initialLoad();
    }
    
    public PageReference initialLoad() {
		accounts = [SELECT Id, Name, Owner.Name, Owner.Profile.Name FROM Account];
        return null;
    }

    public PageReference refreshAcc() {
        // that option string will be casted in Integer while calling the controller
        String wildAdded = currAlphabet + '%';
        accounts = [SELECT Id, Name, Owner.Name, Owner.Profile.Name FROM Account WHERE Name LIKE :wildAdded LIMIT :pageSize];
        return Null;
    }
}