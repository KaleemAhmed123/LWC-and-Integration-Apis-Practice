public class DynamicRecordsController {
    public static Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    public static String obj;
    @AuraEnabled
    public static List<string> getObj(){
        List<String> objNames=new List<String>();
        
        for(String key : gd.keyset()){
            objNames.add(key);
        }
        objNames.sort();
        return objNames;
    }
    
    @AuraEnabled
    public static List<string> getFields(String objectName){
        obj=objectName;
        List<String> fields=new List<String>();
        Map<String, Schema.SObjectField> fieldMap = gd.get(objectName).getDescribe().fields.getMap();
        for(Schema.SObjectField fieldName : fieldMap.values() ) {
            fields.add(String.valueOf(fieldName));
            //fields.add(String.valueOf(fieldMap.get(fieldName))); 
            //system.debug('fieldName -->'+fieldName); // This will give you the api name of the field name.
           }
        return fields;
    }
    
    @AuraEnabled
    public static List<sObject> getRecords(String obj,List<string> fields,string limitVar,string key){
        string query='SELECT ' + String.join(fields,',') + ' FROM ' + obj + ' ORDER BY ' + key +' LIMIT ' +limitVar;
        system.debug(query);
        return database.query(query);
    }
}