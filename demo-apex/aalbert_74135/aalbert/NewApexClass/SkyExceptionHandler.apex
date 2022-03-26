/*
  * rarora, 12/24/2009
  ** Exception Handler class
*/
public class SkyExceptionHandler {
  public string module {get;set;}
  public string classname {get; set;}
  
  public SkyExceptionHandler(string classname) {
    this.classname = classname;
  }
  
  // this method is used to log message into the target as required
  // System.debug log etc.
  public void logMessage(string msg, boolean showindebuglog) {
    if (showindebuglog) {
      System.debug(msg);  
    }  
  }
  
  public string prepareMessage(Exception e, 
    string modulename, string functionname) {
    return 'From : ' + classname + ' (' + functionname 
      + ') Message: ' + e.getMessage();
  }
  
  public void handleException(Exception e, 
    string modulename, string functionname, boolean showindebuglog,
    boolean putonerrorstack) {
    string message = prepareMessage(e, modulename, functionname);
    if (showindebuglog) {
      logMessage(message, showindebuglog);
    }  
    if (!putonerrorstack) throw new SkyException(message);   
  }
}
			                            	