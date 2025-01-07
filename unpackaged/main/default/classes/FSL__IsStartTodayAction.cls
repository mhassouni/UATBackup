/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class IsStartTodayAction {
    global IsStartTodayAction() {

    }
    @InvocableMethod(label='Check If Overlap Is Today' description='Checks whether the overlap occurred today.')
    global static List<Boolean> isDateTodayInTimezone(List<FSL.IsStartTodayAction.IsServiceStartTodayDecisionRequest> isServiceStartTodayDecisionRequest) {
        return null;
    }
global class IsServiceStartTodayDecisionRequest {
    @InvocableVariable(label='Object Type' description='The type of object that triggered the overlap.' required=true)
    global String eventType;
    @InvocableVariable(label='Object Id' description='The ID of the object that caused the overlap.' required=true)
    global Id objectId;
    @InvocableVariable(label='Resource TimeZone' description='The timezone of the service resource that has the overlap.' required=true)
    global String timezoneName;
    global IsServiceStartTodayDecisionRequest() {

    }
}
}
