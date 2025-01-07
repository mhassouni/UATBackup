/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class OptimizerService {
    global OptimizerService() {

    }
    global static dlrs.OptimizerService.Summary analyize() {
        return null;
    }
    global static dlrs.OptimizerService.Summary analyize(Set<dlrs.OptimizerService.NotificationReference> checksToRun) {
        return null;
    }
global class Notification {
    global dlrs.OptimizerService.NotificationReference Id {
        get;
    }
    global String Message {
        get;
    }
    global String MoreInfoURL {
        get;
    }
    global dlrs.OptimizerService.NotificationStatus Status {
        get;
    }
    global Notification() {

    }
}
global enum NotificationReference {LookupRollupSummaryLogsExist, LookupRollupSummaryScheduleItemsFieldDeletion, LookupRollupSummaryScheduleItemsInError, LookupRollupSummaryScheduleItemsWithFullCalcScheduleJob, LookupShadowRecordsNeedDeleting}
global enum NotificationStatus {Attention, CheckFailed, Warning}
global class Summary {
    global Map<dlrs.OptimizerService.NotificationReference,dlrs.OptimizerService.Notification> Notifications {
        get;
    }
    global dlrs.OptimizerService.SummaryStatus Status {
        get;
    }
    global Summary() {

    }
}
global enum SummaryStatus {Complete, CompleteNeedsAttention, CompleteWithWarnings}
}
