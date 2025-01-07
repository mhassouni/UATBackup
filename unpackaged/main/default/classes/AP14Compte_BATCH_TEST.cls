/**
 * Classe de test pour AP14Compte_BATCH
 */

@isTest
public class AP14Compte_BATCH_TEST {

    public static testMethod void launchBatchTest() {
        Bypass__c myBypass=Utils_TestMethods.createBypass(UserInfo.getUserId());
        myBypass.BypassValidationRules__c = true;
        myBypass.BypassTriggers__c = 'AP09Compte';
        
        User userOpTech=[select Name from User where Name=:Label.USR_OPTECH][0];
        Bypass__c opTechBypass=Utils_TestMethods.createBypass(userOpTech.Id);
        opTechBypass.BypassValidationRules__c = true;
        opTechBypass.BypassTriggers__c = 'AP09Compte';
        
        insert new list<Bypass__c>{myBypass, opTechBypass};
        
        //set up custom settings
        TypeIdentifiantNational__c tin1 = new TypeIdentifiantNational__c(Name = '011',
                                                                        Code__c = 'SIREN',
                                                                        CodePays__c = 'FR',
                                                                        Libelle_fr__c = 'SIREN-FRA');
        insert tin1;
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_000',
                                                               EndPoint__c = 'https://api-test.petitforestier.fr/api/services/PFCustomersRepository/Account',
                                                               Methode__c = 'POST',
                                                               UserName__c = 'mdm_sfdc',
                                                               MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                               ContentType__c = 'application/xml',
                                                               ApplicationName__c = 'SFCD',
                                                               Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
        CodesPays__c cp1 = new CodesPays__c(Name = '053',
                                           Code_Pays__c = 'FRA',
                                           Code_Pays2__c = 'FR',
                                           Libelle_fr__c = 'France');
        insert cp1;
        CodeAgence__c ca1 = new CodeAgence__c(Name = '001',
                                           Numero_Agence__c = '001',
                                           Libelle_fr__c = '001 - VILLEPINTE');
        insert ca1;
        
        System.runAs(userOpTech){
            Account accIdNat = new Account(Name='AccountTest', RecordTypeId=Label.CPT_RecordTypeId_CompteClient,
                                       PaysRegionPF__c = 'RPF1', AgencePF__c = '001 - VILLEPINTE',
                                       ModeCreation__c=Label.CPT_ModeCreation_ImportEnMasse,
                                       Statut__c = Label.CPT_Statut_Bloque,
                                       IdentifiantNational__c = '343134763',
                                       TypeIdentifiantNational__c = 'SIREN-FRA',
                                       Ligne1Exploitation__c = '42 avenue de Friedland',
                                       VilleExploitation__c = 'PARIS',
                                       CodePostalExploitation__c = '75008',
                                       PaysExploitation__c = 'France');
            Account accIdEH = new Account(Name='AccountTest2', RecordTypeId=Label.CPT_RecordTypeId_CompteClient,
                                       PaysRegionPF__c = 'RPF1', AgencePF__c = '001 - VILLEPINTE',
                                       Statut__c = Label.CPT_Statut_Bloque,
                                       ModeCreation__c=Label.CPT_ModeCreation_ImportEnMasse,
                                       IDEulerHermes__c = '343134763',
                                       TypeIdentifiantNational__c = 'SIREN-FRA',
                                       Ligne1Exploitation__c = '42 avenue de Friedland',
                                       VilleExploitation__c = 'PARIS',
                                       CodePostalExploitation__c = '75008',
                                       PaysExploitation__c = 'France');
            insert new list<Account>{accIdNat, accIdEH};
            
            VFC20_AccountBatches controller=new VFC20_AccountBatches();
            controller.act();
            controller.accIdEH=accIdEH;
            controller.accIdNat=accIdNat;
            controller.denombrerIdEH();
            controller.denombrerIdNat();
            
            Test.startTest();
            /*AP14Compte_BATCH batchIdEH = new AP14Compte_BATCH('IDEulerHermes__c', accIdEH.PaysRegionPF__c, accIdEH.AgencePF__c);
            ID batchprocessid_IdEH = Database.executeBatch(batchIdEH);
            
            AP14Compte_BATCH batchIdNat = new AP14Compte_BATCH('IdentifiantNational__c', accIdNat.PaysRegionPF__c, accIdNat.AgencePF__c);
            ID batchprocessid_IdNat = Database.executeBatch(batchIdNat);*/
            
            controller.executeBatchIdEHNotNull();
            controller.executeBatchIdNatNotNull();
            Test.stopTest();
        }
    }
}