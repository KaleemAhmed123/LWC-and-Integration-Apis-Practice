@RestResource(urlMapping='/accountc1')
global class AccountAPI {
	@HttpGet
    global static List<Account> getAccount() {
        List<Account> accList = new List<Account>();
        try{
            accList = [SELECT Name, Id FROM Account LIMIT 10];
        } catch(Exception e) {
            system.debug('Error');
            throw new RestException('Error ' + e.getMessage());
        }
        
        return accList;
    }
    global class RestException extends Exception{}
}