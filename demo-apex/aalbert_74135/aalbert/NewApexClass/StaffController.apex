public class StaffController {
        
     private DriverAccess driverAccess= new DriverAccess();
     public User staff{get;set;}
     String columnName='Name';
     String direction= 'ASC';
     public String messageString {get; set;}     
     public String errorString;
     public String tempString {get; set;}
     public String getErrorString() {
        return errorString;
      }
     public void setErrorString(String errorString) {
        this.errorString=errorString;
      }     
     public  StaffController() {     
            staff = new User();
            String staffId = ApexPages.CurrentPage().getParameters().get('id');
            columnName = ApexPages.CurrentPage().getParameters().get('columnField');
            direction = ApexPages.CurrentPage().getParameters().get('direction');
            String copyId = ApexPages.CurrentPage().getParameters().get('copyId'); 
            
           if ((staffId != null && staffId != '')|| (copyId !=null && copyId != '')){
             
            List<String> lstOutputFields = new List<String>();        
            lstOutputFields.add('Username');
            lstOutputFields.add('FirstName');
            lstOutputFields.add('LastName');
            lstOutputFields.add('Phone');
            lstOutputFields.add('Extension');
            lstOutputFields.add('MobilePhone');
            lstOutputFields.add('pager__c');
            lstOutputFields.add('email');                 
            lstOutputFields.add('workSchedule__c');
            lstOutputFields.add('TimeZoneSidKey');
            lstOutputFields.add('IsActive');
            
            String queryString = '';
        if((copyId !=null && copyId != '')){
          queryString='Id =' +'\''+copyId+'\'';  
                            
         }else {
           queryString='Id =' +'\''+staffId+'\'';  
         }        
            
            ConditionBuilder objConditionBuilder = new ConditionBuilder();        
            objConditionBuilder.setCondition(queryString); 
                        
            driverAccess = new DriverAccess();
            List<User> listOfStaff= (List<User>) driverAccess.selectObjects(staff,lstOutputFields,objConditionBuilder,null);  
              
            if((listOfStaff.size() >0 ) && (copyId !=null && copyId != '')){
                  staff = listOfStaff[0];
                  copyStaff();
                  
            }else if(listOfStaff.size() >0){
              staff = listOfStaff[0];
              }else {
                staff = new User();
              }
        }             
    }
  
    String createAlias(String firstName, String lastName){
      String alias = '';
      if(firstName!=null && firstName!='' && firstName.length()>1){
        if(lastName!=null && lastName!='' && lastName.length()>1){
          alias = firstName.substring(0, 1) + lastName;
        }else{
          alias = firstName;
        }
      }else if(lastName!=null && lastName!='' && lastName.length()>1){
        alias = lastName;
      }else{
        alias = 'TemporaryAlias';  
      }
      
      if(alias.length() < 4){
        String dummy = 'xxxx';
        Integer left = 4 - alias.length();
        alias += dummy.substring(0,left);
      }
      else if(alias.length() > 5){      
      alias =alias.substring(0,4);
    }
      return alias;
    }
    public PageReference save() {
     try{
      if(staff!=null && staff.Id!=null){          
            driverAccess.updateObject(staff,null,null); 
      }else{  
           User ob1 = [Select u.Username, u.TimeZoneSidKey, u.ProfileId, u.Name, u.LocaleSidKey, u.LanguageLocaleKey, u.FirstName, u.Email, u.EmailEncodingKey
          From User u limit 1];
          staff.alias = createAlias(staff.FirstName, staff.LastName);
          staff.ProfileId = ob1.profileid;
          staff.LocaleSidKey = ob1.LocaleSidKey;
          staff.LanguageLocaleKey = ob1.LanguageLocaleKey;
          staff.EmailEncodingKey = ob1.EmailEncodingKey;
          driverAccess.insertObject(staff,null);
          }    
         messageString = validationHelper.getSavedMessage();  
         }catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());                
             }else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
             } 
        } 
        return null;
    }
 
    public PageReference clearStaff() {
                staff = new User(); 
        return  null;
    }
    
  
    public PageReference copyStaff(){
            User tempstaff=staff.clone(false,true);
            staff=tempstaff;
            staff.Username = null;
          staff.LastName = null;
          staff.Email = null;
          staff.TimeZoneSidKey = null;          
        
        return null;        
    }  
 }
			                            	