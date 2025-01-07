@isTest(SeeAllData=true)
public class RHX_TEST_WorkOrder {
	static testMethod void RHX_Testmethod() {

        User testUser1 = Utils_TestMethods.createUser('AP07Opp1','AP07Opp1',Label.USR_ProfileId_PFAdministrateurSysteme);
        insert testUser1;

        System.RunAs(testUser1){
        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        MyBypass.BypassTriggers__c = 'AP09Compte,AP03Opportunite,AP01Opportunite';
            MyBypass.BypassAllTriggers__c=true;
            insert MyBypass;

        Account account = Utils_TestMethods.createAccount( 'account', null, null, Label.CPT_RecordTypeId_CompteClient);
        account.statut__c = Label.CPT_TypeIdentifiantNational_Creation;
            //account.Statut__c = Label.CPT_Statut_Valide;
        insert account;

        Account agence1 = new Account();
        agence1.Name = 'Agence Test 1';
        agence1.RecordTypeId = Label.ACC_RT_AgencePF;
        //agence1.Statut__c = Label.CPT_Statut_Valide;
        agence1.ListeNoire__c = false;
        insert agence1;

        Asset asset1 = new Asset();        
        asset1.Name = 'Asset Name 1';  
        asset1.SerialNumber = '123456789';
        asset1.AccountId = account.Id;     
        asset1.Agence__c = agence1.Id;
        asset1.Position__c = 'ALD';
        insert asset1;


        Case C = new Case(Status='En_cours',Agence_Intervenante__c=agence1.Id, AccountId=account.Id, AssetId=asset1.Id );
        insert C;

        WorkOrder wo = new WorkOrder(AccountId=account.Id, caseId=C.Id, WorkTypeId=Label.OT_TypeDeTravail_ID_Depannage);
        insert wo;


        List<sObject> sourceList = [SELECT Id  FROM WorkOrder where LocationId=NULL  LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new WorkOrder(AccountId=account.Id, caseId=C.Id, RecordTypeId=Label.OT_RecordTypeID_Depannage,WorkTypeId=Label.OT_TypeDeTravail_ID_Depannage)
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );  
    
        }
    }
}