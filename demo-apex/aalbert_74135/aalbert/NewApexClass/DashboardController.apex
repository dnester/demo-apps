/*
    DashboardController : Class to maintain the dashboard state in the database.
    Author: Sachin Kulkarni
    Date: 17/12/2009
*/
public Class DashboardController {
    
    SYSDashboardWidget__c widget;
    public List<SYSDashboardWidget__c> wList;
    List<SYSDashboardWidget__c> wDeleteList;
    SYSDashboard__c defaultDashboard;
    
    String windowId;
    Integer width;
    Integer height;
    Integer xPos;
    Integer yPos;
    String lastId;
    String lastQuickView;
    String lastQuickViewId;
    Boolean enableView = false;
    
    List<String> lstOutputFields;
    ConditionBuilder objConditionBuilder;
    DriverAccess objDriverAccess;
    String queryString;
    
    
    String widgetsState;
    public String messageString {get; set;} 
    public Integer wListSize{get; set;}
    
    
    public Boolean getEnableView() {
        return this.enableView;
    }

    public void setEnableView(Boolean enableView) {
        this.enableView = enableView;
    }
        
    
    public Integer getXPos() {
        return this.xPos;
    }

    public void setXPos(Integer xPos) {
        this.xPos = xPos;
    }

    public Integer getYPos() {
        return this.yPos;
    }

    public void setYPos(Integer yPos) {
        this.yPos = yPos;
    }

    public String getWindowId() {
        return this.windowId;
    }

    public void setWindowId(String windowId) {
        this.windowId = windowId;
    }
    
    
    public String getLastId() {
        return this.lastId;
    }

    public void setLastId(String lastId) {
        this.lastId = lastId;
    }

    public String getWidgetsState() {
        return this.widgetsState;
    }

    public void setWidgetsState(String widgetsState) {
        this.widgetsState = widgetsState;
    }
    
    
    public String getLastQuickView() {
        return this.lastQuickView;
    }

    public void setLastQuickView(String lastQuickView) {
        this.lastQuickView = lastQuickView;
    }
    

    public String getLastQuickViewId() {
        return this.lastQuickViewId;
    }

    public void setLastQuickViewId(String lastQuickViewId) {
        this.lastQuickViewId = lastQuickViewId;
    }
    
    public Integer getHeight() {
        return this.height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }

    public Integer getWidth() {
        return this.width;
    }

    public void setWidth(Integer width) {
        this.width = width;
    }

    public SYSDashboardWidget__c getWidget() {
        return this.widget;
    }

    public void setWidget(SYSDashboardWidget__c widget) {
        this.widget = widget;
    }
    
    public List<SYSDashboardWidget__c> getWList() {
        return this.wList;
    }

    public void setWList(List<SYSDashboardWidget__c> wList) {
        this.wList = wList;
    }
    
    
    
    public DashboardController() {
    
        lstOutputFields = new List<String>();
        objConditionBuilder = new ConditionBuilder();
        objDriverAccess = new DriverAccess();
        queryString = '';
        
        wDeleteList = new List<SYSDashboardWidget__c> ();
        
        defaultDashboard = new SYSDashboard__c();
        
        enableView = false;
    
        
        List<SYSDashboard__C> dList = [Select name, id from SYSDashboard__c where userId__c =: UserInfo.getName()];
        
        if(dList.size() == 0) {
            dList = [Select name, id from SYSDashboard__c where userId__c =: null];
            if(dList.size() > 0) {
                defaultDashboard = dList[0];
                enableView = true;   
            }
            
        }
        
        if(dList.size() > 0) {
            wList = new List<SYSDashboardWidget__c> ();
        
            //wList = [Select s.Name, s.Id, s.xPos__c, s.yPos__c, s.width__c, s.height__c, s.dashboard__r.Id, s.dashboard__r.Name, s.dashboard__c, s.FKSYSQVQuery__r.name__c from SYSDashboardWidget__c s where s.dashboard__r.Id =: dList[0].Id];
            
            // Find the list of widgets of User specific dashboard or the default dashboard.
            if(lstOutputFields.size() > 0)
                lstOutputFields.clear();
        
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('xPos__c');
            lstOutputFields.add('yPos__c');
            lstOutputFields.add('width__c');
            lstOutputFields.add('height__c');
            lstOutputFields.add('dashboard__r.Id');
            lstOutputFields.add('dashboard__r.Name');
            lstOutputFields.add('dashboard__c');
            lstOutputFields.add('FKSYSQVQuery__r.name__c');
            
                
            queryString = 'dashboard__r.Id =' +'\''+dList[0].Id+'\'';
            objConditionBuilder.setCondition(queryString);
        
            wList = (List<SYSDashboardWidget__c>) objDriverAccess.selectObjects(new SYSDashboardWidget__c(),lstOutputFields,objConditionBuilder,null);
            wListSize = wList.size();
        
        }
        
    }
    
    /*
    public PageReference updateList() {
        
        for(Integer i=0; i<wList.size(); i++) {
            if(wList[i].Id == windowId) {
                
                wList[i].xPos__c = xPos;
                wList[i].yPos__c = yPos;
                wList[i].width__c = width;
                wList[i].height__c = height;
            }
            
        }
        
        return null;
    }
    */
    
    //Function to add the widget to the list of widgets.
    public PageReference addToList() {
    
        SYSDashboardWidget__c newWidget = new SYSDashboardWidget__c();
        newWidget.xPos__c = 200;
        newWidget.yPos__c = 200;
        newWidget.width__c = 200;
        newWidget.height__c = 200;
        
        //List<SYSDashboard__C> dList = [Select name, id from SYSDashboard__c where userId__c =: UserInfo.getName()];
        if(lstOutputFields.size() > 0)
                lstOutputFields.clear();
        
        lstOutputFields.add('Id');
        lstOutputFields.add('Name');
        
        queryString = 'userId__c =' +'\''+UserInfo.getName()+'\'';
        objConditionBuilder.setCondition(queryString);
        
        List<SYSDashboard__c> dList = (List<SYSDashboard__c>) objDriverAccess.selectObjects(new SYSDashboard__c(),lstOutputFields,objConditionBuilder,null);
        
        if(dList.size() > 0) {
            newWidget.dashboard__c = dList[0].Id;
            //newWidget.dashboard__r = dList[0];
        
            //List<SYSQVQuery__c> viewList = [select Id, Name, name__c from SYSQVQuery__c where Id =: lastQuickViewId ];
            if(lstOutputFields.size() > 0)
                lstOutputFields.clear();
        
            lstOutputFields.add('Id');
            lstOutputFields.add('Name');
            lstOutputFields.add('name__c');
            
            
            queryString = 'Id =' +'\''+lastQuickViewId+'\'';
            objConditionBuilder.setCondition(queryString);
        
            List<SYSQVQuery__c> viewList = (List<SYSQVQuery__c>) objDriverAccess.selectObjects(new SYSQVQuery__c(),lstOutputFields,objConditionBuilder,null);
        
            
        
            if(viewList.size() > 0) {
                newWidget.FKSYSQVQuery__r = viewList[0];
            
                newWidget.FKSYSQVQuery__c = viewList[0].Id; 
                lastQuickView = viewList[0].Name__c;
                lastQuickViewId = viewList[0].Id;
            }
        
            //insert newWidget;
            objDriverAccess.insertObject(newWidget,null);
        
            lastId = newWidget.Id;
        
            wList.add(newWidget);
        
        }         
        return null;
    }
    
    // Function to maintain the list of widgets to be removed.
    public PageReference removeFromList() {
                
        for(Integer i=0; i<wList.size(); i++) {
            if(wList[i].Id == windowId && wList[i] != null) {
                wDeleteList.add(wList.remove(i));
            }
        }
        return null;
    }
    
    
    
    public PageReference save() {
        
        // For the new user, create a user specific dashboard and add widgets on default dashboard.
        if(wList.size()>0 && wList[0].dashboard__r.Name == defaultDashboard.Name) {
            
            enableView = false;
            
            system.debug('**********for new user');
            
            SysDashboard__c dNew = new SysDashboard__c();
            dNew.userId__c = UserInfo.getName();
            
            //insert dNew;
            objDriverAccess.insertObject(dNew, null);
        
            
            for(Integer i=0; i<wList.size(); i++) {
                SysDashboardWidget__c newWidget = new SysDashboardWidget__c();
                newWidget.width__c = wList[i].width__c;
                newWidget.height__c = wList[i].height__c;
                newWidget.xPos__c = wList[i].xPos__c;
                newWidget.yPos__c = wList[i].yPos__c;
                
                newWidget.FKSYSQVQuery__c = wList[i].FKSYSQVQuery__c;
                
                newWidget.dashboard__c = dNew.Id;
                
                //insert newWidget;
                objDriverAccess.insertObject(newWidget,null);
        
                
            }
            
            wList.clear();
            if(dNew.Id != null) {
                //wList = [Select s.Name, s.Id, s.xPos__c, s.yPos__c, s.width__c, s.height__c, s.dashboard__r.Id, s.dashboard__r.Name, s.dashboard__c from SYSDashboardWidget__c s where s.dashboard__r.Id =: dNew.Id];
                if(lstOutputFields.size() > 0)
                    lstOutputFields.clear();
        
                lstOutputFields.add('Id');
                lstOutputFields.add('Name');
                lstOutputFields.add('xPos__c');
                lstOutputFields.add('yPos__c');
                lstOutputFields.add('width__c');
                lstOutputFields.add('height__c');
                lstOutputFields.add('dashboard__r.Id');
                lstOutputFields.add('dashboard__r.Name');
                lstOutputFields.add('dashboard__c');
                
                
                queryString = 'dashboard__r.Id =' +'\''+dNew.Id+'\'';
                objConditionBuilder.setCondition(queryString);
        
                wList = (List<SYSDashboardWidget__c>) objDriverAccess.selectObjects(new SYSDashboardWidget__c(),lstOutputFields,objConditionBuilder,null);
    
            }
            
            
            enableView = false;
            
            return null;
        }
        //System.debug('===>>>'+wList.size());
        //  Update wList and then remove unnecessary widgets.  
            System.debug('====>>>>'+widgetsState);
          if(widgetsState!=null && widgetsState!='') {
            List<String> widgetsList = widgetsState.split('#');
            //System.Debug('widgetsList ->'+widgetsList);
            List<String> widgetParams = new List<String> ();
            List<String> widgetIdList = new List<String> ();
            
            if(wList.size() < 1)
                widgetsList = null;
            
                
            for(Integer i=0; i<widgetsList.size(); i++) {
                System.Debug('widgetsList ->'+widgetsList[i]);
                
                String widget = widgetsList[i];
                
                system.debug('WIDGET STRING=>'+ widget);
                
                widgetParams = widget.split(',');
            
                String Id;
                Integer width, height, xPos, yPos;
                if(widgetParams[0]!=null && widgetParams[0]!='') {
                    Id = widgetParams[0];
                    width = Integer.valueOf(widgetParams[1]);
                    height = Integer.valueOf(widgetParams[2]);
                    xPos = Integer.valueOf(widgetParams[3]);
                    yPos = Integer.valueOf(widgetParams[4]);
                    
                }
                else {
                    Id = widgetParams[1];
                    width = Integer.valueOf(widgetParams[2]);
                    height = Integer.valueOf(widgetParams[3]);
                    xPos = Integer.valueOf(widgetParams[4]);
                    yPos = Integer.valueOf(widgetParams[5]);
                    
                }   
                
                widgetIdList.add(Id);
                
                for(Integer j=0; j<wList.size(); j++) {
                    
                    system.debug('++++++'+wList[j].Id);
                    
                    
                    if(wList[j].Id == Id) {
                        wList[j].width__c = width;
                        wList[j].height__c = height;
                        wList[j].xPos__c = xPos;
                        wList[j].yPos__c = yPos;
                        //upsert(wList[j]);
                        //objDriverAccess.updateObject(wList[j], null, null);
                        
                            
                    }
                    
                    
                }
                
                
            }
            objDriverAccess.updateObject(wList, null, null);
            
          }
            
            //Removing closed widgets.
            if(wDeleteList.size() > 0) {
                //delete wDeleteList;
                objDriverAccess.deleteObject(wDeleteList, null, null);
            }
            
            if(wDeleteList.size() > 0) {
                wDeleteList.clear();
            }
            
            
                
                
        enableView = false; 
        
        // A message to be displayed on save.
        try{
            messageString = 'Dashboard State Saved...';  
         }catch(Exception e){
            if(ApexPages.hasMessages()){
                messageString = validationHelper.getMessageString(ApexPages.getMessages());
             }else{
                messageString = validationHelper.getMessageFromError(e.getMessage());
             } 
        } 
         
        wListSize = wList.size();   
        return null;
    }
    
}
			                            	