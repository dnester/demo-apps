global class RecordsListCon {
    
public RecordsListCon(){
    boolCheckSize = false;
    isNotAvailable = true;
}
    
     public string strObject
    {
        get;
        set;

    }
    
     public string strFieldToSearch
    {
        get;
        set;

    }
     public Boolean boolCheckSize
    {
        get;
        set;

    }
    
     public Boolean isNotAvailable
    {
        get;
        set;

    }
    
     public string strValue
    {
        get;
        set;

    }
    
     public string strIdPrefix
    {
        get;
        set;

    }
    
     public string strParentId
    {
        get;
        set;

    }
    
     public string strPopupId
    {
        get;
        set;

    }
    
     public string strname
    {
        get;
        set;

    }
     
    public String direct{get; set;} 
    String[] fieldsArray;
    
    
    public void produceData(){
        isNotAvailable = true;
        List<SObject> resultList ;
        
            Map<String, Schema.SObjectField> fieldsMap = new Map<String, Schema.SObjectField> ();
            ConditionBuilder conditionBuilder = new ConditionBuilder();
            if(strValue!=null && strValue.length()>0){
                if(strname==null || strname==''){
                    String condition = strFieldToSearch + ' Like'+'\''+strValue+'%\'';
                    conditionBuilder.setCondition(condition);
                }else{
                    
                    String condition = 'Id= ' +'\''+strname+'\'';
                    conditionBuilder.setCondition(condition);
                    strname = null;
                }
                DriverAccess driverAccess = new DriverAccess();
                sObject obj = SObjectFactory.getSObject(strObject);
                
                resultList = driverAccess.selectObjects(obj, null, conditionBuilder, null);
                fieldsMap = obj.getSObjectType().getDescribe().fields.getMap();
                if(resultList.size()>1){
                    boolCheckSize=true;
                    SYSPopupObject__c po = new SYSPopupObject__c();
                    String condition1 = 'popupObjectName__c=' +'\''+strObject+'\'';
                    conditionBuilder.setCondition(condition1);
                    List<SYSPopupObject__c> popupResult = (List<SYSPopupObject__c>)driverAccess.selectObjects(po, null, conditionBuilder, null);
                    strPopupId = popupResult[0].name;
                }else{
                    boolCheckSize=false;
                }
                integer i = 0;
                if(resultList != null && resultList.size()>0){
                    integer max = fieldsMap.keySet().size() * resultList.size();
                    fieldsArray = new String[max];
                    for(sobject client : resultList )
                    {
                        for(String s : fieldsMap.keySet()){
                            fieldsArray[i] = '\"'+s + ':' + client.get(s)+'\"' ;
                            i++;
                        }
                    }
                }else{
                    isNotAvailable = false;
                    integer max = fieldsMap.keySet().size();
                    fieldsArray = new String[max];
                    for(String s : fieldsMap.keySet()){
                          fieldsArray[i] = '\"'+s + ':' + '' +'\"' ;
                          i++;
                    }
                }
            }
            strname=null;
    }

    public String[] getFieldsList() {
        return fieldsArray;
    }
    
}
			                            	