public class StandardResolutionController {

    public StandardResolution__c standardResolution {set;get;}
    public List <StandardResolution__c> discriptionList{get; set;}
    public DriverAccess objDriverAccess = new DriverAccess();
    public ConditionBuilder objConditionBuilder = new ConditionBuilder();
    public List<String> lstOutputFields = new List<String>();
    public String messageString {get; set;}
    public String standardResolutionId {get; set;}
    public String standardDescriptionId {get; set;}
    public StandardResolutionController(){
         standardResolution= new StandardResolution__c();
         standardResolutionId=Apexpages.currentPage().getParameters().get('id');  
         standardDescriptionId = Apexpages.currentPage().getParameters().get('StandardDescriptionid');
        if((standardResolutionId != null)) {
            lstOutputFields.clear();
            lstOutputFields.add('Id');            
            lstOutputFields.add('resolution__c');            
            lstOutputFields.add('inactive__c');            
            String queryString = '';         
          queryString='Id =' +'\''+standardResolutionId+'\'';
          ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
          discriptionList = (List<StandardResolution__c>) objDriverAccess.selectObjects(standardResolution,lstOutputFields,objConditionBuilder,null);
              if((discriptionList.size() >0 )){
                  standardResolution = discriptionList[0];                 
                  
            }
         }    
    }
    
    public PageReference save(){
      
      try{         
         lstOutputFields.clear();
            if(standardResolutionId != null && standardResolutionId != ''){             
              objDriverAccess.updateObject(standardResolution, null,null);
            }else{
              standardResolution.FKStandardDescription__c=standardDescriptionId;                           
              objDriverAccess.insertObject(standardResolution, null);
          
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
    
    
    
    public PageReference newStdResolution(){
        standardResolution= new StandardResolution__c();
        return null;
    }

}
			                            	