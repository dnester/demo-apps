public class BroadcastHistoryController {

    private DriverAccess driverAccess = null;
    private ConditionBuilder queryCondition = null;
    public BroadcastHistory__c broadcastHistory{get; set;}
    public Broadcasts__c broadcast{get; set;}
  
    private List<String> listFieldNames = null;
    public String messageString {get; set;} 
    
     String actionId;
     public String getActionId(){
        return this.actionId;
    }
    public void setActionId(String actionId){
         this.actionId = actionId;
    }
    
     String actionName;
     public String getActionName(){
        return this.actionName;
    }
    public void setActionName(String actionName){
         this.actionName = actionName;
    }
    
    String userId;
    
    public String getUserId(){
        return this.userId;
    }
    public void setUserId(String userId){
         this.userId = userId;
    }
    
    String userName;
    
    public String getUserName(){
        return this.userName;
    }
    public void setUserName(String userName){
         this.userName = userName;
    }
    
    
    
    String broadCastHistoryId;
    String broadCastId;
    
  
    public String getBroadCastHistoryId(){
    return this.broadCastHistoryId;
    }
    
    public void getBroadCastHistoryId(String broadCastHistoryId){
     this.broadCastHistoryId = broadCastHistoryId;
    }
    
    public BroadcastHistoryController(){
        
        broadCastHistoryId = Apexpages.currentPage().getParameters().get('id');
        broadcastHistory = new BroadcastHistory__c();
        
        broadCastId = Apexpages.currentPage().getParameters().get('broadcastId');
        broadcastHistory.FKBroadcast__c = broadCastId;
        
        broadcastHistory.date__c = System.now();
       if(broadCastHistoryId != null && broadCastHistoryId != ''){
        init(broadCastHistoryId);
      }
    }
        
    public void init(String broadcastHistoryId){
    
    driverAccess = new DriverAccess();
    queryCondition = new ConditionBuilder();
    listFieldNames = new List<String>();
    
    listFieldNames.add('Id');
    listFieldNames.add('FKActions__c');
    listFieldNames.add('FKActions__r.Name');
    listFieldNames.add('FKBroadcast__c');
    listFieldNames.add('FKUser__c');
    listFieldNames.add('FKUser__r.Name');
    listFieldNames.add('Name');
    listFieldNames.add('actionDescription__c');
    listFieldNames.add('actionId__c');
    listFieldNames.add('broadcastId__c');
    listFieldNames.add('broadcastNote__c');
    listFieldNames.add('date__c');
    listFieldNames.add('description__c');
    listFieldNames.add('duration__c');
    listFieldNames.add('firstName__c');
    listFieldNames.add('inactive__c');
    listFieldNames.add('lastName__c');
    listFieldNames.add('note__c');
    listFieldNames.add('userId__c');
    listFieldNames.add('system__c');
       
    queryCondition.setCondition('Id =\'' + broadcastHistoryId +'\'' );
    List<BroadcastHistory__c> listBroadcastHostory =(List<BroadcastHistory__c>)driverAccess.selectObjects(broadcastHistory, listFieldNames, queryCondition, null);
    
    if(listBroadcastHostory.size() > 0){
      broadcastHistory = listBroadcastHostory[0];
      actionId = listBroadcastHostory[0].FKActions__r.Name;
      userId= listBroadcastHostory[0].FKUser__r.Name;
    }
   }

     public Pagereference populateAction(){
        
        if(actionId != null && actionId != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            listFieldNames.add('system__c');
            listFieldNames.add('description__c');
            
            queryCondition.setCondition('Id = \'' + actionId + '\''+ ' And system__c = false');
            List<Action__c> actionList = (List<Action__c> ) driverAccess.selectObjects(new Action__c(), listFieldNames, queryCondition, null);
            
            if(actionList.size() >0){
                System.debug('------------------> actionList[0].Id' + actionList[0].Id);
                broadcastHistory.FKActions__c = actionList[0].Id;
                broadcastHistory.system__c = actionList[0].system__c;
                broadcastHistory.description__c = actionList[0].description__c;
                actionName = actionList[0].Name;
            }
        }
        return null;
   }

  public Pagereference save(){
      try{   
           listFieldNames = new List<String>();
           queryCondition = new ConditionBuilder();
           driverAccess = new DriverAccess();
    
           if(broadcastHistory.Id == null ){
           
                  listFieldNames.clear();
                  listFieldNames.add('Id');
                  listFieldNames.add('Name');
                  queryCondition.setCondition('Name = \''+  userName +'\'');
        
                  List<User> usersList = (List<User>) driverAccess.selectObjects(new User(),listFieldNames,queryCondition,null);
                    
                  if(usersList.size() > 0){
                    System.debug('usersList[0].Id---------------------------' + usersList[0].Id);
                    broadcastHistory.FKUser__c =  usersList[0].Id;
                  }
               
                    listFieldNames.clear();
                              
                    listFieldNames.add('Id');
                    listFieldNames.add('Name');
                    listFieldNames.add('system__c');
                    listFieldNames.add('description__c');
                    
                    queryCondition.setCondition('Name = \'' + actionName + '\''+ ' And system__c = false');
                    List<Action__c> actionList = (List<Action__c> ) driverAccess.selectObjects(new Action__c(), listFieldNames, queryCondition, null);
                    
                    if(actionList.size() >0){
                        System.debug('------------------> actionList[0].Id' + actionList[0].Id);
                        broadcastHistory.FKActions__c = actionList[0].Id;
                        broadcastHistory.actionId__c = actionList[0].Name;
                        broadcastHistory.system__c = actionList[0].system__c;
                        broadcastHistory.description__c = actionList[0].description__c;
                    }
                    
                    listFieldNames.clear();
                    listFieldNames.add('Id');
                    listFieldNames.add('Name');        
                    String queryString = 'Id =' +'\''+broadCastId+'\'';  
                            
                    ConditionBuilder objConditionBuilder = new ConditionBuilder();
                    objConditionBuilder.setCondition(queryString);    
                
                    List<Broadcasts__c> broadcastList= (List <Broadcasts__c>) driverAccess.selectObjects(new Broadcasts__c(),listFieldNames,objConditionBuilder,null); 
                    if(broadcastList.size() >0)
                    {
             
                        broadcastHistory.broadcastId__c = broadcastList[0].Name;                     
                    }
                
                   driverAccess.insertObject(broadcastHistory, null);
             }else {
                  queryCondition.setCondition('Id=\''+ broadcastHistory.Id + '\'');
                  driverAccess.updateObject(broadcastHistory, queryCondition, null);
            }
            messageString = validationHelper.getSavedMessage();  

         }catch(Exception e){

            if(ApexPages.hasMessages()){

                messageString = validationHelper.getMessageString(ApexPages.getMessages());

             }else{

                messageString = validationHelper.getMessageFromError(e.getMessage());

             } 

        }
    return null;
  }

   public Pagereference deleteBroadcastHistory(){
        queryCondition.setCondition('');
        driverAccess.deleteObject(broadcastHistory,queryCondition,null);
        broadcastHistory= new BroadcastHistory__c();
        return null;
    }
    
    public Pagereference copy(){
        
        BroadcastHistory__c tempBroadcastHistory = new BroadcastHistory__c(Name=broadcastHistory.Name, actionId__c =broadcastHistory.actionId__c );
        broadcastHistory = tempBroadcastHistory;
        return null;
    }
    
    public Pagereference resetBroadcastHistory(){
        broadcastHistory = new BroadcastHistory__c();
        actionId=null;
        userId= null;
        actionName='';
        userName='';
        return null;
    }
    
    public Pagereference populateUser(){
        
        System.debug('------------------> userId' + userId);
        if(userId != null && userId != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            queryCondition.setCondition('Id = \'' + userId + '\'');
            List<User> userList = (List<User> ) driverAccess.selectObjects(new User(), listFieldNames, queryCondition, null);
            
            if(userList.size() >0){
                System.debug('------------------> userList[0].Id' + userList[0].Id);
                broadcastHistory.FKUser__c = userList[0].Id;
                userName  = userList[0].Name;
            }
        }
        return null;
    }
    
    
    public PageReference reOpenBroadcast(){
    
       ConditionBuilder conditionBuilder= new ConditionBuilder();
        List<String> lstOutputFields = new List<String>();
        queryCondition = new ConditionBuilder();
        driverAccess = new DriverAccess();
            
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');
         
        String condition = 'state__c =\'O\'' + 'defaultStatus__c = true';
        conditionBuilder.setCondition(condition); 
        Status__c tempStatus = new Status__c();
       
        List<Status__c> statusList = (List<Status__c>) driverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);

       // List<Status__c> statusList = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c from Status__c s where s.State__c =:'O' and s.defaultStatus__c =: true];   
        if(statusList.size() > 0)
         broadcast.FKStatus__r =  statusList[0];

        driverAccess.updateObject(broadcast, null, null);
        //upsert inc;
        return null;
    } 
}
			                            	