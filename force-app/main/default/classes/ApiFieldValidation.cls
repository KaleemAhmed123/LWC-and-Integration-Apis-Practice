global with sharing class ApiFieldValidation {
  public static Boolean isValidId(String Id, String pref) {
    if (String.isBlank(Id)) {
      return false;
    }
    if (!Id.startsWith(pref) || (Id.length() != 18 && Id.length() != 15)) {
      return false;
    }
    return true;
  }
}
