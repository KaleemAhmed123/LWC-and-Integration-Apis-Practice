global with sharing class ApiFieldValidation {
  public static Boolean isValidId(String Id, String pref) {
    if (String.isBlank(Id)) {
      return false;
    }
    if (!Id.startsWith(pref) || (Id.length() != 15 && Id.length() != 18)) {
      return false;
    }
    return true;
  }
  public static Boolean isValidEmail(String email) {
    if (String.isBlank(email))
      return false;
    String emailRegex = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';
    return Pattern.matches(emailRegex, email);
  }
}

// classic  ==> 001dM00001kua5t
// Lightning => 001dM00001kua5tQAA

// last three optional

