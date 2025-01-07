@isTest
public class ControleToDownloadController_TEST {

    // Test the success (200) case of the the Post request
    
	static testMethod void GetControleWithSuccess()
    {
        //Mock
        Test.setMock(HttpCalloutMock.class, new ControleToDownloadMock_TEST(200));
        WSParametreRequete__c wspr = new WSParametreRequete__c(Name='WS_Param_009',
                                                                   EndPoint__c = 'https://api.petitforestier.fr/api/services/SFDC/IGLOOPDFCommunity/GetControle',
                                                                   Methode__c = 'POST',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/json',
                                                                   ApplicationName__c = 'SFDC',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr;
		PageReference pref = Page.ControleToDownload;
        pref.getParameters().put('id','PF-88590/PF-88590_ETALSON_20190212_1449896');
        Test.setCurrentPage(pref);
        Test.startTest();
        ControleToDownloadController MyCon = new ControleToDownloadController();
        MyCon.getDocument();
        Test.stopTest();
    }
    
    // Test the unsuccess (404 or other Status) case of the the Post request
    
    static testMethod void GetControleWithUnsuccess()
    {
        //Mock
		Test.setMock(HttpCalloutMock.class, new ControleToDownloadMock_TEST(404));
		WSParametreRequete__c wspr = new WSParametreRequete__c(Name='WS_Param_009',
                                                                   EndPoint__c = 'https://api.petitforestier.fr/api/services/SFDC/IGLOOPDFCommunity/GetControle',
                                                                   Methode__c = 'POST',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/json',
                                                                   ApplicationName__c = 'SFDC',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr;
        PageReference pref = Page.ControleToDownload;
        pref.getParameters().put('id','PF-88590/PF-88590_ETALSON_20190212_1449896');
        Test.setCurrentPage(pref);
        Test.startTest();
        ControleToDownloadController MyCon = new ControleToDownloadController();
        MyCon.getDocument();
        Test.stopTest();
    }
}