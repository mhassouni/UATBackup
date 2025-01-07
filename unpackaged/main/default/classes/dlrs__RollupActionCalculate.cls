/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class RollupActionCalculate {
    global RollupActionCalculate() {

    }
    @InvocableMethod(label='Calculates a rollup' description='Provide the Id of the parent record and the unique name of the rollup to calculate, you specificy the same Id multiple times to invoke multiple rollups')
    global static void calculate(List<dlrs.RollupActionCalculate.RollupToCalculate> rollupsToCalculate) {

    }
global class RollupToCalculate {
    @InvocableVariable(label='Parent Record Id' required=true)
    global Id ParentId;
    @InvocableVariable(label='Rollup Summary Unique Name' required=true)
    global String RollupSummaryUniqueName;
    global RollupToCalculate() {

    }
}
}
