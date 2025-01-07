global class SADSegmentationSyncBatch implements Database.Batchable<sObject>, Database.Stateful 
{
    private Integer retryCount; 
    private String filterPaysRegionPF;

    // Constructeur prenant le nombre de tentatives en paramètre
    global SADSegmentationSyncBatch(Integer retryCount, String filterPaysRegionPF) 
    {
        this.retryCount = retryCount;
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
     
	global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator([
            SELECT Id, BusinessLine__c, CodeNACE__c, Notation__c, RecordTypeId
            FROM Segmentation__c
        ]);
    } 
    
    global void execute(Database.BatchableContext BC, List<Segmentation__c> scope) 
   	{
         Map<String, SalesAreaData__c> segmentationMap = new Map<String, SalesAreaData__c>();
         if(filterPaysRegionPF!=null && filterPaysRegionPF!='')
         {
            // Construire une carte de CodeNACE__c pour chaque enregistrement SalesAreaData__c
            for(SalesAreaData__c sad : [SELECT Id, Segmentation__c, BusinessLine__c, Code_NACE__c, Last_Batch_Update__c, Verified__c FROM SalesAreaData__c where   Verified__c = false AND Code_NACE__c !='' AND PFRegion__c = :filterPaysRegionPF   Order By Last_Batch_Update__c ASC limit 10000]) 
            {
                segmentationMap.put(sad.Id, sad);
            } 
         }
        else
        {
            for(SalesAreaData__c sad : [SELECT Id, Segmentation__c, BusinessLine__c, Code_NACE__c, Last_Batch_Update__c, Verified__c FROM SalesAreaData__c where   Verified__c = false AND Code_NACE__c !=''   Order By Last_Batch_Update__c ASC limit 10000]) 
            {
                segmentationMap.put(sad.Id, sad);
            } 
        }
        Set<SalesAreaData__c> sadToUpdate = new Set<SalesAreaData__c>();
        //create a map that will hold the values of the list 
        map<id,SalesAreaData__c> accmap = new map<id,SalesAreaData__c>();
        
        for(String sadRecordId  : segmentationMap.keySet()) 
        {
            // Récupérer l'enregistrement SalesAreaData__c correspondant à l'ID
    		SalesAreaData__c sadRecord = segmentationMap.get(sadRecordId);
            for(Segmentation__c seg : scope) 
            {
                if(sadRecord.Code_NACE__c == seg.CodeNACE__c && sadRecord.BusinessLine__c == seg.BusinessLine__c)
                {
                    sadRecord.Segmentation__c = seg.Id;
                    sadRecord.Verified__c = true;
                }
                DateTime currentDateTime = System.now();
                String formattedDateTime = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
                sadRecord.Last_Batch_Update__c = formattedDateTime;
                if (!sadToUpdate.contains(sadRecord)) 
                {
                    sadToUpdate.add(sadRecord);
                }
            }
        }
        
        // Mettre à jour les enregistrements SalesAreaData__c
        if(!sadToUpdate.isempty())
        {
        	accmap.putall((new List<SalesAreaData__c>( sadToUpdate )));
        }

        if(accmap.size()>0)
        {
        	update accmap.values();
        }
    }

    global void finish(Database.BatchableContext BC) 
    {
        // Vérifier s'il existe encore des enregistrements SalesAreaData__c avec Segmentation__c vide
        Integer sadCount = [SELECT COUNT() FROM SalesAreaData__c WHERE  Verified__c = false AND Code_NACE__c !='' ];
        if (sadCount > 0 && retryCount < 50 ) 
        { 
            // Augmenter le compteur de tentative
            retryCount++;
            // Relancer le batch avec une nouvelle plage de données
        	Database.executeBatch(new SADSegmentationSyncBatch(retryCount, filterPaysRegionPF), 50);
        	//Database.executeBatch(new SADSegmentationSyncBatch(), 50);
        }
        else 
        {
            InitUpdateSalesAreaTerritoryDataBatch batchInitUpdateSalesAreaTerritoryData =new InitUpdateSalesAreaTerritoryDataBatch(); 
 			Database.executeBatch(batchInitUpdateSalesAreaTerritoryData, 100);
            // Préparer et envoyer l'email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'helachboura@petitforestier.fr'}; 
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Process Completed: SADSegmentationSyncBatch => Note globale du secteur');
            
            // Construire le corps de l'email
            String emailBody = 'The batch SADSegmentationSyncBatch has finished:\n\n';
    
            mail.setPlainTextBody(emailBody);
            
            // Envoyer l'email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}