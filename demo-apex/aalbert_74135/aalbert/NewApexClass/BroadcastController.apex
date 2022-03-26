public class BroadcastController {

    public final String DONE_IMAGE = 'status_done.gif';
    public final String CURRENT_IMAGE = 'status_current.gif';
    public final String UN_DONE_IMAGE = 'status_undone.gif';
    public final String SKIPPED_IMAGE = 'status_undone.gif';
    
    private list<StageBox> stageBoxes = null;  
    public Broadcasts__c broadcast{get; set;}
    public Incident__c incident{get; set;}
    public Client__c client{get; set;}
    public String messageString {get; set;}
    String columnName='Name';
    String direction= 'ASC';
    public String tempString {get; set;}
    String closeStatus;
    String copyId;
  Boolean closeState = true;
  Boolean reOpenState = true;
  Boolean selectToState = false;
  Boolean selectFromState = false;
  Boolean assignStaffState = false;
  Boolean assignSuggestedStaffState = false;
  Boolean assignGroupState = false;
  Boolean assignMemberOfGroupState = false;
  Boolean assignMyselfState = false;    
  Boolean clearAssignState = true;
    
    String postDate;
    
    public String getPostDate(){
        return this.postDate;
    }
    /*public void setPostDate(DateTime date1){
            Datetime thisDT = date1;
            String myDate = thisDT.format('yyyy-MM-dd HH:mm:ss','PST'); 
            this.postDate= Datetime.valueOf(myDate) + '';
        }
    */
  
  // adding dummy setter
  public void setPostDate(String date1){
           
        }
    
    String toUserName;
    
    public Boolean getCloseState(){        
        return closeState;   
    }
    
    public void setCloseState(Boolean closeState){        
        this.closeState = closeState;   
    }
    
    public Boolean getReOpenState(){        
        return reOpenState;   
    }
    
    public void setReOpenState(Boolean reOpenState){        
        this.reOpenState = reOpenState;   
    }
    
    public Boolean getSelectToState(){        
        return selectToState;   
    }
    
    public void setSelectToState(Boolean selectToState){        
        this.selectToState = selectToState;   
    }
    
    public Boolean getSelectFromState(){        
        return selectFromState;   
    }
    
    public void setSelectFromState(Boolean selectFromState){        
        this.selectFromState = selectFromState;   
    }
    
    public Boolean getAssignMyselfState(){        
        return assignMyselfState;   
    }
    
    public void setAssignMyselfState(Boolean assignMyselfState){        
        this.assignMyselfState = assignMyselfState;   
    }
    
    public Boolean getAssignStaffState(){        
        return assignStaffState;   
    }
    
    public void setAssignStaffState(Boolean assignStaffState){        
        this.assignStaffState = assignStaffState;   
    }

    public Boolean getAssignSuggestedStaffState(){        
        return assignSuggestedStaffState;   
    }
    
    public void setAssignSuggestedStaffState(Boolean assignSuggestedStaffState){        
        this.assignSuggestedStaffState = assignSuggestedStaffState;   
    }
    
    public Boolean getAssignGroupState(){        
        return assignGroupState;   
    }
    
    public void setAssignGroupState(Boolean assignGroupState){        
        this.assignGroupState = assignGroupState;   
    }
    
    public Boolean getAssignMemberOfGroupState(){        
        return assignMemberOfGroupState;   
    }
    
    public void setAssignMemberOfGroupState(Boolean assignMemberOfGroupState){        
        this.assignMemberOfGroupState = assignMemberOfGroupState;   
    }
    
    public Boolean getClearAssignState(){        
        return clearAssignState ;   
    }
    
    public void setClearAssignState(Boolean clearAssignState ){        
        this.clearAssignState  = clearAssignState ;   
    }
    
    public String getToUserName(){
        return this.toUserName;
    }
    public void setToUserName(String toUserName){
         this.toUserName = toUserName;
    }
        
    String fromUserName;
    
     public String getFromUserName(){
        return this.fromUserName;
    }
    public void setFromUserName(String fromUserName){
         this.fromUserName = fromUserName;
    }
    
    String fromUserId;
    
    public String getFromUserId(){
        return this.fromUserId;
    }
    public void setFromUserId(String fromUserId){
         this.fromUserId = fromUserId;
    }
    
    String toUserId;
    
    public String getToUserId(){
        return this.toUserId;
    }
    public void setToUserId(String toUserId){
         this.toUserId = toUserId;
    }
    
    String staffName;
    
    public String getStaffName(){
        return this.staffName;
    }
    public void setStaffName(String staffName){
         this.staffName = staffName;
    }
    
    private String categoryName;
    
    public String getCategoryName(){
        return this.categoryName;
    }
    public void setCategoryName(String categoryName){
         this.categoryName = categoryName;
    }
    
    private String urgencyName;
    
    public String getUrgencyName(){
        return this.urgencyName;
    }
    public void setUrgencyName(String urgencyName){
         this.urgencyName = urgencyName;
    }
    
    private String staffId;
    
    public String getStaffId(){
        return this.staffId;
    }
    public void setStaffId(String staffId){
         this.staffId = staffId;
    }
    
    private String currentBroadCastId;
    
    public String getCurrentBroadCastId(){
        return this.currentBroadCastId;
    }
    public void setCurrentBroadCastId(String currentBroadCastId){
         this.currentBroadCastId = currentBroadCastId;
    }
    
    private String urgencyId;
    
    public String getUrgencyId(){
        return this.urgencyId;
    }
    
    public void setUrgencyId(String urgencyId){
         this.urgencyId = urgencyId;
    }
    
    private String categoryId;
    
    public String getCategoryId(){
        return this.categoryId;
    }
    
    public void setCategoryId(String categoryId){
         this.categoryId = categoryId;
    }
    
    private String categoryResolutionId;
    
    public String getCategoryResolutionId(){
        return this.categoryResolutionId;
    }
    
    public void setCategoryResolutionId(String categoryResolutionId){
         this.categoryResolutionId = categoryResolutionId;
    }
    
    private String categoryDescriptionId;
    
    public String getCategoryDescriptionId(){
        return this.categoryDescriptionId;
    }
    
    public void setCategoryDescriptionId(String categoryDescriptionId){
         this.categoryDescriptionId = categoryDescriptionId;
    }
    
    private String impactId;
    
    public String getImpactId(){
        return this.impactId;
    }
    
    public void setImpactId(String impactId){
         this.impactId = impactId;
    }
    
    private String impactName;
    
    public String getImpactName(){
        return this.impactName;
    }
    
    public void setImpactName(String impactName){
         this.impactName = impactName;
    }
    
    
    private String priorityId;
    
    public String getPriorityId(){
        return this.priorityId;
    }
    
    public void setPriorityId(String priorityId){
         this.priorityId = priorityId;
    }
    
    private String priorityName;
    
    public String getPriorityName(){
        return this.priorityName;
    }
    
    public void setPriorityName(String priorityName){
         this.priorityName = priorityName;
    }
    
     // for Status 
    private String statusId;
    
    public String getStatusId(){
        return this.statusId;
    }
    
    public void setStatusId(String statusId){
         this.statusId = statusId;
    }
    
   
    private String statusName;
    
    public String getStatusName(){
        return this.statusName;
    }
    
    public void setStatusName(String statusName){
         this.statusName = statusName;
    }
    
    private String firstName;
    
    public String getFirstName(){
        return this.firstName;
    }
    
    public void setFirstName(String firstName){
         this.firstName= firstName;
    }
    
    private String lastName;
    
    public String getLastName(){
        return this.lastName;
    }
    
    public void setLastName(String lastName){
         this.lastName= lastName;
    }


    
    private DriverAccess driverAccess = null;
    private ConditionBuilder queryCondition = null;
    private List<String> listFieldNames = null;
    
    public BroadcastController(){
        columnName = ApexPages.CurrentPage().getParameters().get('columnField');
        direction = ApexPages.CurrentPage().getParameters().get('direction'); 
        currentBroadCastId = Apexpages.currentPage().getParameters().get('id');
        copyId = Apexpages.currentPage().getParameters().get('copyId');
        broadcast= new Broadcasts__c();
        driverAccess = new DriverAccess();
        queryCondition = new ConditionBuilder();
        listFieldNames = new List<String>();
        
        listFieldNames.add('Id');
        listFieldNames.add('Name');
        listFieldNames.add('state__c');
        listFieldNames.add('defaultStatus__c');

        String queryString = 'state__c = false and ' + 'defaultStatus__c = true and ' + 'appliesToBroadcasts__c = true';
    
        queryCondition.setCondition(queryString);
        Status__c status = new Status__c();
    
        List<Status__c> defaultStatus = (List<Status__c>) driverAccess.selectObjects(status,listFieldNames,queryCondition,null);                
        if(defaultStatus.size() > 0) {            
            closeStatus = defaultStatus[0].Name;
            //statusName=defaultStatus[0].Name;
        }
        
        String queryStringForOpenStatus = 'state__c = true and ' + 'defaultStatus__c = true and ' + 'appliesToBroadcasts__c = true';
    
        queryCondition.setCondition(queryStringForOpenStatus);
        List<Status__c> defaultOpenStatusList = (List<Status__c>) driverAccess.selectObjects(new Status__c(),listFieldNames,queryCondition,null);                
        if(defaultOpenStatusList.size() > 0) {            
            statusName = defaultOpenStatusList[0].Name;
        }
        if(currentBroadCastId != null && currentBroadCastId != '') {
            init(currentBroadCastId);
        }else if(copyId !=null && copyId != ''){
          init(copyId);
        }
    }
    
    public void init(String broadcastId){
        listFieldNames.clear();
        
        listFieldNames.add('Id');
        listFieldNames.add('urgencyId__c');
        listFieldNames.add('FKUserIdClosedBy__c');
        listFieldNames.add('FKUserIdAssignedTo__c');
        listFieldNames.add('FKUserIdAssignedTo__r.FirstName');
        listFieldNames.add('FKUserIdAssignedTo__r.LastName');
        listFieldNames.add('FKUserIdAssignedTo__r.name');
        listFieldNames.add('FKUrgency__c');
        listFieldNames.add('FKUrgency__r.Name');
        listFieldNames.add('FKCategory__r.Name');
        listFieldNames.add('FKStatus__c');
        listFieldNames.add('FKPriority__c');
        listFieldNames.add('FKImpact__c');
        listFieldNames.add('FKClosedBy__c');
        listFieldNames.add('FKCategory__c');
        listFieldNames.add('Name');
        listFieldNames.add('UserIDAssignedTo__c');
        listFieldNames.add('UserIDClosedBy__c');
        listFieldNames.add('broadcastDescription__c');
        listFieldNames.add('broadcastResolution__c');
        listFieldNames.add('categoryId__c');
        listFieldNames.add('closeDateTime__c');
        listFieldNames.add('closedById__c');
        listFieldNames.add('displayInClientService__c');
        listFieldNames.add('displayInQueue__c');
        listFieldNames.add('expirationDate__c');
        listFieldNames.add('inactive__c');
        listFieldNames.add('note__c');
        listFieldNames.add('postDate__c');
        listFieldNames.add('priorityId__c');
        listFieldNames.add('state__c');
        listFieldNames.add('statusDescription__c');
        listFieldNames.add('statusId__c');
        listFieldNames.add('FKStatus__r.state__c');
        listFieldNames.add('FKFrom__r.Name');
        listFieldNames.add('FKTo__r.Name');
        listFieldNames.add('impactId__c');
        listFieldNames.add('toUserName__c');
        listFieldNames.add('fromUserName__c');
        listFieldNames.add('FKImpact__r.Name');
        listFieldNames.add('FKStatus__r.Name');        
        listFieldNames.add('FKPriority__r.Name');
        
        if((broadcastId != null && broadcastId != '') || (copyId != null && copyId != '')){
            queryCondition.setCondition('Id =\'' + broadcastId +'\'' );
            List<Broadcasts__c> listBroadcast =(List<Broadcasts__c>)driverAccess.selectObjects(broadcast, listFieldNames, queryCondition, null);
        
            if(listBroadcast.size() > 0){
                broadcast = listBroadcast[0];
                staffName = listBroadcast[0].FKUserIdAssignedTo__r.Name;
                urgencyName =listBroadcast[0].FKUrgency__r.Name;
                categoryName =listBroadcast[0].FKCategory__r.Name;
                toUserName= listBroadcast[0].FKTo__r.Name;
                fromUserName= listBroadcast[0].FKFrom__r.Name;
                impactName =listBroadcast[0].FKImpact__r.Name;
                statusName =listBroadcast[0].FKStatus__r.Name;
                priorityName =listBroadcast[0].FKPriority__r.Name;
                firstName =listBroadcast[0].FKUserIdAssignedTo__r.FirstName;
                lastName =listBroadcast[0].FKUserIdAssignedTo__r.LastName;
                postDate = listBroadcast[0].postDate__c + '';
                if(broadcast.FKStatus__r.Name == closeStatus){
              closeState = true;
              assignStaffState = true;
              assignGroupState = true;
              assignMemberOfGroupState = true;
              assignSuggestedStaffState = true;
              assignMyselfState = true;
              selectToState = true;
              selectFromState = true;              
              reOpenState = false;                    
            }else{
              closeState = false;
              reOpenState = true;
              assignStaffState = false;
              assignGroupState = false;
              assignMemberOfGroupState = false;
              assignSuggestedStaffState = false;
              if(broadcast.FKUserIdAssignedTo__c == Userinfo.getUserId()){
                assignMyselfState = true;
              }else{
                assignMyselfState = false;
              }
              selectToState = false;
              selectFromState = false;
              if(broadcast.FKUserIdAssignedTo__c != null){
                clearAssignState = false;
              }else{
                clearAssignState = true;
              }
            }
                
                if(copyId != null && copyId != ''){
                  copy();
                  copyId = null;
                }
            }
            
        }else{
                broadcast = new Broadcasts__c();
                staffName = '';
                urgencyName ='';
                categoryName = '';
                toUserName= '';
                fromUserName= '';
                impactName = '';
                statusName ='';
                priorityName ='';
                firstName ='';
                lastName = '';
                postDate = '';
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                listFieldNames.add('state__c');
                listFieldNames.add('defaultStatus__c');
                listFieldNames.add('appliesToBroadcasts__c');
            
                queryCondition.setCondition('state__c = true AND defaultStatus__c = true AND appliesToBroadcasts__c = true');
        
                List<Status__c> statusList = (List<Status__c>) driverAccess.selectObjects(new Status__c(),listFieldNames,queryCondition,null);
                
                if(statusList.size()>0){
                    broadCast.FKStatus__c = statusList[0].Id;
                    statusName = statusList[0].Name;
                 }else {
                    broadCast.FKStatus__c = null;
                    statusName = '';
                 }
                 
        }
    }
    
    
    public Pagereference populatePriority(){

            if(priorityId != null && priorityId != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            queryCondition.setCondition('Id = \'' + priorityId + '\'');
            List<Priority__c> priorityList = (List<Priority__c> ) driverAccess.selectObjects(new Priority__c(), listFieldNames, queryCondition, null);
            
            if(priorityList.size() >0){
                broadcast.FKPriority__c = priorityList[0].Id;
                priorityName = priorityList[0].Name;
                broadcast.priorityId__c = priorityList[0].Name;
            }else{
              broadcast.FKPriority__c = null;
                priorityName = '';
                broadcast.priorityId__c = '';
              
            }
        }
        return null;
    }
    
    public Pagereference populateStatus(){

         if(statusId != null && statusId != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            queryCondition.setCondition('Id = \'' + statusId + '\'');
            List<Status__c> statusList = (List<Status__c> ) driverAccess.selectObjects(new Status__c(), listFieldNames, queryCondition, null);
            
            if(statusList.size() >0){
                broadcast.FKStatus__c = statusList[0].Id;
                statusName = statusList[0].Name;
            }else {
              broadcast.FKStatus__c = null;
                statusName = '';
            }
        }
        return null;
    }
    
    public Pagereference populateImpact(){

            if(impactId != null && impactId != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            queryCondition.setCondition('Id = \'' + impactId + '\'');
            List<Impact__c> impactList = (List<Impact__c> ) driverAccess.selectObjects(new Impact__c(), listFieldNames, queryCondition, null);
            
            if(impactList.size() >0){
                broadcast.FKImpact__c = impactList[0].Id;
                impactName = impactList[0].Name;
            }else {
              broadcast.FKImpact__c = null;
                impactName = '';
            }
        }
        return null;
    }
    /* 
    this code is not in use modified by Ram.
     */ 
   /* public Pagereference populateCategory(){
         if(categoryId != null && categoryId != ''){
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            queryCondition.setCondition('Name = \'' + categoryId + '\'');
            List<Category__c> categoryList = (List<Category__c> ) driverAccess.selectObjects(new Category__c(), listFieldNames, queryCondition, null);
            if(categoryList.size() >0){
                broadcast.FKCategory__c = categoryList[0].Id;
                categoryName = categoryList[0].Name;
            }else {
              broadcast.FKCategory__c = null;
                categoryName = '';
            }
        }
        return null;
    }*/
    
    
    public PageReference categoryQuery () {
        
        if(categoryId != null) {
          Category__c category = new Category__c();
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            listFieldNames.add('categoryDescription__c');
            listFieldNames.add('FKUrgency__r.Id');
            String queryString='Name =' +'\''+categoryId+'\'';
            queryCondition.setCondition(queryString);
        
            List<Category__c> categoryList = (List<Category__c>) driverAccess.selectObjects(new Category__c(),listFieldNames,queryCondition,null);            
            if(categoryList.size() > 0){
                category = categoryList[0];
                broadcast.FKCategory__c = categoryList[0].Id;
                categoryName = categoryList[0].Name;
            }else {
              broadcast.FKCategory__c = null;
                categoryName = '';
            }
            
        }
       return null;
      }
      
       public PageReference descriptionQuery () {
        StandardDescription__c stdDescription= new  StandardDescription__c();
        if(categoryDescriptionId != null) {
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            listFieldNames.add('description__c');
                
            String queryString='Id =' +'\''+categoryDescriptionId+'\'';
            queryCondition.setCondition(queryString);
       
            List<StandardDescription__c> descriptionList = (List<StandardDescription__c>) driverAccess.selectObjects(stdDescription,listFieldNames,queryCondition,null);            
            if(descriptionList.size() > 0){
                broadcast.broadcastDescription__c = descriptionList[0].description__c;
            }
          }
        return null;
      }
      
       public PageReference resolutionQuery () {
        StandardResolution__c stdResolution= new StandardResolution__c();
        if(categoryResolutionId != null) {
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            listFieldNames.add('resolution__c');
            String queryString='Id =' +'\''+categoryResolutionId+'\'';
            queryCondition.setCondition(queryString);
            List<StandardResolution__c> resolutionList = (List<StandardResolution__c>) driverAccess.selectObjects(stdResolution,listFieldNames,queryCondition,null);            
            if(resolutionList.size() > 0){
                 broadcast.broadcastResolution__c = resolutionList[0].resolution__c;
             }
        }
       return null;
      }
    
    public Pagereference populateUrgency(){
        
          if(urgencyId != null && urgencyId != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            queryCondition.setCondition('Id = \'' + urgencyId + '\'');
            List<Urgency__c> urgencyList = (List<Urgency__c> ) driverAccess.selectObjects(new Urgency__c(), listFieldNames, queryCondition, null);
            
            if(urgencyList.size() >0){
                broadcast.FKUrgency__c = urgencyList[0].Id;
                urgencyName = urgencyList[0].Name;
            }else{
              broadcast.FKUrgency__c = null;
                urgencyName = '';
            }
        }
        return null;
    }
    
    public Pagereference broadcastSelectFromUser(){
       
        if(fromUserId != null && fromUserId != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            queryCondition.setCondition('Id = \'' + fromUserId + '\'');
            List<User> userList = (List<User> ) driverAccess.selectObjects(new User(), listFieldNames, queryCondition, null);
            
            if(userList.size() >0){
                broadcast.FKFrom__c = userList[0].Id;
                fromUserName = userList[0].Name;
            }else{
              broadcast.FKFrom__c = null;
                fromUserName = '';
            }
        }
        return null;
    }
    
     public Pagereference broadcastSelectToUser(){
            if(toUserId != null && toUserId != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            queryCondition.setCondition('Id = \'' + toUserId + '\'');
            List<User> userList = (List<User> ) driverAccess.selectObjects(new User(), listFieldNames, queryCondition, null);
           
            if(userList.size() >0){
                broadcast.FKTo__c = userList[0].Id;
                toUserName = userList[0].Name;
              }else{
              broadcast.FKTo__c = null;
                toUserName = '';
            }
        }
        return null;
    }
    
   
        public Pagereference save(){
    
      try{
            
            driverAccess = new DriverAccess();
            queryCondition = new ConditionBuilder();
            listFieldNames = new List<String>();
           
            List<Status__c> statusList;
            List<Category__c> categoryList;
            List<Urgency__c> urgencyList;
            List<Impact__c> impactList;
            List<Priority__c> priorityList;
            
            if(broadcast.Id == null ){
              
              if(broadcast.expirationDate__c != null && broadcast.expirationDate__c < System.now()){
                messageString = Label.BRDExpriationDateExp;
                throw new FormValidationException(messageString);
                
              }
                     
              
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                listFieldNames.add('state__c');
               
                queryCondition.setCondition('state__c = true AND defaultStatus__c = true AND appliesToBroadcasts__c = true');
                statusList = (List<Status__c>) driverAccess.selectObjects(new Status__c(),listFieldNames,queryCondition,null);
                if(statusList.size() > 0){
                    broadcast.FKStatus__c =  statusList[0].Id;
                    statusName = statusList[0].Name;
                    broadcast.FKStatus__r = statusList[0];                    
                    broadcast.FKStatus__r.Name = statusList[0].Name;                    
                    broadcast.state__c = statusList[0].state__c;  
                    broadcast.statusId__c = statusList[0].Name;                    
                }else{
                   broadcast.FKStatus__c = null;
                   broadcast.statusId__c = '';
                     statusName = '';
                }
                
                
                broadcast.postDate__c =System.now();
                postDate =  broadcast.postDate__c +'';
                
                
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                listFieldNames.add('FirstName');
                listFieldNames.add('LastName');
                queryCondition.setCondition('Name = \''+  staffName +'\'');
                    
                List<User> usersList = (List<User>) driverAccess.selectObjects(new User(),listFieldNames,queryCondition,null);
                
                if(usersList.size() > 0){
                    broadcast.FKUserIdAssignedTo__c =  usersList[0].Id;
                    firstName=usersList[0].FirstName;
                    lastName=usersList[0].LastName;
                    broadcast.userIDAssignedTo__c =   usersList[0].name;
                }else{
                  broadcast.FKUserIdAssignedTo__c =  null;
                    firstName='';
                    lastName='';
                    broadcast.userIDAssignedTo__c =   '';
                }
                
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                queryCondition.setCondition('Name = \''+  categoryName +'\'');
                    
                categoryList = (List<Category__c>) driverAccess.selectObjects(new Category__c(),listFieldNames,queryCondition,null);
                
                if(categoryList.size() > 0){
                    broadcast.FKCategory__c =  categoryList[0].Id;
                    broadcast.categoryId__c = categoryList[0].name;
                }else{
                  broadcast.FKCategory__c =  null;
                  broadcast.categoryId__c = '';
                }
                
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                queryCondition.setCondition('Name = \''+  urgencyName +'\'');
                    
                urgencyList = (List<Urgency__c>) driverAccess.selectObjects(new Urgency__c(),listFieldNames,queryCondition,null);
                if(urgencyList.size() > 0){
                    broadcast.FKUrgency__c =  urgencyList[0].Id;
                    broadcast.urgencyId__c =  urgencyList[0].name;
                }else{
                  broadcast.FKUrgency__c = null;
                  broadcast.urgencyId__c =  '';
                }
                
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                queryCondition.setCondition('Name = \''+  impactName +'\'');
                    
                impactList = (List<Impact__c>) driverAccess.selectObjects(new Impact__c(),listFieldNames,queryCondition,null);
                if(impactList.size() > 0){
                    broadcast.FKImpact__c =  impactList[0].Id;
                    broadcast.impactId__c = impactList[0].name;
                }else{
                   broadcast.FKImpact__c =  null;
                    broadcast.impactId__c = '';
                }
                
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                queryCondition.setCondition('Name = \''+  priorityName +'\'');
                    
                priorityList = (List<Priority__c>) driverAccess.selectObjects(new Priority__c(),listFieldNames,queryCondition,null);
                if(priorityList.size() > 0){
                    broadcast.FKPriority__c =  priorityList[0].Id;
                    broadcast.priorityId__c = priorityList[0].Name;
                }else {
                  broadcast.FKPriority__c =  null;
                    broadcast.priorityId__c = '';
                }
                
                if(fromUserId != null && fromUserId !=''){
                   broadcast.FKFrom__c= fromUserId;
                   
                }else {
                
                   broadcast.FKFrom__c = UserInfo.getUserId();
                   fromUserName = UserInfo.getName();
                }
                 broadcast.FKTo__c= toUserId;
                  
                driverAccess.insertObject(broadcast, null);
                init(broadcast.id+'');
                
            }else {
                
                
              if(broadcast.expirationDate__c != null && broadcast.postDate__c != null 
                    && broadcast.expirationDate__c < broadcast.postDate__c
                     && broadcast.expirationDate__c < System.now()){
                messageString = Label.BRDExpriationDateExp;
                throw new FormValidationException(messageString);
                
              }
                
                broadcast.FKFrom__c= fromUserId;
                broadcast.FKTo__c= toUserId;
                    
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                listFieldNames.add('FirstName');
                listFieldNames.add('LastName');
                queryCondition.setCondition('Name = \''+  staffName +'\'');
                    
                List<User> usersList = (List<User>) driverAccess.selectObjects(new User(),listFieldNames,queryCondition,null);
                
                if(usersList.size() > 0){
                    broadcast.FKUserIdAssignedTo__c =  usersList[0].Id;
                    broadcast.userIDAssignedTo__c =  usersList[0].name;
                    firstName=usersList[0].FirstName;
                    lastName=usersList[0].LastName;
                }else{
                  broadcast.FKUserIdAssignedTo__c =  null;
                    firstName='';
                    lastName='';
                    broadcast.userIDAssignedTo__c =  '';
                }
                
                if(broadcast.categoryId__c!=null && broadcast.categoryId__c!=''){
                  listFieldNames.clear();
                  listFieldNames.add('Id');
                  listFieldNames.add('Name');
                  queryCondition.setCondition('Name = \''+  categoryName +'\'');
                      
                  categoryList = (List<Category__c>) driverAccess.selectObjects(new Category__c(),listFieldNames,queryCondition,null);
                  
                  if(categoryList.size() > 0){
                      broadcast.FKCategory__c =  categoryList[0].Id;
                      broadcast.categoryId__c =   categoryList[0].Name;
                  }else {
                    broadcast.FKCategory__c =null;
                    broadcast.categoryId__c =  '';
                  }  
                }
                  
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                queryCondition.setCondition('Name = \''+  urgencyName +'\'');
                    
                urgencyList = (List<Urgency__c>) driverAccess.selectObjects(new Urgency__c(),listFieldNames,queryCondition,null);
                if(urgencyList.size() > 0){
                    broadcast.FKUrgency__c =  urgencyList[0].Id;
                    broadcast.urgencyId__c =  urgencyList[0].name;
                }else{
                    broadcast.FKUrgency__c =  null;
                     broadcast.urgencyId__c =  '';
                }
                
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                queryCondition.setCondition('Name = \''+  impactName +'\'');
                    
                impactList = (List<Impact__c>) driverAccess.selectObjects(new Impact__c(),listFieldNames,queryCondition,null);
                if(impactList.size() > 0){
                    broadcast.FKImpact__c =  impactList[0].Id;
                    broadcast.impactId__c =  impactList[0].name;
                }else{
                    broadcast.FKImpact__c = null;
                    broadcast.impactId__c = '';
                }
    
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                listFieldNames.add('state__c');
                queryCondition.setCondition('Name = \''+  statusName +'\'');
                    
                statusList = (List<Status__c>) driverAccess.selectObjects(new Status__c(),listFieldNames,queryCondition,null);
                if(statusList.size() > 0){
                    broadcast.FKStatus__c =  statusList[0].Id;
                    broadcast.state__c = statusList[0].state__c;
                    broadcast.FKStatus__r.Name = statusList[0].Name;
                    broadcast.statusId__c = statusList[0].Name;
                }else{
                  broadcast.FKStatus__c =  null;
                    broadcast.state__c = false;
                    broadcast.statusId__c ='';
                }
                
                listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                queryCondition.setCondition('Name = \''+  priorityName +'\'');
                    
                priorityList = (List<Priority__c>) driverAccess.selectObjects(new Priority__c(),listFieldNames,queryCondition,null);
                if(priorityList.size() > 0){
                    broadcast.FKPriority__c =  priorityList[0].Id;
                    broadcast.priorityId__c =  priorityList[0].Name;
                    
                }else{
                  broadcast.FKPriority__c = null;
                  broadcast.priorityId__c =  '';
                }
    
                queryCondition.setCondition('Id =\''+ broadcast.Id + '\'');
                driverAccess.updateObject(broadcast, queryCondition, null);
                init(broadcast.id + '');
            }
            if(broadcast.FKStatus__r.Name == closeStatus){
                  closeState = true;
                reOpenState = false;
                assignStaffState = true;
                assignMyselfState = true;
                assignGroupState = true;
                assignMemberOfGroupState = true;
                assignSuggestedStaffState = true;
                selectToState = true;
                selectFromState = true;          
                clearAssignState = true;
            }else{
              closeState = false;
              reOpenState = true;
              assignStaffState = false;
              assignGroupState = false;
              assignMemberOfGroupState = false;
              assignSuggestedStaffState = false;
              
              if(broadcast.FKUserIdAssignedTo__c == Userinfo.getUserId()){
                assignMyselfState = true;
              }else{
                assignMyselfState = false;
              }
              selectToState = false;
              selectFromState = false;
              if(broadcast.FKUserIdAssignedTo__c != null){
                clearAssignState = false;
              }       
            }            
        
       currentBroadCastId = broadcast.Id +'';
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
    
    
    public Pagereference deleteBroadcast(){
        
        driverAccess = new DriverAccess();
        queryCondition = new ConditionBuilder();
        
        staffName  ='';
        urgencyName='';
        categoryName='';
        toUserName= '';
        fromUserName= '';
        statusName='';
        impactName='';
        priorityName='';
        firstName='';
        lastName='';
        postDate='';
        if(broadcast != null && broadcast.Id != null){
          queryCondition.setCondition('id=\''+ broadcast.Id + '\'');
          driverAccess.deleteObject(broadcast,queryCondition,null);
        }
        return null;
    }
    
    public void copy(){     

        Broadcasts__c tempBroadcast= new Broadcasts__c();
    
          tempBroadcast.urgencyId__c = broadcast.urgencyId__c;
        tempBroadcast.FKUserIdClosedBy__c = broadcast.FKUserIdClosedBy__c;
        tempBroadcast.FKUserIdAssignedTo__c = broadcast.FKUserIdAssignedTo__c;
        tempBroadcast.FKUrgency__c = broadcast.FKUrgency__c;
        tempBroadcast.FKStatus__c = broadcast.FKStatus__c;
        tempBroadcast.FKPriority__c = broadcast.FKPriority__c;
        tempBroadcast.FKImpact__c = broadcast.FKImpact__c;
        tempBroadcast.FKClosedBy__c = broadcast.FKClosedBy__c;
        tempBroadcast.FKCategory__c = broadcast.FKCategory__c;
        tempBroadcast.UserIDAssignedTo__c = broadcast.UserIDAssignedTo__c;
        tempBroadcast.UserIDClosedBy__c = broadcast.UserIDClosedBy__c;
        tempBroadcast.broadcastDescription__c = broadcast.broadcastDescription__c;
        tempBroadcast.broadcastResolution__c = broadcast.broadcastResolution__c;
        tempBroadcast.categoryId__c = broadcast.categoryId__c;
        tempBroadcast.closeDateTime__c = broadcast.closeDateTime__c;
        tempBroadcast.closedById__c = broadcast.closedById__c;
        tempBroadcast.displayInClientService__c = broadcast.displayInClientService__c;
        tempBroadcast.displayInQueue__c = broadcast.displayInQueue__c;
        tempBroadcast.expirationDate__c = broadcast.expirationDate__c;
        tempBroadcast.inactive__c = broadcast.inactive__c;
        tempBroadcast.note__c = broadcast.note__c;
        tempBroadcast.postDate__c = broadcast.postDate__c;
        tempBroadcast.priorityId__c = broadcast.priorityId__c;
        tempBroadcast.state__c = broadcast.state__c;
        tempBroadcast.statusId__c = broadcast.statusId__c;
        tempBroadcast.impactId__c = broadcast.impactId__c;
        tempBroadcast.toUserName__c = broadcast.toUserName__c;
        tempBroadcast.fromUserName__c = broadcast.fromUserName__c;
         
          broadcast = tempBroadcast;
           
        
    }
    
    public Pagereference reset(){
      
      if(broadcast!= null && broadcast.id!= null ){
          init(broadcast.id);
        }
        return null;
    }
    
      
    public Pagereference clear(){
        
        broadcast = new Broadcasts__c();
        staffName  ='';
        urgencyName='';
        categoryName='';
        toUserName= '';
        fromUserName= '';
        statusName='';
        impactName='';
        priorityName='';
        firstName='';
        lastName='';
        postDate='';
      
        return null;
    }
    
    public Pagereference newBroadcast(){
        
        broadcast = new Broadcasts__c();
        /*staffName  ='';
        urgencyName='';
        categoryName='';
        toUserName= '';
        fromUserName= '';
        statusName='';
        impactName='';
        priorityName='';
        firstName='';
        lastName='';
        postDate='';
        
       */
        init(null);
        
        return null;
    }
    
    public Pagereference broadcastAssignToMyself(){
        
        broadcast.FKUserIdAssignedTo__c = Userinfo.getUserId();
        staffName  = Userinfo.getName();
        firstName=Userinfo.getFirstName();
        lastName=Userinfo.getLastName();
        closeState = false;
      reOpenState = true;
        assignMyselfState = true;
        assignStaffState = false;
        assignSuggestedStaffState = false;
        assignGroupState = false;
        assignMemberOfGroupState = false;
        selectFromState = false;
        selectToState = false;
        clearAssignState = false;
        return null;
    }
    
    public Pagereference broadcastAssignToStaff(){
        
         if(staffName != null && staffName != ''){
            
            listFieldNames = new List<String>();
            queryCondition = new ConditionBuilder();
            driverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            listFieldNames.add('FirstName');
            listFieldNames.add('LastName');
            
            queryCondition.setCondition('Id = \'' + staffName + '\'');
            List<User> usersList = (List<User> ) driverAccess.selectObjects(new User(), listFieldNames, queryCondition, null);
            
            if(usersList.size() >0){
               
                broadcast.FKUserIdAssignedTo__c = usersList[0].Id;
                staffName = usersList[0].Name;
                firstName=usersList[0].FirstName;
                lastName=usersList[0].LastName;
                assignStaffState = false;
              assignSuggestedStaffState = false;
              assignGroupState = false;
              assignMemberOfGroupState = false;
              selectFromState = false;
            selectToState = false;              
              clearAssignState = false;  
              closeState = false;
          reOpenState = true;          
              if(broadcast.FKUserIdAssignedTo__c == Userinfo.getUserId()){
                assignMyselfState = true;
              }else{
                assignMyselfState = false;
              }
              
            }
        }
        return null;    
    }
    
    public Pagereference broadcastAssignToClear(){
        
        broadcast.FKUserIdAssignedTo__c = null;
        firstName = '';
        lastName = '';
        staffName  = '';
        assignStaffState = false;
        assignSuggestedStaffState = false;
        assignGroupState = false;
        assignMemberOfGroupState = false;
        assignMyselfState = false;
        selectFromState = false;
        selectToState = false;
        clearAssignState = true;
        return null;
    }
      
    public PageReference reOpenBroadcast(){
        
        driverAccess = new DriverAccess();
        ConditionBuilder conditionBuilder= new ConditionBuilder();
        List<String> lstOutputFields = new List<String>();
     
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');
         
        String condition = 'state__c =true AND defaultStatus__c =true AND appliesToBroadcasts__c = true';
        conditionBuilder.setCondition(condition); 
        Status__c tempStatus = new Status__c();
       
        List<Status__c> statusList = (List<Status__c>) driverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);

        if(statusList.size() > 0){
            broadcast.FKStatus__c =  statusList[0].Id;
            broadcast.state__c =  statusList[0].state__c;
            statusName = statusList[0].Name;
        }
      
        conditionBuilder.setCondition('Id =\''+ broadcast.Id + '\'');
        
        closeState = false;
    reOpenState = true;
    selectToState = false;
    selectFromState = false;
    assignStaffState = false;
    assignSuggestedStaffState = false;
    assignGroupState = false;
    assignMemberOfGroupState = false;
    assignMyselfState = false;
    clearAssignState = true;
    if(broadcast.FKUserIdAssignedTo__c != null){
      clearAssignState = false;
      if(broadcast.FKUserIdAssignedTo__c == Userinfo.getUserId()){
        assignMyselfState = true;
      }
    
    }
    
        driverAccess.updateObject(broadcast,conditionBuilder, null);
       
        return null;
    }
    public Pagereference callInit(){
        init(currentBroadCastId);
      return null;
    }
    
     public Pagereference calculatePriority(){
        
       List <Priority__c> broadcastPriority= null;
       driverAccess = new DriverAccess();
       ConditionBuilder conditionBuilder= new ConditionBuilder();
       List<String> lstOutputFields = new List<String>();
       lstOutputFields = new List<String>();

       lstOutputFields.add('Name');
       lstOutputFields.add('FKUrgency__c');
       lstOutputFields.add('FKImpact__c');
       lstOutputFields.add('FKUrgency__r.ID');
       lstOutputFields.add('FKUrgency__r.Name');
       lstOutputFields.add('FKImpact__r.ID');
       lstOutputFields.add('FKImpact__r.Name');
       lstOutputFields.add('priorityDuration__c');
       
       
       String queryString = null;
        if(broadcast!=null && broadcast.urgencyId__c != null && broadcast.impactId__c != null) {
           queryString='urgencyId__c =' +'\''+broadcast.urgencyId__c+'\' and  impactId__c =' +'\''+broadcast.impactId__c+'\'';
            conditionBuilder.setCondition(queryString);
            broadcastPriority = (List<Priority__c>) driverAccess.selectObjects(new Priority__c(),lstOutputFields,conditionBuilder,null);
      
          if(broadcastPriority!=null && broadcastPriority.size() > 0 && broadcast != null){     
                          
             broadcast.priorityId__c = broadcastPriority[0].Name;
             broadcast.FKPriority__c = broadcastPriority[0].Id;


        }else{
             broadcast.priorityId__c = null;
             broadcast.FKPriority__c = null;
       }
      }
     return null;
    }
    
     
  public class StageBox{                
        public String tip {get;set;}        
        public DateTime changeDate {get;set;}        
        public String image {get;set;}        
        public String name {get;set;}                
        public StageBox(){}
    } 
    public list<StageBox> getStageBoxes(){
       if(stageBoxes == null){
           populateStageBoxes();
       }
       return stageBoxes;
    }


    public void populateStageBoxes(){

        stageBoxes = new list<StageBox>(); 
        boolean currentStageFound = false; 

        
        StageBox stageBox = new StageBox();
        stageBox.name = 'Open';
        stageBox.image = SKIPPED_IMAGE;
        stageBoxes.add(stageBox);            
        
        StageBox stageBox1 = new StageBox();
        stageBox1.name = 'Acknowleged';
        stageBox1.image = CURRENT_IMAGE;
        stageBoxes.add(stageBox1);            
        
        StageBox stageBox2 = new StageBox();
        stageBox2.name = 'In Progress';
        stageBox2.image = DONE_IMAGE;
        stageBoxes.add(stageBox2);            
        
        StageBox stageBox3 = new StageBox();
        stageBox3.name = 'Closed';
        stageBox3.image = SKIPPED_IMAGE;
        stageBoxes.add(stageBox3);                    

    }
public Pagereference previousBtnHandler(){
        if(broadcast!=null){
          CommonUI commonUiObj=new CommonUI();
            broadcast = (Broadcasts__c)commonUiObj.getSobject(broadcast, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(broadcast!=null){
          
          CommonUI commonUiObj=new CommonUI();
            broadcast = (Broadcasts__c)commonUiObj.getSobject(broadcast, tempString, columnName, direction, 'next');
        }
        return null;
    }
    
  
}
			                            	