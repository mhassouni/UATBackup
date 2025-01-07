public class RDD_InitContractsSAD_Batch implements Database.Batchable<sObject>, Database.Stateful {



    private string filterPaysRegionPF;
    
    
    
    public RDD_InitContractsSAD_Batch(string filterPaysRegionPF)
    {
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    
	public  Database.queryLocator start(Database.BatchableContext bc)    
    {
        System.Debug('>>>>> RDD_InitContractsSAD_Batch  start <<<<<');
        
        
        string Query = 'select Id,AccountId, Account.PaysRegionPF__c,Actif__c,Actif__r.Name,recordtypeId from Contract where SalesAreaData__c=null and AccountId<>null ' ;
         if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            Query+=' AND Account.PaysRegionPF__c=\''+filterPaysRegionPF+'\' ';
        }
                Query+= ' ORDER BY AccountId';

        
        return Database.getQueryLocator(Query);
    }
    
    
    
     public void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> RDD_InitContractsSAD_Batch start execute <<<<');
       list<Contract> ListeCts = (list<Contract>)scope;
       
         	Set<id> AccountIDS = new Set<id>();
        	for(Contract C : ListeCts) {
            AccountIDS.add(C.AccountId);
        	}
         System.debug('AccountIDS size : '+AccountIDS.Size());
        List<SalesAreaData__c> ListeSAD = [Select Id,Name,Account__c,BusinessLine__c,LegalEntityName__c,SalesArea__c,Pays_SA__c from SalesAreaData__c where Account__c IN :AccountIDS ORDER BY Account__c];
        
 		
        RDD_SADController.MigrateContratsSAD(ListeCts,ListeSAD);
        
        System.Debug('>>>> RDD_InitContractsSAD_Batch End execute <<<<');
    }
    
    
     public void finish(Database.BatchableContext bc){
        System.Debug('>>>> RDD_InitContractsSAD_Batch Start finish <<<<');
                
       
    }
}