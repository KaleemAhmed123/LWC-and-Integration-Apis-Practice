public class UserHandler {
    public static void addInGroup(List<User> userList) {
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Id GroupId = [SELECT Id FROM Group WHERE Name = 'Admin'].Id;
        
        for(User newUser: userList) {
            if(newUser.profileId == adminId && newUser.isActive) {
                GroupMember newMem = new GroupMember();
				newMem.GroupId = GroupId;
                newMem.UserOrGroupId = newUser.Id;
            }
        }
    }
}