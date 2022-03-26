public class PortletDAO {
  
    public Boolean isFframe{get; set;}
    public String title{get; set;}
    public String height{get; set;}
    public String baseCls{get; set;}
    public String contentEl{get; set;}
    public Boolean isCollapsible{get; set;}  
    public String html{get; set;}
                              
    
    public PortletDAO(){
      isFframe = true;
      title='';
      height ='60';
      baseCls='sideBar';
      contentEl='';
      isCollapsible=true;
      html='\'<div class=\\"iframe-enclave\\"><iframe src =\\"\\/apex\\/underconstruction" class=\\"tab-iframe\\"/></div>\'';
      
    }
    public PortletDAO(Boolean isFframe,String title,
              String height,String baseCls,
              String contentEl,Boolean isCollapsible,
              String html){
     
      this.isFframe = true;
      this.title=title;
      this.height =height;
      this.baseCls=baseCls;
      this.contentEl=contentEl;
      this.isCollapsible=isCollapsible;
      this.html= html;
    
   }
   
   public String toJSONString(){
     
     String jsonString =null;
     
     if(contentEl != null && contentEl != ''){
           jsonString= ('{' 
                + 'frame:' + isFframe
                + ',title:\'' + title + '\''
                        + ',height:'+ height 
                        +',baseCls:\'' + baseCls + '\''
                        + ',contentEl:\'' + contentEl + '\''
                + ',collapsible:' + isCollapsible
                + ' }');
                        
      
     }else{ 
       
         String str='\'<div class=\"iframe-enclave\"> <iframe src =\\"\\/apex\\/'+ html +'" class=\\"tab-iframe\\"/></div>\'';
         
         jsonString= ('{' 
                + 'frame:' + isFframe
                + ',title:\'' + title + '\''
                        + ',height:'+ height 
                        +',baseCls:\''+ baseCls + '\''
                + ',collapsible:' + isCollapsible
                + ',html:' +str+'}');
                
                
                
     } 
     
    System.debug('---------------->jsonString debug log'+jsonString);
     
     return jsonString;
   }  
   
       
   
   
}
			                            	