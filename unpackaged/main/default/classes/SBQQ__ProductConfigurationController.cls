/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class ProductConfigurationController {
    global ProductConfigurationController() {

    }
    @RemoteAction
    global static String loadConfiguredProduct(String quoteJSON, Id productId, Integer lineItemKey, List<String> featureOptionalSKUs, String existingConfigJSON, String parentProductJSON) {
        return null;
    }
    global static String loadConfiguredProduct(String quoteJSON, Id productId, List<String> featureOptionalSKUs) {
        return null;
    }
    global static String loadConfiguredProducts(String quoteJSON, List<Id> productIds) {
        return null;
    }
    global static String loadOptionData(String quoteJSON, List<Id> optionIds) {
        return null;
    }
    @RemoteAction
    global static String loadOptionData(String quoteJSON, List<String> featureOptionIds, String fieldSetName) {
        return null;
    }
    global static String loadSearchModelFiltered(String quoteJSON, List<String> filtersJSON) {
        return null;
    }
    @RemoteAction
    global static String loadSearchModelFiltered(String quoteJSON, List<String> filtersJSON, String filterFieldSet) {
        return null;
    }
    @RemoteAction
    global static String saveConfiguration(String quoteJSON, String configJSON, String upgradedAssetId) {
        return null;
    }
    global static String searchLookup(String quoteJSON, String filterValuesJSON) {
        return null;
    }
    global static String searchLookupWithFilters(String quoteJSON, String filterValuesJSON, List<String> filtersJSON) {
        return null;
    }
    global static String searchLookup(String quoteJSON, String filterValuesJSON, List<String> filtersJSON) {
        return null;
    }
    @RemoteAction
    global static String searchLookup(String quoteJSON, String filterFieldSet, String filterValuesJSON, List<String> filtersJSON) {
        return null;
    }
    @RemoteAction
    global static String updateConfiguration(String quoteJSON, String configJSON, String upgradedAssetId) {
        return null;
    }
}
