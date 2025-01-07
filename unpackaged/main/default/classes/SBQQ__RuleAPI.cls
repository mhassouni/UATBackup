/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class RuleAPI {
    global RuleAPI() {

    }
    global static void executePriceRules(List<SObject> targets) {

    }
    global static void executePriceRules(List<SObject> targets, SObject configurationData) {

    }
    global static SBQQ.RuleAPI.SelectionProductRulesResult executeProductSelectionRules(String event, Id productId, List<SObject> targets, SObject configurationData) {
        return null;
    }
    global static SBQQ.RuleAPI.SelectionProductRulesResult executeProductSelectionRules(String event, Id productId, List<SObject> targets, SObject configurationData, Schema.SObjectField actionTargetField) {
        return null;
    }
    global static SBQQ.RuleAPI.SelectionProductRulesResult executeProductSelectionRules(String event, List<SObject> targets) {
        return null;
    }
    global static SBQQ.RuleAPI.SelectionProductRulesResult executeProductSelectionRules(String event, List<SObject> targets, Schema.SObjectField actionTargetField) {
        return null;
    }
    global static SBQQ.RuleAPI.ValidationProductRulesResult executeProductValidationRules(String event, Id productId, List<SObject> targets, SObject configurationData) {
        return null;
    }
    global static SBQQ.RuleAPI.ValidationProductRulesResult executeProductValidationRules(String event, List<SObject> targets) {
        return null;
    }
    global static void registerListener(SBQQ.RuleListener listener) {

    }
global class SelectionProductRulesResult {
    global Set<Id> disabledProductIds {
        get;
    }
    global Set<Id> enabledProductIds {
        get;
    }
    global Set<Id> hiddenProductIds {
        get;
    }
    global Set<Id> optionalProductIds {
        get;
    }
    global Set<Id> removedProductIds {
        get;
    }
    global Set<Id> requiredProductIds {
        get;
    }
    global Set<Id> shownProductIds {
        get;
    }
}
global class ValidationProductRulesResult {
    global List<String> messages {
        get;
        set;
    }
    global ValidationProductRulesResult() {

    }
}
}
