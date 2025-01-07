global class RDD_InitOppSAD_Batch implements Database.Batchable<sObject>, Database.Stateful {

    private string filterPaysRegionPF;
    
    
    
    public RDD_InitOppSAD_Batch(string filterPaysRegionPF)
    {
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    
	global Database.queryLocator start(Database.BatchableContext bc)    
    {
        System.Debug('>>>>> RDD_InitOppSAD_Batch  start <<<<<');
        
        
        string Query = 'select Id,AccountId,Name,PaysRegionPF__c,TypeProduits__c from Opportunity where SalesAreaData__c=null and TypeProduits__c<>null and AccountId<>Null' ;
         if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            Query+=' AND PaysRegionPF__c=\''+filterPaysRegionPF+'\' ';
        }
        Query+= ' ORDER BY AccountId';
        
        return Database.getQueryLocator(Query);
    }
    
    
    
     global void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> RDD_InitOppSAD_Batch start execute <<<<');
       list<Opportunity> ListeOPPs = (list<Opportunity>)scope;
       
         	Set<id> AccountIDS = new Set<id>();
        	for(Opportunity O : ListeOPPs) {
            AccountIDS.add(O.AccountId);
        	}
        List<SalesAreaData__c> ListeSAD = [Select Id,Name,Account__c,BusinessLine__c,LegalEntityName__c,SalesArea__c,Pays_SA__c from SalesAreaData__c where Account__c IN :AccountIDS ORDER BY Account__c];
        
 		
         
         
        RDD_SADController.MigrateOppsSAD(ListeOPPs,ListeSAD);
        
        System.Debug('>>>> RDD_InitOppSAD_Batch End execute <<<<');
    }
    
    
     global void finish(Database.BatchableContext bc){
        System.Debug('>>>> RDD_InitOppSAD_Batch Start finish <<<<');
                
       
    }
}