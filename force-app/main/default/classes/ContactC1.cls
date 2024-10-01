// Retrieve Contact by Email: Create an Apex web service that
//  retrieves a Contact record based on the provided email address.
@RestResource(urlMapping='/contactc1') 
global class ContactC1 {
    @HttpGet
    global static void getContacts() {
		String email = RestContext.request.params.get('email');
        if(email == null || email == '' || !isValidEmail(email)) {
			ApiErrorHandler.setError(400, 'No a Valid Email');
        }
        
        List<Contact> conList = new List<Contact>();
        try {
            conList = [SELECT LastName, FirstName, Email FROM Contact WHERE Email =:email];
            RestResponse res = RestContext.response;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(conList));
        } catch(Exception e) {
            ApiErrorHandler.setError(500, 'Internal Error');
        }
    }
    public static Boolean isValidEmail(String email) {
        String emailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$';
        return Pattern.matches(emailPattern, email);
    }
    global class RestException Extends Exception{}
}