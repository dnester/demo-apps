public class BRInformationController {
    // Class stores BRAction and mappings together
    class BRActionAndMappings {
        //Stores the BRActions. All its fields will be directly linked to GUI
        SYSBRActions__c brAction;
        
        //Stores the BRMappings. All its fields will be directly linked to GUI
        List<SYSBRMapping__c> brMappings;
        
        BRActionAndMappings() {
            brAction = new SYSBRActions__c();
            brMappings = new List<SYSBRMapping__c>();
        }
        
        public SYSBRActions__c getBrAction() {
            return  brAction;
        }
        
        public void setBrAction(SYSBRActions__c brAction) {
            this.brAction = brAction;
        }
        
        public List<SYSBRMapping__c> getBrMappings() {
            return brMappings;
        }
        
        public void setBrMappings(List<SYSBRMapping__c> brMappings) {
            this.brMappings = brMappings;
        }
    }
    
     
    
    public string ruleName {get; set;}
    public string revisionHistory {get; set;}
    public string error {get; set;}
    // Stores the BRInformation. All its fields will be directly linked to GUI
    SYSBRInformation__c brInfo;
    
    // Stores the BRConditions. All its fields will be directly linked to GUI
    List<SYSBRConditions__c> brConditions;
    
    List<BRActionAndMappings> actionsAndMappingsList;
    
    // To store Module name on which BR is being created
    public String module{get;set;}
    
    // To store API name and label of Object/ Module Name 
    List<String> moduleNameList;
    List<String> moduleLabelList;
    List<SelectOption> moduleNames;
    
    String strFieldLabel;
    
    //To store fields Names and field Labels 
    List<String> fieldLabelList;
    List<String> fieldNameList;
    List<String> fieldTypeList;
    String fieldType;
    String conditionStr;
    Boolean isCondOnCreate;
    Boolean isCondOnUpdate;
    Boolean isCondOnDelete;
    List<List<String>> brConditionRecords;
    List<String> brConditionRecord;
    
    String actionStr;
    
    public List<List<String>> getBrConditionRecords(){
        System.debug(' Inside getter brConditionRecords ------------------------------------------------------------> ' + brConditionRecords);
        return brConditionRecords;
    }
    /*public void setBrConditionRecords(List<List<String>> brConditionRecords){
        this.brConditionRecords = brConditionRecords;
    }*/
    public void setActionStr(string actionStr){
        this.actionStr = actionStr;
    }
    public String getActionStr(){
        return this.actionStr;
    }
    
    public void setIsCondOnCreate(Boolean isCondOnCreate){
        this.isCondOnCreate = isCondOnCreate;
    }
    public Boolean getIsCondOnCreate(){
        return this.isCondOnCreate;
    } 
    
    public void setIsCondOnUpdate(Boolean isCondOnUpdate){
        this.isCondOnUpdate = isCondOnUpdate;
    }
    public Boolean getIsCondOnUpdate(){
        return this.isCondOnUpdate;
    }
    
    public void setIsCondOnDelete(Boolean isCondOnDelete){
        this.isCondOnDelete = isCondOnDelete;
    }
    public Boolean getIsCondOnDelete(){
        return this.isCondOnDelete;
    }
    
    public void setConditionStr(String conditionStr){
        this.conditionStr = conditionStr;
    }
    public String getConditionStr(){
        return conditionStr;
    }
    
    public void setFieldType(String fieldType){
        this.fieldType = fieldType;
    }       
    public String getFieldType(){
        return fieldType;
    }
    
    public List<String> getModuleLabelList() {
        return this.moduleLabelList;
    }
    
    public void setModuleLabelList(List<String> moduleLabelList) {
        this.moduleLabelList = moduleLabelList;
    }
    
    public List<String> getModuleNameList() {
        return this.moduleNameList;
    }
    
    public void setModuleNameList(List<String> moduleNameList) {
        this.moduleNameList = moduleNameList;
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
    
    public List<String> getFieldTypeList() {
        return this.fieldTypeList;
    }
    
    public void setFieldTypeList(List<String> fieldTypeList) {
        this.fieldTypeList = fieldTypeList;
    }
         
    public String getModule() {
        return this.module;
    }
    
    public void setModule(String module) {
        this.module = module;
    }
    
    public SYSBRInformation__c getBrInfo() {
        return brInfo;
    }
    public void setBrInfo(SYSBRInformation__c brInfo) {
        this.brInfo = brInfo;
    }
    
    public List<SYSBRConditions__c> getBrConditions() {
        return brConditions;
    }
    public void setBrConditions(List<SYSBRConditions__c> brConditions) {
        this.brConditions = brConditions;
    }
    
    public List<BRActionAndMappings> getActionsAndMappingsList() {
        return actionsAndMappingsList;
    }
    
    /*public void setActionsAndMappingsList(List<BRActionAndMappings> actionsAndMappingsList) {
        this.actionsAndMappingsList = actionsAndMappingsList;
    }*/
    
    public BRInformationController() {
        
        //Id brInfoId = ApexPages.currentPage.getParameters.get('brId');
        Id brInfoId;
        if(brInfo==null && (brInfoId == null || brInfoId == '')){
        brInfo = new SYSBRInformation__c();
        brConditions = new List<SYSBRConditions__c>();
        actionsAndMappingsList = new List<BRActionAndMappings>();
        
        moduleNameList= new List<String>();
        moduleLabelList = new List<String>();
        moduleNames = getModuleNames();
        
        fieldLabelList = new List<String>();
        fieldNameList = new List<String>();
        fieldTypeList = new List<String>();
            brConditionRecords = new List<List<String>>();
    }
        else if(brInfoId != null){
            
        }
         
    }
    
    public void importRule(){
    
    }
    public void exportRule() {
    
    }
    
    // Action For "Done" on schedule page
    public PageReference save() {
        DriverAccess dAccess = new DriverAccess();

        
        
        // Insert BRInformation
        Id infoId = dAccess.insertObject(brInfo, null);
        
        // Insert BRConditions
        for(SYSBRConditions__c brCondition : brConditions) {
             brCondition.BRInfoId__c = infoId;
        }
        List<Id> conditionResult = dAccess.insertObject(brConditions, null);
        
        // Insert BRActions and BRMappings.
        System.debug('In Save -- ' + actionsAndMappingsList);
        for(BRActionAndMappings actionAndMappings : actionsAndMappingsList) {
            actionAndMappings.brAction.BRInfoId__c = infoId;
            Id actionId = dAccess.insertObject(actionAndMappings.brAction, null);
            for (SYSBRMapping__c brMapping : actionAndMappings.brMappings) {
                brMapping.BRActionsId__c = actionId;
            }
            List<Id> mappingResult = dAccess.insertObject(actionAndMappings.brMappings, null);
        }
        return null; 
    }
    
    
    public PageReference nextOfBrInformationPage() {
        if (ruleName == null || ruleName.length() <= 0) {
            error = 'Error: You must Enter a value';
        }
        else {
            brInfo.Name__c = ruleName;
            brInfo.RevisionHistory__c = revisionHistory;
            System.debug('Rule Name -- ' + brInfo.Name__c);
            System.debug('Description ' + brInfo.Description__c);
            System.debug('Revision History' + brInfo.RevisionHistory__c);
            PageReference pageRef= Page.BRConditionPage;
            pageRef.setredirect(false);
            return pageRef;
            
        }
        return null;
    }
    
    public PageReference nextOfBrConditionPage(){
        brInfo.ModuleName__c = module;
        system.debug('nextOfBrConditionPage START');
        //System.debug('------------------------------------------------> ' + brConditionRecords); 
        PageReference pageRef= Page.BRActionPage;
        pageRef.setredirect(false);
        return pageRef;
        //system.debug('nextOfBrConditionPage END');
        //return Page.BRActionPage;
    }
    public PageReference previousOfBrInformationPage() {
        System.debug('Conditions:::' + brConditions);
        return Page.BroadcastsPage;
    }
    
    public PageReference doNext4(){
        return Page.BRActionPage;
    
    }
    public PageReference previousOfBrConditonPage() {
        brInfo.ModuleName__c = module;
        System.debug('------------------------------------------------> ' + brConditionRecords); 
        return Page.BRInformationPage;
    }
    
    public PageReference previousOfBrActionPage() {
         System.debug('------------------------------------------------> ' + brConditionRecords); 
         PageReference pageRef= Page.BRConditionPage;
         pageRef.setredirect(false);
         return pageRef;
        //return Page.BRConditionPage;
    }
    
    // value for drop down of Action Method
    public List<SelectOption> getActionMethod() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(BRConstants.CREATE_STR,BRConstants.CREATE_STR));
        options.add(new SelectOption(BRConstants.UPDATE_STR,BRConstants.UPDATE_STR));
        options.add(new SelectOption(BRConstants.DELETE_STR,BRConstants.DELETE_STR));
        return options;
    }
    
    // Get Module Names
    public List<SelectOption> getModuleNames() {
        List<SelectOption> options = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectType> validModuleNames = new Map<String, Schema.SObjectType>();
        for(String moduleName : gd.keySet()){ 
            //System.debug('>>>>>>>' + moduleName);
            if ((!moduleName.startsWith('sys')) && 
            (moduleName.endsWith('__c') || moduleName.endsWith('__C'))) {
               validModuleNames.put(moduleName, gd.get(moduleName));
            }
        }
        
        String brExclusionObjs = getBRExclusionObjects();
        if(brExclusionObjs != null) {
            String[] strObjs = brExclusionObjs.split(';',0);   // separate value with ;
            for(String moduleName : validModuleNames.keySet()) {
                if(!isBRExclusion(moduleName, strObjs)) {  // hide BR infrasturcture objects 
                    String strFieldLabel = validModuleNames.get(moduleName).getDescribe().getLabel();
                    options.add(new SelectOption(moduleName, strFieldLabel));
                    
                    moduleNameList.add(moduleName);
                    moduleLabelList.add(strFieldLabel);
                }
                
            }
        }
        
        
        /*for(String str : validModuleNames.keySet()) {
            Schema.SObjectType sobjtype = validModuleNames.get(str);
            String strFieldLabel = sobjtype.getDescribe().getLabel();
            moduleNameList.add(str);
            modleLabelList.add(strFieldLabel);
            
            
        }*/
        return options;
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
            //System.debug(prop.value__c);
            brExclusionValue = prop.value__c;
        }
        return brExclusionValue;
    }
    
    private Boolean isBRExclusion(String moduleName, String[] strObjs) {
        Boolean match = false;
        for(String strobj : strObjs) {
            if(strobj.equalsIgnoreCase(moduleName)) { 
                match = true;
                break;
            }
        }
        return match;
    }
    
    // Manage data table of BRConditions
     public void addConditions() {
        
        String exp1, compOp, exp2, logOp;
        
        System.debug('Condition String ---------------------------------------------->>' + conditionStr);
        conditionStr = conditionStr.trim();
        String[] conditions = conditionStr.split(';');
        brConditionRecords = new List<List<String>>();
        for(String str: conditions){
            System.debug('-----------------------------' + str);
            String[] condition = str.split(':');
            if(condition.size() == 4){
            exp1 = condition[0];
            compOp =  condition[1];
            exp2 = condition[2];
            logOp = condition[3];
            }
            SYSBRConditions__c brCondition = new SYSBRConditions__c(Expression1__c = exp1,Expression2__c = exp2, LogicalOpr__c = logOp ,CompareOpr__c = compOp);
        brConditions.add(brCondition);
            
            brConditionRecord = new List<String>();
            brConditionRecord.add(exp1);
            brConditionRecord.add(compOp);
            brConditionRecord.add(exp2);
            brConditionRecord.add(logOp);
            
            brConditionRecords.add(brConditionRecord);
            
        }
     
        System.debug('Inside addcondition------------------------------------------------> ' + brConditions);
        System.debug('Inside addcondition------------------------------------------------> ' + brConditionRecords);
        String eventNames = '';
        brInfo.EventName__c = null; 
        if(isCondOnCreate){
        
            eventNames +=  'Create;';
        }
        if(isCondOnUpdate){
            eventNames += 'Update;';
        }
        if(isCondOnDelete){
            eventNames += 'Delete;';
     }
     
        brInfo.EventName__c = eventNames;   
        
        
        //PageReference pageRef= new PageReference('/apex/BRActionPage');
        //pageRef.setredirect(false);
        //return Page.BRActionPage;
     }
     
     public void deleteCondition() {
        brConditions.remove(brConditions.size()-1);
     }
    
    // Manage data table of BRActions
    public void addActions() {
        actionsAndMappingsList.clear();
        System.debug(actionStr);
        if (actionStr != null && actionStr != '') {
            System.debug('----------------' + actionStr);
            actionStr = actionStr.trim();
            String[] actions = actionStr.split(';');
            for(String action: actions){
                BRActionAndMappings actionAndMappings = new BRActionAndMappings();
                String []actionAttributes = action.split('->');
                actionAndMappings.brAction.ActionMethod__c = actionAttributes[0];
                actionAndMappings.brAction.ActionModuleName__c = actionAttributes[1];
                if (actionAttributes[2]!= null && actionAttributes[2] != '' && 
                  !actionAttributes[2].equalsIgnoreCase('undefined')) {
                    String []mappings = actionAttributes[2].split('&');
                    for (String mapping : mappings) {
                        String []mappingAttr = mapping.split('=');
                        SYSBRMapping__c brMapping = new SYSBRMapping__c();
                        brMapping.FieldName__c = mappingAttr[0];
                        brMapping.Value__c = mappingAttr[1];
                        actionAndMappings.brMappings.add(brMapping);
                    }
                }
                actionsAndMappingsList.add(actionAndMappings);
            } 
        }
        System.debug('Action List==>>>>>' + actionsAndMappingsList); 
        //save();
    }
    
    public void deleteActions() {
        //actionsAndMappingsList.remove(actionsAndMappingsList.size()-1);         
    }
    
    public void setSelectedModule(){
        System.debug('---------------------------------------------------->' + module); 
    }   

    public void getModuleFields() {
        if(fieldLabelList.size() > 0)
            fieldLabelList.clear();
       
        if(fieldNameList.size() > 0)
            fieldNameList.clear();
        
        if(fieldTypeList.size() > 0)
            fieldTypeList.clear();
            
        String strFieldType;
        System.debug('---------------------------------------------------->' + 'In getModuleFields');
        System.debug('---------------------------------------------------->' + module); 
        List<SelectOption> fieldOptions = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        if(module!=null && module.length()>0) {
                Schema.SObjectType s1 = gd.get(module);
                Map<String, Schema.SObjectField> M = s1.getDescribe().fields.getMap();
                for(String s : M.keySet()) {
                    Schema.SObjectField fieldType = M.get(s);
                    strFieldLabel = fieldType.getDescribe().getLabel();
                    strFieldType = String.valueOf(fieldType.getDescribe().getType());
                    
                    
                    
                    System.debug('StrFieldType==================================================>' + strFieldLabel + '   ' +strFieldType);
                    
                        if(strFieldType == 'Schema.DisplayType.STRING') 
                            strFieldType = 'text';
                        else if(strFieldType == 'Schema.DisplayType.DATETIME') 
                            strFieldType = 'date';
                        else if(strFieldType == 'Schema.DisplayType.BOOLEAN')
                            strFieldType = 'combo';
                        else if(strFieldType == 'Schema.DisplayType.NUMBER') 
                            strFieldType = 'number';
                        else if(strFieldType == 'Schema.DisplayType.REFERENCE')
                            strFieldType = 'reference';
                        
                            fieldTypeList.add(strFieldType);
                            fieldLabelList.add(strFieldLabel);
                            fieldNameList.add(s);
                            System.Debug ('Label ---- ' + strFieldLabel + '  --  ' + s  );
                            fieldOptions.add(new SelectOption(s,strFieldLabel));
                            
                }
        }
        //return fieldOptions;
        
        /*for(SelectOption s : fieldOptions) {
            fieldLabelList.add(s.getLabel());
            fieldNameList.add(s.getValue());
            
        }*/
        system.debug('Module=>'+module);
        system.debug('fieldLabelList=>'+fieldLabelList);
        system.debug('fieldNameList=>'+fieldNameList);
        system.debug('fieldNameList=>'+fieldTypeList);
               
    }
    
    public string moduleForActionPage {get; set;}
    
    public void getModuleFieldsForActionPage() {
        if(fieldLabelList.size() > 0)
            fieldLabelList.clear();
       
        if(fieldNameList.size() > 0)
            fieldNameList.clear();
        
        if(fieldTypeList.size() > 0)
            fieldTypeList.clear();
            
        String strFieldType;
        System.debug('---------------------------------------------------->' + 'In getModuleFields');
        System.debug('---------------------------------------------------->' + moduleForActionPage); 
        List<SelectOption> fieldOptions = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        if(moduleForActionPage!=null && moduleForActionPage.length()>0) {
                Schema.SObjectType s1 = gd.get(moduleForActionPage);
                Map<String, Schema.SObjectField> M = s1.getDescribe().fields.getMap();
                for(String s : M.keySet()) {
                    Schema.SObjectField fieldType = M.get(s);
                    strFieldLabel = fieldType.getDescribe().getLabel();
                    strFieldType = String.valueOf(fieldType.getDescribe().getType());
                    
                    
                    
                    System.debug('StrFieldType==================================================>' + strFieldLabel + '   ' +strFieldType);
                    
                        if(strFieldType == 'Schema.DisplayType.STRING') 
                            strFieldType = 'text';
                        else if(strFieldType == 'Schema.DisplayType.DATETIME') 
                            strFieldType = 'date';
                        else if(strFieldType == 'Schema.DisplayType.BOOLEAN')
                            strFieldType = 'combo';
                        else if(strFieldType == 'Schema.DisplayType.NUMBER') 
                            strFieldType = 'number';
                        else if(strFieldType == 'Schema.DisplayType.REFERENCE')
                            strFieldType = 'reference';
                        
                            fieldTypeList.add(strFieldType);
                            fieldLabelList.add(strFieldLabel);
                            fieldNameList.add(s);
                            System.Debug ('Label ---- ' + strFieldLabel + '  --  ' + s  );
                            fieldOptions.add(new SelectOption(s,strFieldLabel));
                            
                }
        }
        //return fieldOptions;
        
        /*for(SelectOption s : fieldOptions) {
            fieldLabelList.add(s.getLabel());
            fieldNameList.add(s.getValue());
            
        }*/
        system.debug('Module=>'+moduleForActionPage);
        system.debug('fieldLabelList=>'+fieldLabelList);
        system.debug('fieldNameList=>'+fieldNameList);
        system.debug('fieldNameList=>'+fieldTypeList);
               
    }
    
    public void onload() {
        System.debug('Condition Page Rule Name -- ' + brInfo.Name__c);
        System.debug('Condition Page Description ' + brInfo.Description__c);
        System.debug('Condition Page Revision History' + revisionHistory);
        System.debug('------------------------------------------------> ' + actionsAndMappingsList);
    }
        
    public String getValidData(String data){
        if(data==null) return '-';
        return data;
    }
   
    
}
			                            	