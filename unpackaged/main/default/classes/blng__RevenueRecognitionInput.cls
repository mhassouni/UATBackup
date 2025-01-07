/*
Ce fichier est généré ne correspond pas au code source de cette
classe globale gérée.
Ce fichier en lecture seule affiche les constructeurs globaux,
les méthodes, les variables et les propriétés de la classe.
Pour activer le code à compiler, toutes les méthodes renvoient null.
*/
global class RevenueRecognitionInput {
    @InvocableVariable(label='Currency ISO Code' description='Currency ISO code for recognized revenue' required=false)
    global String currencyIsoCode;
    @InvocableVariable(label='End Date' description='Refers to the revenue term end date' required=false)
    global Date endDate;
    @InvocableVariable(label='Legal Entity Id' description='Refers to the legal entity where this revenue is recorded' required=false)
    global Id legalEntityId;
    @InvocableVariable(label='Revenue Amount' description='Total revenue to recognize with this revenue schedule' required=true)
    global Decimal revenueAmount;
    @InvocableVariable(label='Revenue Recognition Rule Id' description='Lookup to the revenue recognition rule used for this revenue schedule' required=true)
    global Id revenueRecognitionRuleId;
    @InvocableVariable(label='Source' description='Id of the source object from which this revenue is recognized' required=true)
    global Id source;
    @InvocableVariable(label='Source Field Name' description='Name of the field on revenue schedule to insert the source id' required=true)
    global String sourceFieldName;
    @InvocableVariable(label='Start Date' description='Refers to the revenue term start date' required=true)
    global Date startDate;
    global RevenueRecognitionInput() {

    }
}
