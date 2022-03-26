/*
  BRStructuredCondition: Wrapper class of BRConditions custom object.
  Author: apatel
  Date: 02/12/09
*/

public class BRStructuredCondition {
  
  private String expression1;
  private String compareOpr;
  private String expression2;
  private String logicalOpr;
  private Boolean unitResult;
  
  public String getExpression1() {
    return expression1;
  }
  public void setExpression1(String exp1) {
    expression1 = exp1;
  }
  public String getCompareOpr() {
    return compareOpr;
  }
  public void setCompareOpr(String compOpr) {
    compareOpr = compOpr;
  }
  public String getExpression2() {
    return expression2;
  }
  public void setExpression2(String exp2) {
    expression2 = exp2;
  }
  public String getLogicalOpr() {
    return logicalOpr;
  }
  public void setLogicalOpr(String logOpr) {
    logicalOpr = logOpr;
  }
  public Boolean getUnitResult() {
    return unitResult;
  }
  public void setUnitResult(Boolean unitRst) {
    unitResult = unitRst;
  }
    
}
			                            	