public with sharing class ApiFieldValidation {
  private static Boolean isValidId(String Id, String pref) {
    if (String.isBlank(Id)) {
      return false;
    }
    if (!Id.startsWith(pref) || (Id.length() != 15 && Id.length() != 18)) {
      return false;
    }
    return true;
  }
  private static Boolean isValidEmail(String email) {
    if (String.isBlank(email))
      return false;
    String emailRegex = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';
    return Pattern.matches(emailRegex, email);
  }

  public static Boolean isValidPicklist(
    String objectName,
    String picklistFieldName,
    String value
  ) {
    if (String.isBlank(value)) {
      return false;
    }

    Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
    if (sObjectType == null) {
      return false;
    }

    Map<String, Schema.SObjectField> fieldMap = sObjectType
      ?.getDescribe()
      .fields.getMap();
    if (!fieldMap?.containsKey(picklistFieldName)) {
      return false;
    }

    Schema.DescribeFieldResult fieldResult = fieldMap
      ?.get(picklistFieldName)
      ?.getDescribe();

    List<Schema.PicklistEntry> picklistValues = fieldResult
      ?.getPicklistValues();
    for (Schema.PicklistEntry entry : picklistValues) {
      if (entry?.getValue()?.equals(value)) {
        return true;
      }
    }

    return false;
  }
}

// classic  ==> 001dM00001kua5t
// Lightning => 001dM00001kua5tQAA

// last three optional

