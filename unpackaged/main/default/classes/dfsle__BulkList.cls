/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class BulkList {
    global List<dfsle.Envelope> copies {
        get;
    }
    global dfsle.UUID docuSignId {
        get;
    }
    global Id id {
        get;
    }
    global String name {
        get;
    }
    global dfsle.Entity source {
        get;
    }
    global static String STATUS_FAILED;
    global static String STATUS_PROCESSING;
    global static String STATUS_QUEUED;
    global static String STATUS_SENT;
    global static dfsle.BulkList newList(String name, List<dfsle.Envelope> copies, dfsle.Entity source) {
        return null;
    }
global class Result {
    global Id bulkStatusId {
        get;
    }
    global List<dfsle.APIError> errors {
        get;
    }
    global Boolean success {
        get;
    }
}
global class Status {
    global Integer batchSize {
        get;
    }
    global dfsle.UUID docuSignId {
        get;
    }
    global Integer failedEnvelopes {
        get;
    }
    global Id id {
        get;
    }
    global Boolean isFinal {
        get;
    }
    global Datetime lastStatusUpdate {
        get;
    }
    global Integer queuedEnvelopes {
        get;
    }
    global Integer sentEnvelopes {
        get;
    }
    global dfsle.Entity source {
        get;
    }
    global Datetime submitted {
        get;
    }
}
}
