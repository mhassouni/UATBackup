/**
 * Test Class pour VFE11_CompteReload
 */
@isTest

private class VFE11_CompteReload_TEST {

    static testMethod void TestCompteWarning() {

        
        //User userOpTech = Utils_TestMethods.createUser('OP_TECH', 'OP_TECH', Label.USR_ProfileId_PFAdministrateurSysteme);
        //userOpTech.LanguageLocaleKey='fr';
        //insert userOpTech;
        
        
       //system.runAs(userOpTech)
       
        Test.startTest();
        //Bypass__c MyBypass = Utils_TestMethods.createBypass(userOpTech.Id);
        //MyBypass.BypassValidationRules__c=true;
        //MyBypass.BypassAllTriggers__c=true;
        //MyBypass.BypassTriggers__c='UtilisateurAfterUpdate,AP02Utilisateur';
        //insert MyBypass;
        Account Account1 = Utils_TestMethods.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient);
        Account1.Statut__c = Label.CPT_Statut_Draft;
        Account1.ModeCreation__c = Label.CPT_ModeCreation_ImportEnMasse;
        Account1.PaysRegionPF__c='DO1B';
        Account1.AgencePF__c = '001 - VILLEPINTE';
        Account1.ListeNoire__c = true;
        
        Account Account1_bloque = Utils_TestMethods.createAccount('Account1_bloque', null, null, Label.CPT_RecordTypeId_CompteClient);
        Account1_bloque.PaysRegionPF__c='DO1B';
        Account1_bloque.AgencePF__c = '001 - VILLEPINTE';
        Account1_bloque.Statut__c = Label.CPT_Statut_Bloque;
        
        Account Account1_erreurEH = Utils_TestMethods.createAccount('Account1_erreurEH', null, null, Label.CPT_RecordTypeId_CompteClient);
        Account1_erreurEH.Statut__c = Label.CPT_Statut_Erreur_EH;
         Account1_erreurEH.PaysRegionPF__c='DO1B';
        Account1_erreurEH.AgencePF__c = '001 - VILLEPINTE';
        
        insert new list<Account>{Account1, Account1_bloque, Account1_erreurEH};
        
        ApexPages.StandardController controller = new ApexPages.StandardController(Account1);
        VFE11_CompteReload r = new VFE11_CompteReload(controller);
        r.reload();
        r.validateAccount();
        
        ApexPages.StandardController controller_bloque = new ApexPages.StandardController(Account1_bloque);
        VFE11_CompteReload r_bloque = new VFE11_CompteReload(controller_bloque);
        r_bloque.reload();
        r_bloque.validateAccount();
        
        ApexPages.StandardController controller_erreurEH = new ApexPages.StandardController(Account1_erreurEH);
        VFE11_CompteReload r_erreurEH = new VFE11_CompteReload(controller_erreurEH);
        r_erreurEH.reload();
        r_erreurEH.validateAccount();
        
       
            
            Account Account2 = Utils_TestMethods.createAccount('Account2', null, null, Label.CPT_RecordTypeId_CompteClient);
            Account2.Statut__c = Label.CPT_Statut_Draft;
            Account2.ModeCreation__c = Label.CPT_ModeCreation_ImportEnMasse;
            Account2.PaysRegionPF__c='DO1B';
        	Account2.AgencePF__c = '001 - VILLEPINTE';
            insert Account2;
            
            ApexPages.StandardController controller2 = new ApexPages.StandardController(Account2);
            VFE11_CompteReload r2 = new VFE11_CompteReload(controller2);
            r2.reload();
            r2.validateAccount();
        
        
			Test.stopTest();}
        
    
}