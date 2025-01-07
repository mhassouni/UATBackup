/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3ComponentCheck {
    global String cssUrl {
        get;
        set;
    }
    global Boolean isDev {
        get;
        set;
    }
    global dupcheck.dc3License license {
        get;
        set;
    }
    global dupcheck.dc3Config objectConfig {
        get;
        set;
    }
    global SObject objectData {
        get;
        set;
    }
    global String objectFieldName {
        get;
        set;
    }
    global Id objectId {
        get;
        set;
    }
    global dupcheck.dc3Settings settings {
        get;
        set;
    }
    global dc3ComponentCheck() {

    }
    @RemoteAction
    global static dupcheck.dc3HelperGlobal.remoteResult doCheck(Id recordId) {
        return null;
    }
    global String getAssetsUrl() {
        return null;
    }
    global String getAssetsUrlNew() {
        return null;
    }
    global String getAssetsUrlStatic() {
        return null;
    }
}
