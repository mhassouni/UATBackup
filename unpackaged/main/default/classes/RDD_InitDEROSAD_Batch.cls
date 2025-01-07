public class RDD_InitDEROSAD_Batch implements Database.Batchable<sObject>, Database.Stateful {



    private string filterPaysRegionPF;
    
    
    
    public RDD_InitDEROSAD_Batch(string filterPaysRegionPF)
    {
        this.filterPaysRegionPF = filterPaysRegionPF;
    }
    
	public  Database.queryLocator start(Database.BatchableContext bc)    
    {
        System.Debug('>>>>> RDD_InitDEROSAD_Batch  start <<<<<');
        
        
        string Query = 'Select Id,SalesAreaData__c,Opportunite__c,Opportunite__r.SalesAreaData__c,Opportunite__r.PaysRegionPF__c from Derogation__c where SalesAreaData__c=null and Opportunite__c<>null and Opportunite__r.SalesAreaData__c <>null' ;
         if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            Query+=' AND Opportunite__r.PaysRegionPF__c=\''+filterPaysRegionPF+'\' ';
        }
               
        
        return Database.getQueryLocator(Query);
    }
    
    
    
     public void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> RDD_InitDEROSAD_Batch start execute <<<<');
       list<Derogation__c> ListeDero = (list<Derogation__c>)scope;
       

        RDD_SADController.MigrateDeroSAD(ListeDero);
        
        System.Debug('>>>> RDD_InitDEROSAD_Batch End execute <<<<');
    }
    
    
     public void finish(Database.BatchableContext bc){
        System.Debug('>>>> RDD_InitDEROSAD_Batch Start finish <<<<');
                
       
    }
}