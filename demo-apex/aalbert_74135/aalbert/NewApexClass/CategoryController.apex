public class CategoryController
 {                         
    
    public Category__c category = new Category__c();
    String categoryType;
    String parentCategory;
    String urgency;
    String copyId;
    public String categoryId{get; set; }
    String columnName='Name';
    String direction= 'ASC';
    public String tempString {get; set;}
    public List<Category__c> categorryList;
    public List<CategoryTypes__c> CategoryTypesList;
    public List<Urgency__c> urgencysList;
    DriverAccess objDriverAccess;
    public String messageString {get; set;}
    String catTypeId;
    public List<Category__c> categorysList = new List<Category__c>();
    public Boolean chkBoxValue{get; set;} 
    
    public CategoryController(){        
         DriverAccess   driverAccess = new DriverAccess();
         ConditionBuilder conditionBuilder = new ConditionBuilder();
         
         categoryId= Apexpages.currentPage().getParameters().get('id');    
         columnName = ApexPages.CurrentPage().getParameters().get('columnField');
         direction = ApexPages.CurrentPage().getParameters().get('direction'); 
         copyId= Apexpages.currentPage().getParameters().get('copyId');   
         catTypeId = Apexpages.currentPage().getParameters().get('CategoryTypesid');
         
         //Changes for Adding Child Cat when added from Cat details
              //Changes made by Sujeet
              String category_Id = ApexPages.CurrentPage().getParameters().get('Categoryid');
              category.FKParentCategory__c = category_Id;
              List<Category__c> lstcategory;
              if(category_Id != null && category_Id != ''){
                String qryString = 'Id = '+'\''+category_Id+'\'';
                conditionBuilder.setCondition(qryString);
                lstcategory= (List<Category__c>)driverAccess.selectObjects(new Category__c(), null, conditionBuilder, null);
                category.parentCategoryId__c = lstcategory[0].Name;
              }
             //Changes Ends here//
         
         List<CategoryTypes__c> lstCat;
          if(catTypeId != null && catTypeId != ''){
            String qryString = 'Id = '+'\''+catTypeId+'\'';
            conditionBuilder.setCondition(qryString);
            lstCat = (List<CategoryTypes__c>)driverAccess.selectObjects(new CategoryTypes__c(), null, conditionBuilder, null);
            category.categoryTypeId__c = lstCat[0].Name;
          }
         if(((categoryId != null) && (categoryId != ''))  || (copyId !=null && copyId != '')){     
          
         List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');    
        lstOutputFields.add('categoryDescription__c');
        lstOutputFields.add('inactive__c');    
        lstOutputFields.add('requireFollowUp__c');    
        lstOutputFields.add('followUpAfter__c'); 
        lstOutputFields.add('categoryTypeId__c');  
        lstOutputFields.add('parentCategoryId__c');
        lstOutputFields.add('urgencyID__c');
    
         String queryString = '';
        if((copyId !=null && copyId != '')){
            queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
            queryString='Id =' +'\''+categoryId+'\'';  
         }

        ConditionBuilder objConditionBuilder = new ConditionBuilder();

        objDriverAccess = new DriverAccess();
       
        objConditionBuilder.setCondition(queryString);
              List<Category__c> categorysList= (List<Category__c>) objDriverAccess.selectObjects(category,lstOutputFields,objConditionBuilder,null); 
            
                if((categorysList.size() >0 ) && (copyId !=null && copyId != '')){
                    category = categorysList[0];
                    copy();
                    
                }else if(categorysList.size() >0){
                    category = categorysList[0];
                }else {
                    category = new Category__c();
                }
        
        }
    }
   
    public String getCategoryType(){

        return this.categoryType;

    }
    
    public void setCategoryType(String categoryType){

        this.categoryType = categoryType;

    }
    
    public void setParentCategory(String parentCategory){

        this.parentCategory= parentCategory;

    }
    
    public String getParentCategory(){

        return parentCategory;
    }
    
    public void setUrgency(String urgency){

        this.urgency = urgency;

    }
    
    public String getUrgency(){

        return urgency;
    }
    
   public Category__c getCategory() {
        return category;
    }
    
    public void setCategory(Category__c category){
        this.category= category;
    }

   public PageReference save() {      
      category.inactive__c=chkBoxValue;
     try{
         if(category.categoryTypeId__c != null ){
              CategoryTypesList= [select id,name from CategoryTypes__c where Name=:category.categoryTypeId__c]; // category.Seq_Client__c ];
              if(CategoryTypesList.size() > 0){
              category.FKCategoryType__c = CategoryTypesList[0].id ;        
            }  
          }
             
         if(category.parentCategoryId__c != null ){ 
              categorryList= [select id,Name from Category__c where Name =:category.parentCategoryId__c];
              if(categorryList.size()> 0){
              category.FKParentCategory__c = categorryList[0].id ;        
            } 
          }
    
         if(category.urgencyID__c != null ){         
              urgencysList= [select id,Name from Urgency__c where Name =:category.urgencyID__c];
              if(urgencysList.size()> 0){
              category.FKUrgency__c = urgencysList[0].id ;        
            }
           }
           
         /* if(category.Id!= null)
           {
               objDriverAccess.updateObject(category,null,null);
           }else{
               objDriverAccess.insertObject(category,null);
           }*/
           
          if(category.categoryTypeId__c == null ||category.categoryTypeId__c =='')
             category.FKCategoryType__c=null;
                  
       if(category.parentCategoryId__c == null ||category.parentCategoryId__c =='')
             category.FKParentCategory__c=null;
                  
       if(category.urgencyID__c == null ||category.urgencyID__c =='')
             category.FKUrgency__c=null;
             
             
          if(category.Id!= null)
           upsert category;
           else 
           insert category;  
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

    public PageReference cancel() {
        return null;
    }   
    
    public PageReference newCategory() {
    
        PageReference page =new PageReference('/apex/CategoryPage').setRedirect(true);
        return page;
    }
    
       
    public PageReference categoryTypeQuery(){
        
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('ID');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+categoryType+'\'';
        
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
        CategoryTypes__c categoryTypes = new CategoryTypes__c();
        
        DriverAccess objDriverAccess = new DriverAccess();
        List<CategoryTypes__c> categoryTypeList= (List<CategoryTypes__c>) objDriverAccess.selectObjects(categoryTypes,lstOutputFields,objConditionBuilder,null); 
        if(categoryTypeList.size() >0){
            category.categoryTypeId__c = categoryTypeList[0].Name;
        }
                
        return null;
    }
    
    public PageReference parentCategoryQuery(){
        
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('ID');
        lstOutputFields.add('Name');
        
        String queryString = 'Id =' +'\''+parentCategory+'\'';        
         
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
        Category__c parentCategorys = new Category__c();
        
        DriverAccess objDriverAccess = new DriverAccess();
        List<Category__c> categoryList= (List<Category__c>) objDriverAccess.selectObjects(parentCategorys,lstOutputFields,objConditionBuilder,null); 
        if(categoryList.size() >0){
        category.parentCategoryId__c = categoryList[0].Name; 
                   
        }                
        return null;
    }

  
        public PageReference urgencyQuery(){
        
        List<String> lstOutputFields = new List<String>();
    
        lstOutputFields.add('ID');
        lstOutputFields.add('Name');        
        String queryString = 'Id =' +'\''+urgency+'\'';       
       
        ConditionBuilder objConditionBuilder = new ConditionBuilder();
        
        objConditionBuilder.setCondition(queryString);    
    
        Urgency__c urgencys = new Urgency__c();
        
        DriverAccess objDriverAccess = new DriverAccess();
        List<Urgency__c> urgencyList= (List<Urgency__c>) objDriverAccess.selectObjects(urgencys,lstOutputFields,objConditionBuilder,null); 
        if(urgencyList.size() >0){
        category.urgencyID__c = urgencyList[0].Name;         
        }
                
        return null;
    }   
    
    public Pagereference deleteCategory(){

            if(category !=null && category.Id !=null){
                ConditionBuilder objConditionBuilder = new ConditionBuilder();
                String queryString='Id =' +'\''+category.Id+'\''; 
                objDriverAccess = new DriverAccess(); 
                objConditionBuilder.setCondition(queryString);
                objDriverAccess.deleteObject(category, objConditionBuilder, null);
             
            }
            return null;
       }   
       
   public void copy(){     
        Category__c tempCategory= category.clone(false,true);
        category = tempCategory;
        category.name =null;
    }
     public Pagereference clear(){     
        category =null;
        category = new Category__c();
         return null;
    }
      public Pagereference reset(){     
                
           
         
         categoryId= Apexpages.currentPage().getParameters().get('id');    
        
         if(((categoryId != null) && (categoryId != '')) ){     
          
             List<String> lstOutputFields = new List<String>();
        
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');    
            lstOutputFields.add('categoryDescription__c');
            lstOutputFields.add('inactive__c');    
            lstOutputFields.add('requireFollowUp__c');    
            lstOutputFields.add('followUpAfter__c'); 
            lstOutputFields.add('categoryTypeId__c');  
            lstOutputFields.add('parentCategoryId__c');
            lstOutputFields.add('urgencyID__c');
        
            String queryString='Id =' +'\''+categoryId+'\'';  
    
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
    
            objDriverAccess = new DriverAccess();
           
            objConditionBuilder.setCondition(queryString);
            List<Category__c> categorysList= (List<Category__c>) objDriverAccess.selectObjects(category,
                                                                            lstOutputFields,objConditionBuilder,null); 
            if(categorysList.size() >0){
                category = categorysList[0];
            }else {
                category = new Category__c();
            }
            
         }
    
        return null;
    }

public Pagereference previousBtnHandler(){
        if(category!=null){
            CommonUI commonUiObj=new CommonUI();
            category = (Category__c)commonUiObj.getSobject(category, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(category!=null){
            CommonUI commonUiObj=new CommonUI();
            category = (Category__c)commonUiObj.getSobject(category, tempString, columnName, direction, 'next');
        }
        return null;
    }
}
			                            	