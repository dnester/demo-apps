public class DueDateRecalculator {
    
  
    public String selectedOption{ get; set;}
    public String selectedDate{ get; set;}
    DriverAccess objDriverAccess= null;
    List<String> listFields = null;
    ConditionBuilder objConditionBuilder= null;
    String queryString = null;
    List<Incident__c> incidentList{get; set;}
    public String incidentId{ get; set;}   
    public Incident__c incident;
    
    public void setIncident(Incident__c incident){
        this.incident = incident;
    }   
    public Incident__c getIncident(){
        return incident;
    }
    
     public DueDateRecalculator(){
        incidentId= Apexpages.currentPage().getParameters().get('incidentID');
        System.debug('------------------------DueDateRecalculator ----------------------------  ' + incidentId);
        objConditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
    }
     
   public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('0','Donot Recalculate')); 
        options.add(new SelectOption('1','Recalculate Based on Open Date')); 
        options.add(new SelectOption('2','Recalculate Based on Current Date')); 
        return options; 
    }
       
       public Pagereference calculateDueDate(){ 
         
       if(incidentId != null && incidentId != ''){
            System.debug('------------------------inside calculateDueDate ----------------------------');
            System.debug('------------------------inside calculateDueDate ----------------------------');
             List <Priority__c> incidentPriority = null;
             String condition = 'Id = '+'\'' + incidentId + '\'';
            objConditionBuilder.setCondition(condition);
          
              listFields = new List<String>();
              listFields.add('id');
              listFields.add('Name');
              listFields.add('clientId__c');
              listFields.add('categoryId__c');
              listFields.add('incidentDescription__c');
              listFields.add('incidentResolution__c');
              listFields.add('firstCallResolution__c');
              listFields.add('inactive__c');
              listFields.add('statusId__c');
              listFields.add('impactId__c');
              listFields.add('urgencyId__c');
              listFields.add('priorityId__c');
              listFields.add('openDateTime__c');
              listFields.add('respondedDateTime__c');
              listFields.add('dueDateTime__c');
              listFields.add('closeDateTime__c');
              listFields.add('timeSpent__c');
              listFields.add('broadcastId__c');
              listFields.add('note__c');
              listFields.add('assignedToUserId__c');
              listFields.add('supplierName__c');
              listFields.add('call__c');
              
              listFields.add('FKClient__c');
              listFields.add('FKCategory__c');
              listFields.add('FKImpact__c');
              listFields.add('FKUrgency__c');
              listFields.add('FKUrgency__r.Name');
              listFields.add('FKImpact__r.Name');
          
              incidentList = (List<Incident__c>)objDriverAccess.selectObjects(new Incident__c(), listFields, objConditionBuilder, null);
          System.debug('incidentList ------------------------inside calculateDueDate ----------------------------' + incidentList.size());
            System.debug('incidentList.openDateTime__c ---------------------------->' + incidentList[0].openDateTime__c );
            System.debug('incidentList.dueDateTime__c ---------------------------->' + incidentList[0].dueDateTime__c );
           
           listFields=null;
           listFields = new List<String>();
           listFields.add('Id');
           listFields.add('Name');
           listFields.add('FKUrgency__c');
           listFields.add('FKImpact__c');
           listFields.add('FKUrgency__r.ID');
           listFields.add('FKUrgency__r.Name');
           listFields.add('FKImpact__r.ID');
           listFields.add('FKImpact__r.Name');
           listFields.add('priorityDuration__c');
           
            if(incidentList[0].urgencyId__c != null && incidentList[0].impactId__c != null) {
              
               queryString='FKUrgency__r.Name =' +'\''+incidentList[0].urgencyId__c+'\' and  FKImpact__r.Name =' +'\''+incidentList[0].impactId__c+'\'';
               objConditionBuilder.setCondition(queryString);
                
               incidentPriority = (List<Priority__c>) objDriverAccess.selectObjects(new Priority__c(),listFields,objConditionBuilder,null);
          System.debug('incidentPriority.size() ---------------------------->' + incidentPriority.size());              
          }
      
             
           if(selectedOption == '0' ){
     //System.debug('0 ====== incidentPriority[0].Priority_Duration__c ---------------------------->' + incidentPriority[0].priorityDuration__c);
                //System.debug('0 incidentList[0].DueDateTime__c---------------------------->' + incidentList[0].dueDateTime__c);
                
           }else if(selectedOption == '1' && incidentPriority!= null && incidentPriority.size() > 0  &&          
                incidentPriority[0].priorityDuration__c != Null){
                    System.debug('(selectedOption == 1--------------------------->' );
                Datetime dDate = incidentList[0].openDateTime__c.addMinutes
                                                    (Integer.valueOf(incidentPriority[0].priorityDuration__c)) ;
                incidentList[0].dueDateTime__c = dDate;
                 
                incidentList[0].priorityId__c = incidentPriority[0].Name;                                   
                upsert incidentList[0]; 
                incident =   incidentList[0];
                selectedDate = incidentList[0].dueDateTime__c + ''; 
                System.debug('1 ====== incidentPriority[0].Id ---------------------------->' + incidentPriority[0].Id);
                 System.debug('1 ====== incidentPriority[0].Priority_Duration__c ---------------------------->' + incidentPriority[0].priorityDuration__c);
                System.debug('1 incidentList[0].DueDateTime__c---------------------------->' + incidentList[0].dueDateTime__c);
                
            }else if(selectedOption == '2' && incidentPriority!= null && incidentPriority.size() > 0 && 
                    incidentPriority[0].priorityDuration__c != Null){
                Datetime dDate = System.now().addMinutes
                                    (Integer.valueOf(incidentPriority[0].priorityDuration__c));
                incidentList[0].dueDateTime__c = dDate;
                 upsert incidentList[0];
                 incident = incidentList[0];
                 selectedDate = incidentList[0].dueDateTime__c + '';
                 System.debug('2 ====== incidentPriority[0].Id ---------------------------->' + incidentPriority[0].Id);
                 System.debug('2 incidentPriority[0].Priority_Duration__c ---------------------------->' + incidentPriority[0].priorityDuration__c);
                 System.debug('2 Changed values  ---------------------------->' + incidentList[0].dueDateTime__c);
                
            
            }else{
                System.debug('(else ------------------------->' );
            }
       }     
    return null;        
      }
}
			                            	