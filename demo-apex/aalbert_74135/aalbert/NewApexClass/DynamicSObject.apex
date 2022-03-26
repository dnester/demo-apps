public class DynamicSObject {
  public DynamicSObject(){}

  private List<Field> fields;
  private final SObject delegate;
  public List<String> headers {get; set;}
  public List<String> flds {get; set;}

    public List<DynamicSObject> getList(List<SObject> sObjects, List<String> cols){
        List<DynamicSObject> resultSet = new List<DynamicSObject>();
        if(sObjects!=null){
            for(SObject so:sObjects){
                resultSet.add(new DynamicSObject(so, cols));
            }
        }
        return resultSet;
    }    

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
    //Add Id byDefault if Id is not the first field to select
    /*if(flds.get(0).toLowerCase()!='id'){
      Field field = new Field();
      field.name='ID'; field.label='ID'; field.value=getId();
      fields.add(field);
    }*/    
    
    for (String fld : flds) {
      try {
        fld=fld.trim().toLowerCase();                        
        //if(fld.indexOf('__r')<>-1) fld=fld.substring(0, fld.indexof('__r'))+'__c';
        Field field = new Field();
        field.name=fld;        
        field.label='.'+fld;
        field.label=field.label.substring(field.label.lastIndexOf('.')+1).replace('__c', '').replace('_', ' ');
        field.value=String.valueOf(delegate.get(fld));
        if(field.value==null)
          field.value='';
        field.value=field.value.replace('\r','').replace('\n','
');//.replace('\"','\\\"""')                    
        fields.add(field);
        //headers.add(field.label);
      } catch (System.SObjectException x) {
        // Do nothing - just means that the field was not selected in the select list
      }
    }
  }
  private Schema.DescribeSObjectResult getDescribe() {
    return delegate.getSObjectType().getDescribe();
  }
    
    public class Field {
        public String name {get; set;}
        public String label {get; set;}
        public String value {get; set;}
    }
}
			                            	