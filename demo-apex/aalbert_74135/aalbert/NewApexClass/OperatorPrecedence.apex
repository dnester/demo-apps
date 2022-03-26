/*
  OperatorPrecedence: This class will decide operator precedence for composite expressions
  Author: Manish K
  Date: 18/11/2009
*/
public class OperatorPrecedence {
    
    public Boolean logicalEvaluate (string s){
            
            String[] orComponents = s.split('[oO][rR]');
            boolean returnValue = andLogicalEvaluate(orComponents[0]); 
            for (integer i=1; i<orComponents.size(); i++)
                  returnValue = returnValue || andLogicalEvaluate(orComponents[i]);
                  
            return returnValue;
     }
      
     public boolean andLogicalEvaluate (string s){
            
            String[] andComponents = s.split('[aA][nN][dD]');
            boolean returnValue = true;
            boolean valueOfString;
            for (integer i=0; i<andComponents.size(); i++){
                  if (andComponents[i].trim().equalsIgnoreCase('true'))
                        valueOfString = true;
                  else 
                        valueOfString = false;
                        
                  returnValue = returnValue && valueOfString;
            }
            return returnValue;
      }
}
			                            	