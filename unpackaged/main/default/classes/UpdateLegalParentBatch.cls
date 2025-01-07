/**
 * @author HMS
 * Calcul Parent legal sur tous les comptes  
 * GFC-GFC-2219
 * Code coverage: 100%
 * */
global class UpdateLegalParentBatch implements Database.Batchable<sObject>,Database.stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Sélection de tous les comptes nécessaires pour le traitement
        String query = 'SELECT Id, DB_DUNS_Number__c, DB_DUNS_DU__c, DB_DUNS_GU__c, Compte_Parent_legal__c, RecordTypeId ' +
                       'FROM Account ' +
                       'WHERE (RecordTypeId = :recordtypeCLIENT OR RecordTypeId = :recordtypePROSPECT) AND DB_DUNS_Number__c<>null AND DB_DUNS_DU__c<>null ORDER BY DB_DUNS_DU__c DESC';
        
		/*String query = 'SELECT Id, DB_DUNS_Number__c, DB_DUNS_DU__c, DB_DUNS_GU__c, Compte_Parent_legal__c, RecordTypeId,Last_Flow_Update__c ' +
                       'FROM Account ' +
                       'WHERE (RecordTypeId = :recordtypeCLIENT OR RecordTypeId = :recordtypePROSPECT) AND DB_DUNS_Number__c= \'504979704\' AND DB_DUNS_DU__c<>null ORDER BY DB_DUNS_DU__c DESC';
        */
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        // Maps pour trouver rapidement les comptes par DUNS Number
        Map<String, Account> dunsToAccountMap = new Map<String, Account>();
        for (Account acc : scope) {
            dunsToAccountMap.put(acc.DB_DUNS_Number__c, acc);
            //dunsToAccountMap.put(acc.Id, acc);
        }
        
        // Listes pour les mises à jour
        List<Account> updates = new List<Account>();
        
        for (Account acc : scope) {
            // Comptes qui ne sont ni DU ni GU
            
            if (acc.DB_DUNS_DU__c != acc.DB_DUNS_Number__c && acc.DB_DUNS_GU__c != acc.DB_DUNS_Number__c ) {
                
                Account duAccount = dunsToAccountMap.get(acc.DB_DUNS_DU__c);
                //Account duAccount = dunsToAccountMap.get(acc.Id);
                //DateTime currentDateTime = System.now();
        		//String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
                if (duAccount != null && duAccount.id != acc.id) {
                    acc.Compte_Parent_legal__c = duAccount.Id;
                    //acc.Last_Flow_Update__c = formattedDateTime;
                    //acc.Last_Flow_Update__c = duAccount.Id;
	
                    updates.add(acc);
                }
            }
            // Comptes DU
            else if (acc.DB_DUNS_DU__c == acc.DB_DUNS_Number__c && acc.DB_DUNS_GU__c != acc.DB_DUNS_Number__c) {
                Account guAccount = dunsToAccountMap.get(acc.DB_DUNS_GU__c);
                //Account guAccount = dunsToAccountMap.get(acc.Id);
                //DateTime currentDateTime = System.now();
        		//String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
                if (guAccount != null  && guAccount.id != acc.id) {
                    acc.Compte_Parent_legal__c = guAccount.Id;
                    //acc.Last_Flow_Update__c = formattedDateTime;
                    
                    updates.add(acc);
                }
            }
        }
        
        // Mise à jour des comptes
        if (!updates.isEmpty()) {
            update updates;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
          // Préparer et envoyer l'email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'mhassouni@petitforestier.fr'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Process Completed: UpdateLegalParentBatch');
        
        // Construire le corps de l'email
        String emailBody = 'The batch has finished:\n\n';
        
        
        mail.setPlainTextBody(emailBody);
        
        // Envoyer l'email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}