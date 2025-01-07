/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class RecurringPattern {
    global Set<FSL.RecurringPattern.DaysOfWeek> DaysOfWeek {
        get;
        set;
    }
    global Integer Frequency {
        get;
        set;
    }
    global FSL.RecurringPattern.FrequencyType FrequencyType {
        get;
        set;
    }
    global Integer NumberOfVisits {
        get;
        set;
    }
    global RecurringPattern() {

    }
global enum DaysOfWeek {Friday, Monday, Saturday, Sunday, Thursday, Tuesday, Wednesday}
global enum FrequencyType {DAILY, MONTHLY, WEEKLY}
}
