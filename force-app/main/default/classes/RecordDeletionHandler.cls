public class RecordDeletionHandler {
    public static void checkId(List<Opportunity> oppList) {
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
		Id currentUserId = UserInfo.getProfileId();

        for (Opportunity opp : oppList) {
            if ((opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') && currentUserId != adminProfile.Id) {
                opp.addError('Only Admins can delete closed Opportunities.');
            }
        }
    }
}