/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class dc3DuplicateResult {
    global Integer duplicateCount {
        get;
        set;
    }
    global Map<String,Map<String,dupcheck.dc3Meta.fieldMeta>> fieldMeta {
        get;
        set;
    }
    global Map<String,dupcheck.dc3Meta.objectMeta> objectMeta {
        get;
        set;
    }
    global Map<String,List<Map<String,Object>>> searchResult {
        get;
        set;
    }
    global Map<String,List<dupcheck.dc3Config.ResultField>> searchResultField {
        get;
        set;
    }
    global dc3DuplicateResult(Map<String,List<dupcheck.dc3SearchResult>> searchResult) {

    }
}
