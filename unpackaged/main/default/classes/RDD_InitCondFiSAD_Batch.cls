public class RDD_InitCondFiSAD_Batch implements Database.Batchable<sObject>, Database.Stateful {



    private string filterPaysRegionPF;
    
    
    
    public RDD_InitCondFiSAD_Batch(string filterPaysRegionPF)
    {
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    
	public  Database.queryLocator start(Database.BatchableContext bc)    
    {
        System.Debug('>>>>> RDD_InitCondFiSAD_Batch  start <<<<<');
        
        
        string Query = 'select Id,SalesAreaData__c,Account__c,Account__r.PaysRegionPF__c from Dero_Fi__c where SalesAreaData__c=null and Account__r.PaysRegionPF__c<>null' ;
         if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            Query+=' AND Account__r.PaysRegionPF__c=\''+filterPaysRegionPF+'\' ';
        }
                Query+= ' ORDER BY Account__r.PaysRegionPF__c';

        
        return Database.getQueryLocator(Query);
    }
    
    
    
     public void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> RDD_InitCondFiSAD_Batch start execute <<<<');
       list<Dero_Fi__c> ListecondFi = (list<Dero_Fi__c>)scope;
       
         	Set<id> AccountIDS = new Set<id>();
        	for(Dero_Fi__c C : ListecondFi) {
            AccountIDS.add(C.Account__c);
        	}
         System.debug('AccountIDS size : '+AccountIDS.Size());
        List<SalesAreaData__c> ListeSAD = [Select Id,Name,Account__c,BusinessLine__c,LegalEntityName__c,SalesArea__c,Pays_SA__c from SalesAreaData__c where Account__c IN :AccountIDS ORDER BY Account__c];
        
 		
        RDD_SADController.MigrateCondFiSAD(ListecondFi,ListeSAD);
        
        System.Debug('>>>> RDD_InitCondFiSAD_Batch End execute <<<<');
    }
    
    
     public void finish(Database.BatchableContext bc){
        System.Debug('>>>> RDD_InitCondFiSAD_Batch Start finish <<<<');
                
       
    }
}