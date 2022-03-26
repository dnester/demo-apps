public class CMDBTest
{
    Map<String, String> mapClassesInfo;
    public void SetLevels()
    {
        List<CMDB_Class__c> classes=[Select ClassName__c, SuperClass__c from CMDB_Class__c Order by SuperClass__c asc];
        
        mapClassesInfo = new Map<String, String>();
        for (CMDB_Class__c cls: classes )
        {
            mapClassesInfo.put(cls.ClassName__c , cls.SuperClass__c);  
        }
        
        integer level;
        List<CMDB_Class__c> lObjects = new List<CMDB_Class__c>();
        
        for (CMDB_Class__c cls: classes )
        {
            level=0;
            level = GetClassLevel(cls.ClassName__c, level);
            cls.Level__c = level;
        }
        upsert classes;
    }
    
    public integer GetClassLevel(String className, integer level)
    {
        if(mapClassesInfo.containsKey(className) && mapClassesInfo.get(className) == null )
        {
           return level;
        }
        else
        {
            string s= mapClassesInfo.get(className);
            return GetClassLevel(s, level+1);
        }
    }
    
    
    public static void test()
    {
     //CMDBDataLoader   
        //CMDBDataLoader.TestGetSuperClasses();
        
        //SObject o = CMDBHelper.getConcreteObjectFromFactory('BMC_AccessPoint__c');
        //if(o==null) system.debug('QQQ not found');
        
        //SObject o = CMDBHelper.getConcreteObjectFromFactory('BMC_AccessPoint__c','ss');
        //if(o==null) system.debug('QQQ not found');
        
        /*
        ConfigurationItem ci = new ConfigurationItem();
        ci.ClassName = 'BMC_AccessPoint';
        ci.InstanceId = 'INST_2009_12_31_12_38_15_7501001';
        //ci.InstanceId = 'INST_2009_12_30_11_41_36_4091001';
        ci.Attributes.put('SystemClassId__c','myvalue122');
        ci.Attributes.put('SystemName__c','myvalue222');
        ci.Attributes.put('Description__c','descmyvalue2');
        CMDBHelper h = new CMDBHelper();
        h.upsertCI(ci);*/
        
        CMDBHelper h = new CMDBHelper();
        ConfigurationItem ci = h.getCI('INST_2009_12_31_12_38_15_7501001','BMC_AccessPoint');
        printCI(ci);
        
    }
    
    public static void printCI(ConfigurationItem ci)
    {
        system.debug('ClassName-->' + ci.ClassName);
        system.debug('InstanceID-->' + ci.InstanceID);
        
        for(string k : ci.Attributes.keyset())
        {
            system.debug(' --> ' + k + ' -- ' + ci.Attributes.get(k));
        }
    }
    
    public static void TestGetSuperClasses()
    {
        List<String> lst = CMDBHelper.getSuperClasses('BMC_Package');
        for(string s : lst) { system.debug('-->'+s); }
    }
    
    

}
			                            	