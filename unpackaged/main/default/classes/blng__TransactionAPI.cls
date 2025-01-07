/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class TransactionAPI {
    global TransactionAPI() {

    }
    webService static blng.TransactionResult authorizeTransaction(Id invoiceId) {
        return null;
    }
    global static List<blng.TransactionResult> authorizeTransaction(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    global static List<blng.CaptureOutputResult> captureTransaction(List<blng.CaptureInputParameter> captureInputParameters) {
        return null;
    }
    global static List<blng.TransactionResult> captureTransaction(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    webService static blng.TransactionResult chargeTransaction(Id invoiceId) {
        return null;
    }
    global static List<blng.TransactionResult> chargeTransaction(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    global static List<blng.TransactionResult> generateToken(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    global static List<blng.TransactionResult> getPaymentStatus(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    global static List<blng.TransactionResult> getRefundStatus(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    global static List<blng.TransactionResult> nonReferredRefund(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    @AuraEnabled
    webService static List<blng.TransactionResult> refundPayment(List<blng.RefundParameter> listOfRefundParameters) {
        return null;
    }
    @AuraEnabled
    webService static List<blng.TransactionResult> refundTransaction(Id transactionId) {
        return null;
    }
    global static List<blng.TransactionResult> refundTransaction(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    @AuraEnabled
    webService static Boolean resetInvoiceCorrectiveAction(List<blng__Invoice__c> invoices) {
        return null;
    }
    @AuraEnabled
    webService static String validateRefundTransactionId(Id transactionId) {
        return null;
    }
    global static List<blng.TransactionResult> voidRefundTransaction(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    global static List<blng.TransactionResult> voidTokenTransaction(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
    global static List<blng.TransactionResult> voidTransaction(Map<String,blng.TransactionParameter> mapOfTransactionParameterById) {
        return null;
    }
}
