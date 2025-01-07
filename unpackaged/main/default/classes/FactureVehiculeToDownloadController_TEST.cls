@isTest
public class FactureVehiculeToDownloadController_TEST {

    // Test the success (200) case of the the GET request
    
	static testMethod void GetFactureVehiculeWithSuccess()
    {
        //Mock
        Test.setMock(HttpCalloutMock.class, new FactureVehiculeToDownloadMock_TEST(200));
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_010',
                                                                   EndPoint__c = 'https://api.petitforestier.fr/api/services/SFDC/IGLOOPDFCommunity/GetFacture/',
                                                                   Methode__c = 'GET',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/xml',
                                                                   ApplicationName__c = 'SFCD',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
		PageReference pref = Page.FactureVehiculeToDownload;
        
        //data
        Account AC = Utils_TestMethods.createAccount('Test','test',null,Label.CPT_RecordTypeId_CompteClient);
        insert AC;
        Facture_vehicule__c FV = new Facture_vehicule__c();
        FV.Numero_de_facture_IGLOO__c = '123456789';
        FV.Compte__c=AC.id;
        insert FV;
        pref.getParameters().put('id',FV.Id);
        Test.setCurrentPage(pref);
        Test.startTest();
        FactureVehiculeToDownloadController MyCon = new FactureVehiculeToDownloadController();
        MyCon.getDocument();
        Test.stopTest();
    }
    
    // Test the unsuccess (404 or other Status) case of the the GET request
    
    static testMethod void GetFactureVehiculeWithUnsuccess()
    {
        //Mock
		Test.setMock(HttpCalloutMock.class, new FactureVehiculeToDownloadMock_TEST(404));
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_010',
                                                                   EndPoint__c = 'https://api.petitforestier.fr/api/services/SFDC/IGLOOPDFCommunity/GetFacture/	',
                                                                   Methode__c = 'GET',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/xml',
                                                                   ApplicationName__c = 'SFCD',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
       
        PageReference pref = Page.FactureVehiculeToDownload;
        
        //data
        Account AC = Utils_TestMethods.createAccount('Test','test',null,Label.CPT_RecordTypeId_CompteClient);
        insert AC;
        Facture_vehicule__c FV = new Facture_vehicule__c();
        FV.Numero_de_facture_IGLOO__c = '123456789';
        FV.Compte__c=AC.id;
        insert FV;
        pref.getParameters().put('id',FV.Id);
        Test.setCurrentPage(pref);
        
        
        Test.startTest();
        FactureVehiculeToDownloadController MyCon = new FactureVehiculeToDownloadController();
        MyCon.getDocument();
        Test.stopTest();
    }
}