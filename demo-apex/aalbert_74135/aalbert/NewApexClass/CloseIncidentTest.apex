@isTest
private class CloseIncidentTest{

       static IncidentCloser incidentCloser;
       static Incident__c incident;
       static Category__c category1;
       static Category__c category2;
       static Client__c client;
       static Status__C status;
       static User user;
       
       static List<StandardDescription__c> stdDescription = new List<StandardDescription__c>();
       static List<StandardResolution__c> stdResolution = new List<StandardResolution__c>();
       
       static String[] updateDescRes = new String[]{'isStdDescription','isStdResolution'};
       static String[] updateDesc = new String[]{'isStdDescription'};
       static String[] updateRes = new String[]{'isStdResolution'};
       
       static List<String> lstOutputFields = new List<String>();
       static String condition = null;
       static ConditionBuilder conditionBuilder = new ConditionBuilder();
       static DriverAccess objDriverAccess = new DriverAccess();
    
       List<Incident__c> incidents;
       
    
    public static void setUpData(){
        
        category1 = new Category__c(Name = 'Hardware Installation Test...', CategoryDescription__c = 'test Description');
        category2 = new Category__c(Name = 'Software Instllation Test....', CategoryDescription__c = 'test Resolution');
        
        objDriverAccess.insertObject(category1, null);        
        objDriverAccess.insertObject(category2, null);
        //insert category1;
        //insert category2;
        
        client = new Client__c( Name= 'PSL2', FirstName__c = 'Dayanand', LastName__c = 'K');
        objDriverAccess.insertObject(client, null);
        //insert client;
        
        String clientID = client.Id;
        
        status = new Status__c(Name = 'OPEN 2', defaultStatus__c = true, state__c = true);
        
        
        objDriverAccess.insertObject(status, null);
        //insert status;
        
        incident = new Incident__c( incidentDescription__c = 'Incdent Description', 
                                    incidentResolution__c = 'Incident_Resolution__c', 
                                    FKStatus__r = status, closeDateTime__c = System.now(), 
                                    FKCategory__c = category1.Id, FKClient__c = clientID, 
                                    firstCallResolution__c = false, followUp__c = false);

        objDriverAccess.insertObject(incident, null);
        //insert incident;
        String incidentId = incident.Id;
        Apexpages.currentPage().getParameters().put('incidentID',incidentId);
        
        System.debug('incidentId ================'+ incidentId);
        incidentCloser = new IncidentCloser();
        
        incidentCloser.inc = incident;
        incidentCloser.setUpdateDescRes(updateDescRes);
        
    }
    public static testMethod void testUpdateStdDescRes(){
        
        Test.startTest();
        setUpData();           
        Boolean isStdDescInserted = false;
        Boolean isStdResInserted = false;
        incidentCloser.setUpdateDescRes(updateDescRes);
        incidentCloser.save();
       
        //stdDescription = [Select s.Id, s.Description__c from StandardDescription__c s where s.CategoryId__c =: incident.FKCategory__c];
                
        lstOutputFields = new List<String>();
        lstOutputFields.add('Id');
        lstOutputFields.add('Description__c');
        
        StandardDescription__c tempStdDesc = new StandardDescription__c();
        stdDescription = (List<StandardDescription__c>)objDriverAccess.selectObjects(tempStdDesc, lstOutputFields, null, null);
        
        //stdDescription = [Select s.Id, s.Description__c from StandardDescription__c s];
        System.assert(stdDescription.size() > 0);
        
        if(stdDescription.size() > 0){
            for(StandardDescription__c stdDescTemp : stdDescription){
                if(stdDescTemp.Description__c == incident.incidentDescription__c){
                    isStdDescInserted = true;
                }
            }
        }
        
        lstOutputFields = new List<String>();
        lstOutputFields.add('Id');
        lstOutputFields.add('Description__c');
        
        condition = 'FKStandardDescription__c =' +  incident.incidentDescription__c;
        conditionBuilder.setCondition(condition);
        
        StandardResolution__c tempStdResc = new StandardResolution__c();
        stdResolution = (List<StandardResolution__c>)objDriverAccess.selectObjects(tempStdResc, lstOutputFields, conditionBuilder, null);
        
        //stdResolution = [Select s.Id, s.Resolution__c from StandardResolution__c s where s.FKStandardDescription__c =: incident.incidentDescription__c];
       
        if(isStdDescInserted){
                for(StandardResolution__c stdRes : stdResolution){
                    if(stdRes.Resolution__c.equals( incident.incidentResolution__c)){
                        isStdResInserted  = true;
                    }
                }
        }
            
        if(isStdDescInserted  )//&& isStdResInserted)
            System.assert(true);
        else
            System.assert(false);
            Test.stopTest();
    }
    
    public static testMethod void testUpdateStdDesc(){
    
             Test.startTest();
             setUpData();
             Boolean isStdDescInserted = false;
             incidentCloser.setUpdateDescRes(updateDesc);
             incidentCloser.inc.incidentDescription__c = 'Only Standard Description';   
             incidentCloser.save();
             
             lstOutputFields = new List<String>();
             lstOutputFields.add('Id');
             lstOutputFields.add('Description__c');
        
             StandardDescription__c tempStdDesc = new StandardDescription__c();
             stdDescription = (List<StandardDescription__c>)objDriverAccess.selectObjects(tempStdDesc, lstOutputFields, null, null);
             
             //stdDescription = [Select s.Id, s.Description__c from StandardDescription__c s];

             if(stdDescription.size() > 0){
                for(StandardDescription__c stdDescTemp : stdDescription){
                    if(stdDescTemp.Description__c == incidentCloser.inc.incidentDescription__c){
                        isStdDescInserted = true;   
                    }
                }
            }
            
            if(isStdDescInserted)
                System.assert(true);
            else
                System.assert(false);
                
            Test.stopTest();
    }
 
    /*public static testMethod void testAddStdResInExistingStdDesc(){
            
            Test.startTest();
            setUpData();
            Boolean isStdResInserted = false;
            
            incidentCloser.inc.incidentResolution__c = 'test Incident Resolution 2...';
            incidentCloser.setUpdateDescRes(updateDesc);   
            incidentCloser.save();
            
            stdResolution = [Select s.Id, s.Resolution__c from StandardResolution__c s where s.StandardDescriptionId__c =: incidentCloser.inc.incidentDescription__c];
            
            if(stdResolution.size() > 0){
                for(StandardResolution__c stdRes : stdResolution){
                    if(stdRes.Resolution__c.equals( incidentCloser.inc.incidentResolution__c)){
                        isStdResInserted = true;
                    }
                }
            }
            
            if(isStdResInserted)
                System.assert(true);
            else
                System.assert(false);
    }*/
    
    public static testMethod void testquickClose(){
        
        Test.startTest();
        setUpData();
        
        Status__c statusO = new Status__c(Name = 'TestOPEN', state__c = true, defaultStatus__c = true);
       
        objDriverAccess.insertObject(statusO, null);
        //insert statusO;
        Status__c statusC = new Status__c(Name = 'TestCLOSE', state__c = false, defaultStatus__c = true);
       
        objDriverAccess.insertObject(statusC, null);
        //insert statusC;
        System.debug(statusC);
        incidentCloser.inc.FKStatus__c = statusO.Id;  
        objDriverAccess.updateObject(incidentCloser.inc, null, null);
        //upsert incidentCloser.inc;
        incidentCloser.quickClose(); 
        Status__c qcStatus = incidentCloser.inc.FKStatus__r;
        boolean qcState = qcStatus.state__c;
       
       //System.assert(qcState.equals(false));
        System.assert(qcState==false);
        Test.stopTest();
    }

        
    public static testMethod void testIncidentReopen(){
        Test.startTest();
        setUpData();
       Status__c statusO = new Status__c(Name = 'TestOPEN', state__c = true, defaultStatus__c = true);
      
        objDriverAccess.insertObject(statusO, null);
        //insert statusO;
       Status__c statusC = new Status__c(Name = 'TestCLOSE', state__c = false, defaultStatus__c = true);
       
        objDriverAccess.insertObject(statusC, null);
        //insert statusC;
        incidentCloser.inc.FKStatus__c = statusC.Id;  
        
        objDriverAccess.updateObject(incidentCloser.inc, null, null);
        //upsert incidentCloser.inc;
        incidentCloser.reopenIncident(); 
        Status__c roStatus = incidentCloser.inc.FKStatus__r;
       // String roState = roStatus.state__c;
       
       Boolean roState=null;
       
        System.assert(roState == true);
        Test.stopTest();
    }
    
    public static testMethod void testSetSelectedCategory(){
        Test.startTest();
        setUpData();
        incidentCloser.inc.FKCategory__c = category2.Id;
        String cat2Desc = category2.categoryDescription__c; 
        incidentCloser.setSelectedCategory();
        Category__c temp = incidentCloser.inc.FKCategory__r;
        String incCatDesc = temp.categoryDescription__c;
        System.assert(cat2Desc.equals(incCatDesc));
        Test.stopTest();
    }
    
    public static testMethod void testGetUpdateList(){
        Test.startTest();
        setUpData();
        List<SelectOption> tempOptions =  incidentCloser.getUpdateList();
        
        for(Selectoption option : tempOptions){
            String temp = option.getValue();    
            if( temp.equals('isStdDescription') || temp.equals('isStdResolution')){
                System.assert(true);
            }
            else
                System.assert(false);
        }
        Test.stopTest();
    }
    
}
			                            	