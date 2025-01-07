/**
 * Test Class pour CatalogueControlle
 */
@isTest
private class CatalogueController_TEST {

    static testMethod void TestSearchCatalogue() {
		Test.setMock(HttpCalloutMock.class, new CatalogueAPIMock_200());
        Test.setMock(HttpCalloutMock.class, new CatalogueAPIMock_404());
        Test.setMock(HttpCalloutMock.class, new CatalogueAPIMock_500());
		WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_006',
                                                               EndPoint__c = 'https://api.petitforestier.fr/services/PFCore/produits',
                                                               Methode__c = 'POST',
                                                               UserName__c = 'ftgo_google',
                                                               MotDePasse__c = 'E_@h3D3r!7',
                                                               ContentType__c = 'application/json',
                                                               ApplicationName__c = 'SFCD',
                                                               Authorization__c = 'Basic ZnRnb19nb29nbGU6RV9AaDNEM3IhNw==');	
        insert wspr1;
       
       
        Account Account1 = Utils_TestMethods.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient);
        //Account1.Statut__c = Label.CPT_Statut_ValideCM;
        Account1.ModeCreation__c = Label.CPT_ModeCreation_ImportEnMasse;
        Account1.PaysRegionPF__c='DRO IDF1';
        //Account1.AgencePF__c = '004 - RUNGIS';
        Account1.IDEulerHermes__c='123456789';
        Account1.Ligne1__c='x';Account1.CodePostal__c='93420';Account1.Ville__c='VILLEPINTE';Account1.Pays__c='France';
        Account1.RecordTypeId = Label.ACC_RecordTypeId_CompteClient;
              insert new list<Account>{Account1};
		Contact CON = Utils_TestMethods.createContact('conName', Account1.Id);
                     insert new list<Contact>{CON};

        Opportunity OPP = Utils_TestMethods.createOpportunity('Nouvelle Opportunité 1',Label.OPP_StageName_OpportuniteCreee,system.today(),Account1);
        OPP.RecordTypeId = Label.OPP_RecordType_Vehicule_ENCOURS;
        OPP.PaysRegionPF__c = 'DRO IDF1';
        OPP.Amount = 500000;
        OPP.DateClotureEffective__c = system.today();
           insert new list<Opportunity>{OPP};

        Quote Q = new Quote();
        Q.Name = 'TEST';
       
        Q.OpportunityId = OPP.Id;
        Q.RecordTypeId = Label.Quote_RecordTypeId_HorsStandard	;
                   insert new list<Quote>{Q};

        ApexPages.StandardController controller = new ApexPages.StandardController(Q);
        CatalogueController r = new CatalogueController(controller);
        r.CatalogueParam = 'HY_ST';
        r.CodePaysParam = 'FR';
        //r.CodePFParam = '100E19 20CH';
        r.CodePFParam = '100E19 CH';
        r.StandardPFParam = '01';
        r.MarqueParam = 'IVECO';
        r.ModeleParam = 'EUROCARGO';
       /*
        List<SelectOption> selOpts1=r.getCATALOGUEPFValues();
        List<SelectOption> selOpts2=r.getCODEPFValues();
        List<SelectOption> selOpts3=r.getCODEPAYSValues();
        List<SelectOption> selOpts4=r.getSTANDARDPFValues();
        */
       

    List<sObject> Base_produit_Data = Test.loadData(Base_produit__c.sObjectType, 'BaseProductData');
       /* List<Base_produit__c> Base_produitTemp = new List<Base_produit__c>();
        for(Base_produit__c b : Base_produit_Data)
        {
            Base_produitTemp.Catalogue__c = b.Catalogue__c;
            Base_produitTemp.Code_PF__c = b.Code_PF__c;
            Base_produitTemp.Code_Pays__c = b.Code_Pays__c;
            Base_produitTemp.Marque__c = b.Marque__c;
            Base_produitTemp.Modele__c = b.Modele__c;
            Base_produitTemp.Standard__c = b.Standard__c;
            Base_produitTemp.Name = b.Name;
            Base_produit.add(Base_produitTemp);
        }

        insert  Base_produit;
*/
        //insert  Base_produit_Data;
        
        Test.startTest();
         r.getCATALOGUEPFValues();
        r.getCODEPFValues();
        r.getCODEPAYSValues();
        r.getSTANDARDPFValues();
        r.getMARQUEValues();
        r.getMODELEValues();
        r.SearchCatalogue();
        CatalogueController.SearchAllowedCountryCatalogue(r.CodePaysParam,r.CatalogueParam);
        CatalogueController.SearchCatalogueFromLWC('-', '-', '-', '-', Q.ID, '-', '-');
        CatalogueController.SearchCatalogueFromLWC('FR', '100E19 20CH', 'HY_ST', '01', Q.ID, '-', '-');
        CatalogueController.SearchCatalogueFromLWC('', '100E19 20CH', 'HY_ST', '01', Q.ID, '-', '-');
        CatalogueController.SearchCatalogueFromLWC('AT_DE', '120EL21CF', 'FS_PF', '01', Q.ID, '-', '-');
           
   //SearchCatalogueFromLWC(String CodePaysParam, String CodePFParam, String CatalogueParam, String StandardPFParam,String currentQuoteID,String MarqueParam,String ModeleParam)

        
        Test.stopTest();
        
         
    }
        

}