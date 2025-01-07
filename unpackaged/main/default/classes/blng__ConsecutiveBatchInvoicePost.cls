/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class ConsecutiveBatchInvoicePost implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful, blng.BatchInvoice {
    global Id invoiceRunId;
    global String query;
    global Set<Id> setOfInvoiceIds;
    global ConsecutiveBatchInvoicePost() {

    }
    global void execute(Database.BatchableContext bc, List<blng__Invoice__c> listOfInvoices) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global void setInvoiceRunId(Id invoiceRunId) {

    }
    global void setOfInvoiceIds(Set<Id> setOfInvoiceIds) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
