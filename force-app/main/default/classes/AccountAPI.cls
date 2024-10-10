@RestResource(urlMapping='/accountc1')
global class AccountAPI {
	@HttpGet
    global static List<Account> getAccount() {
        List<Account> accList = new List<Account>();
        try{
            accList = [SELECT Name, Website, Type, Id FROM Account LIMIT 10];
        } catch(Exception e) {
            ApiErrorHandler.setError(500, 'Something went wrong.');
            return;
        }
        
        return accList;
    }
    global class RestException extends Exception{}
}