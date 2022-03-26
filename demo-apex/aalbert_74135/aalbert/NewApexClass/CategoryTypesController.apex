public class CategoryTypesController {

    public CategoryTypes__c categoryTypes;
    public String categoryTypeId{get; set; }
  String columnName='Name';
    String direction= 'ASC';
    public String tempString {get; set;}
    
    public List<CategoryTypes__c> categoryTypesList = new List<CategoryTypes__c>();
    DriverAccess objDriverAccess;
    public String messageString {get; set;}
    String copyId ;
    public CategoryTypesController(){ 
          
         categoryTypeId = Apexpages.currentPage().getParameters().get('id');  
     columnName = ApexPages.CurrentPage().getParameters().get('columnField');
         direction = ApexPages.CurrentPage().getParameters().get('direction');          
         copyId = Apexpages.currentPage().getParameters().get('copyId');              
         categoryTypes = new CategoryTypes__c();
         
         if(((categoryTypeId != null) && (categoryTypeId != '')) || (copyId !=null && copyId != '')){
           
          List<String> lstOutputFields = new List<String>();       
          lstOutputFields.add('Name');    
          lstOutputFields.add('description__c');
          lstOutputFields.add('inactive__c');    
         
          String queryString = '';
        if((copyId !=null && copyId != '')){
          queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
            queryString='Id =' +'\''+categoryTypeId+'\''; 
         }
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
           List<CategoryTypes__c> categoryTypesList = (List<CategoryTypes__c>) objDriverAccess.selectObjects(categoryTypes,lstOutputFields,objConditionBuilder,null); 
         
              if((categoryTypesList.size() >0 ) && (copyId !=null && copyId != '')){
                  categoryTypes = categoryTypesList[0];
                  copy();
                  
            }else if(categoryTypesList.size() >0){
              categoryTypes = categoryTypesList[0];
              }else {
                categoryTypes = new CategoryTypes__c();
              } 
      }
     } 

    public CategoryTypes__c getCategoryTypes() {
        return categoryTypes;
    }
    public void setCategoryTypes(CategoryTypes__c categoryTypes){
        this.categoryTypes= categoryTypes;
    }

   public PageReference save() {
       
   /*     if(categoryTypes.Id!= null)
       {
           objDriverAccess.updateObject(categoryTypes,null,null);
       }else{
           objDriverAccess.insertObject(categoryTypes,null);
       }      */             
        //insert categoryTypes;
        
       try{ 
         if(categoryTypes.Id!= null)
             upsert categoryTypes;
         else 
             insert categoryTypes;
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

  public PageReference newCategoryTypes() {
    
        PageReference page =new PageReference('/apex/CategoryTypesPage').setRedirect(true);
        return page;
    }
  
  public PageReference clear() {
      categoryTypes = null;
      categoryTypes = new CategoryTypes__c();
        return null;
    }
  
  
  public PageReference deleteCategoryTypes(){
            System.debug('---------------------deleteCategoryTypes()---------------');
              if(categoryTypes !=null && categoryTypes.Id !=null){
                System.debug('---------------------categoryTypes !=null && categoryTypes.Id !=null---------------');
                ConditionBuilder objConditionBuilder = new ConditionBuilder();
                String queryString='Id =' +'\''+categoryTypes.Id+'\'';  
                objDriverAccess = new DriverAccess(); 
                objConditionBuilder.setCondition(queryString);
                objDriverAccess.deleteObject(categoryTypes, objConditionBuilder, null);
                System.debug('---------------------queryString---------------' + categoryTypes.Id);
            }
            
          categoryTypeId = null;  
          copyId =null;
          return null;
                
            
    } 
    
      public void copy(){     
           CategoryTypes__c tempCategoryTypes= categoryTypes.clone(false,true);
          categoryTypes = tempCategoryTypes;
           categoryTypes.name = null;
    }
    
      public PageReference reset() {
       
          
         categoryTypeId = Apexpages.currentPage().getParameters().get('id');  
         categoryTypes = new CategoryTypes__c();
         
         if(((categoryTypeId != null) && (categoryTypeId != ''))){
           
          List<String> lstOutputFields = new List<String>();       
          lstOutputFields.add('Name');    
          lstOutputFields.add('description__c');
          lstOutputFields.add('inactive__c');    
         
          String queryString='Id =' +'\''+categoryTypeId+'\''; 
         
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();
        objConditionBuilder.setCondition(queryString);    
          objDriverAccess = new DriverAccess();
         
          List<CategoryTypes__c> categoryTypesList = (List<CategoryTypes__c>) objDriverAccess.selectObjects(categoryTypes,lstOutputFields,objConditionBuilder,null); 
         if(categoryTypesList.size() >0){
              categoryTypes = categoryTypesList[0];
         }else {
                categoryTypes = new CategoryTypes__c();
         } 
      }
     

        return null;
    }
     /* public PageReference copyCategoryTypes() {
        
        CategoryTypes__c tempcategoryTypes = categoryTypes ;         
            
            categoryTypes = new CategoryTypes__c();           
            
            categoryTypes.Name = tempcategoryTypes.Name;
            categoryTypes.description__c = tempcategoryTypes.description__c;
            categoryTypes.inactive__c = tempcategoryTypes.inactive__c;       
            return null;      
    }*/

  public Pagereference previousBtnHandler(){
        if(categoryTypes!=null){
          CommonUI commonUiObj=new CommonUI();
            categoryTypes = (CategoryTypes__c)commonUiObj.getSobject(categoryTypes, tempString, columnName, direction, 'previous');
        }
        return null;
    }
    public Pagereference nextBtnHandler(){
        if(categoryTypes!=null){
            CommonUI commonUiObj=new CommonUI();
            categoryTypes = (CategoryTypes__c)commonUiObj.getSobject(categoryTypes, tempString, columnName, direction, 'next');
        }
        return null;
    }    
}
			                            	