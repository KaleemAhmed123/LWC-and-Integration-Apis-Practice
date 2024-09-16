public with sharing class contactRecordsWithFilters {
    @AuraEnabled(cacheable=true)
    public static List<Contact> call(String firstName, String lastName, String email, Integer numOfRecords) {
        String lastNameWildAdded = lastName != null ? lastName + '%' : '%';
        String firstNameWildAdded = firstName != null ? firstName + '%' : '%';
        String emailWildAdded = email != null ? email + '%' : '%';
        Integer recordsToQuery = numOfRecords != null ? numOfRecords : 10;

        String query = 'SELECT LastName, FirstName, Email FROM Contact WHERE LastName LIKE :lastNameWildAdded AND FirstName LIKE :firstNameWildAdded';
        
        if (emailWildAdded != null) 
            query += ' AND Email LIKE :emailWildAdded';
        
        query += ' LIMIT :recordsToQuery';
        // if(query.contains('LIMIT'))
        //     throw new DmlException('An error occurred while processing the request.');
        return Database.query(query);
    }
}
