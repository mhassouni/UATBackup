@isTest
public class GenDocContractsFromQuote_Test {
	@isTest
    public static void GenDocContractsFromQuoteTest(){
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        insert quote;
        Account Acc=new Account(Name='test',PaysRegionPF__c='DO1A',	TypeIdentifiantNational__c='SIREN');
        insert Acc;
        Contract con=new Contract(SBQQ__Quote__c=quote.id,Status='Draft',StartDate=System.today(),ContractTerm=13,AccountId=acc.id);
    	insert con;
        Test.StartTest(); 
        	ApexPages.StandardController sc = new ApexPages.StandardController(quote);
			ApexPages.currentPage().getParameters().put('id', String.valueOf(quote.Id));
			GenDocContractsFromQuote  genDocCon = new GenDocContractsFromQuote(sc);
			genDocCon.quote=quote;
		Test.StopTest();
    }
}