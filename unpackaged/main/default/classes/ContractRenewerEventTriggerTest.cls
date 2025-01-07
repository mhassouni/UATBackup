/**
 * Created by 4C on 06/04/2022.
 */

@IsTest
public class ContractRenewerEventTriggerTest {

    @TestSetup
    public static void setupTests() {
        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        MyBypass.BypassWorkflowRules__c = true;
        insert MyBypass;

        Account acc = TestDataFactory.createAccount('Account1', null, null, Label.CPT_RecordTypeId_CompteClient);
        TestDataFactory.createFinancialCond(acc.Id);
        TestDataFactory.createContact('contactTest', acc.Id);

        // billing rules creation
        // blng__BillingRule__c blngR = TestDataFactory.createBillingRule();
        blng__RevenueRecognitionRule__c revRecRul = TestDataFactory.createRevenueRecognitionRule();
        blng__LegalEntity__c legEnt =  TestDataFactory.createLegalEntity();
        blng__FinanceBook__c finBook = TestDataFactory.createFinanceBook(legEnt.Id);
        blng__GLRule__c glrul = TestDataFactory.createGlRule(legEnt.Id);
        blng__RevenueDistributionMethod__c distMet = TestDataFactory.createDistribMethod();
        TestDataFactory.createRevenueRecognitionTreatment(legEnt.Id, finBook.Id, revRecRul.Id, glrul.Id, distMet.Id, 0);

        // tax rule
        blng__TaxRule__c taxRule = TestDataFactory.createTaxRule();
        TestDataFactory.createTaxTreatment(legEnt.Id, taxRule.Id);

        //product creation (with billing rule)
        // Product2 p = TestDataFactory.createProduct('CF10', true, 'CF10', 'tst', blngR.Id, revRecRul.Id, taxRule.Id);
        // PricebookEntry pbe = TestDataFactory.createPricebookEntry(true, Test.getStandardPricebookId(), p.Id, 10.0);

        //opty & quote creation
        Opportunity opp = TestDataFactory.createOpportunity('opp1', acc.Id, null, Label.OPP_StageName_OpportuniteCreee, null, legEnt.Id);
        SBQQ__Quote__c quote = TestDataFactory.createCPQQuote(opp.Id, true, acc.Id, Date.today(), 12);
        // SBQQ__QuoteLineGroup__c qlg = TestDataFactory.createQuotelineGroup(quote.Id, Date.today(), Date.today().addMonths(12));
        // SBQQ__QuoteLine__c ql = TestDataFactory.createQuoteLine(quote.Id, p.Id, 1, pbe.Id, qlg.Id);

        //create order
        Order order = TestDataFactory.createOrder(acc.Id, Date.today(), Date.today().addMonths(12), quote.Id, opp.Id);
        // TestDataFactory.createOrderProduct(order.Id, p.Id, acc.Id, Date.today(), Date.today().addMonths(12), legEnt.Id, blngR.Id, finBook.Id, glrul.Id, revRecRul.Id, ql.Id, pbe.Id);

        SBQQ.TriggerControl.disable();
        //create contract
        Contract ct = TestDataFactory.createContract(acc.Id, quote.Id, 'Draft', Date.today(), 12, Date.today().addMonths(12).addDays(2), order.Id, opp.Id);
        SBQQ.TriggerControl.enable();
        // TestDataFactory.createSubscription(ct.Id, p.Id, ql.Id, acc.Id);
        Opportunity renewOpp = TestDataFactory.createOpportunity('renewOpp', acc.Id, null, Label.OPP_StageName_OpportuniteCreee, null, legEnt.Id);
        SBQQ__Quote__c renewQuote = TestDataFactory.createCPQQuote(renewOpp.Id, false, acc.Id, Date.today().addMonths(12), 12);
    }

    @IsTest
    public static void testEventContractDraft() {
        Opportunity op = [SELECT Id FROM Opportunity WHERE Name = 'renewOpp'];
        SBQQ__Quote__c q = [SELECT Id, Tech_After_Calculate__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c = :op.Id LIMIT 1];
        Contract c = [SELECT Id, Extension_Date__c FROM Contract LIMIT 1];

        q.Tech_After_Calculate__c = true;
        // q.Tech_approval_unlock__c = true;
        update q;

        Test.startTest();

        List<ContractRenewerEvent__e> events = new List<ContractRenewerEvent__e>();
        events.add(new ContractRenewerEvent__e(quoteIds__c = q.Id,
                quoteContractIdsMap__c = q.Id+'#'+c.Id,
                contractsToNotify__c = c.Id + '#' + Userinfo.getUserId()));
        List<Database.SaveResult> pubResults = EventBus.publish(events);

        Test.stopTest();
        q = [SELECT Id, SBQQ__Status__c, SBQQ__StartDate__c, SBQQ__EndDate__c FROM SBQQ__Quote__c WHERE Id = :q.Id];
        //System.assertEquals(c.Extension_Date__c, q.SBQQ__EndDate__c);
    }/* */

    @IsTest
    public static void testEventContractSent() {
        Opportunity op = [SELECT Id FROM Opportunity WHERE Name = 'renewOpp'];
        SBQQ__Quote__c q = [SELECT Id, Tech_After_Calculate__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c = :op.Id LIMIT 1];
        Contract c = [SELECT Id, Extension_Date__c FROM Contract LIMIT 1];

        q.Tech_After_Calculate__c = true;
        q.SBQQ__Status__c = 'Quote Sent';
        // q.Tech_approval_unlock__c = true;

        Test.startTest();
        update q;

        List<ContractRenewerEvent__e> events = new List<ContractRenewerEvent__e>();
        events.add(new ContractRenewerEvent__e(quoteIds__c = q.Id,
                quoteContractIdsMap__c = q.Id+'#'+c.Id,
                contractsToNotify__c = c.Id + '#' + Userinfo.getUserId()));
        List<Database.SaveResult> pubResults = EventBus.publish(events);

        Test.stopTest();
        c = [SELECT Id, Tech_RenewedContract__c, Extension_Date__c FROM Contract WHERE Id = :c.Id];
        System.assertEquals(true, c.Tech_RenewedContract__c);
    }/* */

    @IsTest
    public static void testUncalculated() {
        Opportunity op = [SELECT Id FROM Opportunity WHERE Name = 'renewOpp'];
        SBQQ__Quote__c q = [SELECT Id, Tech_After_Calculate__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c = :op.Id LIMIT 1];
        Contract c = [SELECT Id, Extension_Date__c FROM Contract LIMIT 1];

        Test.startTest();

        List<ContractRenewerEvent__e> events = new List<ContractRenewerEvent__e>();
        events.add(new ContractRenewerEvent__e(quoteIds__c = q.Id,
                quoteContractIdsMap__c = q.Id+'#'+c.Id,
                contractsToNotify__c = c.Id + '#' + Userinfo.getUserId()));
        List<Database.SaveResult> pubResults = EventBus.publish(events);

        Test.stopTest();
        q = [SELECT Id, SBQQ__Status__c, SBQQ__StartDate__c, SBQQ__EndDate__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c = :op.Id LIMIT 1];
        System.assertEquals(null, q.SBQQ__EndDate__c);
    }/* */
}