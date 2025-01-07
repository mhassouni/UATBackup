@isTest
public class CarteGriseToDownloadController_TEST {

    // Test the success (200) case of the the GET request
    
	static testMethod void GetCarteGriseWithSuccess()
    {
        //Mock
        Test.setMock(HttpCalloutMock.class, new CarteGriseToDownloadMock_TEST(200));
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_008',
                                                                   EndPoint__c = 'https://api.petitforestier.fr/api/services/SFDC/IGLOOPDFCommunity/GetCarteGrise/',
                                                                   Methode__c = 'GET',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/xml',
                                                                   ApplicationName__c = 'SFCD',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
		PageReference pref = Page.CarteGriseToDownload;
        pref.getParameters().put('id','PF-88590');
        Test.setCurrentPage(pref);
        Test.startTest();
        CarteGriseToDownloadController MyCon = new CarteGriseToDownloadController();
        MyCon.getDocument();
        Test.stopTest();
    }
    
    // Test the unsuccess (404 or other Status) case of the the GET request
    
    static testMethod void GetCarteGriseWithUnsuccess()
    {
        //Mock
		Test.setMock(HttpCalloutMock.class, new CarteGriseToDownloadMock_TEST(404));
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_008',
                                                                   EndPoint__c = 'https://api.petitforestier.fr/api/services/SFDC/IGLOOPDFCommunity/GetCarteGrise/',
                                                                   Methode__c = 'GET',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/xml',
                                                                   ApplicationName__c = 'SFCD',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
        Test.startTest();
        CarteGriseToDownloadController MyCon = new CarteGriseToDownloadController();
        MyCon.getDocument();
        Test.stopTest();
    }
}