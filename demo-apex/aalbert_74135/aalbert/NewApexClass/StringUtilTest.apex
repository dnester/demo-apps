/*
  StringUtilTest: testMethods for StringUtil class 
  Author: apatel
  Date: 25/11/2009
*/
@isTest
private class StringUtilTest {
  public static testMethod void mergeStringPositiveTestcase() {
    // setup data
    String[] lstStr = new String[3];
    lstStr[0] = 'Create';
    lstStr[1] = 'Update';
    lstStr[2] = 'Delete'; 
    String delimiter = ';' ;
    // invoke mergeString call
    String mergedString = StringUtil.mergeString(lstStr, delimiter);
    // Verify size of mergedString after spliting is same as setup time size of string array
    String[] strToken = mergedString.split(delimiter);
    System.assertEquals(strToken.size(), lstStr.size());
    //verify mergedString contains delimiter
    System.assert(mergedString.contains(delimiter));
  }
  public static testMethod void mergeStringNegativeTestcase() {
    // setup data
    String[] lstStr = new String[2];
    lstStr[0] = 'After  ';
    lstStr[1] = '  Before  ';
    String delimiter = ' ' ;
    // invoke mergeString call
    String mergedString = StringUtil.mergeString(lstStr, delimiter);
    // Verify size of mergedString after spliting is same as setup time size of string array
    String[] strToken = mergedString.split(delimiter);
    System.assertNotEquals(strToken.size(), lstStr.size());
  }
  public static testMethod void mergeStringNullStringArrayTestcase() {
    // setup data
    String delimiter = ';' ;
    // invoke mergeString call
    String mergedString = StringUtil.mergeString(null, delimiter);
    // Verify mergedString
    System.assertEquals(mergedString, null);
  }
  public static testMethod void mergeStringNullDelimiterTestcase() {
    // setup data
    String[] lstStr = new String[3];
    lstStr[0] = 'Create';
    lstStr[1] = 'Update';
    lstStr[2] = 'Delete'; 
    // invoke mergeString call
    String mergedString = StringUtil.mergeString(lstStr, null);
    // Verify mergedString
    System.assertEquals(mergedString, null);
  }
  
}
			                            	