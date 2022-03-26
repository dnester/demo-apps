public class ProfileSelectController {
    
    private String broadcastId;
    public Broadcasts__c broadcast;
    public String messageString {get; set;}
    public Broadcasts__c getBroadcast(){
      return this.broadcast;
    }
    public String selectedProfiles{get; set;}
    
    public void setBroadcast(Broadcasts__c broadcast){
      this.broadcast = broadcast;
    }
    
    List<String> profileLabelList;
    List<String> profileNameList;
    
    public List<String> getProfileLabelList() {
        return this.profileLabelList;
    }
    
    public void setProfileLabelList(List<String> profileLabelList) {
        this.profileLabelList = profileLabelList;
    }
    
    public List<String> getProfileNameList() {
        return this.profileNameList;
    }
    
    public void setProfileNameList(List<String> profileNameList) {
        this.profileNameList = profileNameList;
    }
    
    
    List<String> fieldLabelList;
    List<String> fieldNameList;
    
    
    public List<String> getFieldLabelList() {
        return this.fieldLabelList;
    }
    
    public void setFieldLabelList(List<String> fieldLabelList) {
        this.fieldLabelList = fieldLabelList;
    }
    
    public List<String> getFieldNameList() {
        return this.fieldNameList;
    }
    
    public void setFieldNameList(List<String> fieldNameList) {
        this.fieldNameList = fieldNameList;
    }

    public ProfileSelectController() {
        fieldLabelList = new List<String>();
        fieldNameList = new List<String>();
        profileLabelList = new List<String>();
        profileNameList = new List<String>();
        
        broadcastId = Apexpages.currentPage().getParameters().get('id');
        if(broadcastId != null && broadcastId != ''){
          Conditionbuilder condition = new ConditionBuilder();
          List<String> listFields = new List<String>();
          listFields.add('name');
          listFields.add('profiles__c');
          listFields.add('FKCategory__c');
          
          DriverAccess driverAccess = new DriverAccess();
          condition.setCondition('id=\'' +  broadcastId + '\'');
          
          List<Broadcasts__c> broadcastList = (List<Broadcasts__c>)driverAccess.selectObjects(new Broadcasts__c(), listFields, condition, null);
          if(broadcastList != null && broadcastList.size() > 0){
            broadcast= broadcastList[0];
            selectedProfiles = broadcast.profiles__c;
          }
        }
    }
   
      
  
    // fetching selected profiles
    public void getFieldItems() {
         fieldLabelList = new List<String>();
         fieldNameList = new List<String>();
         profileLabelList = new List<String>();
         profileNameList = new List<String>();
         List<String> profiles;
         if(selectedProfiles == null || selectedProfiles == ''){
           profiles= new  List<String>();
         }else{
           profiles= selectedProfiles.split(',');
         }
         
         List<Profile> listProfile=[Select p.Name From Profile p];
         Map<String,Profile> mapPro = new Map<String,Profile>();
         
         for(Profile profile:listProfile){
           mapPro.put(profile.name,profile);
         }
         
         for(String strTemp:profiles){
           integer i=0;
           Profile profile = mapPro.get(strTemp);
           if(profile!=null && strTemp.equals(profile.Name)){
             fieldNameList.add(profile.name);
             fieldLabelList.add(profile.name);
               
           }
         }
          
        for(Profile profile:listProfile){
           Boolean isSelected =false;         
           for(String strTemp:profiles){  
             Profile tempProfile =mapPro.get(strTemp);
             if(tempProfile == profile){
                isSelected=true;
               break;
             }
           }
           
           if(!isSelected){
             profileNameList.add(profile.name);
             profileLabelList.add(profile.name);
           }
         }
           
        
    }
    
    // update the broadcast with selected values.
    public Pagereference assignSelectedProfiles() {
      try{
          if(broadcast != null ){
            if(broadcast.FKCategory__c != null){
               broadcast.profiles__c = selectedProfiles;
               ConditionBuilder queryCondition = new ConditionBuilder();
               queryCondition.setCondition('Id=\'' + broadcast.id + '\'');
               DriverAccess driverAccess = new DriverAccess();
               driverAccess.updateObject(broadcast, queryCondition, null);
            }else{
              messageString =Label.BRDProfileError;
          throw new FormValidationException(messageString);
            }
          }else {
            messageString =Label.BRDNotExist;
        throw new FormValidationException(messageString);
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
    
       
    
    
}
			                            	