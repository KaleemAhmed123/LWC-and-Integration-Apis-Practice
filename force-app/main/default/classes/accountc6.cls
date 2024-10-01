// Get Account and Related Contacts: Write an Apex web service to fetch an Account record
// and all its related Contact records using the Account ID.
@RestResource(urlMapping='/accountc6')
global class accountc6 {
    @HttpGet
    global static void getAccountWithContactsAndOpps() {
        String Id = RestContext.request.params.get('Id');
        if(Id == null || Id == '' ) {
            ApiErrorHandler.setError(400, 'Account Id is empty');
            return;
        }
        if(!Id.StartsWith('001') || Id.length() < 18) {
            ApiErrorHandler.setError(400, 'Account Id starts with 001 and length should be 18');
            return;
        }
      
        Account acc;
        try {
            acc = [SELECT Name, Website, Rating, Id,
                   	(SELECT LastName, FirstName, Email FROM Contacts),
                   		(SELECT Name, CloseDate, StageName, AccountId FROM Opportunities) 
                   			FROM Account WHERE Id = :Id];
            
            RestResponse res = RestContext.response;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(new AccountWrapper(acc)));
        }  catch(Exception e) {
            ApiErrorHandler.setError(500, 'Internal Error');
        }
    }
    
public class AccountWrapper {
    public String Name { get; set; }
    public String Website { get; set; }
    public String AccountId { get; set; }
    public List<ContactWrapper> Contacts { get; set; }
    public List<OpportunityWrapper> Opportunities { get; set; }

    public AccountWrapper(Account acc) {
        this.Name = acc.Name;
        this.Website = acc.Website;
        this.AccountId = acc.Id; 
        this.Contacts = new List<ContactWrapper>();
        this.Opportunities = new List<OpportunityWrapper>();
        for (Contact con : acc.Contacts) {
            this.Contacts.add(new ContactWrapper(con));
        }
        for (Opportunity opp : acc.Opportunities) {
            this.Opportunities.add(new OpportunityWrapper(opp));
        }
    }
}

public class ContactWrapper {
    public String LastName { get; set; }
    public String FirstName { get; set; }
    public String Email { get; set; }

    public ContactWrapper(Contact con) {
        this.LastName = con.LastName;
        this.FirstName = con.FirstName;
        this.Email = con.Email;
    }
}

public class OpportunityWrapper {
    public String Name { get; set; }
    public Date CloseDate { get; set; }
    public String StageName { get; set; }
    public String AccountId { get; set; }

    public OpportunityWrapper(Opportunity opp) {
        this.Name = opp.Name;
        this.CloseDate = opp.CloseDate;
        this.StageName = opp.StageName;
        this.AccountId = opp.AccountId;
    }
}

    
global class RestException extends Exception{}
}