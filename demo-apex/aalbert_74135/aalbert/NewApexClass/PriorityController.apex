public class PriorityController {

      public Priority__c priority;
      public Impact__c impact {get;set;}
      Urgency__c urgency {get;set;}
      List<Priority__c> priorityList;
      List<String> lstOutputFields = new List<String>();
      public String messageString {get; set;}
    String columnName='Name';
      String direction= 'ASC';
      public String tempString {get; set;}      
      
     DriverAccess objDriverAccess = new DriverAccess();
     public String urgencyId ;
     public String impactId;
     public String priorityId{get;set;}
   String tbd;   
    
    
     public void setUrgencyId(String urgencyId){
        
        this.urgencyId= urgencyId;        
    }
    
    public String getUrgencyId(){

        return urgencyId;
    }

    public void setImpactId(String impactId){
        
        this.impactId= impactId;        
    }
    
    public String getImpactId(){
               return impactId;
    }
    
    public void setPriority(Priority__c priority){
         this.priority= priority;
    }
    public Priority__c getPriority(){
      System.debug('Priority Obj'+ priority);
        return priority;
    }
    
    public void setImpact(Impact__c impact ){
     System.debug('Impact Obj'+ impact);
         this.impact= impact;
    }
    public Impact__c getImpact(){
    System.debug('Inside getImpact'+ impact);
        return impact;
    }

    public void setUrgency( Urgency__c urgency ){
         this.urgency = urgency ;
    }
    public Urgency__c getUrgency(){
        return urgency ;
    }

  public String getTbd(){
        return 'TBD';
    }

    public void setTbd(String tbd){
        
        this.tbd= tbd;        
    }
  
    ConditionBuilder objConditionBuilder = new ConditionBuilder();

    
    public priorityController(){
        priority =new Priority__c();
         priorityId=Apexpages.currentPage().getParameters().get('id');
         columnName = ApexPages.CurrentPage().getParameters().get('columnField');
       direction = ApexPages.CurrentPage().getParameters().get('direction');
         String copyId =Apexpages.currentPage().getParameters().get('copyId');
         if(priorityId!=null|| (copyId !=null && copyId != '')){
     
            //  priorityList=(List<Priority__c>)[select  Name, description__c,impactId__c,impactDescription__c,urgencyId__c,urgencyDescription__c,priorityDuration__c,inactive__c from
                  //           Priority__c  i where Name=:Id ];
                        
                lstOutputFields.add('ID');
                lstOutputFields.add('Name');  
                lstOutputFields.add('description__c');  
                lstOutputFields.add('impactId__c');
                lstOutputFields.add('FKImpact__c');
                lstOutputFields.add('impactDescription__c'); 
                lstOutputFields.add('FKUrgency__c');
                lstOutputFields.add('urgencyId__c'); 
                lstOutputFields.add('urgencyDescription__c');
                lstOutputFields.add('priorityDuration__c');  
                lstOutputFields.add('inactive__c'); 
                lstOutputFields.add('FKImpact__r.Name'); 
                lstOutputFields.add('FKUrgency__r.Name');   
           
            String queryString = '';
        if((copyId !=null && copyId != '')){
          queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
            queryString='Id =' +'\''+priorityId+'\''; 
         }
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
          List<Priority__c> priorityList = (List<Priority__c>) objDriverAccess.selectObjects(priority,lstOutputFields,objConditionBuilder,null);  
            
              if((priorityList.size() >0 ) && (copyId !=null && copyId != '')){
                  priority = priorityList[0];
                  copy();
                  
            }else if(priorityList.size() >0){
              priority = priorityList[0];
              }else {
                priority = new Priority__c();
              }
         }
    }

    /*
     * To Insert the new records.
     */ 
     
    public PageReference save() {
    
    try{    
      if(priority.Id!=null){ 
       List<Urgency__c> urgencyL = [select id from Urgency__c where Name =:priority.urgencyId__c];
       List<Impact__c> impactL = [select id from Impact__c where Name =:priority.impactId__c];

        if(impactL.size()!=0)
        {
          priority.FKImpact__c= impactL[0].Id;
        }
        if(urgencyL.size()!=0)
        {
          priority.FKUrgency__c= urgencyL[0].Id;
        }
          objDriverAccess.updateObject(priority, null,null);
     }  
     else{
         List<Urgency__c> urgencyL = [select id from Urgency__c where Name =:priority.urgencyId__c];
         List<Impact__c> impactL = [select id from Impact__c where Name =:priority.impactId__c];

        if(impactL.size()!=0)
        {
          priority.FKImpact__c= impactL[0].Id;
        }
        if(urgencyL.size()!=0)
        {
          priority.FKUrgency__c= urgencyL[0].Id;
        }
          objDriverAccess.insertObject(priority, null);
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
    
    public PageReference newPriority() {
       
        priority =new Priority__c();
        urgency = new Urgency__c();
        impact = new Impact__c();
            
        return null;
    }
    
     public PageReference urgencyQuery(){
        
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('ID');
        lstOutputFields.add('Name');  
        lstOutputFields.add('description__c');      
        String queryString = 'Id =' +'\''+urgencyId+'\'';  
                
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
        urgency = new Urgency__c();
        
        objDriverAccess = new DriverAccess();
        List<Urgency__c> urgencyList= (List<Urgency__c>) objDriverAccess.selectObjects(urgency,lstOutputFields,objConditionBuilder,null); 
        if(urgencyList.size() >0){
            urgency=urgencyList[0];
            priority.urgencyId__c = urgencyList[0].Name; 
            priority.FKUrgency__c = urgencyList[0].Id;
        }
                
        return null;
    }   

    public PageReference impactQuery(){
        
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('ID');
        lstOutputFields.add('Name'); 
        lstOutputFields.add('description__c');       
        String queryString = 'Id =' +'\''+impactId+'\'';  
                
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
        impact= new Impact__c();
        
        objDriverAccess = new DriverAccess();
        List<Impact__c> impactList= (List<Impact__c>) objDriverAccess.selectObjects(impact,lstOutputFields,objConditionBuilder,null); 
        if(impactList.size() >0){
            impact=impactList[0];
            priority.impactId__c = impactList[0].Name; 
            priority.FKImpact__c= impactList[0].Id;
            this.setImpactId(impactList[0].Id); 

        }
                
        return null;
    }   

  public PageReference deletePriority() {
        
        if(priority !=null && priority.Id !=null){
              ConditionBuilder objConditionBuilder = new ConditionBuilder();
              String queryString='Id =' +'\''+priority.Id+'\'';  
              objConditionBuilder.setCondition(queryString);
              objDriverAccess.deleteObject(priority, objConditionBuilder, null);
            }

       return null;
    }
   
    public void copy(){     
           Priority__c tempPriority= priority.clone(false,true);
          priority = tempPriority;
          priority.name =null;
    }
    
    public PageReference clear() {
        priority =null;
        priority = new Priority__c();
        return null;
    }
    public PageReference reset() {
         
         priority =new Priority__c();
         if(priorityId!=null){
               lstOutputFields.clear();
                lstOutputFields.add('ID');
                lstOutputFields.add('Name');  
                lstOutputFields.add('description__c');  
                lstOutputFields.add('impactId__c');
                lstOutputFields.add('FKImpact__c');
                lstOutputFields.add('impactDescription__c'); 
                lstOutputFields.add('FKUrgency__c');
                lstOutputFields.add('urgencyId__c'); 
                lstOutputFields.add('urgencyDescription__c');
                lstOutputFields.add('priorityDuration__c');  
                lstOutputFields.add('inactive__c'); 
                lstOutputFields.add('FKImpact__r.Name'); 
                lstOutputFields.add('FKUrgency__r.Name');   
           
            String queryString = '';
         queryString='Id =' +'\''+priorityId+'\''; 
                 
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
          List<Priority__c> priorityList = (List<Priority__c>) objDriverAccess.selectObjects(priority,lstOutputFields,objConditionBuilder,null);  
            
              if(priorityList.size() >0){
              priority = priorityList[0];
              }else {
                priority = new Priority__c();
              }
         }
    
        return null;
    }

   public Pagereference previousBtnHandler(){
        if(priority!=null){
            CommonUI commonUiObj=new CommonUI();
            priority = (Priority__c)commonUiObj.getSobject(priority, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(priority!=null){
            CommonUI commonUiObj=new CommonUI();
            priority = (Priority__c)commonUiObj.getSobject(priority, tempString, columnName, direction, 'next');
        }
        return null;
    }
}
			                            	