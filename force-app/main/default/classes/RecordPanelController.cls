public class RecordPanelController {
    public List<List<Contact>> recordPanels { get; set; }
    
    public RecordPanelController() {

        List<Contact> allRecords = [SELECT Id, LastName FROM Contact];
        recordPanels = new List<List<Contact>>();
        List<Contact> currentPanel = new List<Contact>();
        
        for (Integer i = 0; i < allRecords.size(); i++) {
            currentPanel.add(allRecords[i]);
            if (currentPanel.size() == 10 || i == allRecords.size() - 1) {
                recordPanels.add(currentPanel);
                currentPanel = new List<Contact>();
            }
        }
    }
}