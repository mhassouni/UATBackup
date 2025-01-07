public class AssetCalendarController {
  
  @AuraEnabled
  public static List<Reservation__c> getReservations(Id assetId) {
    return [
      SELECT
        Id,
        Name,
        Client__c,
        Client__r.Name,
        Date_de_debut__c,
        Date_de_fin__c,
        Description_Gantt__c,
        RecordType.Name,
        RecordType.DeveloperName,
        Type_Atelier__c,
        Type_de_transport__c,
        Status__c
      FROM Reservation__c
      WHERE Asset_Assigne__c = :assetId
      LIMIT 5000
    ];
  }
    
  @AuraEnabled
  public static List<Holiday> getHolidays() {
    return [SELECT ActivityDate, Name FROM Holiday];
  }
}