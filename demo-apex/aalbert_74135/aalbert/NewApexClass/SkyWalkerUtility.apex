/*
  * rarora, 12/24/2009
  ** Utility class for multi-purpose common functions
  
*/
public class SkyWalkerUtility {
  /*
  ** function takes a comma separated string and
  ** returns the string collection.
  */
  public List<String> ConvertCSVToList(String lststrvalues) {
    List<String> lstResult = lststrvalues.split(',');
    return lstResult;
  }
}
			                            	