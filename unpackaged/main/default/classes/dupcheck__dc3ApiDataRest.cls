/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
@RestResource(urlMapping='/dc3DataApi/*')
global class dc3ApiDataRest {
    global dc3ApiDataRest() {

    }
    @HttpPost
    global static dupcheck.dc3ApiDataRest.UpsertDataOutput doUpsert(dupcheck.dc3ApiDataRest.UpsertDataInput input) {
        return null;
    }
global class RelatedDataInput {
    global Boolean duplicateCheck {
        get;
        set;
    }
    global Integer duplicateScore {
        get;
        set;
    }
    global Map<String,String> objectData {
        get;
        set;
    }
    global String objectType {
        get;
        set;
    }
    global String recordType {
        get;
        set;
    }
    global String referenceField {
        get;
        set;
    }
    global List<dupcheck.dc3ApiDataRest.RelatedDataInput> relatedList {
        get;
        set;
    }
    global RelatedDataInput() {

    }
}
global class RelatedDataOutput {
    global String errorMessage {
        get;
        set;
    }
    global Boolean isCreated {
        get;
        set;
    }
    global Boolean isSuccess {
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
    global List<dupcheck.dc3ApiDataRest.RelatedDataOutput> relatedList {
        get;
        set;
    }
    global RelatedDataOutput() {

    }
}
global class UpsertDataInput {
    global Boolean allOrNone {
        get;
        set;
    }
    global Boolean duplicateCheck {
        get;
        set;
    }
    global Integer duplicateScore {
        get;
        set;
    }
    global Map<String,String> objectData {
        get;
        set;
    }
    global String objectType {
        get;
        set;
    }
    global String recordType {
        get;
        set;
    }
    global List<dupcheck.dc3ApiDataRest.RelatedDataInput> relatedList {
        get;
        set;
    }
    global UpsertDataInput() {

    }
}
global class UpsertDataOutput {
    global String errorMessage {
        get;
        set;
    }
    global Boolean isCreated {
        get;
        set;
    }
    global Boolean isSuccess {
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
    global List<dupcheck.dc3ApiDataRest.RelatedDataOutput> relatedList {
        get;
        set;
    }
    global UpsertDataOutput() {

    }
}
}
