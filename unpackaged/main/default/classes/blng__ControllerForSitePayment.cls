/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class ControllerForSitePayment {
    global Boolean ACH {
        get;
        set;
    }
    global Decimal amountToBeProcessed {
        get;
        set;
    }
    global String baseURL {
        get;
        set;
    }
    global String cardTypes {
        get;
        set;
    }
    global String countryAPIName {
        get;
        set;
    }
    global Boolean CreditCard {
        get;
        set;
    }
    global blng__Invoice__c invoice {
        get;
        set;
    }
    global Boolean isActive {
        get;
        set;
    }
    global Boolean isCountryPickListEnable {
        get;
        set;
    }
    global Boolean isLogoExist {
        get;
        set;
    }
    global Boolean isPayeezy {
        get;
        set;
    }
    global Boolean isPayeezyCheck {
        get;
        set;
    }
    global Boolean isSaveCardDetails {
        get;
        set;
    }
    global Boolean isValidGateWay {
        get;
        set;
    }
    global blng__PaymentMethod__c paymentMethod {
        get;
        set;
    }
    global String stateAPIName {
        get;
        set;
    }
    global ControllerForSitePayment() {

    }
    global System.PageReference attemptInvoiceLock() {
        return null;
    }
    global System.PageReference enableAutoPay() {
        return null;
    }
    global void previous() {

    }
    global void processACH() {

    }
    global void processCreditCard() {

    }
    global System.PageReference processPayment() {
        return null;
    }
}
