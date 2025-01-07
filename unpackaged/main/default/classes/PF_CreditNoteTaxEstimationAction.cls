public class PF_CreditNoteTaxEstimationAction {

    @InvocableMethod(label='Estimate Tax' description='Estimate Tax for the specified Credit Note IDs.')
    public static void estimateTax(List<Id> CreditNoteIds)
    {
        for(Id cnId: CreditNoteIds)
        {
        	blng.CreditNoteLineAPI.estimateTaxForCreditNoteLines(cnId);
        }
    }
}