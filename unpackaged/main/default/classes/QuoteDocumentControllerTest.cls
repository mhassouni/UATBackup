@isTest 
private class QuoteDocumentControllerTest { 
   
  @testSetup 
   static void setup() { 
       Account acc = new Account (Name = 'Test Account'); 
       insert acc; 
 
       Opportunity oppty = new Opportunity( 
           Name = 'Test Opportunity', 
           AccountId = acc.Id, 
           StageName = 'Prospecting', 
           Amount = 3000, 
           CloseDate = System.today()); 
       insert oppty; 
 
       List<SFCPQ_Fields_Mapping_Settings__mdt> fieldsMappingSettingsList = SFCPQ_Fields_Mapping_Settings__mdt.getAll().values(); 
       if (! fieldsMappingSettingsList.isEmpty()) { 
           SFCPQ_Fields_Mapping_Settings__mdt fieldsMappingSettings = fieldsMappingSettingsList[0]; 
           String sobjectName = fieldsMappingSettings.SF_SObject_API_Name__c; 
           SObject obj = (SObject) Type.forName('Schema', sobjectName).newInstance(); 
          // obj.put('Name', '1221'); 
           obj.put(fieldsMappingSettings.Quote_ID_Field_API_Name__c, 123321); 
           obj.put(fieldsMappingSettings.CPQ_Owner_ID_Field_API_Name__c, '123'); 
           obj.put(fieldsMappingSettings.Opportunity_ID_Field_API_Name__c, oppty.Id); 
           insert obj; 
       } 
   } 
 
   @isTest 
   static void getUrlToRedirectCreateActionTest() { 
       Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1]; 
       ApexPages.currentPage().getParameters().put('recordid', opportunity.Id); 
       ApexPages.currentPage().getParameters().put('token', 'testtoken'); 
       ApexPages.currentPage().getParameters().put('action', 'create'); 
       Test.startTest(); 
           QuoteDocumentController quoteDocumentCtrl = new QuoteDocumentController(); 
           System.assertEquals(true, quoteDocumentCtrl.url != null); 
       Test.stopTest(); 
   } 
 
 
   @isTest 
   static void getUrlToRedirectEditActionTest() { 
       SFCPQ_Fields_Mapping_Settings__mdt fieldsMappingSettings = SFCPQ_Fields_Mapping_Settings__mdt.getAll().values()[0]; 
       String query = 'SELECT ' + fieldsMappingSettings.Quote_ID_Field_API_Name__c + ', ' + 
                               fieldsMappingSettings.CPQ_Owner_ID_Field_API_Name__c + ', ' + 
                               fieldsMappingSettings.Opportunity_ID_Field_API_Name__c + ' ' + 
                       'FROM ' + fieldsMappingSettings.SF_SObject_API_Name__c + ' ' + 
                       'LIMIT 1'; 
       SObject sobj = Database.query(query); 
       ApexPages.currentPage().getParameters().put('recordid', String.valueOf(sobj.get('Id'))); 
       ApexPages.currentPage().getParameters().put('token', 'testtoken'); 
       ApexPages.currentPage().getParameters().put('action', 'edit'); 
       Test.startTest(); 
           QuoteDocumentController quoteDocumentCtrl = new QuoteDocumentController(); 
           System.assertEquals(true, quoteDocumentCtrl.url != null); 
       Test.stopTest(); 
   } 
 
 
   @isTest 
   static void authorizationTest() { 
       SingleRequestMock fakeResponse =  new SingleRequestMock(200, 'Complete','{"access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IkpXVCJ9."}', null); 
       Test.setMock(HttpCalloutMock.class, fakeResponse); 
       Test.startTest(); 
           String accessToken = QuoteDocumentController.getAccessToken(); 
           System.assertEquals(true, accessToken != null); 
       Test.stopTest(); 
   } 
}