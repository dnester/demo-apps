public class ImpactController {

      public Impact__c impact;
      
     private DriverAccess driverAccess;
     public String messageString {get; set;}
   String columnName='Name';
     String direction= 'ASC';
     public String tempString {get; set;}  
      public void setImpact(Impact__c impact){
         this.impact= impact;
    }
    public Impact__c getImpact(){
        return impact;
    }
     String impactId;
    
    public impactController(){
        impact =new Impact__c();
        impactId = ApexPages.CurrentPage().getParameters().get('id');
        columnName = ApexPages.CurrentPage().getParameters().get('columnField');
        direction = ApexPages.CurrentPage().getParameters().get('direction');
        String copyId = ApexPages.CurrentPage().getParameters().get('copyId');
        if((impactId  != null) || (copyId !=null && copyId != '')){
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('description__c');
            lstOutputFields.add('SystemModstamp');
            lstOutputFields.add('OwnerId');
            lstOutputFields.add('Name');
            lstOutputFields.add('LastModifiedDate');
            lstOutputFields.add('LastModifiedById');
            lstOutputFields.add('LastActivityDate');
            lstOutputFields.add('Id');
            lstOutputFields.add('CreatedDate');
            lstOutputFields.add('CreatedById');
            
            String queryString = '';
        if((copyId !=null && copyId != '')){
          queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
           queryString='Id =' +'\''+impactId+'\'';  
         }
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          driverAccess = new DriverAccess();
         
          List<Impact__c> impactList= (List<Impact__c>) driverAccess.selectObjects(impact,lstOutputFields,objConditionBuilder,null);  
            
              if((impactList.size() >0 ) && (copyId !=null && copyId != '')){
                  impact = impactList[0];
                  copy();
                  
            }else if(impactList.size() >0){
              impact = impactList[0];
              }else {
                impact = new Impact__c();
              }
        } 
    } 
    
    
    /*
     * To Insert the new records.
     */ 
    public PageReference save() { 
    try{
           driverAccess= new DriverAccess();  
             if(impact.Id!= null){
                 update impact;
             }else{
                  driverAccess.insertObject(impact,null);
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
    public PageReference newImpact() {
        
       impact =new Impact__c();
       return null;
    }
    
    public PageReference deleteImpact() {
        
        if(impact !=null && impact.Id !=null){
              ConditionBuilder objConditionBuilder = new ConditionBuilder();
              String queryString='Id =' +'\''+impact.Id+'\'';  
              objConditionBuilder.setCondition(queryString);
              //objDriverAccess.deleteObject(impact,objConditionBuilder, null);
              delete impact;
            }

       return null;
    }
    
     public void copy(){     
           Impact__c tempImpact= impact.clone(false,true);
          impact = tempImpact;
          impact.name = null;
    }
    
    public PageReference clear() {
       impact = null;
       impact =new Impact__c();
       return null;
    }
    
    public PageReference reset() {
      
        impact =new Impact__c();
        if((impactId  != null) ){
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('description__c');
            lstOutputFields.add('SystemModstamp');
            lstOutputFields.add('OwnerId');
            lstOutputFields.add('Name');
            lstOutputFields.add('LastModifiedDate');
            lstOutputFields.add('LastModifiedById');
            lstOutputFields.add('LastActivityDate');
            lstOutputFields.add('Id');
            lstOutputFields.add('CreatedDate');
            lstOutputFields.add('CreatedById');
            
            String queryString = '';
        queryString='Id =' +'\''+impactId+'\'';  
        
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          driverAccess = new DriverAccess();
         
          List<Impact__c> impactList= (List<Impact__c>) driverAccess.selectObjects(impact,lstOutputFields,objConditionBuilder,null);  
            
              if((impactList.size() >0 )){
                  impact = impactList[0];
            }else {
                impact = new Impact__c();
              }
        } 
    
       return null;
    }
   
   public Pagereference previousBtnHandler(){
        if(impact!=null){
          CommonUI commonUiObj=new CommonUI();
            impact = (Impact__c)commonUiObj.getSobject(impact, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(impact!=null){
          CommonUI commonUiObj=new CommonUI();
            impact = (Impact__c)commonUiObj.getSobject(impact, tempString, columnName, direction, 'next');
        }
        return null;
    }
}
			                            	