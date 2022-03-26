public class ActionController{

    Action__c action;
    String userId;
    String actionId;
    String copyId;
    DriverAccess objDriverAccess ;
    ConditionBuilder objConditionBuilder;
    public String messageString {get; set;} 
    String columnName='Name';
    String direction= 'ASC';
    public String tempString {get; set;}
    
    public ActionController(){
        action = new Action__c();
        objDriverAccess = new DriverAccess();
         objConditionBuilder = new ConditionBuilder();
        actionId = Apexpages.currentPage().getParameters().get('id');
        columnName = ApexPages.CurrentPage().getParameters().get('columnField');
        direction = ApexPages.CurrentPage().getParameters().get('direction');   
        copyId = Apexpages.currentPage().getParameters().get('copyId');
         
        //Changes for Adding Child Cat when added from Cat details
             //Changes made by Sujeet
            String category_Id = ApexPages.CurrentPage().getParameters().get('Categoryid');
            action.FKCategory__c = category_Id;
            List<Category__c> lstcategory;
            if(category_Id != null && category_Id != ''){
              String qryString = 'Id = '+'\''+category_Id+'\'';
            objConditionBuilder.setCondition(qryString);
            lstcategory= (List<Category__c>)objDriverAccess.selectObjects(new Category__c(), null, objConditionBuilder, null);
            action.categoryId__c = lstcategory[0].Name; 
            }
         //Changes Ends here// 
         
        if((actionId != null && actionId != '') || (copyId !=null && copyId != '')){
            
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('appliesToConfigurationItems__c');
            lstOutputFields.add('appliesToIncident__c');
            lstOutputFields.add('AppliesToPreventiveMaintenance__c');
            lstOutputFields.add('appliesToPurchasing__c');
            lstOutputFields.add('appliesToTask__c');
            lstOutputFields.add('autoModify__c');
            lstOutputFields.add('cost__c');
            lstOutputFields.add('description__c');
            lstOutputFields.add('displayInSelfService__c');
            lstOutputFields.add('FKUser__c');
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('instruction__c');
            lstOutputFields.add('note__c');
            lstOutputFields.add('picture__c');
            lstOutputFields.add('system__c');
            lstOutputFields.add('trackTime__c');
            lstOutputFields.add('userId__c');
            
            String queryString = '';
          if((copyId !=null && copyId != '')){
            queryString='Id =' +'\''+copyId+'\'';  
                            
           }else {
             queryString='Id =' +'\''+actionId+'\'';  
           }
           
           objConditionBuilder.setCondition(queryString);
           List<Action__c> actionList = (List<Action__c>) objDriverAccess.selectObjects(action,lstOutputFields,objConditionBuilder,null);    
              if((actionList.size() > 0) && (copyId !=null && copyId != '')){
                  action = actionList[0];
                  copy();
                  
            }else if(actionList.size() > 0){
              action = actionList[0];
              }else {
                action = new Action__c();
              }
      }
    }
    
    public Action__c getAction(){
        return action;
    }
    
    public void setAction(Action__c action){
        this.action = action;
    }
    
    public String getActionId(){
        return actionId;
    }
    
    public void setActionId(String actionId){
        this.actionId = actionId;
    }
    
    public pagereference saveAction(){
        try{
          if(action.Id!=null){
               objDriverAccess.updateObject(action,null,null); 
  
            }else{
               objDriverAccess.insertObject(action, null); 
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
    public PageReference setSelectedUser(){
        
        return null;
    }
    public PageReference newAction(){
        //objDriverAccess.updateObject(action, null, null);
        action = new Action__c();
        return null;
    }
    public PageReference deleteAction(){
        System.debug('deleteAction');
         if(action !=null && action.Id !=null){
           System.debug('action' + action.Name);
              ConditionBuilder objConditionBuilder = new ConditionBuilder();
              String queryString='Id =' +'\''+action.Id+'\'';  
              objConditionBuilder.setCondition(queryString);
              objDriverAccess.deleteObject(action, objConditionBuilder, null);
            }
            return null;
    }
       
      public void copy(){     
           Action__c tempAction= action.clone(false,true);
          action = tempAction;
          action.name =null;
    }
    
    public Pagereference clear(){     
           action = null;
          action = new Action__c();
          return null;
    }
    
    public Pagereference reset(){     
           
        action = new Action__c();
        objDriverAccess = new DriverAccess();
        objConditionBuilder = new ConditionBuilder();
          
        if((actionId != null && actionId != '')){
            
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('appliesToConfigurationItems__c');
            lstOutputFields.add('appliesToIncident__c');
            lstOutputFields.add('AppliesToPreventiveMaintenance__c');
            lstOutputFields.add('appliesToPurchasing__c');
            lstOutputFields.add('appliesToTask__c');
            lstOutputFields.add('autoModify__c');
            lstOutputFields.add('cost__c');
            lstOutputFields.add('description__c');
            lstOutputFields.add('displayInSelfService__c');
            lstOutputFields.add('FKUser__c');
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('instruction__c');
            lstOutputFields.add('note__c');
            lstOutputFields.add('picture__c');
            lstOutputFields.add('system__c');
            lstOutputFields.add('trackTime__c');
            lstOutputFields.add('userId__c');
            
            String queryString = '';
          queryString='Id =' +'\''+actionId+'\'';  
           
           objConditionBuilder.setCondition(queryString);
           List<Action__c> actionList = (List<Action__c>) objDriverAccess.selectObjects(action,lstOutputFields,objConditionBuilder,null);    
           if(actionList.size() > 0){
              action = actionList[0];
           }else {
                action = new Action__c();
           }
      }
    
          return null;
    }
    public Pagereference previousBtnHandler(){
        if(action!=null){
          CommonUI commonUiObj=new CommonUI();
            action = (Action__c)commonUiObj.getSobject(action, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(action!=null){
            CommonUI commonUiObj=new CommonUI();
            action = (Action__c)commonUiObj.getSobject(action, tempString, columnName, direction, 'next');
        }
        return null;
        
    }
}
			                            	