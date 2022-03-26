public class ClockWidgetController {
    
    private List<String> listFieldNames = null; 
    public String tZone1{get; set;}
    public String tZone2{get; set;}
    public String tZone3{get; set;}
    
    public String tZone1Label{get; set;}
    public String tZone2Label{get; set;}
    public String tZone3Label{get; set;}
    
    DriverAccess driverAccess = null;
    ConditionBuilder queryCondition = null;
    
    public ClockWidgetController(){
        
        List<SYSUsersTimezones__c> timeZoneList = new List<SYSUsersTimezones__c>();
        driverAccess = new DriverAccess();
        queryCondition = new ConditionBuilder();
        listFieldNames= new List<String>();
        
        queryCondition.setCondition('FKUserId__r.name = \'' + Userinfo.getName()+ '\'');
        listFieldNames.add('Id');
        listFieldNames.add('name');
        listFieldNames.add('FKSYSTimeZone__c');
        listFieldNames.add('FKSYSTimeZone__r.offset__c');
        listFieldNames.add('FKUserId__c');
        listFieldNames.add('FKUserId__r.name');
        
        
        timeZoneList = (List<SYSUsersTimezones__c>)driverAccess.selectObjects(new SYSUsersTimezones__c(), listFieldNames, queryCondition, null);
        
        if(timeZoneList.size() == 0){
            tZone1='+04.00'; 
            tZone2= '+00.00';
            tZone3= '-05.00';
            tZone1Label='Dubai'; 
            tZone2Label ='London'; 
            tZone3Label ='NewYork';
        }else if(timeZoneList.size() == 1 ){
                        
            tZone1= tZone2= tZone3=(timeZoneList[0].FKSYSTimeZone__r.offset__c!=null?timeZoneList[0].FKSYSTimeZone__r.offset__c:'+5.50');
            
            tZone1Label = tZone2Label = tZone3Label =(timeZoneList[0]!=null?timeZoneList[0].name:'');
            
            
        }else if(timeZoneList.size() == 2){
            tZone1= timeZoneList[0].FKSYSTimeZone__r.offset__c;         
            tZone2 = tZone3= timeZoneList[1].FKSYSTimeZone__r.offset__c;
            
            tZone1Label = (timeZoneList[0].name !=null?timeZoneList[0].name:'');
            tZone2Label = (timeZoneList[1].name !=null?timeZoneList[1].name:'');
            tZone3Label = '';
            
        }else if(timeZoneList.size() >= 3){
            tZone1= (timeZoneList[0].FKSYSTimeZone__r.offset__c!=null?timeZoneList[0].FKSYSTimeZone__r.offset__c:'+5.50');
            tZone2= (timeZoneList[1].FKSYSTimeZone__r.offset__c!=null?timeZoneList[1].FKSYSTimeZone__r.offset__c:'+5.50');
            tZone3= (timeZoneList[2].FKSYSTimeZone__r.offset__c!=null?timeZoneList[2].FKSYSTimeZone__r.offset__c:'+5.50');
            
            tZone1Label =(timeZoneList[0].name !=null?timeZoneList[0].name:'');
            tZone2Label =(timeZoneList[1].name !=null?timeZoneList[1].name:'');
            tZone3Label =(timeZoneList[2].name !=null?timeZoneList[2].name:'');
        }
        
    }  
    
}
			                            	