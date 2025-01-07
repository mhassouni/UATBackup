@isTest
private class RCSC_GetCalendrierAstreinte_TEST {
    static testmethod void testcomponent(){
        //Agence
Account AgenceTest = new account();
    AgenceTest.Name = '000 - AgenceTest';
    AgenceTest.Code__c = '000';
    AgenceTest.NomCommercial__c = 'AgenceTest';
    AgenceTest.Libelle__c = 'AgenceTest';
    AgenceTest.Societe_PF__c = 'PFLO';
    AgenceTest.Region__c = 'DIRECTION RESEAU IDF';
    AgenceTest.Territoire__c = 'DRO IDF 1';
    AgenceTest.RecordTypeId = Label.CPT_RecordTypeId_AgencePF;
    insert AgenceTest;
//Calendrier
    Calendrier_Astreinte__c CalendrierAstreinteTEST1 = New Calendrier_Astreinte__c();
    CalendrierAstreinteTEST1.Name = '2019 - S36';
    CalendrierAstreinteTEST1.N_semaine__c = 36;
    CalendrierAstreinteTEST1.Agence_PF__c = AgenceTest.id;
    CalendrierAstreinteTEST1.Date_de_debut__c = system.today();
    CalendrierAstreinteTEST1.Date_de_fin__c = system.today() +7;
    insert CalendrierAstreinteTEST1;
        Test.startTest();
        List<Calendrier_Astreinte__c> Lst = RCSC_GetCalendrierAstreinte.listWeeks(CalendrierAstreinteTEST1.Id);
        
        Test.stopTest();
        system.assertNotEquals(Lst.size(), 1);
    }

}