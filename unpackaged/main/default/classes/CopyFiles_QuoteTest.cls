@isTest

public class CopyFiles_QuoteTest {
    @isTest static void TestCopyFileFicheRenseignement()
    {
        test.startTest();
        Account acc = TestDataFactory.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient);
        acc.Statut__c='Validé CM';acc.IDEulerHermes__c='123';acc.Ligne1__c='Ligne1';acc.CodePostal__c='93420';acc.ville__c='Villepinte';acc.Pays__c='France';
        update acc;
         TestDataFactory.createFinancialCond(acc.Id);
        Contact Cont = TestDataFactory.createContact('Test', acc.id);
        blng__LegalEntity__c legEnt =  TestDataFactory.createLegalEntity();
        Opportunity opp = TestDataFactory.createOpportunity('opp1', acc.Id, null, Label.OPP_StageName_OpportuniteCreee, 'PRG', legEnt.Id);
        opp.TypeProduits__c='Containers';Update opp;
        SBQQ__Quote__c quote = TestDataFactory.createCPQQuote(opp.Id, true, acc.Id, Date.today(), 12);
		Information_Sheet__c Fiche = new Information_Sheet__c();
        Fiche.Quote__c = quote.id;
        insert Fiche;
        ContentVersion cv = new ContentVersion();
        cv.Title = 'FR-TEST-ttile';
        cv.PathOnClient = 'FR-TEST.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
       
      	///
        ContentDocumentLink NewCDL = new ContentDocumentLink();
        NewCDL.ContentDocumentId = [select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        NewCDL.LinkedEntityId = quote.id;
        NewCDL.ShareType='I';
        NewCDL.Visibility='InternalUsers';
        insert NewCDL;
        
        //test
        list<ContentDocumentLink> L = [select id from ContentDocumentLink where LinkedEntityId=:fiche.id];
        system.debug('L='+L);
        system.assertEquals(1, L.size());
        test.stopTest();
    }
    
     @isTest static void TestCopyFileContratMA()
    {
        test.startTest();
        Account acc = TestDataFactory.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient);
        acc.Statut__c='Validé CM';acc.IDEulerHermes__c='123';acc.Ligne1__c='Ligne1';acc.CodePostal__c='93420';acc.ville__c='Villepinte';acc.Pays__c='France';
        update acc;
         TestDataFactory.createFinancialCond(acc.Id);
        Contact Cont = TestDataFactory.createContact('Test', acc.id);
        blng__LegalEntity__c legEnt =  TestDataFactory.createLegalEntity();
        Opportunity opp = TestDataFactory.createOpportunity('opp1', acc.Id, null, Label.OPP_StageName_OpportuniteCreee, 'PRG', legEnt.Id);
        opp.TypeProduits__c='Containers';Update opp;
        SBQQ__Quote__c quote = TestDataFactory.createCPQQuote(opp.Id, true, acc.Id, Date.today(), 12);
		//Information_Sheet__c Fiche = new Information_Sheet__c();
		Order order = TestDataFactory.createOrder(acc.Id, Date.today(), Date.today().addMonths(12), quote.Id, opp.Id); 
        
		//Contract ct = TestDataFactory.createContract(acc.Id, quote.Id, 'Draft', Date.today(), 12, Date.today().addMonths(12).addDays(2), order.Id, opp.Id);
		//Contract ct = TestDataFactory.createContract(acc.Id, quote.Id, 'Draft', Date.today(), 12, Date.today().addMonths(12).addDays(2), order.Id, opp.Id);
          Contract ct = new Contract();
        ct.AccountId = acc.id;
        ct.Status = 'Draft';
        ct.StartDate = Date.today();
        ct.EndDate =  Date.today().addMonths(12).addDays(2);
        ct.ContractTerm = 12;
        ct.SBQQ__Quote__c = quote.Id;
        ct.SBQQ__Order__c = order.Id;
        ct.SBQQ__Opportunity__c = opp.Id;
        insert ct;
		String ContractNumber = [select ContractNumber from Contract where id=:ct.id].ContractNumber;
        system.debug('ct.ContractNumber:'+ContractNumber);
        ContentVersion cv = new ContentVersion();
        cv.Title = 'MA container_'+ContractNumber+'_2022-12-19_completed';
        cv.PathOnClient = 'MA Container_'+ContractNumber+'_2022-12-19_completed.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
       
        ContentDocumentLink NewCDL = new ContentDocumentLink();
        NewCDL.ContentDocumentId = [select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        NewCDL.LinkedEntityId = quote.id;
        NewCDL.ShareType='I';
        NewCDL.Visibility='InternalUsers';
        insert NewCDL;
        
        //test
        list<ContentDocumentLink> L = [select id from ContentDocumentLink where LinkedEntityId=:ct.id];
        system.debug('L='+L);
        system.assertEquals(1, L.size());
        test.stopTest();
    }
      @isTest static void TestCopyFileContract()
    {
        test.startTest();
        Account acc = TestDataFactory.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient);
        acc.Statut__c='Validé CM';acc.IDEulerHermes__c='123';acc.Ligne1__c='Ligne1';acc.CodePostal__c='93420';acc.ville__c='Villepinte';acc.Pays__c='France';
        update acc;
         TestDataFactory.createFinancialCond(acc.Id);
        Contact Cont = TestDataFactory.createContact('Test', acc.id);
        blng__LegalEntity__c legEnt =  TestDataFactory.createLegalEntity();
        Opportunity opp = TestDataFactory.createOpportunity('opp1', acc.Id, null, Label.OPP_StageName_OpportuniteCreee, 'PRG', legEnt.Id);
        opp.TypeProduits__c='Containers';Update opp;
        SBQQ__Quote__c quote = TestDataFactory.createCPQQuote(opp.Id, true, acc.Id, Date.today(), 12);
		
		Order order = TestDataFactory.createOrder(acc.Id, Date.today(), Date.today().addMonths(12), quote.Id, opp.Id); 
       
		//Contract ct = TestDataFactory.createContract(acc.Id, quote.Id, 'Draft', Date.today(), 12, Date.today().addMonths(12).addDays(2), order.Id, opp.Id);
        Contract ct = new Contract();
        ct.AccountId = acc.id;
        ct.Status = 'Draft';
        ct.StartDate = Date.today();
        ct.EndDate =  Date.today().addMonths(12).addDays(2);
        ct.ContractTerm = 12;
        ct.SBQQ__Quote__c = quote.Id;
        ct.SBQQ__Order__c = order.Id;
        ct.SBQQ__Opportunity__c = opp.Id;
        insert ct;
        
        String ContractNumber = [select ContractNumber from Contract where id=:ct.id].ContractNumber;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Contrat simplifié_'+ContractNumber+'_2022-12-19_completed';
        cv.PathOnClient = 'Contrat simplifié_'+ContractNumber+'_2022-12-19_completed.pdf';system.debug('ContractNumber: '+ContractNumber);
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
       
      	///
        ContentDocumentLink NewCDL = new ContentDocumentLink();
        NewCDL.ContentDocumentId = [select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;
        NewCDL.LinkedEntityId = quote.id;
        NewCDL.ShareType='I';
        NewCDL.Visibility='InternalUsers';
        insert NewCDL;
        
        //test
        list<ContentDocumentLink> L = [select id from ContentDocumentLink where LinkedEntityId=:ct.id];
        system.debug('L='+L);
        system.assertEquals(1, L.size());
        test.stopTest();
    }
}