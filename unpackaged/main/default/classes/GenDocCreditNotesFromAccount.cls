public class GenDocCreditNotesFromAccount {
	public Account acc { get; set; }
    public List<blng__CreditNote__c> creditNotes { get; set; }
    public Boolean allDocsAlreadyGenerated { get; set; }
    public GenDocCreditNotesFromAccount(ApexPages.StandardController stdController) {
        allDocsAlreadyGenerated=false;
        String id = ApexPages.currentPage().getParameters().get('id');
        creditNotes = [SELECT id,blng__Account__c,templateId__c,Facture_Genere__c   FROM blng__CreditNote__c where blng__Account__c=:id];
        integer nombreTotalDesFactureGenere=0;
        for(blng__CreditNote__c creditNote:creditNotes){
            system.debug('before condition');
            if(creditNote.Facture_Genere__c){
                nombreTotalDesFactureGenere++;
            }
        }
        if(nombreTotalDesFactureGenere==creditNotes.size()){
            allDocsAlreadyGenerated=true;
        }
    }
}