@isTest
private class TestBatchCountAssets {
    static testMethod void testme(){
        //Create account S
        Account A = New Account();
        A.RecordTypeId = Label.ACC_RecordTypeId_CompteSite;
        A.Name = 'Account test';
		insert A;
        //create Agence
        Account ag = Utils_TestMethods.CreateAgence('Agence Test');
        insert ag;
        //Create Parc
        Asset Parc = Utils_TestMethods.CreateAsset(A.id,Label.Parc_RecordTypeId);
        Parc.Agence__c = ag.id;
        Parc.Agence_Localisation__c = ag.id;
        insert Parc;
        
        
        Test.startTest();
        BatchCountAssets B = new BatchCountAssets();
        //Id jobid = Database.executeBatch(B,5);
        Database.executeBatch(B);
        Test.stopTest();
        Account ACC = [Select id,Nombre_de_vehicules__c from account where id=:A.id];
        system.assertEquals(1,ACC.Nombre_de_vehicules__c);
    }
}