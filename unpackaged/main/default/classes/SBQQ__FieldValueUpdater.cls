/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class FieldValueUpdater implements Database.Batchable<SObject> {
    global Schema.SObjectType entityToBeUpdated;
    global List<Schema.SObjectField> fieldsToBeUpdated;
    global String queryToBeUpdated;
    global Map<Schema.SObjectField,String> valuesToBeUpdated;
    global FieldValueUpdater(List<Schema.SObjectField> fieldsToBeUpdated, Schema.SObjectType entityToBeUpdated, Map<Schema.SObjectField,String> valuesToBeUpdated) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> sObjects) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return null;
    }
}
