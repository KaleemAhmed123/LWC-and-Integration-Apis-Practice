public with sharing class contactRecordsWithFilters {
    @AuraEnabled(cacheable=true)
    public static List<Contact> call(String firstName, String lastName, String email, Integer numOfRecords) {
        String lastNameWildAdded = (lastName != null) ? lastName + '%' : '%';
        String firstNameWildAdded = (firstName != null) ? firstName + '%' : '%';
        String emailWildAdded = (email != null) ? email + '%' : '%';
        Integer recordsToQuery = numOfRecords != null ? numOfRecords : 10;

        String query = 'SELECT LastName, FirstName, Email FROM Contact';
        query += ' WHERE LastName LIKE :lastNameWildAdded';
        query += ' AND FirstName LIKE :firstNameWildAdded';
        query += ' AND Email LIKE :emailWildAdded';
        query += ' LIMIT :recordsToQuery';

        return Database.query(query);
    }
}
