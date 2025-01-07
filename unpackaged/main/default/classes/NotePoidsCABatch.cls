global class NotePoidsCABatch implements Database.Batchable<sObject>, Database.Stateful {
    

    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String query = 'SELECT Id, DB_Code_Activite_NACE__c, CodeNACE__c, DB_DUNS_DU__c, Poids_CA__c, Note_Poids_CA__c FROM Account';
		return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        List<Account> accountToUpdate = new List<Account>();
        
        for (Account acc : scope) 
        {
            if (acc.Poids_CA__c <= 0) 
            {
                acc.Note_Poids_CA__c = 1;
                accountToUpdate.add(acc);
            } 
            
            else if (acc.Poids_CA__c > 0 && acc.Poids_CA__c < 2) 
            {
                acc.Note_Poids_CA__c = 2;
                accountToUpdate.add(acc);
            } 
            
            else if (acc.Poids_CA__c >= 2 && acc.Poids_CA__c < 5) 
            {
                acc.Note_Poids_CA__c = 3;
                accountToUpdate.add(acc);
            }
            
            else if (acc.Poids_CA__c >= 5 && acc.Poids_CA__c < 10) 
            {
                acc.Note_Poids_CA__c = 4;
                accountToUpdate.add(acc);
            } 
            
            else if (acc.Poids_CA__c >= 10 && acc.Poids_CA__c < 15) 
            {
                acc.Note_Poids_CA__c = 5;
                accountToUpdate.add(acc);
            }
            
            else if (acc.Poids_CA__c >= 15 && acc.Poids_CA__c < 20) 
            {
                acc.Note_Poids_CA__c = 6;
                accountToUpdate.add(acc);
            }
            
            else if (acc.Poids_CA__c >= 20 && acc.Poids_CA__c < 30) 
            {
                acc.Note_Poids_CA__c = 7;
                accountToUpdate.add(acc);
            }
            
            else if (acc.Poids_CA__c >= 30 && acc.Poids_CA__c < 50) 
            {
                acc.Note_Poids_CA__c = 8;
                accountToUpdate.add(acc);
            }
            
            else if (acc.Poids_CA__c >= 50 && acc.Poids_CA__c < 75) 
            {
                acc.Note_Poids_CA__c = 9;
                accountToUpdate.add(acc);
            }
            
            else if (acc.Poids_CA__c > 75) 
            {
                acc.Note_Poids_CA__c = 10;
                accountToUpdate.add(acc);
            }
        }
        
        if(!accountToUpdate.isEmpty())
        {
        	update accountToUpdate;
        } 
    }
    
    global void finish(Database.BatchableContext BC) 
    {
        // Préparer et envoyer l'email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'helachboura@petitforestier.fr'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Process Completed: NotePoidsCABatch');
        
        // Construire le corps de l'email
        String emailBody = 'The batch NotePoidsCABatch has finished:\n\n';

        mail.setPlainTextBody(emailBody);
        
        // Envoyer l'email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}