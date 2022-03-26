/*
  BRProcessor: This class execute BRActions depending on BR definition match with Trigger.new
  Author: apatel
  Date: 10/11/2009
*/
global class BRProcessor {
  
  private List<SYSBRInformation__c> lstBrInformation;
  
  private static SObject oldSObject;
  private static SObject newSObject;
  
  public List<SYSBRInformation__c> getLstBrInformation() { 
    return lstBrInformation;
  }
  public void setLstBrInformation(List<SYSBRInformation__c> list2) {
    lstBrInformation = list2; 
  } 
  
  //  This method with invoke BRAction depending on parameters
  public void execute(Boolean isInsert, Boolean isUpdate, Boolean isDelete, 
            Boolean isBefore, Boolean isAfter, List<SObject> newRecords, List<SObject> oldRecords) {
    
    String objectName;
    try{
      if(newRecords != null && newRecords.size() > 0)
        objectName = newRecords.get(0).getSObjectType()+''; 
      else if(oldRecords != null && oldRecords.size() > 0)
        objectName = oldRecords.get(0).getSObjectType()+'';
      
      // Get BR definition
      if(isInsert)  // Create event 
        lstBrInformation = getBRdefinition(objectName, BRConstants.CREATE_STR);
      else if(isUpdate) // Update event
        lstBrInformation = getBRdefinition(objectName, BRConstants.UPDATE_STR);
      else if(isDelete) // Delete event
        lstBrInformation = getBRdefinition(objectName, BRConstants.DELETE_STR);
       
       List<String> matchBRInfoLst = new List<String>();
      //get the list of matched BRs
      for(SYSBRInformation__c BRinfoObject :lstBrInformation) {
        String matchBRInfoId = null;
        if(isInsert) {  
          for(Integer i=0 ; i<newRecords.size() ; i++) {
            matchBRInfoId = matchWithBRdefinition(BRinfoObject, newRecords[i], null);  
            if(matchBRInfoId!=null) 
              matchBRInfoLst.add(matchBRInfoId);
          }
        }
        else if(isUpdate) {
          for(Integer i=0 ; i<newRecords.size() ; i++) {
            matchBRInfoId = matchWithBRdefinition(BRinfoObject, newRecords[i], oldRecords[i]);  
            if(matchBRInfoId!=null)
              matchBRInfoLst.add(matchBRInfoId);
          }
        }
        else if(isDelete) {
          for(Integer i=0 ; i<oldRecords.size() ; i++) {
            matchBRInfoId = matchWithBRdefinition(BRinfoObject, null, oldRecords[i]);  
            if(matchBRInfoId!=null)
              matchBRInfoLst.add(matchBRInfoId);
          }
        }
      }
      system.debug('matchBRInfoLst.size====' + matchBRInfoLst.size());
      if(matchBRInfoLst.size() > 0){  
        BRProcessor.executeBRAction(matchBRInfoLst); 
      }
      }
      catch(Exception e) {
        throw new BRException(e.getMessage());    
      }
   }
  // get List of BRInformation (parent-to-child relationship SOQL) depending on moduleName, and eventName
  public List<SYSBRInformation__c> getBRdefinition(String brModuleName, String brEventName) {
    
    DriverAccess dAccess = new DriverAccess();
    // Construct ConditionBuilder  
    ConditionBuilder whereClause = new ConditionBuilder();
    whereClause.setCondition('ModuleName__c = \'' + brModuleName + '\' AND eventName__c includes (\'' + brEventName + '\')');
    
    // Construct List of field which you want to retrieve
    List<String> lstField = new List<String>();
    lstField.add('Id');
    lstField.add('Name__c');
    lstField.add('ModuleName__c');
    lstField.add('EventName__c');
    lstField.add('isActive__c');
    lstField.add('(select  expression1__c, compareOpr__c, expression2__c, LogicalOpr__c from SYSBRConditions__r order by name)');
    
    // create concrete object on which you want to fire query
    sObject sObjAction = ObjectFactory.getInstanceByName('SYSBRInformation__c');
        
    List<sObject> lstsObj = dAccess.selectObjects(sObjAction, lstField, whereClause, null);
    setLstBrInformation((List<SYSBRInformation__c>) lstsObj);
    return getLstBrInformation();
  }
  
  // match Trigger.new record with BRInformation & BRConditions
  public String matchWithBRdefinition(SYSBRInformation__c brInfo, sObject newSObj, sObject oldSObj) {
    
    // Copying object reference, because they will be use in @future method. 
    oldSObject = oldSObj;
    newSObject = newSObj;
    
    String matchBRInfoId = null;    
    ExpressionParser expParser = new ExpressionParser();
    if(brInfo!=null){
      if(brInfo.IsActive__c) {
        List<BRStructuredCondition> structuredConditions = new List<BRStructuredCondition>();
        for(SYSBRConditions__c brCondition : brInfo.SYSBRConditions__r) {
          BRStructuredCondition conditionResult = expParser.evaluateBRCondition(newSObj, oldSObj, brCondition,brInfo.EventName__c); 
          if(conditionResult != null)
              structuredConditions.add(conditionResult);   
        }
        if(structuredConditions.size() > 0) {
          System.debug('structuredConditions >>>> ' + structuredConditions);
          String compositeExp = getCompositeExpression(structuredConditions);
          System.debug('Composite expression :' + compositeExp);
          OperatorPrecedence oprPrecedence = new OperatorPrecedence();
          Boolean compositeResult = oprPrecedence.logicalEvaluate(compositeExp);
          System.debug('Composite Result :' + compositeResult);
          if(compositeResult) {
            matchBRInfoId = brInfo.Id;
            System.debug('********  matchBRInfoId :' + matchBRInfoId);
          }
        }
      }
    }
    return matchBRInfoId;
  }
  
  private String getCompositeExpression(List<BRStructuredCondition> structuredConditions) {
    String compositeExp = '';
    for(BRStructuredCondition brStructuredCon : structuredConditions) {
      compositeExp += brStructuredCon.getUnitResult() + ' ' + brStructuredCon.getLogicalOpr();
    }
    return compositeExp;
  }
  
  //Method returns list of Sobject which are matched for BR rule execution
  private static List<sObject> getMatchActions(List<String> brInfoLst) {
      
    List<sObject> actions;
    String brInfoId;
    for(String br:brInfoLst){
      if (brInfoId!= null){
        brInfoId = brInfoId + ', '+ '\''+ br+'\'';
      }else{
        brInfoId = '\''+br +'\'';
      }}
    // Construct ConditionBuilder  
    ConditionBuilder whereClause = new ConditionBuilder();
    whereClause.setCondition('BRInfoId__c IN ( ' + brInfoId + ')');
    
    // Construct List of field which you want to retrieve
    List<String> lstField = new List<String>();
    lstField.add('id');
    lstField.add('ActionMethod__c');
    lstField.add('ActionModuleName__c');
    lstField.add('(select FieldName__c, Value__c from SYSBR_Mappings__r)');
      
    // create concrete object on which you want to fire query
    sObject sObjAction = ObjectFactory.getInstanceByName('SYSBRActions__c');
    
    DriverAccess dAccess = new DriverAccess();
    actions = dAccess.selectObjects(sObjAction, lstField, whereClause, null);
    System.debug('=====List of BR actions======' + actions);
    return actions;
  }

  // @future
  public static void executeBRAction(List<String> brInfoLst) {
    List<SYSBRActions__c> lstAction = null;
    String eventName;
    System.debug('>>>>>> You are inside executeBRAction.................');
    // Instantiate DriverAccess class
    DriverAccess dAccess = new DriverAccess();
    // Instantiate ExpressionParser class
    //ExpressionParser eParser = new ExpressionParser();
      
    // Ge list of Action depening on BRInfoId
    if(brInfoLst != null && brInfoLst.size()>0) {
      System.debug('brInfo List====== ' + brInfoLst);
      List<sObject> actions = getMatchActions(brInfoLst);
      System.debug('executeBR List ' + actions);
      lstAction = (List<SYSBRActions__c>) actions; 

      // get corresponding eventName from matched brInfoId      
      // Construct ConditionBuilder  
      if(brInfoLst!=null && brInfoLst.size()>0){
        ConditionBuilder whereClause = new ConditionBuilder();
        whereClause.setCondition('id = \'' + brInfoLst[0] + '\'');
        // Construct List of field which you want to retrieve
        List<String> lstField = new List<String>();
        lstField.add('id');
        lstField.add('eventName__c');
        // create concrete object on which you want to fire query
        sObject sObjAction = ObjectFactory.getInstanceByName('SYSBRInformation__c');
        List<sObject> lstBrInfo = dAccess.selectObjects(sObjAction, lstField, whereClause, null);
        if(lstBrInfo != null && lstBrInfo.size() > 0)
          eventName = ((SYSBRInformation__c)lstBrInfo.get(0)).eventName__c;
      }
    }
    
    List<SYSBRInternalObj__c> serializedStateList = new List<SYSBRInternalObj__c>();
    SYSBRInternalObj__c internalObj = null;
    // Construct object based on BRAction & BRMapping and execute BR Action method on constructed objects.
    for(SYSBRActions__c brAction : lstAction) {
      String stateXml = null; 
      
      if(brAction.ActionModuleName__c != null && !(brAction.ActionModuleName__c.equalsIgnoreCase('EmailNotification__c'))) {   
        // get reference of concrete object depending on ActionModuleName
        //sObject sObj = ObjectFactory.getInstanceByName(brAction.ActionModuleName__c);
        System.debug('>>>>>> Before condition block insert update delete');
        //if(BRConstants.CREATE_STR.equalsIgnoreCase(brAction.ActionMethod__c)) {  // for Create ActionMethod
          
          stateXml = xmlWriter(brAction.SYSBR_Mappings__r, eventName);
          System.debug('XML State of object : ' + stateXml);
          // insert searialized state of object in intermediate object
          internalObj = new SYSBRInternalObj__c();
          internalObj.actionName__c = brAction.ActionMethod__c;
          internalObj.objectName__c = brAction.ActionModuleName__c;
          internalObj.objectState__c = stateXml;
          
          serializedStateList.add(internalObj);
      }
      else if (brAction.ActionModuleName__c != null && brAction.ActionModuleName__c.equalsIgnoreCase('EmailNotification__c')) {
        System.debug('>*>*>*>*>*>*>* You are inside Email Notifier condition.....');
        System.debug('>*>*>*>*>*>*>* OLD' + oldSObject);
        System.debug('>*>*>*>*>*>*>* NEW' + newSObject);
        EmailNotificationWrapper eNotificationWrapper = getEmailNotificationWrapper(brAction.Id);
        if(eNotificationWrapper != null)
            EmailNotifier.sendNotification(eNotificationWrapper.getToAddresses(), eNotificationWrapper.getSubject(), eNotificationWrapper.getBody());
      }
    }
    if(serializedStateList.size()>0){
      List<Id> persitedObjects = dAccess.insertObject(serializedStateList, null);
      executeBRfromInternalObj(persitedObjects);
    }
  }
  
  //Method is executed in future . It takes persited objects from internal object and execute them
  @future
  public static void executeBRfromInternalObj(List<Id> idList){
    ConditionBuilder whereClause = null;
    List<String> lstField = null;
    String brInfoId;
    DriverAccess dAccess = new DriverAccess();
    XMLDataParser dataParser;
    XMLDom dom;
    
        for(Id br:idList){
          if (brInfoId!= null){
            brInfoId = brInfoId + ', '+ '\''+ br+'\'';
          }else{
            brInfoId = '\''+br +'\'';
          }
        }
        
        whereClause = new ConditionBuilder();
        whereClause.setCondition('id IN ( ' + brInfoId + ')');
        // Construct List of field which you want to retrieve
        lstField = new List<String>();
        lstField.add('id');
        lstField.add('actionName__c');
        lstField.add('objectName__c');
        lstField.add('objectState__c');
        
        SYSBRInternalObj__c internalObj = new SYSBRInternalObj__c();
        
        //sObject sObjAction = ObjectFactory.getInstanceByName('SYSBRInformation__c');
        List<sObject> lstBrInfo = dAccess.selectObjects(internalObj, lstField, whereClause, null);
        
        for(sObject obj: lstBrInfo){
          internalObj = (SYSBRInternalObj__c)obj;
          String moduleName = internalObj.objectName__c;
          System.debug('module Name==='+ moduleName);
          // create concrete object on which you want to fire query
          //sObject sObjAction = ObjectFactory.getInstanceByName(moduleName);
          String stateXml = internalObj.objectState__c;
          dom = new XMLDom(stateXml);
          dataParser = new XMLDataParser(dom);
          dataParser.objectName = moduleName;
          List<sObject> objectLst = dataParser.populateDataList();
          System.debug('Object after parsing.......' + objectLst.size()+'=======' + objectLst);
          //Check for CREATE Action
          if(BRConstants.CREATE_STR.equalsIgnoreCase(internalObj.actionName__c)){
            dAccess.insertObject(objectLst, null);  
          //Check for update action
          }else if(BRConstants.UPDATE_STR.equalsIgnoreCase(internalObj.actionName__c)){
            
            sObject sobj = objectLst.get(0);
            String whereStr = ' Id=\'' + sobj.get('Id') + '\'';
               ConditionBuilder whereCondition = new ConditionBuilder();
               whereCondition.setCondition(whereStr);
               List<sObject> lstSObject = dAccess.selectObjects(sobj, null, whereCondition, null);
               
               sObject updatedObject = updateExistingObject(lstSObject, dom);
               
               dAccess.updateObject(updatedObject, null, null);
          //Check for Delete Action  
          }else if(BRConstants.DELETE_STR.equalsIgnoreCase(internalObj.actionName__c)){
            
            sObject sobj = objectLst.get(0);
            String whereStr = ' Id=\'' + sobj.get('id') + '\'';
               ConditionBuilder whereCondition = new ConditionBuilder();
               whereCondition.setCondition(whereStr);
               List<sObject> lstSObject = dAccess.selectObjects(sobj, null, whereCondition, null);
            
            dAccess.deleteObject(lstSObject, null, null);
            
          }
        }
    }
  
  //Method to update existing object from the values present in XML for perticular attributes
  private static Sobject updateExistingObject(List<sObject> sobjList, XMLDom xdom){
    
    SObject dataObject;
    if(sobjList.size()>0){
        dataObject = sobjList.get(0);
        Map<String, Schema.SObjectField> fieldsMap = new Map<String, Schema.SObjectField> ();                
            fieldsMap = dataObject.getSObjectType().getDescribe().fields.getMap();
        
        // traversing through the XML file tag-by-tag and adding to a List
        for(XMLDom.Element rowElement: xdom.root.childnodes[0].childNodes){
                for(XmlDom.Element fieldElement:rowElement.childNodes){
                     
                     // need to use more more efficiently.
                     schema.DescribeFieldResult fieldDesc = fieldsMap.get(fieldElement.nodeName).getDescribe();
              String fieldtype = fieldDesc.getType().name(); 
              
              // Testing the visibitlity and types before adding to list.
                     if(fieldDesc.isAccessible() && fieldDesc.isUpdateable() && !(fieldDesc.isAutoNumber())){
                       if(fieldtype == Schema.DisplayType.String.name() ||fieldtype == Schema.DisplayType.TextArea.name() ||fieldtype == Schema.DisplayType.Reference.name()){
                         if(fieldElement.nodeValue != null &&  fieldElement.nodeValue != ''){
                           dataObject.put(fieldElement.nodeName, fieldElement.nodeValue);
                         }else{
                           dataObject.put(fieldElement.nodeName, null);
                         }
                         
                       }else if(fieldtype ==  Schema.DisplayType.Boolean.name() ){
                         if(fieldElement.nodeValue == '1'){
                           dataObject.put(fieldElement.nodeName,true);
                         }else{
                           dataObject.put(fieldElement.nodeName,false);
                         }
                       }
                     }
               }
            }
    }
    return dataObject;
  
  }
  
  //Method to write XML to persist state of an object using XMLStream writer class 
  private static String xmlWriter(List<SYSBRMapping__c> brMapping, String eventName){
    
    ExpressionParser eParser = new ExpressionParser();
    XmlStreamWriter xmlStream = new XmlStreamWriter();
    
    xmlStream.writeStartDocument(null, '1.0');
    xmlStream.writeStartElement(null, 'rows', null);
    xmlStream.writeStartElement(null, 'row', null);
    
    for(SYSBRMapping__c mapping:brMapping){
      String parsedValue = eParser.getParsedValue(newSObject, oldSObject, mapping.Value__c, eventName);
      xmlStream.writeStartElement(null, mapping.FieldName__c, null);
      xmlStream.writeCharacters(parsedValue);
      xmlStream.writeEndElement();
    }
    
    xmlStream.writeEndElement(); 
    xmlStream.writeEndElement(); 
    
    String xmlOutput = xmlStream.getXmlString();
    xmlStream.close();
    
    return xmlOutput;
  }
  
  //Wrapper method to get Email notification
  private static EmailNotificationWrapper getEmailNotificationWrapper(String brActionId) {
    
    EmailNotificationWrapper eNotificationWrapper;
    // Construct ConditionBuilder  
    ConditionBuilder whereClause = new ConditionBuilder();
    whereClause.setCondition('SYSBRActions__c = \'' + brActionId + '\'');
    
    // Construct List of field which you want to retrieve
    List<String> lstField = new List<String>();
    lstField.add('id');
    lstField.add('to__c');
    lstField.add('body__c');
    lstField.add('subject__c');
    lstField.add('SYSBRActions__c');
        
    sObject sObjEmailNotification = ObjectFactory.getInstanceByName('EmailNotification__c');

    DriverAccess dAccess = new DriverAccess();      
    List<sObject> lstEmails = dAccess.selectObjects(sObjEmailNotification, lstField, whereClause, null);
    
    if(lstEmails != null && lstEmails.size() > 0) {
      EmailNotification__c email = (EmailNotification__c) lstEmails.get(0);
      eNotificationWrapper = new EmailNotificationWrapper();
        String[] s = new List<String>();
          String[] splitAdd = StringUtil.splitEmailAddresses(email.to__c); 
          if (splitAdd != null)
            s.addAll(splitAdd);
          eNotificationWrapper.setToAddresses(s);
        
          // Instantiate ExpressionParser
          ExpressionParser eParser = new ExpressionParser();
          String body = email.body__c;
          if (oldSObject != null)
            body = eParser.parseEmailbody(body, oldSObject, BRConstants.OLD_REC);
          if (newSObject != null) 
            body = eParser.parseEmailbody(body, newSObject, BRConstants.NEW_REC);
          eNotificationWrapper.setBody(body);
          String subject = email.subject__c;
          if (oldSObject != null)
            subject = eParser.parseEmailbody(subject, oldSObject, BRConstants.OLD_REC);
          if (newSObject != null)
            subject = eParser.parseEmailbody(subject, newSObject, BRConstants.NEW_REC);
          eNotificationWrapper.setSubject(subject);
    }
        return eNotificationWrapper;
  }
  
}
			                            	