/* 

  This class implements the logic for generic supporting Information.

  It has all the basic operations of supporting information. e.g adding, edditing, linking...
  
*/
public class DetailSectionCont{
    private String objType='';
    private String fkey='';
    public List<String> cols {get; set;}
    public String selectedProfiles{get;set;}
    public List<DynamicSObject> resultSet{get;set;} 
    public List<String> headers;
    public String tabId{get;set;}
    public String parentObject{get;set;}
    public String tabName{get;set;}
    public String strDisable;
    public DetailSectionCont(){
        resultSet=null;
    }
     public String createdby{get;set;}
     public String creationDate{get;set;}
     public String modifiedby{get;set;}
     public String modificationDate{get;set;}
    public List<String> lstSYSToolBarMenuItem {get;set;}
    public List<String> lstSYSToolBarMenu {get;set;}
    public string strObject
    {
        get;
        set;
    }
    
     public string strValue
    {
        get;
        set;

    }
    
    public string filterValue
    {
        get;
        set;
    }
    
    public string childObj
    {
        get;
        set;
    }
    
    public string myId
    {
        get;
        set;
    }
    
    public void setHeaders(List<String> hdrs){headers=hdrs;}
    public List<String> getHeaders(){
        
        return headers;
    }
    
     public Pagereference initResultSet(){
         if(Apexpages.currentPage().getParameters().get('tabid')!=null){
            tabId = Apexpages.currentPage().getParameters().get('tabid');
         }
         else{
            if(resultList!=null && resultList.size()>0 && tabId==null){
                tabId = resultList[0].id;
            }
         }
        sObjects = getSObjects();
        resultSet=new List<DynamicSObject>();
        if(sObjects!=null){
            for(SObject so:sObjects){
                resultSet.add(new DynamicSObject(so, cols));
            }
        }
        return null;
    }
    
    
     public class DynamicSObject {

        public String Name {get; set;}

        public DynamicSObject(SObject delegate, List<String> flds) {
            this.delegate = delegate;
            this.flds = flds;
            getFields();
        }

        public ID getID() {
            return delegate.id;
        }

        public String getSObjectType() {
            return getDescribe().getName();
        }

        public List<Field> getFields() {
            if (fields == null) {
                if(headers==null)
                    headers = new List<String>();
                fields = new List<Field>();                
                readObjectsFields();
            }
            return fields;
        }
        private void readObjectsFields(){
            readObjects(false);
        }
        private void readObjects(Boolean searchName){
            for (String fld : flds) {
                try {
                    fld=fld.trim().toLowerCase();                        
                    Field field = new Field();
                    field.name=fld;
                    field.label=fld.replace('__c', '').replace('_', ' ');
                    field.value=String.valueOf(delegate.get(fld));
                    fields.add(field);
                    if(searchName) break;
                } catch (System.SObjectException x) {
                }
            }
        }
        private Schema.DescribeSObjectResult getDescribe() {
            return delegate.getSObjectType().getDescribe();
        }
         private final SObject delegate;
        private List<Field> fields;
        public List<String> headers {get; set;}
        public List<String> flds {get; set;}
    }
    
    public class Field {
        public String value {get; set;}
        public String label {get; set;}
        public String name {get; set;}
    }
    
    public List<SObject> sObjects;
    public List<SObject> getSObjects(){
        if(strValue == null){
            strDisable ='true';
        }else{
            strDisable ='false';
        }
        ConditionBuilder cb;
        DriverAccess objDriverAccess = new DriverAccess();
        if(tabId !=null && tabId != ''){
            String poId = '';
            childObj = Apexpages.currentPage().getParameters().get('childObj');
            if(childObj!=null && childObj !=''){
                cb = new ConditionBuilder();
                cb.setCondition('id=\''+childObj+'\'');
                List<String> poCols = new List<String>();
                List<SYSTabInfo__c> lst1 = (List<SYSTabInfo__c> )objDriverAccess.selectObjects(new SYSTabInfo__c(), null, cb, null);    
                for(SYSTabInfo__c so: lst1){
                    poId = so.Id;
                    objType = so.childObject__c;
                    fkey = so.Fkey__c;
                    parentObject = so.parentObject__c;
                    tabName = so.tabName__c;
                }
            }else{
            
                cb = new ConditionBuilder();
                cb.setCondition('id=\''+tabId+'\'');
                List<String> poCols = new List<String>();
                List<SYSTabInfo__c> lst1 = (List<SYSTabInfo__c> )objDriverAccess.selectObjects(new SYSTabInfo__c(), null, cb, null);    
                
                for(SYSTabInfo__c so: lst1){
                    poId = so.Id;
                    objType = so.childObject__c;
                    fkey = so.Fkey__c;
                    parentObject = so.parentObject__c;
                    tabName = so.tabName__c;
                }
            }
            
            cb = new ConditionBuilder();
            cb.setCondition('SYSTabInfo__c=\''+poId+'\' ORDER BY columnSequence__c');
            List<SYSTabFieldsInfo__c> lst2 = (List<SYSTabFieldsInfo__c> )objDriverAccess.selectObjects(new SYSTabFieldsInfo__c(), null, cb, null);
            cols = new List<String>();
            headers = new List<String>();
            cols.add('Id');
            headers.add('Id');
            for(SYSTabFieldsInfo__c so: lst2){
                cols.add(so.fieldAPIName__c);
                headers.add(so.columnName__c); 
            }
            filterValue = Apexpages.currentPage().getParameters().get('filterVal');
            SObject so = SObjectFactory.getSObject(objType);
            String strParId;
            if(strValue ==null && Apexpages.currentPage().getParameters().get('parId')!=null && Apexpages.currentPage().getParameters().get('parId')!=''){
                String strPId = Apexpages.currentPage().getParameters().get('parId');
                strValue = strPId;
                strDisable = 'false';
            }
            if(myId != null && myId != ''){
                strValue = myId;
            }
            if(so != null && strValue !=null && strValue != ''){
                strDisable = 'false';
                String queryString;
                if(filterValue==null || filterValue==''){
                    queryString = fkey + '='+'\''+strValue+'\'';
                    if(objType=='IncidentTemplate__c'){
                        queryString = 'parentTemplateId__c='+'\''+strValue+'\' order by orderNumber__c';
                        cb = new ConditionBuilder();
                        cb.setCondition(queryString);
                        List<SYSTemplateLink__c> listSYSTemplateLink = (List<SYSTemplateLink__c>) objDriverAccess.selectObjects(new SYSTemplateLink__c(),null,cb,null);
                        
                        if(listSYSTemplateLink.size() > 0){
                            strValue = '';
                            List<String> strValueList = new List<String>();                          
                            for(SYSTemplateLink__c sysTemplateLink : listSYSTemplateLink){
                                strValueList.add(sysTemplateLink.linkedTemplateId__c+'');                               
                            }
                            if(strValueList.size() == 1){
                                strValue = strValueList[0]; 
                            }else{
                                for(String str : strValueList){                                 
                                    strValue = strValue + ''+str + '\'OR '+ fkey + '=\'';                                   
                                }
                            }                           
                        }else{
                            strValue = '';
                        }                        
                        queryString = fkey + '='+'\''+strValue+'\'';                        
                        if(queryString.contains('OR id')){
                            queryString = queryString.substring(0, Integer.valueOf(queryString.lastIndexOf('OR id=\'\'')));
                        }                        
                    }
                }else{
                    if(objType=='Task__c'){
                        queryString = fkey + '='+'\''+strValue+'\'and status__c='+'\''+filterValue+'\''; 
                    }else if(objType=='IncidentHistory__c' || objType=='TaskHistory__c' || objType=='BroadcastHistory__c'){
                        queryString = fkey + '='+'\''+strValue+'\'and system__c='+filterValue; 
                    }else if(objType=='Incident__c'){
                        queryString = fkey + '='+'\''+strValue+'\'and statusId__c='+'\''+filterValue+'\''; 
                    }
                }
                cb = new ConditionBuilder();
                cb.setCondition(queryString);
                sObjects = objDriverAccess.selectObjects(so,cols,cb,null); 
                }
            }else{
                sObjects =null;
            }
            if(objType=='Task__c'&& objType!=parentObject){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcView1\''+',tooltip:\''+ 'View\''+',menu: [ {text:\''+'Open\''+',disabled:'+strDisable+',handler:OpenHandler},{text:\''+'Acknowledged\''+',disabled:'+strDisable+',handler:AcknowledgedHandler},{text:\''+'In Progress\''+',disabled:'+strDisable+',handler:InProgressHandler},{text:\''+'Closed\''+',disabled:'+strDisable+',handler:ClosedHandler }]},\''+' \''+',{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]';  
            }else if(objType=='IncidentHistory__c' || objType=='TaskHistory__c' || objType=='BroadcastHistory__c'){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcView1\''+',tooltip:\''+ 'View\''+',menu: [ {text:\''+'User Entries\''+',disabled:'+strDisable+',handler:UserEntriesHandler},{text:\''+'System Entries\''+',disabled:'+strDisable+',handler:SystemEntriesHandler},{text:\''+'All Entries\''+',disabled:'+strDisable+',handler:AllEntriesHandler}]},\''+' \''+',{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]'; 
            }else if(objType=='Attachment'){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Open\''+',disabled:'+strDisable+',handler:OpenFileHandler},{text:\''+'Delete\''+',disabled:'+strDisable+',handler:DeleteFileHandler}]}]'; 
            }else if(objType=='Incident__c' && objType!=parentObject){
                
                if(parentObject=='Broadcasts__c'){                  
                    strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcView1\''+',tooltip:\''+ 'View\''+',menu: [ {text:\''+'Open\''+',disabled:'+strDisable+',handler:OpenHandler},{text:\''+'Acknowledged\''+',disabled:'+strDisable+',handler:AcknowledgedHandler},{text:\''+'In Progress\''+',disabled:'+strDisable+',handler:InProgressHandler},{text:\''+'Closed\''+',disabled:'+strDisable+',handler:ClosedHandler }]},\''+' \''+',{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler},{text:\''+'Link to Incident\''+',disabled:'+strDisable+',handler:LinkHandler}]}]'; 
                }else if(parentObject=='Priority__c' || parentObject=='Client__c'){
                     strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcView1\''+',tooltip:\''+ 'View\''+',menu: [ {text:\''+'Open\''+',disabled:'+strDisable+',handler:OpenHandler},{text:\''+'Acknowledged\''+',disabled:'+strDisable+',handler:AcknowledgedHandler},{text:\''+'In Progress\''+',disabled:'+strDisable+',handler:InProgressHandler},{text:\''+'Closed\''+',disabled:'+strDisable+',handler:ClosedHandler }]},\''+' \''+',{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Save\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]';
                }else if(parentObject=='Category__c'){
                    strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcView1\''+',tooltip:\''+ 'View\''+',menu: [ {text:\''+'Open\''+',disabled:'+strDisable+',handler:OpenHandler},{text:\''+'Acknowledged\''+',disabled:'+strDisable+',handler:AcknowledgedHandler},{text:\''+'In Progress\''+',disabled:'+strDisable+',handler:InProgressHandler},{text:\''+'Closed\''+',disabled:'+strDisable+',handler:ClosedHandler }]},\''+' \''+',{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Save\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]';
                }
            }else if(objType=='Category__c'){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]'; 
            }else if(objType=='StandardDescription__c' && objType!=parentObject){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]'; 
            }else if(objType=='StandardResolution__c' && objType!=parentObject){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]'; 
            }else if(objType=='Action__c' && objType!=parentObject){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]'; 
            }else if(objType=='SupportAssignments__c' && objType!=parentObject){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Assign Support Experts\''+',disabled:'+strDisable+',handler:AssignSupportHandler},{text:\''+'Unassign Support Experts\''+',disabled:'+strDisable+',handler:UnassignSupportHandler},{text:\''+'Edit\''+',disabled:true,handler:EditHandler}]}]'; 
            }else if(objType=='Client__c' && objType!=parentObject){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Link Client\''+',disabled:'+strDisable+',handler:LinkClientHandler},{text:\''+'Unlink Client\''+',disabled:'+strDisable+',handler:UnlinkClientHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]'; 
            }else if(objType=='Organization__c' && objType==parentObject){
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Actions\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler}]}]'; 
            }else if(objType=='IncidentTemplate__C' && objType==parentObject){                
                strItem= '[{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcAction1\''+',tooltip:\'' +'Save\''+',menu: [ {text:\''+'Add\''+',disabled:'+strDisable+',handler:AddHandler},{text:\''+'Edit\''+',disabled:'+strDisable+',handler:EditHandler},{text:\''+'Link Templates\''+',disabled:'+strDisable+',handler:LinkTemplateHandler},{text:\''+'Unlink Templates\''+',disabled:'+strDisable+',handler:UnlinkTemplateHandler}]},\''+' \''+',{scale:\''+ 'medium\''+',iconCls:\''+ 'bmcTemplateOrder\''+',tooltip:\''+ 'Template Display Order\''+',handler:ChildTemplateOrderHandler}]'; 
            }else if(objType==parentObject && strValue != null){
                if(tabName == 'Auditing'){
                     String queryString1;
                     strItem = '[]';
                     SObject sobj = SObjectFactory.getSObject(objType);
                     cb = new ConditionBuilder();
                     queryString1 = fkey + '='+'\''+strValue+'\'';
                     cb.setCondition(queryString1);
                     sObjects = objDriverAccess.selectObjects(sobj,null,cb,null);
                     String createdbyId = sObjects[0].get('CreatedById')+'';
                     
                     queryString1 = 'id='+'\''+createdbyId+'\'';
                     cb.setCondition(queryString1);
                     List<User> userCreatedList = (List<User>)objDriverAccess.selectObjects(new User(),null,cb,null);
                     createdby = userCreatedList[0].Name;
                     
                     creationDate = sObjects[0].get('CreatedDate')+'';
                     
                     String modifiedbyId = sObjects[0].get('LastModifiedById')+'';
                     
                     queryString1 = 'id='+'\''+modifiedbyId+'\'';
                     cb.setCondition(queryString1);
                     List<User> userModifiedList = (List<User>)objDriverAccess.selectObjects(new User(),null,cb,null);
                     modifiedby = userModifiedList[0].Name;

                     modificationDate = sObjects[0].get('LastModifiedDate')+'';
                }else if(tabName == 'DisplayTo'){
                    strItem='[]';
                    
                        
                        populateSelectedProfiles();
                    
                }
                     
            }else{
                strItem='[]';
            }
            
        return sObjects;
    }
    
    String[] strGrpTab;
    String[] strTabItem;
    public String strItem{get;set;}
    public String[] getStrGrpTab(){
        produceData();
        initResultSet();
        return this.strGrpTab;      
    }
    public void setStrGrpTab(String[] strGrpTab){
        
        this.strGrpTab =  strGrpTab;
    }
    public String[] getStrTabItem(){
         return this.strTabItem;
    }
    public void setStrTabItem(String[] strTabItem){
         this.strTabItem = strTabItem;
    }
    
   List<SYSTabInfo__c> resultList;
   public void produceData(){
            ConditionBuilder conditionBuilder = new ConditionBuilder();
                String condition = 'parentObject__c= ' +'\''+ strObject +'\'ORDER BY tabSequence__c';
                conditionBuilder.setCondition(condition);
                DriverAccess driverAccess = new DriverAccess();
                resultList = (List<SYSTabInfo__c>)driverAccess.selectObjects(new SYSTabInfo__c(), null, conditionBuilder, null);                                                                                    //tabReload(childObject);
                  strGrpTab = new String[resultList.size()];
                  strTabItem = new String[resultList.size()];
                  Integer i = 0;
              for(SYSTabInfo__c systabInfo:resultList){                  
                strTabItem[i] = '{title:\''+ systabInfo.tabName__c+'\',id:\''+systabInfo.tabName__c+'\',iconCls:\''+'x-icon-tickets\''+',tabTip:\''+systabInfo.tabName__c+'\''+',style:\''+'padding: 10px;align:left;\''+',listeners: {activate: function(obj,evnt){ elem = obj; }  },items: []}';
                strGrpTab[i] =  '{mainItem: 0,id:\''+ 
                systabInfo.Id+
                '\',listeners: {activate: function(obj,evnt){addEditLink=\''+systabInfo.newEditLink__c+
                '\';childObject=\''+systabInfo.Id+
                '\';childObjectName=\''+systabInfo.childObject__c+
                '\';editLink=\''+systabInfo.editLink__c+
                '\';parentObject=\''+systabInfo.parentObject__c+
                '\'; elem = Ext.getCmp(\''+systabInfo.tabName__c+
                '\');tabReload(childObject);}},items:['+strTabItem[i]+']}' ;
                 
                  
                   i = i+1;
              }
    }

    public  List<SYSTabInfo__c> getTabList() {
        return resultList;
    }
    public Pagereference linkBroadcastInc(){
        if(strvalue==null || strvalue==''){
            strvalue = myId;
        }
        List<Incident__c> incList;
        ConditionBuilder cb = new ConditionBuilder();
        DriverAccess da = new DriverAccess();
        String strincId = Apexpages.currentPage().getParameters().get('incId');
        if(strincId!=null && strincId != ''){
            String condition = 'id=\''+strincId+'\'';
            
            
            cb.setCondition(condition);
            incList = (List<Incident__c>)da.selectObjects(new Incident__c(), null, cb, null);
        }
        Incident__c inc = incList[0];
        
        inc.FKBroadcast__c = strValue;
        cb.setCondition('Id =\''+ inc.Id + '\'');
        da.updateObject(inc, cb, null); 
        return null;
    }
    
    public Pagereference linkOrgClient(){
        if(strvalue==null || strvalue==''){
            strvalue = myId;
        }
        List<Client__c> clntList;
        ConditionBuilder cb = new ConditionBuilder();
        DriverAccess da = new DriverAccess();
        String strclntId = Apexpages.currentPage().getParameters().get('clntId');
        if(strclntId!=null && strclntId != ''){
            String condition = 'id=\''+strclntId+'\'';
            cb.setCondition(condition);
            clntList = (List<Client__c>)da.selectObjects(new Client__c(), null, cb, null);
        }
        Client__c clnt = clntList[0];
        
        clnt.FKOrganization__c = strValue;
        String cond = 'id=\''+strValue+'\'';
        cb.setCondition(cond);
        List<Organization__c> orgList = (List<Organization__c>)da.selectObjects(new Organization__c(), null, cb, null);
        if(orgList!=null && orgList.size()>0){
            clnt.organizationId__c = orgList[0].Name;
        }
        cb.setCondition('Id =\''+ clnt.Id + '\'');
        da.updateObject(clnt, cb, null); 
        return null;
    }
    
    public Pagereference unLinkOrgClient(){
        List<Client__c> clntList;
        ConditionBuilder cb = new ConditionBuilder();
        DriverAccess da = new DriverAccess();
        String strclntId = Apexpages.currentPage().getParameters().get('unlinkClntId');
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+strclntId);
        if(strclntId!=null && strclntId != ''){
            String condition = 'id=\''+strclntId+'\'';
            cb.setCondition(condition);
            clntList = (List<Client__c>)da.selectObjects(new Client__c(), null, cb, null);
        }
        Client__c clnt = clntList[0];
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+clnt.Id);
        clnt.FKOrganization__c = null;
        clnt.organizationId__c = '';
        
        cb.setCondition('Id =\''+ clnt.Id + '\'');
        da.updateObject(clnt, cb, null);
        return null;
    }
    
    public Pagereference linkStaffCategory(){
           if(strvalue==null || strvalue==''){
            strvalue = myId;
           }   
           ConditionBuilder cb = new ConditionBuilder();
           DriverAccess da = new DriverAccess();
           String strStaffId = Apexpages.currentPage().getParameters().get('clntId');
           
              
           if((strStaffId!=null && strStaffId != '') && (strValue!=null && strValue != '')){
               
               String condition = 'Id=\''+strStaffId+'\'';
               cb.setCondition(condition);
               List<String> listFields = new List<String>();
               listFields.add('name');
               List<User> userStaff = (List<User>)da.selectObjects(new User(), null, cb, null);
               
               condition = 'Id=\''+strValue+'\'';
               cb.setCondition(condition);
               listFields = new List<String>();
               listFields.add('name');
               List<Category__c> categoryList = (List<Category__c>)da.selectObjects(new Category__c(), null, cb, null);
               
               
               SupportAssignments__c supportAssignments = new SupportAssignments__c(FKCategory__c=categoryList[0].id,FKUser__c=userStaff[0].Id, categoryId__c= categoryList[0].name,userId__c =userStaff[0].name );
               da.insertObject(supportAssignments, null);
           }
      
        return null;
    }
    
    public Pagereference unLinkStaffCategory(){
       
       String strStaffId = Apexpages.currentPage().getParameters().get('unlinkClntId');
       ConditionBuilder cb = new ConditionBuilder();
       DriverAccess da = new DriverAccess();
       if((strStaffId!=null && strStaffId != '') && (strValue!=null && strValue != '')){
             String condition = 'id=\''+strStaffId+'\'';
             cb.setCondition(condition);
             List<SupportAssignments__c> supportAssignmentsList = (List<SupportAssignments__c>)da.selectObjects(new SupportAssignments__c(), null, cb, null);
                        
             if(supportAssignmentsList != null && supportAssignmentsList.size() > 0){
                 da.deleteObject(supportAssignmentsList[0], null, null);
             }
            
       }
       return null;
    }
    
      public void addIncidentHistory(List<Action__c> lstAction){
        if(strvalue==null || strvalue==''){
            strvalue = myId;
        }
        DriverAccess da = new DriverAccess();
        IncidentHistory__c incHis = new IncidentHistory__c();
        if(lstAction != null && strValue != null){
            incHis.actionId__c = lstAction[0].name;
            incHis.FKAction__c = lstAction[0].id;
            incHis.date__c = system.now();
            incHis.system__c = lstAction[0].system__c; 
            incHis.description__c= lstAction[0].description__c;
            incHis.userId__c = Userinfo.getName();
            incHis.FKIncident__c = strValue;
            da.insertObject(incHis, null);
         }
    }
    
     public void addTaskHistory(List<Action__c> lstAction){
        if(strvalue==null || strvalue==''){
            strvalue = myId;
        }
        DriverAccess da = new DriverAccess();
        TaskHistory__c tskHis = new TaskHistory__c();
        if(lstAction != null && strValue != null){
            tskHis.actionId__c = lstAction[0].name;
            tskHis.FKAction__c = lstAction[0].id;
            tskHis.date__c = system.now();
            tskHis.system__c = lstAction[0].system__c; 
            tskHis.description__c= lstAction[0].description__c;
            tskHis.userId__c = Userinfo.getName();
            tskHis.FKWO__c = strValue;
            tskHis.FKUser__c = Userinfo.getUserId();
            da.insertObject(tskHis, null);
         }
    }
    
     public void addBroadcastHistory(List<Action__c> lstAction){
        if(strvalue==null || strvalue==''){
            strvalue = myId;
        }
        DriverAccess da = new DriverAccess();
        BroadcastHistory__c brdHis = new BroadcastHistory__c();
        if(lstAction != null && strValue != null){
            brdHis.actionId__c = lstAction[0].name;
            brdHis.FKActions__c = lstAction[0].id;
            brdHis.system__c = lstAction[0].system__c; 
            brdHis.date__c = system.now();
            brdHis.description__c= lstAction[0].description__c;
            brdHis.FKUser__c = Userinfo.getUserId();
            brdHis.userId__c = Userinfo.getName();
            brdHis.FKBroadcast__c = strValue;
            da.insertObject(brdHis, null);
         }
    }
    
    public Pagereference addToHistory(){
        if(strvalue==null || strvalue==''){
            strvalue = myId;
        }
        ConditionBuilder cb = new ConditionBuilder();
        DriverAccess da = new DriverAccess();
        String actionId = Apexpages.currentPage().getParameters().get('actionId');
        
        List<Action__c> lstAction;
        if(actionId !=null){
            String condString = 'id=\''+actionId +'\'';
            cb.setCondition(condString );
            lstAction = (List<Action__c>)da.selectObjects(new Action__c(),null,cb,null);
        }
        
        if(objType=='IncidentHistory__c'){
            addIncidentHistory(lstAction);
        }else if(objType=='TaskHistory__c'){
            addTaskHistory(lstAction);
        }else if(objType=='BroadcastHistory__c'){
            addBroadcastHistory(lstAction);
        }
        return null;
    }
    
    public Pagereference linkToParent(){
        if(strvalue==null || strvalue==''){
            strvalue = myId;
        }
        DriverAccess driverAccessObj = new DriverAccess();
        
        SYSTemplateLink__c templateLink = new SYSTemplateLink__c();
        
        String childTemplateId = Apexpages.currentPage().getParameters().get('childTemplateId');
        String parentTemplateId = Apexpages.currentPage().getParameters().get('parentTemplateId');        
        
        templateLink.linkedTemplateId__c = childTemplateId;
        templateLink.parentTemplateId__c = parentTemplateId;
        
        driverAccessObj.insertObject(templateLink, null);
        
        return null;
    }
    
    public Pagereference UnLinkFromParent(){
        
        List<SYSTemplateLink__c> templateLinkList;
        ConditionBuilder conditionBuilderObj = new ConditionBuilder();
        DriverAccess driverAccessObj = new DriverAccess();
        String childTemplateId = Apexpages.currentPage().getParameters().get('childTemplateId');
        String parentTemplateId = Apexpages.currentPage().getParameters().get('parentTemplateId');        
        
        if(childTemplateId!=null && childTemplateId != '' && parentTemplateId!=null && parentTemplateId != ''){
            String condition = 'linkedTemplateId__c=\''+childTemplateId+'\' AND parentTemplateId__c=\''+parentTemplateId+'\'';
            conditionBuilderObj.setCondition(condition);
            templateLinkList = (List<SYSTemplateLink__c>)driverAccessObj.selectObjects(new SYSTemplateLink__c(), null, conditionBuilderObj, null);
        }
        if(templateLinkList.size() > 0){
            driverAccessObj.deleteObject(templateLinkList[0], null, null);
        }
        
        return null;
    }
    
    public Pagereference deleteThisAttachment(){
        String deletedAttId = Apexpages.currentPage().getParameters().get('delId');
         Attachment[] attach = [Select Id, Name From Attachment where Id=:deletedAttId];
        try{
            delete attach;
        }catch(DMLException e){
            
        }
        return null;
    }
     public Pagereference populateSelectedProfiles(){
         if(strvalue==null || strvalue==''){
            strvalue = myId;
        }
        List<String> listField = new List<String>();
        listField.add('name');
        listField.add('Profiles__c');
        ConditionBuilder cb= new ConditionBuilder();
        DriverAccess objDriverAccess = new DriverAccess();
        if(strValue != null && strValue != ''){
            cb.setCondition('Id=\'' + strValue +'\'');
            List<Broadcasts__c> brdList = (List<Broadcasts__c>)objDriverAccess.selectObjects(new Broadcasts__c(),listField,cb,null);
            if(brdList != null && brdList.size() >0 &&  brdList[0].Profiles__c != null){
                selectedProfiles = brdList[0].Profiles__c;
            }else {
                selectedProfiles = '';
            }
        }
        
        return null;
     }
     
       public Pagereference assignId(){
         strValue = myId;
         return null;
     }
}
			                            	