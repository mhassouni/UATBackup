/**
 * Created by Michael on 28-03-24.
 */

global class Intf_KwoteSyncBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {

    global Database.Querylocator start (Database.BatchableContext BC) {

        String query = 'SELECT Id, Legal_Entity__c, api_key__c, api_access__c FROM Intf_Kwote_Access_Mapping__mdt WHERE Active__c = true';

        return Database.getQueryLocator(query);

    }

    global void execute (Database.BatchableContext BC, List<Intf_Kwote_Access_Mapping__mdt> knwoteAccessMappings) {

        //Will be running one by one

        Intf_Kwote_Access_Mapping__mdt kwoteAccessMapping = knwoteAccessMappings[0];

        System.debug('========================== Intf_KwoteSyncBatch execute api_key__c: ' + kwoteAccessMapping.api_key__c);
        System.debug('========================== Intf_KwoteSyncBatch execute api_access__c: ' + kwoteAccessMapping.api_access__c);
        System.debug('========================== Intf_KwoteSyncBatch execute Legal_Entity__c: ' + kwoteAccessMapping.Legal_Entity__c);

        Map<String, String> headers = new Map<String, String>{
                'X-API-KEY' => kwoteAccessMapping.api_key__c,
                'X-API-PWD' => kwoteAccessMapping.api_access__c,
                'accept' => 'application/json'
        };

        Intf_WebserviceCalloutKwote.headers = headers;

        Intf_WebserviceCalloutKwote intfWebserviceCalloutWO = new Intf_WebserviceCalloutKwote();
        intfWebserviceCalloutWO.executeCallout(new List<Object>{kwoteAccessMapping.Legal_Entity__c});

    }

    global void finish(Database.BatchableContext BC) {

        System.debug('========================== Intf_KwoteSyncBatch BATCH FINISHED');

    }

    global void execute(SchedulableContext ctx) {
        Id batchId = Database.executeBatch(new Intf_KwoteSyncBatch(), 1);
        System.debug('Scheduled batchjob: ' + batchId);
    }

    global static String scheduleThis() {
        Intf_KwoteSyncBatch job = new Intf_KwoteSyncBatch();
        // Run job every day at 6 AM
        String schedule = '0 0 10 * * ?';
        String batchName = 'Intf_KwoteSyncBatch - ' + DateTime.now().format('YYYYMMDDHHmmss');
        String jobId = System.schedule(batchName, schedule, job);
        return jobId;
    }

}