public class BroadCastCloseController
{
    public Broadcasts__c broadCast = new Broadcasts__c();
    String broadCastId{get; set;}
    public Category__c category{get; set;}
    List<StandardDescription__c> stdDescription;
    List<StandardResolution__c> stdResolution;
    public Boolean checkedUpdateDesc{get;set;}
    public String messageString {get; set;}
    public Boolean checkedUpdateResolution{get;set;}
    String[] updateDescRes = new String[]{};
    Boolean isStdDesc = false;
    Boolean isStdRes = false;
    String stdDescId; 
    
    List<String> listFieldNames;
    String condition;
    ConditionBuilder conditionBuilder ;
    DriverAccess objDriverAccess;
    
    
    List<Broadcasts__c> broadcasts;
    
    public List<SelectOption> getUpdateList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('isStdDescription','Update Standard Description'));
        options.add(new SelectOption('isStdResolution','Update Standard Resolution'));                 
        return options;
    }

    public String[] getUpdateDescRes(){
        return updateDescRes;
    } 
    
    public void setUpdateDescRes(String[] updateDescRes){
        this.updateDescRes = updateDescRes;
    }
    
    
    public Category__c getCategory(){
        return category;
    }
      
    public void setCategory(Category__c cat){
        this.category = cat;
    }  
    
     public Broadcasts__c getbroadCast(){
        return broadCast ;
    }
    
    String closedByID;
    
    public String getClosedByID(){
        return this.closedByID;
    }
    public void setClosedByID(String closedByID){
         this.closedByID = closedByID;
    }
    
     String closedBy;
    
    public String getClosedBy(){
        return this.closedBy;
    }
    public void setClosedBy(String closedBy){
         this.closedBy = closedBy;
    }
    
    String categoryId;
    
    public String getCategoryId(){
        return this.categoryId;
    }
    public void setCategoryId(String categoryId){
         this.categoryId = categoryId;
    }
    
    
    
    String statusId;
    
    public String getStatusId(){
        return this.statusId;
    }
    public void setStatusId(String statusId){
         this.statusId = statusId;
    }
    
     String statusName;
    
    public String getStatusName(){
        return this.statusName;
    }
    public void setStatusName(String statusName){
         this.statusName = statusName;
    }
    
    String categoryName;
    
    public String getCategoryName(){
        return this.categoryName;
    }
    public void setCategoryName(String categoryName){
         this.categoryName = categoryName;
    }
    
    
    String categoryDescription;
    
    public String getCategoryDescription(){
        return this.categoryDescription;
    }
    public void setCategoryDescription(String categoryDescription){
         this.categoryDescription = categoryDescription;
    }
    public PageReference setSelectedCategory(){

        
        listFieldNames= null;
        conditionBuilder = new ConditionBuilder();
        objDriverAccess= new DriverAccess();
        listFieldNames= new List<String>();
     
        listFieldNames.add('Id');
        listFieldNames.add('categoryDescription__c');
         
        condition = null;
        String temp =  broadCast.FKCategory__c; 
        condition = 'Name =' + temp;
        conditionBuilder.setCondition(condition); 
        Category__c tempCategory = new Category__c();
        List<Category__c> categories = (List<Category__c>) objDriverAccess.selectObjects(tempCategory,listFieldNames,conditionBuilder,null);
        category =  categories[0];   

        broadCast.FKCategory__r = category;
        return null;
    }
    
    public void updateStdDescription(){
        
        objDriverAccess= new DriverAccess();
        StandardDescription__c stdDescTemp = new StandardDescription__c(Description__c = broadCast.broadcastDescription__c, Inactive__c = false, CategoryId__c = broadCast.FKCategory__r.Id );
        objDriverAccess.insertObject(stdDescTemp, null);
         
    }
    public void updateStdResolution(){
        StandardResolution__c stdResTemp = new StandardResolution__c(Resolution__c = broadCast.broadcastResolution__c, Inactive__c = false);
        stdResTemp.StandardDescriptionId__c = stdDescId;
        objDriverAccess= new DriverAccess();
        objDriverAccess.insertObject(stdResTemp, null);
    }
    
    
    public BroadCastCloseController(){
      broadCastId = Apexpages.currentPage().getParameters().get('broadCastId');
     
        conditionBuilder = new ConditionBuilder();
        objDriverAccess= new DriverAccess();
        listFieldNames= new List<String>();
            
        if(broadCastId != null && broadCastId !=''){
            listFieldNames = new List<String>();
            conditionBuilder = new ConditionBuilder();
            objDriverAccess = new DriverAccess();
        
            listFieldNames.add('Id');
            listFieldNames.add('urgencyId__c');
            listFieldNames.add('FKUserIdClosedBy__c');
            listFieldNames.add('FKUserIdAssignedTo__c');
            listFieldNames.add('FKUrgency__c');
            listFieldNames.add('FKStatus__c');
            listFieldNames.add('FKPriority__c');
            listFieldNames.add('FKImpact__c');
            listFieldNames.add('FKClosedBy__c');
            listFieldNames.add('FKCategory__c');
            listFieldNames.add('FKClosedBy__r.Name');
            listFieldNames.add('FKCategory__r.Name');
            listFieldNames.add('Name');
            listFieldNames.add('UserIDAssignedTo__c');
            listFieldNames.add('UserIDClosedBy__c');
            listFieldNames.add('broadcastDescription__c');
            listFieldNames.add('broadcastResolution__c');
            listFieldNames.add('categoryId__c');
            listFieldNames.add('closeDateTime__c');
            listFieldNames.add('closedById__c');
            listFieldNames.add('displayInClientService__c');
            listFieldNames.add('expirationDate__c');
            listFieldNames.add('inactive__c');
            listFieldNames.add('note__c');
            listFieldNames.add('postDate__c');
            listFieldNames.add('priorityId__c');
            listFieldNames.add('state__c');
            listFieldNames.add('statusDescription__c');
            listFieldNames.add('statusId__c');
            listFieldNames.add('FKStatus__r.Name');
            listFieldNames.add('FKStatus__r.state__c');
            listFieldNames.add('FKCategory__r.categoryDescription__c');
            
            
            condition = 'id=' + '\''+broadCastId +'\'';

            conditionBuilder.setCondition(condition); 
            Broadcasts__c tempBroadCast = new Broadcasts__c();
            
            broadcasts =  (List<Broadcasts__c>) objDriverAccess.selectObjects(tempBroadCast ,
                                            listFieldNames,conditionBuilder,null);
            
            if(broadcasts.size()>0){

            broadCast = broadcasts[0];
            broadCast.FKClosedBy__c = UserInfo.getUserId();
            broadCast.closeDateTime__c = System.now();
           // statusName = broadCast.FKStatus__r.Name;
            categoryName = broadCast.FKCategory__r.Name;
            categoryDescription =  broadCast.FKCategory__r.categoryDescription__c;
            closedBy = Userinfo.getName();
           
            listFieldNames= null;
            listFieldNames= new List<String>();
     
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            listFieldNames.add('state__c');
         
            condition = null;   
            condition = 'state__c = false AND defaultStatus__c = true AND appliesToBroadcasts__c = true';
          conditionBuilder.setCondition(condition);
            List<Status__c> statusList = (List<Status__c>) objDriverAccess.selectObjects(new Status__c(),listFieldNames,conditionBuilder,null);
         
            if(statusList.size()>0){
               broadCast.FKStatus__c = statusList[0].Id;
               statusName = statusList[0].Name;
            }
            broadCast.closeDateTime__c = System.now();
               
            this.category = broadCast.FKCategory__r;
            checkedUpdateDesc = false;
            checkedUpdateResolution= false;
            }
          }
        }
        
     public String dateTimeobj;
      public void setdateTime(){
            Datetime thisDT = System.now();
            String myDate = thisDT.format('yyyy-MM-dd HH:mm:ss','PST'); 
            this.dateTimeobj = Datetime.valueOf(myDate) + '';
    }  
    
     public String  getdateTime(){
        return dateTimeobj;
    }

    public Pagereference populateCategory(){
        
        if(categoryId != null && categoryId != ''){
            
            listFieldNames = new List<String>();
            conditionBuilder = new ConditionBuilder();
            objDriverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            listFieldNames.add('categoryDescription__c');
            
            
            conditionBuilder.setCondition('Name = \'' + categoryId + '\'');
            List<Category__c> categoryList = (List<Category__c> ) objDriverAccess.selectObjects(new Category__c(), listFieldNames, conditionBuilder, null);
            
            if(categoryList.size() >0){
                broadcast.FKCategory__c = categoryList[0].Id;
                categoryName = categoryList[0].Name;
                categoryDescription = categoryList[0].categoryDescription__c;
            }
        }
        return null;
    }
        
   public Pagereference populateClosedBy(){
        
        if(closedByID != null && closedByID != ''){
            
            listFieldNames = new List<String>();
            conditionBuilder = new ConditionBuilder();
            objDriverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            conditionBuilder.setCondition('Id = \'' + closedByID + '\'');
            List<User> usersList = (List<User> ) objDriverAccess.selectObjects(new User(), listFieldNames, conditionBuilder, null);
            
            if(usersList.size() >0){
                broadcast.FKClosedBy__c = usersList[0].Id;
                closedBy = usersList[0].Name;
            }
        }
        return null;
    }
    
     public Pagereference populateStatus(){
        
        if(statusId != null && statusId != ''){
            
            listFieldNames = new List<String>();
            conditionBuilder = new ConditionBuilder();
            objDriverAccess = new DriverAccess();
            
            listFieldNames.add('Id');
            listFieldNames.add('Name');
            
            conditionBuilder.setCondition('Id = \'' + statusId + '\'');
            List<Status__c> statusList = (List<Status__c> ) objDriverAccess.selectObjects(new Status__c(), listFieldNames, conditionBuilder, null);
            
            if(statusList.size() >0){
                broadcast.FKStatus__c = statusList[0].Id;
                statusName = statusList[0].Name;
            }
        }
        return null;
    }
    
    public PageReference save() {
     
    try{ 
     listFieldNames = new List<String>();
     conditionBuilder = new ConditionBuilder();
     objDriverAccess = new DriverAccess();
     if(broadCast != null){
       for(String str : updateDescRes){
            if(str.equals('isStdDescription'))
                checkedUpdateDesc = true;
            if(str.equals('isStdResolution'))
                checkedUpdateResolution = true;
        }
          setdateTime();
          if(broadcast.expirationDate__c != null && broadcast.postDate__c != null 
                        && broadcast.expirationDate__c < broadcast.postDate__c
                         && broadcast.expirationDate__c < System.now()){
                    messageString =Label.BRDExpriationDateExp;
                    throw new FormValidationException(messageString);
               }
      conditionBuilder = new ConditionBuilder();
          objDriverAccess= new DriverAccess();
          listFieldNames= new List<String>();
          
          listFieldNames.add('Id');
          listFieldNames.add('Name');
          listFieldNames.add('state__c');
          condition = null;   
          condition = 'Name =\''+ statusName +'\'';
          conditionBuilder.setCondition(condition);
          Status__c tempStatus = new Status__c();
          List<Status__c> statusList = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,listFieldNames,conditionBuilder,null);
          if(statusList.size()>0){
           broadCast.FKStatus__c = statusList[0].Id;
           broadCast.FKStatus__r.Name = statusList[0].Name;
           broadCast.state__c = statusList[0].state__c;
          }
              
           if(categoryId != null && categoryId != ''){
               broadcast.FKCategory__c = categoryId;  
           }else{ 
              listFieldNames.clear();
                listFieldNames.add('Id');
                listFieldNames.add('Name');
                conditionBuilder.setCondition('Name = \''+  categoryName +'\'');
                    
                List<Category__c> categoryList = (List<Category__c>) objDriverAccess.selectObjects(new Category__c(),listFieldNames,conditionBuilder,null);
                 
                if(categoryList.size() > 0){
                    
                    broadcast.FKCategory__c =  categoryList[0].Id;
                }
           }
          
          condition = null;
          
          conditionBuilder.setCondition('Id =\'' + broadCast.Id +'\'' );
          objDriverAccess.updateObject(broadCast, conditionBuilder, null);
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
			                            	