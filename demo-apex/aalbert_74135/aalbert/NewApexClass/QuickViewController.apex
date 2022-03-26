/*
  QuickViewController  : Class to fetch the result of a QuickView query from database.
  Author: Sachin Kulkarni
  Date: 17/12/2009
*/
public class QuickViewController {

  String queryName; 
  List<String> lstOutputFields;
    ConditionBuilder objConditionBuilder;
    DriverAccess objDriverAccess;
    List<SYSQVFieldsObjectsInfo__c> moduleList;
    List<SObject>recordList;
    List<String> labelList;
    List<Integer> colsWidthList;
    public List<DynamicSObject> resultSet;
    List<String> lstParamList;
    String query;
    String queryString;
           
    public QuickViewController() {
      lstOutputFields = new List<String>();
      objConditionBuilder = new ConditionBuilder();
      objDriverAccess = new DriverAccess();
      moduleList = new List<SYSQVFieldsObjectsInfo__c>();
      labelList = new List<String> ();
      colsWidthList = new List<Integer> ();
      lstParamList = new List<String> ();
      executeQuery();
    }
    
    public List<SObject> getRecordList() {
      return this.recordList;
    }
    
    public void setRecordList(List<SObject> recordList) {
      this.recordList = recordList;
    }
    
    public List<String> getLabelList() {
      return this.labelList;
    }
    
    public void setLabelList(List<String> labelList) {
      this.labelList = labelList;
    }
    
    public List<Integer> getColsWidthList() {
      return this.colsWidthList;
    }
    
    public void setColsWidthList(List<Integer> colsWidthList) {
      this.colsWidthList = colsWidthList;
    }
    
    public List<DynamicSObject> getResultSet(){
        return resultSet;
    }
    
    
    //Function to fetch the resultSet based on data in the QuickView database model.
    public PageReference executeQuery() {
    
    
  String queryId = Apexpages.currentPage().getParameters().get('queryName');
        
        //List<SYSQVQuery__c> quickViewList = [select Id, Name, name__c from SYSQVQuery__c where Id =: queryId];
    if(lstParamList.size() > 0)
      lstParamList.clear();
    
    lstParamList.add('Id');
    lstParamList.add('Name');
    lstParamList.add('name__c');
    
    query = 'Id =' +'\''+queryId+'\'';
    objConditionBuilder.setCondition(query);
    
    List<SYSQVQuery__c> quickViewList = (List<SYSQVQuery__c>) objDriverAccess.selectObjects(new SYSQVQuery__c(),lstParamList,objConditionBuilder,null);
            
    
    //System.debug('quickViewList[0].name__c : '+ quickViewList[0].name__c);
    
    if(quickViewList.size() > 0) {
      
      List<String> lstIdList = new List<String>();
         
      
      //Use Driver class to build the query based on Query name referred in SYSQV__c.
      queryName = quickViewList[0].Name;
      
      //Get output parameters of the query from SYSQVFieldsInfo.
      //List<SYSQVFieldInfo__c> outputParamsList = [select Id, Name, displayLabel__c, columnWidth__c from SYSQVFieldInfo__c where FKSYSQVQuery__r.Name =: queryName AND isDisplayed__c =: true order by displayPosition__c];
      if(lstParamList.size() > 0)
        lstParamList.clear();
    
      lstParamList.add('Id');
      lstParamList.add('Name');
      lstParamList.add('displayLabel__c');
      lstParamList.add('columnWidth__c');
      
      query = 'FKSYSQVQuery__r.Name =' +'\''+queryName+'\' and  isDisplayed__c = true order by displayPosition__c';
      objConditionBuilder.setCondition(query);
    
      List<SYSQVFieldInfo__c> outputParamsList = (List<SYSQVFieldInfo__c>) objDriverAccess.selectObjects(new SYSQVFieldInfo__c(),lstParamList,objConditionBuilder,null);
        
      
      
      
      if(outputParamsList.size() > 0) {
        if(lstOutPutFields.size() > 0)
          lstOutPutFields.clear();
          
        if(labelList.size() > 0)
          labelList.clear();
        
          
        //Module List
        moduleList = new List<SYSQVFieldsObjectsInfo__c>();
         
         lstOutPutFields.add('Id');
        labelList.add('Id');
        //lstIdList.add('Id');
         colsWidthList.add(10);    
        
        
        
        for(Integer i=0; i<outputParamsList.size(); i++) {
          
          lstOutPutFields.add(outputParamsList[i].Name);
          labelList.add(outputParamsList[i].displayLabel__c);
          lstIdList.add(outputParamsList[i].Id);
          
          if(outputParamsList[i].columnWidth__c != null)
            colsWidthList.add(Integer.valueOf(outputParamsList[i].columnWidth__c+''));
          else
            colsWidthList.add(84);
        }

        if (lstIdList.size() > 0) {
          moduleList = [select Name, Id, objectName__c from SYSQVFieldsObjectsInfo__c where FKSYSQVFieldInfo__r.Id in :lstIdList];
          //moduleList = [select Name, Id, objectName__c from SYSQVFieldsObjectsInfo__c where FKSYSQVFieldInfo__c in :outputParamsList];
          
          /*if(lstParamList.size() > 0)
            lstParamList.clear();
    
          lstParamList.add('Id');
          lstParamList.add('Name');
          lstParamList.add('objectName__c');
          
          query = 'FKSYSQVFieldInfo__r.Id in:' +'\''+lstIdList+'\'';
          objConditionBuilder.setCondition(query);
    
          moduleList = (List<SYSQVFieldsObjectsInfo__c>) objDriverAccess.selectObjects(new SYSQVFieldsObjectsInfo__c(),lstParamList,objConditionBuilder,null);
              */
        }
      }
      
      //Get Condition Builder for the query from SYSQVCondition__c. 
      
        //1. Get Condition Parameteres from SYSQVFieldsInfo
        List<String> conditionParamNames = new List<String> ();//List of condition parameter names.
        List<String> conditionQueryNames = new List<String> ();//List of condition parameter Query names.
        //List<SYSQVFieldInfo__c> conditionParamsList = [select Id, Name, displayLabel__c, columnWidth__c, FKSYSQVQuery__r.Name from SYSQVFieldInfo__c where FKSYSQVQuery__r.Name =: queryName AND isDisplayed__c =: false];
        if(lstParamList.size() > 0)
          lstParamList.clear();
    
        lstParamList.add('Id');
        lstParamList.add('Name');
        lstParamList.add('displayLabel__c');
        lstParamList.add('columnWidth__c');
        lstParamList.add('FKSYSQVQuery__r.Name');
        
      
        query = 'FKSYSQVQuery__r.Name =' +'\''+queryName+'\' and  isDisplayed__c = false';
        objConditionBuilder.setCondition(query);
    
        List<SYSQVFieldInfo__c> conditionParamsList = (List<SYSQVFieldInfo__c>) objDriverAccess.selectObjects(new SYSQVFieldInfo__c(),lstParamList,objConditionBuilder,null);
        
        
        
        
        if(conditionParamsList.size() > 0) {
          for(Integer i=0; i<conditionParamsList.size(); i++) {
            conditionParamNames.add(conditionParamsList[i].Name);
            conditionQueryNames.add(conditionParamsList[i].FKSYSQVQuery__r.Name);
          }
        }
        //system.debug('===>conditionParamNames'+conditionParamNames);
        //system.debug('===>conditionQueryNames'+conditionQueryNames);
        
        
        //2. Get exact condition from SYSQVCondition__c.         
         List<SYSQVCondition__c> conditionList = new List<SYSQVCondition__c> ();
         if(conditionParamNames.size()>0 && conditionQueryNames.size()>0) {
           
           conditionList = [select Id, Name, SYSQVOperator__c, operand1__c from SYSQVCondition__c where FKSYSQVFieldInfo__r.Name in : conditionParamNames AND FKSYSQVQuery__r.Name in : conditionQueryNames];
          system.debug('Found conditionList'+conditionList);
          /*if(lstParamList.size() > 0)
            lstParamList.clear();
    
          lstParamList.add('Id');
          lstParamList.add('Name');
          lstParamList.add('SYSQVOperator__c');
          lstParamList.add('operand1__c');
          
          system.debug('====>conditionParamNames'+conditionParamNames);
          system.debug('====>conditionQueryNames'+conditionQueryNames);
          
          query='FKSYSQVFieldInfo__r in : ' +'\''+conditionParamNames+' \' and  FKSYSQVQuery__r.Name in : ' + ' \' '+conditionQueryNames+'\'';
          objConditionBuilder.setCondition(query);
    
          conditionList = (List<SYSQVCondition__c>) objDriverAccess.selectObjects(new SYSQVCondition__c(),lstParamList,objConditionBuilder,null);
               */  
           
           
           
           /*for(Integer i=0; i<conditionParamsList.size(); i++) {
             List<SYSQVCondition__c> conditionList = [select Id, Name, SYSQVOperator__c, operand1__c from SYSQVCondition__c where FKSYSQVFieldInfo__r.Name =: conditionParamsList[0].Name AND FKSYSQVQuery__r.Name =: conditionParamsList[0].FKSYSQVQuery__r.Name];
          */
          
          //Query with AND/OR conditions to be handled here.
           if(conditionList.size() > 0) {
             queryString = conditionParamsList[0].Name + conditionList[0].SYSQVOperator__c + '\''+conditionList[0].operand1__c+'\''; 
             objConditionBuilder.setCondition(queryString);
             system.debug('=>Query :'+queryString);
           }
         }
         
         
       //Fire actual query here
       SObject module = SObjectFactory.getSObject(moduleList[0].objectName__c);   
       system.debug('=>Module :'+module);
       system.debug('=>fields :'+lstOutputFields);
       List<SObject> recordList = objDriverAccess.selectObjects(module, lstOutputFields, objConditionBuilder, null);            
             
             //System.debug('========Query Result======');
             //System.debug('=>'+recordList[0].get('Name'));      
             //System.debug('=>'+recordList[0].get('Id'));
             //System.debug('=>'+recordList[0].get('assignedToUserId__c'));
             /*
             for(Integer i=0; i<recordList.size(); i++) {
               List<String> row = new List<String> ();
             
               for(Integer j=0; j<lstOutputFields.size(); j++) {
                 
                 row.add(String.valueOf(recordList[i].get(lstOutputFields[j]))==null?' ':String.valueOf(recordList[i].get(lstOutputFields[j])));
                 row.add(String.valueOf(recordList[i].get('Id')));
                 //row.add(String.valueOf(recordList[i].get(lstOutputFields[j])));
               }
               matrix.add(row);
             }*/
             //system.debug('MATRIX : '+ matrix);
             
             //Get the name of the page from SYSQVPageReference.
             
             //List<SYSQVPageReference__c> pageList = [select Id, Name, FKSYSPageObjectAssociation__r.pageName__c from SYSQVPageReference__c where FKSYSQVQuery__c =: quickViewList[0].Id];
             if(lstParamList.size() > 0)
        lstParamList.clear();
    
       lstParamList.add('Id');
       lstParamList.add('Name');
       lstParamList.add('FKSYSPageObjectAssociation__r.pageName__c');
          
       query = 'FKSYSQVQuery__c =' +'\''+quickViewList[0].Id+'\'';
       objConditionBuilder.setCondition(query);
    
       List<SYSQVPageReference__c> pageList = (List<SYSQVPageReference__c>) objDriverAccess.selectObjects(new SYSQVPageReference__c(),lstParamList,objConditionBuilder,null);
        
             
             
             if(pageList.size() > 0) {
               lstOutputFields.add(pageList[0].FKSYSPageObjectAssociation__r.pageName__c);
               colsWidthList.add(10);
             }
               
             resultSet=new DynamicSObject().getList(recordList, lstOutputFields);
       
       if(pageList.size() > 0) {
               for(DynamicSObject dso : resultSet){
           DynamicSObject.Field fld= new DynamicSObject.Field();
           fld.name=pageList[0].FKSYSPageObjectAssociation__r.pageName__c;
           fld.value=pageList[0].FKSYSPageObjectAssociation__r.pageName__c;
           dso.getFields().add(fld);
         }
       }
    }
      
    return null;
  }
  
}
			                            	