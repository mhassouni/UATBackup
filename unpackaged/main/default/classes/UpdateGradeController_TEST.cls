/**
 * Test Class pour UpdateGrade
 */
@isTest


private class UpdateGradeController_TEST {

    static testMethod void TestTheMethod() {

       
        Test.startTest();
       
        Account Account1 = Utils_TestMethods.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient);
        Account1.Statut__c = Label.CPT_Statut_Draft;
        Account1.ModeCreation__c = Label.CPT_ModeCreation_ImportEnMasse;
        Account1.PaysRegionPF__c='DO1B';
        Account1.AgencePF__c = '001 - VILLEPINTE';
        Account1.ListeNoire__c = true;
       
   
        
        insert new list<Account>{Account1};
        
        ApexPages.StandardController controller = new ApexPages.StandardController(Account1);
        UpdateGradeController r = new UpdateGradeController(controller);
        r.method();
        
     
      
        
			Test.stopTest();}
        
    
}