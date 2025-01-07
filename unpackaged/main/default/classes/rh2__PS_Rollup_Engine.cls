/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global interface PS_Rollup_Engine {
    SObject getOrgDefaultSettings();
    List<SObject> performTriggerRollups(Map<Id,SObject> param0, Map<Id,SObject> param1, Boolean param2);
    void setRollupSetting(String param0, String param1, String param2, String param3, String param4);
}
