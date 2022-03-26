public class CloseTaskController{

    public String messageString {get; set;}
    public Task__c task = new Task__c();
    String taskId{get; set;}
    public Category__c category{get; set;}
    List<StandardDescription__c> stdDescription;
    List<StandardResolution__c> stdResolution;
    public Boolean checkedUpdateDesc{get;set;}
    public Boolean checkedUpdateResolution{get;set;}
    String[] updateDescRes = new String[]{};
    Boolean isStdDesc = false;
    Boolean isStdRes = false;
    String stdDescId; 
    String categoryId;
    String categoryDesc;
    String statusId;
    Status__c selectedStatus;
    String closedById;
    
    List<String> lstOutputFields;
    String condition;
    ConditionBuilder conditionBuilder ;
    DriverAccess objDriverAccess;
    List<Task__c> incidents;
    
    public List<SelectOption> getUpdateList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('isStdDescription','Update Standard Description'));
        options.add(new SelectOption('isStdResolution','Update Standard Resolution'));                 
        return options;
    }
    
    public String getCategoryDesc(){
        return categoryDesc;
    }
    public void setCategoryDesc(String categoryDesc){
        this.categoryDesc = categoryDesc;
    }
    public String getStatusId(){
        return statusId;
    }
    public void setStatusId(String statusId){
        this.statusId = statusId;
    }
    
    public String getClosedById(){
        return closedById;
    }
    public void setClosedById(String closedById){
        this.closedById = closedById;
    }
    
    
    public String[] getUpdateDescRes(){
        return updateDescRes;
    } 
    
    public void setUpdateDescRes(String[] updateDescRes){
        this.updateDescRes = updateDescRes;
    }
    
    public String getCategoryId(){
        return categoryId;
    }
    public void setCategoryId(String categoryId){
        this.categoryId = categoryId;
    }
    public Category__c getCategory(){
        return category;
    }
      
    public void setCategory(Category__c cat){
        this.category = cat;
    }  
    
   public Task__c getTask(){
        return task;
    }

    public PageReference setSelectedClosedBy() {
    System.debug('------------------> closedBy' + closedByID);
        if(closedByID != null && closedByID != ''){
            
            lstOutputFields.clear();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            
            conditionBuilder.setCondition('Id = \'' + closedByID + '\'');
            List<User> usersList = (List<User> ) objDriverAccess.selectObjects(new User(), lstOutputFields, conditionBuilder, null);
            
            if(usersList.size() >0){
                task.FKClosedBy__c = usersList[0].Id;
                task.closedBy__c = usersList[0].Name;
            }
        }
        return null;
    }
    
    public PageReference setSelectedCategory(){

        lstOutputFields.clear();
        lstOutputFields.add('Name');
        lstOutputFields.add('Id');
        lstOutputFields.add('categoryDescription__c');
         
        condition = null;
        condition = 'Id =' + '\'' + categoryId + '\'';
        conditionBuilder.setCondition(condition);
        Category__c tempCategory = new Category__c();
        List<Category__c> categories = (List<Category__c>) objDriverAccess.selectObjects(tempCategory,lstOutputFields,conditionBuilder,null);
        //task.FKCategory__r = categories[0];
        //task.categoryId__c = task.FKCategory__r.Name;
        if(task.Id != null && categories.size() > 0){
            task.FKCategory__c = categories[0].Id;
            task.categoryId__c = categories[0].Name;
            categoryDesc = categories[0].categoryDescription__c;
            //task.FKCategory__r.categoryDescription__c = categories[0].categoryDescription__c;
            
        }
        
        return null;
    }
    
    public Pagereference setSelectedStatus(){
        
        lstOutputFields.clear();
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');
         
        condition = null;
        condition = 'Id =' + '\'' + statusId + '\'';
        
        conditionBuilder.setCondition(condition);
        Status__c tempStatus = new Status__c();
        List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
        //task.FKStatus__r = statuses[0];
        //task.statusId__c = task.FKStatus__r.Name;
        if(statuses.size() > 0) {
            task.FKStatus__c = statuses[0].Id;
            task.state__c = statuses[0].state__c;
            selectedStatus = statuses[0];
            task.status__c = statuses[0].Name;
        }
        
        
        return null;
    }
    
    public PageReference save() 
    {
        //create new stdDesc object if one does not existing with specified "Std Description" input and Update std desc checkbox is selected
        //create new stdResoltion object if one does not existing , in stdDesc , with specified "Std Resoltion" input and Update std resoltion checkbox is selected
        try{
          lstOutputFields.clear();
          lstOutputFields.add('Name');
          lstOutputFields.add('Id');
          lstOutputFields.add('categoryDescription__c');
           
          condition = null;
          condition = 'Name =' + '\'' + task.categoryId__c + '\'';
          conditionBuilder.setCondition(condition);
          Category__c tempCategory = new Category__c();
          List<Category__c> categories = (List<Category__c>) objDriverAccess.selectObjects(tempCategory,lstOutputFields,conditionBuilder,null);
          //task.FKCategory__r = categories[0];
          //task.categoryId__c = task.FKCategory__r.Name;
          if(task.Id != null && categories.size() > 0){
              task.FKCategory__c = categories[0].Id;
              task.categoryId__c = categories[0].Name;
              categoryDesc = categories[0].categoryDescription__c;
              //task.FKCategory__r.categoryDescription__c = categories[0].categoryDescription__c;
              
          }
          
          lstOutputFields.clear();
          lstOutputFields.add('Id');
          lstOutputFields.add('Name');
          lstOutputFields.add('state__c');
          lstOutputFields.add('defaultStatus__c');
           
          condition = null;
          condition = 'Name =' + '\'' + task.status__c + '\'';
          
          conditionBuilder.setCondition(condition);
          Status__c tempStatus = new Status__c();
          List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
          //task.FKStatus__r = statuses[0];
          //task.statusId__c = task.FKStatus__r.Name;
          if(statuses.size() > 0) {
              task.FKStatus__c = statuses[0].Id;
              task.state__c = statuses[0].state__c;
              selectedStatus = statuses[0];
              task.status__c = statuses[0].Name;
          }
          
          for(String str : updateDescRes){
              if(str.equals('isStdDescription'))
                  checkedUpdateDesc = true;
              if(str.equals('isStdResolution'))
                  checkedUpdateResolution = true;
          }
          if(task.taskDescription__c == null){
              task.taskDescription__c = '';
          }
          if(task.taskResolution__c == null)
              task.taskResolution__c = ''; 
  
          lstOutputFields.clear();
          lstOutputFields.add('Id');
          lstOutputFields.add('description__c');
          lstOutputFields.add('categoryDescription__c');
           
          condition = null;
          String categoryCondition = task.FKCategory__c;
          condition = 'FKCategory__c =' + '\'' + categoryCondition + '\'';
          conditionBuilder.setCondition(condition); 
          
          StandardDescription__c tempStdDesc = new StandardDescription__c();
          stdDescription = (List<StandardDescription__c>) objDriverAccess.selectObjects(tempStdDesc ,lstOutputFields,conditionBuilder,null);
          
          //stdDescription = [Select stdD.Description__c from StandardDescription__c stdD where stdD.FKCategory__c =: task.FKCategory__r.Id];
          //System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ' + stdDescription.size());
          
          if(stdDescription.size() > 0){
              
              for(StandardDescription__c stdDesc : stdDescription){
                  // for adding Standard Resolution in blank Standard Description Object...
                  if(task.taskDescription__c == '' && task.taskResolution__c != null)
                 {
                      if(stdDesc.Description__c == null){
                           stdDesc.Description__c = '';
                           StandardResolution__c stdResTemp = new StandardResolution__c(Resolution__c = task.taskResolution__c, StandardDescriptionId__c = stdDesc.Id); 
                           objDriverAccess.insertObject(stdResTemp, null);
                           //insert stdResTemp;
                      }
                 }
                 if(stdDesc.Description__c == null){
                     stdDesc.Description__c = '';
                 }
                 else if(stdDesc.Description__c.equals( task.taskDescription__c)){
                      isStdDesc = true;
                      stdDescId = stdDesc.Id;
                      break;
                  }
                  
              }
          }
          if(stdDescription.size() != 0){
              lstOutputFields.clear();
              lstOutputFields.add('Id');
              lstOutputFields.add('resolution__c');
              
              condition = null;
              //String reolutionCondition =  task.taskDescription__c;
              String reolutionCondition =  stdDescId;
              condition = 'FKStandardDescription__c=' + '\'' + reolutionCondition + '\'';
              conditionBuilder.setCondition(condition); 
              
              //StandardResolution__c tempStdRes = new StandardResolution__c();
              //stdResolution = (List<StandardResolution__c>) objDriverAccess.selectObjects(tempStdRes ,lstOutputFields,conditionBuilder,null);
              stdResolution = [Select stdR.Id, stdR.Resolution__c from StandardResolution__c stdR where stdR.StandardDescriptionId__c =: task.taskDescription__c];
  
              if(stdResolution.size() > 0){
                  for(StandardResolution__c stdRes : stdResolution){
                      if(stdRes.Resolution__c == null)
                          stdRes.Resolution__c = '';
                      else if(stdRes.Resolution__c.equals( task.taskResolution__c)){
                          isStdRes = true;
                      }
                  }
              }
          }
          else{
              stdResolution = new List<StandardResolution__c>();
          }
          
          if(checkedUpdateDesc && checkedUpdateResolution ) 
          {
              //if Standard Description's record exist for this Category do not add new Standard Description
              if(isStdDesc)
              {
                  // if Standard resolution does not exist for this Standard Description then add it to Std Descripption
                  if(!isStdRes){
                      updateStdResolution();
                  }
              }
              else     
              {   
                  // if Standard Description and Standard resolution does not exist and Update Standard Description , Update Standard resolution is checked  
                  // then add Standard Description record for this Category of incident and Standard Resolution for this Standard Description 
                  updateStdDescription();
                  updateStdResolution();
              }
          }
          else if(checkedUpdateDesc && !checkedUpdateResolution){ // if Standard Description is not exist and Update Standard resolution is not checked  
                                                                  // then add Standard Description record for this Category of incident       
              if(!isStdDesc){
                  updateStdDescription();
              }
          }
          if(task.categoryId__c == null ||task.categoryId__c =='')
               task.FKCategory__c=null;
               
          objDriverAccess.updateObject(task,null,null);
          //objDriverAccess.updateObject(inc, null, null);
          messageString = ''; 
        } catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
            } else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
            } 
        } 
        return null;
    }
    
    public void updateStdDescription(){
         StandardDescription__c stdDescTemp = new StandardDescription__c(Description__c = task.taskDescription__c, Inactive__c = false, FKCategory__c = task.FKCategory__r.Id );
         objDriverAccess.insertObject(stdDescTemp, null);
         stdDescId = stdDescTemp.Id;
         //insert stdDescTemp;
         //stdDescId = stdDescTemp.Id;
    }
    public void updateStdResolution(){
        StandardResolution__c stdResTemp = new StandardResolution__c(Resolution__c = task.taskResolution__c, Inactive__c = false);
        stdResTemp.FKStandardDescription__c = stdDescId;
        //insert stdResTemp;
        objDriverAccess.insertObject(stdResTemp, null);
    }
    
    public CloseTaskController(){
        
        taskId= Apexpages.currentPage().getParameters().get('taskId');
        
        lstOutputFields = new List<String>();
        conditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
        
        lstOutputFields.add('UrgencyId__c');
        lstOutputFields.add('openDateTime__c');
        lstOutputFields.add('Id');
        lstOutputFields.add('dueDateTime__c'); 
        lstOutputFields.add('FKImpact__c');        
        lstOutputFields.add('FKClient__c');
        lstOutputFields.add('FKCategory__c');
        lstOutputFields.add('CreatedDate');
        lstOutputFields.add('FKPriority__c');
        lstOutputFields.add('FKClosedBy__c');
        lstOutputFields.add('closeDateTime__c');
        lstOutputFields.add('FKStatus__c');
        //lstOutputFields.add('followUpDateTime__c');
        lstOutputFields.add('FKCategory__r.categoryDescription__c');
        //lstOutputFields.add('firstCallResolution__c');
        lstOutputFields.add('FKCategory__r.Name');
        lstOutputFields.add('taskDescription__c');
        lstOutputFields.add('taskResolution__c');
        //lstOutputFields.add('followUp__c');

        condition = 'id=' + '\''+taskId+'\'';

        conditionBuilder.setCondition(condition); 
        Task__c tempTask = new Task__c();
        
         /*this.inc = [Select i.UrgencyId__c,i.openDateTime__c, i.Id,
               i.dueDateTime__c,i.FKImpact__c, i.FKClient__c,
               i.FKCategory__c,i.CreatedDate, i.FKPriority__c, i.FKClosedBy__c, 
               i.closeDateTime__c, i.FKStatus__c, i.followUpDateTime__c,
               i.FKCategory__r.categoryDescription__c, i.firstCallResolution__c,
               i.FKCategory__r.Name, i.taskDescription__c, i.taskResolution__c,
               i.followUp__c
               From Task__c i where i.id =: taskId];*/
          
         List<Task__c> tasks =  (List<Task__c>) objDriverAccess.selectObjects(tempTask,lstOutputFields,conditionBuilder,null);

         if(tasks.size() > 0) { 
             task = tasks[0];
             categoryDesc = tasks[0].FKCategory__r.categoryDescription__c;
         }
         task.FKClosedBy__c = UserInfo.getUserId();
         task.closedBy__c = UserInfo.getName();
         task.closeDateTime__c = System.now();
          
         lstOutputFields.clear();
     
         lstOutputFields.add('Id');
         lstOutputFields.add('Name');
         lstOutputFields.add('state__c');
         lstOutputFields.add('defaultStatus__c');
         lstOutputFields.add('statusDescription__c');
         
         condition = null;   
         condition = 'state__c = false and ' + 'defaultStatus__c = true and ' + 'appliesToTask__c = true';
         conditionBuilder.setCondition(condition);
         Status__c tempStatus = new Status__c();
         List<Status__c> status = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
            
         /*Status__c[] status = [Select s.Id, s.Name, s.state__c from Status__c s where s.state__c =:'C' and s.defaultStatus__c =: true] ;*/
          
          
          if(status.size()!=0){
                task.FKStatus__c = status[0].Id;
                task.state__c = status[0].state__c;                
                task.status__c = status[0].Name;
                statusId = status[0].Name;
          }
          
          task.categoryId__c = task.FKCategory__r.Name;      
          categoryId = task.FKCategory__r.Name;     
          this.category = task.FKCategory__r;
          
          checkedUpdateDesc = false;
          checkedUpdateResolution= false;
    }
}
			                            	