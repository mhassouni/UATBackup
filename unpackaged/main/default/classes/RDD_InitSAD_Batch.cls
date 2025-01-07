global class RDD_InitSAD_Batch implements Database.Batchable<sObject>, Database.Stateful {

    private string filterPaysRegionPF;
    
    
    
    public RDD_InitSAD_Batch(string filterPaysRegionPF)
    {
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    
	global Database.queryLocator start(Database.BatchableContext bc)    
    {
        System.Debug('>>>>> initSAD_BATCH start <<<<<');
        string Query = 'select Id,Name,Pays__c,OwnerId,PaysRegionPF__c,CurrencyIsoCode from Account where Count_NB_SAD__c=0 and (RecordtypeId=\'0123X00000041YvQAI\' OR RecordtypeId=\'0123G000002UKyQQAW\') ' ;
         if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            Query+='AND PaysRegionPF__c=\''+filterPaysRegionPF+'\' ';
        }
        Query+= ' ORDER BY Id';
        return Database.getQueryLocator(Query);
    }
    
    
    
     global void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> initSAD_BATCH start execute <<<<');
        
         List<SalesArea__c> ListSA=[SELECT id,Name,Country__c,BusinessLine__c,LegalEntity__c,LegalEntity__r.Name from SalesArea__c];
        
         list<Account> listAccounts=(list<Account>)scope;
        RDD_SADController.InitiateSADCreation(listAccounts,ListSA);
        
        System.Debug('>>>> initSAD_BATCH End execute <<<<');
    }
    
    
     global void finish(Database.BatchableContext bc){
        System.Debug('>>>> initSAD_BATCH Start finish <<<<');
                
        
    }
}