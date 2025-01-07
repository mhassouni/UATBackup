/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
@RestResource(urlMapping='/dc3Merge/*')
global class dc3MergeRest {
    global dc3MergeRest() {

    }
    @HttpPost
    global static Boolean doMerge(dupcheck.dc3MergeRest.MergeInput mergeInput) {
        return null;
    }
global class MergeInput {
    global Id jobId {
        get;
        set;
    }
    global SObject masterObject {
        get;
        set;
    }
    global String mergeData {
        get;
        set;
    }
    global String mergeMethod {
        get;
        set;
    }
    global List<SObject> objectList {
        get;
        set;
    }
    global String objectPrefix {
        get;
        set;
    }
    global MergeInput() {

    }
    global String toJson() {
        return null;
    }
}
}
