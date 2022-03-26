public class CloseIncidentController{

    public Incident__c inc = new Incident__c();
    String incidentId{get; set;}
    public Category__c category{get; set;}
    List<StandardDescription__c> stdDescription;
    List<StandardResolution__c> stdResolution;
    public Boolean checkedUpdateDesc{get;set;}
    public Boolean checkedUpdateResolution{get;set;}
    String[] updateDescRes = new String[]{};
    Boolean isStdDesc = false;
    Boolean isStdRes = false;
    String stdDescId;
    String stdDescTempForRes; 
    String categoryId;
    String categoryDesc;
    String statusId;
    Status__c selectedStatus;
    String closedByUserId;
    
    public String closeDate{get;set;}
    
    List<String> lstOutputFields;
    String condition;
    ConditionBuilder conditionBuilder ;
    DriverAccess objDriverAccess;
    List<Incident__c> incidents;
    public String messageString {get; set;}
    
    public List<SelectOption> getUpdateList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('isStdDescription','Update Standard Description'));
        options.add(new SelectOption('isStdResolution','Update Standard Resolution'));                 
        return options;
    }
    
    public String getClosedByUserId(){
      return ClosedByUserId;
    }
    public void setClosedByUserId(String closedByUserId){
      this.closedByUserId = closedByUserId;
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
    
   public Incident__c getInc(){
        return inc;
    }
    
    public Pagereference setSelectedClosedBy(){
        
        if(inc.closedByUserId__c != null && inc.closedByUserId__c != ''){
            
            lstOutputFields = null;
            lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('FirstName');
            lstOutputFields.add('LastName');
            
            objDriverAccess = new DriverAccess();
            conditionBuilder = new ConditionBuilder();
            conditionBuilder.setCondition('Id = \'' + closedByUserId + '\'');
            
            List<User> usersList = (List<User> ) objDriverAccess.selectObjects(new User(), lstOutputFields, conditionBuilder, null);
            
            if(usersList.size() >0){
                inc.FKClosedBy__c = usersList[0].Id;
                inc.closedByUserId__c = usersList[0].Name;
                inc.FirstNameClosedBy__c = usersList[0].FirstName;
                inc.LastNameClosedBy__c = usersList[0].LastName;
            }
        }
        return null;
    }
    
    public Pagereference setSelectedClosedByNext(){
        
        
            lstOutputFields = null;
            lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('FirstName');
            lstOutputFields.add('LastName');
            
            objDriverAccess = new DriverAccess();
            conditionBuilder = new ConditionBuilder();
            conditionBuilder.setCondition('Name = \'' + closedByUserId + '\'');
            
            List<User> usersList = (List<User> ) objDriverAccess.selectObjects(new User(), lstOutputFields, conditionBuilder, null);
            System.debug('-------------------------------------------------------------------- >' + usersList[0].Name);
            if(usersList.size() >0 && inc.Id != null){
                inc.FKClosedBy__c = usersList[0].Id;
                inc.closedByUserId__c = usersList[0].Name;
                inc.FirstNameClosedBy__c = usersList[0].FirstName;
                inc.LastNameClosedBy__c = usersList[0].LastName;
            }
        return null;
    }
    
    public PageReference setSelectedCategory(){

        lstOutputFields = null;
        lstOutputFields = new List<String>();
        lstOutputFields.add('Name');
        lstOutputFields.add('Id');
        lstOutputFields.add('categoryDescription__c');
         
        condition = null;
        condition = 'Id =' + '\'' + categoryId + '\'';
        conditionBuilder.setCondition(condition);
        Category__c tempCategory = new Category__c();
        List<Category__c> categories = (List<Category__c>) objDriverAccess.selectObjects(tempCategory,lstOutputFields,conditionBuilder,null);
        //inc.FKCategory__r = categories[0];
        //inc.categoryId__c = inc.FKCategory__r.Name;
        System.debug('-------------------------------------------------------------------- >' + categories[0].Name);
        if(inc.Id != null && categories.size() > 0){
          System.debug('-------------------------------------------------------------------- >' + categories[0].Name);
          inc.FKCategory__c = categories[0].Id;
          inc.categoryId__c = categories[0].Name;
          categoryDesc = categories[0].categoryDescription__c;
          //inc.FKCategory__r.categoryDescription__c = categories[0].categoryDescription__c;
          
        }
        
        //upsert inc;
        
        return null;
    }

  public PageReference setSelectedCategoryNext(){

        lstOutputFields = null;
        lstOutputFields = new List<String>();
        lstOutputFields.add('Name');
        lstOutputFields.add('Id');
        lstOutputFields.add('categoryDescription__c');
         
        condition = null;
        condition = 'Name =' + '\'' + categoryId + '\'';
        conditionBuilder.setCondition(condition);
        Category__c tempCategory = new Category__c();
        List<Category__c> categories = (List<Category__c>) objDriverAccess.selectObjects(tempCategory,lstOutputFields,conditionBuilder,null);
        //inc.FKCategory__r = categories[0];
        //inc.categoryId__c = inc.FKCategory__r.Name;
        //System.debug('-------------------------------------------------------------------- >' + categories[0].Name);
        if(inc.Id != null && categories.size() > 0){
          System.debug('-------------------------------------------------------------------- >' + categories[0].Name);
          inc.FKCategory__c = categories[0].Id;
          inc.categoryId__c = categories[0].Name;
          categoryDesc = categories[0].categoryDescription__c;
          //inc.FKCategory__r.categoryDescription__c = categories[0].categoryDescription__c;
          
        }
        //upsert inc;
        return null;
    }
  
    
    public Pagereference setSelectedStatus(){
        
        lstOutputFields = null;
        lstOutputFields = new List<String>();
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');
         
        condition = null;
        condition = 'Id =' + '\'' + statusId + '\'';
        
        conditionBuilder.setCondition(condition);
        Status__c tempStatus = new Status__c();
        List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
        //inc.FKStatus__r = statuses[0];
        //inc.statusId__c = inc.FKStatus__r.Name;
        if(statuses.size()>0){
          inc.FKStatus__c = statuses[0].Id;
          selectedStatus = statuses[0];
          inc.statusId__c = statuses[0].Name;
          inc.state__c = statuses[0].state__c;
        }
        return null;
    }
    
    public Pagereference setSelectedStatusNext(){
        
        lstOutputFields = null;
        lstOutputFields = new List<String>();
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');
         
        condition = null;
        condition = 'Name =' + '\'' + statusId + '\'';
        
        conditionBuilder.setCondition(condition);
        Status__c tempStatus = new Status__c();
        List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
        //inc.FKStatus__r = statuses[0];
        //inc.statusId__c = inc.FKStatus__r.Name;
        System.debug('-------------------------------------------------------------------- >' + statuses[0].Name);
        if(statuses.size()>0){
          inc.FKStatus__c = statuses[0].Id;
          selectedStatus = statuses[0];
          inc.statusId__c = statuses[0].Name;
          inc.state__c = statuses[0].state__c;
        }
        return null;
    }
    
    public PageReference save() 
    {
        //create new stdDesc object if one does not existing with specified "Std Description" input and Update std desc checkbox is selected
        //create new stdResoltion object if one does not existing , in stdDesc , with specified "Std Resoltion" input and Update std resoltion checkbox is selected
        try{
        for(String str : updateDescRes){
            if(str.equals('isStdDescription'))
                checkedUpdateDesc = true;
            if(str.equals('isStdResolution'))
                checkedUpdateResolution = true;
        }
        if(inc.incidentDescription__c == null){
            inc.incidentDescription__c = '';
        }
        if(inc.incidentResolution__c == null)
            inc.incidentResolution__c = ''; 

        lstOutputFields = null;
        lstOutputFields = new List<String>();
     
        lstOutputFields.add('Id');
        lstOutputFields.add('description__c');
        lstOutputFields.add('categoryDescription__c');
         
        condition = null;
        String categoryCondition = inc.FKCategory__c;
        condition = 'FKCategory__c =' + '\'' + categoryCondition + '\'';
        conditionBuilder.setCondition(condition); 
        
        StandardDescription__c tempStdDesc = new StandardDescription__c();
        stdDescription = (List<StandardDescription__c>) objDriverAccess.selectObjects(tempStdDesc ,lstOutputFields,conditionBuilder,null);
        
        //stdDescription = [Select stdD.Description__c from StandardDescription__c stdD where stdD.FKCategory__c =: inc.FKCategory__r.Id];
        
        if(stdDescription.size() > 0){
            
            for(StandardDescription__c stdDesc : stdDescription){
                // for adding Standard Resolution in blank Standard Description Object...
                if(inc.incidentDescription__c == '' && inc.incidentResolution__c != null)
               {
                    if(stdDesc.Description__c == null){
                         stdDesc.Description__c = '';
                         StandardResolution__c stdResTemp = new StandardResolution__c(Resolution__c = inc.incidentResolution__c, StandardDescriptionId__c = stdDesc.Description__c); 
                         objDriverAccess.insertObject(stdResTemp, null);
                         //insert stdResTemp;
                    }
               }
               if(stdDesc.Description__c == null){
                   stdDesc.Description__c = '';
               }
               else if(stdDesc.Description__c.equals( inc.incidentDescription__c)){
                    isStdDesc = true;
                    stdDescId = stdDesc.Id;
                    break;
                }
                
            }
        }
        if(stdDescription.size() != 0){
            lstOutputFields = null;
            lstOutputFields = new List<String>();
     
            lstOutputFields.add('Id');
            lstOutputFields.add('resolution__c');
            
            condition = null;
            String reolutionCondition =  inc.incidentDescription__c;
            //String reolutionCondition =  stdDescId;
            condition = 'FKStandardDescription__c=' + '\'' + reolutionCondition + '\'';
            conditionBuilder.setCondition(condition); 
            
            //StandardResolution__c tempStdRes = new StandardResolution__c();
            //stdResolution = (List<StandardResolution__c>) objDriverAccess.selectObjects(tempStdRes ,lstOutputFields,conditionBuilder,null);
            stdResolution = [Select stdR.Id, stdR.Resolution__c from StandardResolution__c stdR where stdR.StandardDescriptionId__c =: inc.incidentDescription__c];

            if(stdResolution.size() > 0){
                for(StandardResolution__c stdRes : stdResolution){
                    if(stdRes.Resolution__c == null)
                        stdRes.Resolution__c = '';
                    else if(stdRes.Resolution__c.equals( inc.incidentResolution__c)){
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
        //upsert inc;
          objDriverAccess.updateObject(inc, null, null); 
      messageString = '';  
         }catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
             }else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
             } 
        }
        return null;
    }
    
    public void updateStdDescription(){
         StandardDescription__c stdDescTemp = new StandardDescription__c(Description__c = inc.incidentDescription__c, Inactive__c = false, FKCategory__c = inc.FKCategory__r.Id );
         objDriverAccess.insertObject(stdDescTemp, null);
         stdDescId = stdDescTemp.Id;
         stdDescTempForRes = stdDescTemp.Description__c;
         //insert stdDescTemp;
         //stdDescId = stdDescTemp.Id;
    }
    public void updateStdResolution(){
        StandardResolution__c stdResTemp = new StandardResolution__c(Resolution__c = inc.incidentResolution__c, Inactive__c = false);
        stdResTemp.FKStandardDescription__c = stdDescId;
        stdResTemp.standardDescriptionId__c = stdDescTempForRes;
        //insert stdResTemp;
        objDriverAccess.insertObject(stdResTemp, null);
    }
   
    public CloseIncidentController(){
        
        incidentId= Apexpages.currentPage().getParameters().get('incidentID');
        
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
        lstOutputFields.add('followUpDateTime__c');
        lstOutputFields.add('FKCategory__r.categoryDescription__c');
        lstOutputFields.add('firstCallResolution__c');
        lstOutputFields.add('FKCategory__r.Name');
        lstOutputFields.add('incidentDescription__c');
        lstOutputFields.add('incidentResolution__c');
        lstOutputFields.add('followUp__c');
        lstOutputFields.add('state__c');

        condition = 'id=' + '\''+incidentId+'\'';
        conditionBuilder.setCondition(condition); 
        Incident__c tempIncident = new Incident__c();
        
         /*this.inc = [Select i.UrgencyId__c,i.openDateTime__c, i.Id,
               i.dueDateTime__c,i.FKImpact__c, i.FKClient__c,
               i.FKCategory__c,i.CreatedDate, i.FKPriority__c, i.FKClosedBy__c, 
               i.closeDateTime__c, i.FKStatus__c, i.followUpDateTime__c,
               i.FKCategory__r.categoryDescription__c, i.firstCallResolution__c,
               i.FKCategory__r.Name, i.incidentDescription__c, i.incidentResolution__c,
               i.followUp__c
               From Incident__c i where i.id =: incidentId];*/
          
         incidents =  (List<Incident__c>) objDriverAccess.selectObjects(tempIncident ,lstOutputFields,conditionBuilder,null);
     
     if(incidents.size()>0){
           inc = incidents[0];
           inc.FKClosedBy__c = UserInfo.getUserId();
           inc.closedByUserId__c = UserInfo.getName();
           closedByUserId = UserInfo.getName();
           inc.closeDateTime__c = System.now();
            closeDate= (inc.closeDateTime__c).format();
           lstOutputFields = null;
           lstOutputFields = new List<String>();
       
           lstOutputFields.add('Id');
           lstOutputFields.add('Name');
           lstOutputFields.add('state__c');
           lstOutputFields.add('defaultStatus__c');
           lstOutputFields.add('statusDescription__c');
           
           condition = null;   
           condition = 'state__c = false and defaultStatus__c = true';
           conditionBuilder.setCondition(condition);
           Status__c tempStatus = new Status__c();
           List<Status__c> status = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
              
           /*Status__c[] status = [Select s.Id, s.Name, s.state__c from Status__c s where s.state__c =:'C' and s.defaultStatus__c =: true] ;*/
            
            
            if(status.size()!=0){
                  inc.FKStatus__c = status[0].Id;
                  inc.statusId__c = status[0].Name;
                  inc.state__c = status[0].state__c;
                  statusId = status[0].Name;
            }
            
              inc.categoryId__c = inc.FKCategory__r.Name;      
              categoryId = inc.FKCategory__r.Name;    
              categoryDesc =  inc.FKCategory__r.categoryDescription__c;
              this.category = inc.FKCategory__r;
       }
       checkedUpdateDesc = false;
       checkedUpdateResolution= false;
    }
}
			                            	