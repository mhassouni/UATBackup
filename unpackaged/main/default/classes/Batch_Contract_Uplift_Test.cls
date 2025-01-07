/**
 * @description       :
 * @author            : Gil Gourevitch
 * @group             :
 * @last modified on  : 15/09/2022
 * @last modified by  : Gil Gourevitch
 * Modifications Log
 * Ver   Date         Author           Modification
 * 1.0   15/09/2022   Gil Gourevitch   Initial Version
**/
@IsTest
public class Batch_Contract_Uplift_Test {
    @TestSetup
    public static void setup(){
        System.debug('start testsetup');
        Date dd = Date.today();

        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassTriggers__c  = 'AP04Opportunite';
        insert MyBypass;

        //ACCOUNT
        Account ACC = Utils_TestMethods.createAccount('accName', 'accCodeNAF', null, Label.CPT_RecordTypeId_CompteClient);
        ACC.SBQQ__RenewalModel__c  = 'Contract Based';
        ACC.Statut__c = 'Validé';
        ACC.SBQQ__PreserveBundle__c = true;
        insert ACC;

        //CONTACT
        Contact Cont = Utils_TestMethods.createContact('conName', ACC.Id);
        insert Cont;

        Id pricebookId = Test.getStandardPricebookId();

        //OPPORTUNITY
        Opportunity  OPP = Utils_TestMethods.createOpportunity('oppName', '2 - Opportunité qualifiée',dd , ACC);
        OPP.Pricebook2Id = pricebookId;
        OPP.Type_Location__c = 'Courte Durée';
        insert OPP;

        //PRODUCT
        Product2 PRD1 = new Product2(Name = 'Product test 1' , IsActive = true , SBQQ__SubscriptionPricing__c = 'Fixed Price');
        insert PRD1;

        Product2 PRD2 = new Product2(Name = 'Product test 2' , IsActive = true , SBQQ__SubscriptionPricing__c = 'Fixed Price');
        insert PRD2;

        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = pricebookId;
        pricebookEntry.Product2Id = PRD1.Id;
        pricebookEntry.IsActive = true;
        pricebookEntry.UnitPrice = 100;
        insert pricebookEntry;

        pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = pricebookId;
        pricebookEntry.Product2Id = PRD2.Id;
        pricebookEntry.IsActive = true;
        pricebookEntry.UnitPrice = 100;
        insert pricebookEntry;

        //QUOTE
        SBQQ__Quote__c Q = new SBQQ__Quote__c();
        Q.Quote_Type__c = 'Standard Quote';
        Q.SBQQ__Primary__c = true;
        Q.SBQQ__Account__c = ACC.Id;
        Q.SBQQ__Opportunity2__c  = OPP.Id;
        Q.SBQQ__StartDate__c = dd;
        insert Q;

        //QLI
        List<SBQQ__QuoteLine__c> qlis = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c QLI1 = new SBQQ__QuoteLine__c();
        QLI1.SBQQ__Product__c = PRD1.Id;
        QLI1.SBQQ__Quote__c = Q.Id;
        QLI1.SBQQ__Quantity__c = 12;
        QLI1.SBQQ__StartDate__c  = Date.newInstance(2021  , 10 , 10);
        QLI1.SBQQ__EndDate__c  = Date.newInstance(2021  , 11 , 11);
        QLI1.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        QLI1.Uplift_Eligible__c = true;
        qlis.add(QLI1);

        SBQQ__QuoteLine__c QLI2 = new SBQQ__QuoteLine__c();
        QLI2.SBQQ__Product__c = PRD2.Id;
        QLI2.SBQQ__Quote__c = Q.Id;
        QLI2.SBQQ__Quantity__c = 12;
        QLI2.SBQQ__StartDate__c  = Date.newInstance(2021  , 10 , 10);
        QLI2.SBQQ__EndDate__c  = Date.newInstance(2021  , 11 , 11);
        QLI2.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        qlis.add(QLI2);

        insert qlis;
        OPP.SBQQ__Contracted__c  = true;
        update OPP;

        // billing rules creation
        blng__BillingRule__c blngR = TestDataFactory.createBillingRule();
        blng__RevenueRecognitionRule__c revRecRul = TestDataFactory.createRevenueRecognitionRule();
        blng__LegalEntity__c legalEntityMensuelle =  TestDataFactory.createLegalEntity('Mensuelle');
        blng__LegalEntity__c legalEntityTrimestre =  TestDataFactory.createLegalEntity('Trimestrielle');
        blng__LegalEntity__c legalEntityAnnuelle =  TestDataFactory.createLegalEntity('Annuelle');
        blng__FinanceBook__c finBook = TestDataFactory.createFinanceBook(legalEntityMensuelle.Id);
        blng__GLRule__c glrul = TestDataFactory.createGlRule(legalEntityMensuelle.Id);
        blng__RevenueDistributionMethod__c distMet = TestDataFactory.createDistribMethod();
        TestDataFactory.createRevenueRecognitionTreatment(legalEntityMensuelle.Id, finBook.Id, revRecRul.Id, glrul.Id, distMet.Id, 0);

        // tax rule
        blng__TaxRule__c taxRule = TestDataFactory.createTaxRule();
        TestDataFactory.createTaxTreatment(legalEntityMensuelle.Id, taxRule.Id);

        //create order
        Order order = TestDataFactory.createOrder(ACC.Id, Date.newInstance(2021  , 10 , 10), Date.newInstance(2021  , 11 , 11), Q.Id, OPP.Id);

        OrderItem orderItem = TestDataFactory.createOrderProduct(order.Id, PRD1.Id, ACC.Id, Date.today(), Date.today().addMonths(12), legalEntityMensuelle.Id, blngR.Id, finBook.Id, glrul.Id, revRecRul.Id, QLI1.Id, pricebookEntry.Id);

        //USAGE SUMMARY
        blng__UsageSummary__c usageSummary = new blng__UsageSummary__c();
        usageSummary.blng__Account__c = ACC.Id;
        usageSummary.blng__Order__c = order.Id;
        usageSummary.blng__OrderProduct__c = orderItem.Id;
        usageSummary.blng__SummaryStartDate__c = Date.newInstance(2025  , 10 , 10);
        usageSummary.blng__SummaryEndDate__c = Date.newInstance(2025  , 11 , 11);
        usageSummary.blng__AppliedUnitPrice__c = 10.0;
        usageSummary.blng__MatchingId__c = 'test';
        insert usageSummary;

        //UPLIFT RATE
        List<Uplift_Rate__c> upliftRates = new List<Uplift_Rate__c>();
        Uplift_Rate__c upliftRate = new Uplift_Rate__c(Index_Year__c  = Date.today().year() ,Legal_Entity__c = legalEntityAnnuelle.Id , Index_Period__c ='Y' , Index__c = 12 );
        upliftRates.add(upliftRate);
        upliftRate = new Uplift_Rate__c(Index_Year__c  = Date.today().year()-1 ,Legal_Entity__c = legalEntityAnnuelle.Id , Index_Period__c ='Y' , Index__c = 1 );
        upliftRates.add(upliftRate);

        upliftRate = new Uplift_Rate__c(Index_Year__c  = Date.today().year() ,Legal_Entity__c = legalEntityMensuelle.Id , Index_Period__c ='M2' , Index__c = 12 );
        upliftRates.add(upliftRate);
        upliftRate = new Uplift_Rate__c(Index_Year__c  = Date.today().year()-1 ,Legal_Entity__c = legalEntityMensuelle.Id , Index_Period__c ='M2', Index__c = 1 );
        upliftRates.add(upliftRate);

        upliftRate = new Uplift_Rate__c(Index_Year__c  = Date.today().year()-1 ,Legal_Entity__c = legalEntityMensuelle.Id , Index_Period__c ='M1', Index__c = 1 );
        upliftRates.add(upliftRate);

        upliftRate = new Uplift_Rate__c(Index_Year__c  = Date.today().year() ,Legal_Entity__c = legalEntityMensuelle.Id , Index_Period__c ='M1', Index__c = 1 );
        upliftRates.add(upliftRate);

        upliftRate = new Uplift_Rate__c(Index_Year__c  = Date.today().year() ,Legal_Entity__c = legalEntityTrimestre.Id , Index_Period__c ='T1' , Index__c = 12 );
        upliftRates.add(upliftRate);
        upliftRate = new Uplift_Rate__c(Index_Year__c  = Date.today().year()-1 ,Legal_Entity__c = legalEntityTrimestre.Id , Index_Period__c ='T1' , Index__c = 1 );
        upliftRates.add(upliftRate);

        insert upliftRates;
    }

    @IsTest
    public static void test_PourcentageNegocie(){
        Contract contract = [SELECT Id FROM Contract LIMIT 1] ;
        Order order = [SELECT Id FROM Order];
        blng__LegalEntity__c legalEntity = [SELECT Id FROM blng__LegalEntity__c WHERE Update_Rate_Frequency__c = 'Mensuelle' LIMIT 1] ;

        contract.Next_Date_Uplift__c = Date.today();
        contract.Uplift_Mode__c = 'Pourcentage fixe négocié';
        contract.Legal_Entity__c = legalEntity.Id;
        contract.Negociated_Rate__c = 5;
        contract.SBQQ__Order__c = order.Id;
        update contract;

        Test.startTest();
        Batch_Contract_Uplift b = new Batch_Contract_Uplift(true);
        Database.executeBatch(b,1);
        Test.stopTest();

        //Contract Next Date Uplift
        contract = [SELECT Id , Next_Date_Uplift__c FROM Contract WHERE Id = :contract.Id];
        System.assert(contract.Next_Date_Uplift__c != Date.today());

        //Usage Summary Applied Unit Price
        OrderItem orderItem = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id LIMIT 1];

        Boolean has105 = false;
        for(blng__UsageSummary__c usageSummary : [SELECT Id , blng__AppliedUnitPrice__c FROM blng__UsageSummary__c WHERE blng__OrderProduct__c = :orderItem.Id]) {
            if (usageSummary.blng__AppliedUnitPrice__c == 10.5)
                has105 = true;
        }
        System.assert(has105);
    }

    @IsTest
    public static void test_IndiceNegocie(){
        Contract contract = [SELECT Id FROM Contract LIMIT 1] ;
        Order order = [SELECT Id FROM Order];
        blng__LegalEntity__c legalEntity = [SELECT Id FROM blng__LegalEntity__c WHERE Update_Rate_Frequency__c = 'Annuelle' LIMIT 1] ;

        contract.Next_Date_Uplift__c = Date.today();
        contract.Uplift_Mode__c = 'Pourcentage de l\'indice négocié';
        contract.Legal_Entity__c = legalEntity.Id;
        contract.Negociated_Rate__c = 5;
        contract.SBQQ__Order__c = order.Id;
        update contract;

        Test.startTest();
        Batch_Contract_Uplift b = new Batch_Contract_Uplift(false);
        Database.executeBatch(b,1);
        Test.stopTest();

        //Contract Next Date Uplift
        contract = [SELECT Id , Next_Date_Uplift__c FROM Contract WHERE Id = :contract.Id];
        System.assert(contract.Next_Date_Uplift__c != Date.today());

        //Usage Summary Applied Unit Price
        OrderItem orderItem = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id LIMIT 1];

        Boolean has155 = false;
        for(blng__UsageSummary__c usageSummary : [SELECT Id , blng__AppliedUnitPrice__c FROM blng__UsageSummary__c WHERE blng__OrderProduct__c = :orderItem.Id]) {
            if (usageSummary.blng__AppliedUnitPrice__c == 15.5)
                has155 = true;
        }
        System.assert(has155);
    }

    @IsTest
    public static void test_IndiceEnVigueur(){
        System.debug('start test indice en vigueur');

        Contract contract = [SELECT Id FROM Contract LIMIT 1] ;
        Order order = [SELECT Id FROM Order];
        blng__LegalEntity__c legalEntity = [SELECT Id FROM blng__LegalEntity__c WHERE Update_Rate_Frequency__c = 'Annuelle' LIMIT 1] ;
        contract.Next_Date_Uplift__c = Date.today();
        contract.Uplift_Mode__c = 'Indexation selon indice en vigueur';
        contract.Legal_Entity__c = legalEntity.Id;
        contract.SBQQ__Order__c = order.Id;
        update contract;

        System.debug('udpate contract');

        Test.startTest();
        Batch_Contract_Uplift b = new Batch_Contract_Uplift(false);
        Database.executeBatch(b,1);
        Test.stopTest();

        System.debug('batch end');

        //Contract Next Date Uplift
        contract = [SELECT Id , Next_Date_Uplift__c FROM Contract WHERE Id = :contract.Id];
        System.assert(contract.Next_Date_Uplift__c != Date.today());

        //Usage Summary Applied Unit Price
        OrderItem orderItem = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id LIMIT 1];
        Boolean has120 = false;
        for(blng__UsageSummary__c usageSummary : [SELECT Id , blng__AppliedUnitPrice__c FROM blng__UsageSummary__c WHERE blng__OrderProduct__c = :orderItem.Id]) {
            if (usageSummary.blng__AppliedUnitPrice__c == 120)
                has120 = true;
        }
        // System.assertEquals(usageSummary.blng__AppliedUnitPrice__c , 120);
        System.assert(has120);
    }

    @IsTest
    public static void test_PasIndexation(){
        Contract contract = [SELECT Id FROM Contract LIMIT 1] ;
        Order order = [SELECT Id FROM Order];
        blng__LegalEntity__c legalEntity = [SELECT Id FROM blng__LegalEntity__c WHERE Update_Rate_Frequency__c = 'Trimestrielle' LIMIT 1] ;

        contract.Next_Date_Uplift__c = Date.today();
        contract.Uplift_Mode__c = 'Pas d\'indexation';
        contract.Legal_Entity__c = legalEntity.Id;
        contract.SBQQ__Order__c = order.Id;
        update contract;

        Test.startTest();
        Batch_Contract_Uplift b = new Batch_Contract_Uplift(false);
        Database.executeBatch(b,1);
        Test.stopTest();

        //Contract Next Date Uplift
        contract = [SELECT Id , Next_Date_Uplift__c FROM Contract WHERE Id = :contract.Id];
        System.assert(contract.Next_Date_Uplift__c == Date.today());

        //Usage Summary Applied Unit Price
        OrderItem orderItem = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id LIMIT 1];
        blng__UsageSummary__c usageSummary = [SELECT Id , blng__AppliedUnitPrice__c FROM blng__UsageSummary__c WHERE blng__OrderProduct__c = :orderItem.Id LIMIT 1];
        System.assertEquals(usageSummary.blng__AppliedUnitPrice__c , 10);
    }

    //Two Product item one with product tiers, the other without
    @IsTest
    public static void test_Tiers(){
        Id pricebookId = Test.getStandardPricebookId();

        Contract contract = [SELECT Id, AccountId FROM Contract LIMIT 1] ;
        Order order = [SELECT Id, AccountId FROM Order];
        OrderItem orderItem2 = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id LIMIT 1];

        order.Status = 'Draft';
        order.SBQQ__Quote__c = null;
        update order;

        blng__LegalEntity__c legalEntityMensuelle = [SELECT Id FROM blng__LegalEntity__c WHERE Update_Rate_Frequency__c = 'Mensuelle'];
        blng__BillingRule__c blngR = [SELECT Id FROM blng__BillingRule__c WHERE Name = 'Petit Forestier - Container Invoicing'];
        blng__FinanceBook__c finBook = [SELECT Id FROM blng__FinanceBook__c WHERE Name = 'Petit Forestier Revenue'];
        blng__GLRule__c glrul = [SELECT Id FROM blng__GLRule__c WHERE Name = 'Facturation Conteneurs Revenue'];
        blng__RevenueRecognitionRule__c revRecRul = [SELECT Id FROM blng__RevenueRecognitionRule__c WHERE Name = 'Reconnaissance de la Revenue des Factures'];

        Product2 PRD = new Product2(Name = 'Product test 3' , IsActive = true , SBQQ__SubscriptionPricing__c = 'Fixed Price');
        insert PRD;

        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = pricebookId;
        pricebookEntry.Product2Id = PRD.Id;
        pricebookEntry.IsActive = true;
        pricebookEntry.UnitPrice = 100;
        insert pricebookEntry;

        OrderItem orderItem = TestDataFactory.createOrderProduct(order.Id, PRD.Id, order.AccountId, Date.today(), Date.today().addMonths(12), legalEntityMensuelle.Id, blngR.Id, finBook.Id, glrul.Id, revRecRul.Id, null, pricebookEntry.Id);

        SBQQ__PriceSchedule__c priceSchedule = new SBQQ__PriceSchedule__c(	SBQQ__Order__c = order.Id , SBQQ__OrderProduct__c = orderItem.Id);
        insert priceSchedule;

        SBQQ__PriceTier__c priceTier = new SBQQ__PriceTier__c(SBQQ__PriceSchedule__c = priceSchedule.Id , Name = 'testTier' , SBQQ__Price__c = 5);
        insert priceTier;

        blng__UsageSummary__c usageSummary = new blng__UsageSummary__c(blng__UnitPrice__c = 10 , blng__OrderProduct__c = orderItem.Id , blng__SummaryEndDate__c = Date.newInstance(2025  , 11 , 11) , blng__SummaryStartDate__c = Date.newInstance(2025  , 10 , 10));
        insert usageSummary;

        blng__LegalEntity__c legalEntity = [SELECT Id FROM blng__LegalEntity__c WHERE Update_Rate_Frequency__c = 'Mensuelle' LIMIT 1] ;

        contract.Next_Date_Uplift__c = Date.today();
        contract.Uplift_Mode__c = 'Pourcentage fixe négocié';
        contract.Legal_Entity__c = legalEntity.Id;
        contract.Negociated_Rate__c = 5;
        contract.SBQQ__Order__c = order.Id;
        update contract;

        Map<Id , OrderItem> orderProducts = new Map<Id , OrderItem> ([SELECT Id FROM OrderItem WHERE OrderId = :contract.SBQQ__Order__c AND Uplift_Eligible__c = TRUE]);
        System.debug('Batch_Contract_Uplift_Test : ' + orderProducts.keySet().size());

        List<SBQQ__PriceTier__c> priceTiers = [SELECT Id , Order_Product_ID__c , SBQQ__Price__c FROM SBQQ__PriceTier__c WHERE Order_Product_ID__c IN :orderProducts.keySet()];
        System.debug('Batch_Contract_Uplift_Test : ' + priceTiers.size());

        priceTiers = [SELECT Id , Order_Product_ID__c , SBQQ__Price__c FROM SBQQ__PriceTier__c ];
        System.debug('Batch_Contract_Uplift_Test : ' + priceTiers);

        Test.startTest();
        Batch_Contract_Uplift b = new Batch_Contract_Uplift(true);
        Database.executeBatch(b,1);
        Test.stopTest();

        //Contract Next Date Uplift
        contract = [SELECT Id , Next_Date_Uplift__c FROM Contract WHERE Id = :contract.Id];
        System.assert(contract.Next_Date_Uplift__c != Date.today());

        //Usage Summary Applied Unit Price
        Boolean has525 = false;
        Boolean has105 = false;
        List<Id> itIds = new List<Id>{orderItem2.Id, orderItem.Id};
        for(blng__UsageSummary__c us : [SELECT Id , blng__AppliedUnitPrice__c FROM blng__UsageSummary__c WHERE blng__OrderProduct__c IN :itIds]) {
            System.debug('Useage summary: ');
            System.debug(us);
            if (us.blng__AppliedUnitPrice__c == 5.25)
                has525 = true;
            if (us.blng__AppliedUnitPrice__c == 10.5)
                has105 = true;
        }
        System.assert(has525);
        System.assert(has105);
    }

}