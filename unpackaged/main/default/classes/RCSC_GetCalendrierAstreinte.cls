public with sharing class RCSC_GetCalendrierAstreinte {

    @AuraEnabled
    
    public static List<Calendrier_Astreinte__c> listWeeks(String Id){
        List<Calendrier_Astreinte__c> result = [SELECT Id, Numero_semaine_dates__c
        FROM Calendrier_Astreinte__c
        WHERE Agence_PF__c =: Id AND Date_de_fin__c >= TODAY ORDER BY Date_de_debut__c,Date_de_fin__c ASC];
        return result;
    }
}