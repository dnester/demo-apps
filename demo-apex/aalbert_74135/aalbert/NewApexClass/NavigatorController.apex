public class NavigatorController{

    public JsonNode root;
    public String jsonString{get; set;}
    public Integer startIndex = 1;
    
    public void setStartIndex(Integer startIndex){
        this.startIndex = startIndex;
    }
    public PageReference refreshPage() {
        return new PageReference('/apex/redirectControllPage?link=skywalker');
    }
    
    public Integer getstartIndex(){
        return startIndex;
    }
    
    public pageReference nextPortlet(){
        startIndex = startIndex + 1;
        PortletManager portletManager= new PortletManager(startIndex);
        jsonString = portletManager.portletJSONString();
        return null;
    }
    
    public pageReference backPortlet(){
        startIndex = startIndex - 1;
        PortletManager portletManager= new PortletManager(startIndex);
        jsonString = portletManager.portletJSONString();
        return null;
    } 
    
    public NavigatorController(){
        root = new JsonNode();
        PortletManager portletManager= new PortletManager();
        System.debug('--------------------------------------------------------');
       // System.debug(portletManager.portletJSONString());
        System.debug('--------------------------------------------------------');
        
       jsonString = portletManager.portletJSONString();
    }
    
    public String getNavigatorJsonFeed(){
        root = new JsonNode();
        SYSNavigator__c navigator = [select id from SYSNavigator__c limit 1];
        if(navigator != null){
            String navigatorId = navigator.id;
            boolean firstNodeFound = false;
            map<String, JsonNode> nodeMap = new map<String, JsonNode>();
            SYSNode__c[] navNodes = [select name, PageReference__c, Parent__c, Tip__c from SYSNode__c where Navigator__c = :navigatorId order by Parent__c, id asc NULLS FIRST ];
            if(navNodes != null && navNodes.size() > 0){
                for(SYSNode__c item : navNodes ){
                    JsonNode node = new JsonNode();
                    node.text = item.name;
                    node.qtip = item.Tip__c;
                    node.id= item.id;
                    if(!firstNodeFound){
                       node.expanded = true; 
                       firstNodeFound = true;
                    }
                    if(item.Parent__c != null){
                        nodeMap.get(item.Parent__c).addChild(node);
                        nodeMap.get(item.Parent__c).leaf = false;
                        if(item.PageReference__c != null){
                            node.pageRef = item.PageReference__c;
                        }
                    }else{
                        root.addChild(node);
                    }
                    nodeMap.put(item.id, node);
                }
        }}
        return root.getJsonChildArrayString();
    }
    
}
			                            	