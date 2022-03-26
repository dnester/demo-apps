/*
  EmailNotifier : This class is used for sending email notification
  Author: apatel
  Date: 27/11/09
*/
public class EmailNotifier {
   // send email notification
   public static void sendNotification(String[] toAddresses, String subject, String body) {
    // Instantiate SingleEmailMessage
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // set toAddresses, subject, and body
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);        
        mail.setHTMLBody(body);
    // sendEmail
        Messaging.sendEmail(new Messaging.Email[] { mail } );
  }
}
			                            	