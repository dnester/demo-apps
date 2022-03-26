public class IncidentHistoryController 
{
    
    
    public IncidentHistory__c incidentHistory = new IncidentHistory__c();
   
    String userId;
    String Id;
    String incidentId;
    String incidentHistroyId;
    String actionId;
    public Incident__c incident;
    public Action__c action;
    DriverAccess objDriverAccess ;
    ConditionBuilder objConditionBuilder; 
    public String messageString {get; set;} 
    
  

    public IncidentHistoryController()
    {
        incidentHistory=new  IncidentHistory__c();
         incidentHistory.date__c=System.now();
         
            incidentId = ApexPages.CurrentPage().getParameters().get('incidentId');
            incidentHistory.FKIncident__c = incidentId;
         
            incidentHistroyId = ApexPages.CurrentPage().getParameters().get('id');
            if(incidentHistroyId!=null && incidentHistroyId != '')
        {
            List <String>isOutputFields=new List<String>();
            isOutputFields.add('userId__c');
            isOutputFields.add('system__c');
            isOutputFields.add('note__c');
            isOutputFields.add('noteExists__c');
            isOutputFields.add('incidentId__c');
            isOutputFields.add('inactive__c');
            isOutputFields.add('duration__c');
            isOutputFields.add('description__c');
            isOutputFields.add('date__c');
            isOutputFields.add('actionId__c');
            isOutputFields.add('Name');
            isOutputFields.add('Id');
            isOutputFields.add('FKUser__c');
            isOutputFields.add('FKIncident__c');
            isOutputFields.add('FKAction__c');            
                       
            String queryString='Id =' +'\''+incidentHistroyId+'\'';  
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
            objConditionBuilder.setCondition(queryString);
            objDriverAccess = new DriverAccess();
                      
            List<IncidentHistory__c> incidentHistoryList = (List<IncidentHistory__c>) objDriverAccess.selectObjects( incidentHistory,isOutputFields,objConditionBuilder,null);    
            if(incidentHistoryList.size() > 0)
            {
               incidentHistory = incidentHistoryList[0];
             }
            
  
     }
      }

  
    public void setActionId(String actionId)
    {
    
        this.actionId=actionId;

    }
     public String getActionId()
     {

        return ActionId;
    }

    public void setIncidentId(String incidentId)
    {
      
       this.incidentId=incidentId;
    
    }
    
    public String getIncidentId()
    {

        return incidentId;
    }

    public void setUserId(String userId)
    {
        this.userId=userId;
    
                       
    }
    
    public String getUserId()
    {

        return userId;
    }
    public IncidentHistory__c getIncidentHistory()
    {
        return incidentHistory;
    }
    public void setIncidentHistory(IncidentHistory__c incidentHistory)
    {
        this.incidentHistory=incidentHistory;
    }
    /*
* To Insert the new records.
*/
    public PageReference save(){ 
        try{
              String queryString;
              objDriverAccess = new DriverAccess();
              List<String> lstOutputFields = new List<String>();
    
                lstOutputFields.add('Id');
                lstOutputFields.add('Name');   
                if(incidentId!=null && incidentId!=''){
                    queryString = 'Id =' +'\''+incidentId+'\'';  
                            
                    ConditionBuilder objConditionBuilder = new ConditionBuilder();
                    objConditionBuilder.setCondition(queryString);    
                
                    incident = new Incident__c();
                    
                    objDriverAccess = new DriverAccess();
                    List<Incident__c> incidentList= (List <Incident__c>) objDriverAccess.selectObjects(incident,lstOutputFields,objConditionBuilder,null); 
                    if(incidentList.size() >0)
                    {
             
                        incidentHistory.incidentId__c = incidentList[0].Name;                     
                    }

                }
                
                lstOutputFields.clear();
                lstOutputFields.add('Id');
                lstOutputFields.add('Name');
                lstOutputFields.add('system__c');
                lstOutputFields.add('description__c');  
                if(actionId!=null && actionId!=''){
                    queryString = 'Id =' +'\''+actionId+'\''+ ' And system__c = false';  
                            
                    objConditionBuilder = new ConditionBuilder();
                    
                    objConditionBuilder.setCondition(queryString);    
                
                    action = new Action__c();
                    
                    objDriverAccess = new DriverAccess();
                    List<Action__c> actionList= (List <Action__c>) objDriverAccess.selectObjects(action,lstOutputFields,objConditionBuilder,null); 
                    if(actionList.size() >0)
                    {
                     
                        incidentHistory.actionId__c = actionList[0].Name; 
                        incidentHistory.FKAction__c= actionList[0].Id;            
                        incidentHistory.system__c = actionList[0].system__c; 
                        incidentHistory.description__c= actionList[0].description__c;
                    }
                }
      
              if(incidentHistory.Id!= null){
                 objDriverAccess.updateObject(incidentHistory,null,null);
              }else{
                  objDriverAccess.insertObject(incidentHistory,null);
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
    public PageReference newIncident() 
    {
        
        incidentHistory=new  IncidentHistory__c();
        return null;
    }


    public PageReference incidentQuery()
    {
        
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+incidentId+'\'';  
                
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
    
        incident = new Incident__c();
        
        objDriverAccess = new DriverAccess();
        List<Incident__c> incidentList= (List <Incident__c>) objDriverAccess.selectObjects(incident,lstOutputFields,objConditionBuilder,null); 
        if(incidentList.size() >0)
        {
 
            incidentHistory.incidentId__c = incidentList[0].Name; 
            incidentHistory.FKIncident__c =  incidentList[0].Id;
        }
                
        return null;
    }   

    public PageReference actionQuery()
    {
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('system__c');
        lstOutputFields.add('description__c');        
        String queryString = 'Id =' +'\''+actionId+'\''+ ' And system__c = false';  
                
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
        action = new Action__c();
        
        objDriverAccess = new DriverAccess();
        List<Action__c> actionList= (List <Action__c>) objDriverAccess.selectObjects(action,lstOutputFields,objConditionBuilder,null); 
        if(actionList.size() >0)
        {
         
            incidentHistory.actionId__c = actionList[0].Name; 
            incidentHistory.FKAction__c= actionList[0].Id;            
            incidentHistory.system__c = actionList[0].system__c; 
            incidentHistory.description__c= actionList[0].description__c;
        }

      return null;
   }
   public PageReference userQuery()
   {
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+userId+'\'';  
                
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
    
        User user = new User();
        
        objDriverAccess = new DriverAccess();
        List<User> userList= (List <User>) objDriverAccess.selectObjects(user,lstOutputFields,objConditionBuilder,null); 
        if(userList.size() >0)
        {
 
            incidentHistory.userId__c = userList[0].Name; 
            incidentHistory.FKUser__c= userList[0].Id;
      
        }

      return null;
   }

}
			                            	