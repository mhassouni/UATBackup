/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class BatchInvoiceUsage implements Database.Batchable<SObject>, Database.Stateful, blng.BatchInvoice {
    global blng.InvoiceRunVO invoiceRunVOInstance;
    global String query;
    global BatchInvoiceUsage() {

    }
    global void execute(Database.BatchableContext bc, List<blng__UsageSummary__c> listOfUsageSummaries) {

    }
    global void finish(Database.BatchableContext bc) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
