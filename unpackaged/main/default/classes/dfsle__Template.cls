/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class Template {
    global List<dfsle.CustomField> customFields {
        get;
    }
    global String emailMessage {
        get;
    }
    global String emailSubject {
        get;
    }
    global dfsle.UUID id {
        get;
    }
    global Datetime lastModified {
        get;
    }
    global String name {
        get;
    }
    global dfsle.Notifications notifications {
        get;
    }
    global List<dfsle.Recipient> recipients {
        get;
    }
    global Template(dfsle.UUID id, String name, List<dfsle.CustomField> customFields, dfsle.Notifications notifications, String emailSubject, String emailMessage, List<dfsle.Recipient> recipients, Datetime lastModified) {

    }
}
