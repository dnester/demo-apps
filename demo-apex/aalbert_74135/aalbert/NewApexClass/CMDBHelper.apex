public class CMDBHelper
{
//    static final string INSTANCE_ID_COL = 'InstanceID';
    public static final string INSTANCE_ID_COL = 'Name';
    public class CMDBException extends Exception
    {}
    
    public class CMDBResult
    {
        public boolean Success {get; set; }
        public string Message {get; set; }
    }
    
    public static integer instance_cnt = 1000;
    public static string getInstanceID()
    {
        instance_cnt++;
        return ('INST_' + DateTime.Now().format('yyyy_M_d_h_m_s_S')+ instance_cnt);
    }
    
    public CMDBResult UpsertCI(ConfigurationItem ci)
    {
        CMDBResult res = new CMDBResult(); 
     
        if(ci.ClassName == null || ci.ClassName =='') throw new CMDBException('Class Name not set for CI');   
        
        List<String> classes = getSuperClasses(ci.ClassName);
        
        string prevCName = '';        
        SObject o = null;
        boolean hasInstanceID = (ci.InstanceID!=null && ci.InstanceID != '');
        
        if(!hasInstanceID)
        {
            ci.InstanceID = getInstanceID();
        }
        
        List<CMDB_AttributeDefinition__c> classAttributes = [select AttributeName__c, ClassName__c from CMDB_AttributeDefinition__c where ClassName__c in : classes and AttributeName__c in : ci.Attributes.keyset() order by ClassName__c ];
        
        for(CMDB_AttributeDefinition__c attr : classAttributes )
        {
            //system.debug('-->' + attr.ClassName__c + '<>' + attr.AttributeName__c);
            if(prevCName!=attr.ClassName__c)
            {
                if(o!=null){upsert o; o=null; }
                
                if(!hasInstanceID)
                {
                    o = CMDBHelper.getConcreteObjectFromFactory(attr.ClassName__c);
                }
                else
                {
                    o = CMDBHelper.FetchCIObject( ci.InstanceID, attr.ClassName__c);
                }
                o.put(INSTANCE_ID_COL,ci.InstanceID);
                
                prevCName=attr.ClassName__c;
            }
            o.put(attr.AttributeName__c, ci.Attributes.get(attr.AttributeName__c));
        }
        if(o!=null){upsert o; o=null; }
        
        res.Success = true;
        return res;
    }

    public void DeleteCI(ConfigurationItem ci)
    {
        DeleteCI(ci.instanceID, ci.className);        
    }
    
    public void DeleteCI(string instanceID, string className)
    {
        List<String> classes = getSuperClasses(className);
        for(String cls :classes)
        {
            Sobject o = FetchCIObject(instanceID, cls);
            delete o;
        }
    }
    
    public ConfigurationItem GetCI(String InstanceID , String ClassName)
    {
        ConfigurationItem ci = new ConfigurationItem(); 
        
        List<String> classes = getSuperClasses(ClassName);
        List<CMDB_AttributeDefinition__c> classAttributes = [select AttributeName__c, ClassName__c from CMDB_AttributeDefinition__c where ClassName__c in : classes order by ClassName__c ];
        
        string prevCName = null; 
        SObject o=null;
        Set<string> columns=new Set<string>();
        for(CMDB_AttributeDefinition__c attr : classAttributes )
        {
            columns.Add(attr.AttributeName__c);
            //system.debug('-->' + attr.ClassName__c + '<>' + attr.AttributeName__c);

            if(prevCName!=attr.ClassName__c && prevCName !=null)
            {
                setCIAttributes(ci,columns, InstanceID, prevCName);
                columns.clear();
            }
            prevCName=attr.ClassName__c;
        }
        setCIAttributes(ci,columns, InstanceID, prevCName);

        ci.InstanceId = InstanceID;
        ci.ClassName = ClassName;

        return ci;
    }
    
    private void setCIAttributes(ConfigurationItem ci, Set<string> columns, String InstanceID , String ClassName)
    {
        SObject o = CMDBHelper.FetchCIObject(InstanceID, ClassName, columns);
        for(string s : columns)
        {
            ci.Attributes.put(s,o.get(s));
        }
    }

   public static List<String> getSuperClasses (String className)
   {
      List<CMDB_Class__c> classes = new List<CMDB_Class__c>();
      classes = [Select ClassName__c, SuperClass__c from CMDB_Class__c Order by Level__c desc];
      List<String> superClasses = new List<String>();
      String baseClassID = null;
      String currentClassID = className;
      for (CMDB_Class__c cls: classes)
      {    
          if(cls.ClassName__c == currentClassID)
          {
             baseClassID = cls.SuperClass__c;
             if(null == baseClassID)
             {
                 superClasses.add(currentClassID);
                 break;
             }
             else
             {
                 superClasses.add(currentClassID);
                 currentClassID = cls.SuperClass__c;
             }
          }
      }
      return superClasses ;
   }


    public static SObject FetchCIObject(string InstanceID, string className, Set<string> columns)
    {
        className+='__c';
        
        string cols='';
        if(columns!=null)
        {
            for(string s: columns)
            {
                cols+=(','+s);
            }
        }
        
        SObject o = Database.query('select ID ' + cols + ' from ' + className + ' where ' + INSTANCE_ID_COL +  '  = \'' + InstanceID + '\' limit 1');
        return o;
    }
    
    public static SObject FetchCIObject(string InstanceID, string className)
    {
       return FetchCIObject(InstanceID, className, null);
    }

    public static SObject getConcreteObjectFromFactory(string s)
    {
        s+='__c';
        SObject o = null;
        
        if(s=='Account') { o = new Account(); }
        else if(s=='Account') { o = new Account(); }
        else if(s=='AccountContactRole') { o = new AccountContactRole(); }
        else if(s=='AccountHistory') { o = new AccountHistory(); }
        else if(s=='AccountPartner') { o = new AccountPartner(); }
        else if(s=='AccountShare') { o = new AccountShare(); }
        else if(s=='ActivityHistory') { o = new ActivityHistory(); }
        else if(s=='AdditionalNumber') { o = new AdditionalNumber(); }
        else if(s=='ApexClass') { o = new ApexClass(); }
        else if(s=='ApexComponent') { o = new ApexComponent(); }
        else if(s=='ApexPage') { o = new ApexPage(); }
        else if(s=='ApexTrigger') { o = new ApexTrigger(); }
        else if(s=='Approval') { o = new Approval(); }
        else if(s=='Asset') { o = new Asset(); }
        else if(s=='AssignmentRule') { o = new AssignmentRule(); }
        else if(s=='AsyncApexJob') { o = new AsyncApexJob(); }
        else if(s=='Attachment') { o = new Attachment(); }
        else if(s=='BMC_AccessPoint__History') { o = new BMC_AccessPoint__History(); }
        else if(s=='BMC_AccessPoint__c') { o = new BMC_AccessPoint__c(); }
        else if(s=='BMC_AccountOnSystem__History') { o = new BMC_AccountOnSystem__History(); }
        else if(s=='BMC_AccountOnSystem__c') { o = new BMC_AccountOnSystem__c(); }
        else if(s=='BMC_Account__History') { o = new BMC_Account__History(); }
        else if(s=='BMC_Account__c') { o = new BMC_Account__c(); }
        else if(s=='BMC_Activity__History') { o = new BMC_Activity__History(); }
        else if(s=='BMC_Activity__c') { o = new BMC_Activity__c(); }
        else if(s=='BMC_ApplicationSystemServices__History') { o = new BMC_ApplicationSystemServices__History(); }
        else if(s=='BMC_ApplicationSystemServices__c') { o = new BMC_ApplicationSystemServices__c(); }
        else if(s=='BMC_ApplicationSystem__History') { o = new BMC_ApplicationSystem__History(); }
        else if(s=='BMC_ApplicationSystem__c') { o = new BMC_ApplicationSystem__c(); }
        else if(s=='BMC_Application__History') { o = new BMC_Application__History(); }
        else if(s=='BMC_Application__c') { o = new BMC_Application__c(); }
        else if(s=='BMC_BaseElement__c') { o = new BMC_BaseElement__c(); }
        else if(s=='BMC_BaseRelationship__History') { o = new BMC_BaseRelationship__History(); }
        else if(s=='BMC_BaseRelationship__c') { o = new BMC_BaseRelationship__c(); }
        else if(s=='BMC_BusinessProcess__History') { o = new BMC_BusinessProcess__History(); }
        else if(s=='BMC_BusinessProcess__c') { o = new BMC_BusinessProcess__c(); }
        else if(s=='BMC_BusinessService__History') { o = new BMC_BusinessService__History(); }
        else if(s=='BMC_BusinessService__c') { o = new BMC_BusinessService__c(); }
        else if(s=='BMC_Cluster__History') { o = new BMC_Cluster__History(); }
        else if(s=='BMC_Cluster__c') { o = new BMC_Cluster__c(); }
        else if(s=='BMC_Collection__History') { o = new BMC_Collection__History(); }
        else if(s=='BMC_Collection__c') { o = new BMC_Collection__c(); }
        else if(s=='BMC_CommunicationEndpoint__History') { o = new BMC_CommunicationEndpoint__History(); }
        else if(s=='BMC_CommunicationEndpoint__c') { o = new BMC_CommunicationEndpoint__c(); }
        else if(s=='BMC_Component__History') { o = new BMC_Component__History(); }
        else if(s=='BMC_Component__c') { o = new BMC_Component__c(); }
        else if(s=='BMC_ComputerSystem__History') { o = new BMC_ComputerSystem__History(); }
        else if(s=='BMC_ComputerSystem__c') { o = new BMC_ComputerSystem__c(); }
        else if(s=='BMC_ConcreteCollection__History') { o = new BMC_ConcreteCollection__History(); }
        else if(s=='BMC_ConcreteCollection__c') { o = new BMC_ConcreteCollection__c(); }
        else if(s=='BMC_ConnectivityCollection__History') { o = new BMC_ConnectivityCollection__History(); }
        else if(s=='BMC_ConnectivityCollection__c') { o = new BMC_ConnectivityCollection__c(); }
        else if(s=='BMC_ContractComponent__c') { o = new BMC_ContractComponent__c(); }
        else if(s=='BMC_ContractLine__History') { o = new BMC_ContractLine__History(); }
        else if(s=='BMC_ContractLine__c') { o = new BMC_ContractLine__c(); }
        else if(s=='BMC_Contract__History') { o = new BMC_Contract__History(); }
        else if(s=='BMC_Contract__c') { o = new BMC_Contract__c(); }
        else if(s=='BMC_DataBase__History') { o = new BMC_DataBase__History(); }
        else if(s=='BMC_DataBase__c') { o = new BMC_DataBase__c(); }
        else if(s=='BMC_Dependency__History') { o = new BMC_Dependency__History(); }
        else if(s=='BMC_Dependency__c') { o = new BMC_Dependency__c(); }
        else if(s=='BMC_Document__History') { o = new BMC_Document__History(); }
        else if(s=='BMC_Document__c') { o = new BMC_Document__c(); }
        else if(s=='BMC_ElementLocation__History') { o = new BMC_ElementLocation__History(); }
        else if(s=='BMC_ElementLocation__c') { o = new BMC_ElementLocation__c(); }
        else if(s=='BMC_HardwareSystemComponent__History') { o = new BMC_HardwareSystemComponent__History(); }
        else if(s=='BMC_HardwareSystemComponent__c') { o = new BMC_HardwareSystemComponent__c(); }
        else if(s=='BMC_HostedAccessPoint__History') { o = new BMC_HostedAccessPoint__History(); }
        else if(s=='BMC_HostedAccessPoint__c') { o = new BMC_HostedAccessPoint__c(); }
        else if(s=='BMC_HostedService__History') { o = new BMC_HostedService__History(); }
        else if(s=='BMC_HostedService__c') { o = new BMC_HostedService__c(); }
        else if(s=='BMC_HostedSystemComponents__History') { o = new BMC_HostedSystemComponents__History(); }
        else if(s=='BMC_HostedSystemComponents__c') { o = new BMC_HostedSystemComponents__c(); }
        else if(s=='BMC_Impact__History') { o = new BMC_Impact__History(); }
        else if(s=='BMC_Impact__c') { o = new BMC_Impact__c(); }
        else if(s=='BMC_InIPSubnet__History') { o = new BMC_InIPSubnet__History(); }
        else if(s=='BMC_InIPSubnet__c') { o = new BMC_InIPSubnet__c(); }
        else if(s=='BMC_InSegment__History') { o = new BMC_InSegment__History(); }
        else if(s=='BMC_InSegment__c') { o = new BMC_InSegment__c(); }
        else if(s=='BMC_LNsInCollection__History') { o = new BMC_LNsInCollection__History(); }
        else if(s=='BMC_LNsInCollection__c') { o = new BMC_LNsInCollection__c(); }
        else if(s=='BMC_LogicalEntity__History') { o = new BMC_LogicalEntity__History(); }
        else if(s=='BMC_LogicalEntity__c') { o = new BMC_LogicalEntity__c(); }
        else if(s=='BMC_LogicalSystemComponent__History') { o = new BMC_LogicalSystemComponent__History(); }
        else if(s=='BMC_LogicalSystemComponent__c') { o = new BMC_LogicalSystemComponent__c(); }
        else if(s=='BMC_MemberOfCollection__History') { o = new BMC_MemberOfCollection__History(); }
        else if(s=='BMC_MemberOfCollection__c') { o = new BMC_MemberOfCollection__c(); }
        else if(s=='BMC_OfferingMeasuredBy__History') { o = new BMC_OfferingMeasuredBy__History(); }
        else if(s=='BMC_OfferingMeasuredBy__c') { o = new BMC_OfferingMeasuredBy__c(); }
        else if(s=='BMC_Offering__History') { o = new BMC_Offering__History(); }
        else if(s=='BMC_Offering__c') { o = new BMC_Offering__c(); }
        else if(s=='BMC_Organization__History') { o = new BMC_Organization__History(); }
        else if(s=='BMC_Organization__c') { o = new BMC_Organization__c(); }
        else if(s=='BMC_Person__History') { o = new BMC_Person__History(); }
        else if(s=='BMC_Person__c') { o = new BMC_Person__c(); }
        else if(s=='BMC_PhysicalLocation__History') { o = new BMC_PhysicalLocation__History(); }
        else if(s=='BMC_PhysicalLocation__c') { o = new BMC_PhysicalLocation__c(); }
        else if(s=='BMC_ProtocolEndPoint__History') { o = new BMC_ProtocolEndPoint__History(); }
        else if(s=='BMC_ProtocolEndPoint__c') { o = new BMC_ProtocolEndPoint__c(); }
        else if(s=='BMC_Role__History') { o = new BMC_Role__History(); }
        else if(s=='BMC_Role__c') { o = new BMC_Role__c(); }
        else if(s=='BMC_ServiceLevelTarget__History') { o = new BMC_ServiceLevelTarget__History(); }
        else if(s=='BMC_ServiceLevelTarget__c') { o = new BMC_ServiceLevelTarget__c(); }
        else if(s=='BMC_ServiceRealizedByOffering__History') { o = new BMC_ServiceRealizedByOffering__History(); }
        else if(s=='BMC_ServiceRealizedByOffering__c') { o = new BMC_ServiceRealizedByOffering__c(); }
        else if(s=='BMC_SettingsOf__History') { o = new BMC_SettingsOf__History(); }
        else if(s=='BMC_SettingsOf__c') { o = new BMC_SettingsOf__c(); }
        else if(s=='BMC_SystemComponent__History') { o = new BMC_SystemComponent__History(); }
        else if(s=='BMC_SystemComponent__c') { o = new BMC_SystemComponent__c(); }
        else if(s=='BMC_System__History') { o = new BMC_System__History(); }
        else if(s=='BMC_System__c') { o = new BMC_System__c(); }
        else if(s=='BMC_UserCommunity__History') { o = new BMC_UserCommunity__History(); }
        else if(s=='BMC_UserCommunity__c') { o = new BMC_UserCommunity__c(); }
        else if(s=='BrandTemplate') { o = new BrandTemplate(); }
        else if(s=='BusinessHours') { o = new BusinessHours(); }
        else if(s=='BusinessProcess') { o = new BusinessProcess(); }
        else if(s=='CMDB_AttributeDefinition__History') { o = new CMDB_AttributeDefinition__History(); }
        else if(s=='CMDB_AttributeDefinition__c') { o = new CMDB_AttributeDefinition__c(); }
        else if(s=='CMDB_Class__c') { o = new CMDB_Class__c(); }
        else if(s=='CallCenter') { o = new CallCenter(); }
        else if(s=='Campaign') { o = new Campaign(); }
        else if(s=='CampaignMember') { o = new CampaignMember(); }
        else if(s=='CampaignMemberStatus') { o = new CampaignMemberStatus(); }
        else if(s=='CampaignShare') { o = new CampaignShare(); }
        else if(s=='Case') { o = new Case(); }
        else if(s=='CaseComment') { o = new CaseComment(); }
        else if(s=='CaseContactRole') { o = new CaseContactRole(); }
        else if(s=='CaseHistory') { o = new CaseHistory(); }
        else if(s=='CaseShare') { o = new CaseShare(); }
        else if(s=='CaseSolution') { o = new CaseSolution(); }
        else if(s=='CaseStatus') { o = new CaseStatus(); }
        else if(s=='CaseTeamMember') { o = new CaseTeamMember(); }
        else if(s=='CaseTeamRole') { o = new CaseTeamRole(); }
        else if(s=='CaseTeamTemplate') { o = new CaseTeamTemplate(); }
        else if(s=='CaseTeamTemplateMember') { o = new CaseTeamTemplateMember(); }
        else if(s=='CaseTeamTemplateRecord') { o = new CaseTeamTemplateRecord(); }
        else if(s=='CategoryData') { o = new CategoryData(); }
        else if(s=='CategoryNode') { o = new CategoryNode(); }
        else if(s=='Community') { o = new Community(); }
        else if(s=='Contact') { o = new Contact(); }
        else if(s=='ContactHistory') { o = new ContactHistory(); }
        else if(s=='ContactShare') { o = new ContactShare(); }
        else if(s=='Contract') { o = new Contract(); }
        else if(s=='ContractContactRole') { o = new ContractContactRole(); }
        else if(s=='ContractHistory') { o = new ContractHistory(); }
        else if(s=='ContractStatus') { o = new ContractStatus(); }
        else if(s=='CronTrigger') { o = new CronTrigger(); }
        else if(s=='Document') { o = new Document(); }
        else if(s=='DocumentAttachmentMap') { o = new DocumentAttachmentMap(); }
        else if(s=='EmailServicesAddress') { o = new EmailServicesAddress(); }
        else if(s=='EmailServicesFunction') { o = new EmailServicesFunction(); }
        else if(s=='EmailStatus') { o = new EmailStatus(); }
        else if(s=='EmailTemplate') { o = new EmailTemplate(); }
        else if(s=='Event') { o = new Event(); }
        else if(s=='EventAttendee') { o = new EventAttendee(); }
        else if(s=='FiscalYearSettings') { o = new FiscalYearSettings(); }
        else if(s=='Folder') { o = new Folder(); }
        else if(s=='ForecastShare') { o = new ForecastShare(); }
        else if(s=='Group') { o = new Group(); }
        else if(s=='GroupMember') { o = new GroupMember(); }
        else if(s=='Holiday') { o = new Holiday(); }
        else if(s=='Idea') { o = new Idea(); }
        else if(s=='IdeaComment') { o = new IdeaComment(); }
        else if(s=='Lead') { o = new Lead(); }
        else if(s=='LeadHistory') { o = new LeadHistory(); }
        else if(s=='LeadShare') { o = new LeadShare(); }
        else if(s=='LeadStatus') { o = new LeadStatus(); }
        else if(s=='MailmergeTemplate') { o = new MailmergeTemplate(); }
        else if(s=='Name') { o = new Name(); }
        else if(s=='Note') { o = new Note(); }
        else if(s=='NoteAndAttachment') { o = new NoteAndAttachment(); }
        else if(s=='OpenActivity') { o = new OpenActivity(); }
        else if(s=='Opportunity') { o = new Opportunity(); }
        else if(s=='OpportunityCompetitor') { o = new OpportunityCompetitor(); }
        else if(s=='OpportunityContactRole') { o = new OpportunityContactRole(); }
        else if(s=='OpportunityFieldHistory') { o = new OpportunityFieldHistory(); }
        else if(s=='OpportunityHistory') { o = new OpportunityHistory(); }
        else if(s=='OpportunityLineItem') { o = new OpportunityLineItem(); }
        else if(s=='OpportunityPartner') { o = new OpportunityPartner(); }
        else if(s=='OpportunityShare') { o = new OpportunityShare(); }
        else if(s=='OpportunityStage') { o = new OpportunityStage(); }
        else if(s=='OrgWideEmailAddress') { o = new OrgWideEmailAddress(); }
        else if(s=='Organization') { o = new Organization(); }
        else if(s=='Partner') { o = new Partner(); }
        else if(s=='PartnerRole') { o = new PartnerRole(); }
        else if(s=='Period') { o = new Period(); }
        else if(s=='Pricebook2') { o = new Pricebook2(); }
        else if(s=='PricebookEntry') { o = new PricebookEntry(); }
        else if(s=='ProcessInstance') { o = new ProcessInstance(); }
        else if(s=='ProcessInstanceHistory') { o = new ProcessInstanceHistory(); }
        else if(s=='ProcessInstanceStep') { o = new ProcessInstanceStep(); }
        else if(s=='ProcessInstanceWorkitem') { o = new ProcessInstanceWorkitem(); }
        else if(s=='Product2') { o = new Product2(); }
        else if(s=='Profile') { o = new Profile(); }
        else if(s=='QueueSobject') { o = new QueueSobject(); }
        else if(s=='RecordType') { o = new RecordType(); }
        else if(s=='Scontrol') { o = new Scontrol(); }
        else if(s=='SelfServiceUser') { o = new SelfServiceUser(); }
        else if(s=='Solution') { o = new Solution(); }
        else if(s=='SolutionHistory') { o = new SolutionHistory(); }
        else if(s=='SolutionStatus') { o = new SolutionStatus(); }
        else if(s=='StaticResource') { o = new StaticResource(); }
        else if(s=='Task') { o = new Task(); }
        else if(s=='TaskPriority') { o = new TaskPriority(); }
        else if(s=='TaskStatus') { o = new TaskStatus(); }
        else if(s=='User') { o = new User(); }
        else if(s=='UserLicense') { o = new UserLicense(); }
        else if(s=='UserPreference') { o = new UserPreference(); }
        else if(s=='UserRole') { o = new UserRole(); }
        else if(s=='Vote') { o = new Vote(); }
        else if(s=='WebLink') { o = new WebLink(); }
                
        
                
        return o;    
    }
    
}
			                            	