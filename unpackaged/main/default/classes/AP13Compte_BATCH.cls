/*
* RDD comptes dans le MDM
* @Author Natasha Maalouf
* @TestClass AP09Compte_BATCH_TEST
* @CodeCoverage 100%
*/

global class AP13Compte_BATCH implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

    global Database.QueryLocator start(Database.BatchableContext bc){
        System.Debug('>>>> AP13Compte_BATCH Start start <<<<');
        set<string> setStatuts=new set<string>{Label.CPT_Statut_Draft, Label.CPT_Statut_Bloque, Label.CPT_Statut_Erreur_EH};
        //set<string> setStatuts=new set<string>{Label.CPT_Statut_Valide};
        set<string> setRTs=new set<string>{Label.CPT_RecordTypeId_CompteClient};
        String query = 'SELECT Id, Name, RecordTypeId, OwnerId, PaysRegionPF__c, TECHIdentifiantNational__c, '
                              +'Ligne1__c, Ligne2__c, Ligne3__c, Ligne4__c, Pays__c, CodePostal__c, Ville__c, '
                              +'TECHTypeIdentifiantNational__c, Ligne1Exploitation__c, Ligne2Exploitation__c, '
                              +'Ligne3Exploitation__c, Ligne4Exploitation__c, VilleExploitation__c, '
                              +'DateCotationPF__c, CotationPF__c, DateAgrementEH__c, AgrementSFAC__c, ListeNoire__c,  '
                              +'CodePostalExploitation__c, PaysExploitation__c, LastModifiedById, ParentId, '
                              +'Statut__c, AgencePF__c, CategorieCompte__c, IrreductibleVIP__c, TECHCompteurAppelsWS__c, TECHWS__c, '
                              +'Parent.TECHTypeIdentifiantNational__c, Parent.TECHIdentifiantNational__c , RecopierAdressePrincipale__c, TECHIdNatCPExp__c '
                              +'FROM Account '
                              +'WHERE RecordTypeID IN :setRTs '
                              +'AND Statut__c IN :setStatuts ';
                                       
        System.Debug(query);
        System.Debug('>>>> AP13Compte_BATCH End start <<<<');
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> AP13Compte_BATCH Start execute <<<<');
        
        list<Account> listAccounts=(list<Account>)scope;
        AP09Compte.processCreation2(listAccounts,true,false); //la RDD ne doit pas déclencher une mise à jour des comptes
        
        System.Debug('>>>> AP13Compte_BATCH End execute <<<<');
    }
    
    
    
    global void finish(Database.BatchableContext bc){
        System.Debug('>>>> AP13Compte_BATCH Start finish <<<<');
                
        System.Debug('>>>> AP13Compte_BATCH End finish <<<<');
    }
}