public class ChangeHistoryController {
 
    ChangeHistory__c changeHistory{get;set;}
    Action__c action;
    User user;
    List<User> usersList;
    List<ChangeHistory__c> changeHistoryList;
    List<Action__c> actionList;
    List<ChangeRequest__c> changeRequestList;
    
    String changeRequestId{get;set;}
    String changeHistoryId{get;set;}
    String actionId{get;set;}
    String staffId{get;set;}
        
    public List<String> listOutputFields=new List<String>();
    public String queryString;
    public DriverAccess objDriverAccess = new DriverAccess();
    public ConditionBuilder objConditionBuilder = new ConditionBuilder();
    public String messageString {get; set;}
    
    public ChangeHistory__c getChangeHistory() {
        return changeHistory;
    }
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
    
    public changeHistoryController(){
        
        changeHistory = new ChangeHistory__c();
        action = new Action__c();
        user = new User();
        changeRequestId = Apexpages.currentPage().getParameters().get('changeId');
        //changeRequestId='a0A90000000PFy8';
        changeHistoryId = Apexpages.currentPage().getParameters().get('id');
        
        changeHistory.date__c = System.now();
        if(changeHistoryId != null && changeHistoryId != '' ){
            listOutputFields.add('Id');
            listOutputFields.add('Name');
            listOutputFields.add('actionId__c');
            listOutputFields.add('staffId__c');
            listOutputFields.add('FKChange__r.Name');
            listOutputFields.add('change__c');
            listOutputFields.add('description__c');
            listOutputFields.add('date__c');
            listOutputFields.add('duration__c');
            listOutputFields.add('note__c');
            listOutputFields.add('inactive__c');
            queryString='Id =' +'\''+changeHistoryId+'\'';  
                
             objConditionBuilder.setCondition(queryString);
         
            changeHistoryList = (List<ChangeHistory__c>) objDriverAccess.selectObjects(changeHistory,listOutputFields,objConditionBuilder,null);    
            if(changeHistoryList.size() > 0){
              changeHistory = changeHistoryList[0];
            }
            
        }
        if(changeRequestId != null && changeRequestId != '' ){
            ChangeRequest__c change= new ChangeRequest__c();
            listOutputFields.clear();
            listOutputFields.add('Id');
            listOutputFields.add('Name');
            
            queryString='Id =' +'\''+changeRequestId+'\'';  
                
            objConditionBuilder.setCondition(queryString);
         
            changeRequestList = (List<ChangeRequest__c>) objDriverAccess.selectObjects(change,listOutputFields,objConditionBuilder,null);    
            if(changeRequestList.size() > 0){
              changeHistory.FKChange__c = changeRequestList[0].Id; 
              changeHistory.change__c = changeRequestList[0].Name;
            }
        }
    }
    
     /*
    *    This populates action attributes to ChangeHistory page.
    */
    
    public PageReference actionQuery() {
        
        listOutputFields.clear();
        if(actionId != null && actionId != ''){
            listOutputFields.add('Id');
            listOutputFields.add('Name');
            listOutputFields.add('description__c');
            queryString='Id =' +'\''+ actionId+'\'';  
            
            objConditionBuilder.setCondition(queryString);
            
            actionList = (List<Action__c>) objDriverAccess.selectObjects(action,listOutputFields,objConditionBuilder,null);    
            if(actionList.size() > 0){
                changeHistory.actionId__c = actionList[0].Name;      
                changeHistory.description__c = actionList[0].description__c;
            } 
            
        }
        
        return null;    
    }
    
    /*
    *    This populates user attributes to ChangeHistory page.
    */
    
    public PageReference staffQuery() {
        
        listOutputFields.clear();
        if(staffId != null && staffId != ''){            
            listOutputFields.add('Id');
            listOutputFields.add('Name');            
            listOutputFields.add('userName');
            
            queryString='Id =' +'\''+ staffId +'\'';
        
            objConditionBuilder.setCondition(queryString);
        
            usersList = (List<User> ) objDriverAccess .selectObjects(user, listOutputFields, objConditionBuilder, null);
                        
            if(usersList.size() >0){      
              changeHistory.staffId__c = usersList[0].Name;
            }
        }
        
        return null;    
    }
    
    public PageReference newAction() {

        changeHistory = new ChangeHistory__c();
        return null;
    }    
    
    public PageReference save() {
        
        try{ 
                listOutputFields.clear();
                if(changeHistory.staffId__c != null && changeHistory.staffId__c != ''){
                    listOutputFields.add('Id');
                    listOutputFields.add('Name');            
                    
                    queryString='Name =' +'\''+changeHistory.staffId__c+'\'';
                    objConditionBuilder.setCondition(queryString);
                
                    usersList = (List<User> ) objDriverAccess .selectObjects(user, listOutputFields, objConditionBuilder, null);
                                
                    if(usersList.size() >0){
                        changeHistory.FKUser__c = usersList[0].Id;                
                    }
                }
                
                listOutputFields.clear();
                if(changeHistory.actionId__c != null && changeHistory.actionId__c != ''){
                    listOutputFields.add('Id');
                    listOutputFields.add('Name');            
                    queryString='Name =' +'\''+changeHistory.actionId__c+'\'';  
                    
                    objConditionBuilder.setCondition(queryString);
                    
                    actionList = (List<Action__c>) objDriverAccess.selectObjects(action,listOutputFields,objConditionBuilder,null);    
                    if(actionList.size() > 0){              
                        changeHistory.FKAction__c = actionList[0].Id;             
                    } 
                    
                }
                
               /*
               * Set FKUser__c null if staffId__c is null or blank
               */
               
                if(changeHistory.staffId__c == null && changeHistory.staffId__c == '')
                    changeHistory.FKUser__c =null;
                    
              /*
               * Set FKAction__c null if actionId__c is null or blank
               */   
                
                
                if(changeHistory.actionId__c == null && changeHistory.actionId__c == '')
                    changeHistory.FKAction__c = null;
                
                if(changeHistory.Id == null){ 
                     objDriverAccess.insertObject(changeHistory, null);
                }else{
                    objDriverAccess.updateObject(changeHistory,null, null);        
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
			                            	