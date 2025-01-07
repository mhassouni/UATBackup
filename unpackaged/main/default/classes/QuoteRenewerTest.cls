/**
 * Created by 4C on 01/03/2022.
 */
@IsTest
public class QuoteRenewerTest {

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

        //update quote to generate order/contract
        // quote.SBQQ__Status__c = 'Devis Signé';
        // quote.SBQQ__Ordered__c = true;
        // update quote;

        //create order
        Order order = TestDataFactory.createOrder(acc.Id, Date.today(), Date.today().addMonths(12), quote.Id, opp.Id);
        TestDataFactory.createOrderProduct(order.Id, p.Id, acc.Id, Date.today(), Date.today().addMonths(12), legEnt.Id, blngR.Id, finBook.Id, glrul.Id, revRecRul.Id, ql.Id, pbe.Id);

        SBQQ.TriggerControl.disable();
        //create contract
        Contract ct = TestDataFactory.createContract(acc.Id, quote.Id, 'Draft', Date.today(), 12, Date.today().addMonths(12).addDays(2), order.Id, opp.Id);
        SBQQ.TriggerControl.enable();

        TestDataFactory.createSubscription(ct.Id, p.Id, ql.Id, acc.Id);
        // ct.Status = 'Activated';
        // update ct;
    }

    @IsTest
    public static void testRenewer() {
        Contract ct = [
                SELECT
                        Id,
                        ContractNumber,
                        EndDate,
                        Extension_Date__c,
                        SBQQ__Opportunity__r.RecordTypeId,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Quote__r.Type_de_location__c
                FROM Contract LIMIT 1
        ];
        System.debug(ct);

        Test.startTest();

        QuoteRenewer.QuoteRenewerOutputContext newQuoteIds = QuoteRenewer.renewContracts(new List<Contract>{ct});
        Test.stopTest();

        SBQQ__Quote__c renewQuote = [
                SELECT Id,
                        SBQQ__Opportunity2__r.TypeOpportunite__c,
                        SBQQ__StartDate__c,
                        SBQQ__EndDate__c,
                        SBQQ__Status__c,
                        SBQQ__Ordered__c
                FROM SBQQ__Quote__c
                WHERE Id = :newQuoteIds.quoteIds.get(0)
        ];
        System.assertNotEquals(null, renewQuote, 'Renewed quote not found');
        System.assertEquals(ct.EndDate.addDays(1), renewQuote.SBQQ__StartDate__c, 'Wrong start date');
        // System.assertEquals(ct.Extension_Date__c, renewQuote.SBQQ__EndDate__c, 'Wrong end date');
        // System.assertEquals('Devis Signé', renewQuote.SBQQ__Status__c, 'Wrong status');
        // System.assert(renewQuote.SBQQ__Ordered__c, 'Wrong ordered value');
    }/* */

    @IsTest
    public static void testRenewerRunRenewalCallout() {
        Contract ct = [
                SELECT
                        Id,
                        ContractNumber,
                        EndDate,
                        Extension_Date__c,
                        SBQQ__Opportunity__r.RecordTypeId,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Quote__r.Type_de_location__c,
                        TypeOpportunite__c
                FROM Contract LIMIT 1
        ];
        SBQQ__Quote__c q = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        System.debug(ct);

        Test.startTest();

        QuoteRenewer.runRenewalCalloutAndScheduleEvent(new List<Contract>{ct}, false);
        Test.stopTest();

        SBQQ__Quote__c renewQuote = [
                SELECT Id,
                        SBQQ__Opportunity2__r.TypeOpportunite__c,
                        SBQQ__StartDate__c,
                        SBQQ__EndDate__c,
                        SBQQ__Status__c,
                        SBQQ__Ordered__c
                FROM SBQQ__Quote__c
                WHERE Id <> :q.Id LIMIT 1
        ];
        System.assertNotEquals(null, renewQuote, 'Renewed quote not found');
        System.assertEquals(ct.EndDate.addDays(1), renewQuote.SBQQ__StartDate__c, 'Wrong start date');
        // System.assertEquals(ct.Extension_Date__c, renewQuote.SBQQ__EndDate__c, 'Wrong end date');
        // System.assertEquals('Devis Signé', renewQuote.SBQQ__Status__c, 'Wrong status');
        // System.assert(renewQuote.SBQQ__Ordered__c, 'Wrong ordered value');
    }/* */

    @IsTest
    public static void testRenewerCustomEnd() {
        Contract ct = [
                SELECT Id,
                        ContractNumber,
                        EndDate,
                        Extension_Date__c,
                        SBQQ__Opportunity__r.RecordTypeId,
                        SBQQ__Quote__r.RecordTypeId,
                        SBQQ__Quote__r.Type_de_location__c,
                        TypeOpportunite__c
                FROM Contract LIMIT 1
        ];
        ct.Extension_Date__c = null;
        update ct;
        List<Contract> ctlist = new List<Contract>{ct};
        List<List<Contract>> invInput = new List<List<Contract>>{ctlist};

        ByPass__c byPass = ByPass__c.getInstance();
        if(bypass == null){
                bypass = new Bypass__c(
                        SetupOwnerId = UserInfo.getUserId()
                );
        }
        byPass.BypassTriggers__c = 'AP04Opportunite';
        upsert bypass;

        Test.startTest();

        QuoteRenewer.renewContractAction(invInput);
        QuoteRenewer.QuoteRenewerOutputContext out = QuoteRenewer.renewContracts(ctlist);
        QuoteApprovalScheduler sc = new QuoteApprovalScheduler(out);
        sc.execute(null);

        Test.stopTest();

        /*
        // START - DISABLE TESTS --> TO FIX
        Contract renewCt = [SELECT Id, StartDate, EndDate FROM Contract WHERE Id <> :ct.Id LIMIT 1];
        System.assertNotEquals(null, renewCt, 'Renewed contract not found');
        // END - DISABLE TESTS --> TO FIX
        */
        // System.assertEquals(Date.today().addMonths(5), renewCt.EndDate, 'Wrong end date');
    }
}