/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class RunFixScheduleOverlaps {
    global RunFixScheduleOverlaps() {

    }
    @InvocableMethod(label='Fix Schedule Overlaps' description='Fixes the schedule when a service appointment overlaps with another appointment, absence, or travel time.')
    global static void runFixOverlap(List<FSL.RunFixScheduleOverlaps.FixOverlapActionRequest> fixOverlapActionRequests) {

    }
global class FixOverlapActionRequest {
    @InvocableVariable(label='Overlap Day End' description='The end date and time of the day that the overlap occurs.' required=true)
    global Datetime EndTime;
    @InvocableVariable(label='Resource ID' description='The ID of the service resource that has the overlap.' required=true)
    global String ResourceId;
    @InvocableVariable(label='Resource TimeZone' description='The timezone of the service resource that has the overlap.' required=true)
    global String ResourceTimeZone;
    @InvocableVariable(label='Scheduling Policy' description='The scheduling policy used when running the Fix Schedule Overlaps action.' required=true)
    global String SchedulingPolicyId;
    @InvocableVariable(label='Overlap Day Start' description='The start date and time of the day that the overlap occurs.' required=true)
    global Datetime StartTime;
    global FixOverlapActionRequest() {

    }
}
}
