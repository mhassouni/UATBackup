public class GenDocInvoicesFromAccount {
	public Account acc { get; set; }
    public List<blng__Invoice__c> invoices { get; set; }
    public Boolean allDocsAlreadyGenerated { get; set; }
    public GenDocInvoicesFromAccount(ApexPages.StandardController stdController) {
        allDocsAlreadyGenerated=false;
        String id = ApexPages.currentPage().getParameters().get('id');
        invoices = [SELECT id,blng__Account__c,templateId__c,Facture_Genere__c   FROM blng__Invoice__c where blng__Account__c=:id];
        integer nombreTotalDesFactureGenere=0;
        for(blng__Invoice__c invoice:invoices){
            system.debug('before condition');
            if(invoice.Facture_Genere__c){
                nombreTotalDesFactureGenere++;
            }
        }
        if(nombreTotalDesFactureGenere==invoices.size()){
            allDocsAlreadyGenerated=true;
        }
    }
}