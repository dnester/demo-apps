/*
 * FilterImplementation implement all the pre and post logic filters for objects
 * used in the system.
 */

public class FilterImplementation
{
    /* Overridden by Object Filters */
    public virtual class FilterLogic 
    {
        public virtual boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
        public virtual boolean postInsert(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
        public virtual boolean preUpdate(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
        public virtual boolean postUpdate(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
        public virtual boolean preDelete(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
        public virtual boolean postDelete(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
    }

    /* Incident Filters 
    *@Method: postInsert :-
    *@Method: postUpdate :-
    */
    public class IncidentFilterImpl extends FilterLogic
    {
        public override boolean postInsert(SObject newrecord, SObject oldrecord)
        {              
            Incident__c incident=(Incident__c) newrecord;
            CreateAuditTrail.auditIncidentCreation(Trigger.old, Trigger.new, incident);
            return true;
        }
        public override boolean postUpdate(SObject newrecord, SObject oldrecord)
        {              
            Incident__c incident=(Incident__c) newrecord;
            Map<String, Schema.SObjectField> mObjectFields = Trigger.new.getSObjectType().getDescribe().fields.getMap();
            Set<string> flds = mObjectFields.keySet();
            
            for(Integer i=0; i<Trigger.new.size(); i++) {
                for(string f : flds) {
        
                    string fldName = mObjectFields.get(f).getDescribe().getName();                    
                    String oldValue = String.valueOf(Trigger.old[i].get(fldName));
                    String newValue = String.valueOf(Trigger.new[i].get(fldName));
            
                    if(((oldValue != null && newValue != null) && !oldValue.equals(newValue)) ||
                    (oldValue != null && newValue == null) ||
                    (oldValue == null && newValue != null)) {
                
                        
                        if(fldName.equals('FKCategory__c')) {                            
                            CreateAuditTrail.auditCategoryChange(Trigger.old, Trigger.new, incident);
                        }
            
                        if(fldName.equals('FKStatus__c')) {
                            CreateAuditTrail.auditStatusChange(Trigger.old, Trigger.new, incident);
                        }
        
                        if(fldName.equals('FKUrgency__c')) {                            
                            CreateAuditTrail.auditUrgencyChange(Trigger.old, Trigger.new, incident);
                        }
                        
                        if(fldName.equals('FKAssignedTo__c')) {
                            CreateAuditTrail.auditAssignToChange(Trigger.old, Trigger.new, incident, newValue);
                        }
                        
                        if(fldName.equals('call__c')) {
                            CreateAuditTrail.auditCallCounterChange(Trigger.old, Trigger.new, incident);
                        }
                        
                        if(fldName.equals('dueDateTime__c')) {
                            CreateAuditTrail.auditDueDateTimeChange(Trigger.old, Trigger.new, incident);
                        }
                        
                        if(fldName.equals('FKPriority__c')) {
                            CreateAuditTrail.auditPriorityChange(Trigger.old, Trigger.new, incident);
                        }

                
                    }
        
                }
            }
            return true;
        }
    }

    /* Action Filters 
     * @Method :  PreInsert :- Filter verifies the Action Id for uniqueness.
     */
    public class ActionFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            System.assert(newRecord.getSObjectType() == Action__c.SObjectType);
            DriverAccess driverAccess = new DriverAccess();
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Name');
    
            List<Action__c> actions = (List<Action__c>)driverAccess.selectObjects(new Action__c(), lstOutputFields, null, null);
            Action__c currAction = (Action__c) newrecord;
            for(Action__c action : actions){
                if(action.Name == currAction.Name){
                    throw new FilterException('Action ID should be unique');
                }
            }
            return true;
        }
    }


    /* BroadCast Filters 
     * @Method : postInsert:- .
     * @Method : preUpdate :-  
     */
    public class BroadCastFilterImpl extends FilterLogic
    {
        public override boolean postInsert(SObject newrecord, SObject oldrecord)
        {            
            Broadcasts__c broadcast = (Broadcasts__c) newrecord;            
             System.debug('Inside trigger-------------------------------------->'+ broadcast.Name); 
                CreateBroadcastAuditTrail.auditBroadcastCreation(broadcast);
            return true;
        }
        public override boolean preUpdate(SObject newrecord, SObject oldrecord)
        { 
                Broadcasts__c broadcast= (Broadcasts__c) newrecord;
                Map<String, Schema.SObjectField> objectFieldsMap = Trigger.new.getSObjectType().getDescribe().fields.getMap();
                Set<string> fieldSet = objectFieldsMap.keySet();
                
                for(Integer index=0; index<Trigger.new.size(); index++) {
                    for(string sField : fieldSet) {
            
                        string sFieldName = objectFieldsMap.get(sField).getDescribe().getName();
                        string sFieldLabel = objectFieldsMap.get(sField).getDescribe().getLabel();
                        //String oldValue = String.valueOf(Trigger.old[index].get(sfieldName));
                       // String newValue = String.valueOf(Trigger.new[index].get(sfieldName));
                        
                    String oldValue = String.valueOf(oldrecord.get(sfieldName));
                        String newValue = String.valueOf(newrecord.get(sfieldName));
                        
                        if(((oldValue != null && newValue != null) && !oldValue.equals(newValue)) ||
                        (oldValue != null && newValue == null) ||
                        (oldValue == null && newValue != null)) {                        
                    
                            if(sFieldName.equals('FKCategory__c')) {
                              CreateBroadcastAuditTrail.auditCategoryChange(broadcast);
                            }
                                                              
                            DriverAccess driverAccess = null;
                            ConditionBuilder queryCondition = null;
                            List<String> listFieldNames = null;
                             
                            if(sFieldName.equals('FKStatus__c')) {
                                
                                CreateBroadcastAuditTrail.auditStatusChange(broadcast);
                                 driverAccess = new DriverAccess();
                                 queryCondition = new ConditionBuilder();
                                 listFieldNames = new List<String>();
                                System.debug('Old value----------------> ' + oldValue);
                                System.debug('new value----------------> ' + newValue);
                                    if(oldValue != newValue && (oldValue != null && newValue != null)){
                                        
                                        listFieldNames.add('Id');
                                        listFieldNames.add('Name');
                                        listFieldNames.add('State__c');
                                        queryCondition.setCondition('Id=\''+ oldValue + '\'');
                                            
                                        List<Status__c> oldStatusList = (List<Status__c>) driverAccess.selectObjects(new Status__c(),listFieldNames,queryCondition,null);
                                         
                                        listFieldNames.clear();
                                        listFieldNames.add('Id');
                                        listFieldNames.add('Name');
                                        listFieldNames.add('State__c');
                                        queryCondition.setCondition('Id=\''+ newValue + '\'');
                                            
                                        List<Status__c> newStatusList = (List<Status__c>) driverAccess.selectObjects(new Status__c(),listFieldNames,queryCondition,null);
                                         if( newStatusList.size() > 0  && oldStatusList.size() > 0){
                                            if(newStatusList[0].state__c == true && oldStatusList[0].state__c == false){
                                                CreateBroadcastAuditTrail.auditStateReopenChange(broadcast);
                                            }else if(newStatusList[0].state__c == false && oldStatusList[0].state__c == true){
                                                CreateBroadcastAuditTrail.auditStateCloseChange(broadcast);
                                            }
                                            
                                        }
                                    }
                                
                            }
                            
                            if(sFieldName.equals('FKUserIdAssignedTo__c')) {
                                CreateBroadcastAuditTrail.auditAssignToChange(broadcast, newValue);
                            }
                        }
                    }
                }
                return true;
        }
    }
    
    
    
    /* Status On Delete  Filters 
     * @Method : preInsert :- Filter verifies the Status Id for uniqueness.
   * @Method : preDelete :- Filter verifies the Status for its default status. 
   * @Method : postUpdate:-   
     */
    public class StatusOnDeleteFilter extends FilterLogic
    {
        public override boolean preDelete(SObject newrecord, SObject oldrecord)
            {               
                Status__c currStatus = (Status__c)oldrecord;//Trigger.old;
                Boolean defaultStatus = currStatus.defaultStatus__c;
                if(defaultStatus){
                    throw new FilterException('Can not Delete Status of which default status is set');
                }         
                return true; 
          }
          
          public override boolean preInsert(SObject newrecord, SObject oldrecord)
           {
                   List<Status__c>  currStatus = new List<Status__c>();
                  currStatus.add((Status__c)newrecord);
            Boolean state = currStatus[0].state__c;
            Boolean defaultStatus = currStatus[0].defaultStatus__c;
            String condition = 'state__c =' + state + ' and defaultStatus__c = true';
            List<Status__c> defStatuses = TriggerUtility.getStatuses(condition);
        
            //List<Status__c> defStatuses = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c, s.LastModifiedDate from Status__c s where s.state__c =: state and defaultStatus__c =: true];
            
            Integer size = defStatuses.size();
            
            if(Trigger.isInsert){
                if(size == 0){
                    if(! currStatus[0].defaultStatus__c )
                        currStatus[0].defaultstatus__c = true;
                }
                if(Trigger.isAfter && size == 2){
                    if(defStatuses[0].LastModifiedDate > defStatuses[1].LastModifiedDate ){
                        defStatuses[0].defaultStatus__c = true;
                        defStatuses[1].defaultStatus__c = false;
                        upsert defStatuses;
                    }
                    else{
                        defStatuses[0].defaultStatus__c = false;
                        defStatuses[1].defaultStatus__c = true;
                        upsert defStatuses;
                    }
                }   
            }
                return true;
           }
         public override boolean postInsert(SObject newrecord, SObject oldrecord)
           {
                   List<Status__c>  currStatus = new List<Status__c>();
                  currStatus.add((Status__c)newrecord);
            Boolean state = currStatus[0].state__c;
            Boolean defaultStatus = currStatus[0].defaultStatus__c;
            String condition = 'state__c =' + state + ' and defaultStatus__c = true';
            List<Status__c> defStatuses = TriggerUtility.getStatuses(condition);
        
            //List<Status__c> defStatuses = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c, s.LastModifiedDate from Status__c s where s.state__c =: state and defaultStatus__c =: true];
            
            Integer size = defStatuses.size();
            
            if(Trigger.isInsert){
                if(size == 0){
                    if(! currStatus[0].defaultStatus__c )
                        currStatus[0].defaultstatus__c = true;
                }
                if(Trigger.isAfter && size == 2){
                    if(defStatuses[0].LastModifiedDate > defStatuses[1].LastModifiedDate ){
                        defStatuses[0].defaultStatus__c = true;
                        defStatuses[1].defaultStatus__c = false;
                        upsert defStatuses;
                    }
                    else{
                        defStatuses[0].defaultStatus__c = false;
                        defStatuses[1].defaultStatus__c = true;
                        upsert defStatuses;
                    }
                }   
            }
                return true;
           }
           
          
          public override boolean postUpdate(SObject newrecord, SObject oldrecord)
            {  
                List<Status__c>  currStatus = new List<Status__c>();
                currStatus.add((Status__c)newrecord);
                Boolean state = currStatus[0].state__c;
                Boolean defaultStatus = currStatus[0].defaultStatus__c;
                String defStatusesCondition = 'state__c = ' + state + ' and defaultStatus__c = true';
                String statusesCondition = 'state__c =' + state;
                List<Status__c> defStatuses = TriggerUtility.getStatuses(defStatusesCondition);
                //List<Status__c> defStatuses = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c, s.LastModifiedDate from Status__c s where s.state__c =: state and defaultStatus__c =: true];
                List<Status__c> statuses = TriggerUtility.getStatuses(statusesCondition);
                //List<Status__c> statuses = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c from Status__c s where s.state__c =: state];
                Integer size = defStatuses.size();
        
                DriverAccess driverAccess = new DriverAccess();
        
                if(Trigger.isAfter && size == 2){
                    if(defStatuses[0].LastModifiedDate > defStatuses[1].LastModifiedDate ){ 
                         defStatuses[0].defaultStatus__c = true;
                         defStatuses[1].defaultStatus__c = false;
                         driverAccess.updateObject(defStatuses, null, null);
                //upsert defStatuses;
                    }else{
                        defStatuses[0].defaultStatus__c = false;
                        defStatuses[1].defaultStatus__c = true;
                        driverAccess.updateObject(defStatuses, null, null);
                        //upsert defStatuses;
                    }
                }       
                if(Trigger.isAfter && size == 0){
                    try{
                    //throw new StatusException('Can Not Modify Default Status of this record');
                    }catch(Exception e){
                        throw new FilterException('Can Not Modify Default Status of this record');
                    }
                }               
            
                return null;
            }
          
          
    }

    

  /* Status On Delete  Filters 
     * @Method : preInsert  : Filter Calculates the Due Date For newly created Task.
     * @Method : postInsert : Creates the System Task Log. 
     * @Method : preUpdate  : Filter Calculates the Due Date For updated Task. 
     * @Method : postUpdate : Creates the System Task Log.
     */
    public class CalculateTDueDateFilter extends FilterLogic
    {
         public override boolean preInsert(SObject newrecord, SObject oldrecord)
            {              
            DriverAccess objDriverAccess = new DriverAccess();
                List<String> lstOutputFields = null;
                ConditionBuilder objConditionBuilder = new ConditionBuilder();
                String queryString = null;
                Task__c task= (Task__c)newRecord;
                //for (Task__c task: trigger.new){             
               
       
                       lstOutputFields = new List<String>();
                       lstOutputFields.add('Id');
                       lstOutputFields.add('Name');
                       lstOutputFields.add('FKUrgency__c');
                       lstOutputFields.add('createdDate');
                       lstOutputFields.add('isDeleted');
                       lstOutputFields.add('FKImpact__c');
                       lstOutputFields.add('FKUrgency__r.ID');
                       lstOutputFields.add('FKUrgency__r.Name');
                       lstOutputFields.add('FKImpact__r.ID');
                       lstOutputFields.add('FKImpact__r.Name');
                       lstOutputFields.add('priorityDuration__c');
                       
                       if(task.urgencyId__c != null && task.impactId__c != null) {
                               //queryString ='FKUrgency__r.Id =' +'\''+task.FKUrgency__c+'\' and  FKImpact__r.Id =' +'\''+task.FKImpact__c+'\'';
                               queryString='urgencyId__c =' +'\''+task.urgencyId__c+'\' and  impactId__c =' +'\''+task.impactId__c+'\'';
                               objConditionBuilder.setCondition(queryString);
                               Priority__c tempPriority = new Priority__c();
                               List <Priority__c> taskPriority = (List<Priority__c>) objDriverAccess.selectObjects(tempPriority,lstOutputFields,objConditionBuilder,null);
                               if(taskPriority.size() > 0 && task != null){     
                                         if(task.dueDateTime__c == null && taskPriority[0].priorityDuration__c != null && taskPriority[0].priorityDuration__c != ''){
                                            if(taskPriority[0].priorityDuration__c != null) {
                                                Datetime prDuration = System.now().addMinutes(Integer.valueOf(taskPriority[0].priorityDuration__c));
                                                task.dueDateTime__c = prDuration ;
                                                task.FKPriority__c = taskPriority[0].Id;
                                                task.priorityId__c = taskPriority[0].Name;
                                            }
                                       }
                               }
                       }
              return true;    
         }   
      
      
        public override boolean postInsert(SObject newrecord, SObject oldrecord)
          {      
            Task__c task = (Task__c) newrecord;
            CreateTaskAuditTrail.auditTaskCreation(task);
            return null;
          }
         public override boolean preUpdate(SObject newrecord, SObject oldrecord)
           {       
              DriverAccess objDriverAccess = new DriverAccess();
                List<String> lstOutputFields = null;
                ConditionBuilder objConditionBuilder = new ConditionBuilder();
                String queryString = null;
                Task__c task= (Task__c)newRecord;
                //for (Task__c task: trigger.new){             
                       lstOutputFields = new List<String>();
                       lstOutputFields.add('Id');
                       lstOutputFields.add('Name');
                       lstOutputFields.add('FKUrgency__c');
                       lstOutputFields.add('createdDate');
                       lstOutputFields.add('isDeleted');
                       lstOutputFields.add('FKImpact__c');
                       lstOutputFields.add('FKUrgency__r.ID');
                       lstOutputFields.add('FKUrgency__r.Name');
                       lstOutputFields.add('FKImpact__r.ID');
                       lstOutputFields.add('FKImpact__r.Name');
                       lstOutputFields.add('priorityDuration__c');
                       //lstOutputFields.add('FKImpact__r.Name');
                       //lstOutputFields.add('FKImpact__r.Name');
                       
                       if(task.urgencyId__c != null && task.impactId__c != null) {
                               //queryString ='FKUrgency__r.Id =' +'\''+task.FKUrgency__c+'\' and  FKImpact__r.Id =' +'\''+task.FKImpact__c+'\'';
                               queryString='urgencyId__c =' +'\''+task.urgencyId__c+'\' and  impactId__c =' +'\''+task.impactId__c+'\'';
                               system.debug('^^^^^task.FKUrgency__c'+task.FKUrgency__c+' '+task.FKImpact__c);
                               
                               objConditionBuilder.setCondition(queryString);
                                    
                               Priority__c tempPriority = new Priority__c();
                                    
                               List <Priority__c> taskPriority = (List<Priority__c>) objDriverAccess.selectObjects(tempPriority,lstOutputFields,objConditionBuilder,null);
                               if(taskPriority.size() > 0 && task != null){     
                                   
                                         if(task.dueDateTime__c == null && taskPriority[0].priorityDuration__c != null && taskPriority[0].priorityDuration__c != ''){
                                    
                                            if(taskPriority[0].priorityDuration__c != null) {
                                                Datetime prDuration = System.now().addMinutes(Integer.valueOf(taskPriority[0].priorityDuration__c));
                                                task.dueDateTime__c = prDuration ;
                                                task.FKPriority__c = taskPriority[0].Id;
                                                task.priorityId__c = taskPriority[0].Name;
                                            }
                                       }
                               }
                       }
                                 //}      
           return true;    
          }   
       
       
         public override boolean postUpdate(SObject newrecord, SObject oldrecord)
           {  
             Task__c task =(Task__c)newrecord;
            Map<String, Schema.SObjectField> mObjectFields = Trigger.new.getSObjectType().getDescribe().fields.getMap();
              Set<string> flds = mObjectFields.keySet();
              
              for(Integer i=0; i<Trigger.new.size(); i++) {
                  for(string f : flds) {
          
                      string fldName = mObjectFields.get(f).getDescribe().getName();
                      String oldValue = String.valueOf(Trigger.old[i].get(fldName));
                      String newValue = String.valueOf(Trigger.new[i].get(fldName));
              
                      if(((oldValue != null && newValue != null) && !oldValue.equals(newValue)) ||
                      (oldValue != null && newValue == null) ||
                      (oldValue == null && newValue != null)) {                        
                  
                          if(fldName.equals('FKCategory__c')) {
                              CreateTaskAuditTrail.auditCategoryChange(task);
                          }
              
                          if(fldName.equals('FKStatus__c')) {
                              CreateTaskAuditTrail.auditStatusChange(task);
                          }
          
                          if(fldName.equals('FKUrgency__c')) {
                              CreateTaskAuditTrail.auditUrgencyChange(task);
                          }
                          
                          if(fldName.equals('FKPriority__c')) {
                              CreateTaskAuditTrail.auditPriorityChange(task);
                          }
                          
                      }
                  }
              }
           return null;    
       }
    }

  /* Category Filters 
     * PreInsert: Filter verifies the Category Id for uniqueness.
     */
     
    public class CategoriesFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            DriverAccess driverAccess = new DriverAccess();
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Name');
    
            List<Category__c> categories = (List<Category__c>)driverAccess.selectObjects(
                                                    new Category__c()
                                                    ,lstOutputFields
                                                    ,null
                                                    ,null);
            Category__c currCategory = (Category__c) newrecord;
            for(Category__c category : categories){
                if(category.Name == currCategory.Name){
                    throw new FilterException('Categories ID should be unique');
                }
            }
            return true;
        }
    }
    
    /* Category Types Filters 
     * PreInsert: Filter verifies the Category Types Id for uniqueness.
     */    
    public class CategoryTypesFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            DriverAccess driverAccess = new DriverAccess();
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Name');
            List<CategoryTypes__c> catTypes = (List<CategoryTypes__c>)driverAccess.selectObjects(
                                new CategoryTypes__c()
                                ,lstOutputFields
                                ,null
                                ,null);
                                
            CategoryTypes__c currCatType = (CategoryTypes__c) newrecord;
            for(CategoryTypes__c catType : catTypes){
                if(catType.Name == currCatType.Name){
                    throw new FilterException('Category Types ID should be unique');
                }
            }
            return true;
        }
    }   
    
    /* Client Filters 
     * PreInsert: Filter verifies the Client Id for uniqueness.
     */    
    public class ClientsFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            DriverAccess driverAccess = new DriverAccess();
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Name');
            List<Client__c> clients = (List<Client__c>)driverAccess.selectObjects(
                                    new Client__c()
                                    ,lstOutputFields
                                    ,null
                                    ,null);
            Client__c currClient = (Client__c) newrecord;
            for(Client__c client : clients){
                if(client.Name == currClient.Name){
                    throw new FilterException('Client ID should be unique');
                }
            }
            return true;
        }
    } 
   
    
    /* Impact Filters 
     * PreInsert: Filter verifies the Impact ID for uniqueness.
     */   
    public class ImpactFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            DriverAccess driverAccess = new DriverAccess();
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Name');
            List<Impact__c> impacts = (List<Impact__c>)driverAccess.selectObjects(
                                    new Impact__c()
                                    ,lstOutputFields
                                    ,null
                                    ,null);
            Impact__c currImpact = (Impact__c) newrecord;
            for(Impact__c impact : impacts){
                if(impact.Name == currImpact.Name){
                    throw new FilterException('Client ID should be unique');
                }
            }
            return true;
        }
    } 

    /* Organization Filters 
     * @Method : preInsert  :- Filter verifies the Organization ID for uniqueness.
     */       

    public class OrganizationFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            DriverAccess driverAccess = new DriverAccess();
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Name');
            List<Organization__c> organizations = (List<Organization__c>)driverAccess.selectObjects(
                                new Organization__c()
                                ,lstOutputFields
                                ,null
                                ,null);
    
            Organization__c currOrg = (Organization__c) newrecord;
            for(Organization__c organization : organizations){
                if(organization.Name == currOrg.Name){
                    throw new FilterException('Organization ID should be unique');
                }
            }
            return true;
        }
        
    } 

    /* Urgency Filters 
     * PreInsert: Filter verifies the Urgency ID for uniqueness.
     */       
    public class UrgencytFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            DriverAccess driverAccess = new DriverAccess();
            List<String> lstOutputFields = new List<String>();
            lstOutputFields.add('Name');
            List<Urgency__c> urgencies = (List<Urgency__c>)driverAccess.selectObjects(
                                    new Urgency__c()
                                    ,lstOutputFields
                                    ,null
                                    ,null);
            Urgency__c currUrgency = (Urgency__c) newrecord;
            for(Urgency__c urgency : urgencies){
                if(urgency.Name == currUrgency.Name){
                    throw new FilterException('Urgency ID should be unique');
                }
            }
            return true;
        }
    }   
    
    /* Proirity Filters 
     * PreInsert: Filter verifies the Urgency ID for uniqueness.
     */  
    public class PriorityFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
        public override boolean postInsert(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
    }       
    
    /* SystemLog Filters 
     * PreInsert: Filter verifies the Urgency ID for uniqueness.
     */ 
    public class SystemLogFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
        public override boolean postInsert(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
    }    
    
    /* TaskLog Filters 
     * PreInsert: Filter verifies the Urgency ID for uniqueness.
     */ 
    public class TaskLogFilterImpl extends FilterLogic
    {
        public override boolean preInsert(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
        public override boolean postInsert(SObject newrecord, SObject oldrecord)
        {              
            return true;
        }
    }                     
    
    /* 
   *  A filter factory method that returns the filter based on the object type   
     */
    public static FilterLogic GetFilterFromFactory(Schema.SObjectType objectType)
    {
        FilterLogic returnObject = null;
        if(objectType == Incident__c.SObjectType){
            returnObject = new IncidentFilterImpl();
        }
        else if (objectType == Action__c.SObjectType){
            returnObject = new ActionFilterImpl();
        }
        else if (objectType == Category__c.SObjectType){
            returnObject = new CategoriesFilterImpl();
        }        
        else if (objectType == CategoryTypes__c.SObjectType){
            returnObject = new CategoryTypesFilterImpl();
        }
        else if (objectType == Client__c.SObjectType){
            returnObject = new ClientsFilterImpl();
        } 
        else if (objectType == Impact__c.SObjectType){
            returnObject = new ImpactFilterImpl();
        }   
        else if (objectType == Organization__c.SObjectType){
            returnObject = new OrganizationFilterImpl();
        }
        else if (objectType == Status__c.SObjectType){
            returnObject = new StatusOnDeleteFilter();
        }
        else if (objectType == Urgency__c.SObjectType){
            returnObject = new UrgencytFilterImpl();
        }
        else if (objectType == Priority__c.SObjectType){
            returnObject = new PriorityFilterImpl();
        }
      /*  else if (objectType == SystemLog__c.SObjectType){
             returnObject = new SystemLogFilterImpl();
        }*/
        else if (objectType == Task__c.SObjectType){
            returnObject = new CalculateTDueDateFilter();
        }
        else if (objectType == Broadcasts__c.SObjectType){
            returnObject = new BroadCastFilterImpl();
        }  
        if (returnObject == null)
        {
            throw new FilterException('No Object found');
        }            
        return returnObject;
    }

}
			                            	