@isTest
public class EstimatedTravelTime_TEST 
{
	// Test the success (200) case of the the Post request
	static testMethod void sendSMSWithSuccess()
    {
        //Mock
        Test.setMock(HttpCalloutMock.class, new EstimatedTravelTimeMock_TEST(200));
        List<Google_Callr_Services_Params__c> GoogleCallrServicesParamsRecords = Test.loadData(Google_Callr_Services_Params__c.sObjectType, 'GoogleCallrServicesParamsRecordsFile');
        List<Case> CaseRecords = Test.loadData(Case.sObjectType, 'CaseRecordFile');
        Test.startTest();
     	EstimatedTravelTime.getEstimatedTravelTime(GoogleCallrServicesParamsRecords[0].Origine_Param__c, GoogleCallrServicesParamsRecords[0].Origine_Param__c, GoogleCallrServicesParamsRecords[0].RecordId_1__c, GoogleCallrServicesParamsRecords[0].RecordId_2__c, CaseRecords[0].Id, GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c, GoogleCallrServicesParamsRecords[0].SMSType__c);
        Test.stopTest();    
    }
    
    // Test the unsuccess (404 or other Status) case of the the Post request
    static testMethod void sendSMSWithUnsuccess()
    {
       //Mock
        Test.setMock(HttpCalloutMock.class, new EstimatedTravelTimeMock_TEST(404));
        List<Google_Callr_Services_Params__c> GoogleCallrServicesParamsRecords = Test.loadData(Google_Callr_Services_Params__c.sObjectType, 'GoogleCallrServicesParamsRecordsFile');
        List<Case> CaseRecords = Test.loadData(Case.sObjectType, 'CaseRecordFile');
        Test.startTest();
        EstimatedTravelTime.getEstimatedTravelTime(GoogleCallrServicesParamsRecords[0].Origine_Param__c, GoogleCallrServicesParamsRecords[0].Origine_Param__c, GoogleCallrServicesParamsRecords[0].RecordId_1__c, GoogleCallrServicesParamsRecords[0].RecordId_2__c, CaseRecords[0].Id, GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c, GoogleCallrServicesParamsRecords[0].SMSType__c);
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    private static void testSchedulable() 
    {        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new EstimatedTravelTimeMock_TEST(200));
        List<Case> CaseRecords = Test.loadData(Case.sObjectType, 'CaseRecordFile');
        List<Google_Callr_Services_Params__c> GoogleCallrServicesParamsRecords = Test.loadData(Google_Callr_Services_Params__c.sObjectType, 'GoogleCallrServicesParamsRecordsFile');
		String name1 = EstimatedTravelTime.getUUID();
		String name2 = EstimatedTravelTime.getUUID();
        EstimatedTravelTime.scheduleThis ( GoogleCallrServicesParamsRecords[0].EstimatedTravelTime_Sec__c.intValue(),  GoogleCallrServicesParamsRecords[0].RecordId_1__c,  GoogleCallrServicesParamsRecords[0].RecordId_2__c, CaseRecords[0].Id, GoogleCallrServicesParamsRecords[0].Origine_Param__c, GoogleCallrServicesParamsRecords[0].Destination_Param__c, '10min', name1, 40, GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c, GoogleCallrServicesParamsRecords[0].SMSType__c);
        Test.stopTest();
    }  
}