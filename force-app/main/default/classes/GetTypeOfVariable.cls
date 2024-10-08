public with sharing class GetTypeOfVariable {
  public static String getTypeX(Object o) {
    if (o == null)
      return '';
    String result = 'Object'; // if we can't find out anything.

    if (o instanceof SObject)
      return ((SObject) o).getSObjectType().getDescribe().getName() + '';
    if (o instanceof Boolean)
      return 'Boolean';
    if (o instanceof Id)
      return 'Id';
    if (o instanceof String)
      return 'String';
    if (o instanceof Blob)
      return 'Blob';
    if (o instanceof Date)
      return 'Date';
    if (o instanceof Datetime)
      return 'Datetime';
    if (o instanceof Time)
      return 'Time';
    if (o instanceof Integer)
      return 'Integer';
    if (o instanceof Long)
      return 'Long';
    if (o instanceof Decimal)
      return 'Decimal';
    if (o instanceof Double)
      return 'Double';
    if (o instanceof List<object>)
      return 'List';
    try {
      // crazy but powerful workaround based on the answer of Arpi Jakab (20217-04-17) on SFSE ==>
      //  https://salesforce.stackexchange.com/questions/48019/how-to-get-the-runtime-type-of-an-object-dynamically-for-primitive-data-types-a
      Name a = (Name) o; // INTENTIONALLY force runtime exception like: "Invalid conversion from runtime type Map<Id,List<Account>> to Name"
    } catch (Exception e) {
      result = e.getMessage()
        .substringAfter('from runtime type ')
        .substringBefore(' ');
    }

    return result;
  }
}
