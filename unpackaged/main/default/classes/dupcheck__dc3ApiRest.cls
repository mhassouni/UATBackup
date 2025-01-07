/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
@RestResource(urlMapping='/dc3Api/*')
global class dc3ApiRest {
    global dc3ApiRest() {

    }
    @HttpPost
    global static void doPost() {

    }
global class DeltaInput {
    global Id deltaId {
        get;
        set;
    }
    global String jobName {
        get;
        set;
    }
    global Id objectId {
        get;
        set;
    }
    global String type {
        get;
        set;
    }
    global DeltaInput() {

    }
}
global class ExportImportJobStatInput {
    global String jobId {
        get;
        set;
    }
    global ExportImportJobStatInput() {

    }
}
global class ExportJobStatOutput extends dupcheck.dc3ApiRest.SimpleRestOutput {
    global AsyncApexJob jobInfo {
        get;
        set;
    }
    global ExportJobStatOutput() {

    }
}
global class ImportConfigInput {
    global String content {
        get;
        set;
    }
    global ImportConfigInput() {

    }
}
global class ImportJobStatOutput extends dupcheck.dc3ApiRest.SimpleRestOutput {
    global AsyncApexJob jobInfo {
        get;
        set;
    }
    global ImportJobStatOutput() {

    }
}
global class SearchInput {
    global String filterDeveloperName {
        get;
        set;
    }
    global Map<String,String> objectData {
        get;
        set;
    }
    global String objectPrefix {
        get;
        set;
    }
    global SearchInput() {

    }
}
global abstract class SimpleRestOutput {
    global String errorMessage {
        get;
        set;
    }
    global Boolean ok {
        get;
        set;
    }
}
global class SimpleRestOutputImpl extends dupcheck.dc3ApiRest.SimpleRestOutput {
    global SimpleRestOutputImpl() {

    }
}
global class SubmitConfigJobOutput extends dupcheck.dc3ApiRest.SimpleRestOutput {
    global String jobId {
        get;
        set;
    }
    global SubmitConfigJobOutput() {

    }
}
}
