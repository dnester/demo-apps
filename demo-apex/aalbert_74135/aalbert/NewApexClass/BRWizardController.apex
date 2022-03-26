public class BRWizardController {
        
    public String fields { get; set; }
    public String ruleName { get; set; }
    public Boolean isEnabled { get; set; }
    public String description { get; set; }
    public String modules { get; set;}
    public String actionMethod { get; set; }
    public String[] events = new String[] {};  
    String strFieldLabel;   
    
    private Map<Integer,SYSBRActions__c> actionMapTemp = new Map<Integer, SYSBRActions__c>();
    private Integer actionCount = 0;
    private Map<Integer, List<SYSBRMapping__C>> mappingMapTemp = new Map<Integer, List<SYSBRMapping__C>>();
    private Integer mappingCount = 0; 
    
    // member variables for rendering widgets dynamically based on data type of fields
    public String inputTxtVisibility ;
    public String inputTxtAreaVisibility ;
    public String radioBtnVisibility ;
    public String picklistVisibility ;
    private Map<String,Schema.DisplayType> fieldLabelTypeMap;
    private Map<String, String> fieldAPILabelMap;
    
    public  BRWizardController() {
         // dataListTemp = [Select b.id,b.LogicalOpr__c, b.Expression2__c, b.Expression1__c, b.CompareOpr__c, b.BRInfoId__c From SYSBRConditions__c b];
         dataListTemp = new List<SYSBRConditions__c>();
       //   actionListTemp = [Select a.id,a.ActionMethod__c, a.ActionModuleName__c, a.BRInfoId__c From SYSBRActions__c a];
        actionListTemp = new List<SYSBRActions__c>();
        // mapdataListTemp = [Select m.id, m.FieldName__c, m.Value__c, m.BRActionsId__c From SYSBRMapping__c m];
        mapdataListTemp = new List<SYSBRMapping__c>();
        
        // default on page load <apex:inputText> only visible
        inputTxtVisibility = 'true';
        inputTxtAreaVisibility = 'false';
        radioBtnVisibility = 'false';     
        picklistVisibility = 'false';
        fieldLabelTypeMap = new Map<String,Schema.DisplayType>();
        fieldAPILabelMap = new Map<String, String>();
    }
    
    public String getInputTxtvisibility() {
        return inputTxtVisibility;
    }
    public void setInputTxtvisibility(String str) {
        inputTxtVisibility = str;
    }
    public String getInputTxtAreaVisibility () {
        return inputTxtAreaVisibility ;
    }
    public void setInputTxtAreaVisibility (String str) {
        inputTxtAreaVisibility = str;
    }
    public String getRadioBtnVisibility() {
        return radioBtnVisibility ;
    }
    public void setRadioBtnVisibility(String str) {
        radioBtnVisibility = str;
    }
    public String getPicklistVisibility () {
        return picklistVisibility ;
    }
    public void setPicklistVisibility (String str) {
        picklistVisibility = str;
    }
   
    // Populate object name in combobox
    public List<SelectOption> getModuleItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectType> createOptions = new Map<String, Schema.SObjectType>();
        for(String str:gd.keySet()){ // Put only custom object into list of select option
            if(str.endsWith('__c') || str.endsWith('__C')){
                createOptions.put(str, gd.get(str));
            }
        }
        // get BRExclusion objects
        String brExclusionObjs = getBRExclusionObjects();
        if(brExclusionObjs != null) {
          String[] strObjs = brExclusionObjs.split(';',0);   // separate value with ;
          for(String str : createOptions.keySet()) {
                if(!containsBRExclusion(str,strObjs)) {  // hide BR infrasturcture objects 
                    Schema.SObjectType sobjtype = createOptions.get(str);
                  strFieldLabel = sobjtype.getDescribe().getLabel();
                  options.add(new SelectOption(str,strFieldLabel));
                }
          }
        }
        strFieldLabel = null;
        return options;
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
        String brExclusionValue;
        // construct condition with property = propObjectExclusion
        ConditionBuilder con = new ConditionBuilder();
        con.setCondition(' Property__c = \'propObjectExclusion\' ');
        System.debug(con.getCondition());
        
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
    public List<SelectOption> getFieldItems() {
        List<SelectOption> fieldOptions = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        if(modules!=null && modules.length()>0) {
                Schema.SObjectType s1 = gd.get(modules);
                Map<String, Schema.SObjectField> M = s1.getDescribe().fields.getMap();
                for(String s : M.keySet()) {
                        Schema.SObjectField fieldType = M.get(s);
                        strFieldLabel =  fieldType.getDescribe().getLabel();
                    fieldOptions.add(new SelectOption('{NEW, ' + s + '}','{NEW, ' + strFieldLabel + '}'));
            }
        }
        return fieldOptions;
    }
    
    public String[] getEvents() {
        return events;
    }
    public void setEvents(String[] events) {
        this.events = events;
    }
    public List<SelectOption> getEventItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(BRConstants.CREATE_STR,BRConstants.CREATE_STR));
        options.add(new SelectOption(BRConstants.UPDATE_STR,BRConstants.UPDATE_STR));
        options.add(new SelectOption(BRConstants.DELETE_STR,BRConstants.DELETE_STR));
        return options;
    }
    
    public List<SelectOption> getComparisonOpr() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(BRConstants.EQUALS_OPR,BRConstants.EQUALS_OPR));
        options.add(new SelectOption(BRConstants.GREATER_THAN_OPR,BRConstants.GREATER_THAN_OPR));
        options.add(new SelectOption(BRConstants.LESS_THAN_OPR,BRConstants.LESS_THAN_OPR));
        return options;
    }
    
    public List<SelectOption> getLogicalOpr() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        options.add(new SelectOption(BRConstants.AND_OPR,BRConstants.AND_OPR));
        options.add(new SelectOption(BRConstants.OR_OPR,BRConstants.OR_OPR));
        return options;
    }
    
    // Add structured data into BR infrastructure objects
    public PageReference save() {
        System.debug('Business Rule Name: ' + ruleName);
        System.debug('IsEnabled: ' + isEnabled);
        System.debug('Description: ' + description);
        System.debug('Condition On:' + modules);
        System.debug('Events:' + events);
        System.debug('Conditions: ' + dataListTemp);
        System.debug('Actions :' + actionListTemp);
        System.debug('MappingListData: ' + mapdataListTemp);
        System.debug('Map 1 ActionMapTemp : ' + actionMapTemp);
        System.debug('Map 2 MappingMapTemp: ' + mappingMapTemp);
        
        DriverAccess dAccess = new DriverAccess();
        
        SYSBRInformation__c brInfo = new SYSBRInformation__c();
        brInfo.Name__c = ruleName;
        brInfo.IsActive__c = isEnabled;
        brInfo.Description__c = description;
        brInfo.ModuleName__c = modules;
        
        brInfo.EventName__c = StringUtil.mergeString(events, ';' );
                
        Id infoId = dAccess.insertObject(brInfo, null);
        
        // set parentId into BRConditions
        for(SYSBRConditions__c brCondition : dataListTemp) {
             brCondition.BRInfoId__c = infoId;
        }
        
        List<Id> conditionResult = dAccess.insertObject(dataListTemp,null);
        
        // set parentId into BRActions
        List<SYSBRActions__c> actionLst = actionMapTemp.values(); 
        for(SYSBRActions__c brAction : actionLst) {
             brAction.BRInfoId__c = infoId;
        }
        List<Id> actionResult = dAccess.insertObject(actionLst,null);
                
        // set parentId into BRMapping
        List<List<SYSBRMapping__c>> mappingLst   = mappingMapTemp.values();
        for(integer i = 0 ; i < mappingLst.size() ; i++) {
              for(SYSBRMapping__c brmapping : mappinglst.get(i)) {
                     brmapping.BRActionsId__c = actionResult.get(i);
              }
              // insert mappinglst.get(i);
            List<Id> mappingResult = dAccess.insertObject(mappinglst.get(i),null);
        }
        return null;
    }
    ////////////////////// code for dynamic table//////////////////////////
    private List<SYSBRConditions__c> dataListTemp = new List<SYSBRConditions__c>();
    
    public List<SYSBRConditions__c> getDataListTemp (){
        return this.dataListTemp ;
    }
    public void setDataListTemp (List<SYSBRConditions__c> dataListTemp ){
        this.dataListTemp = dataListTemp ;
    }
    
    public void add(){
        SYSBRConditions__c addThis = new SYSBRConditions__c();
        dataListTemp.add(addThis);  
    }
    
    public void del(){        
        dataListTemp.remove(0);  
    }
    
    ////////////////////// code for dynamic Action table //////////////////////////
    private List<SYSBRActions__c> actionListTemp = new List<SYSBRActions__c>();
    public List<SYSBRActions__c> getActionListTemp (){
        return this.actionListTemp ;
    }
    
    public void setActionListTemp (List<SYSBRActions__c> actionListTemp ){
        this.actionListTemp = actionListTemp ;
    }
    public void addAction(){
        SYSBRActions__c addThis = new SYSBRActions__c();
        addThis.ActionModuleName__c  = actionModule;
        addThis.ActionMethod__c = actionMethod;
        actionListTemp.add(addThis);
        actionCount++;
        actionMapTemp.put(actionCount,addThis);
    }
    
    public void delAction(){        
        actionListTemp.remove(actionListTemp.size()-1);  //Remove last element from list  
        actionMapTemp.remove(actionCount);
        
        if(mappingMapTemp.containsKey(actionCount)) {
                mappingMapTemp.remove(actionCount);
        }
        actionCount--;
    }
    
    public PageReference open() {
        actionModule = ApexPages.currentPage().getParameters().get('actionModule');
        System.debug('Action Module in open ' + actionModule);
        return null;
    }
    
    
    // ConBRActionMapping...
    
    public String mappingfields { get; set; }
    public String fieldValue { get; set; }
    private String actionModule { get; set; }
   // Get list of all action fields depending on action module selection   
    public List<SelectOption> getActionFieldItems() {
        List<SelectOption> fieldOptions = new List<SelectOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        System.debug('Action Module in  getActionFieldItems' + actionModule);
        requiredFields = '';
        if(actionModule !=null && actionModule.length()>0){
            Schema.SObjectType s1 = gd.get(actionModule);
            Map<String, Schema.SObjectField> M = s1.getDescribe().fields.getMap();
            for(String s : M.keySet()) {
                Schema.SObjectField fieldType = M.get(s);
                strFieldLabel =  fieldType.getDescribe().getLabel();
                fieldLabelTypeMap.put(s, fieldType.getDescribe().getType());
                fieldAPILabelMap.put(s,strFieldLabel);
                fieldOptions.add(new SelectOption(s,strFieldLabel));
                
                // Check weather field is required or not
                if(( fieldType.getDescribe().isNillable() == false && 
                        fieldType.getDescribe().isDefaultedOnCreate() == false )|| 
                        fieldType.getDescribe().isNameField() == true)
                  requiredFields += strFieldLabel + ',';
           }
           requiredFields = requiredFields.substring(0,requiredFields.lastIndexOf(','));
        }
        return fieldOptions;
    }
    ////////////////////// code for dynamic table//////////////////////////
    private List<SYSBRMapping__c> mapdataListTemp = new List<SYSBRMapping__c>();
    
    // For displaying label into select mapping dialog box.
    private List<BRMappingLabel> lstMappingLabel = new List<BRMappingLabel>(); 
    
    // for required fields
    private String requiredFields;
    
    public String getRequiredFields() {
      return requiredFields;
    }
    public List<BRMappingLabel> getLstMappingLabel() {
      return lstMappingLabel;
    }
    
    public List<SYSBRMapping__c> getMapDataListTemp (){
        return this.mapdataListTemp ;
    }
    public void setMapDataListTemp (List<SYSBRMapping__c> mapdataListTemp ){
        this.mapdataListTemp = mapdataListTemp ;
    }
    public void addMapping() {
        SYSBRMapping__c addThis = new SYSBRMapping__c();
        addThis.FieldName__c = mappingfields;
        addThis.Value__c = fieldValue; 
        mapdataListTemp.add(addThis);  
        
        // for displaying label in data grid of select mapping dialog box
        BRMappingLabel mappingLabel = new BRMappingLabel();
        mappingLabel.setFieldLabel(fieldAPILabelMap.get(mappingfields));
        mappingLabel.setValue(fieldValue);
        lstMappingLabel.add(mappingLabel);
    }
    public void removeMapping() {
        mapdataListTemp.remove(mapdataListTemp.size()-1); // Removes last element from list
        lstMappingLabel.remove(lstMappingLabel.size()-1); // Removes last element from list
    }
    public void saveMapping() {
        System.debug('ActionMapping Pages map ' + mapdataListTemp);
        // insert mapdataListTemp;
        mappingCount++;
        mappingMapTemp.put(mappingCount,mapdataListTemp);
    }

    // For dynamically rendering widgets on mapping page
    public List<SelectOption> getBooleanItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('true','True')); 
        options.add(new SelectOption('false','False')); 
        return options; 
    }
        
    public List<SelectOption> getListItems() {
        List<SelectOption> options = new List<SelectOption>();
       
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        System.debug('Action Module in  GetListItem for populating picklist values' + actionModule);
        if(actionModule !=null && actionModule.length()>0){
            Schema.SObjectType s1 = gd.get(actionModule);
            Map<String, Schema.SObjectField> M = s1.getDescribe().fields.getMap();
                List <Schema.PicklistEntry> lst = M.get(mappingfields).getDescribe().getPicklistValues();
                for(Schema.PicklistEntry entry : lst) {
                        options.add(new SelectOption(entry.getValue(),entry.getLabel()));
                }   
        }
        return options;
    }
    // Dynamically rendered widget based on data type of field
    public PageReference changeVisibility() {
        System.debug('mapping : ' + mappingfields);
        Schema.DisplayType fieldType = fieldLabelTypeMap.get(mappingfields);
        System.debug('Data type : ' + fieldType);
        System.debug('FieldNameTypeMap : ' + fieldLabelTypeMap);
        
        if(fieldType == Schema.DisplayType.STRING || fieldType == Schema.DisplayType.CURRENCY || fieldType == Schema.DisplayType.DOUBLE  ||
           fieldType == Schema.DisplayType.EMAIL || fieldType == Schema.DisplayType.ID || fieldType == Schema.DisplayType.INTEGER ||
           fieldType == Schema.DisplayType.PHONE || fieldType == Schema.DisplayType.URL) {
              setInputTxtvisibility('true');            
              setInputTxtAreaVisibility('false');
              setRadioBtnVisibility('false');
              setPicklistVisibility('false');
        }
        else if(fieldType == Schema.DisplayType.BOOLEAN) {
              setInputTxtvisibility('false');            
              setInputTxtAreaVisibility('false');
              setRadioBtnVisibility('true');
              setPicklistVisibility('false');
        }
        else if(fieldType == Schema.DisplayType.TEXTAREA) {
              setInputTxtvisibility('false');            
              setInputTxtAreaVisibility('true');
              setRadioBtnVisibility('false');
              setPicklistVisibility('false');
        }
        else if(fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST) {
              setInputTxtvisibility('false');            
              setInputTxtAreaVisibility('false');
              setRadioBtnVisibility('false');
              setPicklistVisibility('true');
        }
        return null;
 
  }
}
			                            	