public class TemplateController {

    public String messageString {get; set;}
    SYSTemplate__c template;
    SYSTemplateLink__c templateLink;
    List<SYSTemplate__c> templateList;
    SYSTemplateFieldInfo__c sysTemplateFieldInfo;
    List<SYSTemplateFieldInfo__c> listSYSTemplateFieldInfo;
    SYSTemplateAccess__c templateAccess;
    List<SYSTemplateAccess__c> templateAccessList;
    TemplateMappingFields tmplateMapping;
    String popUpId;
    String savedId;
  String detailSectionFor ='';
   
    public List<String> listOutputFields=new List<String>();
    public String queryString;
    public DriverAccess objDriverAccess = new DriverAccess();
    public ConditionBuilder objConditionBuilder = new ConditionBuilder();
    public String templateId{get;set;}
    public String parentTemplateId{get;set;}
    public List<String> fieldLabels{get; set;}
    public String strFieldLabel{get; set;}
    public String fieldValue {get; set;}
    public List<SelectOption> fieldOptions {get; set;}
    public Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>();
    
    public List<TemplateMappingFields> lstMappingField = new List<TemplateMappingFields>(); 
     
    // member variables for rendering widgets dynamically based on data type of fields
    public Boolean inputTxtVisibility ;
    public Boolean inputTxtDisable ;
    public Boolean inputTxtAreaVisibility ;
    public Boolean radioBtnVisibility ;
    public Boolean lookUpVisibility ;
    public Boolean picklistVisibility ;
    public Boolean updateButtonVisibility;
    public Boolean addButtonVisibility;
    public Boolean removeButtonVisibility;
    Map<String, Schema.SObjectType> globalDescribeMap;
    private Map<String,Schema.DisplayType> fieldLabelTypeMap;
    private Map<String, String> fieldAPILabelMap;
    String selectedModule;
    
    String columnName='Name';
    String direction= 'ASC'; 
    List<SelectOption> listItems = new List<SelectOption>();
    public String tempString {get; set;}
    
    String listData;
      
    String buttonLebel {get; set;}
    public String selectedProfiles{get; set;}
        
    /* for select profile MultiSelector   */
    List<String> profileLabelList;
    List<String> profileNameList;
    List<String> fieldLabelList;
    List<String> fieldNameList;
   
    
    public SYSTemplate__c getTemplate(){
        return template;
    }
    
    public String getButtonLebel() {
        return null;
    }
    
    public String getPopUpId() {
        return this.popUpId;
    }
    
  public String getDetailSectionFor() {
        return this.detailSectionFor;
    }
    
    public void setDetailSectionFor(String detailSectionFor) {
        this.detailSectionFor = detailSectionFor;
    }
  
    public String getSavedId() {
        return this.savedId;
    }
    
    public void setSavedId(String savedId) {
        this.savedId = savedId;
    }
    
    public void setPopUpId(String popUpId) {        
        if(popUpId == 'FKAssigned To' || popUpId == 'Assigned To'){
          this.popUpId = 'Staff';
        }else{
          this.popUpId = popUpId;
        }
    }
    
    public TemplateController(){
        
        template= new SYSTemplate__c();
        listSYSTemplateFieldInfo = new List<SYSTemplateFieldInfo__c>();
        templateAccess = new SYSTemplateAccess__c();
        templateAccessList = new    List<SYSTemplateAccess__c> ();
        selectedProfiles = '';
        tmplateMapping= new TemplateMappingFields();
        templateId = Apexpages.currentPage().getParameters().get('id');
        parentTemplateId = Apexpages.currentPage().getParameters().get('IncidentTemplate__CId');
        columnName = ApexPages.CurrentPage().getParameters().get('columnField');
        direction = ApexPages.CurrentPage().getParameters().get('direction');
        String copyId=Apexpages.currentPage().getParameters().get('copyId');
        buttonLebel='Add';
        globalDescribeMap = globalDescribeMap = Schema.getGlobalDescribe();
        
        fieldLabels= new List<String>();
        if((templateId != null && templateId != '') || (copyId !=null && copyId != '')) {
            listOutputFields.add('Id');
            listOutputFields.add('Name');
            listOutputFields.add('description__c');
            listOutputFields.add('orderNumber__c');
            listOutputFields.add('inactive__c');
            listOutputFields.add('displayInSelfService__c');
            listOutputFields.add('templateFor__c');
            listOutputFields.add('allProfile__c');
            listOutputFields.add('templateData__c');
            
            if((copyId !=null && copyId != '')){
                queryString='Id =' +'\''+copyId+'\'';  
                                
             }else {
                queryString='Id =' +'\''+templateId+'\'';  
             }
                             
             objConditionBuilder.setCondition(queryString);
         
            templateList = (List<SYSTemplate__c>) objDriverAccess.selectObjects(template,listOutputFields,objConditionBuilder,null);    
             if((templateList.size() > 0) && (copyId !=null && copyId != '')){
                    template = templateList[0];
                    copy();
                    
             }else if(templateList.size() > 0){
                    template = templateList[0];
                    String moduleName;
                    Map<String, Schema.SObjectField> sobjMap; 
                    
                    if( template.templateFor__c != null && template.templateFor__c != '' ){
                        
                        moduleName= template.templateFor__c +'__c';
                        detailSectionFor = template.templateFor__c+'Template__c';
                sobjMap = getSobjFieldMap( moduleName ); 
                    }
                                                            
                    listOutputFields.clear();
                    listOutputFields.add('Id');
                    listOutputFields.add('Name');
                    listOutputFields.add('fieldName__c');
                    listOutputFields.add('fieldValue__c');
                    listOutputFields.add('FKSYSTemplate__c');
                    
                    queryString='FKSYSTemplate__c =' +'\''+templateId+'\'';
                    objConditionBuilder.setCondition(queryString);
                    listSYSTemplateFieldInfo = (List<SYSTemplateFieldInfo__c>) objDriverAccess.selectObjects(new SYSTemplateFieldInfo__c(),listOutputFields,objConditionBuilder,null);
                    if(listSYSTemplateFieldInfo.size() > 0){
                        for(SYSTemplateFieldInfo__c sysTemplateFieldInfo : listSYSTemplateFieldInfo){
                            tmplateMapping = new TemplateMappingFields();
                            tmplateMapping.setFieldName(sysTemplateFieldInfo.fieldName__c);
                            tmplateMapping.setValue(sysTemplateFieldInfo.fieldValue__c); 
                            tmplateMapping.setTemplateFieldInfoId(sysTemplateFieldInfo.Id);
                            Schema.SObjectField apiName = sobjMap.get(sysTemplateFieldInfo.fieldName__c);
                            String localFieldLabel = apiName.getDescribe().getLabel();
                            if(localFieldLabel.contains('FK')){
                              localFieldLabel = localFieldLabel.substring(2,localFieldLabel.length());
                            }
                            tmplateMapping.setFieldLabel(localFieldLabel);
                            lstMappingField.add(tmplateMapping);
                        }
                    }
                    
                    /* *** For display Selected Profile For specific Template *** */
                                                            
                    listOutputFields.clear();
                    listOutputFields.add('Id');
                    listOutputFields.add('Name');
                    listOutputFields.add('profile__c');
                    listOutputFields.add('templateId__c');
                     
                    queryString='templateId__c =' +'\''+template.Id+'\'';
                    objConditionBuilder.setCondition(queryString);
                    templateAccessList = (List<SYSTemplateAccess__c>) objDriverAccess.selectObjects(new SYSTemplateAccess__c(),listOutputFields,objConditionBuilder,null);
                    if(templateAccesslist.size()> 0){
                        
                        for(SYSTemplateAccess__c sysTemplateAccess : templateAccessList){
                            selectedProfiles = selectedProfiles + sysTemplateAccess.profile__c +',';
                    
              }
                
                    }
                     
             }       
        }else{
            template.templateData__c=' ';
        }
        if(parentTemplateId != null && parentTemplateId != ''){
          template.templateFor__c = 'Task';
        }
        
        inputTxtVisibility = true;
        inputTxtAreaVisibility = false;
        radioBtnVisibility = false; 
        lookUpVisibility = false;    
        picklistVisibility = false;
        addButtonVisibility= true;
        updateButtonVisibility= false;
        removeButtonVisibility= true;
        fieldLabelTypeMap = new Map<String,Schema.DisplayType>();
        
        //List<SelectOption> flist= getFieldItems();
    }
    
  public PageReference dummy() {
    return null;
  }    
  
    public Boolean getInputTxtDisable() {
        return inputTxtDisable;
    }
    public void setInputTxtDisable(Boolean inputTxtDisable) {
        this.inputTxtDisable = inputTxtDisable;
    }
    public Boolean getInputTxtvisibility() {
        return inputTxtVisibility;
    }
    public void setInputTxtvisibility(Boolean str) {
        inputTxtVisibility = str;
    }    
    public Boolean getInputTxtAreaVisibility () {
        return inputTxtAreaVisibility ;
    }
    public void setInputTxtAreaVisibility (Boolean str) {
        inputTxtAreaVisibility = str;
    }
    public Boolean getRadioBtnVisibility() {
        return radioBtnVisibility ;
    }
    public void setRadioBtnVisibility(Boolean str) {
        radioBtnVisibility = str;
    }    
    public Boolean getLookUpVisibility() {
        return lookUpVisibility ;
    }
    public void setLookUpVisibility(Boolean lookUpVisibility) {
        this.lookUpVisibility = lookUpVisibility;
    }    
    public Boolean getPicklistVisibility () {
        return picklistVisibility ;
    }
    public void setPicklistVisibility (Boolean str) {
        picklistVisibility = str;
    }
     public Boolean getAddButtonVisibility () {
        return addButtonVisibility ;
    }
    public void setAddButtonVisibility (Boolean str) {
        addButtonVisibility = str;
    }
     public Boolean getUpdateButtonVisibility () {
        return updateButtonVisibility ;
    }
    public void setUpdateButtonVisibility (Boolean str) {
        updateButtonVisibility = str;
    }
   
    public Boolean getRemoveButtonVisibility () {
        return removeButtonVisibility ;
    }
    public void setRemoveButtonVisibility (Boolean str) {
        removeButtonVisibility = str;
    }
    
    public void setListData(String str) {
        listData = str;
    } 
    public void setSelectedModule (String selectedModule) {
        this.selectedModule = selectedModule;
    }
    
    public String getSelectedModule() {
       return this.selectedModule;
    }
    
    public List<String> getProfileLabelList() {
        return this.profileLabelList;
    }
    
    public void setProfileLabelList(List<String> profileLabelList) {
        this.profileLabelList = profileLabelList;
    }
    
    public List<String> getProfileNameList() {
        return this.profileNameList;
    }
    
    public void setProfileNameList(List<String> profileNameList) {
        this.profileNameList = profileNameList;
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
    
    
    /* ***************************************** */
    
    /* Formate data in Javascript Array Format for display in grid */
    public String getListData() {
        
        listData = '';
        if(lstMappingField.size() > 0)
        {
            for(TemplateMappingFields tmplateMapping :lstMappingField)
                {
                        
                        if(listData == null || listData ==''){
                            listData ='[\''+tmplateMapping.getFieldLabel()+'\',\''+tmplateMapping.getValue()+'\']';
                        }else{
                            listData =listData+',[\''+tmplateMapping.getFieldLabel()+'\',\''+tmplateMapping.getValue()+'\']';
                        }
                 }
            
        }
        return listData;
    }
    
        
    public List<TemplateMappingFields> getLstMappingLabel() {
        return lstMappingField;
            
    }
    
    public  Map<String, Schema.SObjectField>  getSobjFieldMap( String moduleName ){
        
         Schema.SObjectType sobj = globalDescribeMap.get(moduleName);
          Map<String, Schema.SObjectField> sobjMap = sobj.getDescribe().fields.getMap();
        
        return sobjMap;
    }
    
    /* fetch Fields from selcted module and strore it in SelectList */
    
    public List<SelectOption> getFieldItems(){
        fieldOptions = new List<SelectOption>();
        fieldLabels= new List<String>();
            
        if(template.templateFor__c!= null && template.templateFor__c != ''){
            String moduleName=template.templateFor__c;
      detailSectionFor = moduleName+'Template__c';
      DetailSectionCont detailSectionCont = new DetailSectionCont();
      detailSectionCont.strObject = detailSectionFor;
      detailSectionCont.produceData();
      detailSectionCont.strValue = templateId;
      moduleName=moduleName+'__c';
            
            
            if(moduleName !=null && moduleName != ''){
                
                /*if(selectedModule != moduleName){
                    lstMappingField.clear();
                    selectedModule= moduleName;
                }*/
                
                Map<String, Schema.SObjectField> sobjMap = getSobjFieldMap( moduleName );
                for(String str : sobjMap.keySet()) {
                    Schema.SObjectField apiName = sobjMap.get(str);
                    strFieldLabel =  apiName.getDescribe().getLabel();
                    if(apiName.getDescribe().isCreateable() == true && apiName.getDescribe().getSoapType() != Schema.SoapType.DATETIME
                            && !strFieldLabel.endsWith('ID') && !strFieldLabel.endsWith('Id') && apiName.getDescribe().getLocalName() != 'FKTemplate__c'
                            && apiName.getDescribe().getLocalName() != 'status__c' && apiName.getDescribe().getLocalName() != 'CLOrganizationName__c'){
                        if(strFieldLabel.contains('FK')){
                          strFieldLabel = strFieldLabel.substring(2,strFieldLabel.length()); 
                        }
                        fieldLabelTypeMap.put(strFieldLabel, apiName.getDescribe().getType());
                        fieldMap.put(strFieldLabel,apiName);
                        fieldLabels.add(strFieldLabel);
                        fieldOptions.add(new SelectOption(strFieldLabel , strFieldLabel));
                    }
                 }
                 sortList(fieldOptions);
             }
         }else{
       detailSectionFor ='';
     }
        return fieldOptions;
    }
    
    public void sortList(List<SelectOption> toBeSortedList){
      List<SelectOption> selectOptionList = new List<Selectoption>();
      selectOptionList.add(new SelectOption('Select' , 'Select'));
      List<String> stringList = new List<String>();
      if(toBeSortedList.size() > 0){
        for(Selectoption selectOption : toBeSortedList){
          stringList.add(selectOption.getLabel());
        }
      }
      stringList.sort();      
      if(toBeSortedList.size() > 0){
        for(String optionString : stringList){
          for(SelectOption selectOption : toBeSortedList){            
            if(optionString == selectOption.getLabel()){
              selectOptionList.add(new Selectoption(selectOption.getLabel(), selectOption.getValue()));
            }
          }
        }
      }
      fieldOptions.clear();
      fieldOptions = selectOptionList;
    }
     
    
    public PageReference save() {
        
        try{
            if(template.templateData__c == null){
                template.templateData__c='';
            }
            
            if(template.Id == null ){
                templateId = objDriverAccess.insertObject(template , null);
                
                if(lstMappingField.size()>0){                   
                    for(TemplateMappingFields tmplateMapping :lstMappingField){
                        if(tmplateMapping != null && templateId != '' 
                                && tmplateMapping.getFieldName() != '' && tmplateMapping.getValue() != ''){                     
                            sysTemplateFieldInfo = new SYSTemplateFieldInfo__c();
                            sysTemplateFieldInfo.FKSYSTemplate__c = template.Id;
                            sysTemplateFieldInfo.fieldName__c = tmplateMapping.getFieldName();
                            sysTemplateFieldInfo.fieldValue__c = tmplateMapping.getValue();
                             //objDriverAccess.insertObject(sysTemplateFieldInfo , null);  
                            objDriverAccess.insertObject(sysTemplateFieldInfo , null);
              tmplateMapping.setTemplateFieldInfoId(sysTemplateFieldInfo.Id);                       
                        }   
                     }
                }
                
                templateLink = new SYSTemplateLink__c();
                if(parentTemplateId != null && parentTemplateId != '' && templateId != null && templateId != ''){
                  //System.debug('@@ # parentTemplateId : '+parentTemplateId +' @@ # templateId : '+templateId);
                  templateLink.parentTemplateId__c = parentTemplateId;
                  templateLink.linkedTemplateId__c = templateId;
                  objDriverAccess.insertObject(templateLink , null);
                }
                
                
                
            }else{
                objDriverAccess.updateObject(template ,null, null);
                
                if(lstMappingField.size()>0){                   
                    for(TemplateMappingFields tmplateMapping :lstMappingField){
                        
                        if(tmplateMapping.getTemplateFieldInfoId()== null || tmplateMapping.getTemplateFieldInfoId()== ''){
                            sysTemplateFieldInfo = new SYSTemplateFieldInfo__c();
                            sysTemplateFieldInfo.FKSYSTemplate__c = template.Id;
                            sysTemplateFieldInfo.fieldName__c = tmplateMapping.getFieldName();
                            sysTemplateFieldInfo.fieldValue__c = tmplateMapping.getValue();
                            //objDriverAccess.insertObject(sysTemplateFieldInfo , null);  
              objDriverAccess.insertObject(sysTemplateFieldInfo , null);  
                             tmplateMapping.setTemplateFieldInfoId(sysTemplateFieldInfo.Id);
                           
                        }else if(tmplateMapping.getTemplateFieldInfoId()!= null && tmplateMapping.getTemplateFieldInfoId()!= ''){
                                
                                for(SYSTemplateFieldInfo__c templateFieldInfo :listSYSTemplateFieldInfo){
                                    
                                    if(templateFieldInfo.fieldName__c == tmplateMapping.getFieldName()
                                         && templateFieldInfo.fieldValue__c  != tmplateMapping.getValue()){
                                        
                                        templateFieldInfo.fieldValue__c = tmplateMapping.getValue();
                                        objDriverAccess.updateObject(templateFieldInfo ,null, null);     
                                     }
                                }               
                                
                        }   
                    }
                }
            }
            
            
            
             messageString = validationHelper.getSavedMessage();  
         }catch(Exception e){
             if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
              } else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
              } 
        
         }
        
            
        return null;    
    }
    
    /* Selected FeildLabel and Value added in lstMappingField list */
    public PageReference addData(){
        try{
            tmplateMapping= new TemplateMappingFields();            
            if(strFieldLabel!= null || strFieldLabel != ''){
                
                tmplateMapping.setFieldLabel(strFieldLabel);
                Schema.SObjectField fieldAPIName = fieldMap.get(strFieldLabel);
                String strName =''+fieldAPIName+'';
                tmplateMapping.setFieldName(strName);
            }
            System.debug('@@@@@@@@@@ fieldValue'+ fieldValue);
            if( fieldValue != null && fieldValue != ''){
                
                tmplateMapping.setValue(fieldValue);
                lstMappingField.add(tmplateMapping);
            
                fieldValue='';
            
                setInputTxtvisibility(true);            
              setInputTxtAreaVisibility(false);
              setRadioBtnVisibility(false);
              setPicklistVisibility(false);
              setLookUpVisibility(false);
               setInputTxtDisable(false);
                setAddButtonVisibility(true);
                setUpdateButtonVisibility(false);
                messageString ='';
            }else{
                messageString ='Please enter value for '+ strFieldLabel;
            }
            
            
            
        }catch(Exception e){
             if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
              } else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
              } 
        
         }
        return null;
    }
    
    public PageReference updateData() {
        
        if(lstMappingField.size() > 0)
        {
            for(TemplateMappingFields tmplateMapping :lstMappingField)
            {   
                if(tmplateMapping.getFieldLabel() == strFieldLabel ){
                    tmplateMapping.setValue(fieldValue); 
                    
                }
             }  
        }
        
   
        return null;
    }
    
    public PageReference removeData() {
        
        if(lstMappingField.size() > 0)
        {   Integer count=0;
            for(TemplateMappingFields tmplateMapping :lstMappingField)
            {   
                if(tmplateMapping.getFieldLabel() == strFieldLabel && tmplateMapping.getValue() == fieldValue)
                    break;
                else
                    count++;
             }  
             
             
             if(listSYSTemplateFieldInfo.size()>0){
                  TemplateMappingFields tmplateMapping = lstMappingField.get(count);
                 for(SYSTemplateFieldInfo__c templateFieldInfo :listSYSTemplateFieldInfo){
                                        
                    if(templateFieldInfo.Id == tmplateMapping.getTemplateFieldInfoId()){
                          objConditionBuilder = new ConditionBuilder();
                          queryString='Id =' +'\''+templateFieldInfo.Id+'\'';  
                          objConditionBuilder.setCondition(queryString);
                          objDriverAccess.deleteObject(templateFieldInfo, objConditionBuilder, null);               
                    }
                }
             }  
             
             lstMappingField.remove(count);
        }
        fieldValue='';
        setInputTxtvisibility(true);            
        setInputTxtAreaVisibility(false);
        setRadioBtnVisibility(false);
        setPicklistVisibility(false);
        setLookUpVisibility(false);
        setInputTxtDisable(false);
        setAddButtonVisibility(true);
        setUpdateButtonVisibility(false);        
        setRemoveButtonVisibility(true);
        
        
        return null;
    }


    
    /* On row click of grid data should be auto papulate to fieldLabel selectList and value Textbox */
   
   public PageReference handleRowClick() {
        String label = System.currentPageReference().getParameters().get('paramId');
        strFieldLabel=label;
        if(lstMappingField.size() > 0)
        {   
            for(TemplateMappingFields tmplateMapping :lstMappingField)
            {
                if(tmplateMapping.getFieldLabel() == label ){
                    
                    fieldValue=tmplateMapping.getValue(); 
                }
             }  
        }
        
        // Change Visibility of Widget after click on record 
        
        Schema.DisplayType fieldType = fieldLabelTypeMap.get(strFieldLabel);
        if(fieldType == Schema.DisplayType.STRING || fieldType == Schema.DisplayType.CURRENCY || fieldType == Schema.DisplayType.DOUBLE  ||
           fieldType == Schema.DisplayType.EMAIL || fieldType == Schema.DisplayType.ID || fieldType == Schema.DisplayType.INTEGER ||
           fieldType == Schema.DisplayType.PHONE || fieldType == Schema.DisplayType.URL) {
              setInputTxtvisibility(true);            
              setInputTxtAreaVisibility(false);
              setLookUpVisibility(false);
              setInputTxtDisable(false);
              setRadioBtnVisibility(false);
              setPicklistVisibility(false);
       }
        else if(fieldType == Schema.DisplayType.BOOLEAN) {
              setInputTxtvisibility(false);            
              setInputTxtAreaVisibility(false);
              setLookUpVisibility(false);
              setRadioBtnVisibility(true);
              setInputTxtDisable(false);
              setPicklistVisibility(false);
        }
        else if(fieldType == Schema.DisplayType.TEXTAREA) {
              setInputTxtvisibility(false);            
              setInputTxtAreaVisibility(true);
              setLookUpVisibility(false);
              setRadioBtnVisibility(false);
              setInputTxtDisable(false);
              setPicklistVisibility(false);
        }
        else if(fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST) {
              setInputTxtvisibility(false);            
              setInputTxtAreaVisibility(false);
              setLookUpVisibility(false);
              setRadioBtnVisibility(false);
              setInputTxtDisable(false);
              setPicklistVisibility(true);
        }else if(fieldType == Schema.DisplayType.Reference) {
              setInputTxtvisibility(true);
              setLookUpVisibility(true);
              setPopUpId(strFieldLabel);  
              setInputTxtDisable(true);     
              setInputTxtAreaVisibility(false);
              setRadioBtnVisibility(false);
              setPicklistVisibility(false);
        }
        
        setAddButtonVisibility(false);
        setUpdateButtonVisibility(true);
        setRemoveButtonVisibility(false);
        
        if( fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.MULTIPICKLIST){
          if(listItems.size() == 0)
            listItems = addListOptions(); 
            
        }
        
        return null;
    }
    
    
      
     /* For dynamically rendering widgets on mapping page */
    public List<SelectOption> getBooleanItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('true','True')); 
        options.add(new SelectOption('false','False')); 
        return options; 
    }
    
    /* For dynamically fetchIng Picklist Values In List<SelectOption> */ 
     public List<SelectOption> getListItems() {
        
        if(listItems.size() == 0)
            listItems = addListOptions();    
            
       return listItems;
    }
    /* For Adding PickList values in List<SelectOption> */
    public List<SelectOption> addListOptions(){
        List<SelectOption> options = new List<SelectOption>();
        
        if(template.templateFor__c!= null && template.templateFor__c != ''){
        
            String moduleName=template.templateFor__c;
          detailSectionFor = moduleName+'Template__c';
            moduleName=moduleName+'__c';
            
            if(moduleName !=null && moduleName != ''){
                
                Map<String, Schema.SObjectField> sobjMap = getSobjFieldMap( moduleName ); 
                Schema.SObjectField fieldAPIName = fieldMap.get(strFieldLabel);
               
                Schema.DescribeFieldResult result =fieldAPIName.getDescribe();
                List <Schema.PicklistEntry> lst =result.getPicklistValues();
                for(Schema.PicklistEntry entry : lst) {
                    options.add(new SelectOption(entry.getValue(),entry.getValue()));
                }   
             }
        }
        return options;
    
    } 
    
    /* For Change widget visibility adter selecting Field */
    public PageReference changeVisibility() {
         Schema.DisplayType displayType = fieldLabelTypeMap.get(strFieldLabel);
       
        
        if(displayType == Schema.DisplayType.STRING || displayType == Schema.DisplayType.CURRENCY || displayType == Schema.DisplayType.DOUBLE  ||
           displayType == Schema.DisplayType.EMAIL || displayType == Schema.DisplayType.ID || displayType == Schema.DisplayType.INTEGER ||
           displayType == Schema.DisplayType.PHONE || displayType == Schema.DisplayType.URL) {
              setInputTxtvisibility(true);
              setLookUpVisibility(false);
              setInputTxtDisable(false);            
              setInputTxtAreaVisibility(false);
              setRadioBtnVisibility(false);
              setPicklistVisibility(false);
        }
        else if(displayType == Schema.DisplayType.BOOLEAN) {
              setInputTxtvisibility(false);
              setLookUpVisibility(false);
              setInputTxtDisable(false);            
              setInputTxtAreaVisibility(false);
              setRadioBtnVisibility(true);
              setPicklistVisibility(false);
        }
        else if(displayType == Schema.DisplayType.TEXTAREA) {
              setInputTxtvisibility(false);
              setInputTxtDisable(false);
              setLookUpVisibility(false);            
              setInputTxtAreaVisibility(true);
              setRadioBtnVisibility(false);
              setPicklistVisibility(false);
        }
        else if(displayType == Schema.DisplayType.PICKLIST || displayType == Schema.DisplayType.MULTIPICKLIST) {
              setInputTxtvisibility(false);
              setLookUpVisibility(false);
              setInputTxtDisable(false);            
              setInputTxtAreaVisibility(false);
              setRadioBtnVisibility(false);
              setPicklistVisibility(true);
        }else if(displayType == Schema.DisplayType.Reference) {
              setInputTxtvisibility(true);
              setInputTxtDisable(true);
              setLookUpVisibility(true);
              setPopUpId(strFieldLabel);       
              setInputTxtAreaVisibility(false);
              setRadioBtnVisibility(false);
              setPicklistVisibility(false);
        }
        fieldValue='';
        setAddButtonVisibility(true);
        setUpdateButtonVisibility(false);
        setRemoveButtonVisibility(true);
        
        if(lstMappingField.size() > 0){
            for(TemplateMappingFields tmplateMapping :lstMappingField){
                 if(strFieldLabel == tmplateMapping.getFieldLabel()){
                    fieldValue=tmplateMapping.getValue();
                    setAddButtonVisibility(false);
                    setUpdateButtonVisibility(true);
                     setRemoveButtonVisibility(false);
                    break;
                 }
            }
        }
       
        
        return null;
    }
      
   public PageReference newTemplate() {
        template= new SYSTemplate__c();
        
        return null;
    }
    
    
    public PageReference deleteTemplate(){
      List<String> outPutFields = new List<String>();
      ConditionBuilder objConditionBuilder = new ConditionBuilder();
      String queryString = '';            
             if(template !=null && template.Id !=null){                
                
                if(parentTemplateId != null && parentTemplateId != '' && templateId != null && templateId != ''){                  
                  outPutFields.clear();
                  outPutFields.add('Name');
                  outPutFields.add('parentTemplateId__c');
                  outPutFields.add('linkedTemplateId__c');
                  queryString = 'parentTemplateId__c =' +'\''+ parentTemplateId+'\' AND linkedTemplateId__c ='+'\''+template.Id + '\'' ;                  
                  objConditionBuilder.setCondition(queryString);
                  List<SYSTemplateLink__c>  sysTemplateLinkList = (List<SYSTemplateLink__c>) objDriverAccess.selectObjects(new SYSTemplateLink__c(), outPutFields, objConditionBuilder, null);
                  if(sysTemplateLinkList.size() > 0){
                    objDriverAccess.deleteObject(sysTemplateLinkList[0], null, null);
                  }                  
                }
                
                if(templateId != null && templateId != ''){
          outPutFields.clear();
                  outPutFields.add('Name');
                  outPutFields.add('parentTemplateId__c');
                  outPutFields.add('linkedTemplateId__c');
                  queryString = 'parentTemplateId__c =' +'\''+ template.Id+'\'';
                  System.debug(queryString);                  
                  objConditionBuilder.setCondition(queryString);
                  List<SYSTemplateLink__c>  sysTemplateLinkList = (List<SYSTemplateLink__c>) objDriverAccess.selectObjects(new SYSTemplateLink__c(), outPutFields, objConditionBuilder, null);
                  if(sysTemplateLinkList.size() > 0){
                    objDriverAccess.deleteObject(sysTemplateLinkList,null,null);                    
                  }
                }
                
                queryString='Id =' +'\''+template.Id+'\'';  
                objConditionBuilder.setCondition(queryString);
                objDriverAccess.deleteObject(template, objConditionBuilder, null);
            }
            return null;
    }
       
    public void copy(){     
            SYSTemplate__c temptemplate= template.clone(false,true);
            template = tempTemplate;
            template.name =null;
    }
    
    public Pagereference clear(){     
            template = null;
            template = new SYSTemplate__c();
            lstMappingField.clear();
            return null;
    }
    
    public Pagereference reset(){     
            
        template = new SYSTemplate__c();
        objDriverAccess = new DriverAccess();
        objConditionBuilder = new ConditionBuilder();
         
        if((templateId != null && templateId != '')){
            
            listOutputFields.clear();
            listOutputFields.add('Id');
            listOutputFields.add('Name');
            listOutputFields.add('description__c');
            listOutputFields.add('orderNumber__c');
            listOutputFields.add('inactive__c');
            listOutputFields.add('displayInSelfService__c');
            listOutputFields.add('templateFor__c');
            listOutputFields.add('allProfile__c');
            listOutputFields.add('templateData__c');
            String queryString = '';
            queryString='Id =' +'\''+templateId+'\'';  
             
             objConditionBuilder.setCondition(queryString);
             templateList = (List<SYSTemplate__c>) objDriverAccess.selectObjects(template,listOutputFields,objConditionBuilder,null);    
             if(templateList.size() > 0){
                    template = templateList[0];
                    
                if(template.templateData__c != null && template.templateData__c != '' ){
                    String tempData=template.templateData__c;
                    String[] strArr= tempData.split(':');
                    String strValue;
                    String strFeildName;
                    
                    
                    for(String strTemp :strArr){
                        TemplateMappingFields tmplateMapping= new TemplateMappingFields();
                        Integer iStart = strTemp.indexOf('=');
                        strValue = strTemp.subString(iStart+1, strTemp.length());
                        tmplateMapping.setValue(strValue);
                        strFeildName=strTemp.subString(0,iStart);
                        Integer startIndex = strFeildName.indexOf('$');
                        String strLabel =strFeildName.subString(0,startIndex);
                        strFeildName=strFeildName.subString(startIndex+1, strFeildName.length());
                        tmplateMapping.setFieldLabel(strLabel);
                        
                        tmplateMapping.setFieldName(strFeildName);
                        
                        lstMappingField.add(tmplateMapping);
                    }  
                 }
             }else {
                    template = new SYSTemplate__c();
                    
             }
        }else{
          lstMappingField.clear();
        }
    
            return null;
    }
    
    
     public Pagereference previousBtnHandler(){
        if(template!=null){
            CommonUI commonUiObj=new CommonUI();
            template = (SYSTemplate__c)commonUiObj.getSobject(template, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(template!=null){
            CommonUI commonUiObj=new CommonUI();
            template = (SYSTemplate__c)commonUiObj.getSobject(template, tempString, columnName, direction, 'next');
        }
        return null;
    }
    
    public Pagereference assignReferenceToTextField(){
        listOutputFields.clear();
        listOutputFields.add('Id');
        listOutputFields.add('Name');
        
        queryString='Id =' +'\''+savedId+'\'';
        objConditionBuilder.setCondition(queryString);
        String sobjString = popUpId + '__c';
        Schema.SObjectType sObjectTypeToken = null;
        if(sobjString == 'Staff__c'){
          sObjectTypeToken = globalDescribeMap.get('User');
        }else{
          sObjectTypeToken = globalDescribeMap.get(sobjString);
        }        
        SObject sObjectInstance = sObjectTypeToken.newSObject();
        List<Sobject> sobjectList = objDriverAccess.selectObjects(sObjectInstance, listOutputFields, objConditionBuilder, null);
        
        fieldValue = (String)sobjectList[0].get('Name');
        return null;
    }
      
    /* %%%%%%%%%%%%%%%%%%%%%%%%%*/ 
    
    // fetching selected profiles for multiselector profile
    public void FetchFieldItems() {
         fieldLabelList = new List<String>();
         fieldNameList = new List<String>();
         profileLabelList = new List<String>();
         profileNameList = new List<String>();
         List<String> profiles;
         if(selectedProfiles == null || selectedProfiles == ''){
            profiles= new  List<String>();
         }else{
            profiles= selectedProfiles.split(',');
         }
         List<Profile> listProfile=[Select p.Name From Profile p];
         Map<String,Profile> mapPro = new Map<String,Profile>();
         
         for(Profile profile:listProfile){
            mapPro.put(profile.name,profile);
         }
         
         for(String strTemp:profiles){
            integer i=0;
            Profile profile = mapPro.get(strTemp);
            if(profile!=null && strTemp.equals(profile.Name)){
                fieldNameList.add(profile.name);
                fieldLabelList.add(profile.name);
                    
            }
         }
            
         for(Profile profile:listProfile){
            Boolean isSelected =false;         
            for(String strTemp:profiles){   
                Profile tempProfile =mapPro.get(strTemp);
                if(tempProfile == profile){
                    isSelected=true;
                    break;
                }
            }
            
            if(!isSelected){
                profileNameList.add(profile.name);
                profileLabelList.add(profile.name);
            }
         }
      
    }
    
    // update the broadcast with selected values.
    public Pagereference assignSelectedProfiles() {
        if(template.Id != null){
            String[] strProfiles = selectedProfiles.split(',');
            listOutputFields.clear();
            listOutputFields.add('Id');
            listOutputFields.add('Name');
            listOutputFields.add('profile__c');
            listOutputFields.add('templateId__c');
             
            queryString='templateId__c =' +'\''+template.Id+'\'';
            objConditionBuilder.setCondition(queryString);
            templateAccessList = (List<SYSTemplateAccess__c>) objDriverAccess.selectObjects(new SYSTemplateAccess__c(),listOutputFields,objConditionBuilder,null);
      
            if(strProfiles.size() >0){
                if(templateAccesslist.size()> 0){
                    for (String strTemp : strProfiles){
                        Boolean isSelected=false;
                        for(SYSTemplateAccess__c sysTemplateAccess : templateAccessList){
                            if( strTemp.equals(sysTemplateAccess.profile__c) ){
                                isSelected =true;
                                break;
                            }
                        }
                        if(!isSelected){
                            templateAccess = new SYSTemplateAccess__c();
                            templateAccess.templateId__c =template.Id;
                            templateAccess.profile__c = strTemp;
                            objDriverAccess.insertObject(templateAccess , null);    
                        }
                    }
                     
                    for(SYSTemplateAccess__c sysTemplateAccess : templateAccessList){
                        Boolean isSelected=false;
                        for (String strTemp : strProfiles){
                            if( strTemp.equals(sysTemplateAccess.profile__c) ){
                                isSelected =true;
                                break;
                            }
                        }
                        if(!isSelected){
                            objDriverAccess.deleteObject(sysTemplateAccess ,null, null);    
                        }
                     
                     }
                     
                }else{
                    for (String strTemp : strProfiles){
                        templateAccess = new SYSTemplateAccess__c();
                        templateAccess.templateId__c =template.Id;
                        templateAccess.profile__c = strTemp;
                        objDriverAccess.insertObject(templateAccess , null);
                    }
                }
                                
            }
            
        }       
         return null;
    } 
    
}
			                            	