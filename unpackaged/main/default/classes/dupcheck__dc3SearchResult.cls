/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3SearchResult implements System.Comparable {
    global SObject objectData {
        get;
        set;
    }
    global List<dupcheck.dc3SearchResult.ScenarioScore> scenarioScores {
        get;
        set;
    }
    global Integer score {
        get;
        set;
    }
    global dc3SearchResult() {

    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
    global Map<String,Object> getDisplayField() {
        return null;
    }
    global Map<String,Object> getDisplayField(Id recordType) {
        return null;
    }
    global String getObjectName() {
        return null;
    }
    global String getObjectPrefix() {
        return null;
    }
global class IndexSearchData {
    global Integer indexLimit {
        get;
        set;
    }
    global Integer indexResult {
        get;
        set;
    }
    global String objectPrefix {
        get;
        set;
    }
    global IndexSearchData() {

    }
}
global class ScenarioScore {
    global Id scenarioId {
        get;
        set;
    }
    global String scenarioName {
        get;
        set;
    }
    global Integer scenarioScore {
        get;
        set;
    }
    global ScenarioScore(Id sId, String sName, Integer sScore) {

    }
}
}
