public class DateModificationHandler {
    public static void handleDateModification(List<Quote__c> newQuotes, Map<Id, Quote__c> oldMap) {
        List<Quote__c> quotesToUpdateWithNotification = new List<Quote__c>();
        
        for (Quote__c newQuote : newQuotes) {
            Quote__c oldQuote = oldMap.get(newQuote.Id);
            if (newQuote.Date_de_validite_du_devis__c != oldQuote.Date_de_validite_du_devis__c) {
                // Ajouter les enregistrements nécessitant une mise à jour à la liste
                newQuote.Quote_Validity_Notification_Sent__c = false;
                quotesToUpdateWithNotification.add(newQuote);
            }
        }
        
        // Effectuer l'update des enregistrements avec la notification
        if (!quotesToUpdateWithNotification.isEmpty()) {
            update quotesToUpdateWithNotification;
        }
    }
}