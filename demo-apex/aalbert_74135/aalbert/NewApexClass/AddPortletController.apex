public class AddPortletController {
    
    //public static final String ERRO_RTIMEZONE='Please Enter Timezones';
    public static final String ERROR_MANDATORYFIELDS='Enter mandatory fields marked as *';
    public static final String ERROR_ORDER='Order already exist.Enter new Order';
    String portletName;
    String portletTitle;
    DriverAccess objDriverAccess ;
    ConditionBuilder objConditionBuilder;
    public SYSUsersPortletsConfig__c usersPortletsConfig{get; set;}
    public String strOrder{get; set;}
    public String timezone1{get; set;}
    public String timezone2{get; set;}
    public String timezone3{get; set;}
    public SYSUsersTimezones__c userTimeZone{get;set;}
    public String messageString {get; set;} 
    
        
    public String getPortletName(){
        return this.portletName;
    }
    public void setPortletName(String portletName){
         this.portletName = portletName;
    }
    
    public String getPortletTitle(){
        return this.portletTitle;
    }
    public void setPortletTitle(String portletTitle){
         this.portletTitle = portletTitle;
    }
    
    public AddPortletController(){
    }   
    
    public List<SelectOption> getTimezones(){
    
        List<SelectOption> options = new List<SelectOption>();
        List<SYSTimeZone__c> timezones = [Select Id,Name from SYSTimeZone__c];
        options.add(new SelectOption('','--None--'));
        for(SYSTimeZone__c timezone : timezones ){
            options.add(new SelectOption(timezone.Id,timezone.name));
        }
        
        return options;
    }
    
    public List<SelectOption> getPortlets(){
    
        List<SelectOption> options = new List<SelectOption>();
        List<SYSPortlet__c> portlets = [Select Id,Name from SYSPortlet__c];
        options.add(new SelectOption('','--None--'));
        for(SYSPortlet__c portlet : portlets ){
            options.add(new SelectOption(portlet.Id,portlet.name));
        }
        
        return options;
    }
    
    
    public PageReference newAddPortlet(){
    
        return null;
        
    }
    
    public PageReference save(){

     try{
         
         if((portletName==''||portletName==null)||(portletTitle==''||portletTitle==null)
             ||(strOrder==''||strOrder==null)){
          
            throw new AddPortletException(ERROR_MANDATORYFIELDS);
         }   
        
        else{
                usersPortletsConfig = new SYSUsersPortletsConfig__c();
                 List<SYSUsersPortletsConfig__c>usersPortletsConfigList = [select Id from SYSUsersPortletsConfig__c where FKSYSPortlet__c=:portletName and FKUser__c=:UserInfo.getUserId()];
                 List<SYSUsersPortletsConfig__c>listOrder=[select Order__c from SYSUsersPortletsConfig__c];
                           
                if(usersPortletsConfigList.size()==1){
                    
                    for (SYSUsersPortletsConfig__c Ordervar :listOrder){
                     
                        usersPortletsConfig.Order__c = integer.valueOf(strOrder);   
                        if (usersPortletsConfig.Order__c==Ordervar.Order__c){
                            throw new AddPortletException(ERROR_ORDER);
                        }else
                         break;  
                    }
                  
                    usersPortletsConfig = usersPortletsConfigList[0];
                    usersPortletsConfig.Order__c = integer.valueOf(strOrder);
                    System.debug('usersPortletsConfig.Order__c----------->'+usersPortletsConfig.Order__c);
                    usersPortletsConfig.name= portletTitle;
                    
                  //  objDriverAccess.updateObject(usersPortletsConfig,null,null); 
                    update usersPortletsConfig;
                    
                }else{
                
                    System.debug('usersPortletsConfig.Order__c in else------------>'+usersPortletsConfig.Order__c); 
                    usersPortletsConfig.FKSYSPortlet__c = portletName;
                    usersPortletsConfig.Order__c = integer.valueOf(strOrder);
                    usersPortletsConfig.FKUser__c = UserInfo.getUserId();
                    usersPortletsConfig.name= portletTitle;
                    insert usersPortletsConfig;
                   //objDriverAccess.insertObject(usersPortletsConfig, null);     
                } 
                 if ((timezone1==''||timezone1==null)||(timezone2==''||timezone2==null)||(timezone3==''||timezone3==null)){        
                    
                    // throw new AddPortletException(errorMessage3);
                    List<SYSTimeZone__c> timezones = [Select Id,Name from SYSTimeZone__c];
                    update timezones;
                    // objDriverAccess.updateObject(timezones,null,null);
                    
                
                }/*else if((timezone1==''||timezone1==null)&&(timezone2!=''||timezone2!=null)
                         &&(timezone3!=''||timezone3!=null)){
                    
                    List<SYSUsersTimezones__c> timezones = [Select Id,Name from SYSUsersTimezones__c  where Name=:timezone2
                                                      and Name=:timezone3 order by order__c asc ];
                    
                    update timezones;
                    
                 } */  
                
                 else {
                            
                      selectTimezones();
                      
                  }
                 messageString = validationHelper.getSavedMessage();
        }       
                   
      }catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
             }else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
             } 
        }  
                    
        return null;
    }   
    
    
    public void selectTimezones(){
    
      List<SYSTimeZone__c> timezoneRec1 = getTimeZoneDetails(timezone1);
                            List<SYSTimeZone__c> timezoneRec2 = getTimeZoneDetails(timezone2);
                            List<SYSTimeZone__c> timezoneRec3 = getTimeZoneDetails(timezone3);
                            
                            
                            List<SYSUsersTimezones__c> prevUserTimeZoneList = [select Id from SYSUsersTimezones__c where FKUserId__c=:UserInfo.getUserId()];
                            if (prevUserTimeZoneList != null && prevUserTimeZoneList.size() > 0){
                                for(SYSUsersTimezones__c pr : prevUserTimeZoneList){
                                    delete pr;
                                   //objDriverAccess.deleteObject(pr, null, null);
                                }
                            }
                            
                            SYSUsersTimezones__c userTimeZone1 = new SYSUsersTimezones__c();
                            List<SYSUsersTimezones__c> userTimeZoneList1 = [select Id, FKUserId__c,FKSYSTimeZone__c from SYSUsersTimezones__c where FKUserId__c=:UserInfo.getUserId() and FKSYSTimeZone__c=:timezone1]; 
                            if(userTimeZoneList1 !=null && userTimeZoneList1.size() > 0)
                            {
                                userTimeZone1 = userTimeZoneList1[0]; 
                                update userTimeZone1;
                               // objDriverAccess.updateObject(userTimeZone1,null,null);   
                            }else{
                                userTimeZone1.FKSYSTimeZone__c=timezone1;           
                                userTimeZone1.FKUserId__c=UserInfo.getUserId();
                                userTimeZone1.Name = timezoneRec1[0].Name;
                                insert userTimeZone1;
                              //  objDriverAccess.insertObject(userTimeZone1, null);
                            }
                             
                            SYSUsersTimezones__c userTimeZone2 = new SYSUsersTimezones__c();
                            List<SYSUsersTimezones__c> userTimeZoneList2 = [select Id from SYSUsersTimezones__c where FKUserId__c=:UserInfo.getUserId() and FKSYSTimeZone__c=:timezone2]; 
                            if(userTimeZoneList2 !=null && userTimeZoneList2.size() > 0)
                            {
                                userTimeZone2 = userTimeZoneList2[0]; 
                              //  objDriverAccess.updateObject(userTimeZone2, null, null);
                                update userTimeZone2;   
                            }else{
                                userTimeZone2.FKSYSTimeZone__c=timezone2;           
                                userTimeZone2.FKUserId__c=UserInfo.getUserId();         
                                userTimeZone2.Name = timezoneRec2[0].Name;
                                insert userTimeZone2; 
                               // objDriverAccess.insertObject(userTimeZone2, null);
                            }
                    
                            SYSUsersTimezones__c userTimeZone3 = new SYSUsersTimezones__c();
                            List<SYSUsersTimezones__c> userTimeZoneList3 = [select Id from SYSUsersTimezones__c where FKUserId__c=:UserInfo.getUserId() and FKSYSTimeZone__c=:timezone3]; 
                            if(userTimeZoneList3 !=null && userTimeZoneList3.size() > 0)
                            {
                                userTimeZone3 = userTimeZoneList3[0]; 
                                update userTimeZone3;
                               // objDriverAccess.updateObject(userTimeZone3, null, null);
                                   
                            }else{
                                userTimeZone3.FKSYSTimeZone__c=timezone3;           
                                userTimeZone3.FKUserId__c=UserInfo.getUserId();         
                                userTimeZone3.Name = timezoneRec3[0].Name;
                               insert userTimeZone3; 
                               // objDriverAccess.insertObject(userTimeZone3, null);
                            }
    
    
    }
    
    List<SYSTimeZone__c> getTimeZoneDetails(String timeZone){
        List<SYSTimeZone__c> timezoneRec = [select Name from SYSTimeZone__c where Id =: timeZone];
        return timezoneRec;
    }
}
			                            	