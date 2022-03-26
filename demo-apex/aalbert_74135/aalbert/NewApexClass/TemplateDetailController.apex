public class TemplateDetailController {

    public String objectname { get; set; }

    public String fkeyval { get; set; }
    
    public TemplateDetailController() {
        String obname = ApexPages.CurrentPage().getParameters().get('templateFor');
        if (obname != null) objectname = obname;
        String fkval = ApexPages.CurrentPage().getParameters().get('templateid');
        if (fkval != null) fkeyval = fkval;
    }
}
			                            	