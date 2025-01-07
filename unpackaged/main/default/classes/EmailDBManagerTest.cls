@IsTest
private class EmailDBManagerTest {
    @IsTest
    static void testSendModificationEmails() {
       Test.startTest();
       // Configuration - Création de records Account et SalesAreaData__c pour le test
        // Assurez-vous de remplacer les valeurs de champ et d'ID par des valeurs valides pour votre org Salesforce
        Account testAccount = new Account(Name='Test Account', DB_Statut_Activite__c='Old Value');
        insert testAccount;
        
        // Supposons que TerritorialCommercial__c et ManagerCommercial__c contiennent des adresses e-mail valides
        User Commercial = Utils_TestMethods.createUser('UserTest', 'UserT', system.Label.USR_ProfileId_PFReseau);
        Commercial.Email='hass.medsaid@gmail.com';Insert commercial;
        LegalEntity__c LegalEntity = new LegalEntity__c(Name='Legal entity test');insert LegalEntity;
        SalesArea__c SA = New SalesArea__c(Name='SA test',Businessline__c='Véhicules Frigorifiques',Brand__c='Petit Forestier',Country__c='France',LegalEntity__c=legalEntity.id);Insert SA;
        SalesAreaData__c salesAreaData = new SalesAreaData__c(Account__c=testAccount.Id, TerritorialCommercial__c=Commercial.id, ManagerCommercial__c=Commercial.id,SalesArea__c=SA.Id);
        insert salesAreaData;
        
        // Simuler la mise à jour de l'Account pour déclencher l'envoi d'un e-mail
        
        
        // Simuler la modification des champs surveillés
        testAccount.DB_Statut_Activite__c = 'New Value';
        update testAccount;
        
        // Appeler votre méthode pour envoyer les e-mails
        Map<Id, Account> oldMap = new Map<Id, Account>{testAccount.Id => testAccount.clone()};
        Map<Id, Account> newMap = new Map<Id, Account>{testAccount.Id => testAccount};
        Map<Id, Set<String>> accountToModifiedFields = new Map<Id, Set<String>>{
            testAccount.Id => new Set<String>{'DB_Statut_Activite__c'}
        };
        
        EmailDBManager.sendModificationEmails(accountToModifiedFields, oldMap, newMap);
        
        Test.stopTest();
        
        // Assertions - Salesforce ne permet pas de vérifier directement les e-mails envoyés dans les tests unitaires
        // Vous pouvez ici ajouter des assertions indirectes si votre méthode produit d'autres effets secondaires vérifiables
    }
}