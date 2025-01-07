trigger  SAPCPQ_QuoteTrigger on Quote__c (before update) {
    // Vérifiez si le déclencheur est exécuté après une mise à jour
    if ( Trigger.isUpdate) {
        // Parcourir les nouveaux devis et les anciens devis dans Trigger.oldMap
        for (Quote__c newQuote : Trigger.new) {
            Quote__c oldQuote = Trigger.oldMap.get(newQuote.Id);
            
            // Vérifiez si la date de validité a changé
            if (newQuote.Date_de_validite_du_devis__c != oldQuote.Date_de_validite_du_devis__c) {
                // Mettez à jour le champ Quote_Validity_Notification_Sent__c à false
                newQuote.Quote_Validity_Notification_Sent__c = false;
            }
        }
    }
}