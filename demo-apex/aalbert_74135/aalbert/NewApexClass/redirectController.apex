public class redirectController {

    public PageReference redirect() {
        String pageLink = ApexPages.CurrentPage().getParameters().get('link');
        PageReference pf = new PageReference('/apex/'+pageLink);
        return pf;
    }

}
			                            	