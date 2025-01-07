/*
* Automatically sends a web service callout for Accounts with a callout counter superior to 0
* 
* @Author Kévin Melliand
* @TestClass AP09Compte_BATCH_TEST
* @CodeCoverage 0%
*/

global class AP09Compte_BATCH implements Database.Batchable<sObject>, Database.Stateful, 
Database.AllowsCallouts{

    global UtilsBatch__c u;
    
    global dateTime batchStartDateTime;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        System.Debug('>>>> AP09Compte_BATCH Start start <<<<');
                
        String query = 'SELECT Id, Name, RecordTypeId, OwnerId, PaysRegionPF__c, TECHIdentifiantNational__c,'
                              + 'Ligne1__c, Ligne2__c, Ligne3__c, Ligne4__c, Pays__c, CodePostal__c, Ville__c,'
                              +'TECHTypeIdentifiantNational__c, Ligne1Exploitation__c, Ligne2Exploitation__c,'
                              +'DateCotationPF__c, CotationPF__c, DateAgrementEH__c, AgrementSFAC__c, ListeNoire__c,'
                              +'Ligne3Exploitation__c, Ligne4Exploitation__c, VilleExploitation__c, Parent.TECHIdentifiantNational__c, Parent.TECHTypeIdentifiantNational__c, '
                              +'CodePostalExploitation__c, PaysExploitation__c, LastModifiedById, ParentId, '
                              +'Statut__c, AgencePF__c, TECHCompteurAppelsWS__c, TECHWS__c, CategorieCompte__c, IrreductibleVIP__c, RecopierAdressePrincipale__c, TECHIdNatCPExp__c '
                              +'FROM Account WHERE ((RecordTypeID = \''
                                                    + Label.CPT_RecordTypeId_CompteProspectClient 
                                                    + '\' OR RecordTypeID = \''
                                                   // + Label.CPT_RecordTypeId_Administration15 
                                                    + '\' OR RecordTypeID = \''
                                                   // + Label.CPT_RecordTypeId_MultiNiveau 
                                                    + '\' OR RecordTypeID = \''
                                                   // + Label.CPT_RecordTypeId_GrandCompte 
                                                    + '\' OR RecordTypeID = \''
                                                    + Label.CPT_RecordTypeId_CompteClient 
                                                    + '\') AND Statut__c = \''+ Label.CPT_Statut_Erreur_EH +'\' AND TECHCompteurAppelsWS__c > 0)';
                               
        u=[select id, TECHTodayAP09Compte__c from UtilsBatch__c where Name = 'ERG 1'];
        
        if(u.TECHTodayAP09Compte__c != system.today())
        {
            query += ' OR ( (Statut__c = \'' + Label.CPT_Statut_Bloque+'\' OR Statut__c = \''+ Label.CPT_Statut_Erreur_EH + '\') AND (RecordTypeId = \''                                                                                                                                                                                             + '\' OR RecordTypeId = \'' 
            //+ Label.CPT_RecordTypeId_Administration15
            + '\' OR RecordTypeId = \'' 
           // + Label.CPT_RecordTypeId_MultiNiveau
            + '\' OR RecordTypeId = \'' 
           // + Label.CPT_RecordTypeId_GrandCompte
            + '\' OR RecordTypeId = \'' 
            + Label.CPT_RecordTypeId_CompteClient
            + '\'))';
            u.TECHTodayAP09Compte__c = system.today();
            update u;
        }
                               
        System.Debug(query);
        System.Debug('>>>> AP09Compte_BATCH End start <<<<');
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, list<sObject> scope){
        System.Debug('>>>> AP09Compte_BATCH Start execute <<<<');
        
        list<Account> listAccounts=(list<Account>)scope;
        AP09Compte.processCreation2(listAccounts,false,false);
        
    }
    
    global void finish(Database.BatchableContext bc){
        System.Debug('>>>> AP09Compte_BATCH Start finish <<<<');
        
       // System.scheduleBatch(new AP09Compte_BATCH(), 'Web Service Batch', 5);
        
        System.Debug('>>>> AP09Compte_BATCH End finish <<<<');
    }
}