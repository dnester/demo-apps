public class CreateBroadcastAuditTrail {

   private static final String SUBJECT_CHANGED = 'Subject Changed';
   private  static final String URGENCY_CHANGED = 'Urgency has been changed';
   private static final String STATUS_CHANGED = 'User Defined Broadcast Status Changed';
   private  static final String PRIORITY_CHANGED = 'Task Priority has been changed';
   private static final String WB_OPEN = 'WB_OPEN';
   private static final String TAKEN_BY = 'WB_TAKEN';
   private static final String WB_SUBJ_CHANGE = 'WB_SUBJ_CHANGE';
   private static DriverAccess driverAccess = new DriverAccess();
   private static ConditionBuilder queryCondition = new ConditionBuilder();
   private static  List<String> listFieldNames = new List<String>();
   
   private static final String WB_FRWD_STAFF = 'WB_FRWD_STAFF';
   private static final String WB_TAKEN = 'WB_TAKEN';  
   
   private static final String WB_STATUSCHANGE = 'WB_STATUSCHANGE';
   private static final String WB_CLOSE = 'WB_CLOSE'; 
   private static final String WB_REOPEN = 'WB_REOPEN';
    // Function to audit category change.
    public static void auditCategoryChange(Broadcasts__c broadcast) {
            insertRecord(broadcast,WB_SUBJ_CHANGE);
    }
    
          
    // Function to audit Staff change.
    public static void auditStaffChange(Broadcasts__c broadcast) {
             insertRecord(broadcast, WB_FRWD_STAFF);
     }

    // Function to audit status change.
    public static void auditStatusChange(Broadcasts__c broadcast) {
        insertRecord(broadcast, WB_STATUSCHANGE);
    }
   
    // Function to audit State change.
    public static void auditStateCloseChange(Broadcasts__c broadcast) {
        insertRecord(broadcast, WB_CLOSE);
    }
     public static void auditStateReopenChange(Broadcasts__c broadcast) {
        insertRecord(broadcast, WB_REOPEN);
    }
    
    // Function to audit logs on  Broadcasts creation.
    public static void auditBroadcastCreation(Broadcasts__c broadcast) {
        insertRecord(broadcast, WB_OPEN);
        insertRecord(broadcast, WB_TAKEN);
        }     

       public static void auditAssignToChange(Broadcasts__c broadcast, String newValue) {
            if(newValue == null || newValue=='') {
            String actionDescription = 'Assigned To None';
            insertRecord(broadcast, actionDescription);
          }else {
            String actionDescription = 'Forwarded to New Staff';
            insertRecord(broadcast, WB_FRWD_STAFF);
          }
       }

    //Function to insert a log record in DB.
    public static void insertRecord(Broadcasts__c broadcast, String actionDescription) {
    
        BroadcastHistory__c broadcastHistoryRec = new BroadcastHistory__c();
        broadcastHistoryRec.FKBroadcast__c = broadcast.Id;
        listFieldNames.clear();
        listFieldNames.add('id');
        listFieldNames.add('Name');
        listFieldNames.add('system__c');
        listFieldNames.add('description__c');
        
        
        queryCondition.setCondition('Name=\'' + actionDescription  + '\'');
        List<Action__c> actionList = ( List<Action__c>)driverAccess.selectObjects(new Action__c(), listFieldNames, queryCondition, null);
        if(actionList.size() > 0)  {
            broadcastHistoryRec.FKActions__c = actionList[0].Id;
            broadcastHistoryRec.system__c = actionList[0].system__c;
            broadcastHistoryRec.description__c = actionList[0].description__c;
            broadcastHistoryRec.date__c = System.now();
            broadcastHistoryRec.FKUser__c = Userinfo.getUserId();
      broadcastHistoryRec.userId__c = UserInfo.getName();
      broadcastHistoryRec.ActionId__c = actionList[0].Name;
        }
        
       listFieldNames.clear();
       listFieldNames.add('id');
       listFieldNames.add('Name');
       List<User> userList = new List<User>();
       if( broadcast.FKUserIdAssignedTo__c!=null){
        queryCondition.setCondition('id=\'' + broadcast.FKUserIdAssignedTo__c  + '\'');
        userList = ( List<User>)driverAccess.selectObjects(new User(), listFieldNames, queryCondition, null);
        if(userList.size()>0 && actionList.size()>0)  {
           broadcastHistoryRec.description__c = actionList[0].description__c + ' '+ userList[0].name;
         }
       }
       driverAccess.insertObject(broadcastHistoryRec, null);
    }
}
			                            	