public class ConfigurationItem
{    
    public string InstanceID 
    {
        get
        {
            return (string)pAttrValues.get(CMDBHelper.INSTANCE_ID_COL);
        } 
        set
        {
            pAttrValues.put(CMDBHelper.INSTANCE_ID_COL,value);
        } 
    }
    
    public string ClassName
     {get; set; }
    
    private Map<string, object> pAttrValues = new Map<string,object>();

    public Map<string, object>  Attributes{
    get{ return pAttrValues; } }
    
    
}
			                            	