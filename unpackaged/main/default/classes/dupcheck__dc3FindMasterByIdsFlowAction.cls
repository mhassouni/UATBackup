/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3FindMasterByIdsFlowAction {
    global dc3FindMasterByIdsFlowAction() {

    }
    @InvocableMethod(label='DC - Find Master Record By IDs' description='Returns the Master Record ID for a set of Record IDs based on the Duplicate Check Merge Rules.')
    global static List<dupcheck.dc3FindMasterByIdsFlowAction.FindDcMasterByIdsResult> findMasterByIdsFlowAction(List<dupcheck.dc3FindMasterByIdsFlowAction.FindDcMasterByIdsRequest> requests) {
        return null;
    }
global class FindDcMasterByIdsRequest {
    @InvocableVariable(label='RecordIDs' description='The Record IDs to find the Master Record for.' required=true)
    global List<String> recordIds;
    global FindDcMasterByIdsRequest() {

    }
}
global class FindDcMasterByIdsResult {
    @InvocableVariable(label='MasterRecordId' required=false)
    global Id masterRecordId;
    global FindDcMasterByIdsResult() {

    }
}
}
