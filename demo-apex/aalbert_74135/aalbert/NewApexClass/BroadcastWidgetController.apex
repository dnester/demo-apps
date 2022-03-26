public class BroadcastWidgetController {
    
    public List<BroadcastModel> broadcastsDataList{get; set;}
    
    public String broadcastDesc{get; set;}
    public String priority{get; set;}
    public String postDate{get; set;}
    public Integer rowCount{get; set;}
    public Integer currentMax{get; set;}
    Integer currentMin;
    public Integer pageSize{get; set;}
    public Integer currentPageNumber{get; set;}
    public String currentPageNumberDisplay{get; set;}
    Integer previousMax;
    Integer previousMin;
    
    private List<Broadcasts__c> broadcastsList =null;
    private Map<String,Broadcasts__c> broadcastsMap =null;
    public Broadcasts__c selectedBroadcast {get; set;}
    public String strbroadcastId{get; set;}
    
    public Static final String IMG1='priority1-16.gif';
    public Static final String IMG2='priority2-16.gif';
    public Static final String IMG3='priority3-16.gif';
    public Static final String IMG4='priority4-16.gif';
    public Static final String IMG5='priority5-16.gif';
    
    public BroadcastWidgetController(){
        
        
        broadcastsDataList = new List<BroadcastModel>();
        broadcastsMap = new Map<String,Broadcasts__c>();
        selectedBroadcast = new Broadcasts__c();
        fetchBroadcastList();
        rowCount =broadcastsList.size();
        
        pageSize=5;
        currentMax=pageSize-1;
        currentMin=0;
        currentPageNumber=1;
        currentPageNumberDisplay= 'Page No.1';
        
        
        integer index=0;
        for(index =currentMin; ((index<= currentMax)&&(index < broadcastsList.size())); index++){
            BroadcastModel broadcastModel = new BroadcastModel(broadcastsList[index]);
            broadcastsDataList.add(broadcastModel);
            broadcastsMap.put(broadcastsList[index].id,broadcastsList[index]);
             
        }
        previousMin=0;
        previousMax=index-1;
        currentMax=index+ pageSize-1;
        currentMin=index;
        currentPageNumber=1;


    } 

    
    public List<BroadcastModel> updateDataModel(List<Broadcasts__c> broadcasts){
        
        return null;
    }
    
    void fetchBroadcastList(){
        
        broadcastsList= new List<Broadcasts__c>();
        broadcastsList =[Select b.broadcastDescription__c, b.Name, 
                        b.Id, b.FKPriority__r.Name,b.postDate__c, b.FKPriority__c From Broadcasts__c b Order by postDate__c desc limit 200];
        
        
    }
    
    void gotoNext(List<Broadcasts__c> broadcasts,integer startIndex,integer endIndex){
            integer index=0;
            currentPageNumber = (startIndex / 5) + 1;
            currentPageNumberDisplay = 'Page No. '+currentPageNumber;
            
            if(startIndex < broadcastsList.size()-1){
                selectedBroadcast = new Broadcasts__c();
                broadcastsDataList = new List<BroadcastModel>();    
                broadcastsMap = new Map<String,Broadcasts__c>();    
                
                for(index =startIndex; ((index<= endIndex)&&(index < broadcastsList.size())); index++){
                    BroadcastModel broadcastModel = new BroadcastModel(broadcastsList[index]);
                    broadcastsDataList.add(broadcastModel);
                    broadcastsMap.put(broadcastsList[index].id,broadcastsList[index]);
                     
                }
                
                if((startIndex - pageSize) >= 0){
                    previousMin=startIndex - pageSize;
                    previousMax=startIndex-1;
                }
                
                currentMax=index+pageSize-1;
                currentMin=index;
            }
            
        
    }
    
    public Pagereference next(){
        
        if(currentMin <= (broadcastsList.size())){
            gotoNext(broadcastsList,currentMin,currentMax);
        }
        return null;
    }
    
    public Pagereference previous(){
        
        if(currentMax >= 0){
            gotoNext(broadcastsList,previousMin,previousMax);
        }
        
        return null;
    }
    
    public Pagereference getBroadcastDetails() { 
          
          strbroadcastId = Apexpages.currentPage().getParameters().get('BroadcastId');
          if(strbroadcastId != null && strbroadcastId != ''){
            selectedBroadcast = broadcastsMap.get(strbroadcastId);
          }else{
            selectedBroadcast = new Broadcasts__c();
          }
          return null;
          
         }

    
    public class BroadcastModel{
        
        public Broadcasts__c broadcast{get; set;}
        public String image{get; set;}
        public String fontColor{get; set;}
        
        public BroadcastModel(Broadcasts__c broadcast){
                this.broadcast = broadcast;
                
                if(broadcast.FKPriority__r.name =='1'){
                    image = IMG1;
                    fontColor='#ff0000';
                }else if(broadcast.FKPriority__r.name =='2'){
                    image = IMG2;
                    fontColor='#ff0';
                }else if(broadcast.FKPriority__r.name =='3'){
                    image = IMG3;
                    fontColor='#000';
                }else if(broadcast.FKPriority__r.name =='4'){
                    image = IMG4;
                    fontColor='#000';
                }else if(broadcast.FKPriority__r.name =='5'){
                    image = IMG5;
                    fontColor='#000';
                }else{
                    image = IMG5;
                    fontColor='#000';
                }
            }
    }


}
			                            	