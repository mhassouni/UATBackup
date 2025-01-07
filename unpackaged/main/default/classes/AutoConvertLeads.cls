public class AutoConvertLeads {

    @InvocableMethod(label='ConvertedLead' description='Apex ConvertLead for Flow')

    public static void assignLeads(List<LeadToConvert> LeadIds){

        LeadStatus cLeadStatus=[Select Id,MasterLabel from LeadStatus where isConverted=true and MasterLabel = 'Convertie' limit 1];

        List<Database.LeadConvert> massLeadConvert=new List<Database.LeadConvert>();

        for(LeadToConvert currentLead:LeadIds){

            Database.LeadConvert LeadConvert=new Database.LeadConvert();

            LeadConvert.setLeadId(currentLead.leadID);
            LeadConvert.setAccountId(currentLead.accountID);
            LeadConvert.setContactId(currentLead.contactID);
            LeadConvert.setConvertedStatus(cLeadStatus.MasterLabel);
            LeadConvert.setDoNotCreateOpportunity(true);
            LeadConvert.setOwnerId(UserInfo.getUserId());

            massLeadConvert.add(LeadConvert);
        }

        if(!massLeadConvert.isEmpty()){

            List<Database.LeadConvertResult> lcr=Database.convertLead(massLeadConvert);

            system.debug('lcr:: '+lcr);

        }

    }

    public class LeadToConvert {
        @InvocableVariable(label='AccountID' description='AccountID associated to lead converted')
        public Id accountID;
    
        @InvocableVariable(label='ContactID' description='ContactID associated to lead converted')
        public Id contactID;

        @InvocableVariable(label='LeadID' description='LeadID')
        public Id leadID;

    }

}