@isTest
public class GenDocCreditNoteFromCreditNote_Test {
@isTest
    public static void GenDocCreditNoteFromCreditNoteTest(){
        Account acc=new Account(Name='test',PaysRegionPF__c='DO1A',	TypeIdentifiantNational__c='SIREN');
        insert acc;
        blng__CreditNote__c  creditNote=new blng__CreditNote__c (blng__CreditNoteDate__c=system.today(),blng__Account__c=acc.id);
    	insert creditNote;
        Test.StartTest(); 
        	ApexPages.StandardController sc = new ApexPages.StandardController(acc);
			ApexPages.currentPage().getParameters().put('id', String.valueOf(creditNote.Id));
			GenDocCreditNoteFromCreditNote  genDocCreditNote = new GenDocCreditNoteFromCreditNote(sc);
			genDocCreditNote.cr=creditNote;
		Test.StopTest();
    }
}