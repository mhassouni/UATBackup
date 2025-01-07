public class RDD_InitFactureSAD_Batch implements Database.Batchable<sObject>, Database.Stateful {



    private string filterPaysRegionPF;
    
     
    
    public RDD_InitFactureSAD_Batch(string filterPaysRegionPF)
    {
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    
	public  Database.queryLocator start(Database.BatchableContext bc)    
    {
        System.Debug('>>>>> RDD_InitOppSAD_Batch  start <<<<<');
        
        
        string Query = 'select Id,Name,Parc__r.name,compte__c,Compte__r.PaysRegionPF__c,N_Parc__c from Facture_vehicule__c where SalesAreaData__c=null  ' ;
         if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            Query+=' AND Compte__r.PaysRegionPF__c=\''+filterPaysRegionPF+'\' ';
        }
                Query+= ' ORDER BY Compte__r.PaysRegionPF__c';

        
        return Database.getQueryLocator(Query);
    }
    
    
    
     public void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> RDD_InitFactureSAD_Batch start execute <<<<');
       list<Facture_vehicule__c> ListeFacts = (list<Facture_vehicule__c>)scope;
       
         	Set<id> AccountIDS = new Set<id>();
        	for(Facture_vehicule__c O : ListeFacts) {
            AccountIDS.add(O.compte__c);
        	}
        List<SalesAreaData__c> ListeSAD = [Select Id,Name,Account__c,BusinessLine__c,LegalEntityName__c,SalesArea__c,Pays_SA__c from SalesAreaData__c where Account__c IN :AccountIDS ORDER BY Account__c];
        
 		
        RDD_SADController.MigrateFacturesSAD(ListeFacts,ListeSAD);
        
        System.Debug('>>>> RDD_InitFactureSAD_Batch End execute <<<<');
    }
    
    
     public void finish(Database.BatchableContext bc){
        System.Debug('>>>> RDD_InitFactureSAD_Batch Start finish <<<<');
                
       
    }
}