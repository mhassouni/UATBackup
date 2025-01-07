@isTest
public class CallR_SMSService_TEST 
{
// Test the success (200) case of the the Post request
	static testMethod void sendSMSWithSuccess()
    {
        //Mock
        Test.setMock(HttpCalloutMock.class, new CallR_SMSServiceMock_TEST(200));
        List<Google_Callr_Services_Params__c> GoogleCallrServicesParamsRecords = Test.loadData(Google_Callr_Services_Params__c.sObjectType, 'GoogleCallrServicesParamsRecordsFile');
        List<Case> CaseRecords = Test.loadData(Case.sObjectType, 'CaseRecordFile');
        Test.startTest();
        CallR_SMSService.sendSMS(GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c, CaseRecords[0].Id);
        Test.stopTest();
    }
    
// Test the unsuccess (404 or other Status) case of the the Post request
    static testMethod void sendSMSWithUnsuccess()
    {
        //Mock
		Test.setMock(HttpCalloutMock.class, new CallR_SMSServiceMock_TEST(404));
		List<Google_Callr_Services_Params__c> GoogleCallrServicesParamsRecords = Test.loadData(Google_Callr_Services_Params__c.sObjectType, 'GoogleCallrServicesParamsRecordsFile');
 		List<Case> CaseRecords = Test.loadData(Case.sObjectType, 'CaseRecordFile');
        Test.startTest();
        CallR_SMSService.sendSMS(GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c, CaseRecords[0].Id);
        Test.stopTest();
    }
   
    @IsTest(SeeAllData=true)
    private static void testSchedulable() 
    {        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CallR_SMSServiceMock_TEST(200));
        List<Case> CaseRecords = Test.loadData(Case.sObjectType, 'CaseRecordFile');
        List<Google_Callr_Services_Params__c> GoogleCallrServicesParamsRecords = Test.loadData(Google_Callr_Services_Params__c.sObjectType, 'GoogleCallrServicesParamsRecordsFile');
		String name1 = CallR_SMSService.getUUID();
		String name2 = CallR_SMSService.getUUID();
		CallR_SMSService.scheduleThis('Immediately', name1, GoogleCallrServicesParamsRecords[0].Origine_Param__c, GoogleCallrServicesParamsRecords[0].Destination_Param__c, GoogleCallrServicesParamsRecords[0].RecordId_1__c, GoogleCallrServicesParamsRecords[0].RecordId_2__c, CaseRecords[0].Id, GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c);
		CallR_SMSService.scheduleThis('Last Schedule', name2, GoogleCallrServicesParamsRecords[0].Origine_Param__c, GoogleCallrServicesParamsRecords[0].Destination_Param__c, GoogleCallrServicesParamsRecords[0].RecordId_1__c, GoogleCallrServicesParamsRecords[0].RecordId_2__c, CaseRecords[0].Id, GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c);
        CallR_SMSService.scheduleFromFlow( GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c, Datetime.now(), '40', GoogleCallrServicesParamsRecords[0].EventId__c);
        CallR_SMSService.scheduleFromFlow( GoogleCallrServicesParamsRecords[0].Recipient_Phone__c, GoogleCallrServicesParamsRecords[0].SMS_Sender__c, GoogleCallrServicesParamsRecords[0].SMS_Message__c, Datetime.now(), '0', GoogleCallrServicesParamsRecords[0].EventId__c);
        Test.stopTest();
    }  
}