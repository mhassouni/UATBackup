@isTest
private class CatalogueAPI_TEST {
	
    static testMethod void testPostCallout_200() {

        Test.setMock(HttpCalloutMock.class, new CatalogueAPIMock_200());
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
        Account1.Statut__c = Label.CPT_Statut_Valide;
        Account1.ModeCreation__c = Label.CPT_ModeCreation_ImportEnMasse;
        Account1.PaysRegionPF__c='DO1B';
        Account1.AgencePF__c = '001 - VILLEPINTE';
        Account1.RecordTypeId = Label.ACC_RecordTypeId_CompteClient;
              insert Account1;
		
        Contact CON = Utils_TestMethods.createContact('conName', Account1.Id);
               insert CON;

        Opportunity OPP = Utils_TestMethods.createOpportunity('Nouvelle Opportunité 1',Label.OPP_StageName_OpportuniteCreee,system.today(),Account1);
        OPP.RecordTypeId = Label.OPP_RecordType_Vehicule_ENCOURS;
        OPP.Amount = 500000;
        OPP.DateClotureEffective__c = system.today();
           insert OPP;

        Quote Q = new Quote();
        Q.Name = 'TEST';
        Q.OpportunityId = OPP.Id;
        Q.RecordTypeId = Label.Quote_RecordTypeId_HorsStandard	;
                   insert Q;
        
        test.startTest();
        //CatalogueAPI.WSCallCatalogue('FR', '100E19 20CH', 'HY_ST', '01', Q.Id);
        CatalogueAPI.WSCallCatalogue('FR', '100E19 20CH', 'HY_ST', '01', Q.Id, '', '');
        test.stopTest();
      
    }
     static testMethod void testPostCallout_201() {

        Test.setMock(HttpCalloutMock.class, new CatalogueAPIMock_201());
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
        Account1.Statut__c = Label.CPT_Statut_Valide;
        Account1.ModeCreation__c = Label.CPT_ModeCreation_ImportEnMasse;
        Account1.PaysRegionPF__c='DO1B';
        Account1.AgencePF__c = '001 - VILLEPINTE';
        Account1.RecordTypeId = Label.ACC_RecordTypeId_CompteClient;
              insert Account1;
		
        Contact CON = Utils_TestMethods.createContact('conName', Account1.Id);
               insert CON;

        Opportunity OPP = Utils_TestMethods.createOpportunity('Nouvelle Opportunité 1',Label.OPP_StageName_OpportuniteCreee,system.today(),Account1);
        OPP.RecordTypeId = Label.OPP_RecordType_Vehicule_ENCOURS;
        OPP.Amount = 500000;
        OPP.DateClotureEffective__c = system.today();
           insert OPP;

        Quote Q = new Quote();
        Q.Name = 'TEST';
        Q.OpportunityId = OPP.Id;
        Q.RecordTypeId = Label.Quote_RecordTypeId_HorsStandard	;
                   insert Q;
        
        test.startTest();
        //CatalogueAPI.WSCallCatalogue('FR', '100E19 20CH', 'HY_ST', '01', Q.Id);
        CatalogueAPI.WSCallCatalogue('FR', '100E19 20CH', 'HY_ST', '01', Q.Id, '', '');
        test.stopTest();
      
    }
     static testMethod void testPostCallout_404() {

        Test.setMock(HttpCalloutMock.class, new CatalogueAPIMock_404());
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
        Account1.Statut__c = Label.CPT_Statut_Valide;
        Account1.ModeCreation__c = Label.CPT_ModeCreation_ImportEnMasse;
        Account1.PaysRegionPF__c='DO1B';
        Account1.AgencePF__c = '001 - VILLEPINTE';
        Account1.RecordTypeId = Label.ACC_RecordTypeId_CompteClient;
              insert Account1;
		
        Contact CON = Utils_TestMethods.createContact('conName', Account1.Id);
               insert CON;

        Opportunity OPP = Utils_TestMethods.createOpportunity('Nouvelle Opportunité 1',Label.OPP_StageName_OpportuniteCreee,system.today(),Account1);
        OPP.RecordTypeId = Label.OPP_RecordType_Vehicule_ENCOURS;
        OPP.Amount = 500000;
        OPP.DateClotureEffective__c = system.today();
           insert OPP;

        Quote Q = new Quote();
        Q.Name = 'TEST';
        Q.OpportunityId = OPP.Id;
        Q.RecordTypeId = Label.Quote_RecordTypeId_HorsStandard	;
                   insert Q;
        
        test.startTest();
        //CatalogueAPI.WSCallCatalogue('FR', '100E19 20CH', 'HY_ST', '02', Q.Id);
        CatalogueAPI.WSCallCatalogue('FR', '100E19 20CH', 'HY_ST', '01', Q.Id, '', '');
        test.stopTest();
      
    }
     static testMethod void testPostCallout_500() {

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
        Account1.Statut__c = Label.CPT_Statut_Valide;
        Account1.ModeCreation__c = Label.CPT_ModeCreation_ImportEnMasse;
        Account1.PaysRegionPF__c='DO1B';
        Account1.AgencePF__c = '001 - VILLEPINTE';
        Account1.RecordTypeId = Label.ACC_RecordTypeId_CompteClient;
              insert Account1;
		
        Contact CON = Utils_TestMethods.createContact('conName', Account1.Id);
               insert CON;

        Opportunity OPP = Utils_TestMethods.createOpportunity('Nouvelle Opportunité 1',Label.OPP_StageName_OpportuniteCreee,system.today(),Account1);
        OPP.RecordTypeId = Label.OPP_RecordType_Vehicule_ENCOURS;
        OPP.Amount = 500000;
        OPP.DateClotureEffective__c = system.today();
           insert OPP;

        Quote Q = new Quote();
        Q.Name = 'TEST';
        Q.OpportunityId = OPP.Id;
        Q.RecordTypeId = Label.Quote_RecordTypeId_HorsStandard	;
                   insert Q;
        
        test.startTest();
        //CatalogueAPI.WSCallCatalogue('FR', '100E19 20CH', 'HY_ST', '01', Q.Id);
        CatalogueAPI.WSCallCatalogue('FR', '100E19 20CH', 'HY_ST', '01', Q.Id, '', '');

        test.stopTest();
      
    }
}