public class ClientController {    

     public Client__c client;
     String  organizationId;
     String urgencyId;
     public Urgency__c urgency;
     String [] organizationList;
     String Id;
   public String clientId {get; set;}
   String columnName='Name';
     String direction= 'ASC';
   public String tempString {get; set;}
     public Organization__c organization;      
     private DriverAccess driverAccess= new DriverAccess();       
     String tbd='TBD';     
     public String messageString {get; set;}                                                     
      
    
    public void setClient(Client__c client){
         this.client= client;
    }
    public Client__c getClient(){
        return client;
    }
    public void setOrganizationId(String organizationId){
         this.organizationId= organizationId;
    }
    public String getOrganizationId(){
        return organizationId;
    }
     
    public void setUrgencyId(String urgencyId){
        
        this.urgencyId= urgencyId;        
    }
    
    public String getUrgencyId(){

        return urgencyId;
    }
    
    
    public void setTbd(String tbd){
        
        this.tbd= tbd;        
    }
    
    public String getTbd(){

        return tbd;
    }
    
    
     public clientController(){
       ConditionBuilder objConditionBuilder = new ConditionBuilder();
       driverAccess = new DriverAccess();
        client =new Client__c();
        clientId = ApexPages.CurrentPage().getParameters().get('id');  
        columnName = ApexPages.CurrentPage().getParameters().get('columnField');
        direction = ApexPages.CurrentPage().getParameters().get('direction');  
        String copyId = ApexPages.CurrentPage().getParameters().get('copyId');  
        
        //Changes for Adding IncidentPriority when added from Priority details
             //Changes made by Sujeet
            String organization_Id = ApexPages.CurrentPage().getParameters().get('OrganizationId');
            client.FKOrganization__c = organization_Id;
            List<Organization__c> lstorganization;
            if(organization_Id != null && organization_Id != ''){
              String qryString = 'Id = '+'\''+organization_Id+'\'';
            objConditionBuilder.setCondition(qryString);
            lstorganization= (List<Organization__c>)driverAccess.selectObjects(new Organization__c(), null, objConditionBuilder, null);
            client.organizationId__c = lstorganization[0].Name;
            }
             //Changes Ends here//
        
                   
        if ((clientId != null && clientId!='')  || (copyId !=null && copyId != '')){
          {  
            List<String> lstOutputFields = new List<String>();        
            lstOutputFields.add('zip__c');
            lstOutputFields.add('vip__c');
            lstOutputFields.add('userFunction__c');
            lstOutputFields.add('useOganization__c');
            lstOutputFields.add('urgencyId__c');
            lstOutputFields.add('timeZone__c');
            lstOutputFields.add('state__c');
            lstOutputFields.add('selfServicePassword__c');                 
            lstOutputFields.add('room__c');
            lstOutputFields.add('remarks__c');
            lstOutputFields.add('postalCode__c');
            lstOutputFields.add('position__c');
            lstOutputFields.add('picture__c');
            lstOutputFields.add('phone__c');
            lstOutputFields.add('pager__c');
            lstOutputFields.add('organizationName__c');
            lstOutputFields.add('organizationId__c');
            lstOutputFields.add('note__c');
            lstOutputFields.add('mobile__c');      
            lstOutputFields.add('middleInitial__c');
            lstOutputFields.add('lastName__c');
            lstOutputFields.add('intlPhone__c');       
        
            lstOutputFields.add('intlFax__c');
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('firstName__c');
            lstOutputFields.add('fax__c');
            lstOutputFields.add('ext__c');
            lstOutputFields.add('emailAddress__c');
            lstOutputFields.add('displayClientComments__c');
            lstOutputFields.add('createdFromSelfService__c');
            lstOutputFields.add('country__c');
            lstOutputFields.add('city__c');
            lstOutputFields.add('chargeBackName__c');
            lstOutputFields.add('chargeBackId__c');
            lstOutputFields.add('building__c');
            lstOutputFields.add('beeper__c');
            lstOutputFields.add('address__c');
            lstOutputFields.add('SystemModstamp');
            lstOutputFields.add('OwnerId');
            lstOutputFields.add('Name');
            lstOutputFields.add('LastModifiedDate');
            lstOutputFields.add('LastActivityDate');
            lstOutputFields.add('IsDeleted');
            lstOutputFields.add('Id');
            lstOutputFields.add('FKUrgency__c');
            lstOutputFields.add('FKOrganization__c');
            lstOutputFields.add('FKChargeBack__c');
            lstOutputFields.add('CreatedDate');
            lstOutputFields.add('CreatedById');
            lstOutputFields.add('LastModifiedById');        
        
            String queryString = '';
        if((copyId !=null && copyId != '')){
          queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
           queryString='Id =' +'\''+clientId+'\''; 
         }
            
            
            objConditionBuilder.setCondition(queryString);    
            
           
             List<Client__c> listOfClient= (List<Client__c>) driverAccess.selectObjects(client,lstOutputFields,objConditionBuilder,null);  
             
              if((listOfClient.size() >0 ) && (copyId !=null && copyId != '')){
                  client = listOfClient[0];
                  copy();
                  
            }else if(listOfClient.size() >0){
              client = listOfClient[0];
              }else {
                client = new Client__c();
              }   
         }                
     }
     } 
    
    /*
     * To Insert the new records.
     */ 

    public PageReference save() { 
      try{
    
    if(client.Id!= null)
    {
        List<Organization__c> organizationL = [select id from Organization__c where Name =:client.organizationId__c];
        List<Urgency__c> urgencyL = [select id from Urgency__c where Name =:client.urgencyId__c];
    
        if(organizationL.size()!=0)
        {
          client.FKOrganization__c= organizationL[0].Id;
        }
        if(urgencyL.size()!=0)
        {
          client.FKUrgency__c= urgencyL[0].Id;
        }
          driverAccess.updateObject(client,null,null);
     }       
      else
      {         
         List<Organization__c> organizationL = [select id from Organization__c where Name =:client.organizationId__c];
         List<Urgency__c> urgencyL = [select id from Urgency__c where Name =:client.urgencyId__c];
    
          if(organizationL.size()!=0)
          {
            client.FKOrganization__c= organizationL[0].Id;
          }
          if(urgencyL.size()!=0)
         {
            client.FKUrgency__c= urgencyL[0].Id;
         }
            driverAccess.insertObject(client,null);
                  
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
    
    public PageReference newClient() {
        
       client =new Client__c();
       return null;
    }
    public PageReference urgencyQuery(){
        
        List<String> lstOutputFields = new List<String>();    
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+urgencyId+'\''; 
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
    
        urgency = new Urgency__c();
        driverAccess = new DriverAccess();
        List<Urgency__c> urgencyList= (List<Urgency__c>) driverAccess.selectObjects(urgency,lstOutputFields,objConditionBuilder,null); 
        if(urgencyList.size() >0){
            client.urgencyId__c = urgencyList[0].Name;
            
        }
                
        return null;
    } 
    
    public PageReference organizationQuery(){        
       
        List<String> lstOutputFields = new List<String>();    
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+organizationId+'\'';   
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
    
        organization = new Organization__c();
        driverAccess = new DriverAccess();
        List<Organization__c> organizationList= (List<Organization__c>) driverAccess.selectObjects(organization,lstOutputFields,objConditionBuilder,null); 
                      
        if(organizationList.size() >0){
            client.FKOrganization__c= organizationList[0].Id;                         
            client.organizationId__c = organizationList[0].Name; 
            
        }
                
        return null;
    } 
    
    public Pagereference copy(){     
           Client__c tempClient= client.clone();
           client=  tempClient;
           client.name = null;
           
        return null;
    }    
        
     public PageReference deleteClient(){
                
                if(client !=null && client.Id !=null){
                  String queryString='Id =' +'\''+client.Id+'\'';  
                ConditionBuilder objConditionBuilder = new ConditionBuilder();
                objConditionBuilder.setCondition(queryString);
                driverAccess.deleteObject(client,objConditionBuilder,null);
               
              }
              return null;
      }
      public Pagereference previousBtnHandler(){
        if(client!=null){
            CommonUI commonUiObj=new CommonUI();
            client = (Client__c)commonUiObj.getSobject(client, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(client!=null){
          CommonUI commonUiObj=new CommonUI();
            client = (Client__c)commonUiObj.getSobject(client, tempString, columnName, direction, 'next');
        }
        return null;
    } 
    
     public PageReference clear(){
              client = new Client__c();  
               
              return null;
      } 
      
  public PageReference reset(){
              
        client =new Client__c();
        clientId = ApexPages.CurrentPage().getParameters().get('id');  
        if ((clientId != null && clientId!='') ){
          {  
            List<String> lstOutputFields = new List<String>();        
            lstOutputFields.add('zip__c');
            lstOutputFields.add('vip__c');
            lstOutputFields.add('userFunction__c');
            lstOutputFields.add('useOganization__c');
            lstOutputFields.add('urgencyId__c');
            lstOutputFields.add('timeZone__c');
            lstOutputFields.add('state__c');
            lstOutputFields.add('selfServicePassword__c');                 
            lstOutputFields.add('room__c');
            lstOutputFields.add('remarks__c');
            lstOutputFields.add('postalCode__c');
            lstOutputFields.add('position__c');
            lstOutputFields.add('picture__c');
            lstOutputFields.add('phone__c');
            lstOutputFields.add('pager__c');
            lstOutputFields.add('organizationName__c');
            lstOutputFields.add('organizationId__c');
            lstOutputFields.add('note__c');
            lstOutputFields.add('mobile__c');      
            lstOutputFields.add('middleInitial__c');
            lstOutputFields.add('lastName__c');
            lstOutputFields.add('intlPhone__c');       
        
            lstOutputFields.add('intlFax__c');
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('firstName__c');
            lstOutputFields.add('fax__c');
            lstOutputFields.add('ext__c');
            lstOutputFields.add('emailAddress__c');
            lstOutputFields.add('displayClientComments__c');
            lstOutputFields.add('createdFromSelfService__c');
            lstOutputFields.add('country__c');
            lstOutputFields.add('city__c');
            lstOutputFields.add('chargeBackName__c');
            lstOutputFields.add('chargeBackId__c');
            lstOutputFields.add('building__c');
            lstOutputFields.add('beeper__c');
            lstOutputFields.add('address__c');
            lstOutputFields.add('SystemModstamp');
            lstOutputFields.add('OwnerId');
            lstOutputFields.add('Name');
            lstOutputFields.add('LastModifiedDate');
            lstOutputFields.add('LastActivityDate');
            lstOutputFields.add('IsDeleted');
            lstOutputFields.add('Id');
            lstOutputFields.add('FKUrgency__c');
            lstOutputFields.add('FKOrganization__c');
            lstOutputFields.add('FKChargeBack__c');
            lstOutputFields.add('CreatedDate');
            lstOutputFields.add('CreatedById');
            lstOutputFields.add('LastModifiedById');        
        
            String queryString='Id =' +'\''+clientId+'\''; 
      
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          driverAccess = new DriverAccess();
         
           List<Client__c> listOfClient= (List<Client__c>) driverAccess.selectObjects(client,lstOutputFields,objConditionBuilder,null);  
             
             if(listOfClient.size() >0){
              client = listOfClient[0];
              }else {
                client = new Client__c();
              }   
         }                
     }
              return null;
      } 
}
			                            	