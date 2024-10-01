public class ObjectFieldController {
    // List to hold the picklist options
    public List<SelectOption> getObjectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Account', 'Account'));
        options.add(new SelectOption('Contact', 'Contact'));
        options.add(new SelectOption('Opportunity', 'Opportunity'));
        options.add(new SelectOption('Case', 'Case'));
        options.add(new SelectOption('Lead', 'Lead'));
        options.add(new SelectOption('Task', 'Task'));
        return options;
    }

    // The selected object
    public String selectedObject { get; set; }

    // List to hold the fields of the selected object
    public List<String> fields { get; set; }

    // Method to fetch fields based on the selected object
    public void fetchFields() {
        if (String.isNotBlank(selectedObject)) {
            fields = new List<String>();
            Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(selectedObject).getDescribe();
            
            // Corrected loop to fetch field names
            for (Schema.SObjectField field : describeResult.fields.getMap().values()) {
                fields.add(field.getDescribe().getName());
            }
        }
    }
}