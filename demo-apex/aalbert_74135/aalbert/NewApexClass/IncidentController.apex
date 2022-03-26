public class IncidentController {

  public boolean showindebuglog = true;
  public string modulename = 'Incident';
    public String DONE_IMAGE = 'status_done.gif';

    public String CURRENT_IMAGE = 'status_current.gif';

    public String UN_DONE_IMAGE = 'status_undone.gif';

    public String SKIPPED_IMAGE = 'status_undone.gif';
    
    public Category__c category{get; set;}
    public   Organization__c organization{get; set;}
    public   boolean isState{get; set;}
    public   boolean iscalculatePriority = false;
    boolean firstCall = true;
    // utility class object
    public SkyWalkerUtility utility = new SkyWalkerUtility();
    // exception handler
    public SkyExceptionHandler exceptionmanager = new SkyExceptionHandler('IncidentController.cls');
    
    List <Priority__c> incidentPriority;
    
    String closeStatus;
    String incidentId;
    Boolean closeState = true;
    Boolean reOpenState = true; 
    Boolean assignStaffState = false;
    Boolean assignSuggestedStaffState = false;
    Boolean assignSelectedProfileState = false;
    Boolean assignMemberOfAdminState = false;
    Boolean assignMyselfState = false;
    Boolean respondedState = true;    
    Boolean clearAssignState = true;      
    
    String columnName='Name';
    String direction= 'ASC';
    public String strId = null;
    public String queue {get; set;}
    public String tempString {get; set;}
    public String templateId {get; set;}
    public Map<String,String> mapForTemplate {get; set;}
    Boolean flagForTemplate = true;
  
  public Boolean getFlagForTemplate(){        
        return this.flagForTemplate;   
    }
    
    public void setFlagForTemplate(Boolean flagForTemplate){        
        this.flagForTemplate = flagForTemplate;   
    }
    
    
    public void setIscalculatePriority(boolean iscalculatePriority){
        this.iscalculatePriority = iscalculatePriority;
    }
    public boolean getIscalculatePriority(){
        return iscalculatePriority ;
    }
    public void setStrId(Id id){
        this.strId = id;
    }
    public String getStrId(){
        return strId ;
    }
    
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
    
    public Boolean getAssignSelectedProfileState(){        
        return assignSelectedProfileState;   
    }
    
    public void setAssignSelectedProfileState(Boolean assignSelectedProfileState){        
        this.assignSelectedProfileState = assignSelectedProfileState;   
    }
    
    public Boolean getAssignMemberOfAdminState(){        
        return assignMemberOfAdminState;   
    }
    
    public void setAssignMemberOfAdminState(Boolean assignMemberOfAdminState){        
        this.assignMemberOfAdminState = assignMemberOfAdminState;   
    }
    
    public Boolean getRespondedState(){        
        return respondedState ;   
    }
    
    public void setRespondedState(Boolean respondedState ){        
        this.respondedState  = respondedState ;   
    }
    
    public Boolean getClearAssignState(){        
        return clearAssignState ;   
    }
    
    public void setClearAssignState(Boolean clearAssignState ){        
        this.clearAssignState  = clearAssignState ;   
    }
    
    public String messageString {get; set;}
    public String broadcastNote {get; set;}
    public List<Category__c> categoryList;
    public List<Impact__c> impactList;
    public List<Urgency__c> urgencyList;
    public List<User> userList ;
    List<Priority__c> priorityList;
    public List<Broadcasts__c> broadcastList;
     public List<Priority__c> priorityObjList;
    public List<Status__c> statusList;
    public String savedID = null;
    List<Client__c> clients;
    public Incident__c incident;
    public Client__c client;
    public Client__c[] clientArray;
    public User user;
    public List<Incident__c> incidentList; 
    String [] urgencyTypeList;
    public Boolean displayClientComments;
    
    /* ********* Variables Declared for Driver Access class user ******** */
    public List<String> lstOutputFields;
    public String condition;
    public ConditionBuilder conditionBuilder ;
    public DriverAccess objDriverAccess;
    
    public Integer counter=0;
    
    public Integer getCounter(){
        return counter;
    }
    public void setCounter(Integer counter){
        this.counter=counter;
    }
    public class StageBox{                
        public String tip {get;set;}        
        public DateTime changeDate {get;set;}        
        public String image {get;set;}        
        public String name {get;set;}                
        public StageBox(){}
    }        
    
    private list<StageBox> stageBoxes = null;        

    public list<StageBox> getStageBoxes(){
       if(stageBoxes == null){
           populateStageBoxes();
       }
       return stageBoxes;
    }

    
    public PageReference dummyFunction(){
        return null;    
    }
    
    // controller function
    public IncidentController(){ 
        client = new Client__c();
        incident = new Incident__c();
        incident.call__c = Integer.valueOf(0);           
        user = new User();
        DriverAccess driverAccess = new DriverAccess();
        ConditionBuilder conditionBuilder = new ConditionBuilder();
        
        List<String> listFields = utility.ConvertCSVToList('Id,Name,state__c,defaultStatus__c');
        
        String queryString = 'state__c = false and ' + 'defaultStatus__c = true and ' + 'appliesToTask__c = true';
    
        conditionBuilder.setCondition(queryString);
        Status__c status = new Status__c();
    
        try {
          List<Status__c> defaultStatus = 
            (List<Status__c>) driverAccess.selectObjects(status,listFields,conditionBuilder,null);                
          if(defaultStatus.size() > 0) {            
              closeStatus = defaultStatus[0].Name;
          }
          flagForTemplate=true;
          incidentId = ApexPages.CurrentPage().getParameters().get('id');
          String copyId = ApexPages.CurrentPage().getParameters().get('copyId');
          columnName = ApexPages.CurrentPage().getParameters().get('columnField');
          direction = ApexPages.CurrentPage().getParameters().get('direction');
      //Changes for Adding IncidentPriority when added from Priority details
      //Changes made by Sujeet
      String priorty_Id = ApexPages.CurrentPage().getParameters().get('Priorityid');
      incident.FKPriority__c = priorty_Id;
      List<Priority__c> lstPriority;
      if(priorty_Id != null && priorty_Id != ''){
        String qryString = 'Id = '+'\''+priorty_Id+'\'';
        conditionBuilder.setCondition(qryString);
        lstPriority = (List<Priority__c>)driverAccess.selectObjects(new Priority__c(), null, conditionBuilder, null);
        incident.priorityId__c = lstPriority[0].Name;
      }
      //Changes End here//
      
       //Changes for Adding Category when added from category details
          //Changes made by Sujeet
          String category_Id = ApexPages.CurrentPage().getParameters().get('Categoryid');
          incident.FKCategory__c = category_Id;
          List<Category__c> lstCategory;
          if(category_Id != null && category_Id != ''){
            String qryString = 'Id = '+'\''+category_Id+'\'';
          conditionBuilder.setCondition(qryString);
          lstCategory = (List<Category__c>)driverAccess.selectObjects(new Category__c(), null, conditionBuilder, null);
          incident.categoryId__c = lstCategory[0].Name;
          }
          //Changes Ends here//
          
           //Changes for Adding Category when added from category details
          //Changes made by Sujeet
          String broadcast_Id = ApexPages.CurrentPage().getParameters().get('BroadcastsId');
          incident.FKBroadcast__c = broadcast_Id;
          List<Broadcasts__c> lstBrdCast;
          if(broadcast_Id != null && broadcast_Id != ''){
            String qryString = 'Id = '+'\''+broadcast_Id+'\'';
            conditionBuilder.setCondition(qryString);
            lstBrdCast= (List<Broadcasts__c>)driverAccess.selectObjects(new Broadcasts__c(), null, conditionBuilder, null);
            
            if(lstBrdCast!=null && lstBrdCast.size()>0){
                incident.broadcastId__c = lstBrdCast[0].Name;
                incident.categoryId__c = lstBrdCast[0].categoryId__c;
            }
          }
          
          
           //Changes for Adding Category when added from category details
          //Changes made by Sujeet
          String client_Id = ApexPages.CurrentPage().getParameters().get('ClientId');
          incident.FKClient__c = client_Id;
          List<Client__c> lstClt;
          List<String> fldList = new List<String>();
          fldList.add('id');
          fldList.add('name');
          fldList.add('firstName__c');
          fldList.add('lastName__c');
          fldList.add('FKOrganization__c');
          fldList.add('FKUrgency__c');
          fldList.add('FKUrgency__r.name');
          fldList.add('FKOrganization__r.name');
          fldList.add('phone__c');
          fldList.add('ext__c');
          if(client_Id != null && client_Id != ''){
            String qryString = 'Id = '+'\''+client_Id+'\'';
            conditionBuilder.setCondition(qryString);
            lstClt= (List<Client__c>)driverAccess.selectObjects(new Client__c(), fldList, conditionBuilder, null);
            
            if(lstClt!=null && lstClt.size()>0){
                incident.clientId__c = lstClt[0].Name;
                client = lstClt[0];
            }
                //incident.categoryId__c = lstClt[0].categoryId__c;
          }
          
      
          if(incidentId!=null  || (copyId !=null && copyId != '')){
            String condition = 'id = '+'\'' + incidentId + '\'';
              conditionBuilder.setCondition(condition);
            
              listFields.clear();
              listFields = utility.ConvertCSVToList('id,Name,clientId__c,categoryId__c,incidentDescription__c,' + 
                'incidentResolution__c,firstCallResolution__c,inactive__c,statusId__c,impactId__c,urgencyId__c,' +
                'priorityId__c,openDateTime__c,respondedDateTime__c,dueDateTime__c,closeDateTime__c,' +
                'timeSpent__c,broadcastId__c,note__c,FKAssignedTo__c,assignedToUserId__c,supplierName__c,' + 
                'call__c,state__c,FKClient__c,FKCategory__c,FKImpact__c,FKUrgency__c,FKStatus__c,FKBroadcast__c,'+
          'FKStatus__r.Name,OwnerId,Owner.name');
              
              condition ='';
              if((copyId !=null && copyId != '')){
                condition='Id =' +'\''+copyId+'\'';  
              }else {
                condition ='Id =' +'\''+incidentId+'\'';  
              }
              conditionBuilder.setCondition(condition);                
              incidentList = (List<Incident__c>)driverAccess.selectObjects(new Incident__c(), listFields, conditionBuilder, null);
              if((incidentList !=null && incidentList.size() > 0) && (copyId !=null && copyId != '')){
                incident = incidentList[0];
                queue = incident.owner.name;
                  system.debug('-------------------------In  incident constructor---and id is -in if ----' + incident.id);
                  copy();
              }else if(incidentList !=null && incidentList.size() > 0){
                incident = incidentList[0];
                 system.debug('-------------------------In  incident constructor---and id is --in else---' + incident.id); 
                  if(incident.call__c!=null){
                    counter=Integer.valueOf(''+incident.call__c);
                }
                strId = incident.Id;
                if(incident!=null && incident.clientId__c != null && incident.clientId__c!= ''){
                  condition = 'Name = '+'\'' + incident.clientId__c + '\'';
                    conditionBuilder.setCondition(condition);                   
                    listFields = utility.ConvertCSVToList('id,Name,FirstName__c,LastName__c,Phone__c,' +
                      'ext__c,City__c,OrganizationName__c,organizationId__c,displayClientComments__c,' +
                      'FKOrganization__r.id,FKOrganization__r.Name,FKOrganization__r.organizationName__c');
                     
                  List<Client__c>  clientList = 
                      (List<Client__c>)driverAccess.selectObjects(new Client__c(), listFields, conditionBuilder, null);
                                                            
            if(clientList.size() > 0){
                      client = clientList[0];
                        client.organizationId__c = client.FKOrganization__r.Name;
                    }
          }
          if(incident!=null && incident.assignedToUserId__c != null && incident.assignedToUserId__c != ''){
                              condition = 'Name = '+'\'' + incident.assignedToUserId__c + '\'';
                                conditionBuilder.setCondition(condition);                 
                            
                              listFields = new List<String>();
                                    listFields.add('id');
                                    listFields.add('Name');
                                    listFields.add('FirstName');
                                    listFields.add('LastName');
                                    listFields.add('Phone');
                                    listFields.add('Extension');
                              listFields.add('ProfileId');
                              listFields.add('Profile.Name');
                              
                              userList =  (List<User>)driverAccess.selectObjects(new User(), listFields, conditionBuilder, null);
                             if(userList.size()> 0){
                                incident.FKAssignedTo__c  = userList[0].id ; 
                                incident.assignedToUserId__c = userList[0].Name ; 
                                user = userList[0];
                                queue = null;
                                Incident.ownerId =user.id ;      
                            }
                     }
                     if(incident!=null && incident.FKBroadcast__c != null){
                  
                  condition = 'Id = '+'\'' + incident.FKbroadcast__c + '\'';
                      conditionBuilder.setCondition(condition);
                                  
                      listFields = new List<String>();
                        listFields.add('id');
                          listFields.add('Name');
                          listFields.add('note__c');
                              
                          broadcastList =  (List<Broadcasts__c>)driverAccess.selectObjects(new Broadcasts__c(), listFields, conditionBuilder, null);
                          
                          if(broadcastList.size()> 0){
                    incident.broadcastId__c = broadcastList[0].Name;
                    //Incident.broadcastNote__c = broadcastList[0].note__c;
                    broadcastNote = broadcastList[0].note__c;
                          }
                     }  
                    if(incident!=null && incident.OwnerId != null){
                                listFields.clear();    
                        listFields.add('Id');
                        listFields.add('Name');
                        listFields.add('Owner.Name');
                        
                        condition = null;
                        condition = 'Id = \'' + incident.OwnerId+ '\'';
                        conditionBuilder.setCondition(condition);
                    
                        List<Group> groupList = (List<Group> ) driverAccess.selectObjects(new Group(), listFields, conditionBuilder, null);
                        
                        if(groupList.size() >0){
                            queue = groupList[0].Name;                          
                        }
                            }    
                if(incident.FKStatus__r.Name == closeStatus){
                  closeState = true;
                    assignStaffState = true;
                    assignSuggestedStaffState = true;
                    assignSelectedProfileState = true;
                    assignMemberOfAdminState = true;
                    assignMyselfState = true;
                    respondedState = true;
                    reOpenState = false;                    
          }else{
                  closeState = false;
                    assignStaffState = false;
                    assignSuggestedStaffState = false;
                    assignSelectedProfileState = false;
                    assignMemberOfAdminState = false;
                    assignMyselfState = false;
                    clearAssignState = true;                                
                    if(incident.FKAssignedTo__c != null){
                      clearAssignState = false;                                   
                        if(incident.FKAssignedTo__c == Userinfo.getUserId()){
                          assignMyselfState = true;
                        }
                    }
                    respondedState = false;
                    reOpenState = true;
          }                         
                strId = incident.Id;
        } 
      }else{
          flagForTemplate=false;
          incident.openDateTime__c = system.now();
            lstOutputFields = null;
            lstOutputFields = utility.ConvertCSVToList('Id,Name,state__c,defaultStatus__c,appliesToIncident__c');
        condition = null;   
            condition = 'state__c = true and ' + 'defaultStatus__c = true and ' + 'appliesToIncident__c = true';
            conditionBuilder.setCondition(condition); 
            Status__c tempStatus = new Status__c();
            List<Status__c> statuses = 
              (List<Status__c>) driverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
            if(statuses.size() > 0){
              incident.FKStatus__c =  statuses[0].id;
                incident.statusId__c = statuses[0].Name;
                incident.state__c=statuses[0].state__c;
            }
      }
        }
        catch(Exception e) {
          exceptionmanager.handleException(e, modulename, 
        'IncidentController', showindebuglog, false);
        }  
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
    
    public Pagereference calculatePriority(){
    incidentPriority= null;
         objDriverAccess = new DriverAccess();
         conditionBuilder = new ConditionBuilder();
         string fieldlist = 'Id,Name,FKUrgency__c,FKImpact__c,FKUrgency__r.ID,FKUrgency__r.Name,'+
           'FKImpact__r.ID,FKImpact__r.Name,priorityDuration__c';
         lstOutputFields = utility.ConvertCSVToList(fieldlist);
        
         System.debug('Inside Calculate Priority---------------------------');

         String queryString = null;
         try {
      if(incident!=null && incident.urgencyId__c != null 
        && incident.impactId__c != null) {
               queryString = 'urgencyId__c =' + '\'' + incident.urgencyId__c +
                 '\' and  impactId__c =' + '\'' + incident.impactId__c + '\'';
              conditionBuilder.setCondition(queryString);
              incidentPriority = 
                (List<Priority__c>) objDriverAccess.selectObjects(new Priority__c(),
                  lstOutputFields,conditionBuilder,null);
               System.debug('incidentPriority ----------------> ' + incidentPriority.size());
      
             if(incidentPriority!=null && incidentPriority.size() > 0 && incident != null){     
                incident.priorityId__c = incidentPriority[0].Name;
                 incident.FKPriority__c = incidentPriority[0].Id;
                 if(incident.openDateTime__c != null){
                   Datetime dDate = incident.openDateTime__c.addMinutes
                    (Integer.valueOf(incidentPriority[0].priorityDuration__c)) ;
                  incident.dueDateTime__c = dDate;
                 }       
        }else{
                incident.priorityId__c = null;
                 incident.FKPriority__c = null;
                 incident.dueDateTime__c = null;
             }
      }
         }
         catch(Exception e) {
           exceptionmanager.handleException(e, modulename, 
        'calculatePriority', showindebuglog, true);           
         }
       return null;
    }
     
     public String getIncidentId(){
        this.incidentId = ApexPages.CurrentPage().getParameters().get('Id');
      return this.incidentId;   
    }
    
     public void setIncidentId(String incidentId){
            this.incidentId = incidentId;   
     }
     public Boolean getDisplayClientComments() {
        return displayClientComments;
    }     
        
    public void setDisplayClientComments(Boolean displayClientComments){
        this.displayClientComments= displayClientComments;
    }
     
    public String  getSavedID(){
        return savedID ;
    }
    public void setSavedID(String  savedID){
        system.debug('---------------In Set save -----------'  + savedID);
        this.savedID = savedID;
    }
    public void setClient(Client__c client){
         this.client= client;
    }
    public client__c getClient(){
        return client;
    }
    public Incident__c getIncident() {
        
        return incident;
    }
    public void setIncident(Incident__c incident){
        this.incident= incident;
    }
    public User getUser() {
        return user;
    }
    public void setUser(User user){
        this.user= user;
    }
    
    public List<client__c> getClients() {
          clients = [select id,name,FirstName__c,LastName__c,Phone__c,ext__c,City__c,displayClientComments__c from client__c  ];
          return clients;
    }
     ///************ Code By Vilas **********************///
     public Pagereference respondedBtnHandler(){
        incident.respondedDateTime__c = system.now();
        return null;
    }
    
    public Pagereference myselfBtnHandler(){
        user= [select u.Id, u.FirstName, u.ProfileId,u.Profile.Name from User u where u.Id=:Userinfo.getUserId()];
        //user.FirstName = userObj.FirstName;
        //user.ProfileId=userObj.ProfileId;
        
        return null;
    }
    public Pagereference callCounterBtnHandler(){
         if(incident.call__c!=null){
            counter = counter+1;
             incident.call__c=incident.call__c+1;
         
         } else{
            counter = counter+1;
             incident.call__c=1;
         }  
            //counter =counter+1;    
         return null;
    }
    
    /// ************************************************///
    public PageReference save() {
      try{
                 
            DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
        
            if(incident.clientId__c != null  && incident.clientId__c != ''){
        String condition = 'Name = '+'\'' + incident.clientId__c + '\'';
                conditionBuilder.setCondition(condition);
                List<String> listFields = utility.ConvertCSVToList('id,FKOrganization__c');
                List<Client__c> clientList = 
                  (List<Client__c>)driverAccess.selectObjects(new Client__c(), listFields, conditionBuilder, null);
                if(clientList.size()!=0){
                  incident.FKclient__c = clientList[0].id ;
                    incident.FKOrganization__c = clientList[0].FKOrganization__c;        
        }  
            }else{
                incident.FKclient__c = null;
            }
            if(incident.categoryId__c != null && incident.categoryId__c != ''){
        String condition = 'Name = '+'\'' + incident.categoryId__c + '\'';
                conditionBuilder.setCondition(condition);
                List<String> listFields = utility.ConvertCSVToList('id');
                categoryList = (List<Category__c>)driverAccess.selectObjects(new Category__c(), listFields, conditionBuilder, null);
                //categoryList = [select id,Name from Category__c where id =:incident.categoryId__c];
                if(categoryList.size()> 0){
                  incident.FKCategory__c = categoryList[0].id ;        
                } 
            }else{
                incident.FKCategory__c = null;
            }
            if(incident.impactId__c != null && incident.impactId__c != ''){
        String condition = 'Name = '+'\'' + incident.impactId__c + '\'';
                conditionBuilder.setCondition(condition);
                List<String> listFields = utility.ConvertCSVToList('id');
                impactList = (List<Impact__c>)driverAccess.selectObjects(new Impact__c(), listFields, conditionBuilder, null);            
                //impactList = [select id,Name from Impact__c where Name =:incident.impactId__c];
                if(impactList.size()> 0){
                  incident.FKImpact__c = impactList[0].id ;        
                }
            }else{
                incident.FKImpact__c = null;
            }
            if(incident.urgencyId__c != null && incident.urgencyId__c != ''){ 
        String condition = 'Name = '+'\'' + incident.urgencyId__c + '\'';
                conditionBuilder.setCondition(condition);
                List<String> listFields = utility.ConvertCSVToList('id');
                urgencyList = (List<Urgency__c>)driverAccess.selectObjects(new Urgency__c(), listFields, conditionBuilder, null);           
                if(urgencyList.size()> 0){
                  incident.FKUrgency__c = urgencyList[0].id ;        
                }
            }else{
                incident.FKUrgency__c = null;
            }
            if(Incident.priorityId__c != null && Incident.priorityId__c != ''){ 
        String condition = 'Name = '+'\'' + Incident.priorityId__c + '\'';
                conditionBuilder.setCondition(condition);
                List<String> listFields = utility.ConvertCSVToList('id');
                priorityList = 
                  (List<Priority__c>)driverAccess.selectObjects(new Priority__c(), listFields, conditionBuilder, null);           
                     
                if(priorityList.size()> 0){
                  incident.FKPriority__c = priorityList[0].id ;        
                }
            }else{
                incident.FKPriority__c = null;
            }
            if(Incident.statusId__c != null && Incident.statusId__c != ''){ 
              String condition = 'Name = '+'\'' + Incident.statusId__c + '\'';
                conditionBuilder.setCondition(condition);
                List<String> listFields = utility.ConvertCSVToList('id,State__c');
                statusList = 
                  (List<Status__c>)driverAccess.selectObjects(new Status__c(), listFields, conditionBuilder, null);           
                
                if(statusList.size()> 0){
                  incident.FKStatus__c = statusList[0].id ;
                    incident.State__c = statusList[0].state__c ;
                }
            }else{
                incident.FKStatus__c = null;
            }
            if(Incident.assignedToUserId__c != null && Incident.assignedToUserId__c != ''){ 
                     String condition = 'Name = '+'\'' + Incident.assignedToUserId__c + '\'';
                     conditionBuilder.setCondition(condition);
                     List<String> listFields = new List<String>();
                     listFields.add('id');
                     listFields.add('Name');
                     //listFields.add('State__c');                     
                     userList = (List<User>)driverAccess.selectObjects(new User(), listFields, conditionBuilder, null);           
                     
                     if(userList.size()> 0){
                           incident.FKAssignedTo__c  = userList[0].id ; 
                           incident.assignedToUserId__c = userList[0].Name ;  
                           
                     }
            }else{
                incident.FKAssignedTo__c = null;
            }
            if(Incident.broadcastId__c!= null && Incident.broadcastId__c != ''){ 
                     String condition = 'Name = '+'\'' + Incident.broadcastId__c + '\'';
                     conditionBuilder.setCondition(condition);
                     List<String> listFields = new List<String>();
                     listFields.add('id');
                     listFields.add('Name');
                     //listFields.add('State__c');                     
                     broadcastList = (List<Broadcasts__c>)driverAccess.selectObjects(new Broadcasts__c(), listFields, conditionBuilder, null);           
                     
                     if(broadcastList.size()> 0){
                           incident.FKBroadcast__c  = broadcastList[0].id ; 
                           incident.broadcastId__c = broadcastList[0].Name ;  
                           
                     }
            }else{
                incident.FKBroadcast__c = null;
            }         
            incident.FKTemplate__c = templateId;       
          upsert incident;
          String condition = 'id = '+'\'' + incident.Id + '\'';
            conditionBuilder.setCondition(condition);
          
          List<String> listFields = utility.ConvertCSVToList('id,Name,clientId__c,categoryId__c,' +
            'incidentDescription__c,incidentResolution__c,firstCallResolution__c,inactive__c,' +
            'statusId__c,impactId__c,urgencyId__c,priorityId__c,openDateTime__c,respondedDateTime__c,' +
            'dueDateTime__c,closeDateTime__c,timeSpent__c,broadcastId__c,note__c,FKAssignedTo__c,' +
            'assignedToUserId__c,supplierName__c,call__c,CreatedDate,state__c,FKClient__c,FKCategory__c,' +
            'FKImpact__c,FKUrgency__c,FKStatus__c,FKStatus__r.Name,OwnerId,Owner.name'
            );
            
            incidentList = (List<Incident__c>)driverAccess.selectObjects(new Incident__c(), listFields, conditionBuilder, null);
            
            if(incidentList.size() > 0 ){
                incident = incidentList[0]; 
                if(incident.call__c != null){
                 counter=Integer.valueOf(''+incident.call__c);
                }
                
            } 
            if(incident.clientId__c != null && incident.clientId__c!= ''){
        condition = 'Name = '+'\'' + incident.clientId__c + '\'';
                conditionBuilder.setCondition(condition);                   
                
                listFields = utility.ConvertCSVToList('id,Name,FirstName__c,LastName__c,Phone__c,ext__c,' + 
                  'City__c,OrganizationName__c,organizationId__c,displayClientComments__c,' +
                  'FKOrganization__r.id,FKOrganization__r.Name,FKOrganization__r.organizationName__c');
                  
                List<Client__c>  clientList = (List<Client__c>)driverAccess.selectObjects(new Client__c(), listFields, conditionBuilder, null);
                if(clientList.size() > 0){
                  client = clientList[0];
                    client.organizationId__c = client.FKOrganization__r.Name;
        }
      }  
          if(incident.FKStatus__r.Name == closeStatus){
              closeState = true;
              assignStaffState = true;
              assignSuggestedStaffState = true;
              assignSelectedProfileState = true;
              assignMemberOfAdminState = true;
              assignMyselfState = true;
              respondedState = true;
              clearAssignState = true;
              reOpenState = false;                    
          }else{
              closeState = false;
              assignStaffState = false;
              assignSuggestedStaffState = false;
              assignSelectedProfileState = false;
              assignMemberOfAdminState = false;
              assignMyselfState = false;
              clearAssignState = true;            
              if(incident.FKAssignedTo__c != null){
                  clearAssignState = false;               
                  if(incident.FKAssignedTo__c == Userinfo.getUserId()){                    
                      assignMyselfState = true;
                  }
              }
              respondedState = false;
              reOpenState = true;                                          
          }       
          
          //Changes By Sujeet Palwar
          if(templateId != null && templateId != '' && firstCall){
            String templateCondition = 'parentTemplateId__c='+'\''+templateId+'\' order by orderNumber__c';
            List<String> lstFields = new List<String>(); 
            System.debug('=====================----templateId------------->>>>>>>>>'+templateId);
            lstFields.add('name');
            lstFields.add('id');
            lstFields.add('linkedTemplateId__c');
            lstFields.add('orderNumber__c');
            lstFields.add('parentTemplateId__c');
            conditionBuilder.setCondition(templateCondition); 
            List<SYSTemplateLink__c>  temList = (List<SYSTemplateLink__c>)driverAccess.selectObjects(new SYSTemplateLink__c(), lstFields, conditionBuilder, null);
            System.debug('=====================----temList------------->>>>>>>>>'+temList);           
                   String incidentId =   incident.Id;
                   if(incidentId.length()>15){
                       incidentId.substring(0, 15);
                   }
                   String templateId =   temList[0].linkedTemplateId__c;
                   if(templateId.length()>15){
                       templateId.substring(0, 15);
                   }
            Task__c relatedTask = new Task__c();
            relatedTask.FKIncident__c = incidentId;
            relatedTask.incidentId__c = incident.name;
        relatedTask.FKTemplate__c = templateId;
            CommonUI commonUiObj=new CommonUI();
            relatedTask = (Task__c)commonUiObj.getTemplateData(relatedTask,temList[0].linkedTemplateId__c);
        System.debug('=====================----relatedTask------------->>>>>>>>>'+relatedTask); 
        upsert relatedTask;
        firstCall = false;
          }
          //Changes end here
          
          
                 
          messageString = validationHelper.getSavedMessage();
    } catch(Exception e){
          if(ApexPages.hasMessages()){
              messageString = validationHelper.getMessageString(ApexPages.getMessages());
            } else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
            } 
        }
    return null;
    }
        
    public PageReference newIncident() {
       
       PageReference pageReference = new PageReference('/apex/IncidentPage').setRedirect(true);
        return pageReference;
    }
    
    public PageReference clearIncident() {
                incident.FKclient__c = null;
                incident.FKCategory__c = null;
                incident.FKImpact__c = null;
                incident.FKUrgency__c = null;
                incident.FKPriority__c = null;
                
                Counter = 0;
                
                incident = new Incident__c();
                client = new Client__c();
       
        return  null;
    }
    
    public PageReference deleteIncident(){
         /*   //PageReference pageReference = null;
            system.debug('-------------------------In delete incident---and id is -----' + incident.id);
            if(incident != null && incident.id != null && incident.id != ''){
                delete incident;
                
                //pageReference = new PageReference('/apex/SearchPage?popupId=0001').setRedirect(true);
            }
            //return pageReference;
            return null;  */
            DriverAccess objDriverAccess = new DriverAccess();
            if(incident !=null && incident.Id !=null){
           System.debug('incident' + incident.Name);
              ConditionBuilder objConditionBuilder = new ConditionBuilder();
              String queryString='Id =' +'\''+incident.Id+'\'';  
              objConditionBuilder.setCondition(queryString);
              objDriverAccess.deleteObject(incident, objConditionBuilder, null);
            }
            return null;         
  } 
    
    public PageReference copyIncident(){
            
            Incident__c tempIncident = incident;
            
            incident = new Incident__c();
            
            incident.clientId__c = tempIncident.clientId__c;
            incident.categoryId__c = tempIncident.categoryId__c;
            incident.incidentDescription__c = tempIncident.incidentDescription__c;
            incident.incidentResolution__c = tempIncident.incidentResolution__c;
            incident.firstCallResolution__c = tempIncident.firstCallResolution__c;
            incident.inactive__c = tempIncident.inactive__c;
            incident.statusId__c = tempIncident.statusId__c;
            incident.impactId__c = tempIncident.impactId__c;
            incident.urgencyId__c = tempIncident.urgencyId__c;
            incident.priorityId__c = tempIncident.priorityId__c;
            incident.openDateTime__c = tempIncident.openDateTime__c;
            incident.respondedDateTime__c = tempIncident.respondedDateTime__c;
            incident.dueDateTime__c = tempIncident.dueDateTime__c;
            incident.closeDateTime__c = tempIncident.closeDateTime__c;
            incident.timeSpent__c = tempIncident.timeSpent__c;
            incident.broadcastId__c = tempIncident.broadcastId__c;
            incident.note__c = tempIncident.note__c;
            incident.assignedToUserId__c = tempIncident.assignedToUserId__c;
            //incident.supplierName__c = tempIncident.supplierName__c;
            incident.call__c = tempIncident.call__c;
                  
            incident.FKClient__c = tempIncident.FKClient__c;
            incident.FKCategory__c = tempIncident.FKCategory__c;
            incident.FKImpact__c = tempIncident.FKImpact__c;
            incident.FKUrgency__c = tempIncident.FKUrgency__c;
            incident.FKPriority__c = tempIncident.FKPriority__c;
            incident.FKStatus__c = tempIncident.FKStatus__c;      
                
            
    
        return null;        
    }   
    
     /*
      * To retrive the client based on clientID. 
      */  
    public pageReference setSelectedClientNext(){
            DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
            
            List<Client__c> clientList;
            system.debug('-------------setSelectedClientNext -----------'  + savedID);        
            if(savedID != null ){
                    String condition = 'Id = '+'\'' + savedID + '\'';
                    conditionBuilder.setCondition(condition);
                    
                    List<String> listFields = new List<String>();
                            listFields.add('id');
                            listFields.add('Name');
                            listFields.add('FirstName__c');
                            listFields.add('LastName__c');
                            listFields.add('Phone__c');
                            listFields.add('ext__c');
                            listFields.add('City__c');
                            listFields.add('OrganizationName__c');
                            listFields.add('organizationId__c');
                            listFields.add('displayClientComments__c');
                            listFields.add('FKOrganization__r.id');
                            listFields.add('FKOrganization__r.Name');
                            listFields.add('FKOrganization__r.organizationName__c');
                            
                    clientList = (List<client__c>)driverAccess.selectObjects(new client__c(), listFields, conditionBuilder, null);           
                             
                    // clientList = [select id,name,FirstName__c,LastName__c,Phone__c,ext__c,City__c,OrganizationName__c,organizationId__c,displayClientComments__c, FKOrganization__r.id, FKOrganization__r.Name, FKOrganization__r.organizationName__c from client__c where Id =:savedID ]; // incident.Seq_Client__c ];
                  
                    if(clientList.size() > 0 ){
                         client = clientList[0];
                         if(client != null){ 
                              // system.debug('-------------setSelectedClientNext -----------'  + client.FirstName__c);         
                              incident.FKOrganization__c = client.FKOrganization__r.id;
                              incident.FKclient__c = client.id;
                              Incident.clientId__c = client.Name;
                              client.organizationId__c = client.FKOrganization__r.Name;
                              // client.organizationName__c = client.FKOrganization__r.organizationName__c;
                              // incident.clientLastName__c = client.LastName__c ;
                              setDisplayClientComments(client.displayClientComments__c);
                              FetchUrgency();
                         }      
                    }                   
           }
             
       return null;     
    }
    
   public pageReference setSelectedUrgencytNext(){
        DriverAccess driverAccess = new DriverAccess();
        ConditionBuilder conditionBuilder = new ConditionBuilder();
        
        if(savedID != null ){ 
                String condition = 'Id = '+'\'' + savedID + '\'';
                conditionBuilder.setCondition(condition);
                    
                List<String> listFields = new List<String>();
                    listFields.add('id');
                    listFields.add('Name');    
                urgencyList = (List<Urgency__c>)driverAccess.selectObjects(new Urgency__c(), listFields, conditionBuilder, null);
                //urgencyList = [select id,Name from urgency__c where id =:savedID];
                if(urgencyList.size()> 0){
                             incident.FKUrgency__c = urgencyList[0].id ; 
                             Incident.urgencyId__c = urgencyList[0].Name ;
                             iscalculatePriority = true;       
                }
        }
        return null;
    }
    
    public pageReference setSelectedImpactNext(){
            DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
        
            if(savedID != null ){ 
                    String condition = 'Id = '+'\'' + savedID + '\'';
                    conditionBuilder.setCondition(condition);
                        
                    List<String> listFields = new List<String>();
                        listFields.add('id');
                        listFields.add('Name');
                    
                    impactList = (List<Impact__c>)driverAccess.selectObjects(new Impact__c(), listFields, conditionBuilder, null);
                    // impactList = [select id,Name from Impact__c where id =:savedID];
                    if(impactList.size()> 0){
                            incident.FKImpact__c = impactList[0].id ; 
                            Incident.impactId__c = impactList[0].Name ;
                            iscalculatePriority = true;       
                    }
            }
        return null;
    }
    
     public pageReference setSelectedStatusNext(){
            DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
        
            if(savedID != null ){ 
                    String condition = 'Id = '+'\'' + savedID + '\'';
                    conditionBuilder.setCondition(condition);
                        
                    List<String> listFields = new List<String>();
                        listFields.add('id');
                        listFields.add('Name');
                    
                    statusList = (List<Status__c>)driverAccess.selectObjects(new Status__c(), listFields, conditionBuilder, null);
                    // impactList = [select id,Name from Impact__c where id =:savedID];
                    if(incident!=null && statusList.size()> 0){
                            incident.FKStatus__c = statusList[0].id ; 
                            incident.statusId__c = statusList[0].Name ;       
                    }
            }
        return null;
    }
    //Sujeet changed
    public pageReference setSelectedPriorityNext(){
            DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
        
            if(savedID != null ){ 
                    String condition = 'Id = '+'\'' + savedID + '\'';
                    conditionBuilder.setCondition(condition);
                        
                    List<String> listFields = new List<String>();
                        listFields.add('id');
                        listFields.add('Name');
                    
                    priorityObjList = (List<Priority__c>)driverAccess.selectObjects(new Priority__c(), listFields, conditionBuilder, null);
                    // impactList = [select id,Name from Impact__c where id =:savedID];
                    if(incident!=null && priorityObjList.size()> 0){
                            incident.FKPriority__c = priorityObjList[0].id ; 
                            incident.priorityId__c = priorityObjList[0].Name ;       
                    }
            }
        return null;
    }
    
    public pageReference setSelectedAssignedToStaffNext(){
            DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
        
            if(savedID != null ){ 
                    String condition = 'Id = '+'\'' + savedID + '\'';
                    conditionBuilder.setCondition(condition);
                        
                    List<String> listFields = new List<String>();
                        listFields.add('id');
                        listFields.add('Name');
                        listFields.add('FirstName');
                        listFields.add('LastName');
                        listFields.add('Phone');
                        listFields.add('Extension');
                        listFields.add('ProfileId');
                        listFields.add('Profile.Name');
                        
                    
                    userList =  (List<User>)driverAccess.selectObjects(new User(), listFields, conditionBuilder, null);
                    // userList = [select id,Name,userName from User where id =:savedID];
                     if(userList.size()> 0){
                        incident.FKAssignedTo__c  = userList[0].id ; 
                        Incident.assignedToUserId__c = userList[0].Name ; 
                        user = userList[0];
                        queue = null;
                        Incident.ownerId =user.id ;      
                    }
             }
            assignStaffState = false;
            assignSuggestedStaffState = false;
            assignSelectedProfileState = false;
            assignMemberOfAdminState = false;
            assignMyselfState = false;
            if(incident.FKAssignedTo__c == Userinfo.getUserId()){
                assignMyselfState = true;
            }
            respondedState = true;    
            clearAssignState = false;
            
        return null;   
    
    }
    
    public pageReference setSelectedAssignedToMyselfNext(){
                //incident.FKAssignedTo__c = user.id;
                //user = [select firstName, lastname from user where id =: userinfo.getUserId()];
             
             DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
        
            if(savedID != null ){ 
                    String condition = 'Id = '+'\'' + userinfo.getUserId() + '\'';
                    conditionBuilder.setCondition(condition);
                        
                    List<String> listFields = new List<String>();
                        listFields.add('id');
                        listFields.add('Name');
                        listFields.add('FirstName');
                        listFields.add('LastName');
                        listFields.add('Phone');
                        listFields.add('Extension');
                        listFields.add('ProfileId');
                        listFields.add('Profile.Name');
                        
                    
                    userList =  (List<User>)driverAccess.selectObjects(new User(), listFields, conditionBuilder, null);
                    // userList = [select id,Name,userName from User where id =:savedID];
                     if(userList.size()> 0){
                        incident.FKAssignedTo__c  = userList[0].id ; 
                        Incident.assignedToUserId__c = userList[0].Name ; 
                        user = userList[0];
                        queue = null;
                        Incident.ownerId =user.id;      
                    }
             }
            assignStaffState = false;
            assignSuggestedStaffState = false;
            assignSelectedProfileState = false;
            assignMemberOfAdminState = false;
            assignMyselfState = true;           
            respondedState = true;    
            clearAssignState = false;
            
        return null;   
          
    }
    
    public pageReference setSelectedAssignedToClearfNext(){
            //Incident.assignedToUserId__c = null;
            user = null;
            assignStaffState = false;
            assignSuggestedStaffState = false;
            assignSelectedProfileState = false;
            assignMemberOfAdminState = false;
            assignMyselfState = false;
            assignMyselfState = false;          
            respondedState = true;    
            clearAssignState = false;
            queue = null;
            //incident.ownerId = null;  
        return null;
    }
    
    public pageReference setSelectedBroadcastNext(){
      if(savedID != null ){ 
        DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
        
        String condition = 'Id = '+'\'' + savedID + '\'';
            conditionBuilder.setCondition(condition);
                        
            List<String> listFields = new List<String>();
              listFields.add('id');
                listFields.add('Name');
                listFields.add('note__c');
                    
                broadcastList =  (List<Broadcasts__c>)driverAccess.selectObjects(new Broadcasts__c(), listFields, conditionBuilder, null);
                
                if(broadcastList.size()> 0){
          Incident.broadcastId__c = broadcastList[0].Name;
          //Incident.broadcastNote__c = broadcastList[0].note__c;
          broadcastNote = broadcastList[0].note__c;
                }      
      }  
      return null;  
    }  
    
  
  //--------------- check this method   setAssignedToNext()------may be added by Vilas and not used now
    public pageReference setAssignedToNext(){
            
            if(incident.AssignedToUserId__c != null){
                user = [select FirstName,LastName, extension,phone from User where id=:incident.AssignedToUserId__c ];
            }
        return null;
    }
    
    public void checkDependantLookup(client__c[] client, integer lookupCounter){
           for(integer i=0;i<lookupCounter;i++){
                 if(urgencyTypeList[i]=='Company'){
                        incident.FKurgency__c=client[0].FKOrganization__r.urgencyId__c;
                        break;
                 }
                
           }
    }
    
        public PageReference FetchUrgency(){
        List<String> lookupObjects= FetchUrgencyhierarchy();
        DriverAccess objDriverAccess = new DriverAccess();
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        String queryString='';
        List<String> lstOutputFields = new List<String>();
        Client__c client=new Client__c();
        system.debug('====##############==> '+ lookupObjects);
        
        if(incident.urgencyId__c==null || incident.urgencyId__c ==''){    
          if(urgencyTypeList!=null && urgencyTypeList.size()>0){
              for(integer i=0; i<urgencyTypeList.size();i++){
                  if(urgencyTypeList[i]=='Client' && (lookupObjects[i]!=null && lookupObjects[i]!='')){
                      lstOutputFields.add('FKUrgency__r.Id');
                      lstOutputFields.add('FKUrgency__r.Name');
                      lstOutputFields.add('Id');
                      queryString='Name=\''+lookupObjects[i]+'\''; //incident.FKClient__c';
                      objConditionBuilder.setCondition(queryString);
                      //client__c [] clientObj=
                      List<Client__c> clientObj = (List<Client__c>) objDriverAccess.selectObjects(client,lstOutputFields,objConditionBuilder,null);
                      //client__c [] clientObj=[Select FKUrgency__r.Id, FKUrgency__r.Name, Id From client__c   where Id=:incident.clientId__c];
                      if(clientObj !=null && clientObj.size()>0){
                           system.debug('########################  '+incident.FKurgency__c+' #####  '+clientObj[0].FKurgency__r.Id+'######## '+clientObj[0].FKurgency__r.Name);
                              incident.FKurgency__c=clientObj[0].FKurgency__r.Id;
                              incident.urgencyId__c=clientObj[0].FKurgency__r.Name;
                              system.debug('########################  '+incident.FKurgency__c+' #####  '+clientObj[0].FKurgency__r.Id+' ######## '+Incident.urgencyId__c);
                          return null;
                      }
                  }else if(urgencyTypeList[i]=='Category' && (lookupObjects[i]!=null || lookupObjects[i]!='')){
                      Category__c [] categoryObj=[Select c.FKurgency__r.Id, c.FKurgency__r.Name, c.Id From Category__c c where c.Name=:incident.categoryId__c];
                      if(categoryObj.size()!=0){
                          incident.urgencyId__c=categoryObj[0].FKurgency__r.Id;
                          incident.urgencyId__c=categoryObj[0].FKurgency__r.Name;
                          return null;
                      }   
                  }
        }
          }  
    }
    return null;
    }
  private List<String> FetchUrgencyhierarchy(){
            SYSProperties__c[] propertyObj=[Select s.Value__c, s.Property__c, s.Id From SYSProperties__c s where s.Property__c='propUrgencyHierarchy']; 
            system.debug('sys obj = '+propertyObj);
            List<String> lookupObjects=new List<String>();
            String lookupObj;
            
            if(propertyObj.size()!=0){
                String urgencyType=propertyObj[0].Value__c;
                urgencyTypeList=urgencyType.split(';',7);
                for(integer i=0;i<urgencyTypeList.size(); i++){
                    if(urgencyTypeList[i]=='Client'){
                        lookupObj=incident.clientId__c;
                    }else if(urgencyTypeList[i]=='Category'){ 
                        lookupObj=incident.categoryId__c;
                    }
                    /*else if(urgencyTypeList[i]=='Company'){
                        lookupObj=incident.FKOrganization__c;
                    }*/
                    lookupObjects.add(lookupObj);
                }
                
            }
          // system.debug('lookup list obj = '+lookupObjects);
            return lookupObjects;                       
                        
    }
         
    /*
        To retrive the existing incident, after selecting ID
    */
    
    public pageReference setSelectedCloseIncidentNext(){
      //try{
            DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
                      
          if(savedID != null){
            
            String condition = 'id = '+'\'' + savedID + '\'';
            conditionBuilder.setCondition(condition);
          
            List<String> listFields = new List<String>();
              listFields.add('id');
              listFields.add('Name');
              listFields.add('clientId__c');
              listFields.add('categoryId__c');
              listFields.add('incidentDescription__c');
              listFields.add('incidentResolution__c');
              listFields.add('firstCallResolution__c');
              listFields.add('inactive__c');
              listFields.add('statusId__c');
              listFields.add('impactId__c');
              listFields.add('urgencyId__c');
              listFields.add('priorityId__c');
              listFields.add('openDateTime__c');
              listFields.add('respondedDateTime__c');
              listFields.add('dueDateTime__c');
              listFields.add('closeDateTime__c');
              listFields.add('timeSpent__c');
              listFields.add('broadcastId__c');
              listFields.add('note__c');
              listFields.add('assignedToUserId__c');
              listFields.add('supplierName__c');
              listFields.add('call__c');  
              listFields.add('state__c');
              
              listFields.add('FKClient__c');
              listFields.add('FKCategory__c');
              listFields.add('FKImpact__c');
              listFields.add('FKUrgency__c');
              listFields.add('FKStatus__c');
          
          
              incidentList = (List<Incident__c>)driverAccess.selectObjects(new Incident__c(), listFields, conditionBuilder, null);
  
              if(incidentList.size() > 0){
                  incident = incidentList[0]; 
                  strId = incident.Id;
                  isState = incident.state__c;  
                  if(incident.clientId__c != null && incident.clientId__c!= ''){
                          
                          condition = 'Name = '+'\'' + incident.clientId__c + '\'';
                          conditionBuilder.setCondition(condition);                   
                      
                          listFields = new List<String>();
                              listFields.add('id');
                              listFields.add('Name');
                              listFields.add('FirstName__c');
                              listFields.add('LastName__c');
                              listFields.add('Phone__c');
                              listFields.add('ext__c');
                              listFields.add('City__c');
                              listFields.add('OrganizationName__c');
                              listFields.add('organizationId__c');
                              listFields.add('displayClientComments__c');
                              listFields.add('FKOrganization__r.id');
                              listFields.add('FKOrganization__r.Name');
                              listFields.add('FKOrganization__r.organizationName__c');
                              
                                                       
                          List<Client__c>  clientList = (List<Client__c>)driverAccess.selectObjects(new Client__c(), listFields, conditionBuilder, null);
                                                      
                          if(clientList.size() > 0){
                              client = clientList[0];
                              client.organizationId__c = client.FKOrganization__r.Name;
                          }
                      }   
                 } 
         } 
         if(incident.clientId__c == null ||incident.clientId__c ==''){
                  incident.FKClient__c=null;
              }
              if(incident.categoryId__c == null ||incident.categoryId__c ==''){
                  incident.FKCategory__c =null;
              }           
                  
              if(incident.Id == null)         {               
                  driverAccess.insertObject(incident, null);
              }
              else{               
                  driverAccess.updateObject(incident, null, null);
              }
           closeState = true;
              assignStaffState = true;
              assignSuggestedStaffState = true;
              assignSelectedProfileState = true;
              assignMemberOfAdminState = true;
              assignMyselfState = true;
              respondedState = true;
              reOpenState = false;
              
              messageString = validationHelper.getSavedMessage();
      /*}catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
            } else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
            }                                   
        }   */     
        return null;
    }
    
    public pageReference setSelectedIncidentNext(){
          DriverAccess driverAccess = new DriverAccess();
          ConditionBuilder conditionBuilder = new ConditionBuilder();
                    
        if(savedID != null){
          
          String condition = 'id = '+'\'' + savedID + '\'';
          conditionBuilder.setCondition(condition);
        
          List<String> listFields = new List<String>();
            listFields.add('id');
            listFields.add('Name');
            listFields.add('clientId__c');
            listFields.add('categoryId__c');
            listFields.add('incidentDescription__c');
            listFields.add('incidentResolution__c');
            listFields.add('firstCallResolution__c');
            listFields.add('inactive__c');
            listFields.add('statusId__c');
            listFields.add('impactId__c');
            listFields.add('urgencyId__c');
            listFields.add('priorityId__c');
            listFields.add('openDateTime__c');
            listFields.add('respondedDateTime__c');
            listFields.add('dueDateTime__c');
            listFields.add('closeDateTime__c');
            listFields.add('timeSpent__c');
            listFields.add('broadcastId__c');
            listFields.add('note__c');
            listFields.add('assignedToUserId__c');
            listFields.add('supplierName__c');
            listFields.add('call__c');  
            listFields.add('state__c');
            listFields.add('OwnerId');
            listFields.add('Owner.name');
            
            listFields.add('FKClient__c');
            listFields.add('FKCategory__c');
            listFields.add('FKImpact__c');
            listFields.add('FKUrgency__c');
            listFields.add('FKStatus__c');
        
        
            incidentList = (List<Incident__c>)driverAccess.selectObjects(new Incident__c(), listFields, conditionBuilder, null);

            if(incidentList.size() > 0){
                incident = incidentList[0]; 
                strId = incident.Id;
                isState = incident.state__c;  
                if(incident.clientId__c != null && incident.clientId__c!= ''){
                        
                        condition = 'Name = '+'\'' + incident.clientId__c + '\'';
                        conditionBuilder.setCondition(condition);                   
                    
                        listFields = new List<String>();
                            listFields.add('id');
                            listFields.add('Name');
                            listFields.add('FirstName__c');
                            listFields.add('LastName__c');
                            listFields.add('Phone__c');
                            listFields.add('ext__c');
                            listFields.add('City__c');
                            listFields.add('OrganizationName__c');
                            listFields.add('organizationId__c');
                            listFields.add('displayClientComments__c');
                            listFields.add('FKOrganization__r.id');
                            listFields.add('FKOrganization__r.Name');
                            listFields.add('FKOrganization__r.organizationName__c');
                            
                                                     
                        List<Client__c>  clientList = (List<Client__c>)driverAccess.selectObjects(new Client__c(), listFields, conditionBuilder, null);
                                                    
                        if(clientList.size() > 0){
                            client = clientList[0];
                            client.organizationId__c = client.FKOrganization__r.Name;
                        }
                    }   
               } 
       } 
              
        return null;
    }
   
   public PageReference quickClose(){
      conditionBuilder = new ConditionBuilder();      
        objDriverAccess = new DriverAccess();
        
        try{
          if(incident.clientId__c != '' && incident.categoryId__c != '') {
            
              List<String> lstOutputFields = new List<String>();              
                
                lstOutputFields.add('Id');
                
                String queryString='Name =' +'\''+incident.categoryId__c+'\'';
                conditionBuilder.setCondition(queryString);
    
                List<Category__c> categoryList = (List<Category__c>) objDriverAccess.selectObjects(new Category__c(),lstOutputFields,conditionBuilder,null);            
                
                if(categoryList.size() > 0){
                    incident.FKCategory__c = categoryList[0].Id;
                }
                
                lstOutputFields.clear();
             
                lstOutputFields.add('Id');
                lstOutputFields.add('Name');
                
                queryString='Name =' +'\''+incident.clientId__c+'\'';
                conditionBuilder.setCondition(queryString);
    
                List<Client__c> clientList = (List<Client__c>) objDriverAccess.selectObjects(new Client__c(),lstOutputFields,conditionBuilder,null);            
                
                if(clientList.size() > 0){
                    incident.FKClient__c = clientList[0].Id;
                }           
                
                lstOutputFields.clear();
             
                lstOutputFields.add('Id');
                lstOutputFields.add('Name');
                lstOutputFields.add('state__c');
                lstOutputFields.add('defaultStatus__c');
                 
                condition = null;   
                condition = 'state__c = false and ' + 'defaultStatus__c = true';
                conditionBuilder.setCondition(condition); 
                Status__c tempStatus = new Status__c();
                List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
        
                //List<Status__c> statuses = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c from Status__c s where s.state__c =:'C' and s.defaultStatus__c =: true ];
                
                if(statuses.size() > 0){
                   incident.FKStatus__r =  statuses[0];   //s.Name =:'CLOSED' and
                   incident.statusId__c = statuses[0].Name;
                   incident.state__c = statuses[0].state__c;
                }
            }           
            if(incident.clientId__c == null ||incident.clientId__c ==''){
                incident.FKClient__c=null;
            }
            if(incident.categoryId__c == null ||incident.categoryId__c ==''){
                incident.FKCategory__c =null;
            }           
                
            if(incident.Id == null)         {               
                objDriverAccess.insertObject(incident, null);
            }
            else{               
                objDriverAccess.updateObject(incident, null, null);
            }
            
            closeState = true;
            assignStaffState = true;
            assignSuggestedStaffState = true;
            assignSelectedProfileState = true;
            assignMemberOfAdminState = true;
            assignMyselfState = true;
            respondedState = true;
            reOpenState = false;
            
            messageString = validationHelper.getSavedMessage();
        } catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
            } else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
            }                                   
        } 
        //objDriverAccess.updateObject(incident, null, null);
        //upsert inc;
        return null;
    }
       
       public PageReference reopenIncident(){
      try{
            lstOutputFields = new List<String>();
            conditionBuilder = new ConditionBuilder();
            objDriverAccess = new DriverAccess();
            
            lstOutputFields = null;
            lstOutputFields = new List<String>();
         
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('state__c');
            lstOutputFields.add('defaultStatus__c');
            lstOutputFields.add('appliesToIncident__c');
             
            condition = null;   
            condition = 'state__c = true and ' + 'defaultStatus__c = true and ' + 'appliesToIncident__c = true';
            conditionBuilder.setCondition(condition); 
            Status__c tempStatus = new Status__c();
            List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
    
            //List<Status__c> statuses = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c from Status__c s where s.State__c =:'O' and s.defaultStatus__c =: true];   
            if(statuses.size() > 0){
               incident.FKStatus__c =  statuses[0].id;
               incident.FKStatus__r =  statuses[0];
               incident.statusId__c = statuses[0].Name;
               incident.state__c = statuses[0].state__c;
            } 
            
            closeState = false;
            assignStaffState = false;
            assignSuggestedStaffState = false;
            assignSelectedProfileState = false;
            assignMemberOfAdminState = false;
            assignMyselfState = false;
            clearAssignState = true;
            if(incident.FKAssignedTo__c != null){
                clearAssignState = false;           
                if(incident.FKAssignedTo__c == Userinfo.getUserId()){                
                    assignMyselfState = true;
                }
            }
            respondedState = false;
            reOpenState = true;
            if(incident.Id == null){               
                    objDriverAccess.updateObject(incident, null, null);
            }
            messageString = validationHelper.getSavedMessage();
        } catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
            } else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
            }                                   
        }  
        
        //objDriverAccess.updateObject(incident, null, null);
        //upsert inc;
        return null;
    }
    
    public PageReference categoryQuery () {
        
        List<String> lstOutputFields = new List<String>();
        category = new Category__c();
        if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('categoryDescription__c');
            lstOutputFields.add('FKUrgency__r.Id');
    
            String queryString='Name =' +'\''+savedId+'\'';
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
            objConditionBuilder.setCondition(queryString);
        
            DriverAccess objDriverAccess = new DriverAccess();
            List<Category__c> categoryList = (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null);            
            if(categoryList.size() > 0){
                category = categoryList[0];
                incident.FKCategory__c = categoryList[0].Id;
                incident.categoryId__c = categoryList[0].Name;
                urgencyHierarchyQuery();
            }
            
        }
        
      return null;
      }
    
    public PageReference descriptionQuery () {
      List<String> lstOutputFields = new List<String>();
         StandardDescription__c stdDescription= new  StandardDescription__c();
        if(savedId != null) {
          lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('description__c');
                
            String queryString='Id =' +'\''+savedId+'\'';
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
            objConditionBuilder.setCondition(queryString);
        
      DriverAccess objDriverAccess = new DriverAccess();
            List<StandardDescription__c> descriptionList = (List<StandardDescription__c>) objDriverAccess.selectObjects(stdDescription,lstOutputFields,objConditionBuilder,null);            
            if(descriptionList.size() > 0){
              incident.incidentDescription__c = descriptionList[0].description__c;
               
            }
        }
    return null;
  }
    
    public PageReference resolutionQuery () {
      List<String> lstOutputFields = new List<String>();
         StandardResolution__c stdResolution= new StandardResolution__c();
        if(savedId != null) {
          lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('resolution__c');
             
             String queryString='Id =' +'\''+savedId+'\'';
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
            objConditionBuilder.setCondition(queryString);
          
          DriverAccess objDriverAccess = new DriverAccess();
            List<StandardResolution__c> resolutionList = (List<StandardResolution__c>) objDriverAccess.selectObjects(stdResolution,lstOutputFields,objConditionBuilder,null);            
            if(resolutionList.size() > 0){
              incident.incidentResolution__c = resolutionList[0].resolution__c;
                
            }
        }
        return null;
  }
    
    /*
    *
    * It calcultes urgency based on urgency hierarchy.
    */
    
    public Pagereference urgencyHierarchyQuery() {
        system.debug('$$$$urgency Query$$$$$');
        List<String> lstOutputFields = new List<String>();
        lstOutputFields.add('Id');
        lstOutputFields.add('value__c');
        lstOutputFields.add('property__c');        
        String queryString='property__c = \'propUrgencyHierarchy\'';

        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);
        
        DriverAccess objDriverAccess = new DriverAccess();
        
        SYSProperties__c sysProperties =  new SYSProperties__c(); 
        List<SYSProperties__c> urgencyList = (List<SYSProperties__c>) objDriverAccess.selectObjects(sysProperties,lstOutputFields,objConditionBuilder,null);
                
        if(!urgencyList.isEmpty()){
            for(SYSProperties__c urgencyValue :urgencyList ){
                String urgencyHierarchy = urgencyValue.value__c;
                List<String> urgencyTypeList = urgencyHierarchy.split(';');
                for(String urgencyType: urgencyTypeList ){                  
                    
                    if(urgencyType == 'Client' && client.FKUrgency__c !=  null){
                        incident.FKUrgency__c = client.FKUrgency__c;
                        break;
                    }else if(urgencyType == 'Category' && category.FKUrgency__c !=  null){
                       incident.FKUrgency__c = category.FKUrgency__r.Id;
                        //system.debug('####incident.FKUrgency__c'+incident.FKUrgency__c);
                        break;
                    }else if(urgencyType == 'Organization' && organization.FKUrgency__c !=  null){
                        incident.FKUrgency__c = organization.FKUrgency__c;
                        break;
                    } 
                }   
            }
                    
        }
        return null;
        
    }
    
/*
    * previousBtnHandler() : Fetches the previous record of currently opened record from search list. 
    *
    */
      public Pagereference previousBtnHandler(){
        if(incident!=null){
           CommonUI commonUiObj=new CommonUI();
            Incident__c incobj = (Incident__c)commonUiObj.getSobject(incident, tempString, columnName, direction, 'previous');
            cloneIncident(incobj);
        }
        return null;
    }
    
    /*
    * nextBtnHandler() : Fetches the previous record of currently opened record from search list. 
    *
    */
    public Pagereference nextBtnHandler(){
        if(incident!=null){
            CommonUI commonUiObj=new CommonUI();
            Incident__c incobj = (Incident__c)commonUiObj.getSobject(incident, tempString, columnName, direction, 'next');
            cloneIncident(incobj); 
        }
        return null;
    }
  public void cloneIncident(Incident__c tempIncident ){
            system.debug('@@@@@@@@@@ temp = '+tempIncident.Id+ '   '+tempIncident.Name);
            List<String> listFields = new List<String>();
             ConditionBuilder conditionBuilder = new ConditionBuilder();
          DriverAccess driverAccess = new DriverAccess();
            incident.FKclient__c = null;
            incident.FKCategory__c = null;
            incident.FKImpact__c = null;
            incident.FKUrgency__c = null;
            incident.FKPriority__c = null;
            Counter = 0;
            incident = new Incident__c();
            client = new Client__c();
            incident=tempIncident; 
            system.debug('@@@@@@@@@@ inc '+tempIncident.Id+ '   '+tempIncident.Name);          
            if(incident.clientId__c != null && incident.clientId__c!= ''){
               condition = 'Name = '+'\'' + incident.clientId__c + '\'';
              conditionBuilder.setCondition(condition);                   
              listFields = new List<String>();
              listFields.add('id');
              listFields.add('Name');
              listFields.add('FirstName__c');
              listFields.add('LastName__c');
              listFields.add('Phone__c');
              listFields.add('ext__c');
              listFields.add('City__c');
             listFields.add('OrganizationName__c');
              listFields.add('organizationId__c');
              listFields.add('displayClientComments__c');
              listFields.add('FKOrganization__r.id');
              listFields.add('FKOrganization__r.Name');
              listFields.add('FKOrganization__r.organizationName__c');
              List<Client__c>  clientList = (List<Client__c>)driverAccess.selectObjects(new Client__c(), listFields, conditionBuilder, null);
              if(clientList.size() > 0){
                system.debug('@@@@@@@@@@ inc '+clientList[0].Id+ '   '+clientList[0].Name);    
                     client = clientList[0];
                     client.organizationId__c = client.FKOrganization__r.Name;
                       system.debug('@@@@@@@@@@ inc '+client.Id+ '   '+client.Name);    
              }
       }
    }    
      public void copy(){     
            Incident__c tempIncident= incident.clone(false,true);
            incident = tempIncident;
    }
    
      public Pagereference reset(){ 
         
          client =new Client__c();
          incident = new Incident__c();
          incident.call__c=Integer.valueOf(0);           
          user = new User();
          List<String> listFields = new List<String>();
          DriverAccess driverAccess = new DriverAccess();
          ConditionBuilder conditionBuilder = new ConditionBuilder();
          
          incidentId = ApexPages.CurrentPage().getParameters().get('id');
          if(incidentId!=null){
        
                  String condition = 'id = '+'\'' + incidentId + '\'';
                  conditionBuilder.setCondition(condition);
                
                    listFields.clear();
                    listFields.add('id');
                    listFields.add('Name');
                    listFields.add('clientId__c');
                    listFields.add('categoryId__c');
                    listFields.add('incidentDescription__c');
                    listFields.add('incidentResolution__c');
                    listFields.add('firstCallResolution__c');
                    listFields.add('inactive__c');
                    listFields.add('statusId__c');
                    listFields.add('impactId__c');
                    listFields.add('urgencyId__c');
                    listFields.add('priorityId__c');
                    listFields.add('openDateTime__c');
                    listFields.add('respondedDateTime__c');
                    listFields.add('dueDateTime__c');
                    listFields.add('closeDateTime__c');
                    listFields.add('timeSpent__c');
                    listFields.add('broadcastId__c');
                    listFields.add('note__c');
                    listFields.add('FKAssignedTo__c');
                    listFields.add('assignedToUserId__c');
                    listFields.add('supplierName__c');
                    listFields.add('call__c');
                    
                    listFields.add('FKClient__c');
                    listFields.add('FKCategory__c');
                    listFields.add('FKImpact__c');
                    listFields.add('FKUrgency__c');                    
                    listFields.add('FKStatus__r.Name');
                
                
          condition ='Id =' +'\''+incidentId+'\'';  
               
              conditionBuilder.setCondition(condition);                
                    incidentList = (List<Incident__c>)driverAccess.selectObjects(new Incident__c(), listFields, conditionBuilder, null);
                    
                    if(incidentList !=null && incidentList.size() > 0){
                        incident = incidentList[0]; 
                        if(incident.call__c!=null){
                             counter=Integer.valueOf(''+incident.call__c);
                        }
                        strId = incident.Id;
                        if(incident!=null && incident.clientId__c != null && incident.clientId__c!= ''){
                                
                                condition = 'Name = '+'\'' + incident.clientId__c + '\'';
                                conditionBuilder.setCondition(condition);                   
                            
                                listFields = new List<String>();
                                    listFields.add('id');
                                    listFields.add('Name');
                                    listFields.add('FirstName__c');
                                    listFields.add('LastName__c');
                                    listFields.add('Phone__c');
                                    listFields.add('ext__c');
                                    listFields.add('City__c');
                                    listFields.add('OrganizationName__c');
                                    listFields.add('organizationId__c');
                                    listFields.add('displayClientComments__c');
                                    listFields.add('FKOrganization__r.id');
                                    listFields.add('FKOrganization__r.Name');
                                    listFields.add('FKOrganization__r.organizationName__c');
                                                       
                                List<Client__c>  clientList = (List<Client__c>)driverAccess.selectObjects(new Client__c(), listFields, conditionBuilder, null);
                                                            
                                if(clientList.size() > 0){
                                    client = clientList[0];
                                    client.organizationId__c = client.FKOrganization__r.Name;
                                }
                            }
                            if(incident.FKStatus__r.Name == closeStatus){
                                closeState = true;
                                assignStaffState = true;
                                assignSuggestedStaffState = true;
                                assignSelectedProfileState = true;
                                assignMemberOfAdminState = true;
                                assignMyselfState = true;
                                respondedState = true;
                                reOpenState = false;                    
                            }else{
                                closeState = false;
                                assignStaffState = false;
                                assignSuggestedStaffState = false;
                                assignSelectedProfileState = false;
                                assignMemberOfAdminState = false;
                                assignMyselfState = false;
                                clearAssignState = true;                                
                                if(incident.FKAssignedTo__c != null){
                                  clearAssignState = false;                                  
                                  if(incident.FKAssignedTo__c == Userinfo.getUserId()){
                                    assignMyselfState = true;
                                  }
                                }
                                respondedState = false;
                                reOpenState = true;
                                                              
                            }                         
                        strId = incident.Id;
                               
                       
                       } 
             }else{
             
             incident.openDateTime__c = system.now();
                      lstOutputFields = null;
                      lstOutputFields = new List<String>();
                   
                      lstOutputFields.add('Id');
                      lstOutputFields.add('Name');
                      lstOutputFields.add('state__c');
                      lstOutputFields.add('defaultStatus__c');
                      lstOutputFields.add('appliesToIncident__c');
                       
                      condition = null;   
                      condition = 'state__c = true and ' + 'defaultStatus__c = true and ' + 'appliesToIncident__c = true';
                      conditionBuilder.setCondition(condition); 
                      Status__c tempStatus = new Status__c();
                      List<Status__c> statuses = (List<Status__c>) driverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
              
                      if(statuses.size() > 0){
                         incident.FKStatus__c =  statuses[0].id;
                         incident.statusId__c = statuses[0].Name;
                         incident.state__c=statuses[0].state__c;
                      }
         } 
      
        return null;
    }
    
    public PageReference assignIncidentTOQueue() {

         if(savedId != null && savedId != ''){
            DriverAccess driverAccess = new DriverAccess();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
            List<String> listFields = new List<String>();
            
            incident.OwnerId = savedId;
                
                listFields.clear();    
                listFields.add('Id');
                listFields.add('Name');
                listFields.add('Owner.Name');
                
                condition = null;
                condition = 'Id = \'' + incident.OwnerId+ '\'';
                conditionBuilder.setCondition(condition);
            
                List<Group> groupList = (List<Group> ) driverAccess.selectObjects(new Group(), listFields, conditionBuilder, null);
                
                if(groupList.size() >0){
                    queue = groupList[0].Name;
                    user = null;
                    incident.FKAssignedTo__c = null;                          
                }
                //clearAssignState = false;
                assignStaffState = false;
          assignMyselfState = false;
          clearAssignState = false; 
         }                     
      return null; 
     }    
  public Pagereference fetchIncidentTemplates(){
        CommonUI commonUiObj=new CommonUI();
        mapForTemplate = (Map<String, String>) commonUiObj.getTemplateDataMap(incident, templateId);
        return null;
    }
    
   public List<KVPair> getKeyValues(){      
       List<KVPair> lst = new List<KVPair>();
       if(mapForTemplate!=null){
         for(String key : mapForTemplate.keySet()){
             KVPair kvp=new KVPair();
             String subString= key.substring(0,2);
             if(subString!='FK'){
               kvp.key='incident_'+key;
             }else{  
               kvp.key=key;
             }
             kvp.value=mapForTemplate.get(key);
             lst.add(kvp);
         }
       }
       return lst;
    }
        
    public class KVPair{
      public String key {get; set;}
      public String value {get; set;}
    }
}
			                            	