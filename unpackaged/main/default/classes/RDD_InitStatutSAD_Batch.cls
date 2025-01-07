global class RDD_InitStatutSAD_Batch implements Database.Batchable<sObject>, Database.Stateful {

    private string filterPaysRegionPF;
    
    
    
    public RDD_InitStatutSAD_Batch(string filterPaysRegionPF)
    {
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    
	global Database.queryLocator start(Database.BatchableContext bc)    
    {
        System.Debug('>>>>> initSADStatut_BATCH start <<<<<');
        string Query = 'select Id,Name,PFRegion__c,(Select id from Opportunities__r where StageName=\'6 - Contrat signé\'),(select id from Contrats__r) from SalesAreaData__c ' ;
         if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            Query+='where PFRegion__c=\''+filterPaysRegionPF+'\' ';
        }
        Query+= ' ORDER BY Id';
        
        return Database.getQueryLocator(Query);
    }
    
    
    
     global void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> initSADStatut_BATCH start execute <<<<');
        
         
        
         list<SalesAreaData__c> listSAD=(list<SalesAreaData__c>)scope;
        RDD_SADController.InitiateStatutSAD(listSAD);
        
        System.Debug('>>>> initSADStatut_BATCH End execute <<<<');
    }
    
    
     global void finish(Database.BatchableContext bc){
        System.Debug('>>>> initSADStatut_BATCH Start finish <<<<');
                
       
    }
}