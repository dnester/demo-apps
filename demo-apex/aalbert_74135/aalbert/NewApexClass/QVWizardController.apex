public with sharing class QVWizardController {
  public QVWizardController(){
    initQv();//Added By Avadhut K.
    initQuery();
  }
  
  // Define member variables here to maintain state between various pages in the wizard.
  //Added by Sachin
  String strFieldLabel, strFieldType;   
  public String module;
  SYSQVFieldInfo__c fieldInfo; 
  List<String> fieldLabelList;
  List<String> fieldNameList;
  List<String> dataSourceNameList;
  List<String> dataSourceLabelList;
  String fieldLabel;
  String fieldName;
  List<String> expression1TypeList;
  List<String> expression1LabelList;
  String QVString;
    
  List<String> lstOutputFields;
  ConditionBuilder objConditionBuilder;
  DriverAccess objDriverAccess;
    
  String popupId;
  String apiName;
  String nameField;
  String idField;
  
  Map<String, Schema.SObjectField> M;
  
  // Define the methods needed to manage the above member variables.
  //Added by Sachin
  public List<String> getDataSourceLabelList() {
        return this.dataSourceLabelList;
    }
    
    public void setDataSourceLabelList(List<String> dataSourceLabelList) {
        this.dataSourceLabelList = dataSourceLabelList;
    }
    
    public List<String> getDataSourceNameList() {
        return this.dataSourceNameList;
    }
    
    public void setDataSourceNameList(List<String> dataSourceNameList) {
        this.dataSourceNameList = dataSourceNameList;
    }
    
    
    public List<String> getFieldLabelList() {
        return this.fieldLabelList;
    }
    
    public void setFieldLabelList(List<String> fieldLabelList) {
        this.fieldLabelList = fieldLabelList;
    }
    
    public List<String> getFieldNameList() {
        return this.fieldNameList;
    }
    
    public void setFieldNameList(List<String> fieldNameList) {
        this.fieldNameList = fieldNameList;
    }
    
    public List<String> getExpression1TypeList() {
        return this.expression1TypeList;
    }
    
    public void setExpression1TypeList(List<String> expression1TypeList) {
        this.expression1TypeList = expression1TypeList;
    }
    
    public List<String> getExpression1LabelList() {
        return this.expression1LabelList;
    }
    
    public void setExpression1LabelList(List<String> expression1LabelList) {
        this.expression1LabelList = expression1LabelList;
    }
    
    
    public String getFieldLabel() {
        return fieldLabel;
    }
    
    public void setFieldLabel(String fieldLabel) {
        this.fieldLabel = fieldLabel;
    }
    
    public String getFieldName() {
        return fieldName;
    }
    
    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }
    
    
    public String getModule() {
        //return this.modules;
        return this.module;
    }
    
    public void setModule(String module) {
        this.module = module;
    }
    
    public String getQVString() {
        return this.QVString;
    }
    
    public void setQVString(String QVString) {
        this.QVString = QVString;
    }


    public String getPopupId() {
        return this.popupId;
    }
    
    public void setPopupId(String popupId) {
        this.popupId= popupId;
    }
    
    public String getApiName() {
        return this.apiName;
    }
    
    public void setApiName(String apiName) {
        this.apiName= apiName;
    }
    
    public String getNameField() {
        return this.nameField;
    }
    
    public void setNameField(String nameField) {
        this.nameField= nameField;
    }
    
    public String getIdField() {
        return this.idField;
    }
    
    public void setIdField(String idField) {
        this.idField= idField;
    }
    
    public SYSQVFieldInfo__c getFieldInfo() {
        return this.fieldInfo;
    }
    
    public void setFieldInfo(SYSQVFieldInfo__c fieldInfo) {
        this.fieldInfo = fieldInfo;
    }
    
  
  
    public void initQuery() {
    
        fieldLabelList = new List<String>();
        fieldNameList = new List<String>();
        dataSourceNameList = new List<String>();
        dataSourceLabelList = new List<String>();
        expression1LabelList = new List<String>();
        expression1TypeList = new List<String>();
        
        lstOutputFields = new List<String>();
        objConditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
        
        
        getModuleList();
        //getFieldItems();
    
    }  
    
    
    public void getModuleList() {
        
        List<SelectOption> options = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectType> createOptions = new Map<String, Schema.SObjectType>();
        
        for(String str:gd.keySet()){ // Put only custom object into list of select option
            if((!(str.startsWith('SYS') || str.startsWith('sys'))) && (str.endsWith('__c') || str.endsWith('__C'))){
                createOptions.put(str, gd.get(str));
            }
        }
        
        String brExclusionObjs = getBRExclusionObjects();
        system.debug('===>>>brExclusionObjs'+brExclusionObjs);
        if(brExclusionObjs != null) {
            String[] strObjs = brExclusionObjs.split(';',0);   // separate value with ;
            
            for(String str : createOptions.keySet()) {
            
                if(!containsBRExclusion(str,strObjs)) {  // hide BR infrasturcture objects 
                    Schema.SObjectType sobjtype = createOptions.get(str);
                    strFieldLabel = sobjtype.getDescribe().getLabel();
                    options.add(new SelectOption(str,strFieldLabel));
                    dataSourceNameList.add(str);
                    dataSourceLabelList.add(strFieldLabel);
                }
            }
        }
        strFieldLabel = null;
        system.debug('=>'+dataSourceNameList);
        //return options;
        
    }
    
    
    // Check whether object name retrieve from Metadata API is part of BRExclusion property.
    private Boolean containsBRExclusion(String str, String[] strObjs) {
        Boolean match = false;
        for(String strobj : strObjs) {
            if(strobj.equalsIgnoreCase(str)) { 
                match = true;
                break;
            }
        }
        return match;
    }
    
    
    // Get BR Exclusion object from SDEProperties
    public String getBRExclusionObjects() {
        String brExclusionValue = '';
        // construct condition with property = propObjectExclusion
        ConditionBuilder con = new ConditionBuilder();
        con.setCondition(' Property__c = \'propObjectExclusion\' ');
        
        DriverAccess d = new DriverAccess();
        // get concrete object reference from ObjectFactory for SDEProperties
        sObject sdeprop = ObjectFactory.getInstanceByName('SYSProperties__c');

        // select list of fields which you want to retrieve                
        List<String> fields = new List<String>();
        fields.add('Property__c');
        fields.add('value__c');
              
        List<SObject> lst =  d.selectObjects( sdeprop,fields , con, null);
        if(lst != null && lst.size() > 0) {
            SYSProperties__c prop = (SYSProperties__c) lst.get(0);
            System.debug(prop.value__c);
            brExclusionValue = prop.value__c;
        }
        return brExclusionValue;
    }
    
    
    // Load fields depening on value of modules
   /* public List<SelectOption> getFieldItems() {
        List<SelectOption> fieldOptions = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        //if(modules!=null && modules.length()>0) {
                modules = 'Task__c';
                Schema.SObjectType s1 = gd.get(modules);
                Map<String, Schema.SObjectField> M = s1.getDescribe().fields.getMap();
                for(String s : M.keySet()) {
                    Schema.SObjectField fieldType = M.get(s);
                    strFieldLabel = fieldType.getDescribe().getLabel();
                    fieldOptions.add(new SelectOption('{NEW, ' + s + '}',strFieldLabel));
                }
        //}
        return fieldOptions;
    }*/
    
    public void getFieldItems() {
        List<SelectOption> fieldOptions = new List<SelectOption>();
        
        if(expression1TypeList.size() > 0)
            expression1TypeList.clear();
            
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        if(module!=null && module.length()>0) {
                
                
                Schema.SObjectType s1 = gd.get(module);
                M = s1.getDescribe().fields.getMap();
                for(String s : M.keySet()) {
                    Schema.SObjectField fieldType = M.get(s);
                    
                    strFieldType = String.valueOf(fieldType.getDescribe().getType());
                    system.debug('FIELD TYPES ====>>>>>>'+String.valueOf(fieldType.getDescribe().getType()));
                    if(strFieldType == 'Schema.DisplayType.STRING' || strFieldType == 'Schema.DisplayType.TEXTAREA') 
                        strFieldType = 'text';
                    else if(strFieldType == 'Schema.DisplayType.DATETIME'  || strFieldType == 'Schema.DisplayType.DATE') 
                        strFieldType = 'date';
                    else if(strFieldType == 'Schema.DisplayType.BOOLEAN')
                        strFieldType = 'combo';
                    else if(strFieldType == 'Schema.DisplayType.NUMBER' || strFieldType == 'Schema.DisplayType.DOUBLE' || strFieldType == 'Schema.DisplayType.PHONE') 
                        strFieldType = 'number';
                    else if(strFieldType == 'Schema.DisplayType.REFERENCE') {
                        List<SObjectType> sList = fieldType.getDescribe().getReferenceTo();
                        strFieldType = 'lookUp';
                        
                    }
                    
                    strFieldLabel = fieldType.getDescribe().getLabel();
                    fieldOptions.add(new SelectOption(s,strFieldLabel));
                    expression1TypeList.add(strFieldType);
                }
                
                
                
        }
        //return fieldOptions;
        
        
        if(fieldLabelList.size() > 0)
            fieldLabelList.clear();
       
        if(fieldNameList.size() > 0)
            fieldNameList.clear();
        
        for(SelectOption s : fieldOptions) {
            fieldLabelList.add(s.getLabel());
            fieldNameList.add(s.getValue());
            
        }
               
    }
    
    public PageReference getModulePopUpId() {
        
        String objectName;
        system.debug('******'+apiName);
        
        List<SObjectType> sList = M.get(apiName).getDescribe().getReferenceTo();
        
        if(sList.size() > 0) {
            objectName = String.valueOf(sList[0]);
        }
        
        
        
        /*if(apiName.startsWith('fk') && apiName.endsWith('__c')) {
            apiname = apiName.subString(2,apiName.length());
            system.debug('sub1'+ apiName);
            apiname = apiName.subString(0,apiName.length()-3);
            system.debug('sub2'+ apiName);
            
        }*/
        system.debug('objectName +'+objectName);        
        //Get popupId from SYSPopUpObject
        if(lstOutPutFields.size() > 0)
            lstOutPutFields.clear();
            
        lstOutPutFields.add('Id');
        lstOutPutFields.add('Name');
        
        String query = 'popupObjectName__c =' +'\''+objectName+'\'';
        objConditionBuilder.setCondition(query);
        
        List<SYSPopupObject__c> popupObjectList = (List<SYSPopupObject__c>) objDriverAccess.selectObjects(new SYSPopupObject__c(),lstOutPutFields,objConditionBuilder,null);
        
        if(popupObjectList.size() > 0){
            popupId = popupObjectList[0].Name;
        }
        system.debug('=====>>>>>'+popupId); 
        return null;
    }
    
    public PageReference saveQVData() {
        
        system.debug('QVString==>>');
        
        system.debug('QVString==>>'+QVString);
        List<String> queryParams = QVString.split(',');
        
        system.debug('SIZE==>>'+queryParams.size());
        
        system.debug('MODULE==>>'+module);
        
        
        validateGeneral();
        objDriverAccess.insertObject(qvQry, null);
        system.debug('====>>>>QVQRY'+qvQry);
        
        
        if(lstOutPutFields.size() > 0)
                lstOutPutFields.clear();
            
            lstOutPutFields.add('Id');
            lstOutPutFields.add('Name');
            lstOutPutFields.add('name__c');
                    
            String qName = 'Open Tasks';
            String query = 'Id =' +'\''+qvQry.Id+'\'';
            objConditionBuilder.setCondition(query);
        
            List<SYSQVQuery__c> queryForQV = (List<SYSQVQuery__c>) objDriverAccess.selectObjects(new SYSQVQuery__c(),lstOutPutFields,objConditionBuilder,null);
        
        
        for(Integer i=0; i<queryParams.size(); i++) {
            system.debug('*****===='+queryParams[i]);
            
            if(i==0) {
                system.debug('Hi');
                List<string> outParams = queryParams[i].split(':');
                
                for(Integer j=0; j<outParams.size(); j++) {
                    
                    if(outParams[j] != '') {
                    
                    SYSQVFieldInfo__c field = new SYSQVFieldInfo__c();  
                    List<String> outFields = outParams[j].split('&#');
                    for(Integer l=0; l<outFields.size(); l++) {
                        
                        system.debug('outFields ++++++++'+ outFields[l]);
                        if(l == 0) {
                            field.Name = outFields[l];
                        }
                        else if(l==1) {
                            field.displayLabel__c = outFields[l];
                        }
                    }
                    
                    system.debug('OUT : ' +outParams[j]);
                    //Insert this field in SYSQVFieldInfo
                    
                    //field.Name = outParams[j];
                    field.displayPosition__c = j;
                    field.isDisplayed__c = true;
                    field.columnWidth__c = 100;
                    
                    if(queryForQV.size() > 0) {
                        field.FKSYSQVQuery__c = queryForQV[0].Id;
                    }
                    //field.displayLabel__c = 'tempLabel';
                    system.debug('Inserting FieldInfo ************'+ field);
                    objDriverAccess.insertObject(field, null);
                    
                    SYSQVFieldsObjectsInfo__c objectInfo = new SYSQVFieldsObjectsInfo__c();
                    objectInfo.FKSYSQVFieldInfo__c = field.Id;
                    objectInfo.objectName__c = module; 
                    objectInfo.fieldName__c = field.Name;
                    
                    system.debug('Inserting FieldObjectInfo ************'+ objectInfo);
                    objDriverAccess.insertObject(objectInfo, null);
                    }
                         
                }
            }
            else {
                    List<String> conditionParam = queryParams[i].split('#');
                
                        SYSQVFieldInfo__c conditionField = new SYSQVFieldInfo__c();
                        if(queryForQV.size() > 0)
                            conditionField.FKSYSQVQuery__c = queryForQV[0].Id;
                        conditionField.isDisplayed__c = false;
                        conditionField.displayPosition__c = i;
                        
                        SYSQVCondition__c QVCondition = new SYSQVCondition__c();
                        
                        QVCondition.orderIndex__c = i;
                        if(queryForQV.size() > 0)
                            QVCondition.FKSYSQVQuery__c = queryForQV[0].Id;
                        
                
                for(Integer k=0; k<conditionParam.size(); k++) {
                    //Insert into SYSQVFieldInfo and SYSQVCondition.
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+conditionParam[k]);
                        
                        if(k==0) {
                            conditionField.displayLabel__c = conditionParam[k]; 
                        }
                        else if(k==1) {
                            conditionField.Name = conditionParam[k];
                        }
                        else if(k==2) {
                            QVCondition.SYSQVOperator__c = conditionParam[k];
                        }
                        else if(k==3) {
                            QVCondition.operand1__c = conditionParam[k];
                            QVCondition.operand2__c = 'null';
                            
                        }   
                        else if(k==4) {
                            
                            if(conditionParam[k] == 'AND')
                                QVCondition.groupingOperator__c = 1;
                            else if(conditionParam[k] == 'OR')
                                QVCondition.groupingOperator__c = 0;
                                
                        }
                }
                system.debug('Inserting condition field**********'+ conditionField);
                objDriverAccess.insertObject(conditionField, null);
                
                system.debug('Inserting condition clause**********'+ QVCondition);
                QVCondition.FKSYSQVFieldInfo__c = conditionField.Id;
                objDriverAccess.insertObject(QVCondition, null);
                
            }
            
        }
        
        //Enter data in SYSQVPageReference
        SYSQVPageReference__c pageReference = new SYSQVPageReference__c();
        pageReference.FKSYSQVQuery__c = qvQry.Id;
        
        if(lstOutPutFields.size() > 0)
            lstOutPutFields.clear();
            
        lstOutPutFields.add('Id');
        lstOutPutFields.add('Name');
                    
        String objectName = module;
        String queryString = 'objectName__c =' +'\''+objectName+'\'';
        objConditionBuilder.setCondition(queryString);
        
        List<SYSPageObjectAssociation__c> pageObjectList = (List<SYSPageObjectAssociation__c>) objDriverAccess.selectObjects(new SYSPageObjectAssociation__c(),lstOutPutFields,objConditionBuilder,null);
        
        if(pageObjectList.size() > 0)
            pageReference.FKSYSPageObjectAssociation__c = pageObjectList[0].Id;
        
        objDriverAccess.insertObject(pageReference, null);
        
        return null;
    }
    
    
    
    public PageReference findNameField() {
        system.debug('==============>>>>>>>>'+idField);
        
        String objectName;
        List<SObjectType> sList = M.get(apiName).getDescribe().getReferenceTo();
        
        if(sList.size() > 0) {
            objectName = String.valueOf(sList[0]);
        }
        
        if(lstOutPutFields.size() > 0)
                lstOutPutFields.clear();
            
            lstOutPutFields.add('Id');
            lstOutPutFields.add('Name');
                    
            String query = 'Id =' +'\''+idField+'\'';
            objConditionBuilder.setCondition(query);
        
            SObject objectModule = SObjectFactory.getSObject(objectName);    
            system.debug('=>Module :'+objectModule);
            system.debug('=>fields :'+lstOutputFields);
            List<SObject> recordList = objDriverAccess.selectObjects(objectModule, lstOutputFields, objConditionBuilder, null);            
            
            if(recordList.size() > 0) {
                nameField = (String)recordList[0].get('Name');
            }
        system.debug('==============>>>>>>>>'+nameField);
             
        return null;    
    }
    
    

    
 //End by Sachin K   
  
  
  
  
  
  
  // The methods that will be used to navigate through the wizard.
  // The following methods return the page reference of the respective pages.

    // This method returns the page reference of the Intro page of the wizard.
    public Pagereference stepIntro(){
        Pagereference page=new Pagereference('/apex/QVWizIntroPage').setRedirect(false);
        return page;
    }
  
  // This method returns the page reference of the General page of the wizard.
  public Pagereference stepGeneral(){
    Pagereference page=new Pagereference('/apex/QVWizardGeneralPage').setRedirect(false);
    return page;
  }
  
  // This method returns the page reference of the Query page of the wizard.
  public Pagereference stepQuery(){
    saveGeneral();
    Pagereference page=new Pagereference('/apex/QVWizQueryPage').setRedirect(false);
    return page;
  }
  
  // This method returns the page reference of the Table view page of the wizard.
  public Pagereference stepTableview(){
    Pagereference page=new Pagereference('/apex/QVWizTableviewPage').setRedirect(false);
    return page;
  }
  
  // This method returns the page reference of the Chart view page of the wizard.
  public Pagereference stepChartview(){
    Pagereference page=new Pagereference('/apex/QVWizChartviewPage').setRedirect(false);
    return page;
  }
  
  // This method returns the page reference of the Calendar view page of the wizard.
  public Pagereference stepCalendarview(){
    Pagereference page=new Pagereference('/apex/QVWizCalendarviewPage').setRedirect(false);
    return page;
  }
    
    private void saveQV(){
      //
    }
    //Added By Avadhut K.
    public SYSQVQuery__c qvQry {get; set;}
    public SYSQVQueryAccess__c qvQryAcc {get; set;}
    public List<Profile> lstProfiles {get; set;}
    public String selectedProfiles {get; set;}      
    private void initQv(){
        selectedProfiles='';
        qvQry = new SYSQVQuery__c();
        qvQryAcc = new SYSQVQueryAccess__c();
        String qvId = Apexpages.currentPage().getParameters().get('qvId');
        if(qvId!=null){
            DriverAccess dao = new DriverAccess();
            ConditionBuilder cb = new ConditionBuilder();
            cb.setCondition('id='+qvId);
            List<SYSQVQuery__c> qvs = (List<SYSQVQuery__c>)dao.selectObjects(SObjectFactory.getSObject('SYSQVQuery__c'), null, cb, null);
            if(qvs.size()>0){
              qvQry=qvs.get(0);
              cb = new ConditionBuilder();
              cb.setCondition('id='+qvQry.Id);
              List<SYSQVQueryAccess__c> qvas = (List<SYSQVQueryAccess__c>)dao.selectObjects(SObjectFactory.getSObject('SYSQVQuery__c'), null, cb, null);
              if(qvas.size()>0)
                  qvQryAcc=qvas.get(0);
            }
        }
        initGeneralPage();
    }
    public void initGeneralPage(){
        if(lstProfiles == null || lstProfiles.size()<1){
            DriverAccess dao = new DriverAccess();
            ConditionBuilder cb = new ConditionBuilder();
            cb.setCondition('');
            List<String> poCols = new List<String>();
            //Select p.id, p.Name, p.Description From Profile p 
            poCols.add('Id');
            poCols.add('Name');
            poCols.add('Description');
            lstProfiles = (List<Profile> )dao.selectObjects(new Profile(), poCols, cb, null); 
        }
        if(lstProfiles==null) lstProfiles = new List<Profile>();
    }
    public String getLstProfilesData(){
        String strLstProfiles='';
        if(lstProfiles==null) return strLstProfiles;
        Integer cnt=0;
        for(Profile p:lstProfiles){
            strLstProfiles = strLstProfiles + 'resultSet['+cnt+']=new Array(4);'+
                'resultSet['+cnt+'][0]="'+p.id+'"; resultSet['+cnt+'][1]="'+getValidData(p.name)+'"; resultSet['+cnt+'][2]="'+getValidData(p.description)+'";';
            cnt++;
        }
        return strLstProfiles;
    }
    public String getValidData(String data){
        if(data==null) return '-';
        return data;
    }
    private void validateGeneral(){
      //if(qvQry.accessType__c<0 && qvQry.accessType__c>3)
        qvQry.accessType__c=2; 
        qvQry.isImmutable__c=1;
        qvQry.viewType__c=2;
        //qvQry.FKOwner__c
    }
    private void saveGeneral(){
        DriverAccess dao = new DriverAccess();
        ConditionBuilder cb = new ConditionBuilder();
        cb.setCondition('');
        /*if(qvQry.id==null){
          Id id=dao.insertObject(qvQry, null);
          qvQryAcc.FKQuery__c=id;
          dao.insertObject(qvQryAcc, null);
        }else{
          if(dao.updateObject(qvQry, cb, null))
                dao.updateObject(qvQryAcc, cb, null);
        }*/
    }
    private User getCurrentUser(){
      DriverAccess dao = new DriverAccess();
        ConditionBuilder conditionBuilder = new ConditionBuilder();
        String usrProfile ='';
        String condition = 'Id = '+'\'' + userinfo.getUserId() + '\'';
        conditionBuilder.setCondition(condition);
        List<String> listFields = new List<String>();
        listFields.add('id');
        listFields.add('Name');
        listFields.add('ProfileId');
        listFields.add('Profile.Name');
        List<User> userList =  (List<User>)dao.selectObjects(new User(), listFields, conditionBuilder, null);
        if(userList.size()> 0){
            return userList[0]; 
        }
        return null;      
    }
    //End by Avadhut K.
}
			                            	