public class StatusController {

 public Status__c status{get; set;}
 DriverAccess objDriverAccess ;
 ConditionBuilder objConditionBuilder; 

 public String state{get; set;}
 public String messageString {get; set;}
 String columnName='Name';
 String direction= 'ASC';
 public String tempString {get; set;} 
 /* public String statusID {get;set;}
 
 public String stateOption {get;set;}
 
 public String description {get;set;}
 
 public String ErrorMessage{get;set;} */
  String statusId;
  String copyId;
  
public StatusController() {

   status=new Status__c(); 
   objDriverAccess = new DriverAccess();
   objConditionBuilder = new ConditionBuilder();
   
    statusId = ApexPages.CurrentPage().getParameters().get('id');
    columnName = ApexPages.CurrentPage().getParameters().get('columnField');
    direction = ApexPages.CurrentPage().getParameters().get('direction');
    copyId = ApexPages.CurrentPage().getParameters().get('copyId');
     List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('system__c');
            lstOutputFields.add('statusDescription__c');
            lstOutputFields.add('state__c');
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('defaultStatus__c');
            lstOutputFields.add('appliesToTask__c');
            lstOutputFields.add('appliesToServices__c');
            lstOutputFields.add('appliesToPreventiveMaintenance__c');
            lstOutputFields.add('appliesToSLA__c');
            lstOutputFields.add('appliesToPurchasing__c');
            lstOutputFields.add('appliesToIncident__c');
            lstOutputFields.add('appliesToConfigurationItems__c');
            lstOutputFields.add('appliesToChange__c');
            lstOutputFields.add('appliesToBroadcasts__c');
            
      List<Status__c> listofStatus = null;
      
       if((statusId != null  && statusId != '' )|| (copyId != null && copyId != '')){
            
            String queryString = '';
           if(statusId != null  && statusId != '' ){
             queryString='Id =' +'\''+statusId+'\'';  
           }else if((copyId !=null && copyId != '')){
            queryString='Id =' +'\''+copyId+'\'';  
                            
           }
           
           objConditionBuilder.setCondition(queryString);
            listofStatus = (List<Status__c>)objDriverAccess.selectObjects(new Status__c(), lstOutputFields, objConditionBuilder, null);
            
        if(statusId != null && statusId != '' && listofStatus.size() > 0){
            status = listofStatus[0]; 
            copyId =null;
        }else if(copyId != null && copyId != '' && listofStatus.size() > 0){
            status = listofStatus[0]; 
            copy();
       }else{
           status = new Status__c();
       }
  
 }
}
 
 public List<SelectOption> getStateValue() {
          List<SelectOption> options = new List<SelectOption>(); 
            options.add(new SelectOption('Open','Open')); 
            options.add(new SelectOption('Close','Close')); 
            
            if(status.state__c==true){
            
               state='Open';
            } else {
              
              state='Close';
            }
            
            
         return options;
        }
 
 
 public PageReference save() {
 
  // System.debug('TEsting finction');
  
 /*  if(status__c.name==null){
  
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,
                       'Validation Failed: Status ID is required.'));
  } */                     
                       
    try{
          if(state=='Open' || state==null){
              status.state__c=true;
          }else if(state=='Close'){
              status.state__c=false;
          }
          
          if(status.Id != null){
              upsert status;
          }
          else
              insert status;
              
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
 
  public PageReference newStatus() {
     status = new Status__c();
     status.state__c=true;
     
     return null;
  }
  
       public PageReference deleteStatus(){
            
              if(status !=null && status.Id !=null){
              ConditionBuilder objConditionBuilder = new ConditionBuilder();
              String queryString='Id =' +'\''+status.Id+'\'';  
              objConditionBuilder.setCondition(queryString);
              objDriverAccess.deleteObject(status, objConditionBuilder, null);
            }
            copyId=null;
            statusId= null;
            
            return null;
    } 
    
    public void copy(){     
           Status__c tempStatus= status.clone(false,true);
          status = tempStatus;
          status.name = null;
    }
        public Pagereference previousBtnHandler(){
        if(status!=null){
            CommonUI commonUiObj=new CommonUI();
            status = (Status__c)commonUiObj.getSobject(status, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(status!=null){
            CommonUI commonUiObj=new CommonUI();
            status = (Status__c)commonUiObj.getSobject(status, tempString, columnName, direction, 'next');
        }
        return null;
    }
    public PageReference clear() {
       status = new Status__c();
       
       return null;
  }
  
    public PageReference reset() {

     status=new Status__c(); 
     objDriverAccess = new DriverAccess();
     objConditionBuilder = new ConditionBuilder();
     
      statusId = ApexPages.CurrentPage().getParameters().get('id');
      List<String> lstOutputFields = new List<String>();
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('system__c');
        lstOutputFields.add('statusDescription__c');
        lstOutputFields.add('state__c');
        lstOutputFields.add('inactive__c');
        lstOutputFields.add('defaultStatus__c');
        lstOutputFields.add('appliesToTask__c');
        lstOutputFields.add('appliesToServices__c');
        lstOutputFields.add('appliesToPreventiveMaintenance__c');
        lstOutputFields.add('appliesToSLA__c');
        lstOutputFields.add('appliesToPurchasing__c');
        lstOutputFields.add('appliesToIncident__c');
        lstOutputFields.add('appliesToConfigurationItems__c');
        lstOutputFields.add('appliesToChange__c');
        lstOutputFields.add('appliesToBroadcasts__c');
              
      List<Status__c> listofStatus = null;
      
       if((statusId != null  && statusId != '' )){
            
        String queryString='Id =' +'\''+statusId+'\'';  
                  
       objConditionBuilder.setCondition(queryString);
        listofStatus = (List<Status__c>)objDriverAccess.selectObjects(new Status__c(), lstOutputFields, objConditionBuilder, null);
        
        if(statusId != null && statusId != '' && listofStatus.size() > 0){
            status = listofStatus[0]; 
       }else{
           status = new Status__c();
       }
  
   }
     
     return null;
  }
}
			                            	