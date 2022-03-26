public class IncidentCloser{

    public Incident__c inc = new Incident__c();
    String incidentId{get; set;}
    public Category__c category{get; set;}
    List<StandardDescription__c> stdDescription;
    List<StandardResolution__c> stdResolution;
    public Boolean checkedUpdateDesc{get;set;}
    public Boolean checkedUpdateResolution{get;set;}
    String[] updateDescRes = new String[]{};
    Boolean isStdDesc = false;
    Boolean isStdRes = false;
    String stdDescId; 
    
    List<String> lstOutputFields;
    String condition;
    ConditionBuilder conditionBuilder ;
    DriverAccess objDriverAccess;
    
    List<Incident__c> incidents;
    
    public List<SelectOption> getUpdateList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('isStdDescription','Update Standard Description'));
        options.add(new SelectOption('isStdResolution','Update Standard Resolution'));                 
        return options;
    }

    public String[] getUpdateDescRes(){
        return updateDescRes;
    } 
    
    public void setUpdateDescRes(String[] updateDescRes){
        this.updateDescRes = updateDescRes;
    }
    
    
    public Category__c getCategory(){
        return category;
    }
      
    public void setCategory(Category__c cat){
        this.category = cat;
    }  
    
   public Incident__c getInc(){
        return inc;
    }

    public PageReference setSelectedCategory(){

        lstOutputFields = null;
        lstOutputFields = new List<String>();
     
        lstOutputFields.add('Id');
        lstOutputFields.add('categoryDescription__c');
         
        condition = null;
        String temp =  inc.FKCategory__c; 
        condition = 'Id =' + temp;
        conditionBuilder.setCondition(condition); 
        Category__c tempCategory = new Category__c();
        List<Category__c> categories = (List<Category__c>) objDriverAccess.selectObjects(tempCategory,lstOutputFields,conditionBuilder,null);
        category =  categories[0];   

        //category = [Select c.Id, c.categoryDescription__c from Category__c c where c.Id =: inc.FKCategory__c ];
        inc.FKCategory__r = category;
        return null;
    }
    
    public PageReference save() 
    {
        //create new stdDesc object if one does not existing with specified "Std Description" input and Update std desc checkbox is selected
        //create new stdResoltion object if one does not existing , in stdDesc , with specified "Std Resoltion" input and Update std resoltion checkbox is selected
        for(String str : updateDescRes){
            if(str.equals('isStdDescription'))
                checkedUpdateDesc = true;
            if(str.equals('isStdResolution'))
                checkedUpdateResolution = true;
        }
        if(inc.incidentDescription__c == null){
            inc.incidentDescription__c = '';
        }
        if(inc.incidentResolution__c == null)
            inc.incidentResolution__c = ''; 

        lstOutputFields = null;
        lstOutputFields = new List<String>();
     
        lstOutputFields.add('Id');
        lstOutputFields.add('categoryDescription__c');
         
        condition = null;
        String categoryCondition = inc.FKCategory__r.Id;
        condition = 'FKCategory__c =' + categoryCondition;
        conditionBuilder.setCondition(condition); 

        StandardDescription__c tempStdDesc = new StandardDescription__c();
        stdDescription = (List<StandardDescription__c>) objDriverAccess.selectObjects(tempStdDesc ,lstOutputFields,conditionBuilder,null);
        
        //stdDescription = [Select stdD.Description__c from StandardDescription__c stdD where stdD.FKCategory__c =: inc.FKCategory__r.Id];
       
        if(stdDescription.size() > 0){
            for(StandardDescription__c stdDesc : stdDescription){
                // for adding Standard Resolution in blank Standard Description Object...
                if(inc.incidentDescription__c == '' && inc.incidentResolution__c != null)
               {
                    if(stdDesc.Description__c == null){
                         stdDesc.Description__c = '';
                         StandardResolution__c stdResTemp = new StandardResolution__c(Resolution__c = inc.incidentResolution__c, StandardDescriptionId__c = stdDesc.Id); 
                         insert stdResTemp;
                    }
               }
               if(stdDesc.Description__c == null){
                   stdDesc.Description__c = '';
               }
               else if(stdDesc.Description__c.equals( inc.incidentDescription__c)){
                    isStdDesc = true;
                    stdDescId = stdDesc.Id;
                    break;
                }
                
            }
        }
        if(stdDescription.size() != 0){
           stdResolution = [Select stdR.Id, stdR.Resolution__c from StandardResolution__c stdR where stdR.StandardDescriptionId__c =: inc.incidentDescription__c];

            if(stdResolution.size() > 0){
                for(StandardResolution__c stdRes : stdResolution){
                    if(stdRes.Resolution__c == null)
                        stdRes.Resolution__c = '';
                    else if(stdRes.Resolution__c.equals( inc.incidentResolution__c)){
                        isStdRes = true;
                    }
                }
            }
        }
        else{
            stdResolution = new List<StandardResolution__c>();
        }
        
        System.debug('>>>>>>>>>>>>>>' + checkedUpdateDesc + '>>>>>>>>>>>>>>>>>' + checkedUpdateResolution );
        if(checkedUpdateDesc && checkedUpdateResolution ) 
        {
            //if Standard Description's record exist for this Category do not add new Standard Description
            if(isStdDesc)
            {
                // if Standard resolution does not exist for this Standard Description then add it to Std Descripption
                if(!isStdRes){
                    updateStdResolution();
                }
            }
            else     
            {   // if Standard Description and Standard resolution does not exist and Update Standard Description , Update Standard resolution is checked  
                // then add Standard Description record for this Category of incident and Standard Resolution for this Standard Description 
                updateStdDescription();
                updateStdResolution();
            }
        }
        else if(checkedUpdateDesc && !checkedUpdateResolution){ // if Standard Description is not exist and Update Standard resolution is not checked  
                                                                // then add Standard Description record for this Category of incident       
            if(!isStdDesc){
                updateStdDescription();
            }
        }
        //upsert inc;
        objDriverAccess.updateObject(inc, null, null);    
        return null;
    }
    
    public void updateStdDescription(){
         StandardDescription__c stdDescTemp = new StandardDescription__c(Description__c = inc.incidentDescription__c, Inactive__c = false, CategoryId__c = inc.FKCategory__r.Id );
         objDriverAccess.insertObject(stdDescTemp, null);
         
         //insert stdDescTemp;
         //stdDescId = stdDescTemp.Id;
    }
    public void updateStdResolution(){
        StandardResolution__c stdResTemp = new StandardResolution__c(Resolution__c = inc.incidentResolution__c, Inactive__c = false);
        stdResTemp.StandardDescriptionId__c = stdDescId;
        //insert stdResTemp;
        objDriverAccess.insertObject(stdResTemp, null);
    }
    public PageReference quickClose(){
        
        lstOutputFields = null;
        lstOutputFields = new List<String>();
     
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');
         
        condition = null;   
        condition = 'state__c = false and' + 'defaultStatus__c = true';
        conditionBuilder.setCondition(condition); 
        Status__c tempStatus = new Status__c();
        List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);

        //List<Status__c> statuses = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c from Status__c s where s.state__c =:'C' and s.defaultStatus__c =: true ];
        
        if(statuses.size() > 0){
           inc.FKStatus__r =  statuses[0];   //s.Name =:'CLOSED' and
        } 
        objDriverAccess.updateObject(inc, null, null);
        //upsert inc;
        return null;
    }
    
    public PageReference reopenIncident(){
    
        lstOutputFields = null;
        lstOutputFields = new List<String>();
     
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        lstOutputFields.add('state__c');
        lstOutputFields.add('defaultStatus__c');
         
        condition = null;   
        condition = 'state__c = true and' + 'defaultStatus__c = true';
        conditionBuilder.setCondition(condition); 
        Status__c tempStatus = new Status__c();
        List<Status__c> statuses = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);

        //List<Status__c> statuses = [Select s.Id, s.Name, s.state__c, s.defaultStatus__c from Status__c s where s.State__c =:'O' and s.defaultStatus__c =: true];   
        if(statuses.size() > 0)
           inc.FKStatus__r =  statuses[0];

        objDriverAccess.updateObject(inc, null, null);
        //upsert inc;
        return null;
    }
    public IncidentCloser(){
        
        incidentId= Apexpages.currentPage().getParameters().get('incidentID');
        
        lstOutputFields = new List<String>();
        conditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
        
        lstOutputFields.add('UrgencyId__c');
        lstOutputFields.add('openDateTime__c');
        lstOutputFields.add('Id');
        lstOutputFields.add('dueDateTime__c'); 
        lstOutputFields.add('FKImpact__c');        
        lstOutputFields.add('FKClient__c');
        lstOutputFields.add('FKCategory__c');
        lstOutputFields.add('CreatedDate');
        lstOutputFields.add('FKPriority__c');
        lstOutputFields.add('FKClosedBy__c');
        lstOutputFields.add('closeDateTime__c');
        lstOutputFields.add('FKStatus__c');
        lstOutputFields.add('followUpDateTime__c');
        lstOutputFields.add('FKCategory__r.categoryDescription__c');
        lstOutputFields.add('firstCallResolution__c');
        lstOutputFields.add('FKCategory__r.Name');
        lstOutputFields.add('incidentDescription__c');
        lstOutputFields.add('incidentResolution__c');
        lstOutputFields.add('followUp__c');

        condition = 'id=' + '\''+incidentId+'\'';
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' + condition);
        conditionBuilder.setCondition(condition); 
        Incident__c tempIncident = new Incident__c();
        
         /*this.inc = [Select i.UrgencyId__c,i.openDateTime__c, i.Id,
               i.dueDateTime__c,i.FKImpact__c, i.FKClient__c,
               i.FKCategory__c,i.CreatedDate, i.FKPriority__c, i.FKClosedBy__c, 
               i.closeDateTime__c, i.FKStatus__c, i.followUpDateTime__c,
               i.FKCategory__r.categoryDescription__c, i.firstCallResolution__c,
               i.FKCategory__r.Name, i.incidentDescription__c, i.incidentResolution__c,
               i.followUp__c
               From Incident__c i where i.id =: incidentId];*/
          
         incidents =  (List<Incident__c>) objDriverAccess.selectObjects(tempIncident ,lstOutputFields,conditionBuilder,null);

         inc = incidents[0];
         inc.FKClosedBy__c = UserInfo.getUserId();
         inc.closeDateTime__c = System.now();
          
         lstOutputFields = null;
         lstOutputFields = new List<String>();
     
         lstOutputFields.add('Id');
         lstOutputFields.add('Name');
         lstOutputFields.add('state__c');
         
         condition = null;   
         condition = 'state__c = false and' + 'defaultStatus__c = true';
         conditionBuilder.setCondition(condition); 
         Status__c tempStatus = new Status__c();
         List<Status__c> status = (List<Status__c>) objDriverAccess.selectObjects(tempStatus,lstOutputFields,conditionBuilder,null);
            
         /*Status__c[] status = [Select s.Id, s.Name, s.state__c from Status__c s where s.state__c =:'C' and s.defaultStatus__c =: true] ;*/
          
          if(status.size()!=0){
              inc.FKStatus__c = status[0].Id;
          }
               
          this.category = inc.FKCategory__r;
          checkedUpdateDesc = false;
          checkedUpdateResolution= false;
    }
}
			                            	