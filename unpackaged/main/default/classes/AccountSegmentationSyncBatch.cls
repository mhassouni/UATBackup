global class AccountSegmentationSyncBatch implements Database.Batchable<sObject>, Database.Stateful 
{
    private Integer retryCount; // Variable de classe statique pour compter les tentatives
    private String filterPaysRegionPF;

    // Constructeur prenant le nombre de tentatives en paramètre
    global AccountSegmentationSyncBatch(Integer retryCount, String filterPaysRegionPF) 
    {
        this.retryCount = retryCount;
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator([
            SELECT Id, BusinessLine__c, CodeNACE__c, Notation__c, RecordTypeId, NotationPotentielExtension__c	
            FROM Segmentation__c
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Segmentation__c> scope) 
   	{
        
         Map<String, Account> accountMap = new Map<String, Account>();
        Set<String> codeNACESet = new Set<String>();
        for (Segmentation__c segmentationRec : scope) 
        {
            codeNACESet.add(segmentationRec.CodeNACE__c);
        }
        
        List<Account> accList = new List<Account>();
        if(filterPaysRegionPF!=null && filterPaysRegionPF!='')
        {
            accList = [SELECT ID,Segmentation__c, Verified__c, DB_Code_Activite_NACE__c	, CodeNACE__c, Last_Batch_Update__c FROM Account where Segmentation__c = '' AND DB_Code_Activite_NACE__c IN :codeNACESet AND PaysRegionPF__c = :filterPaysRegionPF AND Verified__c = false  ORDER BY LastModifiedDate ASC limit 150];  
        }
        else   
        {
            accList = [SELECT ID,Segmentation__c, Verified__c, DB_Code_Activite_NACE__c	, CodeNACE__c, Last_Batch_Update__c FROM Account where Segmentation__c = '' AND DB_Code_Activite_NACE__c IN :codeNACESet AND Verified__c = false ORDER BY LastModifiedDate ASC limit 150];  
        } 
           
        // Construire une carte de CodeNACE__c pour chaque enregistrement SalesAreaData__c
        for(Account acc : accList)  
        { 
            accountMap.put(acc.Id, acc);
        } 

        List<Account> accToUpdate = new List<Account>();
        
        for(String accRecordId  : accountMap.keySet()) 
        {
            // Récupérer l'enregistrement SalesAreaData__c correspondant à l'ID
    		Account accRecord = accountMap.get(accRecordId);
            for(Segmentation__c segmentationRec : scope) 
            {
                if(accRecord.DB_Code_Activite_NACE__c == segmentationRec.CodeNACE__c && accRecord.DB_Code_Activite_NACE__c != '')
                {
                    accRecord.Segmentation__c = segmentationRec.Id;
                    DateTime currentDateTime = System.now();
                    String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
                    accRecord.Last_Batch_Update__c = formattedDateTime;
                    accRecord.Verified__c = true;
                    accToUpdate.add(accRecord); 
                }
            }
        }
        
        // Mettre à jour les enregistrements SalesAreaData__c
        update accToUpdate;        
    }

    global void finish(Database.BatchableContext BC) 
    {
        // Vérifier s'il existe encore des enregistrements SalesAreaData__c avec Segmentation__c vide
        Integer accCount = [SELECT COUNT() FROM Account WHERE Segmentation__c = '' AND PaysRegionPF__c = :filterPaysRegionPF];
        if (accCount > 0 && retryCount < 50) 
        {
            // Augmenter le compteur de tentative
            retryCount++;
            // Relancer le batch avec une nouvelle plage de données
        	Database.executeBatch(new AccountSegmentationSyncBatch(retryCount, filterPaysRegionPF), 50);
        }
        else 
        { 
            InitVerifiedAccountsBatch batchInitVerifiedAccountsBatch =new InitVerifiedAccountsBatch(); 
 			Database.executeBatch(batchInitVerifiedAccountsBatch, 100);
            // Préparer et envoyer l'email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'helachboura@petitforestier.fr'}; 
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Process Completed: AccountSegmentationSyncBatch => Note Potentiel Extension');
            
            // Construire le corps de l'email
            String emailBody = 'The batch AccountSegmentationSyncBatch has finished:\n\n';
    
            mail.setPlainTextBody(emailBody);
            
            // Envoyer l'email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
    }
}