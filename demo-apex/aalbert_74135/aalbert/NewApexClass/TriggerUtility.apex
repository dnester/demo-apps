public class TriggerUtility {

       static List<String> lstOutputFields  ;
       static String condition = null;
       static ConditionBuilder conditionBuilder = new ConditionBuilder();
       static DriverAccess objDriverAccess = new DriverAccess();
       
       public static List<Status__c> getStatuses(String tempCondition){
       
            lstOutputFields = new List<String>();
            lstOutputFields.add('Id');
            lstOutputFields.add('state__c');
            lstOutputFields.add('defaultStatus__c');
            lstOutputFields.add('Name');
            lstOutputFields.add('LastModifiedDate');
            conditionBuilder.setCondition(tempCondition);

            List<Status__c> statuses = (List<Status__c>)objDriverAccess.selectObjects(new Status__c(), lstOutputFields, conditionBuilder, null);
             
            return statuses;
       }
}
			                            	