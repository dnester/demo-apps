//By Avadhut K.
public class SObjectFactory{
    public static SObject getSObject(String strType){
        if (strType == 'Incident' || strType == 'Incident__c') {
           return new Incident__c();           
        }else if (strType == 'Clients' || strType == 'Client__c') {
           return new Client__c();              
        }else if (strType == 'Broadcasts__c') {
           return new Broadcasts__c();              
        }else if (strType == 'Task__c') {
           return new Task__c();              
        }else if (strType == 'Status__c') {
           return new Status__c();              
        }else if (strType == 'Urgency__c') {
           return new Urgency__c();              
        }else if (strType == 'Impact__c') {
           return new Impact__c();              
        }else if (strType == 'Organization__c') {
           return new Organization__c();              
        }else if (strType == 'CategoryTypes__c') {
           return new CategoryTypes__c();              
        }else if (strType == 'Category__c') {
           return new Category__c();              
        }else if (strType == 'Action__c') {
           return new Action__c();              
        }else if (strType == 'User') {
           return new User();              
        }else if (strType == 'Priority__C') {
           return new Priority__C();              
        }else if (strType == 'StandardDescription__c') {
           return new StandardDescription__c();              
        }else if (strType == 'IncidentHistory__c') {
       return new IncidentHistory__c();              
        }else if (strType == 'SYSQVQuery__c') {
           return new SYSQVQuery__c();              
        }else if (strType == 'BlackOut__c') {
           return new BlackOut__c();              
    }else if (strType == 'Attachment') {
           return new  Attachment();              
        }else if (strType == 'TaskHistory__c') {
           return new  TaskHistory__c();              
        }else if (strType == 'BroadcastHistory__c') {
           return new  BroadcastHistory__c();              
        }else if (strType == 'SYSTemplate__c') {
           return new  SYSTemplate__c();              
        }else if (strType == 'ChangeHistory__c') {
           return new  ChangeHistory__c();              
        }
        else if (strType == 'ChangeRequest__c') {
           return new  ChangeRequest__c();              
        }
        else if (strType == 'ClientComments__c') {
           return new  ClientComments__c();              
        }
        else if (strType == 'EmailNotification__c') {
           return new  EmailNotification__c();              
        }
        else if (strType == 'Service__c') {
           return new  Service__c();              
        }
        else if (strType == 'StandardResolution__c') {
           return new  StandardResolution__c();              
        }
    else if (strType == 'SupportAssignments__c') {
           return new  SupportAssignments__c();              
        }
        else if (strType == 'TaskOrganizationLink__c') {
           return new  TaskOrganizationLink__c();              
        }
        else if (strType == 'UrgencyHierarchy__c') {
           return new  UrgencyHierarchy__c();              
        }else if ((strType == 'IncidentTemplate__c') || (strType == 'TaskTemplate__c')) {
           return new  SYSTemplate__c();              
        }else if (strType == 'SYSQVQueryAccess__c') {
           return new SYSQVQueryAccess__c();              
        }        
        return null;
    }
  
  //Get instance of object with given ID value
  public static SObject getSObject(String strType, String idValue){
        if (strType == 'Incident' || strType == 'Incident__c') {
           return new Incident__c(id=idValue);
        }else if (strType == 'Clients' || strType == 'Client__c') {
           return new Client__c(id=idValue);              
        }else if (strType == 'Broadcasts__c') {
           return new Broadcasts__c(id=idValue);              
        }else if (strType == 'Task__c') {
           return new Task__c(id=idValue);              
        }else if (strType == 'Status__c') {
           return new Status__c(id=idValue);              
        }else if (strType == 'Urgency__c') {
           return new Urgency__c(id=idValue);              
        }else if (strType == 'Impact__c') {
           return new Impact__c(id=idValue);              
        }else if (strType == 'Organization__c') {
           return new Organization__c(id=idValue );              
        }else if (strType == 'CategoryTypes__c') {
           return new CategoryTypes__c(id= idValue );              
        }else if (strType == 'Category__c') {
           return new Category__c(id= idValue );              
        }else if (strType == 'Action__c') {
           return new Action__c(id= idValue );              
        }else if (strType == 'User') {
           return new User(id= idValue );              
        }else if (strType == 'Priority__C') {
           return new Priority__C(id= idValue );              
        }else if (strType == 'StandardDescription__c') {
           return new StandardDescription__c(id= idValue );              
        }else if (strType == 'SYSQuickView__c') {
           return new SYSQuickView__c(id= idValue );              
        }else if (strType == 'IncidentHistory__c') {
           return new IncidentHistory__c(id= idValue );              
        }else if (strType == 'BlackOut__c') {
           return new BlackOut__c(id= idValue );              
        }
      return null;
    }
}
			                            	