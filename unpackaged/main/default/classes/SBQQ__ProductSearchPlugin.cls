/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global interface ProductSearchPlugin {
    String getAdditionalSearchFilters(SObject param0, Map<String,Object> param1);
    String getAdditionalSuggestFilters(SObject param0, Map<String,Object> param1);
    Object getFilterDefaultValue(SObject param0, String param1);
    Object getInputDefaultValue(SObject param0, String param1);
    Boolean isFilterHidden(SObject param0, String param1);
    Boolean isInputHidden(SObject param0, String param1);
    Boolean isSearchCustom(SObject param0, Map<String,Object> param1);
    Boolean isSuggestCustom(SObject param0, Map<String,Object> param1);
    List<PricebookEntry> search(SObject param0, Map<String,Object> param1);
    List<PricebookEntry> suggest(SObject param0, Map<String,Object> param1);
}
