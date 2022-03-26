public class PortletManager {
  
  private  List<PortletDAO> portletsList=null;
  private String portletConfig = '';
  private Integer index = 1;
                        
  public PortletManager(){
    this.portletsList = portletsList;
    portletsList = fetchPortal(index);   
  }
  
  public PortletManager(Integer index){
    this.portletsList = portletsList;
    portletsList = fetchPortal(index);   
  }
  
  public String portletJSONString(){

    String strJSON;
    strJSON = portletConfig;
    integer counter =1;
    
    System.debug('portletsList.size()----->'+portletsList.size());
    for(PortletDAO portlet:portletsList){
      
      System.debug('counter----->'+counter);
      if(counter < portletsList.size()){
        
        System.debug('portletsList.size()----->'+portletsList.size());    
        strJSON += portlet.toJSONString() +',';
      }else {
        strJSON += portlet.toJSONString();
      }
      counter++;
    }
    
    
    return strJSON;
  }
  
  private List<PortletDAO> fetchPortal(Integer index){
  
    DriverAccess driverAccess = new DriverAccess();
    ConditionBuilder queryCondition = new ConditionBuilder();
    List<String> listFieldNames = new List<String>();
    List<PortletDAO> portals = new List<PortletDAO>();
    String height;
    listFieldNames.add('id');
    listFieldNames.add('name'); 
    listFieldNames.add('FKUser__r.id');
    listFieldNames.add('FKUser__r.name');
    listFieldNames.add('FKSYSPortlet__r.name');
    listFieldNames.add('FKSYSPortlet__r.title__c');
    
    queryCondition.setCondition('FKUser__r.name =\'' + UserInfo.getName() +'\' order by order__c');
    List<SYSUsersPortletsConfig__c> listUserPortlets = (List<SYSUsersPortletsConfig__c>)driverAccess.selectObjects(new SYSUsersPortletsConfig__c(), listFieldNames, queryCondition, null);
    
    PortletDAO portal = null;
    PortletDAO portal1= null;
    
        //for(SYSUsersPortletsConfig__c portletConfig :listUserPortlets){
    
    for(Integer i =0 ; i<listUserPortlets.size() ; i++){
      SYSUsersPortletsConfig__c portletConfig = listUserPortlets[i];
      System.debug('@@@@@ listUserPortlets[i].Name : '+portletConfig.Name);
            
      if(portletConfig.FKSYSPortlet__r.Name == 'Broadcast'){
        System.debug('@@@@@ In if index 1');
          portal = new PortletDAO(true,portletConfig.FKSYSPortlet__r.title__c,'250','sideBar',null,true,'broadcastWidgetPage');
        
      }else if(portletConfig.FKSYSPortlet__r.Name == 'Inbox'){
        System.debug('@@@@@ In if index 2');
        portal = new PortletDAO(true,portletConfig.FKSYSPortlet__r.title__c,'250','sideBar',null,true,'inboxWidgetPage');
        
      }else if(portletConfig.FKSYSPortlet__r.Name == 'Search'){
        System.debug('@@@@@ In if index 3');
        portal = new PortletDAO(true,portletConfig.FKSYSPortlet__r.title__c,'50','sideBar','side-Search',true,'SearchPortletPage');
        
      }else if(portletConfig.FKSYSPortlet__r.Name == 'Action'){
        System.debug('@@@@@ In if index 4');
        portal = new PortletDAO(true,portletConfig.FKSYSPortlet__r.title__c,'150','sideBar',null,true,'actionWidgetPage');
        
      }
      if( (i == index-1) || (i == index)){
        System.debug('@@@@@ In if index '+i);
          portals.add(portal);
      }
      
    }
    
    height = 'Ext.isIE7 ? 200 : 160 '; 
    portal = new PortletDAO(true,'World Clock',height,'sideBarClock',null,true,'clockWidgetPage');
        
    portals.add(portal);
    
    return portals;
  }
  
}
			                            	