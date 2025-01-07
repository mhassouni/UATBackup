global class EmployeeCountNoteUpdateBatch implements Database.Batchable<sObject>, Database.Stateful 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String query = 'SELECT Id, DB_Code_Activite_NACE__c, CodeNACE__c, DB_DUNS_DU__c, Pourcentage_effectif__c, Note_Nombre_employe__c FROM Account ';
		return Database.getQueryLocator(query);
    }
    
     
    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        List<Account> accountToUpdate = new List<Account>();

        // Créer un ensemble pour stocker les ID des enregistrements déjà ajoutés
		Set<Id> existingIds = new Set<Id>();
        for (Account acc : scope) 
        {
            for (EmployeeNoteRule__c rule : [SELECT Code_Nace__c, Minimum_Percentage__c, Maximum_Percentage__c, Note__c FROM EmployeeNoteRule__c where Code_Nace__c =:acc.DB_Code_Activite_NACE__c]) 
            {
                if (acc.Pourcentage_effectif__c != null && acc.Pourcentage_effectif__c >= rule.Minimum_Percentage__c && acc.Pourcentage_effectif__c < rule.Maximum_Percentage__c) 
                {
                    // Vérifier si l'ID de l'enregistrement n'est pas déjà dans l'ensemble existingIds
                    if (!existingIds.contains(acc.Id)) 
                    {
                        // Ajouter l'ID de l'enregistrement à l'ensemble existingIds
                        existingIds.add(acc.Id);
                        // Ajouter l'enregistrement à la liste accountToUpdate
                        acc.Note_Nombre_employe__c = rule.Note__c;
                        accountToUpdate.add(acc);
                    }
           		 }
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
        mail.setSubject('Batch Process Completed: EmployeeCountNoteUpdateBatch');
        
        // Construire le corps de l'email
        String emailBody = 'The batch EmployeeCountNoteUpdateBatch has finished:\n\n';

        mail.setPlainTextBody(emailBody);
        
        // Envoyer l'email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    }

}