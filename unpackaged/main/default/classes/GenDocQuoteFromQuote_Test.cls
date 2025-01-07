@isTest
public class GenDocQuoteFromQuote_Test {
@isTest
    public static void GenDocCreditNoteFromCreditNoteTest(){
        Account acc=new Account(Name='test',PaysRegionPF__c='DO1A',	TypeIdentifiantNational__c='SIREN');
        insert acc;
        SBQQ__Quote__c  quote=new SBQQ__Quote__c ();
    	insert quote;
        Test.StartTest(); 
        	ApexPages.StandardController sc = new ApexPages.StandardController(acc);
			ApexPages.currentPage().getParameters().put('id', String.valueOf(quote.Id));
			GenDocQuoteFromQuote  genDocCreditNote = new GenDocQuoteFromQuote(sc);
			genDocCreditNote.quote=quote;
		Test.StopTest();
    }
}