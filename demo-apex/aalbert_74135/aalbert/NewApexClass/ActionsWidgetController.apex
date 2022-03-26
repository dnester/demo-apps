public class ActionsWidgetController {
        public String INCIDENT_IMAGE = 'Incident.png';
        public String TASK_IMAGE = 'Incident.png';
        public String BROADCAST_IMAGE = 'exclamation_icon.gif';        
    
    public List<TableData> dataList{get; set;}
    
    public ActionsWidgetController(){
        dataList = new List<TableData>();
        
        String incidentCount = [SELECT count() FROM Incident__c] + '';
        System.debug('incidentCount '+incidentCount) ;
        TableData tableData = new TableData('Incidents',incidentCount,INCIDENT_IMAGE);
        dataList.add(tableData);
        
        String taskCount = [SELECT count() FROM Task__c] + '';
        tableData = new TableData('Tasks',taskCount,TASK_IMAGE);
        dataList.add(tableData);    
        System.debug('taskCount  ' + taskCount) ;
        
        String broadcastCount = [SELECT count() FROM Broadcasts__c] + '';
        tableData = new TableData('Broadcasts',broadcastCount,BROADCAST_IMAGE);
        System.debug('broadcastCount '+broadcastCount) ;
        dataList.add(tableData);
    }
    
    class TableData{
        
        public String name{get; set;}
        public String count{get; set;}
        public String image{get; set;}
        
        public TableData(){
            this.name = '';
            this.count = '0';
        }
        public TableData(String name,String count,String image){
            this.name = name;
            this.count = count;
            this.image = image;
        }
    }
}
			                            	