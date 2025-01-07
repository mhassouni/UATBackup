@isTest
private class TestBatchCountContainers {
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
        Asset Parc = Utils_TestMethods.CreateAsset(A.id,Label.Parc_Container_RecordTypeId);
        Parc.Agence__c = ag.id;
        Parc.Agence_Localisation__c = ag.id;
        insert Parc;
        
        
        Test.startTest();
        BatchCountContainers B = new BatchCountContainers();
        //Id jobid = Database.executeBatch(B,5);
        Database.executeBatch(B);
        Test.stopTest();
        Account ACC = [Select id,Nombre_de_Containers__c from account where id=:A.id];
        system.assertEquals(1,ACC.Nombre_de_Containers__c);
    }
}