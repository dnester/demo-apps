/*
  ProcessBRActionOrganizationTest: testMethods for processing business rules for company object 
  Author: apatel
  Date: 26/11/2009
*/
@isTest
private class ProcessBRActionOrganizationTest {
  
  public static testMethod void testProcessBRForInsertOrganization() {
    
    Test.startTest();
    // set up BR related custom objects
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'BRTestSuite';
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing from BRTestSuite';
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.CREATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);
     
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{new, organizationName__c}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'BRTestSuite';
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('>>>>>>>>>>>>>>>' + brActionId);
    
    String clientId = 'TestSuiteDept11';
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = clientId;
    brMappings.add(brMap2);
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'firstName__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = clientId;
    brMappings.add(brMap3);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
    // Based on BR eventName and module construct object and fire DML statement
    
    // To test methods defined with the future annotation, call the class containing the method in a startTest, stopTest code block. 
    // All asynchronous calls made after the startTest method are collected by the system. When stopTest is executed, all asynchronous processes are run synchronously. 
    
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    
    orgObj.Name = 'K77';
    orgObj.organizationName__c = 'BRTestSuite';
    insert orgObj;
    System.debug('Org created with Id========'+ orgObj.Id);
    System.assert(orgObj.Id != null);
    Test.stopTest();
    
    
    // Verify that result is as expected
    List<Client__c> lstClient = [select id, name, lastName__c from Client__c where name=: clientId];
    System.debug('-----******------ Added Department -----******------' + lstClient);
    System.assert(lstClient.get(0).name != null);
    
    List<SYSBRInternalObj__c> obj2 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c after insert  >>>>>>>' + obj2.size());
    System.debug('Object values are====='+ obj2 );
    //System.assert(obj2.size()==1);
    
    
  }
  
  public static testMethod void testProcessBRForMultiInsertRules() {
    
    Test.startTest();
    
    List<Client__c> lstClient1 = [select id, name, lastName__c from Client__c];
    List<SYSBRInternalObj__c> obj1 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c before insert  >>>>>>>' + obj1.size());
    insertBRInfo(1);
    insertBRInfo(2);
    // Based on BR eventName and module construct object and fire DML statement
    
    // To test methods defined with the future annotation, call the class containing the method in a startTest, stopTest code block. 
    // All asynchronous calls made after the startTest method are collected by the system. When stopTest is executed, all asynchronous processes are run synchronously. 
    
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    
    orgObj.Name = 'K77';
    orgObj.organizationName__c = 'BRTestSuite';
    insert orgObj;
    System.debug('Org created with Id========'+ orgObj.Id);
    System.assert(orgObj.Id != null);
    Test.stopTest();
    
    
    // Verify that result is as expected
    List<Client__c> lstClient2 = [select id, name, lastName__c from Client__c];
    System.debug('-----******------ Added Department -----******------' + lstClient2);
    System.debug('list of clients after insert lstClient2 >>>>>>>' + lstClient2.size());
    System.assert(lstClient2.size()>lstClient1.size());
    
    List<SYSBRInternalObj__c> obj2 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c after insert  >>>>>>>' + obj2.size());
    System.debug('Object values are====='+ obj2 );
    //System.assert(obj2.size()>obj1.size());
    
    
  }
  
  private static void insertBRInfo(integer i){
    // set up BR related custom objects for Rule 1
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'BRTestSuite'+i;
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing from BRTestSuite'+i;
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.CREATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);
    
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{new, organizationName__c}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'BRTestSuite';
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('>>>>>>>>>>>>>>>' + brActionId);
    
    String clientId = 'TestSuiteDept'+i;
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = 'Kumar '+i;
    brMappings.add(brMap2);
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'firstName__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = 'Kamlesh '+i;
    brMappings.add(brMap3);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
  }
  
  
  public static testMethod void testProcessBRForUpdateOrganization() {
    
    // Based on BR eventName and module construct object and fire DML statement
    
    // To test methods defined with the future annotation, call the class containing the method in a startTest, stopTest code block. 
    // All asynchronous calls made after the startTest method are collected by the system. When stopTest is executed, all asynchronous processes are run synchronously. 
    Test.startTest();
    List<Client__c> Clientlst = [select id, name, lastName__c from Client__c];
    System.debug('Clientlst.size()=====' + Clientlst.size());
    
    List<SYSBRInternalObj__c> obj1 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c before update  >>>>>>>' + obj1.size());
    
    insertBRInfoForUpdate(1);
    insertBRInfoForUpdate(2);
    
    // insert company object
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    orgObj.Name = '5363677';
    orgObj.organizationName__c = 'BRTestSuiteXYZ';
    insert orgObj;
    System.assert(orgObj.Id != null);
    // update company name
    orgObj.organizationName__c = 'BRTestSuiteUpdateEvent';
    update orgObj;
    
    Test.stopTest();
    // Verify that result is as expected
    List<Client__c> Clientlst2 = [select id, name, lastName__c from Client__c];
    System.debug('-----******------ Added Department -----******------' + Clientlst2);
    System.debug('After update Clientlst.size()=====' + Clientlst.size());
    System.assert(Clientlst2.size()>Clientlst.size());
    
    List<SYSBRInternalObj__c> obj2 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c after update  >>>>>>>' + obj2.size());
    System.debug('Object values are====='+ obj2 );
    //System.assert(obj2.size()>obj1.size());
    
    
  }
  
  private static void insertBRInfoForUpdate(Integer i){
  // set up BR related custom objects
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'BRUpdateEvent'+i;
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing for BRUpdate Event';
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.UPDATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);

    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{new, organizationName__c}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'BRTestSuiteUpdateEvent';
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('>>>>>>>>>>>>>>>' + brActionId);
    
    String clientId = 'TestSuiteUpdEventDept'+i;
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = 'Burmer '+i;
    brMappings.add(brMap2);
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'firstName__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = 'Scott '+i;
    brMappings.add(brMap3);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
  
  }
  
  public static testMethod void testProcessBRForDeleteOrganization() {
    // set up BR related custom objects
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'BRDeleteEvent';
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing for BRDelete Event';
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.DELETE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);

    String orgName = 'BRTestSuiteDeleteEvent';     
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{old, organizationName__c}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = orgName;
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('>>>>>>>>>>>>>>>' + brActionId);
    
    String clientId = 'TestSuiteDelEventDept';
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = clientId;
    brMappings.add(brMap2);
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'firstName__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = clientId;
    brMappings.add(brMap3);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
    // Based on BR eventName and module construct object and fire DML statement
    
    // To test methods defined with the future annotation, call the class containing the method in a startTest, stopTest code block. 
    // All asynchronous calls made after the startTest method are collected by the system. When stopTest is executed, all asynchronous processes are run synchronously. 
    Test.startTest();
    
    // insert company object
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    orgObj.Name = '5363677';
    orgObj.organizationName__c = orgName;
    insert orgObj;
    System.assert(orgObj.Id != null);
    // delete company 
    delete orgObj;
    Test.stopTest();
    
    // Verify that result is as expected
    List<Client__c> lstDept = [select id, name, lastName__c from Client__c where name=: clientId];
    System.debug('-----******------ Added Department -----******------' + lstDept);
    System.assert(lstDept.get(0).name != null);
    
    List<SYSBRInternalObj__c> obj2 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c after update  >>>>>>>' + obj2.size());
    System.debug('Object values are====='+ obj2 );
    System.assert(obj2.size()==1);
    
  }

  // Create organization with Create client and Create priority
  public static testMethod void testInsertEventWithMultipleActionOrganization() {
    // set up BR related custom objects
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'BRTestSuite';
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing from BRTestSuite';
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.CREATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);
     
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{new, organizationName__c}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'BRTestSuiteMultiple';
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    
    SYSBRActions__c brAct1 = new SYSBRActions__c();
    brAct1.ActionMethod__c = BRConstants.CREATE_STR;
    brAct1.ActionModuleName__c = 'Status__c';
    brAct1.BRInfoId__c = brInfoId;
    brActions.add(brAct1);
    
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.assert(brActionId.get(1) != null);
    System.debug('>>>>>>>>>>>>>>>' + brActionId);
    
    String clientId = 'TestSuiteDept11';
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = 'client last name' ;
    brMappings.add(brMap2);
    SYSBRMapping__c brMap5 = new SYSBRMapping__c();
    brMap5.FieldName__c = 'firstName__c'; 
    brMap5.BRActionsId__c =  brActionId.get(0);
    brMap5.Value__c = 'client first name';
    brMappings.add(brMap5);
    
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'name'; 
    brMap3.BRActionsId__c =  brActionId.get(1);
    brMap3.Value__c = clientId;
    brMappings.add(brMap3);
    SYSBRMapping__c brMap4 = new SYSBRMapping__c();
    brMap4.FieldName__c = 'statusdescription__c'; 
    brMap4.BRActionsId__c =  brActionId.get(1);
    brMap4.Value__c = 'Status Description';
    brMappings.add(brMap4);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
    System.assert(brMappingId.get(2) != null);
    
    // Based on BR eventName and module construct object and fire DML statement
    // To test methods defined with the future annotation, call the class containing the method in a startTest, stopTest code block. 
    // All asynchronous calls made after the startTest method are collected by the system. When stopTest is executed, all asynchronous processes are run synchronously. 
    Test.startTest();
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    orgObj.Name = '5363677';
    orgObj.organizationName__c = 'BRTestSuiteMultiple';
    insert orgObj;
    System.assert(orgObj.Id != null);
    
    Test.stopTest();
    
    // Verify that result is as expected
    List<Client__c> lstClient = [select id, name, lastName__c from Client__c where name=: clientId];
    System.debug('-----******------ Added Department -----******------' + lstClient);
    System.assert(lstClient.get(0).name != null);
    
    List<Status__c> lstPriority = [select id, name, statusDescription__c from Status__c where name=: clientId];
    System.debug('-----******------ Added Priority -----******------' + lstPriority);
    System.assert(lstPriority.get(0).name != null);
    
    List<SYSBRInternalObj__c> obj2 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c after update  >>>>>>>' + obj2.size());
    System.debug('Object values are====='+ obj2 );
    System.assert(obj2.size()==2);
        
  }

  public static testMethod void testProcessBRForUpdateOrganizationWithLessThan() {
    // set up BR related custom objects
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'BRUpdateEvent';
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing for BRUpdate Event';
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.UPDATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);

    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{old, estimatedNumberOfUsers__c}'; 
    brCon1.CompareOpr__c = BRConstants.LESS_THAN_OPR;
    brCon1.Expression2__c = '{new, estimatedNumberOfUsers__c}';
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('>>>>>>>>>>>>>>>' + brActionId);
    
    String clientId = 'TestSuiteUpdEventDept';
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = clientId;
    brMappings.add(brMap2);
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'firstName__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = clientId;
    brMappings.add(brMap3);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
    // Based on BR eventName and module construct object and fire DML statement
    
    // To test methods defined with the future annotation, call the class containing the method in a startTest, stopTest code block. 
    // All asynchronous calls made after the startTest method are collected by the system. When stopTest is executed, all asynchronous processes are run synchronously. 
    Test.startTest();
    
    // insert organization object
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    orgObj.Name = '12345';
    orgObj.organizationName__c = 'BRTestSuite';
    orgObj.estimatedNumberOfUsers__c = 12345;
    insert orgObj;
    System.assert(orgObj.Id != null);
    // update organization name
    orgObj.estimatedNumberOfUsers__c = 54321;
    update orgObj;
    Test.stopTest();
    
    // Verify that result is as expected
    List<Client__c> lstDept = [select id, name, lastName__c from Client__c where name=: clientId];
    System.debug('-----******------ Added Department -----******------' + lstDept);
    System.assert(lstDept.get(0).name != null);
    
    List<SYSBRInternalObj__c> obj2 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c after update  >>>>>>>' + obj2.size());
    System.debug('Object values are====='+ obj2 );
    System.assert(obj2.size()==1);
    
    
  } 
  
  // Create Orgnization and send email notification
  public static testMethod void testProcessBRForUpdateOrganizationEmailNotication() {
    // set up BR related custom objects
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'BRTestSuiteEmailNotify1';
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing from BRTestSuiteEmailNotify1';
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.UPDATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);
     
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{new, organizationName__c}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'ENotifier Inc.';
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'EmailNotification__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('>>>>>>>>>>>>>>>' + brActionId);
    
    EmailNotification__c eNotify = new EmailNotification__c();
    eNotify.to__c = 'kamlesh_tkumar@persistent.co.in';
    eNotify.subject__c = 'Welcome aboard';
    eNotify.body__c = 'New Name: {NEW, Name}, new Organization: {NEW, organizationName__c} old ogganization name: {OLD, organizationName__c}';
    eNotify.SYSBRActions__c = brActionId.get(0);
    Id notificationId = dAccess.insertObject(eNotify, null);
    System.assert(notificationId != null);
  
    // Based on BR eventName and module construct object and fire DML statement
    
    // To test methods defined with the future annotation, call the class containing the method in a startTest, stopTest code block. 
    // All asynchronous calls made after the startTest method are collected by the system. When stopTest is executed, all asynchronous processes are run synchronously. 
    Test.startTest();
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    orgObj.Name = 'BRTestSuiteEmailNotify1';
    orgObj.organizationName__c = 'Email Notifier LLC';
    insert orgObj;
    System.assert(orgObj.Id != null);
    // update company name
    orgObj.organizationName__c = 'ENotifier Inc.';
    update orgObj;
    Test.stopTest();
    
    
  }

  public static testMethod void testProcessBRForInsertOrganizationExpMapping() {
    // set up BR related custom objects
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'BRTestSuite';
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing from BRTestSuite for Expression in Mapping';
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.CREATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);
     
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{new, organizationName__c}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'BRTestSuiteExpMapping';
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('>>>>>>>>>>>>>>>' + brActionId);
    
    String clientId = 'TestSuiteDept11';
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = 'client last name' ;
    brMappings.add(brMap2);
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'note__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = '{new, organizationName__c}';
    brMappings.add(brMap3);
    SYSBRMapping__c brMap4 = new SYSBRMapping__c();
    brMap4.FieldName__c = 'firstName__c'; 
    brMap4.BRActionsId__c =  brActionId.get(0);
    brMap4.Value__c = 'client first name' ;
    brMappings.add(brMap4);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
    System.assert(brMappingId.get(2) != null);
    // Based on BR eventName and module construct object and fire DML statement
    
    // To test methods defined with the future annotation, call the class containing the method in a startTest, stopTest code block. 
    // All asynchronous calls made after the startTest method are collected by the system. When stopTest is executed, all asynchronous processes are run synchronously. 
    Test.startTest();
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    orgObj.Name = '5363677';
    orgObj.organizationName__c = 'BRTestSuiteExpMapping';
    insert orgObj;
    System.assert(orgObj.Id != null);
    
    Test.stopTest();
    
    // Verify that result is as expected
    List<Client__c> lstClient = [select id, name, lastName__c, note__c from Client__c where name=: clientId];
    System.debug('-----******------ Added Department -----******------' + lstClient);
    System.assert(lstClient.get(0).note__c != null);
    System.assert(lstClient.get(0).note__c == 'BRTestSuiteExpMapping');
    
    List<SYSBRInternalObj__c> obj2 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c after update  >>>>>>>' + obj2.size());
    System.debug('Object values are====='+ obj2 );
    System.assert(obj2.size()==1);
    
    
  }
   
  public static testMethod void testCreateEventMultipleConditionOR() {
    // construct SYSBRInformation__c custom object
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'CreateEventMultipleConditionOR';    // Name of Rule is required and Unique field
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing for CreateEventMultipleConditionOR';
    brInfo.ModuleName__c = 'Organization__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.CREATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);
    System.debug('BRInfo is created with ID: ' + brInfoId);
    
    // construct SYSBRConditions__c custom object
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{new, organizationName__c}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'AOL';
    brCon1.LogicalOpr__c = BRConstants.OR_OPR;
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    
    SYSBRConditions__c brCon2 = new SYSBRConditions__c();
    brCon2.Expression1__c = '{new, division__c}'; 
    brCon2.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon2.Expression2__c = 'Cloud';
    brCon2.BRInfoId__c = brInfoId;
    brConditions.add(brCon2);
    
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    System.assert(brConditionId.get(1) != null);
    System.debug('BRConditions are created with these IDs : ' + brConditionId);
    
    //construct SYSBRActions__c custom object
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('BRActions are created with these IDs : ' + brActionId);
    
    // construct SYSBRMapping__c custom object
    String clientId = 'Cloud';
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = clientId;
    brMappings.add(brMap2);
    
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'note__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = '{new, organizationName__c}';
    brMappings.add(brMap3);
    
    SYSBRMapping__c brMap4 = new SYSBRMapping__c();
    brMap4.FieldName__c = 'firstName__c'; 
    brMap4.BRActionsId__c =  brActionId.get(0);
    brMap4.Value__c = clientId;
    brMappings.add(brMap4);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
    System.assert(brMappingId.get(2) != null);
    System.assert(brMappingId.get(3) != null);
    System.debug('BRMappings are created with IDs: ' + brMappingId);
    
    Test.startTest();
    Organization__c orgObj = new Organization__c();
    // set values for required fields
    orgObj.Name = 'AOL34834';
    orgObj.organizationName__c = 'AOL';
    insert orgObj;
    System.assert(orgObj.Id != null);
    
    Test.stopTest();
    // Verify that result is as expected
    List<Client__c> lstDept = [select id, name, lastName__c, note__c from Client__c where name=: clientId];
    System.debug('-----******------ Added Department -----******------' + lstDept);
    System.assert(lstDept.get(0).name != null);
    System.assert(lstDept.get(0).lastName__c == clientId);
    
    List<SYSBRInternalObj__c> obj2 = [select id from SYSBRInternalObj__c];
    System.debug('size of SYSBRInternalObj__c after update  >>>>>>>' + obj2.size());
    System.debug('Object values are====='+ obj2 );
    System.assert(obj2.size()==1);
    
  }
  
  
  public static testMethod void testCreateEventMultipleConditionORAction() {
    // construct SYSBRInformation__c custom object
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'CreateEventMultipleConditionORAction';    // Name of Rule is required and Unique field
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing for CreateEventMultipleConditionORAction';
    brInfo.ModuleName__c = 'Action__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.CREATE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);
    System.debug('BRInfo is created with ID: ' + brInfoId);
    
    // construct SYSBRConditions__c custom object
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{new, name}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'ActionName';
    brCon1.LogicalOpr__c = BRConstants.OR_OPR;
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    
    SYSBRConditions__c brCon2 = new SYSBRConditions__c();
    brCon2.Expression1__c = '{new, description__c}'; 
    brCon2.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon2.Expression2__c = 'ActionDescription';
    brCon2.BRInfoId__c = brInfoId;
    brConditions.add(brCon2);
    
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    System.assert(brConditionId.get(1) != null);
    System.debug('BRConditions are created with these IDs : ' + brConditionId);
    
    //construct SYSBRActions__c custom object
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.CREATE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('BRActions are created with these IDs : ' + brActionId);
    
    // construct SYSBRMapping__c custom object
    String clientId = 'Action';
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'name'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'lastName__c'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = clientId;
    brMappings.add(brMap2);
    
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'note__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = '{new, name}';
    brMappings.add(brMap3);
    
    SYSBRMapping__c brMap4 = new SYSBRMapping__c();
    brMap4.FieldName__c = 'firstName__c'; 
    brMap4.BRActionsId__c =  brActionId.get(0);
    brMap4.Value__c = clientId;
    brMappings.add(brMap4);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
    System.assert(brMappingId.get(2) != null);
    System.assert(brMappingId.get(3) != null);
    System.debug('BRMappings are created with IDs: ' + brMappingId);
    
    Test.startTest();
    Action__c orgObj = new Action__c();
    // set values for required fields
    orgObj.Name = 'ActionName';
    orgObj.description__c = 'ActionDescription';
    insert orgObj;
    System.assert(orgObj.Id != null);
    Test.stopTest();
    
    // Verify that result is as expected
    List<Client__c> lstDept = [select id, name, lastName__c, note__c from Client__c where name=: clientId];
    System.debug('-----******------ Added Department -----******------' + lstDept);
    System.assert(lstDept.get(0).name != null);
    System.assert(lstDept.get(0).lastName__c == clientId);
  }

  
    public static testMethod void testCreateEventBroadcast() {
        // construct SYSBRInformation__c custom object
        SYSBRInformation__c brInfo = new SYSBRInformation__c();
        brInfo.Name__c = 'CreateEventMultipleConditionORBroadcast';    // Name of Rule is required and Unique field
        brInfo.IsActive__c = True;
        brInfo.Description__c = 'BR Testing for CreateEventMultipleConditionORBroadcastHistory';
        brInfo.ModuleName__c = 'Broadcasts__c';
        
        String[] lstStr = new String[1];
        lstStr[0] = BRConstants.CREATE_STR;
        String delimiter = ';' ;
        brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
        
        DriverAccess dAccess = new DriverAccess();
        // insert BRInformation object 
        Id brInfoId = dAccess.insertObject(brInfo,null);
        System.assert(brInfoId != null);
        System.debug('BRInfo is created with ID: ' + brInfoId);
        
        // construct SYSBRConditions__c custom object
        List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
        SYSBRConditions__c brCon1 = new SYSBRConditions__c();
        brCon1.Expression1__c = '{new, note__c}'; 
        brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
        brCon1.Expression2__c = 'BroadcastNote';
        brCon1.BRInfoId__c = brInfoId;
        brConditions.add(brCon1);
        
        // insert BRCondition object        
        List<Id> brConditionId = dAccess.insertObject(brConditions,null);
        System.assert(brConditionId.get(0) != null);
        System.debug('BRConditions are created with these IDs : ' + brConditionId);
        
        //construct SYSBRActions__c custom object
        List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
        SYSBRActions__c brAct = new SYSBRActions__c();
        brAct.ActionMethod__c = BRConstants.CREATE_STR;
        brAct.ActionModuleName__c = 'Client__c';
        brAct.BRInfoId__c = brInfoId;
        brActions.add(brAct);
        //insert BRAction object
        List<Id> brActionId = dAccess.insertObject(brActions,null);
        System.assert(brActionId.get(0) != null);
        System.debug('BRActions are created with these IDs : ' + brActionId);
        
        // construct SYSBRMapping__c custom object
        String clientId = 'BroadcastsClient';
        List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
        SYSBRMapping__c brMap1 = new SYSBRMapping__c();
        brMap1.FieldName__c = 'name'; 
        brMap1.BRActionsId__c =  brActionId.get(0);
        brMap1.Value__c = clientId;
        brMappings.add(brMap1);
        SYSBRMapping__c brMap2 = new SYSBRMapping__c();
        brMap2.FieldName__c = 'lastName__c'; 
        brMap2.BRActionsId__c =  brActionId.get(0);
        brMap2.Value__c = clientId;
        brMappings.add(brMap2);
        
        SYSBRMapping__c brMap3 = new SYSBRMapping__c();
        brMap3.FieldName__c = 'note__c'; 
        brMap3.BRActionsId__c =  brActionId.get(0);
        brMap3.Value__c = '{new, note__c}';
        brMappings.add(brMap3);
        
        SYSBRMapping__c brMap4 = new SYSBRMapping__c();
        brMap4.FieldName__c = 'firstName__c'; 
        brMap4.BRActionsId__c =  brActionId.get(0);
        brMap4.Value__c = clientId;
        brMappings.add(brMap4);
        
        // insert BRMapping objects
        List<Id> brMappingId = dAccess.insertObject(brMappings,null);
        System.assert(brMappingId.get(0) != null);
        System.assert(brMappingId.get(1) != null);
        System.assert(brMappingId.get(2) != null);
        System.assert(brMappingId.get(3) != null);
        System.debug('BRMappings are created with IDs: ' + brMappingId);
        
        Test.startTest();
        List<Action__c> actionList = [Select Id from Action__c];
        delete actionList;
        
        Action__c actionObj = new Action__c();
    actionObj.description__c ='Broadcast Taken By';
    actionObj.Name = 'WB_TAKEN';
    insert actionObj;
    System.assert(actionObj.Id != null); 
    
    Action__c actionObj1 = new Action__c();
    actionObj1.description__c ='Opened Braodcast';
    actionObj1.Name = 'WB_OPEN';
    insert actionObj1;
    System.assert(actionObj1.Id != null); 
    
        Category__c catObj = new Category__c();
        catObj.Name = 'cat';
        catObj.categoryDescription__c = 'cat';
        insert catObj;
        System.assert(catObj.Id != null); 
        
        Broadcasts__c broadObj = new Broadcasts__c();
        broadObj.FKCategory__c = catObj.Id;
        broadObj.note__c = 'BroadcastNote';
        insert broadObj;
        System.assert(broadObj.Id != null); 
        Test.stopTest();
        
        // Verify that result is as expected
        List<Client__c> lstDept = [select id, name, lastName__c, note__c from Client__c where name=: clientId];
        System.debug('-----******------ Added Department -----******------' + lstDept);
        System.assert(lstDept.get(0).name != null);
        System.assert(lstDept.get(0).lastName__c == clientId);
    }

    public static testMethod void testCreateEventIncident() {
        // construct SYSBRInformation__c custom object
        SYSBRInformation__c brInfo = new SYSBRInformation__c();
        brInfo.Name__c = 'CreateEventIncident';    // Name of Rule is required and Unique field
        brInfo.IsActive__c = True;
        brInfo.Description__c = 'BR Testing for CreateEventIncident';
        brInfo.ModuleName__c = 'Incident__c';
        
        String[] lstStr = new String[1];
        lstStr[0] = BRConstants.CREATE_STR;
        String delimiter = ';' ;
        brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
        
        DriverAccess dAccess = new DriverAccess();
        // insert BRInformation object 
        Id brInfoId = dAccess.insertObject(brInfo,null);
        System.assert(brInfoId != null);
        System.debug('BRInfo is created with ID: ' + brInfoId);
        
        // construct SYSBRConditions__c custom object
        List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
        SYSBRConditions__c brCon1 = new SYSBRConditions__c();
        brCon1.Expression1__c = '{new, information__c}'; 
        brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
        brCon1.Expression2__c = 'IncidentInformation';
        brCon1.BRInfoId__c = brInfoId;
        brConditions.add(brCon1);
        
        // insert BRCondition object        
        List<Id> brConditionId = dAccess.insertObject(brConditions,null);
        System.assert(brConditionId.get(0) != null);
        System.debug('BRConditions are created with these IDs : ' + brConditionId);
        
        //construct SYSBRActions__c custom object
        List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
        SYSBRActions__c brAct = new SYSBRActions__c();
        brAct.ActionMethod__c = BRConstants.CREATE_STR;
        brAct.ActionModuleName__c = 'Organization__c';
        brAct.BRInfoId__c = brInfoId;
        brActions.add(brAct);
        //insert BRAction object
        List<Id> brActionId = dAccess.insertObject(brActions,null);
        System.assert(brActionId.get(0) != null);
        System.debug('BRActions are created with these IDs : ' + brActionId);
        
        // construct SYSBRMapping__c custom object
        String clientId = 'IncidentOrg1';
        List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
        SYSBRMapping__c brMap1 = new SYSBRMapping__c();
        brMap1.FieldName__c = 'name'; 
        brMap1.BRActionsId__c =  brActionId.get(0);
        brMap1.Value__c = clientId ;
        brMappings.add(brMap1);
        SYSBRMapping__c brMap2 = new SYSBRMapping__c();
        brMap2.FieldName__c = 'organizationName__c'; 
        brMap2.BRActionsId__c =  brActionId.get(0);
        brMap2.Value__c = clientId;
        brMappings.add(brMap2);
        // insert BRMapping objects
        List<Id> brMappingId = dAccess.insertObject(brMappings,null);
        System.assert(brMappingId.get(0) != null);
        System.assert(brMappingId.get(1) != null);
        System.debug('BRMappings are created with IDs: ' + brMappingId);
        
        Test.startTest();
        
        Client__c clientObj = new Client__c();
        clientObj.name = 'IncidentClientName';
        clientObj.lastName__c = 'IncidentClientLastName';
        clientObj.firstName__c = 'IncidentClientFirstName';
        insert clientObj;
        System.assert(clientObj.Id != null); 
    
     List<Action__c> actionList = [Select Id from Action__c];
        delete actionList;
        
    Action__c actionObj = new Action__c();
    actionObj.description__c ='Call Taken By';
    actionObj.Name = 'HD_TAKEN';
    insert actionObj;
    System.assert(actionObj.Id != null); 
    
    Action__c actionObj1 = new Action__c();
    actionObj1.description__c ='Opened call';
    actionObj1.Name = 'HD_OPEN';
    insert actionObj1;
    System.assert(actionObj1.Id != null); 
    
        Category__c catObj = new Category__c();
        catObj.Name = 'cat';
        catObj.categoryDescription__c = 'cat';
        insert catObj;
        System.assert(catObj.Id != null); 
       
        Incident__c orgObj = new Incident__c();
        // set values for required fields
        orgObj.information__c = 'IncidentInformation';
        orgObj.FKClient__c = clientObj.Id;
        orgObj.FKCategory__c = catObj.Id;
        
        insert orgObj;
        System.assert(orgObj.Id != null);
        
        //IncidentHistory__c incidentHistoryObj = new IncidentHistory__c();
        //incidentHistoryObj.FKIncident__c = orgObj.Id;
        //incidentHistoryObj.FKAction__c = actionObj.Id;
        //incidentHistoryObj.actionId__c = actionObj.Name;
        //insert incidentHistoryObj;
        //System.assert(incidentHistoryObj.Id != null);
        
        Test.stopTest();
        
        // Verify that result is as expected
        List<Organization__c> lstDept = [select id, name, organizationName__c from organization__c where name=: clientId];
        System.debug('-----******------ Added Department -----******------' + lstDept);
        System.assert(lstDept.get(0).name != null);
        System.assert(lstDept.get(0).name == clientId);
    }
    
    //Method for Delete event, Delete Action
    public static testMethod void testDeleteEventwithAndOperDeleteAction() {
    // construct SYSBRInformation__c custom object
    SYSBRInformation__c brInfo = new SYSBRInformation__c();
    brInfo.Name__c = 'DeleteEventDeleteAction';    // Name of Rule is required and Unique field
    brInfo.IsActive__c = True;
    brInfo.Description__c = 'BR Testing for Delete Action';
    brInfo.ModuleName__c = 'Action__c';
    
    String[] lstStr = new String[1];
    lstStr[0] = BRConstants.DELETE_STR;
    String delimiter = ';' ;
    brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
    
    DriverAccess dAccess = new DriverAccess();
    // insert BRInformation object 
    Id brInfoId = dAccess.insertObject(brInfo,null);
    System.assert(brInfoId != null);
    System.debug('BRInfo is created with ID: ' + brInfoId);
    System.debug('BRInfo object is created with values: ' + brInfo);
    
    // construct SYSBRConditions__c custom object
    List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
    SYSBRConditions__c brCon1 = new SYSBRConditions__c();
    brCon1.Expression1__c = '{old, name}'; 
    brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon1.Expression2__c = 'ActionName';
    brCon1.LogicalOpr__c = BRConstants.AND_OPR;
    brCon1.BRInfoId__c = brInfoId;
    brConditions.add(brCon1);
    
    SYSBRConditions__c brCon2 = new SYSBRConditions__c();
    brCon2.Expression1__c = '{old, description__c}'; 
    brCon2.CompareOpr__c = BRConstants.EQUALS_OPR;
    brCon2.Expression2__c = 'ActionDescription';
    brCon2.BRInfoId__c = brInfoId;
    brConditions.add(brCon2);
    
    // insert BRCondition object    
    List<Id> brConditionId = dAccess.insertObject(brConditions,null);
    System.assert(brConditionId.get(0) != null);
    System.assert(brConditionId.get(1) != null);
    System.debug('BRConditions are created with these IDs : ' + brConditionId);
    System.debug('BRConditions are created with values : ' + brConditions);
    
    //construct SYSBRActions__c custom object
    List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
    SYSBRActions__c brAct = new SYSBRActions__c();
    brAct.ActionMethod__c = BRConstants.DELETE_STR;
    brAct.ActionModuleName__c = 'Client__c';
    brAct.BRInfoId__c = brInfoId;
    brActions.add(brAct);
    //insert BRAction object
    List<Id> brActionId = dAccess.insertObject(brActions,null);
    System.assert(brActionId.get(0) != null);
    System.debug('BRActions are created with these IDs : ' + brActionId);
    System.debug('BRActions are created with values : ' + brActions);
    
    Test.startTest();
    String clientId = 'Action';
    
    Client__c client = new Client__c();
    client.name = clientId;
    client.firstName__c = clientId;
    client.lastName__c = clientId;
    client.note__c = clientId;
    insert client;
    String id = client.Id;
    System.assert(client.Id != null);
    
    // construct SYSBRMapping__c custom object
    
    List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
    
    SYSBRMapping__c brMap = new SYSBRMapping__c();
    brMap.FieldName__c = 'id'; 
    brMap.BRActionsId__c =  brActionId.get(0);
    brMap.Value__c = id;
    brMappings.add(brMap);
    
    SYSBRMapping__c brMap1 = new SYSBRMapping__c();
    brMap1.FieldName__c = 'firstName__c'; 
    brMap1.BRActionsId__c =  brActionId.get(0);
    brMap1.Value__c = clientId;
    brMappings.add(brMap1);
    
    SYSBRMapping__c brMap2 = new SYSBRMapping__c();
    brMap2.FieldName__c = 'name'; 
    brMap2.BRActionsId__c =  brActionId.get(0);
    brMap2.Value__c = clientId;
    brMappings.add(brMap2);
    
    SYSBRMapping__c brMap3 = new SYSBRMapping__c();
    brMap3.FieldName__c = 'lastName__c'; 
    brMap3.BRActionsId__c =  brActionId.get(0);
    brMap3.Value__c = clientId;
    brMappings.add(brMap3);
    
    // insert BRMapping objects
    List<Id> brMappingId = dAccess.insertObject(brMappings,null);
    System.assert(brMappingId.get(0) != null);
    System.assert(brMappingId.get(1) != null);
    System.assert(brMappingId.get(2) != null);
    //System.assert(brMappingId.get(3) != null);
    System.debug('BRMappings are created with IDs: ' + brMappingId);
    System.debug('BRMappings are created with values: ' + brMappings);
    
    
    List<Client__c> lstDept = [select id, name, lastName__c, note__c from Client__c where name=: clientId];
    System.assert(lstDept.get(0).name != null);
    System.assert(lstDept.get(0).lastName__c == clientId);
    
    
    Action__c orgObj = new Action__c();
    // set values for required fields
    orgObj.Name = 'ActionName';
    orgObj.description__c = 'ActionDescription';
    insert orgObj;
    System.assert(orgObj.Id != null);
    
    List<Action__c> deleteAction = [select a.id from Action__c a where a.name='ActionName' and a.description__c = 'ActionDescription'];
    System.assert(deleteAction.size()>0);
    
    delete deleteAction;
    
    Test.stopTest();
    
    // Verify that result is as expected
    List<Client__c> lstDept1 = [select id, name, lastName__c, note__c from Client__c where name=: clientId];
    System.debug('-----******------ Added Department -----******------' + lstDept1);
    System.assert(lstDept1.size()==0);
    
  }
  
  public static testMethod void testCreateIncidentDetailUpdateIncidentAction() {
    
     // construct SYSBRInformation__c custom object
        SYSBRInformation__c brInfo = new SYSBRInformation__c();
        brInfo.Name__c = 'CreateEventIncidentDetailUpdateIncident';    // Name of Rule is required and Unique field
        brInfo.IsActive__c = True;
        brInfo.Description__c = 'BR Testing for CreateEventIncident';
        brInfo.ModuleName__c = 'IncidentHistory__c';
        
        String[] lstStr = new String[1];
        lstStr[0] = BRConstants.CREATE_STR;
        String delimiter = ';' ;
        brInfo.EventName__c = StringUtil.mergeString(lstStr, delimiter);
        
        DriverAccess dAccess = new DriverAccess();
        // insert BRInformation object 
        Id brInfoId = dAccess.insertObject(brInfo,null);
        System.assert(brInfoId != null);
        System.debug('BRInfo is created with ID: ' + brInfoId);
        
        // construct SYSBRConditions__c custom object
        List<SYSBRConditions__c> brConditions = new List<SYSBRConditions__c>();
        SYSBRConditions__c brCon1 = new SYSBRConditions__c();
        brCon1.Expression1__c = '{new, duration__c}'; 
        brCon1.CompareOpr__c = BRConstants.EQUALS_OPR;
        brCon1.Expression2__c = '01:30';
        brCon1.BRInfoId__c = brInfoId;
        brConditions.add(brCon1);
        
        // insert BRCondition object        
        List<Id> brConditionId = dAccess.insertObject(brConditions,null);
        System.assert(brConditionId.get(0) != null);
        System.debug('BRConditions are created with these IDs : ' + brConditionId);
        
        //construct SYSBRActions__c custom object
        List<SYSBRActions__c> brActions = new List<SYSBRActions__c>();
        SYSBRActions__c brAct = new SYSBRActions__c();
        brAct.ActionMethod__c = BRConstants.UPDATE_STR;
        brAct.ActionModuleName__c = 'Incident__c';
        brAct.BRInfoId__c = brInfoId;
        brActions.add(brAct);
        //insert BRAction object
        List<Id> brActionId = dAccess.insertObject(brActions,null);
        System.assert(brActionId.get(0) != null);
        System.debug('BRActions are created with these IDs : ' + brActionId);
        
        Test.startTest();
        
        Client__c clientObj = new Client__c();
        clientObj.name = 'IncidentClientName';
        clientObj.lastName__c = 'IncidentClientLastName';
        clientObj.firstName__c = 'IncidentClientFirstName';
        insert clientObj;
        System.assert(clientObj.Id != null); 
    
     List<Action__c> actionList = [Select Id from Action__c];
        delete actionList;
        
    Action__c actionObj = new Action__c();
    actionObj.description__c ='Call Taken By';
    actionObj.Name = 'HD_TAKEN';
    insert actionObj;
    System.assert(actionObj.Id != null); 
    
    Action__c actionObj1 = new Action__c();
    actionObj1.description__c ='Opened call';
    actionObj1.Name = 'HD_OPEN';
    insert actionObj1;
    System.assert(actionObj1.Id != null); 
    
        Category__c catObj = new Category__c();
        catObj.Name = 'cat';
        catObj.categoryDescription__c = 'cat';
        insert catObj;
        System.assert(catObj.Id != null); 
       
        Incident__c orgObj = new Incident__c();
        // set values for required fields
        orgObj.information__c = 'Incident';
        orgObj.FKClient__c = clientObj.Id;
        orgObj.FKCategory__c = catObj.Id;
        
        insert orgObj;
        String Id = orgObj.Id;
        System.assert(orgObj.Id != null);
        
        
        // construct SYSBRMapping__c custom object
        List<SYSBRMapping__c> brMappings = new List<SYSBRMapping__c>();
        
        SYSBRMapping__c brMap2 = new SYSBRMapping__c();
        brMap2.FieldName__c = 'incidentDescription__c'; 
        brMap2.BRActionsId__c =  brActionId.get(0);
        brMap2.Value__c = 'Incident updated' ;
        brMappings.add(brMap2);
        
        SYSBRMapping__c brMap1 = new SYSBRMapping__c();
        brMap1.FieldName__c = 'Id'; 
        brMap1.BRActionsId__c =  brActionId.get(0);
        brMap1.Value__c = Id ;
        brMappings.add(brMap1);
        
        // insert BRMapping objects
        List<Id> brMappingId = dAccess.insertObject(brMappings,null);
        System.assert(brMappingId.get(0) != null);
        System.assert(brMappingId.get(1) != null);
        System.debug('BRMappings are created with IDs: ' + brMappingId);
        
        IncidentHistory__c incidentHistoryObj = new IncidentHistory__c();
        incidentHistoryObj.FKIncident__c = orgObj.Id;
        incidentHistoryObj.FKAction__c = actionObj1.Id;
        incidentHistoryObj.actionId__c = actionObj1.Name;
        incidentHistoryObj.duration__c = '01:30';
        insert incidentHistoryObj;
        System.assert(incidentHistoryObj.Id != null);
        
        Test.stopTest();
        
        // Verify that result is as expected
        List<Incident__c> lstIncident = [select id, incidentDescription__c from Incident__c where Id=: Id];
        System.debug('-----******------ Added Department -----******------' + lstIncident);
        System.assert(lstIncident.get(0).incidentDescription__c != null);
        System.assert(lstIncident.get(0).incidentDescription__c.equalsIgnoreCase('Incident updated'));
    
  }
}
			                            	