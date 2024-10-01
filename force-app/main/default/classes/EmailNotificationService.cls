public class EmailNotificationService {
    public static void sendEmail(List<String> recipientEmails) {        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setToAddresses(recipientEmails);
        email.setSubject('Contact created successfully.');
        email.setPlainTextBody('Hello there, your contact has been created successfully.');
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            system.debug('Email send successfully.');
        } catch (Exception e) {
            System.debug('Error sending Email: ' + e.getMessage());
        }
    }

    public static void sendNotification(Set<String> recipientsIds, String targetId) {
         CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='justTofillTheField'];
        
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        notification.setTitle('Account created successfully.');
        notification.setBody('Account has been created successfully.');

        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        try {
            notification.send(recipientsIds);
            system.debug('Noti send successfully.');
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}