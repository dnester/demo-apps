/*
  BRConstants: Constants String required in BRProcessor
  Author: apatel
  Date: 15/11/2009
*/
public class BRConstants {
  
  // BR Action methods / Event Names
  public static String CREATE_STR  = 'Create';
  public static String UPDATE_STR  = 'Update';
  public static String DELETE_STR  = 'Delete';
  
  // Boolean values in Field/Value mapping
  public static String TRUE_VALUE = 'TRUE';
  public static String FALSE_VALUE = 'FALSE';
  
  // Current Record (CUR<->NEW) i.e Trigger.Old and Transaction Record (TR<>->NEW) i.e. Trigger.New
  public static String NEW_REC = 'NEW';
  public static String OLD_REC = 'OLD'; 

  // Supported Comparison operator
  public static String EQUALS_OPR = '=';
  public static String LESS_THAN_OPR = '<';
  public static String GREATER_THAN_OPR = '>';
  
  // Supported Logical operator
  public static String AND_OPR = 'AND';
  public static String OR_OPR = 'OR';
  
}
			                            	