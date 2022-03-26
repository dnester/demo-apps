public class CommonUI {

    public CommonUI(){
    
    }
    public Sobject getSobject(Sobject so, String idString, String columnName, String direction, String order){
           // SObject so = SObjectFactory.getSObject(objType);
            String nameFld=String.valueOf(so.get('Name')); 
            /*List<String> objectIdList =new List<String>();
            objectIdList=idString.split(',',50);*/
            ConditionBuilder conditionBuilder = new ConditionBuilder();
            DriverAccess driverAccess = new DriverAccess();
            List<SObject> sObjects;
            if((idString!=null || idString!='') && (columnName!=null && direction!=null)){
              String condition = 'Id IN  ('+idString+') order by '+columnName+' '+direction+' NULLS last, Name ASC';
              conditionBuilder.setCondition(condition);
              sObjects = driverAccess.selectObjects(so, null, conditionBuilder, null);
              if(sObjects.size() > 0){
                  for(Integer i=0; i<sObjects.size(); i++){
                      if(String.valueOf(sObjects[i].get('Name'))==nameFld){
                              if(i>0 && order=='previous'){
                                  return sObjects[i-1];
                              }else if(i == 0 && order=='previous'){ 
                                  return sObjects[sObjects.size()-1];
                              }
                              if(i<sObjects.size()-1 && order=='next'){
                                  return sObjects[i+1];
                              }else if(i == sObjects.size()-1 && order=='next'){
                                  return sObjects[0];
                              }
                      }
                  }
              }
          }
           return so; 
    }
     /*
      * @Methode : getTemplateData :- Fetches the template data for particular SObject.
      * @param   : soo :- SObject
      * @param   : idString :- perticular template Id.   
     */
      public  SObject getTemplateData(Sobject soo, String idString){
                    
            ConditionBuilder conditionBuilder = new ConditionBuilder();
            DriverAccess driverAccess = new DriverAccess();
            List<SObject> sObjects;
            List<String> listFields = new List<String>();
            listFields.add('fieldName__c');
            listFields.add('fieldValue__c');
            listFields.add('fieldId__c');
            String condition = 'FKSYSTemplate__c='+'\''+idString+'\'';
            conditionBuilder.setCondition(condition);
            List<SYSTemplateFieldInfo__c> templateFieldList = (List<SYSTemplateFieldInfo__c>) driverAccess.selectObjects(new SYSTemplateFieldInfo__c(), listFields, conditionBuilder, null);
            Map<String, Schema.SObjectField> fieldsMap = new Map<String, Schema.SObjectField> ();
            fieldsMap = soo.getSObjectType().getDescribe().fields.getMap();
            for(String s : fieldsMap.keySet()){
                   for(Integer i=0; i< templateFieldList.size(); i++){
                        if(s == templateFieldList[i].fieldName__c && (templateFieldList[i].fieldName__c!='Name' && templateFieldList[i].fieldName__c != 'Id')){
                           if(templateFieldList[i].fieldName__c.subString(0,2)=='FK'){
                               soo.put(s,templateFieldList[i].FieldId__c);
                           }else{
                            soo.put(s,templateFieldList[i].fieldValue__c);
                           }
                            break;
                        }
                   }
            }
            return soo;
      } 
      
      
      /*
      * @Methode : getTemplateDataMap :- Fetches the template data for particular SObject.
      * @param   : soo :- SObject
      * @param   : idString :- perticular template Id.  
      * @return  : Map<String,String> :- returns the Id-Value pair of template fields for perticular SObject.    
     */
       public  Map<String,String> getTemplateDataMap(Sobject soo, String idString)
       {
           ConditionBuilder conditionBuilder = new ConditionBuilder();
            DriverAccess driverAccess = new DriverAccess();
           List<String> listFields = new List<String>();

           listFields.add('fieldName__c');

           listFields.add('fieldValue__c');

           String condition = 'FKSYSTemplate__c='+'\''+idString+'\'';

           conditionBuilder.setCondition(condition);

           List<SYSTemplateFieldInfo__c> templateFieldList = (List<SYSTemplateFieldInfo__c>) driverAccess.selectObjects(new SYSTemplateFieldInfo__c(), listFields, conditionBuilder, null);
          
           Map<String, Schema.SObjectField> fieldsMap = new Map<String, Schema.SObjectField> ();
           fieldsMap = soo.getSObjectType().getDescribe().fields.getMap();
           Map<String, String> fieldsMapForPage = new Map<String, String> ();
           for(String s : fieldsMap.keySet()){
           for(Integer i=0; i< templateFieldList.size(); i++){
                if(s == templateFieldList[i].fieldName__c && (templateFieldList[i].fieldName__c!='Name' && templateFieldList[i].fieldName__c != 'Id')){
                     fieldsMapForPage.put(templateFieldList[i].fieldName__c,templateFieldList[i].fieldValue__c);  
                     system.debug('name :'+templateFieldList[i].fieldName__c + ' and value is :' + templateFieldList[i].fieldValue__c); 
                     break;
                    }
                 }
             }
             return fieldsMapForPage;
      }
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
}
			                            	