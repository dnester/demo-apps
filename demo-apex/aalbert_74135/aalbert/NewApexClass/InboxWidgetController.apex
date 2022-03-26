public class InboxWidgetController {
  
  List<Incident__c> incidentsList = null;
  public List<Incident__c> incidentsPageList{get; set;}
  Integer currentMax{get; set;}
  Integer currentMin{get; set;}
  Integer previousMax;
  Integer previousMin;
  public Integer pageSize{get; set;}
  
  
  public InboxWidgetController(){
    
    incidentsList= [Select i.openDateTime__c, i.incidentDescription__c, i.Name, i.Id,state__c From Incident__c i where state__c =true order by openDateTime__c desc];
    pageSize=3;
    currentMax=pageSize;
    currentMin=0;
    integer index=0;      
        
    incidentsPageList = new List<Incident__c>();  
    
    for(index =0; ((index< currentMax )&&(index < incidentsList.size())); index++){
      Incident__c incident = incidentsList[index];
      incidentsPageList.add(incident);
       
    }
    previousMin=0;
    previousMax=index;
    currentMax=index+ pageSize;
    currentMin=index;
    //currentPageNumber++;
      
  } 
  
  public Pagereference gotoNext(List<Incident__c> incidents,integer startIndex,integer endIndex){
      integer index=0;
      if(startIndex < incidentsList.size()-1){
        
        incidentsPageList = new List<Incident__c>();  
        
        for(index =startIndex; ((index < endIndex)&&(index < incidentsList.size())); index++){
          Incident__c incident = incidentsList[index];
          incidentsPageList.add(incident);
           
        }
        
        if((startIndex - pageSize) >= 0){
          previousMin=startIndex - pageSize;
          previousMax=startIndex;
        }
        
        currentMax=(index-1)+pageSize;
        currentMin=index;
        //currentPageNumber++;
      }
      return null;
    
  }
  
  
  public void previous(){
    
    
    if(currentMax > 0){
      gotoNext(incidentsList,previousMin,previousMax);
      
    }
  }
  
  
  public void next(){
    
      
    if((currentMin < (incidentsList.size()))){
      gotoNext(incidentsList,currentMin,currentMax);
    }
  }

}
			                            	