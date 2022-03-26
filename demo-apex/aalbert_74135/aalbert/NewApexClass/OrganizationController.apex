public class OrganizationController {

      public Organization__c organization;
      public Client__c client;
      public Urgency__c urgencyO;
      String urgency;
      String businessOwner;
      String parentOrganization;
      String Id;
      ConditionBuilder objConditionBuilder; 
      public String organizationId{get;set;}
    String columnName='Name';
      String direction= 'ASC';
       public String tempString {get; set;}
      public String dummy{get;set;}
      List<Organization__c> organizationList;
      public String messageString {get; set;}   
      
      DriverAccess objDriverAccess;    
      
      public void setOrganization(Organization__c organization){
         this.organization= organization;
      }
      public Organization__c getOrganization(){
        return organization;
      }
    
    
    
    public void setUrgency(String urgency){
        
        this.urgency= urgency;        
    }
    
    public String getUrgency(){

        return urgency;
    }
    
    public void setParentOrganization(String parentOrganization){
        
        this.parentOrganization= parentOrganization;        
    }
    
    public String getParentOrganization(){

        return parentOrganization;
    }

    
    public void setBusinessOwner(String businessOwner){
        
        this.businessOwner= businessOwner;        
    }
    
    public String getBusinessOwner(){

        return businessOwner;
    }
    
    public organizationController(){
              organization =new Organization__c();
             // if(organization.Name!=null || organization.Name!=" ")
              //{
             // organization=[select Name,organizationName__c,FKBusinessOwner__c,note__c,inactive__c,FKUrgency__c,FKOrganization__c,comments__c,estimatedNumberOfUsers__c,
              //address__c,state__c,country__c,city__c,zip__c,division__c,phone__c,fax__c,mainContactPhone__c,intlPostalCode__c,intlPhone__c,intlFax__c,intlPostalCode__c,
              //CreatedBy,ModifiedBy];
              
              objDriverAccess = new DriverAccess();
              objConditionBuilder = new ConditionBuilder();
              organizationId = Apexpages.currentPage().getParameters().get('id');
        columnName = ApexPages.CurrentPage().getParameters().get('columnField');
              direction = ApexPages.CurrentPage().getParameters().get('direction');
        String copyId=Apexpages.currentPage().getParameters().get('copyId');
              
              //Changes for Adding IncidentPriority when added from Priority details
             //Changes made by Sujeet
            String organization_Id = ApexPages.CurrentPage().getParameters().get('Organizationid');
            organization.FKOrganization__c = organization_Id;
            List<Organization__c> lstorganization;
            if(organization_Id != null && organization_Id != ''){
              String qryString = 'Id = '+'\''+organization_Id+'\'';
            objConditionBuilder.setCondition(qryString);
            lstorganization= (List<Organization__c>)objDriverAccess.selectObjects(new Organization__c(), null, objConditionBuilder, null);
            organization.parentOrganisationId__c = lstorganization[0].Name;
            }
             //Changes Ends here//
              
              
              
              if((organizationId != null && organizationId != '') || (copyId !=null && copyId != '')){
            
              List<String> lstOutputFields = new List<String>();
              lstOutputFields.add('Id');
              lstOutputFields.add('Name');
              lstOutputFields.add('zip__c');
              lstOutputFields.add('urgencyId__c');
              lstOutputFields.add('timeZone__c');
              lstOutputFields.add('state__c');
              lstOutputFields.add('note__c');
              lstOutputFields.add('mainContact__c');
              lstOutputFields.add('mainContactPhone__c');
              lstOutputFields.add('intlPostalCode__c');
              lstOutputFields.add('intlPhone__c');
              lstOutputFields.add('installationDate__c');
              lstOutputFields.add('inactive__c');
              lstOutputFields.add('fax__c');
              lstOutputFields.add('estimatedNumberOfUsers__c');
              lstOutputFields.add('division__c');
              lstOutputFields.add('country__c');
              lstOutputFields.add('comments__c');
              lstOutputFields.add('city__c');
              lstOutputFields.add('businessOwner__c');
              lstOutputFields.add('address__c');
             // lstOutputFields.add('SystemModstamp');
              lstOutputFields.add('OwnerId');
              lstOutputFields.add('parentOrganisationId__c');
              lstOutputFields.add('organizationName__c');
        lstOutputFields.add('purchaseDate__c');
              lstOutputFields.add('phone__c');
              lstOutputFields.add('intlFax__c');
              //lstOutputFields.add('CreatedBy.Name');
  
  
             // lstOutputFields.add('IsDeleted');
              lstOutputFields.add('FKUrgency__c');
              lstOutputFields.add('FKOrganization__c');
              lstOutputFields.add('FKBusinessOwner__c');
            //  lstOutputFields.add('CreatedDate');
              lstOutputFields.add('CreatedById');
              lstOutputFields.add('LastModifiedById');
  
  
             String queryString = '';
        if((copyId !=null && copyId != '')){
          queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
            queryString='Id =' +'\''+organizationId+'\''; 
         }
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
          List<Organization__c> organizationList = (List<Organization__c>) objDriverAccess.selectObjects(organization,lstOutputFields,objConditionBuilder,null);    
    
              if((organizationList.size() >0 ) && (copyId !=null && copyId != '')){
                  organization = organizationList[0];
                  copy();
                  
            }else if(organizationList.size() >0){
              organization = organizationList[0];
              }else {
                organization = new Organization__c();
              } 
            
        }
    }

    
    /*
     * To Insert the new records.
     */ 
   
    public PageReference save() { 
    try{    
                                                
    if(organization.Id!=null){
     List<Organization__c> organizationL= [select id from Organization__c where Name =:organization.parentOrganisationId__c];
     List<Urgency__c> urgencyL = [select id from Urgency__c where Name =:organization.urgencyId__c];
     List<Client__c> clientL = [select id from Client__c where Name =:organization.businessOwner__c];
        
         // organization.FKOrganization__c= organization.parentOrganisationId__c;
       if(organizationL.size()!=0)
        {
          organization.FKOrganization__c= organizationL[0].Id;
        }
        
        if(urgencyL.size()!=0)
        {
          organization.FKUrgency__c= urgencyL[0].Id;
        }
        if(clientL.size()!=0)
        {
          organization.FKBusinessOwner__c= clientL[0].Id;
        }
            
         objDriverAccess.updateObject(organization,null,null);                          

     }else{
          List<Organization__c> organizationL= [select id from Organization__c where Name =:organization.parentOrganisationId__c];
          List<Urgency__c> urgencyL = [select id from Urgency__c where Name =:organization.urgencyId__c];
          List<Client__c> clientL = [select id from Client__c where Name =:organization.businessOwner__c];
        if(organizationL.size()!=0)
        {
          organization.FKOrganization__c= organizationL[0].Id;
           
        }
        
        if(urgencyL.size()!=0)
        {
          organization.FKUrgency__c= urgencyL[0].Id;
        }
        if(clientL.size()!=0)
        {
          organization.FKBusinessOwner__c= clientL[0].Id;
        }
        objDriverAccess.insertObject(organization, null); 
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
    
    public PageReference newOrganization() {
       
        client=new Client__c();
        urgencyO=new Urgency__c();
        organization =new Organization__c();
        
       return null;
    }
   
  public PageReference urgencyQuery(){
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('ID');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+urgency+'\'';  
           
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
        Urgency__c urgency = new Urgency__c();
        
        objDriverAccess = new DriverAccess();
        List<Urgency__c> urgencyList= (List<Urgency__c>) objDriverAccess.selectObjects(urgency,lstOutputFields,objConditionBuilder,null); 
        if(urgencyList.size() >0){
             
            organization.FKUrgency__c =urgencyList[0].Id;
            organization.urgencyId__c = urgencyList[0].Name; 
          
        }
        return null;
    }   
    
    public PageReference businessOwnerQuery(){
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('ID');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+businessOwner+'\'';  
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
        Client__c client = new Client__c();
        
        objDriverAccess = new DriverAccess();
        List<Client__c> clientList= (List<Client__c>) objDriverAccess.selectObjects(client,lstOutputFields,objConditionBuilder,null); 
        if(clientList.size() >0){
            organization.FKBusinessOwner__c = businessOwner;
            organization.businessOwner__c = clientList[0].Name; 
        }
       return null;
    } 
    
    public PageReference parentOrganizationQuery(){
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('ID');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+parentOrganization+'\'';  
                
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
         //organization = new Organization__c();
        
        objDriverAccess = new DriverAccess();
        organizationList= (List<Organization__c>) objDriverAccess.selectObjects(organization,lstOutputFields,objConditionBuilder,null); 
        if(organizationList.size() >0){
            organization.FKOrganization__c =organizationList[0].Id;            
            organization.parentOrganisationId__c = organizationList[0].Name; 
        }
        return null;
    } 
   
     public PageReference deleteOrganization(){
              
                if(organization !=null && organization.Id !=null){
                ConditionBuilder objConditionBuilder = new ConditionBuilder();
                String queryString='Id =' +'\''+organization.Id+'\'';  
                objConditionBuilder.setCondition(queryString);
                objDriverAccess.deleteObject(organization, objConditionBuilder, null);
              }
              return null;
      } 
      
    public void copy(){     
           Organization__c tempOrganization= organization.clone(false,true);
          organization = tempOrganization;
          organization.name= null;
    }

     public Pagereference previousBtnHandler(){
        if(organization!=null){
          CommonUI commonUiObj=new CommonUI();
            organization = (Organization__c)commonUiObj.getSobject(organization, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(organization!=null){
          CommonUI commonUiObj=new CommonUI();
            organization = (Organization__c)commonUiObj.getSobject(organization, tempString, columnName, direction, 'next');
        }
        return null;
    }
      public PageReference clear(){
              organization = new Organization__c();
              return null;
      } 
      
       public PageReference reset(){
            
            organization =new Organization__c();
              objDriverAccess = new DriverAccess();
              objConditionBuilder = new ConditionBuilder();
              organizationId = Apexpages.currentPage().getParameters().get('id');
              
              if((organizationId != null && organizationId != '') ){
            
              List<String> lstOutputFields = new List<String>();
              lstOutputFields.add('Id');
              lstOutputFields.add('Name');
              lstOutputFields.add('zip__c');
              lstOutputFields.add('urgencyId__c');
              lstOutputFields.add('timeZone__c');
              lstOutputFields.add('state__c');
              lstOutputFields.add('note__c');
              lstOutputFields.add('mainContact__c');
              lstOutputFields.add('mainContactPhone__c');
              lstOutputFields.add('intlPostalCode__c');
              lstOutputFields.add('intlPhone__c');
              lstOutputFields.add('installationDate__c');
              lstOutputFields.add('inactive__c');
              lstOutputFields.add('fax__c');
              lstOutputFields.add('estimatedNumberOfUsers__c');
              lstOutputFields.add('division__c');
              lstOutputFields.add('country__c');
              lstOutputFields.add('comments__c');
              lstOutputFields.add('city__c');
              lstOutputFields.add('businessOwner__c');
              lstOutputFields.add('address__c');
              lstOutputFields.add('OwnerId');
              lstOutputFields.add('parentOrganisationId__c');
              lstOutputFields.add('organizationName__c');
        lstOutputFields.add('purchaseDate__c');
              lstOutputFields.add('phone__c');
              lstOutputFields.add('intlFax__c');
              lstOutputFields.add('FKUrgency__c');
              lstOutputFields.add('FKOrganization__c');
              lstOutputFields.add('FKBusinessOwner__c');
              lstOutputFields.add('CreatedById');
              lstOutputFields.add('LastModifiedById');
  
  
           String queryString='Id =' +'\''+organizationId+'\''; 
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
          List<Organization__c> organizationList = (List<Organization__c>) objDriverAccess.selectObjects(organization,
                                        lstOutputFields,objConditionBuilder,null);    
    
             if(organizationList.size() >0){
              organization = organizationList[0];
              }else {
                organization = new Organization__c();
              } 
            
        }
              return null;
      }
}
			                            	