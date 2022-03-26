public class TaskHistoryController {
       
    TaskHistory__c taskHistory{get;set;}
    Action__c action;
    User user;
    
    List<User> usersList;
    List<TaskHistory__c> taskHistoryList;
    List<Action__c> actionList;
    
    String actionId;
    String staffId;
    String taskHistoryId;
    String taskId;    
    
    List<String> lstOutputFields;
    String queryString;
    ConditionBuilder objConditionBuilder;
    DriverAccess objDriverAccess;
    public String messageString {get; set;}
        
    public String getActionId(){
        return this.actionId;
    }
    
    public void setActionId(String actionId){
        this.actionId = actionId;
    }

    public String getStaffId() {
        return staffId;
    }
     
    public void setStaffId(String staffId){
        this.staffId= staffId;
    }
    
    public String getTaskHistoryId() {
        return taskHistoryId;
    }
     
    public void setTaskHistoryId(String taskHistoryId){
        this.taskHistoryId= taskHistoryId;
    }
    
    public TaskHistory__c getTaskHistory() {
        return taskHistory;
    }
    
    public TaskHistoryController() {
        
        taskHistory = new TaskHistory__c();
        action = new Action__c();
        user = new User();
        
        lstOutputFields = new List<String>();
        objConditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
        
        taskHistory.date__c = System.now();
      
        taskId = Apexpages.currentPage().getParameters().get('taskid');
        taskHistory.FKWO__c = taskid;
                
        taskHistoryId = Apexpages.currentPage().getParameters().get('id');
      
        if(taskHistoryId != null && taskHistoryId != '' ){
          
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('actionId__c');
            lstOutputFields.add('userId__c');
            lstOutputFields.add('taskId__c');
            lstOutputFields.add('description__c');
            lstOutputFields.add('date__c');
            lstOutputFields.add('duration__c');
            lstOutputFields.add('note__c');
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('system__c');
            lstOutputFields.add('FKWO__c');
            queryString='Id =' +'\''+taskHistoryId+'\'';  
        
            objConditionBuilder.setCondition(queryString);
         
            taskHistoryList = (List<TaskHistory__c>) objDriverAccess.selectObjects(taskHistory,lstOutputFields,objConditionBuilder,null);    
            if(taskHistoryList.size() > 0){
              taskHistory = taskHistoryList[0];
            }
          }
      }
    
    /*
    *    This populates action attributes to task history page.
    */
    
    public PageReference actionQuery() {
    
        lstOutputFields.clear();
        if(actionId != null && actionId != ''){
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('system__c');
            lstOutputFields.add('description__c');
            queryString='Id =' +'\''+actionId+'\''+ ' And system__c = false';  
            
            objConditionBuilder.setCondition(queryString);
            
            actionList = (List<Action__c>) objDriverAccess.selectObjects(action,lstOutputFields,objConditionBuilder,null);    
            if(actionList.size() > 0){
                taskHistory.actionId__c = actionList[0].Name;
                taskHistory.system__c = actionList[0].system__c;      
                taskHistory.description__c = actionList[0].description__c;
            } 
            
        }
        
        
        return null;    
    }
    
    /*
    *    This populates user attributes to task history page.
    */
    
    public PageReference staffQuery() {
    
        lstOutputFields.clear();
        if(staffId != null && staffId != ''){            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');            
            lstOutputFields.add('userName');
            
            queryString='Id =' +'\''+staffId +'\'';
        
            objConditionBuilder.setCondition(queryString);
        
            usersList = (List<User> ) objDriverAccess .selectObjects(user, lstOutputFields, objConditionBuilder, null);
                        
            if(usersList.size() >0){             
                taskHistory.userId__c = usersList[0].Name;
            }
        }
        
        return null;    
    }
    
    public PageReference newAction() {

        taskHistory = new TaskHistory__c();
        return null;
    }    
    
    public PageReference save() {
       try{ 
          lstOutputFields.clear();
          if(taskHistory.userId__c != null && taskHistory.userId__c != ''){
              lstOutputFields.add('Id');
              lstOutputFields.add('Name');            
              
              queryString='Name =' +'\''+taskHistory.userId__c+'\'';
              objConditionBuilder.setCondition(queryString);
          
              usersList = (List<User> ) objDriverAccess .selectObjects(user, lstOutputFields, objConditionBuilder, null);
                          
              if(usersList.size() >0){
                  taskHistory.FKUser__c = usersList[0].Id;                
              }
          }
          
          lstOutputFields.clear();
          if(taskHistory.actionId__c != null && taskHistory.actionId__c != ''){
              lstOutputFields.add('Id');
              lstOutputFields.add('Name');
              lstOutputFields.add('system__c');
              lstOutputFields.add('description__c');         
              queryString='Name =' +'\''+taskHistory.actionId__c+'\''+ ' And system__c = false';  
              
              objConditionBuilder.setCondition(queryString);
              
              actionList = (List<Action__c>) objDriverAccess.selectObjects(action,lstOutputFields,objConditionBuilder,null);    
              if(actionList.size() > 0){              
                  taskHistory.FKAction__c = actionList[0].Id;
                  taskHistory.system__c = actionList[0].system__c;      
                  taskHistory.description__c = actionList[0].description__c;             
              } 
              
          }
          
      lstOutputFields.clear();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
          if(taskId!=null){ 
            queryString='Id=' +'\''+taskId+'\'';  
            
            objConditionBuilder.setCondition(queryString);
            
            List<Task__c> taskList= (List<Task__c>) objDriverAccess.selectObjects(new Task__c(),lstOutputFields,objConditionBuilder,null);    
            if(taskList.size() > 0){              
                taskHistory.taskId__c = taskList[0].Name;      
            }
          }          
          if(taskHistory.Id == null){             
              objDriverAccess.insertObject(taskHistory, null);
          }else{
              objDriverAccess.updateObject(taskHistory,null, null);        
          }
          
           messageString = validationHelper.getSavedMessage();  
         }catch(Exception e){
           if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
            }  else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
            } 
       }
                    
        return null;
    }    

}
			                            	