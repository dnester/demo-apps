public class AttachmentController {
  
    String parentId;
    private Attachment attach = new Attachment();
    public String idValue;
    public List<Attachment> AttachList;
  public void setIdValue(String id){
       this.idValue = id; 
    }
    Attachment attachmentObj ;
    public String getIdValue(){
        return this.idValue;
    }
    
    public AttachmentController() { 
      AttachList = new List<Attachment>();
       
        idValue = Apexpages.currentPage().getParameters().get('parentId');
    }
    public PageReference attachFile() {
            try{
              attachmentObj = new Attachment();
              Attachment AttachListobj;
              if(idValue!=null && attach != null && attach.body != null && attach.Name !=null){
                  attachmentObj.ParentId=idValue;
                  attachmentObj.Body=attach.body;
                  attachmentObj.Name=attach.Name;
                  insert attachmentObj;
                
                if(attachmentObj!=null && attachmentObj.id!=null) {  
              AttachListobj = [Select Id, ParentId, Name, BodyLength, CreatedDate, CreatedBy.Name From Attachment where id=:attachmentObj.id];
                AttachList.add(AttachListobj);
            }
            attachmentObj =null;
                  attach = null;
                  attach = new Attachment();
              }
            }catch(Exception e){
              System.debug('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'+e);
              ApexPages.addMessages(e);
              
            }
            
        return null;
    }
    
    public Attachment getAttach() {
        return attach;
    }
    public void setAttach(Attachment a){
        this.attach=a;
    }
   
    public List<Attachment> NotesAndAttachList; 
    public List<Attachment> getNotesAndAttachList() {
        return AttachList;
    }
}
			                            	