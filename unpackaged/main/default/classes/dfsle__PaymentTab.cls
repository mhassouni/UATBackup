/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class PaymentTab extends dfsle.FormulaTab {
    global dfsle.PaymentTab.Payment payment {
        get;
    }
    global PaymentTab() {

    }
    global dfsle.PaymentTab withPayment(dfsle.PaymentTab.Payment payment) {
        return null;
    }
global class LineItem {
    global String amountReference {
        get;
    }
    global String description {
        get;
    }
    global String itemCode {
        get;
    }
    global String name {
        get;
    }
    global LineItem(String name, String description, String itemCode, String amountReference) {

    }
}
global class Payment {
    global Boolean authorize {
        get;
    }
    global String currencyCode {
        get;
    }
    global String customerId {
        get;
    }
    global String customMetadata {
        get;
    }
    global Boolean customMetadataRequired {
        get;
    }
    global dfsle.UUID docuSignGatewayId {
        get;
    }
    global List<dfsle.PaymentTab.LineItem> lineItems {
        get;
    }
    global List<String> methods {
        get;
    }
    global Boolean save {
        get;
    }
    global String sourceId {
        get;
    }
    global Payment(dfsle.UUID docuSignGatewayId, String customerId, String sourceId, List<String> methods, String currencyCode, List<dfsle.PaymentTab.LineItem> lineItems, Boolean authorize, Boolean save, String customMetadata, Boolean customMetadataRequired) {

    }
}
}
