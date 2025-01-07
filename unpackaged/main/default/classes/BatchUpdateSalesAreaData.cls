public class BatchUpdateSalesAreaData implements Database.Batchable<SObject>, Database.Stateful {
    private Set<Id> secteurIds;
    private Map<Id, Secteur__c> secteurMap;

    // Constructor to initialize the Secteur IDs
    public BatchUpdateSalesAreaData(Set<Id> secteurIds) {
        this.secteurIds = secteurIds;
    }

    // Start method to query SalesAreaData__c records
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query and cache Secteur__c records
        secteurMap = new Map<Id, Secteur__c>([
            SELECT Id, Commercial__c, Manager_Commercial__c
            FROM Secteur__c
            WHERE Id IN :secteurIds
        ]);

        // Query related SalesAreaData__c records
        return Database.getQueryLocator([
            SELECT Id, Secteur__c
            FROM SalesAreaData__c
            WHERE Secteur__c IN :secteurIds
        ]);
    }

    // Execute method to process each batch of records
    public void execute(Database.BatchableContext bc, List<SalesAreaData__c> scope) {
        List<SalesAreaData__c> recordsToUpdate = new List<SalesAreaData__c>();

        for (SalesAreaData__c salesData : scope) {
            Secteur__c secteur = secteurMap.get(salesData.Secteur__c);
            if (secteur != null) {
                salesData.TerritorialCommercial__c = secteur.Commercial__c;
                salesData.ManagerCommercial__c = secteur.Manager_Commercial__c;
                recordsToUpdate.add(salesData);
            }
        }

        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
    }

    // Finish method (optional)
    public void finish(Database.BatchableContext bc) {
        // Send email when Batch finish
         // Préparer et envoyer l'email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'mhassouni@petitforestier.fr'}; 
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Process Completed: BatchUpdateSalesAreaData');
            
            // Construire le corps de l'email
            String emailBody = 'The batch BatchUpdateSalesAreaData has finished:\n\n';
    
            mail.setPlainTextBody(emailBody);
            
            // Envoyer l'email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}