public class CMDBDataLoader
{

    public void AddAttributes()
    {
        List<CMDB_Class__c> classes = [select ID, ClassName__c from CMDB_Class__c];
        
        Map<string,List<string>> m = getClassAttribMap();
        /*
        Map<string,List<string>> m = new Map<string,List<string>>();
        
        List<string> l = null;
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        for(CMDB_Class__c cls: classes)
        {
            system.debug('Processing class-->'+cls.ClassName__c);
            Schema.SObjectType typ = gd.get(cls.ClassName__c+'__c');
            if(null!=typ)
            {
                Map<string, object> flds = typ.getDescribe().fields.getMap();
                l = new List<string>();
                if(flds!=null)
                {
                    for(string k : flds.keyset())
                    {
                        system.debug(cls.ClassName__c + '-->'+k);
                        l.Add(k);
                    }
                }
                m.put(cls.ClassName__c,l);
            }
        }
        */
        
        /*        
            Map<string,List<string>> m = new Map<string,List<string>>();
            List<string> l = null;
            
            l = new List<string>();
            l.Add('MyAttrib1');
            l.Add('MyAttrib2');
            m.put('BMC_AccessPoint',l);
        */
        
        ///---map completed

        List<string> attrs = new List<string>();
        List<CMDB_AttributeDefinition__c> lObjects = new List<CMDB_AttributeDefinition__c>();
        Integer cnt=0;
        for(CMDB_Class__c cls: classes)
        {
            attrs = m.get(cls.ClassName__c) ;
            if(attrs!=null)
            {
                for(string attrName : attrs)
                {
                    CMDB_AttributeDefinition__c newObj = new CMDB_AttributeDefinition__c();
                    newObj.AttributeName__c = attrName;
                    newObj.ClassID__c = cls.ID;
                    newObj.AttributeID__c = ('ATTR_' + DateTime.Now().format('yyyy_M_d_h_m_s_S')+ cnt);
                    cnt++;
                    lObjects.Add(newObj);
                }
            }
        }
        
        upsert lObjects;
    }
    
    public void deleteAllAttributes()
    {
        List<CMDB_AttributeDefinition__c> lObjects = [select ID from CMDB_AttributeDefinition__c];
        delete lObjects;
    }
    
    public void DeleteCMDBData()
    {
        //List<CMDB_Class__c> classes = [select ID, from CMDB_Class__c];
    }
    

    public Map<string,List<string>> getClassAttribMap()
    {
         Map<string,List<string>> m = new Map<string,List<string>>();
         List<string> l = null;        
         
         
         
                     
            l = new List<string>(); 
            l.Add('SystemClassId__c');
            l.Add('SystemName__c');
            m.put('BMC_AccessPoint',l);
            l = new List<string>(); 
            l.Add('AccountType__c');
            m.put('BMC_AccountOnSystem',l);
            l = new List<string>(); 
            m.put('BMC_Account',l);
            l = new List<string>(); 
            l.Add('Manual_Interaction_Business_Process_S__c');
            m.put('BMC_Activity',l);
            l = new List<string>(); 
            m.put('BMC_ApplicationSystemServices',l);
            l = new List<string>(); 
            l.Add('BuildNumber__c');
            l.Add('PatchNumber__c');
            l.Add('ServicePack__c');
            m.put('BMC_ApplicationSystem',l);
            l = new List<string>(); 
            l.Add('ApplicationType__c');
            m.put('BMC_Application',l);
            l = new List<string>(); 
            l.Add('AccountID__c');
            l.Add('AssignedTo__c');
            l.Add('AttributeDataSourceList__c');
            l.Add('Availability__c');
            l.Add('Category__c');
            l.Add('CITag__c');
            l.Add('ClassId__c');
            l.Add('CMDBRowLevelSecurity__c');
            l.Add('CMDBWriteSecurity__c');
            l.Add('Confidentiality__c');
            l.Add('CreateDate__c');
            l.Add('DatasetId__c');
            l.Add('Description__c');
            l.Add('FailedAutomaticIdentification__c');
            l.Add('History__c');
            l.Add('ImpactComputationModel__c');
            l.Add('InstanceId__c');
            l.Add('Integrity__c');
            l.Add('Item__c');
            l.Add('LastModifiedBy__c');
            l.Add('LastScanDate__c');
            l.Add('ManufacturerName__c');
            l.Add('MarkAsDeleted__c');
            l.Add('Model__c');
            l.Add('ModifiedDate__c');
            l.Add('Name__c');
            l.Add('NameFormat__c');
            l.Add('Notes__c');
            l.Add('OwnerContact__c');
            l.Add('OwnerName__c');
            l.Add('ParentCITag__c');
            l.Add('Priority__c');
            l.Add('ReconciliationIdentity__c');
            l.Add('ReferenceInstance__c');
            l.Add('RequestId__c');
            l.Add('SerialNumber__c');
            l.Add('ShortDescription__c');
            l.Add('Submitter__c');
            l.Add('Supported__c');
            l.Add('TokenFormat__c');
            l.Add('TokenId__c');
            l.Add('Type__c');
            l.Add('Version_Number__c');
            m.put('BMC_BaseElement',l);
            l = new List<string>(); 
            l.Add('AccountID__c');
            l.Add('AssignedTo__c');
            l.Add('AttributeDataSourceList__c');
            l.Add('ClassId__c');
            l.Add('CMDBRowLevelSecurity__c');
            l.Add('CMDBWriteSecurity__c');
            l.Add('CreateDate__c');
            l.Add('DatasetId__c');
            l.Add('HasImpact__c');
            l.Add('ImpactDirection__c');
            l.Add('Destination_ClassId__c');
            l.Add('Destination_DatasetId__c');
            l.Add('Destination_InstanceId__c');
            l.Add('Destination_ReconciliationIdentity__c');
            l.Add('ImpactPropagationModel__c');
            l.Add('ImpactWeight__c');
            l.Add('InstanceId__c');
            l.Add('LastModifiedBy__c');
            l.Add('MarkAsDeleted__c');
            l.Add('ModifiedDate__c');
            l.Add('Name__c');
            l.Add('ReconciliationIdentity__c');
            l.Add('RequestId__c');
            l.Add('ShortDescription__c');
            l.Add('Source_ClassId__c');
            l.Add('Source_DatasetId__c');
            l.Add('Source_InstanceId__c');
            l.Add('Source_ReconciliationIdentity__c');
            l.Add('Status__c');
            l.Add('Submitter__c');
            m.put('BMC_BaseRelationship',l);
            l = new List<string>(); 
            l.Add('SourceLocation__c');
            m.put('BMC_BusinessProcess',l);
            l = new List<string>(); 
            l.Add('ServiceType__c');
            m.put('BMC_BusinessService',l);
            l = new List<string>(); 
            l.Add('ClusterType__c');
            l.Add('Interconnect__c');
            l.Add('InterconnectAddress__c');
            l.Add('MaxNumberOfNodes__c');
            l.Add('Types__c');
            m.put('BMC_Cluster',l);
            l = new List<string>(); 
            m.put('BMC_Collection',l);
            l = new List<string>(); 
            l.Add('PortNumber__c');
            m.put('BMC_CommunicationEndpoint',l);
            l = new List<string>(); 
            m.put('BMC_Component',l);
            l = new List<string>(); 
            l.Add('AdminPasswordStatus__c');
            l.Add('BootROMSupported__c');
            l.Add('CapabilityList__c');
            l.Add('ChassisBootupState__c');
            l.Add('ConfigurationOptions__c');
            l.Add('DataRate__c');
            l.Add('DHCPUse__c');
            l.Add('Domain__c');
            l.Add('EnvironmentSpecification__c');
            l.Add('Expansion__c');
            l.Add('ExpansionInterface__c');
            l.Add('FirmwareVersion__c');
            l.Add('FlashMemory__c');
            l.Add('Frequency__c');
            l.Add('HostName__c');
            l.Add('InputCurrent__c');
            l.Add('InputVoltage__c');
            l.Add('MaxConsumption__c');
            l.Add('MediaSupported__c');
            l.Add('NumberOfSlots__c');
            l.Add('OtherCapabilityDescription__c');
            l.Add('PortsPerSlot__c');
            l.Add('PrimaryCapability__c');
            l.Add('ResetCapability__c');
            l.Add('ResetCount__c');
            l.Add('ResetLimit__c');
            l.Add('SystemOID__c');
            l.Add('SystemType__c');
            l.Add('ThermalState__c');
            l.Add('TotalPhysicalMemory__c');
            l.Add('VirtualSystemType__c');
            l.Add('Workgroup__c');
            m.put('BMC_ComputerSystem',l);
            l = new List<string>(); 
            m.put('BMC_ConcreteCollection',l);
            l = new List<string>(); 
            l.Add('ConnectivityCollectionType__c');
            l.Add('ConnectivityStatus__c');
            m.put('BMC_ConnectivityCollection',l);
            l = new List<string>(); 
            l.Add('ConnectivityType__c');
            l.Add('Count__c');
            l.Add('Fixed__c');
            l.Add('NetworkID__c');
            l.Add('OtherTypeDescription__c');
            m.put('BMC_ConnectivitySegment',l);
            l = new List<string>(); 
            m.put('BMC_ContractComponent',l);
            l = new List<string>(); 
            l.Add('ContractLineType__c');
            m.put('BMC_ContractLine',l);
            l = new List<string>(); 
            l.Add('ContractType__c');
            m.put('BMC_Contract',l);
            l = new List<string>(); 
            m.put('BMC_DataBase',l);
            l = new List<string>(); 
            m.put('BMC_Dependency',l);
            l = new List<string>(); 
            l.Add('InterfaceType__c');
            l.Add('Partitions__c');
            l.Add('SCSIBus__c');
            l.Add('SCSILogicalUnit__c');
            l.Add('SCSIPort__c');
            l.Add('SCSITargetID__c');
            l.Add('SectorsPerTrack__c');
            l.Add('Size__c');
            l.Add('TotalCylinders__c');
            l.Add('TotalHeads__c');
            l.Add('TotalSectors__c');
            l.Add('TotalTracks__c');
            l.Add('TracksPerCylinder__c');
            m.put('BMC_DiskDrive',l);
            l = new List<string>(); 
            l.Add('Author__c');
            l.Add('DocumentDate__c');
            l.Add('DocumentSize__c');
            l.Add('DocumentStatus__c');
            l.Add('DocumentType__c');
            l.Add('EndDate__c');
            l.Add('FileName__c');
            l.Add('Keywords__c');
            l.Add('Locale__c');
            l.Add('StartDate__c');
            m.put('BMC_Document',l);
            l = new List<string>(); 
            l.Add('ElementLocation__c');
            m.put('BMC_ElementLocation',l);
            l = new List<string>(); 
            l.Add('PNPDeviceID__c');
            l.Add('PowerManagementCapabilities__c');
            l.Add('SystemAvailability__c');
            m.put('BMC_HardwareSystemComponent',l);
            l = new List<string>(); 
            m.put('BMC_HostedAccessPoint',l);
            l = new List<string>(); 
            m.put('BMC_HostedService',l);
            l = new List<string>(); 
            m.put('BMC_HostedSystemComponents',l);
            l = new List<string>(); 
            l.Add('AddressType__c');
            l.Add('DNSHostName__c');
            l.Add('ManagementAddress__c');
            l.Add('PrefixLength__c');
            l.Add('SubnetMask__c');
            m.put('BMC_IPEndpoint',l);
            l = new List<string>(); 
            m.put('BMC_Impact',l);
            l = new List<string>(); 
            m.put('BMC_InIPSubnet',l);
            l = new List<string>(); 
            m.put('BMC_InSegment',l);
            l = new List<string>(); 
            l.Add('AliasAddresses__c');
            l.Add('GroupAddresses__c');
            l.Add('LANID__c');
            l.Add('MACAddress__c');
            m.put('BMC_LANEndpoint',l);
            l = new List<string>(); 
            m.put('BMC_LNsInCollection',l);
            l = new List<string>(); 
            m.put('BMC_LogicalEntity',l);
            l = new List<string>(); 
            m.put('BMC_LogicalSystemComponent',l);
            l = new List<string>(); 
            l.Add('AvailableCPs__c');
            l.Add('AvailableIFAs__c');
            l.Add('AvailableIFCs__c');
            l.Add('AvailableIFLs__c');
            l.Add('GridLocation__c');
            l.Add('InstalledCPUs__c');
            l.Add('InstalledCPs__c');
            l.Add('InstalledDASD__c');
            l.Add('NumberChannels__c');
            l.Add('NumberOfLPARS__c');
            l.Add('PhysicalMemory__c');
            m.put('BMC_Mainframe',l);
            l = new List<string>(); 
            m.put('BMC_MemberOfCollection',l);
            l = new List<string>(); 
            l.Add('Capacity__c');
            l.Add('FormFactor__c');
            l.Add('HotSwappable__c');
            l.Add('MemoryType__c');
            l.Add('Removable__c');
            l.Add('Replaceable__c');
            l.Add('Speed__c');
            m.put('BMC_Memory',l);
            l = new List<string>(); 
            l.Add('ClientSiteName__c');
            l.Add('DSDirectoryServiceFlag__c');
            l.Add('DSDnsControllerFlag__c');
            l.Add('DSDnsDomainFlag__c');
            l.Add('DSDnsForestFlag__c');
            l.Add('DSGlobalCatalogFlag__c');
            l.Add('DSKerberosDistributionCenterFlag__c');
            l.Add('DSPrimaryDomainControllerFlag__c');
            l.Add('DSTimeServiceFlag__c');
            l.Add('DSWritableFlag__c');
            l.Add('DcSiteName__c');
            l.Add('DnsForestName__c');
            l.Add('DomainControllerAddressType__c');
            l.Add('DomainControllerAddress__c');
            l.Add('DomainControllerName__c');
            l.Add('DomainGuid__c');
            l.Add('DomainName__c');
            m.put('BMC_NTDomain',l);
            l = new List<string>(); 
            m.put('BMC_OfferingMeasuredBy',l);
            l = new List<string>(); 
            l.Add('OfferingType__c');
            m.put('BMC_Offering',l);
            l = new List<string>(); 
            l.Add('BusinessCategory__c');
            l.Add('Email__c');
            l.Add('URI__c');
            m.put('BMC_Organization',l);
            l = new List<string>(); 
            l.Add('Email__c');
            l.Add('Fax__c');
            l.Add('FirstName__c');
            l.Add('LastName__c');
            l.Add('MiddleName__c');
            l.Add('MobilePhone__c');
            l.Add('OfficePhone__c');
            l.Add('PagerEmail__c');
            l.Add('PagerParams1__c');
            l.Add('PagerParams2__c');
            l.Add('PagerPhoneNumber__c');
            l.Add('PagerPINNumber__c');
            l.Add('PagerProvider__c');
            l.Add('PagerSoftware__c');
            l.Add('PagerType__c');
            l.Add('PersonAdditionalDetails__c');
            l.Add('PersonDepartment__c');
            l.Add('PersonId__c');
            l.Add('PersonRegion__c');
            l.Add('SecondaryEmail__c');
            l.Add('Title__c');
            l.Add('WebPage__c');
            m.put('BMC_Person',l);
            l = new List<string>(); 
            l.Add('Address__c');
            l.Add('AddressAdditionalInfo__c');
            l.Add('Altitude__c');
            l.Add('City__c');
            l.Add('CoordinateFormat__c');
            l.Add('Country__c');
            l.Add('CountryCode__c');
            l.Add('FaxNumber__c');
            l.Add('Latitude__c');
            l.Add('Longitude__c');
            l.Add('MailStop__c');
            l.Add('PhoneNumber__c');
            l.Add('PhysicalPosition__c');
            l.Add('PostalCode__c');
            l.Add('StateOrProvince__c');
            l.Add('WebPage__c');
            m.put('BMC_PhysicalLocation',l);
            l = new List<string>(); 
            l.Add('AveragePagesPerMinute__c');
            l.Add('HorizontalResolution__c');
            l.Add('MarkingTechnology__c');
            l.Add('NumberOfTrays__c');
            l.Add('PaperSizesSupported__c');
            l.Add('PortName__c');
            l.Add('PrinterCapabilities__c');
            l.Add('PrinterLanguageList__c');
            l.Add('PrinterType__c');
            l.Add('VerticalResolution__c');
            m.put('BMC_Printer',l);
            l = new List<string>(); 
            l.Add('Address__c');
            l.Add('ProtocolType__c');
            m.put('BMC_ProtocolEndPoint',l);
            l = new List<string>(); 
            l.Add('CommonName__c');
            m.put('BMC_Role',l);
            l = new List<string>(); 
            l.Add('SLTType__c');
            m.put('BMC_ServiceLevelTarget',l);
            l = new List<string>(); 
            m.put('BMC_ServiceRealizedByOffering',l);
            l = new List<string>(); 
            l.Add('IsCurrent__c');
            l.Add('IsDefault__c');
            l.Add('IsMaximum__c');
            l.Add('IsMinimum__c');
            l.Add('IsNext__c');
            l.Add('IsPending__c');
            m.put('BMC_SettingsOf',l);
            l = new List<string>(); 
            l.Add('BuildNumber__c');
            l.Add('BuildType__c');
            l.Add('ConfigurationBasicNumber__c');
            l.Add('ContractID__c');
            l.Add('InstallLocation__c');
            l.Add('LicenseType__c');
            l.Add('LicensesAvailable__c');
            l.Add('PatchNumber__c');
            l.Add('ServicePack__c');
            m.put('BMC_Software',l);
            l = new List<string>(); 
            l.Add('isVirtual__c');
            l.Add('SystemClassId__c');
            l.Add('SystemName__c');
            m.put('BMC_SystemComponent',l);
            l = new List<string>(); 
            m.put('BMC_SystemSoftware',l);
            l = new List<string>(); 
            l.Add('IsVirtual__c');
            m.put('BMC_System',l);
            l = new List<string>(); 
            l.Add('TransactionType__c');
            m.put('BMC_Transaction',l);
            l = new List<string>(); 
            l.Add('Count__c');
            l.Add('SPOC__c');
            m.put('BMC_UserCommunity',l);
                     
                     
                     
                     
                     
                     
                     
         for(List<string> lst : m.values())
         {
             lst.Add(CMDBHelper.INSTANCE_ID_COL);
         }   
                     
         return m;
    }
}
			                            	