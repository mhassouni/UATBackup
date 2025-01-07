/*
* OPP-RG-004: Lorsque la « date clôture prévue » d’une opportunité est dépassée sans que son statut soit passé à « Opportunité Gagnée » ou « Contrat Signé », une notification par Chatter est envoyée au propriétaire.
* OPP-RG-005: Si la "date clôture appel d'offre" est renseignée, sa valeur est reprise automatiquement dans la "date clôture effective" de l'opportunité.
* N.B. Si la "date clôture appel d'offre" est vidée par la suite, la "date clôture effective" est vidée aussi.
* @Author Ali Naji
* TestClass for AP01MembreEquipeOpportunite
*/
@isTest(SeeAllData=true)

private class AP01MembreEquipeOpportunite_TEST {

    static testMethod void myUnitTestClass() {
        String OPTECHID = Label.OPTECH_ID;
        User UserTest= [SELECT Id FROM User WHERE Id=:OPTECHID];

        System.runAs(UserTest){


        User User1 = Utils_TestMethods.createUser('AP01MEO1', 'AP01MEO1', Label.USR_ProfileId_PFAdministrateurSysteme);
        User1.UserRoleId = '00E20000001ZxwpEAC';
        insert User1;

        User User2 = Utils_TestMethods.createUser('AP01MEO2', 'AP01MEO2', Label.USR_ProfileId_PFAdministrateurSysteme);
        insert User2;
        
        
        Account Account1;
        Opportunity Opportunity1;
		Contact Contact1;
            
            Account1 = Utils_TestMethods.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient	);
            Account1.Statut__c='Validé';
            insert Account1;
            
            Contact1 = Utils_TestMethods.createContact('conName', Account1.Id);
            insert Contact1;         
            Opportunity1 = Utils_TestMethods.createOpportunity('Opportunity1', Label.OPP_StageName_PropositionRemise, Date.newInstance(2020,9,1), Account1);
            Opportunity1.AccountId = Account1.Id;
            insert Opportunity1;
        

        OpportunityTeamMember OpportunityTeamMember1 = Utils_TestMethods.createOpportunityTeamMember(User2.Id, 'Acteur', Opportunity1.Id);
        insert OpportunityTeamMember1;
        
        delete OpportunityTeamMember1;
    }
    }
    static testMethod void myUnitTestTrigger() {
        List<OpportunityTeamMember> members = new List<OpportunityTeamMember>();
        String OPTECHID = Label.OPTECH_ID;
        User UserTest= [SELECT Id FROM User WHERE Id=:OPTECHID];

        System.runAs(UserTest){

        User User1 = Utils_TestMethods.createUser('AP01MEO1', 'AP01MEO1', Label.USR_ProfileId_PFAdministrateurSysteme);
        User1.UserRoleId = '00E20000001ZxwpEAC';
        insert User1;

        User User2 = Utils_TestMethods.createUser('AP01MEO2', 'AP01MEO2', Label.USR_ProfileId_PFAdministrateurSysteme);
        insert User2;
        
      Account Account1;
        Opportunity Opportunity1;
		Contact Contact1;
            
            Account1 = Utils_TestMethods.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient	);
            Account1.Statut__c='Validé';
            insert Account1;
            
            Contact1 = Utils_TestMethods.createContact('conName', Account1.Id);
            insert Contact1;         
            Opportunity1 = Utils_TestMethods.createOpportunity('Opportunity1', Label.OPP_StageName_PropositionRemise, Date.newInstance(2020,9,1), Account1);
            Opportunity1.AccountId = Account1.Id;
            insert Opportunity1;

        OpportunityTeamMember OpportunityTeamMember1 = Utils_TestMethods.createOpportunityTeamMember(User2.Id, 'Acteur', Opportunity1.Id);
        insert OpportunityTeamMember1;
        members.add(OpportunityTeamMember1);
        AP01MembreEquipeOpportunite.SendChatterNotif(members,true);
        delete OpportunityTeamMember1;
        AP01MembreEquipeOpportunite.SendChatterNotif(members,false);
    }
    }
}