public with sharing class QueueAssignment {
    List<Group> objectGroup;
    
   public List<Group> getQueues(){
         return objectGroup;
   }
   
   public void setQueues(List<Group> objgroup){
    this.objectGroup = objgroup;
   }
   
  /* constructor */
  public QueueAssignment(){
    getGridColumns();
    displayQueue();
    buildGrid();
  }
      String dataString;
      public String getDataString(){
        return this.dataString;
      }
    public PageReference displayQueue(){
         String sObjectType = ApexPages.currentPage().getParameters().get('sObjectType');
        objectGroup =  new List<Group>();
        String queryString = 'Select ';
        for(Integer k=0;k<fieldsList.size();k++){
            queryString = queryString + fieldsList[k] +',';
        }
         queryString = queryString + '(Select QueueId, SobjectType From QueueSobjects q where SobjectType =\''+sObjectType+'\' ) From Group g where type=\'Queue\'';
         System.debug('Query String ========'+ queryString);
        List<Group> allGroups = Database.query(queryString);//[Select g.Id,g.Name, g.Type, (Select QueueId, SobjectType From QueueSobjects q where SobjectType =:sObjectType ) From Group g where type='Queue'];
        if(allGroups!= null && allGroups.size()>0){
            dataString = '[';
             Integer j = 0;
        for(Group eachGroup:allGroups){
            System.debug('object field value ================'+eachGroup.get('Type'));
            List<QueueSobject> qsobjs = eachGroup.QueueSobjects;//[Select QueueId, SobjectType From QueueSobject q where SobjectType ='ChangeRequest__c'];
            if(qsobjs!=null && qsobjs.size()>0){
             
              for(QueueSobject qsobj:qsobjs){
                
                objectGroup.add(eachGroup);
                    for(integer i=0; i<fieldsList.size();i++){
                        if(i==fieldsList.size()-1){
                            dataString = dataString + '\''+eachGroup.get(fieldsList[i])+'\']';
                        }else if(i==0){
                            dataString = dataString + '[\''+eachGroup.get(fieldsList[i])+'\',';
                        }else {
                            dataString = dataString + '\''+eachGroup.get(fieldsList[i])+'\',';
                        }
                    }
                    System.debug('After fields loop'+dataString);
                    System.debug('qsobjs.size()'+qsobjs.size()+ 'j----'+j);
                    if(j< qsobjs.size() ){
                    dataString = dataString +',';
                    System.debug('inside If'+dataString);
                    }
                    j = j+1;
                
              }
              system.debug('before datastring ===='+dataString);
             // dataString = dataString + ']';
              system.debug('after datastring ===='+dataString);
            }
        }
           dataString = dataString + ']';
        
    }   
         System.debug('dataString ================='+ dataString);
        setQueues(objectGroup);
        System.debug('Inside displayqueue-------'+objectGroup.size());
        return null;
    }
    
     String columnsString;
     public String getColumnsString(){
        return this.columnsString;
     } 
     String fieldsString;
     public String getFieldsString(){
        return this.fieldsString;
     }
     
     String[] fieldsList;
     public String[] getFieldsList(){
        return this.fieldsList;
     }
  /* To be removed     
    String[] columns;
    String[] fields;
    public String[] getColumns(){ 
        System.debug('Inside getColumns ----'+columns);
        return this.columns;
    }
    public void setColumns(String[] cols){
        this.columns = cols;
    }
    public String[] getFields(){
        System.debug('Inside getFields -----'+fields);
        return this.fields;
    }
    public void setFields(String[] flds){
        this.fields = flds;
    }
    */
    // To get the extjs datagrid columns
    public Pagereference getGridColumns(){
       //String sObjectType = ApexPages.currentPage().getParameters().get('sObjectType');
       String sObjectType = 'Group';
      List<SYSPopupObject__c> sysPopupObj = [select Name,Id  from SYSPopupObject__c where Name=:sObjectType ];
      if(sysPopupObj!= null && sysPopupObj.size()>0){
        List<SYSPopupObjectFields__c> sysPopupObjFields = [select Id, Name, fieldLabel__c,popupObjectId__c from  SYSPopupObjectFields__c where popupObjectId__c=:sysPopupObj[0].Id];
         if(sysPopupObjFields!=null && sysPopupObjFields.size()>0){
            fieldsList= new String[sysPopupObjFields.size()+1];
            fieldsList[0] = 'Id';
            fieldsString='[{name:\'Id\'},';
            columnsString='[{id:\'Id\',header:\'Id\', hidden:true},';
              
            for(Integer i = 0;i<sysPopupObjFields.size();i++){
                  fieldsList[i+1] = sysPopupObjFields[i].Name;
                if(i==sysPopupObjFields.size()-1){
                    fieldsString = fieldsString + '{name:\''+sysPopupObjFields[i].Name+'\'}]';
                    columnsString = columnsString + '{header:\''+sysPopupObjFields[i].fieldLabel__c+'\', sortable:true,width:75,dataIndex:\''+sysPopupObjFields[i].Name+'\'}]';
                    break;
                }               
                else  {
                    fieldsString = fieldsString+ '{name:\''+sysPopupObjFields[i].Name+'\'},';
                    columnsString = columnsString+ '{header:\''+sysPopupObjFields[i].fieldLabel__c+'\', sortable:true,width:75,dataIndex:\''+sysPopupObjFields[i].Name+'\'},';
                    
                    
                }
                
            }            
            System.debug('get Grid columns   ===== '+columnsString);
            System.debug('get Grid felds =========='+fieldsString);
         }
        
      }
     
        return null;
    }
    String grid;
    public String getGrid(){
        return this.grid;
    }
    //To get the grid to be rendered.
    public PageReference buildGrid(){
        
        grid='new Ext.grid.GridPanel({store: new Ext.data.Store({reader:new Ext.data.ArrayReader({},'+fieldsString+'),data:'+dataString+'}),columns:'+columnsString+',listeners:{rowdblclick:function(grid,rowIndex,e){window.returnValue = grid.getSelectionModel().getSelected().get(\'Id\');window.parent.close();}},stripeRows:true,height: 600,viewConfig: {forceFit: true}})';
        System.debug('Inside grid=================='+grid);
        return null;
        
    }
    

}
			                            	