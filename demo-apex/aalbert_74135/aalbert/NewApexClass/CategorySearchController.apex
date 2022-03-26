public class CategorySearchController {

    public PageReference selctStandardResolution() {
        return null;
    }
    public JsonNode root;
    Category__c category {get; set;}
    List<Category__c> categoryList;
    List<String> listOutputFields= new List<String>();
    String categoryId;
    String descriptionId;
    public List<StandardDescription__c> descriptionList{ get; set;}
    public List<StandardResolution__c> resolutionList{ get; set;}
    StandardDescription__c stdDescription;
    StandardResolution__c stdResolution;
    public DriverAccess objDriverAccess = new DriverAccess();
    public ConditionBuilder objConditionBuilder = new ConditionBuilder();
    public String queryString;
    public String selectedResolution{ get; set;}
    public String selectedDescription{ get; set;}
    String[] selectDescRes = new String[]{};
    String objDescription{ get; set;}
    String objResolution{ get; set;}
    public String getObjDescription(){
    
        return objDescription;
    }
    public void setObjDescription(String objDescription){
    
        this.objDescription=objDescription;
    }
    
    public String getObjResolution(){
    
        return objResolution;
    }
    public void setObjResolution(String objResolution){
    
        this.objResolution=objResolution;
    }
    public void CategorySearch(){
        objDescription='Standard Description';
        objResolution='Standard Resolution';
    
    }
    
    
    public void setSelectDescRes(String[] selectDescRes){
    
        this.selectDescRes = selectDescRes;
    }
    
    public String[] getSelectDescRes(){
    
       return selectDescRes;
    }
    
    
    public String getCategories() {
          root = new JsonNode();
            boolean firstNodeFound = false;
            map<String, JsonNode> nodeMap = new map<String, JsonNode>();
            Category__c[] navNodes = [Select id, c.Name,c.FKParentCategory__c ,c.FKParentCategory__r.Name From Category__c c order by c.FKParentCategory__c];
            if(navNodes != null && navNodes.size() > 0){
                for(Category__c item : navNodes ){
                    JsonNode node = new JsonNode();
                    node.text = item.name;
                    
                    if(!firstNodeFound){
                       node.expanded = true; 
                       firstNodeFound = true;
                    }
                    if(item.FKParentCategory__c != null){
                        JSonNode parentnode = nodeMap.get(item.FKParentCategory__c);
                        if (parentnode != null) {
                            parentnode.addChild(node);
                            parentnode.leaf = false;
                        }
                    }else{
                        root.addChild(node);
                    }
                    nodeMap.put(item.id, node);
                }
        }
        return root.getJsonChildArrayString();
    }
    
   
    public PageReference diasplayStandardDescriptions() {
        
        if(resolutionList!=null)
            resolutionList.clear();
        
        categoryId=System.currentPageReference().getParameters().get('paramId');
        System.debug('>>>>>>>>>>>>>>>>>>>> categoryId : '+categoryId);
        stdDescription= new StandardDescription__c();
        
        listOutputFields.clear();
        
        listOutputFields.add('Id');
        listOutputFields.add('Name');
        listOutputFields.add('description__c');
        listOutputFields.add('FKCategory__r.Name');
      
        queryString='FKCategory__r.Name=' +'\''+categoryId+'\'';
        objConditionBuilder.setCondition(queryString);
        
        descriptionList= (List<StandardDescription__c>)objDriverAccess.selectobjects(stdDescription,listOutputFields,objConditionBuilder,null);
         
      
        return null;
    }
    
    
    
     public List<StandardDescription__c> getStandardDescriptions() {
        return descriptionList;
    }
    
    
    public PageReference diasplayStandardResolutions(){
        
        descriptionId=System.currentPageReference().getParameters().get('descriptionID');
        stdResolution= new StandardResolution__c();
        
        listOutputFields.clear();
        
        listOutputFields.add('Id');
        listOutputFields.add('Name');
        listOutputFields.add('resolution__c');
              
        queryString='FKStandardDescription__r.Name=' +'\''+descriptionId+'\'';
        objConditionBuilder.setCondition(queryString);
        
        resolutionList= (List<StandardResolution__c>)objDriverAccess.selectobjects(stdResolution,listOutputFields,objConditionBuilder,null);
      
       return null;
    }
    

}
			                            	