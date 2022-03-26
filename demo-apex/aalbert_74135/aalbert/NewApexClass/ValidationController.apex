public class ValidationController {

     public String[] errorMessagelist {get; set;}
     public String Uname='Username';
     public String LName='LastName';
     public String Eml='email';
     public String EmlL='E-mail';
     public String TimeZone='TimeZoneSidKey';
     public String ValidateRequired='validateRequired';
     public String ValidateEmail='validateEmail';
     public String FL='Email Adddress';
     public String StaffID='Staff ID';    
     public String emsg='Please enter ';     
     public String clientSide='Client Side';
     
     public ValidationController(){}
   
      public String getValidationJsonFeed(){
         ValidationJsonNode root = new ValidationJsonNode();
         Map<String, Schema.SObjectField> describeFields = Schema.SObjectType.User.fields.getMap();
         Map<String, Boolean> fieldIsRequired = new Map<String, Boolean>();
         List<String> lst = new List<String>();
         for(String field : describeFields.keyset()){
            ValidationJsonNode child = new ValidationJsonNode();
            Schema.DescribeFieldResult desribeResult = describeFields.get(field).getDescribe();
            if(desribeResult .isCreateable() && !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate()){
                if(field==Uname ||  field== LName || field==Eml || field==TimeZone){
                child.fieldLabel=desribeResult.getLabel();
                child.errorMessage=emsg;
                child.fieldId ='User'+'_id_'+field;
                  child.validationType=clientSide;
                  child.validationFunction=ValidateRequired; 
                  if(child.fieldLabel==Uname){
                   child.fieldLabel=StaffID;                   
                  }
                  if(child.fieldLabel==EmlL){
                   child.fieldLabel=FL;
                   child.validationFunction=ValidateEmail;                                   
                  }
                                
                
                root.addChild(child);
            
            }
           }  
        }
            return root.getJsonChildArrayString(); 
       
      }  
     
}
			                            	