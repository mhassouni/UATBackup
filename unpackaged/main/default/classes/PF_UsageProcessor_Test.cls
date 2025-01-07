/**
 * Created by 4C on 17/03/2022.
 */

@IsTest
public with sharing class PF_UsageProcessor_Test {

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
        blng__BillingRule__c blngR = TestDataFactory.createBillingRule();
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
        Product2 p = TestDataFactory.createProduct('CF10', true, 'CF10', 'tst', blngR.Id, revRecRul.Id, taxRule.Id);
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(true, Test.getStandardPricebookId(), p.Id, 10.0);

//        Account acc = Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteClient);
        Opportunity opp = TestDataFactory.createOpportunity('opp1', acc.Id, null, Label.OPP_StageName_OpportuniteCreee, null, legEnt.Id);
        SBQQ__Quote__c quote = TestDataFactory.createCPQQuote(opp.Id, true, acc.Id, Date.today(), 12);
        SBQQ__QuoteLineGroup__c qlg = TestDataFactory.createQuotelineGroup(quote.Id, Date.today(), Date.today().addMonths(12));
        SBQQ__QuoteLine__c ql = TestDataFactory.createQuoteLine(quote.Id, p.Id, 1, pbe.Id, qlg.Id);
        Order order = TestDataFactory.createOrder(acc.Id, Date.today(), Date.today().addMonths(12), quote.Id, opp.Id);
        OrderItem orderPrd = TestDataFactory.createOrderProduct(order.Id, p.Id, acc.Id, Date.today(), Date.today().addMonths(12), legEnt.Id, blngR.Id, finBook.Id, glrul.Id, revRecRul.Id, ql.Id, pbe.Id);
        Reservation__c reserv = TestDataFactory.createTransportToClientReservation(order.Id, orderPrd.Id, System.today());

        //create contract
        Date startDate = Date.today().addMonths(-4);
        Date startOfMonth = Date.newInstance(Date.today().year(), Date.today().month(), 1);

        SBQQ.TriggerControl.disable();
        Contract ct = TestDataFactory.createContract(acc.Id, quote.Id, 'Draft', startDate, 4, startDate.addMonths(4).addDays(1), order.Id, opp.Id);
        SBQQ.TriggerControl.enable();
        TestDataFactory.createSubscription(ct.Id, p.Id, ql.Id, acc.Id);

        blng__UsageSummary__c us = new blng__UsageSummary__c();
        us.blng__Account__c = acc.Id;
        us.blng__Order__c = order.Id;
        us.blng__OrderProduct__c = orderPrd.Id;
        us.blng__SummaryStartDate__c = startOfMonth;
        us.blng__SummaryEndDate__c = Date.today();
        us.blng__AppliedUnitPrice__c = 10.0;
        us.blng__MatchingId__c = 'test';
        insert us;
    }


    @IsTest
    public static void testUsageSummaryLDShortMonth() {
        Order o = [SELECT Id FROM Order LIMIT 1];
        o.Status = Label.orderStatus_processed;
        update o;

        //o = [SELECT Id, status FROM Order where Id =: o.Id];

        //System.debug('o = ' + o);

        Test.startTest();

        PF_UsageProcessor pfus = new PF_UsageProcessor(o.Id);
        Database.executeBatch(pfus,10);

        Test.stopTest();
        List<blng__Usage__c> usages = [
                SELECT
                        Id,
                        blng__StartDateTime__c,
                        blng__EndDateTime__c,
                        blng__PreratedAmount__c,
                        blng__PreratedQuantity__c,
                        blng__Quantity__c
                FROM blng__Usage__c
        ];

        System.assert(!usages.isEmpty(), 'No usages found');
    }

    @IsTest
    public static void testUsageSummaryLDFullMonth() {
        Order o = [SELECT Id FROM Order LIMIT 1];
        o.Status = Label.orderStatus_processed;
        update o;

        Test.startTest();

        PF_UsageProcessor pfus = new PF_UsageProcessor(o.Id);
        Database.executeBatch(pfus,10);

        Test.stopTest();
        List<blng__Usage__c> usages = [
                SELECT
                        Id,
                        blng__StartDateTime__c,
                        blng__EndDateTime__c,
                        blng__PreratedAmount__c,
                        blng__PreratedQuantity__c,
                        blng__Quantity__c
                FROM blng__Usage__c
        ];

        System.assert(!usages.isEmpty(), 'No usages found');
    }

    @IsTest
    public static void testUsageSummaryLDMidMonth() {
//        Date endOfMonth = Date.newInstance(Date.today().addMonths(1).year(), Date.today().addMonths(1).month(), 1).addDays(-1);
        Order o = [SELECT Id, Status FROM Order LIMIT 1];
        o.Status = Label.orderStatus_processed;
        update o;

        Contract ct = [SELECT Id, InterruptionDate__c, Status FROM Contract LIMIT 1];
        ct.TechTerminated__c = true;
        ct.InterruptionDate__c = Date.today();
//        ct.InterruptionDate__c = endMiddleMonth;
        ct.Status = Label.contractStatus_Resilie;
        update ct;

        Test.startTest();

        PF_UsageProcessor pfus = new PF_UsageProcessor(o.Id);
        Database.executeBatch(pfus,10);

        Test.stopTest();
        List<blng__Usage__c> usages = [
                SELECT
                        Id,
                        blng__StartDateTime__c,
                        blng__EndDateTime__c,
                        blng__PreratedAmount__c,
                        blng__PreratedQuantity__c,
                        blng__Quantity__c
                FROM blng__Usage__c
        ];

        System.assert(!usages.isEmpty(), 'No usages found');
    }

    @IsTest
    public static void testInvocableProcessor() {
        Order o = [SELECT Id, Status FROM Order LIMIT 1];
        o.Status = Label.orderStatus_processed;
        update o;

        Test.startTest();

        List<Order> orders = new List<Order>{o};
        InvocablePF_UsageProcessor.UsageProcessorUniqueOrder(new List<List<Order>>{orders});

        Test.stopTest();

        List<blng__Usage__c> usages = [
                SELECT
                        Id,
                        blng__StartDateTime__c,
                        blng__EndDateTime__c,
                        blng__PreratedAmount__c,
                        blng__PreratedQuantity__c,
                        blng__Quantity__c
                FROM blng__Usage__c
        ];

        System.assert(!usages.isEmpty(), 'No usages found');
    }
}