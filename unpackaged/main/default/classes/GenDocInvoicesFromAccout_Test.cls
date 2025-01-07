@isTest
public class GenDocInvoicesFromAccout_Test {
	@isTest
    public static void GenDocInvoicesFromAccoutTest(){
        Account acc=new Account(Name='test',PaysRegionPF__c='DO1A',	TypeIdentifiantNational__c='SIREN');
        insert acc;
        blng__Invoice__c invoice=new blng__Invoice__c(blng__Account__c=acc.id);
    	insert invoice;
        Test.StartTest(); 
        	ApexPages.StandardController sc = new ApexPages.StandardController(acc);
			ApexPages.currentPage().getParameters().put('id', String.valueOf(acc.Id));
			GenDocInvoicesFromAccount  genDocInvoice = new GenDocInvoicesFromAccount(sc);
			genDocInvoice.acc=acc;
		Test.StopTest();
    }
}