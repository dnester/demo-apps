/*
  ExpressionParser: This class will evaluate unit expression based on exp1 compOpr exp2
  Author: apatel
  Date: 18/11/2009
*/
public class ExpressionParser {
  // Handle == , < and > operator for String DisplayTypes
  private Boolean evaluateCondition(String exp1, String comOpr, String exp2) {
    Boolean match = false;
    if(exp1 != null && exp2 != null) {
      if(comOpr.equalsIgnoreCase(BRConstants.EQUALS_OPR) && exp1 == exp2) 
        match = true;
      else if(comOpr.equalsIgnoreCase(BRConstants.LESS_THAN_OPR) && exp1 < exp2)
        match = true;
      else if(comOpr.equalsIgnoreCase(BRConstants.GREATER_THAN_OPR) && exp1 > exp2)
        match = true;
    }
    return match;
  }
  // Evaluate expressions of SYSBRCondition, and compare with Trigger.New or Trigger.Old based on Current/Transaction Record 
  public BRStructuredCondition evaluateBRCondition(sObject newSObj, sObject oldSObj, SYSBRConditions__c brCondition, String eventName) {
    BRStructuredCondition conditionResult;
    Boolean unitResult = false;
    // get parsed value of expression value {OLD/NEW, FIELD_API_NAME}
    String exp1Value = getParsedValue(newSObj, oldSObj, brCondition.Expression1__c, eventName);
    String exp2Value = getParsedValue(newSObj, oldSObj, brCondition.Expression2__c, eventName);
    conditionResult = new BRStructuredCondition();
    unitResult = evaluateCondition(exp1Value, brCondition.CompareOpr__c, exp2Value);  
    // set values in BRStructuredCondition bean
    conditionResult.setExpression1(brCondition.Expression1__c);
      conditionResult.setCompareOpr(brCondition.CompareOpr__c);
      conditionResult.setExpression2(brCondition.Expression2__c);
      if(brCondition.LogicalOpr__c != null)
        conditionResult.setLogicalOpr(brCondition.LogicalOpr__c);
      else
        conditionResult.setLogicalOpr('');
      conditionResult.setUnitResult(unitResult);
      System.debug('Expression Parser---> BR Condition evaluation::::' + conditionResult) ;
    return conditionResult;
  }
  // parse expression1 and expression2 {NEW, company_name__c} , {OLD, categoryId__c}
/*  public String[] parse(String exp) {
    String[] parsedString;
    if(exp!=null && exp.contains('{') && exp.contains(',') && exp.contains('}')) {
      String trimString = exp.trim();
      parsedString = trimString.substring(1, trimString.length()-1).split(',',0);
    }
    return parsedString;
  } 
  */
  public String getParsedValue(sObject newObj, sObject oldObj,String exp, String eventName) {
    String[] parsedString;
    String expValue;
    if(exp!=null && exp.contains('{') && exp.contains(',') && exp.contains('}')) {
      String trimString = exp.trim();
      parsedString = trimString.substring(1, trimString.length()-1).split(',',0);
    }
    if(parsedString == null)
      expValue = exp;
    if(parsedString != null && parsedString.size() == 2) {
      if(BRConstants.NEW_REC.equalsIgnoreCase(parsedString[0].trim()) && (eventName.contains(BRConstants.CREATE_STR) || eventName.contains(BRConstants.UPDATE_STR)))  
        expValue = newObj.get(parsedString[1].trim())+'';
      else if(BRConstants.OLD_REC.equalsIgnoreCase(parsedString[0].trim()) && (eventName.contains(BRConstants.DELETE_STR) || eventName.contains(BRConstants.UPDATE_STR)))
        expValue = oldObj.get(parsedString[1].trim())+'';
    }
    return expValue;    
  }
  
  // parse email body, and replace expression with actual value  
  public String parseEmailbody(String initialBody, sObject sObj, String recordType){
      String body = '';
      Integer i = initialbody.indexOf('{'+recordType+',');
      if (i == -1) 
        return initialBody;
      Integer j = 0;
      Boolean flag = true;
      body = body + initialbody.subString(j, i);
      while (flag){
        system.debug(i + ' ' + j + ' ' + body + ' ' + initialbody.length());
        j = initialbody.indexOf('}', i+5);
        string subs = initialbody.substring(i+5,j);
        Object obj = sObj.get(subs.trim());
        body = body + ''+ obj;
        system.debug(i + ' ' + j + ' ' + body + ' ' + initialbody);
        if (j+1 < initialbody.length()) {
          
          system.debug(i + ' ' + j + ' ' + body);
          i = initialbody.indexOf('{'+recordType+',', j+1);
          system.debug(i + ' ' + j + ' ' + body);
          if (i == -1) {
            flag = false;
            body = body + initialbody.subString(j + 1, initialbody.length());
          }
          else
            body = body + initialbody.subString(j + 1, i);
        }
        else
          flag = false;
      }
      
      return body;
   }
}
			                            	