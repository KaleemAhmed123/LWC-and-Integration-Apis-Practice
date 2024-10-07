public class DeleteChildRecordClass {
  public static void deleteChildRecords(
    String parentId,
    String parentObjectName
  ) {
    try {
      Schema.SObjectType parentObjType = Schema.getGlobalDescribe()
        .get(parentObjectName);
      Schema.DescribeSObjectResult parentObjDescribe = parentObjType.getDescribe();

      List<Schema.ChildRelationship> childRelationships = parentObjDescribe.getChildRelationships();

      List<SObject> allChildRecordsToDelete = new List<SObject>();

      for (Schema.ChildRelationship childRel : childRelationships) {
        String childObjectName = String.valueOf(childRel.getChildSObject());

        if (
          childRel.getField() != null &&
          !childRel.getField().getDescribe().isCustom()
        ) {
          String childField = childRel.getField().getDescribe().getName();

          String query =
            'SELECT Id FROM ' +
            childObjectName +
            ' WHERE ' +
            childField +
            ' = :parentId';
          List<SObject> childRecords = Database.query(query);

          if (!childRecords.isEmpty()) {
            allChildRecordsToDelete.addAll(childRecords);
          }
        }
      }

      if (!allChildRecordsToDelete.isEmpty()) {
        delete allChildRecordsToDelete;
        System.debug(
          'Deleted ' + allChildRecordsToDelete.size() + ' child records.'
        );
      } else {
        System.debug('No child records found.');
      }
    } catch (Exception ex) {
      System.debug('Error deleting child records: ' + ex.getMessage());
    }
  }
}
