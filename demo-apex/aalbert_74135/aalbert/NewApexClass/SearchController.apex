//By Avadhut K.
//By Manjiri Yatnalkar
public class SearchController{
  public String log {get; set;}

    private String objType='';
    public Boolean shInactive {get; set;}
    public Boolean shState {get; set;}
    public Boolean shLink {get; set;}
    public List<String> cols {get; set;}
    public List<DynamicSObject> resultSet;
    public List<String> headers;
    public String sortField {get; set;}
    
  public SearchController(){research();}
    
    String popupId;
    public String getPopupId(){
        return popupId;
    }

    public void setPopupId(String popupId){
        this.popupId = popupId;
    }
    
    String view;

    public String getView(){
        return view;
    }

    public void setView(String view){
        this.view = view;
    }
    
    Boolean show;
    public Boolean getShow(){
        view = Apexpages.currentPage().getParameters().get('view');
        if(view == null){
            show = true;
        }else{
            show = false;
        }
        return show;
    }
    public void setShow(Boolean show){
        this.show = show;
    }
    
    
    Boolean showNew;
    public Boolean getShowNew(){
        view = Apexpages.currentPage().getParameters().get('view');
        if(view == null){
            showNew = false;
        }else{
            showNew = true;
        }
        return showNew;
    }
    
    public void setShowNew(Boolean showNew){
        this.showNew = showNew;
    }
    
    public void setHeaders(List<String> hdrs){headers=hdrs;}
    public List<String> getHeaders(){
        return headers;
    }
    public List<DynamicSObject> getResultSet(){
        return resultSet;
    }
    public String getResultSetString(){
      String rs='';      
      if(resultSet!=null && resultSet.size()>0){
        Integer i=0;
        rs=rs+'resultSet= new Array('+resultSet.size()+');';
        for(DynamicSObject row : resultSet){
          Integer j=0;
          rs=rs+'resultSet['+i+']=new Array('+row.getFields().size()+'); ';    
          for(DynamicSObject.Field fld: row.getFields()){
            rs=rs+'resultSet['+i+']['+j+']="'+StringUtil.getValidData(fld.value)+'"; ';            
            j++;
          }i++;
        }
      }
      return rs;
    }
    private void initResultSet(){
      //if(resultSet<>null) return;
        sObjects = getSObjects();
                
        resultSet=new DynamicSObject().getList(sObjects, cols);        
    }

    String poupId;

    public String getPoupId(){
        return poupId;
    }

    public List<SObject> sObjects;
    public List<SObject> getSObjects(){
      String queryCrit='';
      sortField = 'cols[1]';        
      ConditionBuilder cb;
      String pId = Apexpages.currentPage().getParameters().get('popupId');
      setPopupId(pId);
    
      String view = Apexpages.currentPage().getParameters().get('view');
      if(view != null){
          setView(view);
      }
      
      DriverAccess objDriverAccess = new DriverAccess();
      cb = new ConditionBuilder();
      cb.setCondition('Name=\''+pId+'\'');
      List<String> poCols = new List<String>();
    poCols.add('Name');
      poCols.add('popupObjectName__c');
      poCols.add('searchByInactive__c');
      poCols.add('searchByStatus__c');
      poCols.add('staticQueryCriteria__c');
      List<SYSPopupObject__c> lst1 = (List<SYSPopupObject__c> )objDriverAccess.selectObjects(new SYSPopupObject__c(), poCols, cb, null);    
      String poId = '';
      for(SYSPopupObject__c so: lst1){
          poId = so.Id;
          objType = so.popupObjectName__c;
          shInactive = so.searchByInactive__c;
          shState = so.searchByStatus__c;
          queryCrit = so.staticQueryCriteria__c;
      }    
      if(queryCrit==null) { queryCrit=''; }
      
      poCols = new List<String>();
      poCols.add('Name');
      poCols.add('PopupObjectId__c');
      poCols.add('FieldId__c');
      poCols.add('fieldLabel__c');
      cb = new ConditionBuilder();
      cb.setCondition('PopupObjectId__c=\''+poId+'\' ORDER BY FieldId__c');
      List<SYSPopupObjectFields__c> lst2 = (List<SYSPopupObjectFields__c> )objDriverAccess.selectObjects(new SYSPopupObjectFields__c(), poCols, cb, null);
      cols = new List<String>();
      headers = new List<String>();
      cols.add('Id');
      headers.add('Id');
      Boolean nameIncluded = false;
      for(SYSPopupObjectFields__c so: lst2){
          //addlog('>>name:'+so.Name+':Label:'+so.fieldLabel__c+':popId:'+so.popupObjectId__c+':FldId:'+so.FieldId__c);
          cols.add(so.Name);
          if(so.Name.equalsIgnoreCase('name')){ nameIncluded=true; }
          //if(so.fieldLabel__c<>'Name')
          headers.add(so.fieldLabel__c); 
      }
    getOptions();  
      SObject so = SObjectFactory.getSObject(objType);
      if(so!=null){
          String queryString = '';
          queryString = getCriteria();
          queryString = queryString + chkFilterObjForIncident();          
      queryString = queryString+getTemplateQS();
      //Dont add anything after this line
      //queryCrit can contain order by or group by clause so no further addition is to be done
          if(queryCrit!='' && queryString!='' && !queryCrit.toLowerCase().startsWith('order by'))
            queryString = queryString+' AND '+queryCrit;
          else if(queryCrit!='' && queryString!='' && queryCrit.toLowerCase().startsWith('order by'))
                queryString = queryString+' '+queryCrit;
            else if(queryCrit!='' && queryString=='')
            queryString = queryCrit;
          //Handling Order by  
          if(nameIncluded && queryString.toLowerCase().indexOf('order by')==-1){ 
            queryString = queryString+' order by Name'; 
          }else if(queryString.toLowerCase().indexOf('order by')==-1){
            queryString = queryString+' order by '+cols.get(0);
          }          
          cb = new ConditionBuilder();
          cb.setCondition(queryString);
          String strOrderBy = 'order by ';
          if(queryString.toLowerCase().indexOf(strOrderBy)!=-1){
                String sortFld = queryString.substring(queryString.toLowerCase().indexOf(strOrderBy)+(strOrderBy).length());
                sortFld=sortFld.trim()+' ';
                sortFld=sortFld.substring(0, sortFld.indexOf(' '));
                Integer idx=0;
                for(String xcol: cols){
                  addlog('>>'+xcol+';'+sortFld+':'+idx);
                  if(xcol.equalsIgnoreCase(sortFld)){                    
                      sortField = 'cols['+idx+']';//xcol;                      
                      break;
                  }
                  idx++;
                }
            }
            addlog('>>'+queryString+':'+sortField);
      if(txtSrchCrit!=null && txtSrchCrit!='' && txtSrchCrit.length()>1){
        sObjects = objDriverAccess.findObjects(so,cols,cb,null, txtSrchCrit);
          //txtSrchCrit=''; //Not to be reset as required for Reset functionality.
      }else{
            sObjects = objDriverAccess.selectObjects(so,cols,cb,null);            
      }
      }
        return sObjects;
    }
    public String getCriteria(){
    String sql12 = '';
    String sql1 = '';
    String sql2 = '';
    String sql34 = '';
    String sql3 = '';
    String sql4 = '';
    String sql = '';
    String sqlDefault = '';
    inactiveOption=','+inactiveOption;
    stateOption=','+stateOption;    
    if(objType!=null && objType.endsWith('__c')) {
      if(inactiveOption!=null && inactiveOption.indexOf(',Active,')!=-1){
        sql1 = 'Inactive__c=false';
      }if(inactiveOption!=null && inactiveOption.indexOf(',Inactive,')!=-1){
        sql2 = 'Inactive__c=true';
      }if(stateOption!=null && stateOption.indexOf(',Open,')!=-1){
        sql3 = 'state__c=true';
      }if(stateOption!=null && stateOption.indexOf(',Close,')!=-1){
        sql4 = 'state__c=false';
      }
    }if(objType!=null && objType.equals('User')) {
      if(inactiveOption!=null && inactiveOption.indexOf(',Active,')!=-1){
        sql1 = 'IsActive=true';
      }if(inactiveOption!=null && inactiveOption.indexOf(',Inactive,')!=-1){
        sql2 = 'IsActive=false';
      }
    }
    
    if((sql1 != '') && (sql2 != '')){
      sql12 = '';//sql1+' or '+sql2;
    }else if(sql1 == ''){
      sql12 = sql2;
    }else if(sql2 == ''){
      sql12 = sql1;
    }
    
    //if(objType.equals('Incident__c')){
    if((sql3 != '') && (sql4 != '')){
       sql34 = '';//sql3+' or '+sql4;
    }else if(sql3 == ''){
       sql34 = sql4;
    }else if(sql4 == ''){
       sql34 = sql3;
    }
    
    if((sql12 != '') && (sql34 != '')){    
      sql = sql12+' AND '+sql34;
    }else if(sql12 == ''){
      sql = sql34;
    }else if(sql34 == ''){
      sql = sql12;
    }

      if(sqlDefault != ''){
        sql = sqlDefault;
      }
  
    String searchField = Apexpages.currentPage().getParameters().get('searchField');
      String fieldValue = Apexpages.currentPage().getParameters().get('fieldValue');
      if(searchField!=null && searchField<>''){
        if(sql!= null && sql!= '') 
           sql = sql + ' and '+ searchField + ' Like'+'\''+fieldValue+'%\'';
         else
           sql = sql + searchField + ' Like'+'\''+fieldValue+'%\'';
      }
      if(sql== null || sql=='') sql = ' Id<>null ';
    //addlog('>>'+sql);
      return sql;
    }

    String[] selectedCriteria = new String[]{};

    public String[] getselectedCriteria() {
        return selectedCriteria;
    }

    public void setselectedCriteria(String[] selectedCriteria) {
        this.selectedCriteria = selectedCriteria;
    }

    public void getOptions() {      
      inactiveOptions = new List<String>();
        stateOptions = new List<String>();          
        String view = Apexpages.currentPage().getParameters().get('view');
        //addlog('Before:'+inactiveOption+':'+stateOption);
      //if(view == null){
          if(shInactive==true){
              if(inactiveOption==null || inactiveOption=='') inactiveOption = ',Active,';
              inactiveOptions.add('Record Disposition (All)');
                inactiveOptions.add('Active');
                inactiveOptions.add('Inactive');                
          }
          if(shState==true){
              if(stateOption==null || stateOption=='') stateOption = ',Open,';
              stateOptions.add('Item Status (All)');
                stateOptions.add('Open');
                stateOptions.add('Close');                
          }
          setShow(true);
      /*}else{ setShow(false); }*/
      //addlog('After:'+inactiveOption+':'+stateOption);
    }

    Boolean visible = false;
    public Boolean getVisible() {
        return null;
    }
    public void setVisible(Boolean visible){
        this.visible = visible;
    }

    public PageReference research() {      
      shInactive=true; shState=false; log=''; resultSet=null;
      if(Apexpages.currentPage().getParameters().get('inactiveOption')!=null)
        inactiveOption=Apexpages.currentPage().getParameters().get('inactiveOption');
      if(Apexpages.currentPage().getParameters().get('stateOption')!=null)
        stateOption=Apexpages.currentPage().getParameters().get('stateOption');
      initResultSet();        
      initMenu();
      return null; 
    }
    
    public String txtSrchCrit {get; set;}
    public List<String> stateOptions {get; private set;}
    public List<String> inactiveOptions {get; private set;}
    public String stateOption {get; set;}
    public String inactiveOption {get; set;}
 
    private void addlog(String l){
      if(log==null) log='';
      log=log+l+'\n';
    }
    
    ///********************** Code By Vilas *******************///
   public String chkFilterObjForIncident(){
    String srchFld;
    String queryString = '';
    
    srchFld = Apexpages.currentPage().getParameters().get('clientId');
    if(srchFld!=null && srchFld<>'')
      queryString = queryString + ' and FKClient__r.Name=\''+srchFld+'\''; 
    
    srchFld = Apexpages.currentPage().getParameters().get('orgnizationId');
    if(srchFld!=null && srchFld<>'')
      queryString = queryString + ' and FKOrganization__r.Name=\''+srchFld+'\''; 
        
    srchFld = Apexpages.currentPage().getParameters().get('categoryId');
    if(srchFld!=null && srchFld<>'')
      queryString = queryString + ' and FKCategory__r.Name=\''+srchFld+'\'';
    
    return queryString;
  }
  ///********************************************************///
  public Pagereference deleteObject(){
    DriverAccess driverAccess = new DriverAccess();
        ConditionBuilder queryCondition = new ConditionBuilder();
     String selId = Apexpages.currentPage().getParameters().get('selectedSOId');       
        queryCondition.setCondition('id = \''+selId+'\'');
        SObject so = SObjectFactory.getSObject(objType);
        List<String> lstFlds = new list<String>();
        lstFlds.add('id');
        List<SObject> lstSo = driverAccess.selectObjects(so, lstFlds, queryCondition,null);
        
        queryCondition = new ConditionBuilder(); 
        queryCondition.setCondition('');
        for(SObject soo:lstSo){          
          driverAccess.deleteObject(soo,queryCondition,null);
        }
        return research();
  }
  
  SObject duplicate = null;
  public Pagereference copyObject(){
    DriverAccess driverAccess = new DriverAccess();
        ConditionBuilder queryCondition = new ConditionBuilder();
     String selId = Apexpages.currentPage().getParameters().get('selectedSOId');       
        queryCondition.setCondition('id = \''+selId+'\'');
        SObject so = SObjectFactory.getSObject(objType);
        List<SObject> lstSo = driverAccess.selectObjects(so,null, queryCondition,null);
        for(SObject soo:lstSo){          
          duplicate = soo.clone(false, true);
        }                
        return research();
  }
  public Pagereference linkage(){
    String selId = Apexpages.currentPage().getParameters().get('selectedSOId');
    String linkId = Apexpages.currentPage().getParameters().get('linkIds');
    addlog('>Ids>:'+selId+';'+linkId);
    DriverAccess driverAccess = new DriverAccess();
    if(linkId.indexOf(',')==-1)linkId = linkId+',';
    String[] linkIds = linkId.split(',');    
    if(objType.toLowerCase()=='incident__c') {
      ConditionBuilder queryCondition = new ConditionBuilder();
      queryCondition.setCondition('id = \''+selId+'\'');
          SObject so = SObjectFactory.getSObject(objType);
          List<SObject> lstSo = driverAccess.selectObjects(so,null, queryCondition,null);
      for(String id:linkIds){
        if(id!=''){
          for(SObject soo:lstSo){
            Incident__c obj=(Incident__c)soo;
            obj.FKBroadcast__c = id;
            addlog('Linking: '+obj.Id+';'+id);
            driverAccess.updateObject(obj, null, null);
          }
        }
      }
    } else if(objType.toLowerCase()=='broadcast__c') {
      for(String id:linkIds){
        ConditionBuilder queryCondition = new ConditionBuilder();
        queryCondition.setCondition('id = \''+id+'\'');
            SObject so = SObjectFactory.getSObject('Incident__c');
            List<SObject> lstSo = driverAccess.selectObjects(so,null, queryCondition,null);        
        for(SObject soo:lstSo){
          Incident__c obj=(Incident__c)soo;
          obj.broadcastId__c = selId;
          driverAccess.updateObject(obj, null, null);
        }
      }
    } else if(objType.toLowerCase()=='change__c') {
      //
    }
    return research();
  }
  public Pagereference unlinkage(){
    String selId = Apexpages.currentPage().getParameters().get('selectedSOId');
    String linkId = Apexpages.currentPage().getParameters().get('linkIds');
    addlog('>Ids>:'+selId+';'+linkId);
    DriverAccess driverAccess = new DriverAccess();
    if(linkId.indexOf(',')==-1)linkId = linkId+',';
    String[] linkIds = linkId.split(',');    
    if(objType.toLowerCase()=='incident__c') {
      ConditionBuilder queryCondition = new ConditionBuilder();
      queryCondition.setCondition('id = \''+selId+'\'');
          SObject so = SObjectFactory.getSObject(objType);
          List<SObject> lstSo = driverAccess.selectObjects(so,null, queryCondition,null);
      for(String id:linkIds){
        if(id!=''){
          for(SObject soo:lstSo){
            Incident__c obj=(Incident__c)soo;
            obj.FKBroadcast__c = null;
            ConditionBuilder cndn = new ConditionBuilder();
            cndn.setCondition('FKBroadcast__c = \''+id+'\'');
                addlog('Linking: '+obj.Id+';'+id);
            driverAccess.updateObject(obj, cndn, null);
          }
        }
      }
    } else if(objType.toLowerCase()=='broadcast__c') {
      for(String id:linkIds){
        ConditionBuilder queryCondition = new ConditionBuilder();
        queryCondition.setCondition('id = \''+id+'\'');
            SObject so = SObjectFactory.getSObject('Incident__c');
            List<SObject> lstSo = driverAccess.selectObjects(so,null, queryCondition,null);        
        for(SObject soo:lstSo){
          Incident__c obj=(Incident__c)soo;
          obj.broadcastId__c = selId;
          driverAccess.updateObject(obj, null, null);
        }
      }
    } else if(objType.toLowerCase()=='change__c') {
      //
    }
    return research();
  }
  public List<String> linkMenu {get; set;}
  public String popId {get; set;}
  public void initMenu(){
    linkMenu = new List<String>();
    if(objType.toLowerCase()=='incident__c') {
      popId='Broadcast'; 
      linkMenu.add('Link to Broadcast');
      linkMenu.add('Unlink from Broadcast');
    } else if(objType.toLowerCase()=='broadcast__c') {
      popId='Incident';
      linkMenu.add('Link to Incident');
      linkMenu.add('Unlink from Incident');
    } else if(objType.toLowerCase()=='change__c') {
      popId='Task';
      linkMenu.add('Link to Task');
      linkMenu.add('Unlink from Task');
    }
  }
  public String getTemplateQS(){
    String qs='';
    if(!popupId.equalsIgnoreCase('TaskTemplate') && !popupId.equalsIgnoreCase('IncidentTemplates')) return '';
    //Write your code
    DriverAccess driverAccess = new DriverAccess();
        ConditionBuilder conditionBuilder = new ConditionBuilder();
        String usrProfile ='';
        String condition = 'Id = '+'\'' + userinfo.getUserId() + '\'';
        conditionBuilder.setCondition(condition);
        List<String> listFields = new List<String>();
        listFields.add('id');
        listFields.add('Name');
        listFields.add('ProfileId');
        listFields.add('Profile.Name');
        List<User> userList =  (List<User>)driverAccess.selectObjects(new User(), listFields, conditionBuilder, null);
        if(userList.size()> 0){
            usrProfile = userList[0].Profile.Name ; 
        }
        if(usrProfile!=null)
            qs=' Id in (Select templateId__c From SYSTemplateAccess__c where profile__c =\''+usrProfile+'\')';
    //
    if(qs!='')qs=' AND '+qs;
    return qs;
  }
  public String getColsString(){
    String ret = '';
    ret = StringUtil.listToJSString(cols, 'cols', false, '');    
    return ret;
  }
    public String getColsHeadersString(){
        String ret = '';
        ret = StringUtil.listToJSString(headers, 'colsHdrs', false, '');
        return ret;
    }
}
			                            	