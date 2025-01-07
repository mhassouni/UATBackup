/*
* Déclenchement de l'appel WS sur les comptes repris par OP_TECH (Import en masse) avec un ID Euler Hermes
* @Author Natasha Maalouf
* @TestClass AP14Compte_BATCH_TEST
* @CodeCoverage 100%
*/

global class AP14Compte_BATCH implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

    private string idEHorNat;
    private string filterPaysRegionPF;
    private string filterAgencePF;
    
    public AP14Compte_BATCH(string idEHorNat, string filterPaysRegionPF, string filterAgencePF){
        this.idEHorNat=idEHorNat;
        this.filterPaysRegionPF=filterPaysRegionPF;
        this.filterAgencePF=filterAgencePF;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        System.Debug('>>>> AP14Compte_BATCH Start start <<<<');
                
        String query = 'SELECT Id, Name, RecordTypeId, OwnerId, PaysRegionPF__c, TECHIdentifiantNational__c,'
                              +'TECHTypeIdentifiantNational__c, Ligne1Exploitation__c, Ligne2Exploitation__c,'
                              +'DateCotationPF__c, CotationPF__c, DateAgrementEH__c, AgrementSFAC__c, ListeNoire__c,'
                              +'Ligne3Exploitation__c, Ligne4Exploitation__c, VilleExploitation__c, Parent.TECHIdentifiantNational__c, Parent.TECHTypeIdentifiantNational__c, '
                              +'CodePostalExploitation__c, PaysExploitation__c, LastModifiedById, ParentId, '
                              +'Statut__c, AgencePF__c, TECHCompteurAppelsWS__c, TECHWS__c, CategorieCompte__c, IrreductibleVIP__c, RecopierAdressePrincipale__c, TECHIdNatCPExp__c, '
                              +'CreatedBy.Name, ModeCreation__c, IDEulerHermes__c '
                              +'FROM Account '
                              //+'WHERE CreatedBy.Name=\''+Label.USR_OPTECH+'\' '
                              //+'WHERE ModeCreation__c=\''+Label.CPT_ModeCreation_ImportEnMasse+'\' '
                              +'WHERE Statut__c=\''+Label.CPT_Statut_Draft+'\' '
                              +'AND '+idEHorNat+'!=null and '+idEHorNat+'!=\'\' ';
                              
                              
        if(filterPaysRegionPF!=null && filterPaysRegionPF!=''){
            query+='AND PaysRegionPF__c=\''+filterPaysRegionPF+'\' ';
        }
        if(filterAgencePF!=null && filterAgencePF!=''){
            query+='AND AgencePF__c=\''+filterAgencePF+'\' ';
        }
                               
        System.Debug('query: '+query);
        System.Debug('>>>> AP14Compte_BATCH End start <<<<');
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> AP14Compte_BATCH Start execute <<<<');
        
        list<Account> listAccounts=(list<Account>)scope;
        AP09Compte.processCreation2(listAccounts,false,false);
        
        System.Debug('>>>> AP14Compte_BATCH End execute <<<<');
    }
    
    
    
    global void finish(Database.BatchableContext bc){
        System.Debug('>>>> AP14Compte_BATCH Start finish <<<<');
                
        System.Debug('>>>> AP14Compte_BATCH End finish <<<<');
    }
}