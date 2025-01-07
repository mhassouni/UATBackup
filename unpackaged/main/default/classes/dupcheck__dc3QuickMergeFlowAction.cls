/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3QuickMergeFlowAction {
    global dc3QuickMergeFlowAction() {

    }
    @InvocableMethod(label='DC - Quick Merge' description='Merge given records based on the Duplicate Check merge rules.')
    global static List<dupcheck.dc3QuickMergeFlowAction.QuickMergeResult> quickMergeRecords(List<dupcheck.dc3QuickMergeFlowAction.QuickMergeRequest> quickMergeRequests) {
        return null;
    }
global class QuickMergeRequest {
    @InvocableVariable(label='RecordIDs' description='The record IDs to merge.' required=false)
    global List<Id> recordIds;
    @InvocableVariable(label='SearchResult' description='A duplicate search result from a DC3 Search Flow Action.' required=false)
    global dupcheck.dc3FlowSearchComplexType searchResult;
    @InvocableVariable(label='Threshold' description='The threshold for merging SearchResult records.' required=false)
    global Integer threshold;
    global QuickMergeRequest() {

    }
}
global class QuickMergeResult {
    @InvocableVariable(label='MasterRecordID' description='The ID of the master record duplicates have been merged into.' required=false)
    global Id masterRecordId;
    @InvocableVariable(label='MergeSucceeded' description='Wether or not the merge has succeeded.' required=false)
    global Boolean mergeSucceeded;
    global QuickMergeResult() {

    }
}
}
