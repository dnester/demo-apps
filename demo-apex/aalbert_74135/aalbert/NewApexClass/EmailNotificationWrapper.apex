/*
  EmailNotificationWrapper: Wrapper class for EmailNotification custom object
  Author: apatel
  Date: 02/12/09
*/
public class EmailNotificationWrapper {
  private String[] toAddresses;
  private String subject;
  private String body;
  
  public String[] getToAddresses() {
    return toAddresses;
  }
  public void setToAddresses(String[] to) {
    toAddresses = to;
  }
  public String getSubject() {
    return subject;
  }
  public void setSubject(String sub) {
    subject = sub;
  }
  public String getBody() {
    return body;
  }
  public void setBody(String body) {
    this.body = body;
  }
}
			                            	