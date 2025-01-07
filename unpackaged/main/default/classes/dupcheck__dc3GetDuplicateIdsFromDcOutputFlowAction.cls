/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3GetDuplicateIdsFromDcOutputFlowAction {
    global dc3GetDuplicateIdsFromDcOutputFlowAction() {

    }
    @InvocableMethod(label='DC - Get Duplicates IDs from DC Flow Output' description='Returns the Duplicate IDs from the output of another Duplicate Check Flow Action.')
    global static List<dupcheck.dc3GetDuplicateIdsFromDcOutputFlowAction.dc3FindMasterByDcOutputFlowActionResult> getDuplicateIdsFromDcOutputFlowAction(List<dupcheck.dc3GetDuplicateIdsFromDcOutputFlowAction.dc3FindMasterByDcOutputFlowActionRequest> requests) {
        return null;
    }
global class dc3FindMasterByDcOutputFlowActionRequest {
    @InvocableVariable(label='Duplicate Result' description='The full duplicate search result' required=true)
    global dupcheck.dc3FlowSearchComplexType duplicateResult;
    @InvocableVariable(label='Object Prefix to retrieve the IDs for' description='Object Prefix to retrieve the IDs for' required=false)
    global String objectPrefix;
    @InvocableVariable(label='Threshold' description='The minimum threshold to return the records for' required=false)
    global Integer threshold;
    global dc3FindMasterByDcOutputFlowActionRequest() {

    }
}
global class dc3FindMasterByDcOutputFlowActionResult {
    @InvocableVariable(label='Duplicate Record IDs' required=false)
    global List<String> duplicateRecordIds;
    @InvocableVariable(label='Source ID (Record Used to Search for Duplicates)' required=false)
    global String sourceId;
    global dc3FindMasterByDcOutputFlowActionResult() {

    }
}
}
