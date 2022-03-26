Public class CreateAuditTrail {
  
    private static  List<String> listFieldNames = new List<String>();
    private static ConditionBuilder queryCondition = new ConditionBuilder();
    
    public static void auditCategoryChange(List<sObject> soOldTrigger, List<sObject> soNewTrigger, Incident__c incident) {
    
        String actionId = 'HD_SUBJ_CHANGE';
        insertRecord(incident, actionId);
    }

    public static void auditUrgencyChange(List<sObject> soOldTrigger, List<sObject> soNewTrigger, Incident__c incident) {
        
        String actionId = 'URGENCY_CHANGE';
        insertRecord(incident, actionId);
    }

    public static void auditStatusChange(List<sObject> soOldTrigger, List<sObject> soNewTrigger, Incident__c incident) {
        
        String actionId = 'HD_STATUSCHANGE';
        insertRecord(incident, actionId);
    }
    
    public static void auditAssignToChange(List<sObject> soOldTrigger, List<sObject> soNewTrigger, Incident__c incident, String newValue) {
        
        if(newValue == null || newValue=='') {
            
            String actionId = 'HD_REMOVED_STAFF';
            insertRecord(incident, actionId);
        }
        else {
            
            String actionId = 'HD_FRWD_STAFF';
            insertRecord(incident, actionId);
        }
    }
    
    public static void auditDueDateTimeChange(List<sObject> soOldTrigger, List<sObject> soNewTrigger, Incident__c incident) {
        
        String actionId = 'HD_DUEDATETIME_CHANGE';
        insertRecord(incident, actionId);
    }
    
    public static void auditPriorityChange(List<sObject> soOldTrigger, List<sObject> soNewTrigger, Incident__c incident) {
        
        String actionId = 'HD_PRIORITY_CHANGE';
        insertRecord(incident, actionId);
    }
    
    public static void auditCallCounterChange(List<sObject> soOldTrigger, List<sObject> soNewTrigger, Incident__c incident) {
        
        String actionId = 'HD_INCREMENT';
        insertRecord(incident, actionId);
    }
    
    public static void auditIncidentCreation(List<sObject> soOldTrigger, List<sObject> soNewTrigger, Incident__c incident) {
        
        String actionId = 'HD_TAKEN';
        insertRecord(incident, actionId);

        actionId = 'HD_OPEN';
        insertRecord(incident, actionId);
    }
    
    
    
     
    
    

    public static void insertRecord(Incident__c incident, String actionId) {
    
        IncidentHistory__c incidentHistory = new IncidentHistory__c();
         DriverAccess objDriverAccess = new DriverAccess();
        incidentHistory.FKIncident__c = incident.Id;
        listFieldNames.clear();
        listFieldNames.add('id');
        listFieldNames.add('Name');
        listFieldNames.add('system__c');
        listFieldNames.add('description__c');
        queryCondition.setCondition('Name=\'' + actionId  + '\'');
        
    //    Action__c[] actionObj = [SELECT id,Name,system__c,description__c from Action__c where Name=:actionId AND System__c = true];
       List<Action__c> actionList = ( List<Action__c>)objDriverAccess.selectObjects(new Action__c(), listFieldNames, queryCondition, null);
      
        if(actionList.size() > 0){
            incidentHistory.FKAction__c = actionList[0].Id;
            incidentHistory.ActionId__c = actionList[0].Name;
            incidentHistory.description__c = actionList[0].description__c;
            incidentHistory.system__c = actionList[0].system__c;
            if(actionList[0].Name == 'HD_TAKEN'){
                incidentHistory.description__c = incidentHistory.description__c+ ' '+ UserInfo.getName();
            }
        }
        
        incidentHistory.FKUser__c = UserInfo.getUserId();
    incidentHistory.date__c = system.now();
    incidentHistory.userId__c = UserInfo.getName();
        
        objDriverAccess.insertObject(incidentHistory, null);        
    }
}
			                            	