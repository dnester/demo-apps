/*
  StringUtil: This class provides advanced String operations.
  Author: apatel
  Date: 17/11/2009

*/
public class StringUtil {
   
   // merges array of string depending on delimiter separator
    public static String mergeString(String[] lstStr, String delimiter) {
        String resultStr;
        if(lstStr != null && delimiter != null) {
          resultStr = '';  
          for(String str : lstStr) 
                 resultStr += str + delimiter;
          if(resultStr.contains(delimiter))
            resultStr = resultStr.substring(0,resultStr.lastIndexOf(delimiter));
          System.debug('Merged String : ' + resultStr);
        }
        return resultStr;
    }
    
    // split email addresses by , or ;
  public static String [] splitEmailAddresses (String s) {
    
    if (s == null)
      return null;
      String[] commaSeperatedAddresses = s.split(',', 0);
      
      String[] addresses = new List<string>();
      
      for (String csa: commaSeperatedAddresses)
        addresses.addAll(csa.split(';',0));
        
      return addresses;
    }
    
    //Added By Avadhut K.
    //Get Valid data if string is null
    public static String getValidData(String data){
        return getValidData(data, '-');
    }
    public static String getValidData(String data, String replaceInvalid){
        if(data==null) return replaceInvalid;
        return data;
    }
    public static String listToJSString(List<String> lst, String jsVar, Boolean validateData, String replaceInvalid){
      String ret='';
      Integer i=0;
      if(lst==null) return ret;
      for(String str : lst){        
            ret=ret+jsVar+'['+i+']="'+(validateData ? getValidData(str, replaceInvalid) : str)+'";';                    
            i++;
        }
      return ret;
    }
    //      
}
			                            	