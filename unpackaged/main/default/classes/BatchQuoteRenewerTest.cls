/**
 * Created by 4C on 03/03/2022.
 */

@IsTest
global class BatchQuoteRenewerTest {

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

        //opty & quote creation
        Opportunity opp = TestDataFactory.createOpportunity('opp1', acc.Id, null, Label.OPP_StageName_OpportuniteCreee, null, legEnt.Id);
        SBQQ__Quote__c quote = TestDataFactory.createCPQQuote(opp.Id, true, acc.Id, Date.today(), 12);
        SBQQ__QuoteLineGroup__c qlg = TestDataFactory.createQuotelineGroup(quote.Id, Date.today(), Date.today().addMonths(12));
        SBQQ__QuoteLine__c ql = TestDataFactory.createQuoteLine(quote.Id, p.Id, 1, pbe.Id, qlg.Id);

        //create order
        Order order = TestDataFactory.createOrder(acc.Id, Date.today(), Date.today().addMonths(12), quote.Id, opp.Id);
        TestDataFactory.createOrderProduct(order.Id, p.Id, acc.Id, Date.today(), Date.today().addMonths(12), legEnt.Id, blngR.Id, finBook.Id, glrul.Id, revRecRul.Id, ql.Id, pbe.Id);

        //create contract
        Contract ct = TestDataFactory.createContract(acc.Id, quote.Id, 'Draft', Date.today(), 12, Date.today().addMonths(12).addDays(2), order.Id, opp.Id);
        TestDataFactory.createSubscription(ct.Id, p.Id, ql.Id, acc.Id);
    }

    @IsTest
    public static void testBatch() {
        Test.startTest();

        BatchQuoteRenewerProcessor qr = new BatchQuoteRenewerProcessor(Date.today().addMonths(12));
        Database.executeBatch(qr, 5);

        Test.stopTest();

        Contract ct = [
                SELECT
                        Id,
                        StartDate,
                        EndDate,
                        ContractTerm,
                        Extension_Date__c,
                        SBQQ__Opportunity__r.RecordTypeId,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Quote__c
                FROM Contract LIMIT 1
        ];
        List<SBQQ__Quote__c> renewQuote = [
                SELECT Id,
                        SBQQ__Opportunity2__r.TypeOpportunite__c,
                        SBQQ__StartDate__c,
                        SBQQ__EndDate__c,
                        SBQQ__Status__c,
                        SBQQ__Ordered__c
                FROM SBQQ__Quote__c
                WHERE Id <> :ct.SBQQ__Quote__c
        ];
        System.assertNotEquals(null, renewQuote, 'Renewed quote not found');
        System.assert(!renewQuote.isEmpty(), 'Renewed quote not found');
        System.assertEquals(ct.EndDate.addDays(1), renewQuote.get(0).SBQQ__StartDate__c, 'Wrong start date');
//        System.assertEquals(ct.StartDate.addMonths(ct.ContractTerm), renewQuote.get(0).SBQQ__StartDate__c, 'Wrong start date');
    }

    @IsTest
    public static void testBatchDefault() {
        Test.startTest();

        BatchQuoteRenewerProcessor qr = new BatchQuoteRenewerProcessor();
        Database.executeBatch(qr, 5);

        Test.stopTest();
    }

    @IsTest
    public static void testBatchPreprocessor() {
        Test.startTest();

        BatchQuoteRenewerPreprocessor qr = new BatchQuoteRenewerPreprocessor(Date.today().addMonths(12));
        Database.executeBatch(qr, 5);

        Test.stopTest();

        Contract ct = [
                SELECT
                        Id,
                        EndDate,
                        Extension_Date__c,
                        SBQQ__Opportunity__r.RecordTypeId,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Quote__c,
                        TypeOpportunite__c
                FROM Contract LIMIT 1
        ];

        System.assertEquals('PRG', ct.TypeOpportunite__c, 'Contract opp type not updated');
    }

    @IsTest
    public static void testBatchPreprocessorDefault() {
        Test.startTest();

        BatchQuoteRenewerPreprocessor qr = new BatchQuoteRenewerPreprocessor();
        Database.executeBatch(qr, 5);

        Test.stopTest();
    }

    @IsTest
    public static void testBatchPreprocessorContract() {
        Contract ct = [SELECT Id FROM Contract LIMIT 1];
        Test.startTest();

        BatchQuoteRenewerPreprocessor qr = new BatchQuoteRenewerPreprocessor(ct.Id, 'ABC', UserInfo.getUserId());
        Database.executeBatch(qr, 5);

        Test.stopTest();

        ct = [
                SELECT
                        Id,
                        EndDate,
                        Extension_Date__c,
                        SBQQ__Opportunity__r.RecordTypeId,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Quote__c,
                        TypeOpportunite__c
                FROM Contract LIMIT 1
        ];

        System.assertEquals('PRG', ct.TypeOpportunite__c, 'Contract opp type not updated');
    }

    @IsTest
    private static void testScheduler() {
        String CRON_EXP = '0 0 0 ' + Date.today().addMonths(1).day() + ' ' + Date.today().addMonths(1).month() +' ? ' + Date.today().year();
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new BatchQuoteRenewerScheduler());
        Test.stopTest();

        CronTrigger trig = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(CRON_EXP, trig.CronExpression);
        System.assertEquals(Datetime.newInstance(Date.today().addMonths(1), Time.newInstance(0,0,0,0)), trig.NextFireTime);
    }

    @IsTest
    private static void testTestBatch() {
        Contract ct = [SELECT Id, ContractNumber FROM Contract LIMIT 1];

        Test.startTest();

        List<Contract> insideList = new List<Contract> {ct};
        List<List<Contract>> lst = new List<List<Contract>> {insideList};
        BatchQuoteRenewerTestAction.testBatchQuoteRenewerUnitary(lst);

        Test.stopTest();

        ct = [SELECT Id, TypeOpportunite__c FROM Contract WHERE Id = :ct.Id];

        System.assertEquals('PRG', ct.TypeOpportunite__c);
    }

    @IsTest
    public static void testBatchContract() {
        Contract ct = [SELECT Id FROM Contract LIMIT 1];
        Test.startTest();

        BatchQuoteRenewerProcessor qr = new BatchQuoteRenewerProcessor(ct.Id, 'ABC', UserInfo.getUserId());
        Database.executeBatch(qr, 5);

        Test.stopTest();

        ct = [
                SELECT
                        Id,
                        EndDate,
                        Extension_Date__c,
                        SBQQ__Opportunity__r.RecordTypeId,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Quote__c
                FROM Contract LIMIT 1
        ];
        List<SBQQ__Quote__c> renewQuote = [
                SELECT Id,
                        SBQQ__Opportunity2__r.TypeOpportunite__c,
                        SBQQ__StartDate__c,
                        SBQQ__EndDate__c,
                        SBQQ__Status__c,
                        SBQQ__Ordered__c
                FROM SBQQ__Quote__c
                WHERE Id <> :ct.SBQQ__Quote__c
        ];
        System.assertNotEquals(null, renewQuote, 'Renewed quote not found');
        System.assert(!renewQuote.isEmpty(), 'Renewed quote not found');
        System.assertEquals(ct.EndDate.addDays(1), renewQuote.get(0).SBQQ__StartDate__c, 'Wrong start date');
    }

}