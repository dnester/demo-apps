public class BlackOutController {
public BlackOut__c blackout{get; set;}

private DriverAccess driverAccess = null;
private ConditionBuilder queryCondition = null;
private List<String> listFieldNames = null;

    private String currentblackoutId;
    
    public String getCurrentblackoutId(){
        return this.currentblackoutId;
    }
    public void setCurrentblackoutId(String currentblackoutId){
         this.currentblackoutId= currentblackoutId;
    }
    public String messageString {get; set;}

    public BlackOutController(){
        currentblackoutId = Apexpages.currentPage().getParameters().get('id');
        blackout= new BlackOut__c();
        if(currentblackoutId != null && currentblackoutId != ''){
            init(currentblackoutId);
        }
    }
    
    public void init(String blackoutId){
        
        driverAccess = new DriverAccess();
        queryCondition = new ConditionBuilder();
        listFieldNames = new List<String>();
        
        listFieldNames.add('Id');
        listFieldNames.add('name__c');
        listFieldNames.add('description__c');
        listFieldNames.add('endDate__c');
        listFieldNames.add('startDate__c');
        listFieldNames.add('restrict__c');
        
         if(blackoutId != null || blackoutId != ''){
            queryCondition.setCondition('Id =\'' + blackoutId +'\'' );
            List<BlackOut__c> listBlackOut =(List<BlackOut__c>)driverAccess.selectObjects(blackout, listFieldNames, queryCondition, null);
             
           if(listBlackOut.size() > 0){
                blackout= listBlackOut[0];
            }
            else {
                 blackout = new BlackOut__c();
            }
          }
       }
       
        public Pagereference save(){
    
        try{
                driverAccess = new DriverAccess();
                queryCondition = new ConditionBuilder();
                listFieldNames = new List<String>();
                if(blackout.Id == null){
                driverAccess.insertObject(blackout, null);
                }
                else{
                queryCondition.setCondition('Id =\''+ blackout.Id + '\'');
                driverAccess.updateObject(blackout, queryCondition, null);
                }
                currentblackoutId = blackout.Id+'';
                messageString = validationHelper.getSavedMessage();  
         }catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
            }  else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
            } 
        }
        //return new PageReference('/broadcastspage?id='+broadcast.Id);
        return null;
    }


       
     public Pagereference deleteBlackOut(){
        
        driverAccess = new DriverAccess();
        queryCondition = new ConditionBuilder();
        listFieldNames = new List<String>();
       if(blackout != null && blackout.Id != null){
        queryCondition.setCondition('id=\''+ blackout.Id + '\'');
        driverAccess.deleteObject(blackout,queryCondition,null);
        init('');
       }
        return null;
    }
    
    public Pagereference copy(){
        
        BlackOut__c tempBlackout = new BlackOut__c();
        tempBlackout.Name__c= blackout.name__c;
        tempBlackout.description__c=blackout.description__c;
        tempBlackout.endDate__c=blackout.endDate__c;
        tempBlackout.startDate__c=blackout.startDate__c;
        tempBlackout.inactive__c=blackout.inactive__c;
        blackout = tempBlackout;
        return null;
      }
    
    public Pagereference resetBlackOut(){
        if(currentblackoutId!= null){
           init(currentblackoutId);
        } else{
           init('');
         }
        return null;
    }
        
    public Pagereference newBlackOut(){
        
        blackout = new BlackOut__c();
        currentblackoutId='';
        init('');
        return null;
    }
 }
			                            	