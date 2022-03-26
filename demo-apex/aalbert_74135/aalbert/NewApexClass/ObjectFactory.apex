/*
    ObjectFactory: Factory class which will return the reference of concrate object based on parameter value
    Author: apatel
    Date: 12/11/2009
*/
public class ObjectFactory {
    
    // returns reference of concrete object depending on objName string parameter.
    public static sObject getInstanceByName(String objName) {
            sObject sObj = null;    
            if (objName.trim().equalsIgnoreCase('incident__c'))
                sObj = new Incident__c();
            else if(objName.trim().equalsIgnoreCase('action__c'))  
                sObj = new Action__c();
            else if(objName.trim().equalsIgnoreCase('impact__c'))  
                sObj = new Impact__c();
            else if (objName.trim().equalsIgnoreCase('priority__c'))
                sObj = new Priority__c();
            else if (objName.trim().equalsIgnoreCase('status__c'))
                sObj = new Status__c();
            else if (objName.trim().equalsIgnoreCase('Urgency__c'))
                sObj = new Urgency__c();
            else if (objName.trim().equalsIgnoreCase('Organization__c'))
                sObj = new Organization__c();
            else if (objName.trim().equalsIgnoreCase('Client__c'))
                sObj = new Client__c();
            else if (objName.trim().equalsIgnoreCase('SYSBRActions__c'))
                sObj = new SYSBRActions__c();
            else if (objName.trim().equalsIgnoreCase('SYSBRConditions__c'))
                sObj = new SYSBRConditions__c();
      else if (objName.trim().equalsIgnoreCase('SYSBRInformation__c'))
        sObj = new SYSBRInformation__c();
      else if (objName.trim().equalsIgnoreCase('SYSProperties__c'))
        sObj = new SYSProperties__c();
      else if (objName.trim().equalsIgnoreCase('EmailNotification__c'))
        sObj = new EmailNotification__c();
            return sObj;
    }
    // returns refernece of concrete object depending on object type parameter
    public static sObject getInstanceByType(Schema.Sobjecttype sobjType) {
            return getInstanceByName(sobjType+'');
    }   
        
}
			                            	