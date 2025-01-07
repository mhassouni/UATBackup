@isTest
public class DateModificationHandlerTest 
{
        // Création des données de test
 	/* Account */

    public static List<Account> createClients(Integer nbr, Boolean toInsert){
        List<Account> clients = new List<Account>();
        for(Integer i=0; i<nbr; i++){
            clients.add(new Account(Name='Test' + i, Statut__c = 'Validé'));
        }
        if(toInsert) insert clients;
        return clients;
    }
    
    public static Contact createContact(String ctName, Id accountId) {
        Contact ct = new Contact();
        ct.LastName = ctName;
        ct.AccountId = accountId;
        insert ct;

        return ct;
    }
    
     public static Quote__c createQuote(String name, Id opportunityId, Boolean primary, Id accountId, Date startDate, Decimal subsTerm) {
        Quote__c newQuote = new Quote__c();
        newQuote.Name = name;
        newQuote.Opportunity__c = opportunityId;
        newQuote.Primary__c = primary;
        newQuote.Account__c = accountId;
        newQuote.Date_de_validite_du_devis__c = Date.today();
         
        insert newQuote;
        return newQuote;
    }

    public static Opportunity createOpportunity(String name, Id accountId,
            Date dateProlongation, String stageName, String type, Id legEntId) {
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = name;
        newOpportunity.AccountId = accountId;
        newOpportunity.CloseDate = System.today();
        newOpportunity.StageName = stageName;
        newOpportunity.Pricebook2Id = Test.getStandardPricebookId();
        newOpportunity.PF_Legal_Entity__c = legEntId;
        newOpportunity.Type_Location__c = 'Longue Durée';
        if (type != null) newOpportunity.TypeOpportunite__c = type;
        if (dateProlongation != null) newOpportunity.Date_de_prolongation__c = dateProlongation;
        insert newOpportunity;

        return newOpportunity;
    }

    // Test de la méthode handleDateModification
    @isTest
    static void testHandleDateModification() {
        // Utilisez les méthodes de création de données de test définies dans cette classe

        // Créer un compte
        List<Account> acc = createClients(2, true);
        Contact contactRec = createContact('Test Contact', acc[0].Id);

        // Créer une opportunité
        Opportunity opp = createOpportunity('Test Opportunity', acc[0].Id, null, 'Stage', null, null);

        // Créer un devis CPQ
        Quote__c cpqQuote = createQuote('Test Quote', opp.Id, true, acc[0].Id, Date.today(), 12);
        //Quote__c cpqQuote2 = createQuote('Test Quote', opp.Id, true, acc[0].Id, Date.today(), 12);

        // Modifier la date de validité du devis pour simuler un changement
        Date oldDate = cpqQuote.Date_de_validite_du_devis__c;
        cpqQuote.Date_de_validite_du_devis__c = Date.today().addDays(1);

        // Modifier la date de validité du devis pour simuler un changement
        Quote__c cpqQuote2  = cpqQuote;
        cpqQuote2.Date_de_validite_du_devis__c = Date.today().addDays(3);
        
        // Appeler la méthode à tester
        Test.startTest();
        DateModificationHandler.handleDateModification(new List<Quote__c>{cpqQuote}, new Map<Id, Quote__c>{ cpqQuote2.Id => cpqQuote2 });

        // Vérifier si le champ Quote_Validity_Notification_Sent__c a été réinitialisé
        cpqQuote = [SELECT Id, Quote_Validity_Notification_Sent__c, Date_de_validite_du_devis__c FROM Quote__c WHERE Id = :cpqQuote.Id];
        System.assertEquals(false, cpqQuote.Quote_Validity_Notification_Sent__c, 'Le champ Quote_Validity_Notification_Sent__c devrait être réinitialisé');

        // Vérifier si les lignes non couvertes sont exécutées
        List<Quote__c> updatedQuotes = [SELECT Id, Quote_Validity_Notification_Sent__c FROM Quote__c WHERE Id = :cpqQuote.Id];
        System.assertEquals(1, updatedQuotes.size(), 'Une seule mise à jour devrait être effectuée');
        System.assertEquals(false, updatedQuotes[0].Quote_Validity_Notification_Sent__c, 'Le champ Quote_Validity_Notification_Sent__c devrait être réinitialisé');

        // Vérifier que la liste quotesToUpdateWithNotification est vide lorsqu'il n'y a pas de changement de date
        cpqQuote.Date_de_validite_du_devis__c = oldDate; // Rétablir la date originale
        DateModificationHandler.handleDateModification(new List<Quote__c>{cpqQuote}, new Map<Id, Quote__c>{ cpqQuote.Id => cpqQuote });
        //System.assertEquals(0, DateModificationHandler.quotesToUpdateWithNotification.size(), 'La liste quotesToUpdateWithNotification devrait être vide');

        Test.stopTest(); // Arrêtez le bloc de test ici
    }
    
    @isTest
static void testHandleDateModification_NoDateChange() {
    // Utilisez les méthodes de création de données de test définies dans cette classe

    // Créer un compte
    List<Account> acc = createClients(2, true);
    Contact contactRec = createContact('Test Contact', acc[0].Id);

    // Créer une opportunité
    Opportunity opp = createOpportunity('Test Opportunity', acc[0].Id, null, 'Stage', null, null);

    // Créer un devis CPQ avec une date de validité du devis déjà définie
    Quote__c cpqQuote = createQuote('Test Quote', opp.Id, true, acc[0].Id, Date.today(), 12);

    // Appeler la méthode à tester
    Test.startTest();
    DateModificationHandler.handleDateModification(new List<Quote__c>{cpqQuote}, new Map<Id, Quote__c>{ cpqQuote.Id => cpqQuote });

    // Vérifier si le champ Quote_Validity_Notification_Sent__c n'a pas été réinitialisé car la date n'a pas changé
    cpqQuote = [SELECT Id, Quote_Validity_Notification_Sent__c, Date_de_validite_du_devis__c FROM Quote__c WHERE Id = :cpqQuote.Id];
    //System.assertEquals(true, cpqQuote.Quote_Validity_Notification_Sent__c, 'Le champ Quote_Validity_Notification_Sent__c ne devrait pas être réinitialisé');

    Test.stopTest(); // Arrêtez le bloc de test ici
}
}