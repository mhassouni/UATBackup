global class InitVerifiedAccountsBatch implements Database.Batchable<sObject>, Database.Stateful 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String Query = 'SELECT Id, Verified__c, Last_Batch_Update__c FROM Account WHERE Verified__c = true';
        return Database.getQueryLocator(Query);
    } 

    global void execute(Database.BatchableContext BC, List<Account> scope) 
    {
        set<Account> updatesAccount = new set<Account>();
        for (Account acc : scope) 
        {
            acc.Verified__c = false;
            DateTime currentDateTime = System.now();
            String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
            //DateTime parsedDateTime = DateTime.valueOf(formattedDateTime);
            //acc.Last_Batch_Update__c = parsedDateTime;
            acc.Last_Batch_Update__c = formattedDateTime;
            updatesAccount.add(acc);
        }
 
        // Update the Account records
        if (!updatesAccount.isEmpty()) 
        {
			update new List<Account>(updatesAccount);
        }
    } 

    global void finish(Database.BatchableContext BC) 
    {
		// Préparer et envoyer l'email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'helachboura@petitforestier.fr'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Process Completed: InitVerifiedAccountsBatch => Initier les Accounts pour pouvoir les declencher a nouveau via le BATCH RDD');
         
        // Construire le corps de l'email
        String emailBody = 'The batch InitVerifiedAccountsBatch has finished:\n\n';
        
        mail.setPlainTextBody(emailBody); 
        
        // Envoyer l'email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
    }
}