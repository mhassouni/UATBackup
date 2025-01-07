@isTest
private class TestCaseBeforeUpdate 
{
    Static testMethod void CaseClassTest()
    {
        Case Req = new Case();
        Account ACC = Utils_TestMethods.createAccount('accName', 'accCodeNAF', null, Label.CPT_RecordTypeId_CompteClient);
        Asset Parc = Utils_TestMethods.CreateAsset(ACC.Id,Label.Parc_RecordTypeId);
        Account Agence = Utils_TestMethods.CreateAgence('001 - VILLEPINTE');
        Req.AccountId=ACC.Id;
        Req.AssetId = Parc.id;
        Req.Agence_Intervenante__c=Agence.id;
        //Req.Agence_compte__c='001 - VILLEPINTE';
        Req.Description_incident_client__c=null;
		insert Req;
        Req.requete_en_attente__c=true;
        update Req;
        //EN attente
        CaseClass.CaseEnAttente(Req.Id);
        CaseClass.CaseNotificationSent(Req.Id);
    }
    Static testMethod void CaseClassTrigger1Test()
    {
        Case Req = new Case();
        Account ACC = Utils_TestMethods.createAccount('accName', 'accCodeNAF', null, Label.CPT_RecordTypeId_CompteClient);
        Asset Parc = Utils_TestMethods.CreateAsset(ACC.Id,Label.Parc_RecordTypeId);
        Account Agence = Utils_TestMethods.CreateAgence('001 - VILLEPINTE');
        
        Req.AccountId=ACC.Id;
        Req.AssetId = Parc.id;
        Req.Agence_Intervenante__c=Agence.id;
        Req.Agence_compte__c='001 - VILLEPINTE';
        Req.status = Label.Case_Statut_Nouvelle;
		insert Req;
        //Case En attente 
        Req.requete_en_attente__c=true;
        update Req;
        //Case change de statut
       	Req.Status=Label.Case_Statut_EnCours;
        update Req;
       
    }
    Static testMethod void CaseClassTrigger2Test()
    {
        //Data
        Case Req = new Case();
        Account ACC = Utils_TestMethods.createAccount('accName', 'accCodeNAF', null, Label.CPT_RecordTypeId_CompteClient);
        Asset Parc = Utils_TestMethods.CreateAsset(ACC.Id,Label.Parc_RecordTypeId);
        Account Agence = Utils_TestMethods.CreateAgence('001 - VILLEPINTE');
        Account Agence2 = Utils_TestMethods.CreateAgence('002 - BORDEAUX');
        
        //Affectations
        Req.AccountId=ACC.Id;
        Req.AssetId = Parc.id;
        Req.Agence_Intervenante__c=Agence.id;
        Req.Agence_compte__c='001 - VILLEPINTE';
        Req.status = Label.Case_Statut_Nouvelle;
        Req.Requete_en_attente__c=False;
		insert Req;
       
        //Change Agence
        Req.TECH_Notification_sent__c=true;
       	Req.Agence_Intervenante__c=Agence2.id;
        
        update Req;
    }
    
}