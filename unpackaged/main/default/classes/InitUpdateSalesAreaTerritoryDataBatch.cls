global class InitUpdateSalesAreaTerritoryDataBatch implements Database.Batchable<sObject>, Database.Stateful 
{

    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String Query = 'SELECT Id, Verified__c, Last_Batch_Update__c FROM SalesAreaData__c WHERE Verified__c = true';
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext BC, List<SalesAreaData__c> scope) 
    {
        set<SalesAreaData__c> updatesSad = new set<SalesAreaData__c>();
        for (SalesAreaData__c sad : scope) 
        {
            sad.Verified__c = false;
            DateTime currentDateTime = System.now();
            String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
            //DateTime parsedDateTime = DateTime.valueOf(formattedDateTime);
            //sad.Last_Batch_Update__c = parsedDateTime;
            sad.Last_Batch_Update__c = formattedDateTime;
            updatesSad.add(sad);
        }

        // Update the SalesAreaData__c records
        if (!updatesSad.isEmpty()) 
        {
			update new List<SalesAreaData__c>(updatesSad);
        }
    } 

    global void finish(Database.BatchableContext BC) 
    {
		// Préparer et envoyer l'email
		// kbertal@petitforestier.fr
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'helachboura@petitforestier.fr', 'kbertal@petitforestier.fr'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Process Completed: InitUpdateSalesAreaTerritoryDataBatch => Initier les SAD pour pouvoir les declencher a nouveau via le BATCH RDD');
         
        // Construire le corps de l'email
        String emailBody = 'The batch has finished:\n\n';
        
        mail.setPlainTextBody(emailBody); 
        
        // Envoyer l'email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
    }
}