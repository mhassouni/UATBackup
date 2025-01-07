/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global interface PaymentGateWay {
    Map<String,blng.TransactionResult> authorizeTransaction(Map<String,blng.TransactionParameter> param0);
    Map<String,blng.TransactionResult> chargeTransaction(Map<String,blng.TransactionParameter> param0);
    Map<String,blng.TransactionResult> generateToken(Map<String,blng.TransactionParameter> param0);
    Map<String,blng.TransactionResult> refundTransaction(Map<String,blng.TransactionParameter> param0);
    Map<String,blng.TransactionResult> voidTransaction(Map<String,blng.TransactionParameter> param0);
}
