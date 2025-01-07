/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class AppointmentInsightsResult {
    global Integer blockedSlots {
        get;
        set;
    }
    global List<FSL.AppointmentInsightsResult.BlockingRule> blockingRules {
        get;
        set;
    }
    global Datetime horizonEndDate {
        get;
        set;
    }
    global Datetime horizonStartDate {
        get;
        set;
    }
    global Datetime operationStartTime {
        get;
        set;
    }
    global Id policyId {
        get;
        set;
    }
    global Integer resourcesEvaluated {
        get;
        set;
    }
    global Id serviceAppointmentId {
        get;
        set;
    }
    global Id serviceTerritoryId {
        get;
        set;
    }
    global AppointmentInsightsResult() {

    }
global class BlockingRule {
    global String ruleName {
        get;
        set;
    }
    global Integer slotsBlockedByMultipleRules {
        get;
        set;
    }
    global Integer slotsBlockedByRule {
        get;
        set;
    }
    global BlockingRule() {

    }
}
}
