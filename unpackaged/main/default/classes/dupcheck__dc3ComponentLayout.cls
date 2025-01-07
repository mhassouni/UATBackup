/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3ComponentLayout {
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
    global Id objectId {
        get;
        set;
    }
    global dupcheck.dc3Settings settings {
        get;
        set;
    }
    global dc3ComponentLayout() {

    }
    @RemoteAction
    global static dupcheck.dc3ComponentLayout.remoteResult doCheck(Id recordId) {
        return null;
    }
    @AuraEnabled
    global static dupcheck.dc3LightningResult doCheckResult(Id recordId) {
        return null;
    }
    global String getAssetsUrl() {
        return null;
    }
    global String getAssetsUrlStatic() {
        return null;
    }
global class remoteResult {
    global remoteResult() {

    }
}
}
