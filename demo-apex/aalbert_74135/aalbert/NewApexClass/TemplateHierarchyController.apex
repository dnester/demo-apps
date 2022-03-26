public class TemplateHierarchyController{

    public String templateHierarchy;
    List<String> key = new List<String>();
    List<String> value = new List<String>();
    List<SelectOption> options;
    
    List<String> outputFields;
    String queryString;
    ConditionBuilder objConditionBuilder;
    DriverAccess objDriverAccess;
    
    Integer optionSize;
    
    SYSTemplate__c template;  
    
    Map<String,String> templateHierarchyMap=new Map<String,String>();
    
    public String getTemplateHierarchy() {
        return templateHierarchy;
    }

    public void setTemplateHierarchy(String templateHierarchy) {
        this.templateHierarchy = templateHierarchy;
    }
    
    public SYSTemplate__c getTemplate(){
       return template;
     }
     
     public Integer getOptionSize(){
       System.debug('dev dfsgdfgdfkljglkd'+optionSize);
       return optionSize;
     }     
    
  public TemplateHierarchyController(){
    template = new SYSTemplate__c();
    outputFields = new List<String>();
      objConditionBuilder = new ConditionBuilder();
      objDriverAccess = new DriverAccess();      
      
      options = new List<SelectOption>();
      String templateFor = Apexpages.currentPage().getParameters().get('templateFor');
      if(templateFor == 'Incident'){
        template.templateFor__c = 'Incident';
      }if(templateFor == 'Task'){
        template.templateFor__c = 'Task';
      }
      
    }
    
    public Pagereference clearList(){
      value.clear();
      key.clear();
      options.clear();
      return null;
    }
    
    public void dummy(){}  
     
    public List<SelectOption> getTemplateHierarchyFields(){
        
       if(value.size()==0){
      
        if(template.templateFor__c != null && template.templateFor__c != ''){
          
          
          outputFields.clear();
          outputFields.add('ID');
          outputFields.add('Name');
          outputFields.add('orderNumber__c');
          outputFields.add('templateFor__c');        
          
          queryString = 'templateFor__c = '+'\''+template.templateFor__c + '\' Order by orderNumber__c ASC';
          
          objConditionBuilder.setCondition(queryString);
          
          List<SYSTemplate__c> templateList = (List<SYSTemplate__c>)objDriverAccess.selectObjects(new SYSTemplate__c(), outputFields, objConditionBuilder, null);
          
            if(templateList.size() > 0){
              integer i=0;
              for(SYSTemplate__c template : templateList){
                //options.add(new SelectOption(template.ID,template.Name));
                options.add(new SelectOption(''+i,template.Name));
                value.add(template.Name);
                key.add(''+i);
                i++;
              }  
            }
        }
      }else{
        options.clear();
       for(integer i=0; i<value.size();i++){
         options.add(new SelectOption(key.get(i),value.get(i)));
       }
      }
      optionSize = options.size();
      
      return options;
    }
    
    public PageReference ScrollUp(){
         if(value.size()!=0){
             system.debug('hiiiiiiiiiiii '+ templateHierarchy);
                for(integer i=0; i<value.size();i++){
                    system.debug('hiiiiiiiiiiii '+ value.size()+'      '+i);
                    if(i>0 && key.get(i)==templateHierarchy){
                        system.debug('before   '+ value.get(i)+'      '+value.get(i-1));
                        String temp=value.get(i-1);
                        String tempKey=key.get(i-1);
                        key.set(i-1,templateHierarchy);
                        key.set(i, tempKey);
                        value.set(i-1, value.get(i));
                        value.set(i, temp);
                        system.debug('before   '+ value.get(i)+'      '+value.get(i-1));
                    }
                }
         }  
        return null;
    }
    public PageReference ScrollDown(){
         if(value.size()!=0){
             system.debug('hiiiiiiiiiiii '+ templateHierarchy);
                for(integer i=0; i<value.size();i++){
                    if(i<value.size()-1 && key.get(i)==templateHierarchy){
                        system.debug('before   '+ value.get(i)+'      '+value.get(i+1));
                        String temp=value.get(i+1);
                        String tempKey=key.get(i+1);
                        key.set(i+1,templateHierarchy);
                        key.set(i, tempKey);
                        value.set(i+1, value.get(i));
                        value.set(i, temp);
                        
                        system.debug('before   '+ value.get(i)+'      '+value.get(i+1));
                        break;
                    }
                }
         }  
        return null;
    }
    
    public PageReference SaveUHierarchy(){
      List<SYSTemplate__c> modifiedTemplateList = new list<SYSTemplate__c>();      
      System.debug('##################');
        if(template.templateFor__c != null && template.templateFor__c != ''){
                    
        outputFields.clear();
        outputFields.add('ID');
        outputFields.add('Name');
        outputFields.add('orderNumber__c');
        outputFields.add('templateFor__c');        
        
        for(integer i=0;i<value.size();i++){
          
          queryString = 'templateFor__c = '+'\''+template.templateFor__c + '\' AND Name = '+'\''+ value[i]+'\'';                
          objConditionBuilder.setCondition(queryString);
          
          List<SYSTemplate__c> templateList = (List<SYSTemplate__c>)objDriverAccess.selectObjects(new SYSTemplate__c(), outputFields, objConditionBuilder, null);
          
          if(templateList.size() > 0){
            templateList[0].orderNumber__c = i+1;
            modifiedTemplateList.add(templateList[0]);
            //modifiedTemplateList[i].orderNumber__c = i+1;
          }
        }
        
        for(SYSTemplate__c tempTemplate : modifiedTemplateList){
          System.debug('@@@@@@@@@@@@@  Template  : '+ tempTemplate.Name +' (tempTemplate.orderNumber__c) @@@@@@@@@ : '+tempTemplate.orderNumber__c);
        }
        objDriverAccess.updateObject(modifiedTemplateList, null, null);        
        }
          String urgencyProperty='';        
        for(integer i=0;i<value.size();i++){
          if(urgencyProperty==''){
            urgencyProperty=urgencyProperty+value[i];
          }else{
            urgencyProperty=urgencyProperty+';'+value[i];
          }
        }
        system.debug('@@@@@@@@@@@@@  urgencyProperty  @@@@@@@@@ : '+urgencyProperty);
       
        /*for(integer i=0;i<value.size();i++){
            for(integer j=0;j<value.size();j++){
                if(uregencyObj[i].Type__c==value.get(j)){
                    j=j+2;
                    uregencyObj[i].Order__c=''+j;
                }
            }
            
        }*/
        
        return null;
    }   
      
      
}
			                            	