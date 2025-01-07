@isTest
private class PurgeInterfaceLogsBatchTest {
    @testSetup
    static void setup() {
        // Insert test data for each chain with default CreatedDate
        List<LogInterfaces__c> logInterfacesList = new List<LogInterfaces__c>();
        for (Integer i = 0; i < 10; i++) {
            logInterfacesList.add(new LogInterfaces__c());
        }
        insert logInterfacesList;

        List<Interface_Response__c> interfaceResponseList = new List<Interface_Response__c>();
        for (Integer i = 0; i < 10; i++) {
            interfaceResponseList.add(new Interface_Response__c());
        }
        insert interfaceResponseList;

        List<Interface_monitoring__c> interfaceMonitoringList = new List<Interface_monitoring__c>();
        for (Integer i = 0; i < 10; i++) {
            interfaceMonitoringList.add(new Interface_monitoring__c());
        }
        insert interfaceMonitoringList;

        // Set the CreatedDate to a historical date to meet the purge criteria
        for (LogInterfaces__c record : logInterfacesList) {
            Test.setCreatedDate(record.Id, DateTime.now().addDays(-31));
        }
        for (Interface_Response__c record : interfaceResponseList) {
            Test.setCreatedDate(record.Id, DateTime.now().addDays(-31));
        }
        for (Interface_monitoring__c record : interfaceMonitoringList) {
            Test.setCreatedDate(record.Id, DateTime.now().addDays(-31));
        }
    }

    @isTest
    static void testPurgeInterfaceLogsBatchChain1() {
        Test.startTest();
        PurgeInterfaceLogsBatch batch1 = new PurgeInterfaceLogsBatch(1, true);
        Database.executeBatch(batch1, 50);
        Test.stopTest();

        // Verify that records from LogInterfaces__c are deleted
        Integer countLogs = [SELECT COUNT() FROM LogInterfaces__c];
        System.assertEquals(0, countLogs, 'LogInterfaces__c records should be deleted');
    }

    @isTest
    static void testPurgeInterfaceLogsBatchChain2() {
        Test.startTest();
        PurgeInterfaceLogsBatch batch2 = new PurgeInterfaceLogsBatch(2, true);
        Database.executeBatch(batch2, 50);
        Test.stopTest();

        // Verify that records from Interface_Response__c are deleted
        Integer countResponses = [SELECT COUNT() FROM Interface_Response__c];
        System.assertEquals(0, countResponses, 'Interface_Response__c records should be deleted');
    }

    @isTest
    static void testPurgeInterfaceLogsBatchChain3() {
        Test.startTest();
        PurgeInterfaceLogsBatch batch3 = new PurgeInterfaceLogsBatch(3, true);
        Database.executeBatch(batch3, 50);
        Test.stopTest();

        // Verify that records from Interface_monitoring__c are deleted
        Integer countMonitoring = [SELECT COUNT() FROM Interface_monitoring__c];
        System.assertEquals(0, countMonitoring, 'Interface_monitoring__c records should be deleted');
    }
}