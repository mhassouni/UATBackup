/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3LightningResult {
    global dupcheck.dc3AuraSearchResult auraResult {
        get;
        set;
    }
    global Integer DuplicateCount {
        get;
        set;
    }
    global String FirstObject {
        get;
        set;
    }
    global List<dupcheck.dc3LightningResult.ObjectResult> ObjectResult {
        get;
        set;
    }
    global dc3LightningResult(Map<String,List<dupcheck.dc3SearchResult>> searchResult) {

    }
global class IterationMap {
    global String key {
        get;
        set;
    }
    global String value {
        get;
        set;
    }
    global IterationMap(String k, String v) {

    }
}
global class ObjectResult {
    @AuraEnabled
    global Integer DuplicateCount;
    @AuraEnabled
    global Boolean isActive;
    @AuraEnabled
    global Boolean isConvert;
    @AuraEnabled
    global Boolean isMerge;
    @AuraEnabled
    global String Label;
    @AuraEnabled
    global String ObjectName;
    @AuraEnabled
    global String Prefix;
    @AuraEnabled
    global List<dupcheck.dc3LightningResult.RecordResult> ResultData;
    @AuraEnabled
    global List<dupcheck.dc3LightningResult.IterationMap> ResultFields;
    global ObjectResult() {

    }
}
global class RecordResult {
    @AuraEnabled
    global Boolean isSelected;
    @AuraEnabled
    global Map<String,Object> ObjectData;
    @AuraEnabled
    global Integer score;
    global RecordResult() {

    }
}
}
