/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class ParentUtil implements rh2.PS_Rollup_Engine {
    global static Boolean rhxInstalled;
    global ParentUtil() {

    }
    global static void UpsertRollupTestRecords(List<SObject> sourceList) {

    }
    global List<SObject> enterRollupHelperWithCorrectContext(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, List<String> objNames) {
        return null;
    }
    global List<SObject> enterRollupHelperWithCorrectContext(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, String objName) {
        return null;
    }
    global List<String> getAllActiveRollupSettingsForTargetObject(String targetObjectType) {
        return null;
    }
    global SObject getOrgDefaultSettings() {
        return null;
    }
    global String getRollupSetting(Map<String,Object> params) {
        return null;
    }
    global Map<String,SObject> getRollupSettings() {
        return null;
    }
    global List<rh2.PS_Rollup_Context> getRollups(List<String> sourceObjs) {
        return null;
    }
    global Boolean isString(String fieldType) {
        return null;
    }
    global void performInvocableRollups(List<SObject> childRecs) {

    }
    global static List<SObject> performRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap) {
        return null;
    }
    global static List<SObject> performRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, Boolean async) {
        return null;
    }
    global List<SObject> performTriggerRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, Boolean async) {
        return null;
    }
    global List<SObject> performTriggerRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, List<String> objNames, Boolean async) {
        return null;
    }
    global List<SObject> performTriggerRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, String objName, Boolean async) {
        return null;
    }
    global void prepareTriggerRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, List<String> objNames, Boolean async) {

    }
    global Boolean rollupSettingsExist() {
        return null;
    }
    global static List<SObject> setParentValues(List<SObject> recs) {
        return null;
    }
    global void setRollupSetting(String targetField, String sourceField, String relField, String rangeField, String logic) {

    }
    global void setRollupSettingCondition(rh2__Date_Sync__c ds, String field, String logic, String parameter) {

    }
    global Map<String,rh2__Date_Sync__c> setRollupSettings(Map<String,rh2__Date_Sync__c> insertMe) {
        return null;
    }
}
