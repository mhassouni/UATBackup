public class LeadConversionHelper {
    @InvocableMethod
    public static void convertLeads(List<Id> leadIds) {
        // Convertir les pistes
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
                LeadStatus cLeadStatus=[Select Id,MasterLabel from LeadStatus where isConverted=true and MasterLabel = 'Convertie' limit 1];

        for(Id leadId : leadIds) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadId);
            lc.setConvertedStatus(cLeadStatus.MasterLabel);

            // Configurez d'autres options de conversion ici si nécessaire
            leadConverts.add(lc);
        }
        //List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, false);
        List<Database.LeadConvertResult> results = Database.convertLead(leadConverts);
    }
}