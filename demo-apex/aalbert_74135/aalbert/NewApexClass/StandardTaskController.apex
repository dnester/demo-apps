public class StandardTaskController {

    public String messageString {get; set;}
    String taskId = null;
    String incidentId = null;
    String savedId = null;
    String clientID{get; set;}       
    public Task__c task{get; set;}
    Incident__c incident{get; set;}
    Category__c category{get; set;}
    Client__c client{get; set;}
    Urgency__c urgency{get; set;}
    Impact__c impact{get; set;}
    Priority__c priority{get; set;}
    Organization__c organization{get; set;}   
    Status__c status{get; set;}
    public Boolean templateFlag=true;
    public String templateId {get; set;}
    List<String> taskFieldsList;
    String columnName='Name';
    String direction= 'ASC';
    public String tempString {get; set;}
    public string descriptiontextarea {get; set;}
    public string resolutiontextarea {get; set;}

    String copyId;
    String closeStatus;
    Datetime localDateTime; 
        
    List<String> lstOutputFields;
    ConditionBuilder objConditionBuilder;
    DriverAccess objDriverAccess;
    String queryString;
    
    String firstName;
    String lastName;
    String profile;
    String phone;
    String extension;
    String queue;
    
    Boolean closeState = true;
    Boolean reOpenState = true;    
    Boolean assignStaffState = false;
    Boolean assignSuggestedStaffState = false;
    Boolean assignToQueueState = false;
    Boolean assignMyselfState = false;    
    Boolean clearAssignState = true;
    Boolean saveState = false;
    
    String openDateTime;
    String closeDateTime;
   public Map<String,String> mapForTemplate {get; set;}
   public Boolean getTemplateFlag(){        
        return templateFlag;   
    }
    
    public void setTemplateFlag(Boolean templateFlag){        
        this.templateFlag = templateFlag;   
    }
    
    public Boolean getCloseState(){        
        return closeState;   
    }
    
    public void setCloseState(Boolean closeState){        
        this.closeState = closeState;   
    }
    
    public Boolean getSaveState(){        
        return saveState;   
    }
    
    public void setSaveState(Boolean saveState){        
        this.saveState = saveState;   
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
    
    public Boolean getAssignToQueueState(){        
        return assignToQueueState;   
    }
    
    public void setAssignToQueueState(Boolean assignToQueueState){        
        this.assignToQueueState = assignToQueueState;   
    }
    
    public Boolean getAssignSuggestedStaffState(){        
        return assignSuggestedStaffState;   
    }
    
    public void setAssignSuggestedStaffState(Boolean assignSuggestedStaffState){        
        this.assignSuggestedStaffState = assignSuggestedStaffState;   
    }
    
    public Boolean getClearAssignState(){        
        return clearAssignState ;   
    }
    
    public void setClearAssignState(Boolean clearAssignState ){        
        this.clearAssignState  = clearAssignState ;   
    }
    
    public String getOpenDateTime(){        
        return openDateTime;   
    }
    
    public void setOpenDateTime(String openDateTime){        
        this.openDateTime = openDateTime;   
    }
    
    public String getCloseDateTime(){        
        return closeDateTime;   
    }
    
    public void setCloseDateTime(String closeDateTime){        
        this.closeDateTime = closeDateTime;   
    }
    
    public String getFirstName(){        
        return firstName;   
    }
    
    public void setFirstName(String firstName){        
        this.firstName = firstName;   
    }
    
    public String getLastName(){        
        return lastName;   
    }
    
    public void setLastName(String lastName){        
        this.lastName = lastName;   
    }
    
    public String getPhone(){        
        return phone;   
    }
    
    public void setPhone(String phone){        
        this.phone = phone;   
    }
    
    public String getExtension(){        
        return extension;   
    }
    
    public void setExtension(String extension){        
        this.extension = extension;   
    }
    
    public String getQueue(){        
        return queue;   
    }
    
    public void setQueue(String queue){        
        this.queue = queue;   
    }
    
    public String getProfile(){        
        return profile;   
    }
    
    public void setProfile(String profile){        
        this.profile = profile;   
    }
        
    public String getSavedId() {
        return this.savedId;
    }
    
    public void setSavedId(String savedId) {
        this.savedId = savedId;
    }
    
    public String getIncidentId() {
        return this.incidentId;
    }
    
    public void setIncidentId(String incidentId) {
        this.incidentId = incidentId;
    }

    public String getTaskId() {
        return this.taskId;
    }
    
    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }

    public Status__c getStatus() {
        return this.status;
    }
    
    public void setStatus(Status__c status) {
        this.status = status;
    }
    
    public StandardTaskController () {
        
        incidentId = Apexpages.currentPage().getParameters().get('incidentId');
        columnName = ApexPages.CurrentPage().getParameters().get('columnField');
        direction = ApexPages.CurrentPage().getParameters().get('direction'); 
        taskId = Apexpages.currentPage().getParameters().get('id');
        copyId = Apexpages.currentPage().getParameters().get('copyId');
        
        lstOutputFields = new List<String>();
        objConditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
        
        category = new Category__c();
        client = new Client__c();
        task = new Task__c();
        urgency = new Urgency__c();
        impact = new Impact__c();
        priority = new Priority__c();
        organization = new Organization__c();
        incident = new Incident__c();
        status = new Status__c();
        templateFlag=true;
        
        //Changes for Adding Category when added from category details
          //Changes made by Sujeet
          String category_Id = ApexPages.CurrentPage().getParameters().get('Categoryid');
          task.FKCategory__c = category_Id;
          List<Category__c> lstCategory;
          if(category_Id != null && category_Id != ''){
            String qryString = 'Id = '+'\''+category_Id+'\'';
            objConditionBuilder.setCondition(qryString);
            lstCategory = (List<Category__c>)objDriverAccess.selectObjects(new Category__c(), null, objConditionBuilder, null);
            
            if(lstCategory!=null && lstCategory.size()>0)
                task.categoryId__c = lstCategory[0].Name;
          }
        
        
        //Adding Task for the Incident
        if(incidentId != null) {
                        
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('FKCategory__c');
            //lstOutputFields.add('FKCategory__r.categoryDescription__c');
            lstOutputFields.add('FKCategory__r.Id');
            lstOutputFields.add('FKCategory__r.Name');
            lstOutputFields.add('categoryId__c');
            
            lstOutputFields.add('FKImpact__r.Id');
            lstOutputFields.add('FKImpact__r.Name');
            lstOutputFields.add('impactId__c');
            lstOutputFields.add('FKStatus__r.state__c');
            lstOutputFields.add('FKStatus__r.name');
            lstOutputFields.add('FKUrgency__r.Id');
            lstOutputFields.add('FKUrgency__r.Name');
            lstOutputFields.add('urgencyId__c');
            
            lstOutputFields.add('FKPriority__r.Id');
            lstOutputFields.add('FKPriority__r.Name');
            lstOutputFields.add('priorityId__c');
            
            
            lstOutputFields.add('assignedToUserId__c');
            lstOutputFields.add('FKAssignedTo__r.Id');
            
            queryString = 'Id =' +'\''+incidentId+'\'';
            objConditionBuilder.setCondition(queryString);
            
            List <Incident__c> incidentList = (List<Incident__c>) objDriverAccess.selectObjects(incident,lstOutputFields,objConditionBuilder,null);
            taskFieldsList = new List<String> ();
            taskFieldsList = lstOutputFields;
            //Assigning fields from incident to task.
            if(incidentList.size() > 0) {
                incident = incidentList[0];
                task.FKCategory__c = incident.FKCategory__r.Id;
                task.categoryId__c = incident.categoryId__c;
                
                task.FKImpact__c = incident.FKImpact__r.Id;
                task.impactId__c = incident.impactId__c;
                
                task.FKUrgency__c = incident.FKUrgency__r.Id;
                task.urgencyId__c = incident.urgencyId__c;
                
                task.FKPriority__c = incident.FKPriority__r.Id;
                task.priorityId__c = incident.priorityId__c;
                
                task.assignedTo__c = incident.assignedToUserId__c;
                task.FKAssignedTo__c = incident.FKAssignedTo__r.Id;
                
                task.incidentId__c = incident.Name;
                task.FKIncident__c = incident.Id;
            }

        }
        //End of Adding Task for the Incident
        
        localDateTime = task.openDateTime__c  = System.now();
        openDateTime = localDateTime.format('yyyy/MM/dd hh:mm aaa');
                
        lstOutputFields.clear();
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');

        queryString = 'state__c = false and ' + 'defaultStatus__c = true and ' + 'appliesToTask__c = true';
    
        objConditionBuilder.setCondition(queryString);
    
        List<Status__c> defaultStatus = (List<Status__c>) objDriverAccess.selectObjects(status,lstOutputFields,objConditionBuilder,null);                
        if(defaultStatus.size() > 0) {            
            closeStatus = defaultStatus[0].Name;
        }        
        
        // Open Task for Edit
        initTask();
        //End of Edit Task
        
        if(task.Id == null) {
            templateFlag=false;
            lstOutputFields.clear();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('state__c');
            lstOutputFields.add('defaultStatus__c');

            queryString = 'state__c = true and ' + 'defaultStatus__c = true and ' + 'appliesToTask__c = true';
        
            objConditionBuilder.setCondition(queryString);
        
            defaultStatus = (List<Status__c>) objDriverAccess.selectObjects(status,lstOutputFields,objConditionBuilder,null);                
            if(defaultStatus.size() > 0) {
                task.FKStatus__r = defaultStatus[0];
                task.FKStatus__r.Name = defaultStatus[0].Name;
                task.state__c = defaultStatus[0].state__c;
                task.status__c = defaultStatus[0].Name;
            }
        }                
    }
    
    public Pagereference resetClosedTask(){     
        initTask();
        return null;
    }
    
    public Pagereference initTask(){
        
        
        
        if(taskId != null || (copyId !=null && copyId != '')) {
            
            lstOutputFields.clear();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('FKCategory__c');
            lstOutputFields.add('FKCategory__r.Id');
            lstOutputFields.add('categoryId__c');
            lstOutputFields.add('FKCategory__r.Name');
            lstOutputFields.add('FKImpact__r.Id');
            lstOutputFields.add('FKImpact__r.Name');
            lstOutputFields.add('impactId__c');
            lstOutputFields.add('FKUrgency__r.Id');
            lstOutputFields.add('FKUrgency__r.Name');
            lstOutputFields.add('urgencyId__c');
            lstOutputFields.add('FKPriority__r.Id');
            lstOutputFields.add('FKPriority__r.Name');
            lstOutputFields.add('priorityId__c');
            
            lstOutputFields.add('taskDescription__c');
            lstOutputFields.add('taskResolution__c');
            lstOutputFields.add('timeSpent__c');
            lstOutputFields.add('createdOn__c');
            lstOutputFields.add('completedDate__c');
            lstOutputFields.add('dueDateTime__c');
            
            lstOutputFields.add('assignedTo__c');
            lstOutputFields.add('FKSupplier__c');
            lstOutputFields.add('inactive__c');

            lstOutputFields.add('openDateTime__c');
            lstOutputFields.add('closeDateTime__c');
            lstOutputFields.add('firstNameAssignedTo__c');
            lstOutputFields.add('lastNameAssignedTo__c');
            lstOutputFields.add('FKAssignedTo__c');
            lstOutputFields.add('assignedToUserID__c');
            lstOutputFields.add('phone__c');
            
            lstOutputFields.add('incidentId__c');
            lstOutputFields.add('FKIncident__c');
            lstOutputFields.add('FKTemplate__c');
            lstOutputFields.add('FKStatus__c');            
            lstOutputFields.add('FKStatus__r.Name');
            lstOutputFields.add('FKStatus__r.state__c');
            lstOutputFields.add('status__c');
            lstOutputFields.add('Owner.Name');
            
            String queryString = '';
            if((copyId !=null && copyId != '')){
                queryString='Id =' +'\''+copyId+'\'';  
                                
             }else {
                queryString='Id =' +'\''+taskId+'\'';  
             }
             
            objConditionBuilder.setCondition(queryString);
            List <Task__c> taskList = (List<Task__c>) objDriverAccess.selectObjects(new Task__c(),lstOutputFields,objConditionBuilder,null);
               
             if((taskList.size() > 0) && (copyId !=null && copyId != '')){
                task = taskList[0];
                copy();
                
            }else if(taskList.size() > 0) {
            //Assigning fields from incident to task.
            
                task = taskList[0];                
                //openDateTime = taskList[0].openDateTime__c+'';
                localDateTime = task.openDateTime__c  = taskList[0].openDateTime__c;
                if(localDateTime!=null)
                openDateTime = localDateTime.format('yyyy/MM/dd hh:mm aaa');
                if(taskList[0].closeDateTime__c != null){                    
                    localDateTime = task.closeDateTime__c  = taskList[0].closeDateTime__c;
                    closeDateTime = localDateTime.format('yyyy/MM/dd hh:mm aaa');                   
                }else{
                    closeDateTime = '';
                }
                
                if(task.Owner.Name != null && task.Owner.Name != ''){
                    queue = task.Owner.Name;
                    if(task.FKStatus__r.Name == closeStatus){
                        clearAssignState = true;
                    }else{
                        clearAssignState = false;
                    } 
                }else{
                    queue = '';
                }
                                
                if(task.FKStatus__r.Name == closeStatus){
                    closeState = true;
                    saveState = true;
                    assignStaffState = true;
                    assignMyselfState = true;
                    assignSuggestedStaffState = true;
                    assignToQueueState = true;                  
                    reOpenState = false;
                    clearAssignState = true;                    
                }else{
                    closeState = false;
                    saveState = false;
                    reOpenState = true;
                    assignStaffState = false;
                    assignSuggestedStaffState = false;
                    assignToQueueState =false;
                    assignMyselfState = false;
                }                
                savedId = taskList[0].FKAssignedTo__c;
                if(savedId != null && savedId != ''){
                    lstOutputFields.clear();
                    lstOutputFields.add('Id');
                    lstOutputFields.add('Name');                
                    lstOutputFields.add('firstName');
                    lstOutputFields.add('lastName');        
                    lstOutputFields.add('Profile.Name');
                    lstOutputFields.add('phone');
                    lstOutputFields.add('extension');        
                    
                    queryString = 'Id = \'' + savedId + '\'';
                    objConditionBuilder.setCondition(queryString);
                
                    List<User> usersList = (List<User> ) objDriverAccess .selectObjects(new User(), lstOutputFields, objConditionBuilder, null);
                    
                    if(usersList.size() > 0){
                        firstName = usersList[0].firstName;
                        lastName = usersList[0].lastName;
                        profile = usersList[0].Profile.Name;            
                        phone = usersList[0].phone;
                        extension = usersList[0].extension;
                        if(task.FKStatus__r.Name == closeStatus){
                            clearAssignState = true;
                        }else{
                            clearAssignState = false;
                        }
                        
                        if(savedId == Userinfo.getUserId()){
                            assignMyselfState = true;
                        }
                    }
                }else{                  
                    firstName = '';
                    lastName = '';
                    profile = '';            
                    phone = '';
                    extension = '';
                }                
            }            
        }
        return null;
    }
    
    public Client__c getClient() {
        return client;
    }
    
    public Category__c getCategory() {        
        return category;
    }
    
    public Priority__c getPriority() {
        return priority;
    }
    
    public Incident__c getIncident() {        
        return this.incident;
    }
    
    public void setIncident(Incident__c incident) {
        this.incident = incident;
    }
    
        
    /*
    *
    * This fatches the Client information according to the
    * selected Client ID. 
    */    

    public PageReference clientQuery () {
        
        lstOutputFields.clear();
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('Phone__c');
        lstOutputFields.add('ext__c');
        lstOutputFields.add('FirstName__c'); 
        lstOutputFields.add('LastName__c');        
        lstOutputFields.add('FKOrganization__c');
        lstOutputFields.add('FKUrgency__c');
        
        queryString='Id =' +'\''+task.FKClient__c+'\'';  
        
        objConditionBuilder.setCondition(queryString);
        
        List<Client__c> clientList = (List<Client__c>) objDriverAccess.selectObjects(client,lstOutputFields,objConditionBuilder,null);    
        if(clientList.size() > 0){
            client = clientList[0];
            urgencyHierarchyQuery();   
        }       

        return null;
    } 
       
    /*
    *
    * This fatches the Category information according to the
    * selected Category ID. 
    */       
     
    public PageReference categoryQuery () {
        
        lstOutputFields.clear();
        
        if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('categoryDescription__c');
            lstOutputFields.add('FKUrgency__r.Id');
            lstOutputFields.add('FKUrgency__r.Name');
            lstOutputFields.add('urgencyId__c');
    
            queryString='Name =' +'\''+savedId+'\'';
            
            objConditionBuilder.setCondition(queryString);
        
            List<Category__c> categoryList = (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null);            
            
            //List<Category__c> categoryList = [Select c.Id, c.Name, c.categoryDescription__c from Category__c c where c.Name =: savedId];
            
            if(categoryList.size() > 0){
                category = categoryList[0];
                task.FKCategory__c = categoryList[0].Id;
                task.categoryId__c = categoryList[0].Name;
                //task.FKCategory__r.categoryDescription__c                
                urgencyHierarchyQuery();
            }
            
        }
        
        //******
        /*List<String> lstOutputFields = new List<String>();
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('categoryDescription__c');
        lstOutputFields.add('FKUrgency__c');
        String queryString='Id =' +'\''+task.FKCategory__c+'\''; 
        
        
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);
        
        DriverAccess objDriverAccess = new DriverAccess();
        List<Category__c> categoryList = (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null);            
        if(categoryList .size() > 0){
            category= categoryList [0];
            urgencyHierarchyQuery();
         }*/

         return null;    
     }

     /*
    *
    * This fatches the organization information according to the
    * selected Category ID. 
    */       
     
    public PageReference organizationQuery () {
         lstOutputFields.clear();
         lstOutputFields.add('Id');
         lstOutputFields.add('Name');
         lstOutputFields.add('FKUrgency__c');        
         queryString='Id =' +'\''+task.FKOrganization__c+'\'';
         
         objConditionBuilder.setCondition(queryString);
         
         List<Organization__c> organizationationList = (List<Organization__c>) objDriverAccess.selectObjects(organization,lstOutputFields,objConditionBuilder,null);
         if(organizationationList .size() > 0){
            organization= organizationationList [0];
            urgencyHierarchyQuery();
         }

         return null;
    }


    /*
    *
    * This calculates the priority and due date and time 
    * based on Urgency and Impact. 
    */
    
    public PageReference priorityQuery() {
         
         if(task.urgencyId__c != null && task.impactId__c != null) {
         
         lstOutputFields.clear();
                  
         lstOutputFields.add('Id');
         lstOutputFields.add('Name');
         lstOutputFields.add('urgencyId__c');
         lstOutputFields.add('createdDate');
         lstOutputFields.add('priorityDuration__c');
         lstOutputFields.add('isDeleted'); 
         lstOutputFields.add('impactID__c');        
         lstOutputFields.add('FKUrgency__r.ID');
         lstOutputFields.add('FKUrgency__r.Name');
         lstOutputFields.add('FKImpact__r.ID');
         lstOutputFields.add('FKImpact__r.Name');
         
         queryString='urgencyId__c =' +'\''+task.urgencyId__c+'\' and  impactId__c =' +'\''+task.impactId__c+'\'';
                    
         objConditionBuilder.setCondition(queryString);
         
         List<Priority__c> taskPriority = (List<Priority__c>) objDriverAccess.selectObjects(priority,lstOutputFields,objConditionBuilder,null);
   
         if(taskPriority.size() > 0 && task != null){
             priority = taskPriority[0];
             task.priorityId__c = taskPriority[0].Name;
             task.FKPriority__c = taskPriority[0].Id;  
             if(task.DueDateTime__c == null && taskPriority[0].priorityDuration__c != null && taskPriority[0].priorityDuration__c != ''){

                Datetime prDuration = System.now().addMinutes(Integer.valueOf(taskPriority[0].priorityDuration__c));
                task.DueDateTime__c = prDuration ;
             }
         }
         else {
             task.priorityId__c = '';
             task.FKPriority__c = null;  
             
         }
         }
         return null;
    }
    
    public PageReference statusQuery() {
        lstOutputFields.clear();
        
        if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('state__c');
            lstOutputFields.add('defaultStatus__c');
    
    
            queryString='Id =' +'\''+savedId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            List<Status__c> statusList = (List<Status__c>) objDriverAccess.selectObjects(status,lstOutputFields,objConditionBuilder,null);            
            
            //List<Category__c> categoryList = [Select c.Id, c.Name, c.categoryDescription__c from Category__c c where c.Name =: savedId];
            
            if(statusList.size() > 0){
                status = statusList[0];
                task.FKStatus__c = statusList[0].Id;
                task.state__c = statusList[0].state__c;
                task.status__c = statusList[0].Name;
                task.FKStatus__c = statusList[0].Id;
            }
            
        }
        
        return null;
    }
    
    
    public PageReference impactQuery() {
        
        lstOutputFields.clear();      
        if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('description__c');
    
            queryString='Id =' +'\''+savedId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            List<Impact__c> impactList = (List<Impact__c>) objDriverAccess.selectObjects(impact,lstOutputFields,objConditionBuilder,null);            
            
            if(impactList.size() > 0){
                impact = impactList[0];
                task.FKImpact__c = impactList[0].Id;
                task.impactId__c = impactList[0].Name;
                priorityQuery();
            }
            
        }
        
        return null;
    }
    
    public PageReference urgencyQuery() {
        
        lstOutputFields.clear();
        
        if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('description__c');
    
            queryString='Id =' +'\''+savedId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            List<Urgency__c> urgencyList = (List<Urgency__c>) objDriverAccess.selectObjects(urgency,lstOutputFields,objConditionBuilder,null);            
            
            if(urgencyList.size() > 0){
                urgency = urgencyList[0];
                task.FKUrgency__c = urgencyList[0].Id;
                task.urgencyId__c = urgencyList[0].Name;
                priorityQuery();
            }
            
        }
        
        return null;
    }
    
    public PageReference impactQueryOnName() {
        
        lstOutputFields.clear();        
        if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('description__c');
    
            queryString='name =' +'\''+savedId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            List<Impact__c> impactList = (List<Impact__c>) objDriverAccess.selectObjects(impact,lstOutputFields,objConditionBuilder,null);            
            
            if(impactList.size() > 0){
                impact = impactList[0];
                task.FKImpact__c = impactList[0].Id;
                task.impactId__c = impactList[0].Name;
                priorityQuery();
            }
            
        }
        
        return null;
    }
    
    public PageReference urgencyQueryOnName() {
        
        lstOutputFields.clear();
        if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('description__c');
    
            queryString='name =' +'\''+savedId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            List<Urgency__c> urgencyList = (List<Urgency__c>) objDriverAccess.selectObjects(urgency,lstOutputFields,objConditionBuilder,null);            
            
            if(urgencyList.size() > 0){
                urgency = urgencyList[0];
                task.FKUrgency__c = urgencyList[0].Id;
                task.urgencyId__c = urgencyList[0].Name;
                priorityQuery();
            }
            
        }
        
        return null;
    }
    
    /*
    *
    * It calcultes urgency based on urgency hierarchy.
    */
    
    public Pagereference urgencyHierarchyQuery() {
    
        lstOutputFields.clear();
        lstOutputFields.add('Id');
        lstOutputFields.add('value__c');
        lstOutputFields.add('property__c');        
        queryString='property__c = \'propUrgencyHierarchy\'';

        objConditionBuilder.setCondition(queryString);
        
        SYSProperties__c sysProperties =  new SYSProperties__c(); 
        List<SYSProperties__c> urgencyList = (List<SYSProperties__c>) objDriverAccess.selectObjects(sysProperties,lstOutputFields,objConditionBuilder,null);
                
        if(!urgencyList.isEmpty()){
            for(SYSProperties__c urgencyValue :urgencyList ){
                String urgencyHierarchy = urgencyValue.value__c;
                List<String> urgencyTypeList = urgencyHierarchy.split(';');
                for(String urgencyType: urgencyTypeList ){                  
                    
                    if(urgencyType == 'Client' && client.FKUrgency__c !=  null){
                        task.FKUrgency__c = client.FKUrgency__c;
                        break;
                    }else if(urgencyType == 'Category' && category.FKUrgency__c !=  null){
                        task.FKUrgency__c = category.FKUrgency__r.Id;
                        task.urgencyId__c = category.FKUrgency__r.Name;
                        priorityQuery();
                        break;
                    }else if(urgencyType == 'Organization' && organization.FKUrgency__c !=  null){
                        task.FKUrgency__c = organization.FKUrgency__c;
                        break;
                    } 
                }   
            }
                    
        }
        return null;
        
    }
    
    public PageReference descriptionQuery () {
        
        lstOutputFields.clear();
        StandardDescription__c stdDescription= new  StandardDescription__c();
        if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('description__c');
                
            queryString='Id =' +'\''+savedId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            List<StandardDescription__c> descriptionList = (List<StandardDescription__c>) objDriverAccess.selectObjects(stdDescription,lstOutputFields,objConditionBuilder,null);            
            if(descriptionList.size() > 0){
               
                task.taskDescription__c = descriptionList[0].description__c;
               
            }
            
        }
        
      return null;
      }
      
      public PageReference resolutionQuery () {
        
      lstOutputFields.clear();
      StandardResolution__c stdResolution= new StandardResolution__c();
      if(savedId != null) {
            
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('resolution__c');
           
            queryString='Id =' +'\''+savedId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            List<StandardResolution__c> resolutionList = (List<StandardResolution__c>) objDriverAccess.selectObjects(stdResolution,lstOutputFields,objConditionBuilder,null);            
            if(resolutionList.size() > 0){
                
                task.taskResolution__c = resolutionList[0].resolution__c;
                
            }
            
        }
        
      return null;
      }
      
      
      
    
    public PageReference assignTaskTOStaff() {
        
        task.OwnerId = Userinfo.getUserId();
        queue = '';
        lstOutputFields.clear();    
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('Username');
        lstOutputFields.add('firstName');
        lstOutputFields.add('lastName');        
        lstOutputFields.add('Profile.Name');
        lstOutputFields.add('phone');
        lstOutputFields.add('extension');        
        
        queryString = 'Id = \'' + savedId + '\'';
        objConditionBuilder.setCondition(queryString);
    
        List<User> usersList = (List<User> ) objDriverAccess .selectObjects(new User(), lstOutputFields, objConditionBuilder, null);
        
        if(usersList.size() >0){
            task.FKAssignedTo__c = usersList[0].Id;
            task.assignedTo__c = usersList[0].Name;
            firstName = usersList[0].firstName;
            lastName = usersList[0].lastName;
            profile = usersList[0].Profile.Name;
            phone = usersList[0].phone;
            extension = usersList[0].extension;
            assignStaffState = false;
            assignSuggestedStaffState = false;
            assignToQueueState = false;
            clearAssignState = false;  
            //closeState = false;
            reOpenState = true;          
            if(task.FKAssignedTo__c == Userinfo.getUserId()){
                assignMyselfState = true;
            }else{
                assignMyselfState = false;
            }            
        }        
        return null;
    }
    
    public PageReference assignTaskTOMyself() {
        task.OwnerId = Userinfo.getUserId();
        queue = '';
        savedId = Userinfo.getUserId();
        
        lstOutputFields.clear();    
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('Username');
        lstOutputFields.add('firstName');
        lstOutputFields.add('lastName');        
        lstOutputFields.add('Profile.Name');
        lstOutputFields.add('phone');
        lstOutputFields.add('extension');        
        
        queryString = 'Id = \'' + savedId + '\'';
        objConditionBuilder.setCondition(queryString);
    
        List<User> usersList = (List<User> ) objDriverAccess .selectObjects(new User(), lstOutputFields, objConditionBuilder, null);
        
        if(usersList.size() >0){
            task.FKAssignedTo__c = usersList[0].Id;
            task.assignedTo__c = usersList[0].Name;
            firstName = usersList[0].firstName;
            lastName = usersList[0].lastName;
            profile = usersList[0].Profile.Name;            
            phone = usersList[0].phone;
            extension = usersList[0].extension;
        }
        //closeState = false;
        reOpenState = true;
        assignMyselfState = true;
        clearAssignState = false;
        return null;
    }
    
    public PageReference clearAssignedTo() {
        task.FKAssignedTo__c = null;
        task.assignedTo__c = '';
        task.OwnerId = Userinfo.getUserId();
        queue = '';
        firstName = '';
        lastName = '';
        profile = '';
        phone = '';
        extension = '';        
        assignStaffState = false;
        assignSuggestedStaffState = false;
        assignToQueueState = false;
        assignMyselfState = false;
        return null;
    }
    
    public PageReference quickCloseTask() {
        try{
            if(task.categoryId__c != null) {
            
                List<String> lstOutputFields = new List<String>();
                lstOutputFields.add('Id');
                
                queryString='Name =' +'\''+task.categoryId__c+'\'';
                objConditionBuilder.setCondition(queryString);
    
                List<Category__c> categoryList = (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null);            
                
                if(categoryList.size() > 0){
                    task.FKCategory__c = categoryList[0].Id;
                }
                lstOutputFields.clear();
                lstOutputFields.add('Id');
                lstOutputFields.add('Name');
                lstOutputFields.add('state__c');
                lstOutputFields.add('defaultStatus__c');
                 
                queryString = 'state__c = false and ' + 'defaultStatus__c = true and ' + 'appliesToTask__c = true';
                
                objConditionBuilder.setCondition(queryString); 
                
                List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(status,lstOutputFields,objConditionBuilder,null);
        
                if(statuses.size() > 0){
                   task.FKStatus__r =  statuses[0];
                   task.FKStatus__r.Name = statuses[0].Name;
                   task.state__c = statuses[0].state__c;
                   task.status__c = statuses[0].Name;
                   task.FKStatus__c = statuses[0].Id;
                }
                
                localDateTime = task.closeDateTime__c  = System.now();
                closeDateTime = localDateTime.format('yyyy/MM/dd hh:mm aaa');   
            }
                    
            if(task.categoryId__c == null ||task.categoryId__c ==''){
                task.FKCategory__c=null;
            }
                
            
            objDriverAccess.updateObject(task, null, null);
            
            closeState = true;
            saveState = true;
            reOpenState = false;
            assignStaffState = true;
            assignSuggestedStaffState = true;
            assignToQueueState = true;
            assignMyselfState = true;                       
            clearAssignState = true;
            
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
    
    public PageReference reopenTask() {
        
        lstOutputFields.clear();
        
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');
         
        queryString = 'state__c = true and ' + 'defaultStatus__c = true and ' + 'appliesToTask__c = true';
        
        objConditionBuilder.setCondition(queryString); 
        
        List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(status,lstOutputFields,objConditionBuilder,null);

        if(statuses.size() > 0){
           task.FKStatus__r =  statuses[0];
           task.FKStatus__r.Name = statuses[0].Name;
           task.state__c = statuses[0].state__c;
           task.status__c = statuses[0].Name;
           task.FKStatus__c = statuses[0].Id;
        }
        localDateTime = task.openDateTime__c  = System.now();
        openDateTime = localDateTime.format('yyyy/MM/dd hh:mm aaa');
                
        task.closeDateTime__c = null;
        closeDateTime = '';
        
        closeState = false;
        saveState = false;
        reOpenState = true;
        assignStaffState = false;
        assignSuggestedStaffState = false;
        assignToQueueState = false;     
        assignMyselfState = false;
        clearAssignState = true;
        if(task.FKAssignedTo__c != null){
            clearAssignState = false;
            if(task.FKAssignedTo__c == Userinfo.getUserId()){
                assignMyselfState = true;
            }
        }
        
        objDriverAccess.updateObject(task, null, null);
        return null;
        
    }
    
     
    public PageReference save() {
        try{
        
        //task.taskDescription__c=descriptiontextarea;
        //task.taskResolution__c=resolutiontextarea;
        task.createdOn__c = system.now();
        
        if(task.categoryId__c != null) {
            
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            
            queryString='Name =' +'\''+task.categoryId__c+'\'';
            objConditionBuilder.setCondition(queryString);

            List<Category__c> categoryList = (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null);            
            
            if(categoryList != null && categoryList.size() > 0){
                task.FKCategory__c = categoryList[0].Id;
            }
        }
        if(task.status__c != null) {
            
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('state__c');
            
            queryString='Name =' +'\''+task.status__c+'\'';
            
            objConditionBuilder.setCondition(queryString);
        
            
            List<Status__c> statusList = (List<Status__c>) objDriverAccess.selectObjects(new Status__c(),lstOutputFields,objConditionBuilder,null);            
            
            if(statusList!= null &&  statusList.size() > 0){
                task.FKStatus__c = statusList[0].Id;
                task.state__c = statusList[0].state__c;
                task.FKStatus__r = statusList[0];
                task.FKStatus__r.Name = statusList[0].Name; 
            }
        }
        
        List<String> lstOutputFields = new List<String>();
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        
        queryString='Name = '+'\'' +'Tasks'+'\'';
        
        objConditionBuilder.setCondition(queryString);
    
        
        List<RecordType> recordTypeList = (List<RecordType>) objDriverAccess.selectObjects(new RecordType(),lstOutputFields,objConditionBuilder,null);            
        
        if(recordTypeList!= null &&  recordTypeList.size() > 0){
            task.RecordTypeId = recordTypeList[0].Id;             
        } 
        
        if(task.openDateTime__c == null){
            localDateTime = task.openDateTime__c  = System.now();
            openDateTime = localDateTime.format('yyyy/MM/dd hh:mm aaa');
                        
        }       
        
        if(task.categoryId__c == null ||task.categoryId__c =='')
                task.FKCategory__c=null;
                
        if(task.Id == null){
            taskId = objDriverAccess.insertObject(task, null);
            templateFlag=true;            
            initTask();
        }
        else{
            objDriverAccess.updateObject(task, null, null);
            templateFlag=true; 
        }
         
        if(task.FKStatus__r.Name == closeStatus){
            localDateTime = task.closeDateTime__c  = System.now();
            closeDateTime = localDateTime.format('yyyy/MM/dd hh:mm aaa');
            closeState = true;
            saveState = true;
            reOpenState = false;
            assignStaffState = true;
            assignSuggestedStaffState = true;
            assignToQueueState = true;
            assignMyselfState = true;                       
            clearAssignState = true;
            
            
      //Method to add Task from templates
            createTaskFromTemplate(task);
        }else{
            closeState = false;
            reOpenState = true;
            saveState = false;
            assignStaffState = false;
            assignSuggestedStaffState = false;
            assignToQueueState = false;
            if(task.FKAssignedTo__c == Userinfo.getUserId()){
                assignMyselfState = true;
            }else{
                assignMyselfState = false;
            }
        }
        
        if(task.FKAssignedTo__c != null){
            if(task.FKStatus__r.Name == closeStatus){
                clearAssignState = true;
            }else{
                clearAssignState = false;
            }
            if(task.FKAssignedTo__c == Userinfo.getUserId()){
                assignMyselfState = true;
            }           
        }
        
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
    
    
    public PageReference deleteTask() {
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
            if(task != null && task.Id != null ){        
                String queryString='Id =' +'\''+task.Id+'\'';  
                objConditionBuilder.setCondition(queryString);
                objDriverAccess.deleteObject(task, objConditionBuilder, null);
            }       
        return null;
    }
    
      public void copy(){     
            
            Task__c tempTask= new Task__c();
            tempTask.FKCategory__c = task.FKCategory__r.Id;
            tempTask.categoryId__c = task.categoryId__c;
            tempTask.FKImpact__c = task.FKImpact__r.Id;
            tempTask.impactId__c = task.impactId__c;
            tempTask.FKUrgency__c =task.FKUrgency__r.id;
            tempTask.urgencyId__c = task.urgencyId__c;
            tempTask.FKPriority__c = task.FKPriority__r.id;
            tempTask.priorityId__c = task.priorityId__c;
            tempTask.taskDescription__c= task.taskDescription__c;
            tempTask.taskResolution__c = task.taskResolution__c;
            tempTask.timeSpent__c = task.timeSpent__c;
            tempTask.createdOn__c = task.createdOn__c;
            tempTask.completedDate__c = task.completedDate__c;
            tempTask.dueDateTime__c = task.dueDateTime__c;
            tempTask.assignedTo__c = task.assignedTo__c;
            tempTask.FKSupplier__c =task.FKSupplier__c;
            tempTask.inactive__c = task.inactive__c;
            tempTask.openDateTime__c = task.openDateTime__c;
            tempTask.closeDateTime__c = task.closeDateTime__c;
            tempTask.FKAssignedTo__c = task.FKAssignedTo__c;
            tempTask.phone__c = task.phone__c;
            tempTask.incidentId__c = task.incidentId__c;
            tempTask.FKIncident__c = task.FKIncident__c;
            tempTask.FKStatus__c = task.FKStatus__c;
            tempTask.status__c = task.status__c;
            
            task = tempTask;
    }    
    
    /*public PageReference newTask() {
        task = new Task__c();
        task.openDateTime__c = system.now();
        if(task.Id == null) {
            lstOutputFields.clear();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('state__c');
            lstOutputFields.add('defaultStatus__c');

            queryString = 'state__c = true and ' + 'defaultStatus__c = true and ' + 'appliesToTask__c = true';
        
            objConditionBuilder.setCondition(queryString);
        
            List<Status__c> defaultStatus = (List<Status__c>) objDriverAccess.selectObjects(status,lstOutputFields,objConditionBuilder,null);                
            if(defaultStatus.size() > 0) {
                task.FKStatus__r = defaultStatus[0];
                task.status__c = defaultStatus[0].Name;
            }
        }        
        return null;
    }*/

     public Pagereference previousBtnHandler(){
        if(task!=null){
            CommonUI commonUiObj=new CommonUI();
            task = (Task__c)commonUiObj.getSobject(task, tempString, columnName, direction, 'previous');
            taskId = task.Id;
            initTask();
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(task!=null){
            CommonUI commonUiObj=new CommonUI();
            task = (Task__c)commonUiObj.getSobject(task, tempString, columnName, direction, 'next');
            taskId = task.Id;
            initTask();
        }
        return null;
    }
    public Pagereference clear() {
        task = new Task__c();    
        return null;
    }
    
     public Pagereference reset() {
        taskId = Apexpages.currentPage().getParameters().get('id');
        
        lstOutputFields = new List<String>();
        objConditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
        
        task = new Task__c();
        
        // Open Task for Edit
        if(taskId != null ) {
            lstOutputFields.clear();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('FKCategory__c');
            lstOutputFields.add('FKCategory__r.Id');
            lstOutputFields.add('categoryId__c');
            lstOutputFields.add('FKCategory__r.Name');
            lstOutputFields.add('FKImpact__r.Id');
            lstOutputFields.add('FKImpact__r.Name');
            lstOutputFields.add('impactId__c');
            lstOutputFields.add('FKUrgency__r.Id');
            lstOutputFields.add('FKUrgency__r.Name');
            lstOutputFields.add('urgencyId__c');
            lstOutputFields.add('FKPriority__r.Id');
            lstOutputFields.add('FKPriority__r.Name');
            lstOutputFields.add('priorityId__c');
            
            lstOutputFields.add('taskDescription__c');
            lstOutputFields.add('taskResolution__c');
            lstOutputFields.add('timeSpent__c');
            lstOutputFields.add('createdOn__c');
            lstOutputFields.add('completedDate__c');
            lstOutputFields.add('dueDateTime__c');
            
            lstOutputFields.add('assignedTo__c');
            lstOutputFields.add('FKSupplier__c');
            lstOutputFields.add('inactive__c');

            lstOutputFields.add('openDateTime__c');
            lstOutputFields.add('closeDateTime__c');
            lstOutputFields.add('firstNameAssignedTo__c');
            lstOutputFields.add('lastNameAssignedTo__c');
            lstOutputFields.add('FKAssignedTo__c');
            lstOutputFields.add('assignedToUserID__c');
            lstOutputFields.add('phone__c');
            
            lstOutputFields.add('incidentId__c');
            lstOutputFields.add('FKIncident__c');
            
            lstOutputFields.add('FKStatus__c');            
            lstOutputFields.add('FKStatus__r.Name');
            lstOutputFields.add('FKStatus__r.state__c');
            lstOutputFields.add('status__c');            
            
            String queryString='Id =' +'\''+taskId+'\'';  
                         
            objConditionBuilder.setCondition(queryString);
            List <Task__c> taskList = (List<Task__c>) objDriverAccess.selectObjects(new Task__c(),lstOutputFields,objConditionBuilder,null);
            if(taskList.size() > 0) {                     
                task = taskList[0];
                
            }
        }                
          
        return null;
    }
    
    public PageReference assignTaskTOQueue() {
    
            task.FKAssignedTo__c = null;
            task.assignedTo__c = '';            
            firstName = '';
            lastName = '';
            profile = null;
            phone = '';
            extension = '';

            task.OwnerId = savedId;
            lstOutputFields.clear();    
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('Owner.Name');
            
            queryString = 'Id = \'' + task.OwnerId+ '\'';
            objConditionBuilder.setCondition(queryString);
        
            List<Group> groupList = (List<Group> ) objDriverAccess .selectObjects(new Group(), lstOutputFields, objConditionBuilder, null);
            
            if(groupList.size() >0){
                queue = groupList[0].Name;                          
            }
            clearAssignState = false;                   
            return null;
         }

    
    public Pagereference fetchTaskTemplates(){
        system.debug('@@@@@@@@@@ ' + task);
        CommonUI commonUiObj=new CommonUI();
        mapForTemplate = (Map<String, String>) commonUiObj.getTemplateDataMap(task, templateId);
        system.debug('size is : '+mapForTemplate.size());   
        system.debug('map for template >>>>>  : '+mapForTemplate);   
        //commonUiObj.getTemplateDataMap(task, templateId);
        taskId = task.Id;
        initTask();
        return null;
        
    }
    
    public List<KVPair> getKeyValues(){     
       List<KVPair> lst = new List<KVPair>();
       if(mapForTemplate!=null){
           for(String key : mapForTemplate.keySet()){
                KVPair kvp=new KVPair();
                String subString= key.substring(0,2);
             if(subString!='FK'){
               kvp.key='task_'+key;
             }else{  
               kvp.key=key;
             }
                kvp.value=mapForTemplate.get(key);
                lst.add(kvp);
           }
           system.debug('size of the list is :' + lst.size());
       }
       return lst;
    }
    
    public class KVPair{
        public String key {get; set;}
        public String value {get; set;}
    }
    
    
    
 //Method Created By Sujeet to create tsks related to incident templates
    public void createTaskFromTemplate(Task__c task){
          System.debug('reaching till here'+task.FKIncident__c +'          '+task.FKTemplate__c);
              if(task.FKIncident__c != null && task.FKTemplate__c != null){
                System.debug('reaching till here'+task.FKIncident__c +'          '+task.FKTemplate__c);
              queryString='Id = '+'\'' +task.FKIncident__c+'\'';
              objConditionBuilder.setCondition(queryString);
              lstOutputFields.clear();
              lstOutputFields.add('Id');
              lstOutputFields.add('name');
              lstOutputFields.add('FKTemplate__c');
              List<Incident__c> taskRelatedIncident = (List<Incident__c>) objDriverAccess.selectObjects(new Incident__c(),lstOutputFields,objConditionBuilder,null);
              system.debug('size = '+taskRelatedIncident.size()+' , FKTemplate__c = '+taskRelatedIncident[0].FKTemplate__c);
              if(taskRelatedIncident.size()>0 && taskRelatedIncident[0].FKTemplate__c != null){
                system.debug('inside if');
                queryString='parentTemplateId__c = '+'\'' + taskRelatedIncident[0].FKTemplate__c +'\'order by orderNumber__c';
                objConditionBuilder.setCondition(queryString);
                lstOutputFields.clear();
                lstOutputFields.add('Id');
                lstOutputFields.add('name');
                lstOutputFields.add('orderNumber__c');
                lstOutputFields.add('linkedTemplateId__c');
                lstOutputFields.add('linkField__c');
                lstOutputFields.add('parentTemplateId__c');
                List<SYSTemplateLink__c> incidentRelatedTemplates = (List<SYSTemplateLink__c>) objDriverAccess.selectObjects(new SYSTemplateLink__c(),lstOutputFields,objConditionBuilder,null);  
                for(Integer i = 0; i<incidentRelatedTemplates.size(); i++)
                {
                
                  if(incidentRelatedTemplates[i].parentTemplateId__c == taskRelatedIncident[0].FKTemplate__c && incidentRelatedTemplates[i].linkedTemplateId__c == task.FKTemplate__c){
                    Task__c newtask = new Task__c();
                    List<Task__c> existingTempTasks;
                    if((i+1)!=incidentRelatedTemplates.size() && incidentRelatedTemplates[i+1]!=null){
                        queryString='FKTemplate__c = '+'\'' + incidentRelatedTemplates[i+1].linkedTemplateId__c +'\'and FKIncident__c='+'\''+task.FKIncident__c+'\'';
                      objConditionBuilder.setCondition(queryString);
                      lstOutputFields.clear();
                      lstOutputFields.add('Id');
                      lstOutputFields.add('name');
                      lstOutputFields.add('FKTemplate__c');
                      existingTempTasks = (List<Task__c>) objDriverAccess.selectObjects(new Task__c(),lstOutputFields,objConditionBuilder,null);
                    }
                    if(existingTempTasks==null || existingTempTasks.size()==0)
                    {
                      if((i+1)!=incidentRelatedTemplates.size() && incidentRelatedTemplates[i+1]!=null){
                        if(incidentRelatedTemplates[i+1]!=null){
                          newtask.FKIncident__c = task.FKIncident__c;
                          newtask.FKTemplate__c = incidentRelatedTemplates[i+1].linkedTemplateId__c;
                          
                          lstOutputFields.clear();
                          lstOutputFields.add('Id');
                          lstOutputFields.add('Name');
                          lstOutputFields.add('state__c');
                          lstOutputFields.add('defaultStatus__c');
              
                          queryString = 'state__c = true and ' + 'defaultStatus__c = true and ' + 'appliesToTask__c = true';
                      
                          objConditionBuilder.setCondition(queryString);
                      
                          List<Status__c> defaultStatus = (List<Status__c>) objDriverAccess.selectObjects(status,lstOutputFields,objConditionBuilder,null);                
                          if(defaultStatus.size() > 0) {
                              newtask.FKStatus__r = defaultStatus[0];
                              newtask.FKStatus__r.Name = defaultStatus[0].Name;
                              newtask.state__c = defaultStatus[0].state__c;
                              newtask.status__c = defaultStatus[0].Name;
                          }
                          
                          
                          CommonUI commonUiObj=new CommonUI();
                        newtask = (Task__c)commonUiObj.getTemplateData(newtask,incidentRelatedTemplates[i+1].linkedTemplateId__c);
                        upsert newtask;
                        }
                      }
                    }
                  }  
                }
              
              }
            }
    }
}
			                            	