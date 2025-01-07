/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3FindMasterByDcOutputFlowAction {
    global dc3FindMasterByDcOutputFlowAction() {

    }
    @InvocableMethod(label='DC - Find Master Record By DC Search Action Output' description='Returns the Master Record ID for a given DC Search Flow Action Output based on the Duplicate Check Merge Rules.')
    global static List<dupcheck.dc3FindMasterByDcOutputFlowAction.FindDcMasterByFlowOutputResult> findMasterByFlowOutputFlowAction(List<dupcheck.dc3FindMasterByDcOutputFlowAction.FindDcMasterByFlowOutputRequest> requests) {
        return null;
    }
global class FindDcMasterByFlowOutputRequest {
    @InvocableVariable(label='Duplicate Result' description='The full duplicate search result' required=true)
    global dupcheck.dc3FlowSearchComplexType duplicateResult;
    @InvocableVariable(label='Threshold' description='Ignore records with a score below this threshold when determining possible master records' required=false)
    global Integer threshold;
    global FindDcMasterByFlowOutputRequest() {

    }
}
global class FindDcMasterByFlowOutputResult {
    @InvocableVariable(label='MasterRecordId' required=false)
    global Id masterRecordId;
    global FindDcMasterByFlowOutputResult() {

    }
}
}
