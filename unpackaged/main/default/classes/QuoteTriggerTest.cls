@isTest
public class QuoteTriggerTest {
    
    // Méthodes de création de données de test
    public static List<Account> createClients(Integer nbr, Boolean toInsert){
        List<Account> clients = new List<Account>();
        for(Integer i = 0; i < nbr; i++){
            clients.add(new Account(Name = 'Test' + i, Statut__c = 'Validé'));
        }
        if(toInsert) insert clients;
        return clients;
    }
    
    public static Contact createContact(String ctName, Id accountId) {
        Contact ct = new Contact(LastName = ctName, AccountId = accountId);
        insert ct;
        return ct;
    }
    
    public static Quote__c createQuote(String name, Id opportunityId, Boolean primary, Id accountId, Date startDate, Decimal subsTerm) {
        Quote__c newQuote = new Quote__c(
            Name = name,
            Opportunity__c = opportunityId,
            Primary__c = primary,
            Account__c = accountId,
            Date_de_validite_du_devis__c = Date.today()
        );
        insert newQuote;
        return newQuote;
    }

    public static Opportunity createOpportunity(String name, Id accountId, Date dateProlongation, String stageName, String type, Id legEntId) {
        Opportunity newOpportunity = new Opportunity(
            Name = name,
            AccountId = accountId,
            CloseDate = System.today(),
            StageName = stageName,
            Pricebook2Id = Test.getStandardPricebookId(),
            PF_Legal_Entity__c = legEntId,
            Type_Location__c = 'Longue Durée'
        );
        if (type != null) newOpportunity.TypeOpportunite__c = type;
        if (dateProlongation != null) newOpportunity.Date_de_prolongation__c = dateProlongation;
        insert newOpportunity;
        return newOpportunity;
    }
    
    // Test de la méthode handleDateModification
    @isTest
    static void testHandleDateModification() {
        // Créez vos données de test
        List<Account> acc = createClients(2, true);
        Contact contactRec = createContact('Test Contact', acc[0].Id);
        Opportunity opp = createOpportunity('Test Opportunity', acc[0].Id, null, 'Stage', null, null);

        // Créez vos devis avec des dates de validité différentes
        Quote__c quote1 = createQuote('Test Quote 1', opp.Id, true, acc[0].Id, Date.today(), 12);
        Quote__c quote2 = createQuote('Test Quote 2', opp.Id, true, acc[0].Id, Date.today().addDays(1), 12);
        // Effectuez une mise à jour des devis pour déclencher le trigger
        Test.startTest();
        quote2.Date_de_validite_du_devis__c = Date.today().addDays(6);

        update quote2;
        Test.stopTest();

        // Vérifiez que le champ "Quote_Validity_Notification_Sent__c" est réinitialisé à false pour les devis dont la date de validité a changé
        List<Quote__c> updatedQuotes = [SELECT Id, Quote_Validity_Notification_Sent__c FROM Quote__c WHERE Id IN :new Set<Id>{quote1.Id, quote2.Id}];
        for (Quote__c updatedQuote : updatedQuotes) {
            System.assertEquals(false, updatedQuote.Quote_Validity_Notification_Sent__c);
        }
    }
}