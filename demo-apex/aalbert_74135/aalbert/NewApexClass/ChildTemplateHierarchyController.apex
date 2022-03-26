public class ChildTemplateHierarchyController{

    public String templateHierarchy;
    List<String> key = new List<String>();
    List<String> value = new List<String>();
    List<SelectOption> options;
    
    public Map<String, SYSTemplateLink__c> linkTemplatemap = new Map<String, SYSTemplateLink__c>(); 
    
    List<String> outputFields;
    String queryString;
    ConditionBuilder objConditionBuilder;
    DriverAccess objDriverAccess;
    
    String parentTemplateId;
    SYSTemplate__c sysTemplate;
    
    Map<String,String> templateHierarchyMap=new Map<String,String>();
    
    public String getTemplateHierarchy() {
        return templateHierarchy;
    }
    
    public void setTemplateHierarchy(String templateHierarchy) {
        this.templateHierarchy = templateHierarchy;
    }
    
    public String getParentTemplateId() {
        return parentTemplateId;
    }
    
    public ChildTemplateHierarchyController(){
        
        sysTemplate = new SYSTemplate__c();
        outputFields = new List<String>();
        objConditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
        parentTemplateId = Apexpages.currentPage().getParameters().get('parentTemplateId');
        
        options = new List<SelectOption>();
        
        getTemplateHierarchyFields();
    }
    
    public Pagereference clearList(){
        value.clear();
        key.clear();
        options.clear();
        return null;
    }  
       
    public List<SelectOption> getTemplateHierarchyFields(){
        
         if(value.size()==0){
        
            if(parentTemplateId != null && parentTemplateId != ''){
              
                outputFields.clear();                
                outputFields.add('Name');
                outputFields.add('linkedTemplateId__c');
                outputFields.add('linkedTemplateId__r.Name');                         
                
                queryString = 'parentTemplateId__c = '+'\''+parentTemplateId+ '\' order by orderNumber__c';
                
                objConditionBuilder.setCondition(queryString);
                
                List<SYSTemplateLink__c> sysTemplateLinkList = (List<SYSTemplateLink__c>)objDriverAccess.selectObjects(new SYSTemplateLink__c(), outputFields, objConditionBuilder, null);
                
                if(sysTemplateLinkList.size() > 0){
                    integer i=0;
                    for(SYSTemplateLink__c sysTemplateLink : sysTemplateLinkList){
                      linkTemplatemap.put(sysTemplateLink.linkedTemplateId__r.Name, sysTemplateLink);
                        //options.add(new SelectOption(template.ID,template.Name));                       
                        options.add(new SelectOption(''+i,sysTemplateLink.linkedTemplateId__r.Name));
                        value.add(sysTemplateLink.linkedTemplateId__r.Name);
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
        List<SYSTemplateLink__c> modifiedTemplateLinkList = new list<SYSTemplateLink__c>();     
        
        if(parentTemplateId != null && parentTemplateId != ''){
                        
            for(integer i=0;i<value.size();i++){
        linkTemplatemap.get(value[i]).orderNumber__c = i+1;
            }
            
            /*for(SYSTemplate__c tempTemplate : modifiedTemplateList){
                System.debug('@@@@@@@@@@@@@  Template  : '+ tempTemplate.Name +' (tempTemplate.orderNumber__c) @@@@@@@@@ : '+tempTemplate.orderNumber__c);
            }*/
            if((linkTemplatemap.values()).size() > 0){
              objDriverAccess.updateObject(linkTemplatemap.values(), null, null);
            }         
        }
         
        return null;
    }   
      
      
}
			                            	