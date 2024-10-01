// Retrieve a Single Account Record:
//  Write an Apex web service to get an Account record based on a given Account ID.
@RestResource(urlMapping='/accountc2/*')
global class SingleAccount {
    @HttpGet
    global static Account getAccByID() {
        Account acc;
        String accountId = RestContext.request.requestURI.substringAfterLast('/');
        
        try {
            acc = [SELECT Name, Id, Website, Type FROM Account Where Id = :accountId];
        } catch (Exception e) {
            throw new RestException('Error ' + e.getMessage());
        }
        
        return acc;
    }
    global class RestException extends Exception{}
}