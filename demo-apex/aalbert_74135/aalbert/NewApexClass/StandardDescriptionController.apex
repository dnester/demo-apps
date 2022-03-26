public class StandardDescriptionController {
    
    public String savedId = null;
    public StandardDescription__c standardDescription {get; set;}
    public List <StandardDescription__c> discriptionList{get; set;}
    public DriverAccess objDriverAccess = new DriverAccess();
    public ConditionBuilder objConditionBuilder = new ConditionBuilder();
    public List<String> lstOutputFields = new List<String>();
    public Category__c category = new Category__c();
    public List<Category__c> categoryList = new List<Category__c>();
    public String id{get; set;}
    public String messageString {get; set;}
    String columnName='Name';
    String direction= 'ASC';  
    public String tempString {get; set;}   

    public StandardDescriptionController(){
      ConditionBuilder objConditionBuilder = new ConditionBuilder();
      objDriverAccess = new DriverAccess();
        id=Apexpages.currentPage().getParameters().get('id');
    columnName = ApexPages.CurrentPage().getParameters().get('columnField');
        direction = ApexPages.CurrentPage().getParameters().get('direction');
        String copyId=Apexpages.currentPage().getParameters().get('copyId');
        standardDescription= new StandardDescription__c();
        
        //Changes for Adding Child Cat when added from Cat details
             //Changes made by Sujeet
            String category_Id = ApexPages.CurrentPage().getParameters().get('Categoryid');
            standardDescription.FKCategory__c = category_Id;
            List<Category__c> lstcategory;
            if(category_Id != null && category_Id != ''){
              String qryString = 'Id = '+'\''+category_Id+'\'';
            objConditionBuilder.setCondition(qryString);
            lstcategory= (List<Category__c>)objDriverAccess.selectObjects(new Category__c(), null, objConditionBuilder, null);
            standardDescription.categoryId__c = lstcategory[0].Name;
            }
             //Changes Ends here//
        
        
        if((id != null) || (copyId !=null && copyId != '')) {
            lstOutputFields.clear();
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('description__c');
            lstOutputFields.add('FKCategory__r.Name');
            lstOutputFields.add('FKCategory__r.categoryDescription__c');
            lstOutputFields.add('categoryId__c');
            lstOutputFields.add('inactive__c');
            
              String queryString = '';
         if((copyId !=null && copyId != '')){
          queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
           queryString='Id =' +'\''+id+'\'';
         }
            
            
        objConditionBuilder.setCondition(queryString);    
          
         
          discriptionList = (List<StandardDescription__c>) objDriverAccess.selectObjects(standardDescription,lstOutputFields,objConditionBuilder,null);            
            
              if((discriptionList.size() >0 ) && (copyId !=null && copyId != '')){
                  standardDescription = discriptionList[0];
                  copy();
                  
            }else if(discriptionList.size() >0){
              standardDescription = discriptionList[0];
              }else {
                standardDescription = new StandardDescription__c();
              } 
              
              if(standardDescription.FKCategory__c != null){
                categoryList = getCategoryList (standardDescription.FKCategory__c);
                if(categoryList.size()>0)
                  category = categoryList[0];
              }
         }
        
          
            
    }
    
    public List<Category__c> getCategoryList (String catId) {
       
       lstOutputFields.clear();
        category = new Category__c();
        
        if(catId != null) {
           lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('categoryDescription__c');
            String queryString='Id =' +'\''+catId+'\'';
            objConditionBuilder.setCondition(queryString);
            categoryList = (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null);            
            
         }
        
      return categoryList;
    }


    public Category__c  getCategory(){
        return category ;
    }
    
    public PageReference save(){
        try{
            lstOutputFields.clear();
            category = new Category__c();
             
            if(standardDescription.categoryId__c != null) {
                
                lstOutputFields.add('Id');
                lstOutputFields.add('Name');
                lstOutputFields.add('categoryDescription__c');
                String queryString='Name =' +'\''+standardDescription.categoryId__c+'\'';
                objConditionBuilder.setCondition(queryString);
            
                categoryList = (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null);            
                if(categoryList.size() > 0){
                    category = categoryList[0];
                    standardDescription.FKCategory__c = categoryList[0].Id;
                    
                 }
              
             }
             if(standardDescription.categoryId__c == null ||standardDescription.categoryId__c =='')
               standardDescription.FKCategory__c=null;
               
             if(standardDescription.Id == null ){
                  objDriverAccess.insertObject(standardDescription, null);}
             else
             {
                objDriverAccess.updateObject(standardDescription,null,null);
             }
           
             id=standardDescription.Id;
             if(id != null) {
                    standardDescription= new StandardDescription__c(); 
                    lstOutputFields.clear();
                    lstOutputFields.add('Id');
                    lstOutputFields.add('Name');
                    lstOutputFields.add('description__c');
                    lstOutputFields.add('FKCategory__r.Name');
                    lstOutputFields.add('FKCategory__r.categoryDescription__c');
                    lstOutputFields.add('categoryId__c');
                    lstOutputFields.add('inactive__c');
                    
                    String queryString='Id =' +'\''+id+'\'';
                    objConditionBuilder.setCondition(queryString);
    
                    discriptionList = (List<StandardDescription__c>) objDriverAccess.selectObjects(standardDescription,lstOutputFields,objConditionBuilder,null);            
                
                    if(discriptionList.size() > 0){
                       standardDescription = discriptionList[0];
                     }
                }
                
             messageString = validationHelper.getSavedMessage();
             
        }catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
            }  else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
            } 
       }

        return null;
    }
    
    
     public PageReference deleteSTDDescription(){
     if(standardDescription !=null && standardDescription.Id !=null){
              ConditionBuilder objConditionBuilder = new ConditionBuilder();
              String queryString='Id =' +'\''+standardDescription.Id+'\'';  
              objConditionBuilder.setCondition(queryString);
              objDriverAccess.deleteObject(standardDescription, objConditionBuilder, null);
            }
        return null;

    }
    
    public PageReference newStdDescription(){
        standardDescription= new StandardDescription__c();
        category= new Category__c();
        
        return null;
    }
    
    public String  getSavedID(){
        return savedID ;
    }
    
    public void setSavedID(String  savedID){
        this.savedID = savedID;
    }
    
    public PageReference categoryQuery () {
        
       lstOutputFields.clear();
        category = new Category__c();
        
        if(savedId != null) {
           lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('categoryDescription__c');
            String queryString='Id =' +'\''+savedId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            categoryList = (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null);            
           
            if(categoryList.size() > 0){
                category = categoryList[0];
               // standardDescription.FKCategory__c = categoryList[0].Id;
                standardDescription.categoryId__c = categoryList[0].Name;
                
             }
            
         }
       
           
      return null;
    }
   
      public void copy(){     
           StandardDescription__c tempStandardDescription = standardDescription.clone(false,true);
          standardDescription = tempStandardDescription;
    }

  public Pagereference previousBtnHandler(){
        if(standardDescription!=null){
            CommonUI commonUiObj=new CommonUI();
            standardDescription = (StandardDescription__c)commonUiObj.getSobject(standardDescription, tempString, columnName, direction, 'previous');
            categoryList=getCategoryList(standardDescription.FKCategory__c);
      if(categoryList.size() > 0){
               category=categoryList[0];
        }
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(standardDescription!=null){
            CommonUI commonUiObj=new CommonUI();
            standardDescription = (StandardDescription__c)commonUiObj.getSobject(standardDescription, tempString, columnName, direction, 'next');
            categoryList=getCategoryList(standardDescription.FKCategory__c);
            if(categoryList.size() > 0){
               category=categoryList[0];
        }
        }
        return null;
    }
  public PageReference clear() {
    standardDescription = null;
        standardDescription = new StandardDescription__c();
      return null;
    }
    public PageReference resetStdDesc() {
      if(standardDescription != null && standardDescription.id != null){
        id = standardDescription.id +'';
          standardDescription= new StandardDescription__c();
          if((id != null)&& id != '') {
            
              lstOutputFields.clear();
              lstOutputFields.add('Id');
              lstOutputFields.add('Name');
              lstOutputFields.add('description__c');
              lstOutputFields.add('FKCategory__r.Name');
              lstOutputFields.add('FKCategory__r.categoryDescription__c');
              lstOutputFields.add('categoryId__c');
              lstOutputFields.add('inactive__c');
              
              String queryString='Id =' +'\''+id+'\'';
              
              ConditionBuilder objConditionBuilder = new ConditionBuilder();
          objConditionBuilder.setCondition(queryString);    
            objDriverAccess = new DriverAccess();
           
            discriptionList = (List<StandardDescription__c>) objDriverAccess.selectObjects(new StandardDescription__c(),lstOutputFields,objConditionBuilder,null);            
              
             if(discriptionList.size() >0){
            standardDescription = discriptionList[0];
              }else {
                 standardDescription = new StandardDescription__c();
              } 
           }
      }
      return null;
  }
}
			                            	