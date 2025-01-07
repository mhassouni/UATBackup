/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3DirectProcessFlowAction {
    global dc3DirectProcessFlowAction() {

    }
    @InvocableMethod(label='DC - Process record via Direct Processing' description='The record added via this action will be processed according to the Direct Processing configuration.')
    global static List<dupcheck.dc3DirectProcessFlowAction.DirectProcessFlowResult> directProcessFlowAction(List<dupcheck.dc3DirectProcessFlowAction.DirectProcessFlowRequest> directProcessRequests) {
        return null;
    }
global class DirectProcessFlowRequest {
    @InvocableVariable(label='Async' description='Wether or not to process Async.' required=false)
    global Boolean async;
    @InvocableVariable(label='RecordID' description='The Record ID to Process' required=true)
    global Id recordId;
    global DirectProcessFlowRequest() {

    }
}
global class DirectProcessFlowResult {
    @InvocableVariable(label='Succeeded' required=false)
    global Boolean succeeded;
    global DirectProcessFlowResult() {

    }
}
}
