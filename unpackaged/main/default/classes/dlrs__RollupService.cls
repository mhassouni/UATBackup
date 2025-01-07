/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class RollupService {
    global static Exception LastMetadataAPIConnectionException {
        get;
    }
    global RollupService() {

    }
    global static Boolean bypass(String rollupName) {
        return null;
    }
    global static Boolean checkMetadataAPIConnection() {
        return null;
    }
    global static void clearAllBypasses() {

    }
    global static Boolean clearBypass(String rollupName) {
        return null;
    }
    global static Boolean isBypassed(String rollupName) {
        return null;
    }
    global static List<SObject> rollup(List<SObject> childRecords) {
        return null;
    }
    global static void rollup(List<dlrs.RollupService.RollupToCalculate> rollupsToCalculate) {

    }
    global static void rollup(Map<Id,SObject> existingRecords, Map<Id,SObject> newRecords, Schema.SObjectType sObjectType) {

    }
    global static Id runJobToCalculate(Id lookupId) {
        return null;
    }
    global static Id runJobToCalculate(String lookupId) {
        return null;
    }
    global static Id runJobToCalculate(Id lookupId, String masterWhereClause) {
        return null;
    }
    global static Id runJobToCalculate(String lookupId, String masterWhereClause) {
        return null;
    }
    global static Id runJobToProcessScheduledItems() {
        return null;
    }
    global static void testHandler(SObject dummyChildRecord) {

    }
    global static void triggerHandler() {

    }
    global static void triggerHandler(Schema.SObjectType childObjectType) {

    }
global class RollupToCalculate {
    global Id parentId;
    global String rollupSummaryUniqueName;
    global RollupToCalculate() {

    }
}
}
