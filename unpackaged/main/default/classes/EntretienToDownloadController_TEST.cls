@isTest
public class EntretienToDownloadController_TEST {


    // Test the success (200) case of the the Post request
    
	static testMethod void GetEntretienWithSuccess()
    {
        //Mock
        Test.setMock(HttpCalloutMock.class, new EntretienToDownloadMock_TEST(200));
        WSParametreRequete__c wspr = new WSParametreRequete__c(Name='WS_Param_011',
                                                                   EndPoint__c = 'https://api-test.petitforestier.fr/api/services/SFDC/IGLOOPDFCommunity/GetEntretien',
                                                                   Methode__c = 'POST',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/json',
                                                                   ApplicationName__c = 'SFDC',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr;
		PageReference pref = Page.EntretienToDownload;
        pref.getParameters().put('id','PF-88590/PF-88590_ETALSON_20190212_1449896');
        Test.setCurrentPage(pref);
        Test.startTest();
        EntretienToDownloadController Page1 = new EntretienToDownloadController();
        Page1.getDocument();
        Test.stopTest();
    }
    
    // Test the unsuccess (404 or other Status) case of the the Post request
    
    static testMethod void GetEntretienWithUnsuccess()
    {
        //Mock
		Test.setMock(HttpCalloutMock.class, new EntretienToDownloadMock_TEST(404));
		WSParametreRequete__c wspr = new WSParametreRequete__c(Name='WS_Param_011',
                                                                   EndPoint__c = 'https://api-test.petitforestier.fr/api/services/SFDC/IGLOOPDFCommunity/GetEntretien',
                                                                   Methode__c = 'POST',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/json',
                                                                   ApplicationName__c = 'SFDC',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr;
        PageReference pref = Page.EntretienToDownload;
        pref.getParameters().put('id','PF-88590/PF-88590_ETALSON_20190212_1449896');
        Test.setCurrentPage(pref);
        Test.startTest();
        EntretienToDownloadController Page2 = new EntretienToDownloadController();
        Page2.getDocument();
        Test.stopTest();
    }
}