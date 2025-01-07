global class CalculateSectorOverallRatingBatch implements Database.Batchable<sObject>, Database.Stateful 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator([
            SELECT Id, Note_secteur__c, Account__c, Account__r.name, Account__r.DB_DUNS_DU__c
            FROM SalesAreaData__c
            WHERE  Note_secteur__c > 1
        ]);
    }

    global void execute(Database.BatchableContext BC, List<SalesAreaData__c> scope) 
    {
        Map<Id, List<Decimal>> accountNotesToCompute_Map = new Map<Id, List<Decimal>>();
        
        // Regrouper les notes par compte
        for(SalesAreaData__c sad : scope) 
        {
            if(!accountNotesToCompute_Map.containsKey(sad.Account__c)) 
            {
                accountNotesToCompute_Map.put(sad.Account__c, new List<Decimal>());
            }
            accountNotesToCompute_Map.get(sad.Account__c).add(sad.Note_secteur__c);
        }
        
        // Calculer la moyenne et mettre à jour les comptes
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accId : accountNotesToCompute_Map.keySet()) 
        {
            List<Decimal> notes = accountNotesToCompute_Map.get(accId);
            Decimal total = 0;
            for(Decimal note : notes) 
            {
                total += note;
            }
            Decimal average = total / notes.size();
            DateTime currentDateTime = System.now();
            String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
            accountsToUpdate.add(new Account(Id = accId, Note_globale_secteur__c = average, Last_Batch_Update__c = formattedDateTime));
        }
        
        if(!accountsToUpdate.isEmpty()) 
        {
            update accountsToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC) 
    {
        // Préparer et envoyer l'email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'helachboura@petitforestier.fr'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Process Completed: CalculateSectorOverallRatingBatch => Note globale du secteur');
        
        // Construire le corps de l'email
        String emailBody = 'The batch CalculateSectorOverallRatingBatch has finished\n\n';
        mail.setPlainTextBody(emailBody);
        
        // Envoyer l'email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
}