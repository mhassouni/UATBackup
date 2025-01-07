global class DefaultSectorOverallRatingBatch implements Database.Batchable<sObject>, Database.Stateful 
{ 
	global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator([
            SELECT Id, Note_globale_secteur__c, Legal_Entity_Sector_Overall_Rating__c, DB_DUNS_DU__c
            FROM Account
            WHERE Note_globale_secteur__c = null  
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        List<Account> accountsToUpdate = new List<Account>();
        
        // Regrouper les notes par compte
        for(Account accountRecord : scope) 
        {
            accountRecord.Note_globale_secteur__c = 1;
            accountsToUpdate.add(accountRecord);
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
        String[] toAddresses = new String[] {'mhassouni@petitforestier.fr', 'helachboura@petitforestier.fr'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Process Completed: DefaultSectorOverallRatingBatch => Note globale du secteur par defaut');
        
        // Construire le corps de l'email
        String emailBody = 'The batch has finished:\n\n';
        
        
        mail.setPlainTextBody(emailBody);
        
        // Envoyer l'email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}