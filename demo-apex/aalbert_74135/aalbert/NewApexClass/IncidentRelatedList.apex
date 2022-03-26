public with sharing class IncidentRelatedList {
    
  public IncidentRelatedList(){
    getIncidentWorkOrders();
    getIncidentDetails();
    getDocuments();
  }

    public String getRecId(){
     
     return ApexPages.currentPage().getParameters().get('recId');
    }
    
    Integer listSize;
     public void setListSize(Integer size){
        this.listSize = size;
     }
    public Integer getListSize(){
      return this.listSize;
    }

    public List<Task__c> getIncidentWorkOrders(){
    String recordId = getRecId();
     List<Task__c> workorders = new List<Task__c>();
    if(recordId != null && recordId !=''){
    workorders = [select FKClient__r.Name, dueDateTime__c, Name, Id,openDateTime__c,FKCategory__r.Name,FKimpact__r.Name from Task__c where FKIncident__c=:getRecId()]; 
       setListSize(workorders.size());
     }
     return workorders ; 
    }
    
    Integer detailsSize;
    public void setDetailsSize(Integer s){
       this.detailsSize = s;
    }
    public Integer getDetailsSize(){
      return detailsSize;
    }

    public List<IncidentHistory__c> getIncidentDetails(){ 
       String recordId = getRecId();
       List<IncidentHistory__c> actionList = new List<IncidentHistory__c>();
       if(recordId != null && recordId !=''){
        actionList =[select Date__c,Name,Id,Note__c,duration__c,FKAction__r.Name, FKAction__r.DESCRIPTION__c from IncidentHistory__c where FKincident__c=:getRecId()];    
        setDetailsSize(actionList.size());
        System.debug('Incident details size'+actionList.size());
       }
       return actionList;
    }
    
    Integer attachmentCount;
     public void setAttachmentCount(Integer attachmentCount){
       this.attachmentCount = attachmentCount;
     }
     
     public Integer getAttachmentCount(){
       return this.attachmentCount;
     }
    
    public List<NoteAndAttachment> getIncidentAttachment(){
      List<Incident__c> incident = [Select (Select Id, IsNote, Title,CreatedDate From NotesAndAttachments  where IsNOTE=false) From Incident__c where Id=:getRecId()];
       List<NoteAndAttachment> attachments = incident[0].NotesAndAttachments; 
       setAttachmentCount(attachments.size());      
       return attachments;
    }
    Integer documentsList;
    public void setDocumentsList(Integer documentsList){
      this.documentsList = documentsList;
    }
    public Integer getDocumentsList(){
       return this.documentsList;
    }
    public List<Document> getDocuments(){
      List<Document> documents = [Select d.Url, d.Type, d.Name, d.Id, d.CreatedDate, d.ContentType, d.BodyLength From Document d];
       setDocumentsList(documents.size());
      return documents;
    }
    
    
    
  

}
			                            	