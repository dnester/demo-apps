public class UrgencyController {

      public Urgency__c urgency;
      String urgencyId;
      public String messageString {get; set;}
      String columnName='Name';
       String direction= 'ASC';       
       public String tempString {get; set;}      
      
      ConditionBuilder objConditionBuilder; 
  static DriverAccess objDriverAccess = new DriverAccess();
    
      public void setUrgency(Urgency__c urgency){
         this.urgency= urgency;
    }
    public Urgency__c getUrgency(){
        return urgency;
    }
    
    
    public urgencyController(){
              urgency =new Urgency__c();
              objDriverAccess = new DriverAccess();
         objConditionBuilder = new ConditionBuilder();
        urgencyId = Apexpages.currentPage().getParameters().get('id');
        columnName = ApexPages.CurrentPage().getParameters().get('columnField');
        direction = ApexPages.CurrentPage().getParameters().get('direction');
         String copyId=Apexpages.currentPage().getParameters().get('copyId');
          
        if((urgencyId != null && urgencyId!= '') || (copyId !=null && copyId != '') ){
            
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('description__c');
                                 
             String queryString = '';
         if((copyId !=null && copyId != '')){
          queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
           queryString='Id =' +'\''+urgencyId+'\'';  
         }
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
          List<Urgency__c> urgencyList = (List<Urgency__c>) objDriverAccess.selectObjects(urgency,lstOutputFields,objConditionBuilder,null);    
            
              if((urgencyList.size() >0 ) && (copyId !=null && copyId != '')){
                  urgency = urgencyList[0];
                  copy();
                  
            }else if(urgencyList.size() >0){
              urgency = urgencyList[0];
              }else {
                urgency = new Urgency__c();
              } 

              
        //  String urgencyId = ApexPages.CurrentPage().getParameters().get('id');
     //   List<Urgency__c> listOfUrgency  =[ Select u.inactive__c, u.description__c, u.SystemModstamp, u.OwnerId, 
      //      u.Name, u.LastModifiedDate, u.LastModifiedById, u.LastActivityDate, u.IsDeleted, u.Id, 
      //      u.CreatedDate, u.CreatedById From Urgency__c u where u.Id=:urgencyId];
      //  if(listOfUrgency.size() > 0)
      //      urgency = listOfUrgency[0];              
   }

    
    }
    
    /*
     * To Insert the new records.
     */ 
    public PageReference save() {
        try{
            if(urgency.Id!=null){
                objDriverAccess.updateObject(urgency,null,null); 
            }else{
                objDriverAccess.insertObject(urgency, null); 
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
    
   
   public PageReference newUrgency() {
        
     urgency =new Urgency__c();
               
       return null;
    }
    
     public PageReference deleteUrgency(){
     if(urgency !=null && urgency.Id !=null){
              ConditionBuilder objConditionBuilder = new ConditionBuilder();
              String queryString='Id =' +'\''+urgency.Id+'\'';  
              objConditionBuilder.setCondition(queryString);
              objDriverAccess.deleteObject(urgency, objConditionBuilder, null);
            }
        return null;

    }
    
      public void copy(){     
           Urgency__c tempUrgency= urgency.clone(false,true);
          urgency = tempUrgency;
          urgency.Name = null;
    }
         public Pagereference previousBtnHandler(){
        if(urgency!=null){
             CommonUI commonUiObj=new CommonUI();
            urgency = (Urgency__c)commonUiObj.getSobject(urgency, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(urgency!=null){
             CommonUI commonUiObj=new CommonUI();
            urgency = (Urgency__c)commonUiObj.getSobject(urgency, tempString, columnName, direction, 'next');
        }
        return null;
    }
        public PageReference clear() {
        
     urgency =new Urgency__c();
               
       return null;
    }
    
    public PageReference reset() {
      
    urgency =new Urgency__c();
    objDriverAccess = new DriverAccess();
        objConditionBuilder = new ConditionBuilder();
        urgencyId = Apexpages.currentPage().getParameters().get('id');
          
        if((urgencyId != null && urgencyId!= '')){
            
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('inactive__c');
            lstOutputFields.add('description__c');
                                 
            String queryString='Id =' +'\''+urgencyId+'\'';  
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
          List<Urgency__c> urgencyList = (List<Urgency__c>) objDriverAccess.selectObjects(urgency,lstOutputFields,objConditionBuilder,null);    
            
           if(urgencyList.size() >0){
          urgency = urgencyList[0];
            }else {
              urgency = new Urgency__c();
            } 

       }
       return null;
    }
}
			                            	