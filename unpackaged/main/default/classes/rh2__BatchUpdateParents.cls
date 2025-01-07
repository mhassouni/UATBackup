/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class BatchUpdateParents implements Database.Batchable<SObject>, Database.Stateful {
    global Map<String,List<SObject>> childrenByObject;
    global Datetime dt;
    global Map<String,String> queryByObject;
    global List<String> relFields;
    global Map<String,Map<String,Map<String,Set<Id>>>> resultSet;
    global Map<String,List<String>> settingsByQuery;
    global BatchUpdateParents(List<String> q) {

    }
    global BatchUpdateParents(Map<String,List<SObject>> triggerSource) {

    }
    global BatchUpdateParents(Map<String,List<String>> sByQ) {

    }
    global BatchUpdateParents(Map<String,String> q) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global System.Iterable start(Database.BatchableContext BC) {
        return null;
    }
}
