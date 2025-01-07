/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3StoreResultsInJobFlowAction {
    global dc3StoreResultsInJobFlowAction() {

    }
    @InvocableMethod(label='DC - Store Duplicate in DC Job' description='Store DC Search By ID results in a DC Job')
    global static List<dupcheck.dc3StoreResultsInJobFlowAction.StoreResultsInJobResult> storeResultsInJob(List<dupcheck.dc3StoreResultsInJobFlowAction.StoreResultsInJobRequest> storeResultsInJobRequests) {
        return null;
    }
global class StoreResultsInJobRequest {
    @InvocableVariable(label='DC Job Name' description='The name of the DC job to create.' required=false)
    global String dcJobName;
    @InvocableVariable(label='SearchResult' description='A duplicate search result from a DC3 Search Flow Action.' required=true)
    global dupcheck.dc3FlowSearchComplexType searchResult;
    global StoreResultsInJobRequest() {

    }
}
global class StoreResultsInJobResult {
    @InvocableVariable(label='DcJobID' required=false)
    global Id dcJobID;
    @InvocableVariable(label='Succeeded' required=false)
    global Boolean succeeded;
    global StoreResultsInJobResult() {

    }
}
}
