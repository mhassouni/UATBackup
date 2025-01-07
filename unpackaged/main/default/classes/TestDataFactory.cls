@isTest
public class TestDataFactory {

    /* Account */

    public static List<Account> createClients(Integer nbr, Boolean toInsert){
        List<Account> clients = new List<Account>();
        for(Integer i=0; i<nbr; i++){
            clients.add(new Account(Name='Test' + i, Statut__c = 'Validé'));
        }
        if(toInsert) insert clients;
        return clients;
    }

    /* Product */

    public static List<Product2> createOptionsProducts(Integer nbr, Boolean toInsert){
        List<Product2> products = new List<Product2>();
        for(Integer i=0; i<nbr; i++){
            products.add(new Product2(Name='Product' + i, Gamme__c = 'Option'));
        }
        if(toInsert) insert products;
        return products;
    }

    /* Order */

    public static List<Order> createOrders(Integer nbr, Id clientId, Boolean toInsert){
        List<Order> orders = new List<Order>();
        if(clientId == null) clientId = createClients(1, true).get(0).Id;
        for(Integer i=0; i<nbr; i++){
            orders.add(new Order(AccountId = clientId,
                    EffectiveDate = System.today().addDays(7),
                    StartDate__c  = System.today().addDays(7),
                    EndDate__c = System.today().addDays(100),
                    blng__BillingDayOfMonth__c = '1',
                    Status = 'Draft'));
        }
        if(toInsert) insert orders;
        return orders;
    }

    /* Asset */

    public static List<Asset> createContainersWithStatus(Integer nbr, String status, Boolean toInsert){
        List<Asset> containers = new List<Asset>();

        String parcRTID = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Parc_Container').getRecordTypeId();
        for(Integer i=0; i<nbr; i++){
            containers.add(new Asset(RecordTypeId = parcRTID,
                    Name = 'Container' + i,
                    Position_Conteneur__c = 'Exploitable',
                    Status_de_location__c = status));
        }
        if(toInsert) insert containers;
        return containers;
    }


    /* Reservation */

    public static List<Reservation__c> createReservationsAtelier(Integer nbr, Id clientId, Id orderId, Date startDate, Boolean toInsert){
        List<Reservation__c> reservations = new List<Reservation__c>();
        if(clientId == null) clientId = createClients(1, true).get(0).Id;

        String atelierRTID = Schema.SObjectType.Reservation__c.getRecordTypeInfosByDeveloperName().get('Atelier').getRecordTypeId();
        for(Integer i=0; i<nbr; i++){
            reservations.add(new Reservation__c(RecordTypeId = atelierRTID,
                    Client__c = clientId,
                    Commande__c = orderId,
                    Date_de_debut__c = startDate,
                    Date_de_fin__c = startDate.addDays(5)));
        }
        if(toInsert) insert reservations;
        return reservations;
    }

    public static List<Reservation__c> createReservationsLocation(Integer nbr, Id clientId, Id orderId, Date startDate, Boolean toInsert){
        List<Reservation__c> reservations = new List<Reservation__c>();
        if(clientId == null) clientId = createClients(1, true).get(0).Id;

        String locationRTID = Schema.SObjectType.Reservation__c.getRecordTypeInfosByDeveloperName().get('Location').getRecordTypeId();
        for(Integer i=0; i<nbr; i++){
            reservations.add(new Reservation__c(RecordTypeId = locationRTID,
                    Client__c = clientId,
                    Commande__c = orderId,
                    Date_de_debut__c = startDate,
                    Date_de_fin__c = startDate.addDays(5)));
        }
        if(toInsert) insert reservations;
        return reservations;
    }

    public static List<Reservation__c> createReservationsTransport(Integer nbr, Id clientId, Id orderId, Date startDate, Boolean toInsert){
        List<Reservation__c> reservations = new List<Reservation__c>();
        if(clientId == null) clientId = createClients(1, true).get(0).Id;

        String transportRTID = Schema.SObjectType.Reservation__c.getRecordTypeInfosByDeveloperName().get('Transport').getRecordTypeId();
        for(Integer i=0; i<nbr; i++){
            reservations.add(new Reservation__c(RecordTypeId = transportRTID,
                    Client__c = clientId,
                    Commande__c = orderId,
                    Date_de_debut__c = startDate,
                    Date_de_fin__c = startDate.addDays(5)));
        }
        if(toInsert) insert reservations;
        return reservations;
    }






    public static Account createAccount(String accName, String accCodeNAF, String accParent, String accRecordTypeId){
        Account acc = new Account();
        acc.Name = accName;
        acc.CodeNAF__c = accCodeNAF;
        acc.ParentId = accParent;
        acc.RecordTypeId = accRecordTypeId;
        acc.PaysRegionPF__c = 'DO1B';
        acc.AgencePF__c = '001 - VILLEPINTE';
        acc.Statut__c = Label.CPT_Statut_Valide;
        acc.Mode_facturation__c = 'Début de mois';
        acc.Mode_reglement__c = 'Virement';
        acc.SBQQ__RenewalModel__c = 'Contract Based';
        acc.PaysRegionPF__c = 'DO1B';
        insert acc;

        return acc;
    }

    public static void createFinancialCond(Id accountId) {
        Dero_Fi__c dero = new Dero_Fi__c();
        dero.Account__c = accountId;
        dero.Mode_facturation__c = 'Début de mois';
        dero.Delai_reglement__c = '30 jours';
        dero.Mode_reglement__c = 'Virement';
        dero.Dpt_garantie__c = 'Dispensé';
        dero.Mois_caution__c = '1';
        dero.RecordTypeId = Schema.SObjectType.Dero_Fi__c.getRecordTypeInfosByDeveloperName().get('Specific_Financial_Conditions').getRecordTypeId();
        dero.Uplift_Mode__c = 'Pas d\'indexation';
        insert dero;
    }

    public static Contact createContact(String ctName, Id accountId) {
        Contact ct = new Contact();
        ct.LastName = ctName;
        ct.AccountId = accountId;
        insert ct;

        return ct;
    }

    public static blng__BillingRule__c createBillingRule() {
        blng__BillingRule__c blngRul = new blng__BillingRule__c();
        blngRul.Name = 'Petit Forestier - Container Invoicing';
        blngRul.blng__InitialBillingTrigger__c = 'Order Product Activation Date';
        blngRul.blng__GenerateInvoices__c = 'Yes';
        blngRul.blng__PartialPeriodTreatment__c = 'Combine';
        blngRul.blng__PeriodTreatmentForBTDO__c = 'Combine';
        insert blngRul;

        return blngRul;
    }

    public static blng__RevenueRecognitionRule__c createRevenueRecognitionRule() {
        blng__RevenueRecognitionRule__c recRule = new blng__RevenueRecognitionRule__c();
        recRule.Name = 'Reconnaissance de la Revenue des Factures';
        recRule.blng__CreateRevenueSchedule__c = 'Yes';
        insert recRule;

        return recRule;
    }

    public static blng__LegalEntity__c createLegalEntity() {
        blng__LegalEntity__c legEnt = new blng__LegalEntity__c();
        legEnt.Name = 'Petit forrestier';
        legEnt.Update_Rate_Frequency__c = 'Mensuelle';
        legEnt.CurrencyIsoCode = 'EUR';
        legEnt.blng__ZipPostalCode__c = '93420';
        legEnt.blng__Street1__c = 'Route de Tremblay 11';
        legEnt.blng__Country__c = 'France';
        legEnt.blng__City__c = 'Villepinte';
        legEnt.blng__Active__c = true;
        insert legEnt;

        return legEnt;
    }

    public static blng__LegalEntity__c createLegalEntity(String updateFrequency) {
        blng__LegalEntity__c legEnt = new blng__LegalEntity__c();
        legEnt.Name = 'Petit forrestier';
        legEnt.Update_Rate_Frequency__c = updateFrequency;
        legEnt.CurrencyIsoCode = 'EUR';
        legEnt.blng__ZipPostalCode__c = '93420';
        legEnt.blng__Street1__c = 'Route de Tremblay 11';
        legEnt.blng__Country__c = 'France';
        legEnt.blng__City__c = 'Villepinte';
        legEnt.blng__Active__c = true;
        insert legEnt;

        return legEnt;
    }

    public static blng__FinanceBook__c createFinanceBook(Id legEntId) {
        blng__FinanceBook__c fb = new blng__FinanceBook__c();
        fb.Name = 'Petit Forestier Revenue';
        fb.blng__PeriodType__c = 'Revenue';
        fb.blng__FinancePeriodDuration__c = 'Monthly';
        fb.blng__Active__c = true;
        insert fb;

        List<blng__FinancePeriod__c> periods = new List<blng__FinancePeriod__c>();
        for (Integer i = 1; i<=12; i++) {
            Date periodStart = Date.newInstance(Date.today().year(), i, 1);
            blng__FinancePeriod__c per = new blng__FinancePeriod__c();
            per.Name = 'Per ' + i;
            per.blng__LegalEntity__c = legEntId;
            per.blng__FinanceBook__c = fb.Id;
            per.blng__PeriodStatus__c = 'Open';
            per.blng__PeriodStartDate__c = periodStart;
            per.blng__PeriodEndDate__c = periodStart.addMonths(1).addDays(-1);
            periods.add(per);
        }
        insert periods;

        return fb;
    }

    public static blng__GLRule__c createGlRule(Id legEntId) {
        blng__GLRule__c gl = new blng__GLRule__c();
        gl.Name = 'Facturation Conteneurs Revenue';
        gl.blng__Active__c = true;
        insert gl;

        blng__GLAccount__c glac = new blng__GLAccount__c();
        glac.Name = 'Compte GL Revenue Courte & Moyenne Durée';
        glac.blng__Active__c = true;
        glac.blng__GLAccountDescription__c = 'This GL account captures the Revenue transactions, this for Short or Medium Term contracts';
        glac.blng__GLAccountNumber__c = '706310000';
        insert glac;

        blng__GLTreatment__c trt = new blng__GLTreatment__c();
        trt.Name = 'Conteneurs Revenue';
        trt.blng__Active__c = true;
        trt.blng__GLRule__c = gl.Id;
        trt.blng__GLLegalEntity__c = legEntId;
        trt.blng__CreditGLAccount__c = glac.Id;
        trt.blng__DebitGLAccount__c = glac.Id;
        insert trt;

        return gl;
    }

    public static blng__RevenueDistributionMethod__c createDistribMethod() {
        blng__RevenueDistributionMethod__c met = new blng__RevenueDistributionMethod__c();
        met.Name = 'Factures';
        met.blng__MonthlyRecognitionProration__c = 'Number of Days';
        met.blng__RevenueTransactionCreationProcess__c = 'Automatic';
        met.blng__Type__c = 'Invoice';
        met.blng__DistributionMethod__c = 'Full Recognition';
        met.blng__FullRecognitionDate__c = 'Invoice Line Start Date';
        insert met;

        return met;
    }

    public static blng__RevenueRecognitionTreatment__c createRevenueRecognitionTreatment(Id legalEntityId, Id financeBookId, Id revRecRuleId, Id glRuleId, Id distMetId, Integer processingOrder) {
        blng__RevenueRecognitionTreatment__c recTrt = new blng__RevenueRecognitionTreatment__c();
        recTrt.blng__RevenueLegalEntity__c = legalEntityId;
        recTrt.blng__RevenueFinanceBook__c = financeBookId;
        recTrt.blng__RevenueRecognitionRule__c = revRecRuleId;
        recTrt.blng__RevenueGLRule__c = glRuleId;
        recTrt.blng__RevenueScheduleCreationAction__c = 'Invoice Posting';
        recTrt.blng__Percentage__c = 100.0;
        recTrt.blng__Type__c = 'Percentage';
        recTrt.blng__ProcessingOrder__c = processingOrder;
        recTrt.Name = 'Facturation Conteneurs';
        recTrt.blng__RevenueScheduleAmount__c = 'Transaction Amount';
        recTrt.blng__RevenueDistributionMethod__c = distMetId;
        insert recTrt;

        return recTrt;
    }

    public static blng__TaxRule__c createTaxRule() {
        blng__TaxRule__c rul = new blng__TaxRule__c();
        rul.Name = '';
        rul.blng__Active__c = true;
        rul.blng__TaxableYesNo__c = 'Yes';
        insert rul;

        return rul;
    }

    public static blng__TaxTreatment__c createTaxTreatment(Id legEntId, Id taxRulId) {
        blng__GLRule__c glr = new blng__GLRule__c();
        glr.Name = 'Clients Groupe (Filiales) - Ventes Prestations';
        glr.blng__Active__c = true;
        insert glr;

        blng__TaxIntegration__c integ = new blng__TaxIntegration__c();
        integ.Name = 'Standard Salesforce';
        integ.blng__TaxEngine__c = 'Standard';
        integ.blng__Active__c = true;
        integ.blng__Default__c = true;
        insert integ;

        blng__TaxTreatment__c tt = new blng__TaxTreatment__c();
        tt.Name = 'Domestic Customers Treatment';
        tt.blng__TaxCode__c = 'STD';
        tt.blng__Active__c = true;
        tt.blng__TaxGLRule__c = glr.Id;
        tt.blng__TaxLegalEntity__c = legEntId;
        tt.blng__TaxIntegration__c = integ.Id;
        tt.blng__TaxRule__c = taxRulId;
        insert tt;

        return tt;
    }

    public static Product2 createProduct(String name, Boolean isActive, String productCode, String family, Id blngRuleId, Id revRecId, Id taxRuleId) {
        Product2 product = new Product2();
        product.Name = name;
        product.IsActive = isActive;
        product.ProductCode = productCode;
        product.Family = family;
        product.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        product.blng__BillingRule__c = blngRuleId;
        product.SBQQ__ChargeType__c = 'Usage';
        product.SBQQ__BillingFrequency__c = 'Monthly';
        product.blng__RevenueRecognitionRule__c = revRecId;
        product.SBQQ__QuantityEditable__c = true;
        product.QuantityUnitOfMeasure = 'Chaque';
        product.SBQQ__SubscriptionType__c = 'Renewable';
        product.SBQQ__SubscriptionTerm__c = 1;
        product.SBQQ__SortOrder__c = 2;
        product.SBQQ__PriceEditable__c = true;
        product.SBQQ__SubscriptionBase__c = 'List';
        product.SBQQ__OptionSelectionMethod__c = 'Click';
        product.SBQQ__PricingMethod__c = 'List';
        product.SBQQ__DefaultQuantity__c = 1;
        product.SBQQ__ConfigurationType__c = 'Allowed';
        product.SBQQ__BlockPricingField__c = 'Quantity';
        product.SBQQ__ConfigurationEvent__c = 'Always';
        product.blng__TaxRule__c = taxRuleId;
        insert product;

        return product;
    }

    public static PricebookEntry createPricebookEntry(Boolean isactive, Id pricebook2Id, Id product2id, Decimal unitprice) {

        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.IsActive = isactive;
        pricebookEntry.Pricebook2Id = pricebook2Id;
        pricebookEntry.Product2Id = product2id;
        pricebookEntry.UnitPrice = unitprice;
        insert pricebookEntry;

        return pricebookEntry;
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

    public static SBQQ__Quote__c createCPQQuote(Id oppId, Boolean primary, Id accountId, Date startDate, Decimal subsTerm) {
        SBQQ__Quote__c newCPQQuote = new SBQQ__Quote__c();
        newCPQQuote.SBQQ__Opportunity2__c = oppId;
        newCPQQuote.SBQQ__StartDate__c = startDate;
        newCPQQuote.SBQQ__Primary__c = primary;
        newCPQQuote.SBQQ__Account__c = accountId;
        newCPQQuote.SBQQ__StartDate__c = System.today().toStartOfMonth();
        newCPQQuote.SBQQ__SubscriptionTerm__c = subsTerm;
        newCPQQuote.SBQQ__PaymentTerms__c = 'Net 30';
        newCPQQuote.SBQQ__ExpirationDate__c = Date.today().addMonths(1).addDays(-1);
        newCPQQuote.Type_de_location__c = 'Longue Durée';
        newCPQQuote.SBQQ__OrderByQuoteLineGroup__c = true;
        newCPQQuote.Quote_Type__c = 'Standard Quote';
//        newCPQQuote.HeaderFieldSetName__c = 'Standard_Quote'; //defined by default, with different apiname on dev/uat
        newCPQQuote.Mode_reglement__c = 'Virement';
        newCPQQuote.Mode_facturation__c = 'Fin de mois';
        newCPQQuote.Delai_reglement__c = '30 jours';
        newCPQQuote.Dpt_garantie__c = 'Dispensé';
        newCPQQuote.Mois_caution__c = '1';
        newCPQQuote.Paiement_en_avance__c = '50%';
        newCPQQuote.Indexation__c = 'Indexation selon indice en vigueur';
        insert newCPQQuote;

        return newCPQQuote;
    }

    public static SBQQ__QuoteLineGroup__c createQuotelineGroup(Id quoteId, Date startDate, Date endDate) {
        SBQQ__QuoteLineGroup__c qlg = new SBQQ__QuoteLineGroup__c();
        qlg.SBQQ__Quote__c = quoteId;
        qlg.Name = 'Group1';
        qlg.SBQQ__Number__c = 1;
        qlg.SBQQ__StartDate__c = startDate;
        qlg.SBQQ__EndDate__c = endDate;
        qlg.Prom_season__c = true;
        qlg.Code_Postal_Gp__c = '93000';
        insert qlg;

        return qlg;
    }

    public static SBQQ__QuoteLine__c createQuoteLine(Id quoteId, Id productId, Integer qty, Id pbId, Id qlgId) {
        SBQQ__QuoteLine__c quoteline = new SBQQ__QuoteLine__c();
        quoteline.SBQQ__Product__c = productId;
        quoteline.SBQQ__Quantity__c = qty;
        quoteline.SBQQ__Quote__c = quoteId;
        quoteline.SBQQ__PricebookEntryId__c = pbId;
        quoteline.SBQQ__Group__c = qlgId;
        quoteline.SBQQ__ListPrice__c = 12.0;
        quoteline.SBQQ__DefaultSubscriptionTerm__c = 1;
        quoteline.SBQQ__Number__c = 1;
        quoteline.SBQQ__PriceEditable__c = true;
        quoteline.SBQQ__PricingMethod__c = 'List';
        quoteline.AdditionalDiscountUnit__c = 'Percent';
        quoteline.SBQQ__CustomerPrice__c = 5000;
        quoteline.SBQQ__NetPrice__c = 5000;
        quoteline.SBQQ__SpecialPrice__c = 12;
        quoteline.SBQQ__UnitCost__c = 99;
        quoteline.SBQQ__RegularPrice__c = 5232;
        quoteline.SBQQ__ProratedListPrice__c = 5232;
        quoteline.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        quoteline.SBQQ__ProrateMultiplier__c = 396;
        quoteline.SBQQ__SubscriptionType__c = 'Renewable';
        quoteline.SBQQ__AdditionalDiscountAmount__c = 650.3;
        quoteline.SBQQ__ProductSubscriptionType__c = 'Renewable';
        insert quoteline;

        return quoteline;
    }

    public static Order createOrder(Id accId, Date startDate, Date endDate, Id quoteId, Id opportId) {
        Order o = new Order();
        o.AccountId = accId;
        o.SBQQ__Quote__c = quoteId;
        o.StartDate__c = startDate;
        o.EndDate__c = endDate;
        o.Status = 'Draft';
        o.Type = 'New';
        o.OpportunityId = opportId;
//        o.SBQQ__Contracted__c = true;
        o.blng__BillingDayOfMonth__c = '1';
        o.EffectiveDate = startDate;
        insert o;

        return o;
    }

    public static OrderItem createOrderProduct(Id orderId, Id prdId, Id accId, Date start, Date ending, Id legEntId, Id bilRulId, Id finBId, Id glRulId, Id revRecId, Id qlId, Id pbeId) {
        OrderItem item = new OrderItem();
        item.OrderId = orderId;
        item.Product2Id = prdId;
        item.Quantity = 1;
        item.blng__BillingAccount__c = accId;
        item.SBQQ__ChargeType__c = 'Usage';
        item.ServiceDate = start;
        item.EndDate = ending;
        item.blng__BillableUnitPrice__c = 12;
        item.UnitPrice = 5000;
        item.blng__LegalEntity__c = legEntId;
        item.blng__BillingRule__c = bilRulId;
        item.blng__FinanceBookAccounting__c = finbId;
        item.blng__BillingGLRule__c = glRulId;
        item.blng__RevenueRecognitionRule__c = revRecId;
        item.SBQQ__QuoteLine__c = qlId;
        item.PricebookEntryId = pbeId;
        SBQQ.TriggerControl.disable();
        insert item;
        SBQQ.TriggerControl.enable();


        return item;
    }

    public static Contract createContract(Id accountId, Id quoteId, String status, Date startDate, Integer contractTerm, Date extensionDate, Id orderId, Id oppId) {
        Contract contract = new Contract();
        contract.AccountId = accountId;
        contract.Status = status;
        contract.StartDate = startDate;
        contract.EndDate = startDate.addMonths(contractTerm);
        contract.ContractTerm = contractTerm;
        contract.SBQQ__Quote__c = quoteId;
        contract.Extension_Date__c = extensionDate;
        contract.SBQQ__Order__c = orderId;
        contract.SBQQ__RenewalForecast__c = true;
        contract.SBQQ__RenewalQuoted__c = true;
        contract.SBQQ__RenewalTerm__c = 396;
        contract.SBQQ__DefaultRenewalContactRoles__c = true;
        contract.SBQQ__DefaultRenewalPartners__c = true;
        contract.SBQQ__PreserveBundleStructureUponRenewals__c = true;
        contract.SBQQ__AmendmentRenewalBehavior__c = 'Latest End Date';
        contract.SBQQ__Opportunity__c = oppId;
        insert contract;

        return contract;
    }

    public static void createSubscription(Id contractId, Id prdId, Id qlId, Id accId) {
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Contract__c = contractId;
        sub.SBQQ__Quantity__c = 1;
        sub.SBQQ__Product__c = prdId;
        sub.SBQQ__QuoteLine__c = qlId;
        sub.SBQQ__Account__c = accId;
        sub.SBQQ__ProductSubscriptionType__c = 'Renewable';
        sub.SBQQ__SubscriptionType__c = 'Renewable';
        sub.SBQQ__ListPrice__c = 5232;
        sub.SBQQ__SpecialPrice__c = 12;
        sub.SBQQ__CustomerPrice__c = 5000;
        sub.SBQQ__RegularPrice__c = 5232;
        sub.SBQQ__NetPrice__c = 5000;
        sub.SBQQ__RenewalPrice__c = 12;
        sub.SBQQ__ProrateMultiplier__c = 396;
        sub.SBQQ__UnitCost__c = 99;
        insert sub;
    }


    public static Reservation__c createTransportToClientReservation(Id orderId, Id orderItemId, Date deliveryDate) {
        Reservation__c reserv = new Reservation__c();
        reserv.RecordTypeId = Schema.SObjectType.Reservation__c.getRecordTypeInfosByDeveloperName().get('Transport').getRecordTypeId();
        reserv.Type_de_transport__c = Label.TypeReservation_UsageCreation;
        reserv.Commande__c = orderId;
        reserv.PF_Date_de_livraison_du_conteneur__c = deliveryDate;
        reserv.Produits_demandes__c = orderItemId;
        insert reserv;

        return reserv;
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
}