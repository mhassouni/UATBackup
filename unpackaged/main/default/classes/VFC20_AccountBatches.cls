public class VFC20_AccountBatches {
    
    public Account accIdEH{get;set;}
    public Account accIdNat{get;set;}
    public string numberOfAccounts_IdEH{get;set;}
    public string numberOfAccounts_IdNat{get;set;}
    
    public void act(){
        accIdEH=new account();
        accIdNat=new account();
        numberOfAccounts_IdEH='Nombre de comptes';
        numberOfAccounts_IdNat='Nombre de comptes';
    }
    
    public void denombrerIdEH(){
        string queryIdEH='select Id '
                         +'from Account '
                         +'where IDEulerHermes__c!=null and IDEulerHermes__c!=\'\' ' 
            			 
                        
                         +'and Statut__c=\''+Label.CPT_Statut_Draft+'\' ';
                        
        if(accIdEH.PaysRegionPF__c!=null && accIdEH.PaysRegionPF__c!=''){
            queryIdEH+='and PaysRegionPF__c=\''+accIdEH.PaysRegionPF__c+'\' ';
        }
        if(accIdEH.AgencePF__c!=null && accIdEH.AgencePF__c!=''){
            queryIdEH+='and AgencePF__c=\''+accIdEH.AgencePF__c+'\' ';
        }
        
        integer numAccsIdEH=Database.query(queryIdEH).size();
        numberOfAccounts_IdEH=string.valueOf(numAccsIdEH)+' comptes';
    }
    public void denombrerIdNat(){
        string queryIdNat='select Id '
                         +'from Account WHERE Statut__c=\''+Label.CPT_Statut_Draft+'\' '
                         +'and IdentifiantNational__c!=null and IdentifiantNational__c!=\'\' ';
        if(accIdNat.PaysRegionPF__c!=null && accIdNat.PaysRegionPF__c!=''){
            queryIdNat+='and PaysRegionPF__c=\''+accIdNat.PaysRegionPF__c+'\' ';
        }
        if(accIdNat.AgencePF__c!=null && accIdNat.AgencePF__c!=''){
            queryIdNat+='and AgencePF__c=\''+accIdNat.AgencePF__c+'\' ';
        }
        integer numAccsIdNat=Database.query(queryIdNat).size();
        numberOfAccounts_IdNat=string.valueOf(numAccsIdNat)+' comptes';
        
    }
    
    public void executeBatchIdEHNotNull(){
        AP14Compte_BATCH batch_IdEHNotNull=new AP14Compte_BATCH('IDEulerHermes__c', accIdEH.PaysRegionPF__c, accIdEH.AgencePF__c); 
        Database.executeBatch(batch_IdEHNotNull, 1);
    }
    
    public void executeBatchIdNatNotNull(){
        AP14Compte_BATCH batch_IdNatNotNull=new AP14Compte_BATCH('IdentifiantNational__c', accIdNat.PaysRegionPF__c, accIdNat.AgencePF__c); 
        Database.executeBatch(batch_IdNatNotNull, 1);
    }
}