/*
*   A class to audit the field updates and creation of Task object.
*/

Public class CreateTaskAuditTrail {
   
    
    // Function to audit category change.
    public static void auditCategoryChange(Task__c task) {
    
        String actionId = 'WO_SUBJ_CHANGE';
        insertRecord(task, actionId);        
    }

    // Function to audit urgency change.
    public static void auditUrgencyChange(Task__c task) {
        String actionId = 'URGENCY_CHANGE';
        insertRecord(task, actionId);
    }

    // Function to audit status change.
    public static void auditStatusChange(Task__c task) {
        String actionId = 'WO_STATUSCHANGE';
        insertRecord(task, actionId);
    }
    
    // Function to audit priority change.
    public static void auditPriorityChange(Task__c task) {
        String actionId = 'WO_PRIORITY_CHANGE';
        insertRecord(task, actionId);
    }
    
    // Function to audit logs on Task creation.
    public static void auditTaskCreation(Task__c task) {
        
        String actionId = 'WO_OPEN';
        insertRecord(task, actionId);

        actionId = 'WO_TAKEN';
        insertRecord(task, actionId);
    }     

    //Function to insert a log record in DB.
    public static void insertRecord(Task__c task, String actionId) {
    
        TaskHistory__c taskHistory = new TaskHistory__c();
        DriverAccess objDriverAccess = new DriverAccess(); 
        taskHistory.FKWO__c = task.Id;

        List<String> listFieldNames = new List<String>();
        listFieldNames.add('id');
        listFieldNames.add('Name');
        listFieldNames.add('system__c');
        listFieldNames.add('description__c');
        ConditionBuilder queryCondition = new ConditionBuilder();
        queryCondition.setCondition('Name=\'' + actionId  + '\''+ ' And System__c = true');
        
        Action__c[] actionObj = ( List<Action__c>)objDriverAccess.selectObjects(new Action__c(), listFieldNames, queryCondition, null);
        if(actionObj.size() > 0){
            taskHistory.FKAction__c = actionObj[0].Id;
            taskHistory.ActionId__c = actionObj[0].Name;
            taskHistory.system__c = actionObj[0].system__c;
            taskHistory.description__c = actionObj[0].description__c;
            if(actionObj[0].Name == 'WO_TAKEN'){
                taskHistory.description__c = taskHistory.description__c + ' ' +UserInfo.getName();
            }
        }
        
        taskHistory.FKUser__c = UserInfo.getUserId();
    taskHistory.userId__c = UserInfo.getName();
        taskHistory.Date__c = System.now();      
        
        objDriverAccess.insertObject(taskHistory, null);        
    }

}
			                            	