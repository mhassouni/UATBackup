/**
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AP01RoleDeContact_TEST {

    static testMethod void TestDeletePrevention() {

		Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        insert MyBypass;
        
        Account account = Utils_TestMethods.createAccount( 'account', null, null, Label.CPT_RecordTypeId_CompteClient);
        account.Statut__c = Label.CPT_Statut_Valide;
        insert(account);
               
        Contact Contact1 = Utils_TestMethods.createContact('Contact1',account.Id);
        insert Contact1;
        
        Opportunity opp = Utils_TestMethods.createOpportunity('opp1',Label.OPP_StageName_OpportuniteCreee,Date.today(),account);
        opp.AccountId = account.Id;  
        opp.Amount = 30;
        opp.TypeProduits__c = 'Containers';
        opp.RecordTypeId = Label.OPP_RecordType_Vehicule_DRAFT;
        opp.AgencePF__c = '000 - SIEGE';
        opp.PaysRegionPF__c = 'PFPF';
        insert opp;
        
        RoleContact__c rc1 = Utils_TestMethods.createRoleContact(Contact1.Id, opp.Id, account.Id);
        insert rc1;
        
        Opportunity oppEnfant = Utils_TestMethods.createOpportunity('opp1',Label.OPP_RecordType_Vehicule_DRAFT,Date.today()+2,account);
        oppEnfant.AccountId = account.Id;  
        oppEnfant.Amount = 90;
        oppEnfant.TypeProduits__c = 'Containers';
        oppEnfant.RecordTypeId = Label.OPP_RecordType_Vehicule_DRAFT;
        oppEnfant.AgencePF__c = '000 - SIEGE';
        oppEnfant.PaysRegionPF__c = 'PFPF';
        oppEnfant.OpportuniteParent__c = opp.id;
        oppEnfant.Quantite__c = 1;
        oppEnfant.LoyerMensuel__c = 10;
        oppEnfant.Probability = 10;
        oppEnfant.DureeContrat__c = 1;
        insert oppEnfant;
        
        oppEnfant.StageName = Label.OPP_StageName_OpportuniteQualifiee;
        update oppEnfant;
		
        try{
        	delete rc1;
        }
        catch(Exception e){
            System.assertEquals(e.getMessage().contains(Label.OPP_ErrorMessage_CantDeleteRole), true);
        }
    }
}