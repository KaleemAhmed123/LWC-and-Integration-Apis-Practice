// Get Account and Related Contacts: Write an Apex web service to fetch an Account record
// and all its related Contact records using the Account ID.
@RestResource(urlMapping='/accountc4')
global class accountc4 {
    @HttpGet
    global static void getAccountWithContacts() {
        String Id = RestContext.request.params.get('Id');
        
        if(Id == null || Id == '') {
			ApiErrorHandler.setError(400, 'Please Provide Acount Id'); 
            return;
        }
        if(!Id.StartsWith('001') || Id.length() < 18) {
            ApiErrorHandler.setError(400, 'Account Id starts with 001 and length should be 18');
            return;
        }
        
        
        Account acc;
        try {            
            acc = [SELECT Name, Id, (SELECT LastName, FirstName FROM Contacts) FROM Account WHERE Id = :Id];
            RestResponse res = RestContext.response;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(acc));
        }  catch(Exception e) {
            ApiErrorHandler.setError(500, 'Internal Error');
        }
    }
    global class RestException extends Exception{}
}