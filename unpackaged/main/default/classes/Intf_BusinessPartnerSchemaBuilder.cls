/**
 * Created by Michael on 06-03-24.
 */

public with sharing class Intf_BusinessPartnerSchemaBuilder {

    private static Account account;
    private static Contact contact;
    private static Opportunity opportunity;
    private static InvolvedStakeholder__c involvedStakeholder;
    private static SalesAreaData__c salesAreaData;
    private static Framework_Agreement__c frameworkAgreement;

    private static final String PARTNER_FUNCTION_INVOICE = 'Facturation';
    private static final String PARTNER_FUNCTION_DELIVERY = 'Livraison';
    private static final String PARTNER_ROLE_B2C_DEFAULT = 'Donneur d\'ordre';
    private static final String LANGUAGE_DEFAULT = 'FR';
    private static final String PARTNER_CLASS_B2B_DEFAULT = '01';
    private static final String CONTACT_SALUTATION_B2B_DEFAULT = '003';
    private static final String B2B_PAYMENT_TYPE = 'F00';
    private static final String B2B_PAYMENT_METHOD = 'P';
    private static final String B2B_DIVISON = 'Z1';
    private static final String B2B_DISTRIBUTION_CHANNEL = '10';
    private static final String FINANCIAL_LANGUAGE = 'FR';
    private static final String FINANCIAL_DEP_COUNTRY = 'FR';
    private static final String FINANCIAL_CUST_TAX_CAT = 'MWST';
    private static final String FINANCIAL_CUST_TAX_CLASS = '1';
    private static final String PAYMENT_TERMS = 'F000';
    private static final String INVOICE_DATE = 'Z1';
    private static final String INVOICE_GROUPING = 'RF';
    private static final String GROUPING_TYPE = 'TYC';

    public class BusinessPartnerMsg {

        public String messid { get; set; }
        public String salesforceId { get; set; }
        public String sapId { get; set; }
        public BasicData BasicData;
        public AdditionnalData AdditionnalData;
        public FinancialData FinancialData;
//        public ContactInfo ContactInfo;
        public List<Address> Addresses { get; set; }
        public List<ContactSAP> Contacts { get; set; }

        public BusinessPartnerMsg(Opportunity oppy, Account acc, InvolvedStakeholder__c involvedStakeh, SalesAreaData__c sad, Framework_Agreement__c fag, Map<Id, Contact> cntcts, Map<Id, List<String>> rolesByCntctIds) {

            System.debug('========================== Intf_BusinessPartnerSchemaBuilder BusinessPartnerMsg sad: ' + sad);
            System.debug('========================== Intf_BusinessPartnerSchemaBuilder BusinessPartnerMsg Account: ' + acc);

            account = acc;
            opportunity = oppy;
            involvedStakeholder = involvedStakeh;
            salesAreaData = sad;
            frameworkAgreement = fag;

            this.messid = Intf_GenerallntService.getUMessageId();
            this.salesforceId = account.Id;
            this.sapId = account.Tech_SAP_Id__c;

            this.BasicData = getB2BBasicData();
            this.AdditionnalData = getB2BAdditionnalData();
            this.FinancialData = getB2BFinancialData();
//            this.ContactInfo = getB2BContactInfo();
            this.Addresses = getB2BAddresses();
            this.Contacts = getB2BContacts(cntcts, rolesByCntctIds);

        }

        public BusinessPartnerMsg(Opportunity oppy, Contact cntct, SalesAreaData__c sad) {

            System.debug('=============================== Intf_BusinessPartnerSchemaBuilder BusinessPartnerMsg B2C SAD: ' + sad);

//            account = account;
            opportunity = oppy;
            contact = cntct;
            salesAreaData = sad;

            this.messid = Intf_GenerallntService.getUMessageId();
            this.salesforceId = contact.Id;
            this.sapId = contact.SAP_ID__c;
            this.BasicData = getB2CBasicData();
            this.Addresses = getB2CAddresses();
            this.FinancialData = getB2CFinancialData();
            this.AdditionnalData = getB2CAdditionnalData();

        }
    }

    private static List<ContactSAP> getB2BContacts(Map<Id, Contact> cntcts, Map<Id, List<String>> rolesByContactIds) {

        List<ContactSAP> contacts = new List<ContactSAP>();

        Integer index = 1;
        if ( cntcts==null ) { return contacts ; }

        for (Contact contact : cntcts.values()) {

            List<String> relCat = rolesByContactIds.get(contact.Id);

            if (relCat != null ) {
                ContactSAP contactSAP = new ContactSAP();
                contactSAP.contactInfo = new ContactInfo(contact);
                contactSAP.contactRel = new ContactRel(contact, index, String.join(relCat, ','));

                contacts.add(contactSAP);
                index++;
            }
//            String relCatString = relCat != null ? String.join(relCat, ',') : null;

        }

        return contacts;

    }

    private static BasicData getB2CBasicData() {

        BasicData basicData = new BasicData();

        String searchTerm = contact.FirstName + contact.LastName;

        basicData.category = 1;
        basicData.salutation = String.isNotBlank(contact.Salutation) ? contact.Salutation : 'Monsieur';
        basicData.lastname = contact.LastName;
        basicData.firstname = contact.FirstName;
        basicData.emailAddress = contact.Email;
        basicData.paymentType = '';
        basicData.grouping = 'PF07';
        basicData.partnerRole = PARTNER_ROLE_B2C_DEFAULT;
        basicData.searchTerm = searchTerm.length() >= 20 ? searchTerm.left(20) : searchTerm;
//        basicData.legalEntity = salesAreaData.PFRegion__c;
        basicData.legalEntity = salesAreaData.LegalEntityCode__c;
        basicData.codeLang = String.isBlank(contact.TECH_SAP_Language__c) ? LANGUAGE_DEFAULT : contact.TECH_SAP_Language__c;

        return BasicData;

    }

    private static BasicData getB2BBasicData() {

        BasicData basicData = new BasicData();

        basicData.accountNumber = account.NumeroCompte__c;
        basicData.category = 2;
//        basicData.grouping = account.CategorieCompte__c;
        basicData.grouping = 'PF03';
        basicData.businessPartnerName = account.NomCommercial__c == null ? account.Name : account.NomCommercial__c;
        basicData.companyType = account.DB_Forme_Juridique_Generale__c;
        basicData.activityDescr = account.DB_Description_activite__c;
//        basicData.legalEntity = salesAreaData.PFRegion__c;
        basicData.legalEntity = salesAreaData.LegalEntityCode__c;
        basicData.codeLang = account.TECH_SAP_Language__c == null ? LANGUAGE_DEFAULT : account.TECH_SAP_Language__c;
        basicData.emailAddress = account.DB_Email_Contact__c;
        basicData.partnerRole = involvedStakeholder.Role__c;
        basicData.lastname = account.NomCommercial__c;
        basicData.searchTerm = String.isNotBlank(basicData.businessPartnerName) && basicData.businessPartnerName.length() >= 20 ? basicData.businessPartnerName.left(20) : basicData.businessPartnerName;

        return basicData;

    }

    private static AdditionnalData getB2BAdditionnalData() {

        AdditionnalData additionnalData = new AdditionnalData();

        additionnalData.mainActivity = salesAreaData.BusinessLine__c;
        additionnalData.partnerClass = PARTNER_CLASS_B2B_DEFAULT;
        additionnalData.distriChannel = B2B_DISTRIBUTION_CHANNEL;
        additionnalData.division = B2B_DIVISON;
        additionnalData.salesOrg = salesAreaData.LegalEntityName__c;

        return additionnalData;
    }

    private static AdditionnalData getB2CAdditionnalData() {

        AdditionnalData additionnalData = new AdditionnalData();

        additionnalData.mainActivity = salesAreaData.BusinessLine__c;
        additionnalData.partnerClass = PARTNER_CLASS_B2B_DEFAULT;
        additionnalData.distriChannel = B2B_DISTRIBUTION_CHANNEL;
//        additionnalData.division = B2B_DIVISON;
        additionnalData.division = salesAreaData.BusinessLine__c;
        additionnalData.salesOrg = salesAreaData.LegalEntityName__c;

        return additionnalData;
    }


    private static FinancialData getB2CFinancialData() {

        FinancialData financialData = new FinancialData();

        financialData.departureCountry = FINANCIAL_DEP_COUNTRY;
        financialData.custTaxCategory = FINANCIAL_CUST_TAX_CAT;
        financialData.custTaxClassifaction = FINANCIAL_CUST_TAX_CLASS;
        financialData.paymentTerms = PAYMENT_TERMS;
        financialData.invoiceDate = INVOICE_DATE;
        financialData.invoiceGrouping = INVOICE_GROUPING;
        financialData.groupingType = GROUPING_TYPE;
        financialData.custPriceProcedure = '01';
        financialData.custGroup1 = 'RF';
        financialData.salesDistrict = '000001';
        financialData.orderCombinationAllowed = true;
        financialData.custPriceGroup = '01';
        financialData.currencyCode = opportunity.CurrencyIsoCode;
        financialData.salesOrg = salesAreaData.LegalEntityName__c;
//        financialData.paymentMethod = contact.ModedePaiement__c;
        financialData.paymentMethod = System.Label.Intf_Default_Payment_Methods;

        return financialData;

    }

    private static FinancialData getB2BFinancialData() {

        FinancialData financialData = new FinancialData();

        String paymentMethod = B2B_PAYMENT_METHOD;
        String paymentType = B2B_PAYMENT_TYPE;
        String tax = '';
        String taxType;
        if(String.isBlank(account.DB_Valeur_Taxe__c) && account.Pays__c == 'LUXEMBOURG') {
            tax = account.DB_Valeur_ID_Prefere__c;
            if(String.isNotBlank(tax)){
                taxType = 'Registration Number (LU1)';
            }
        } else {
            tax = account.DB_Valeur_Taxe__c;
            taxType = account.DB_ID_Prefere__c;
        }

        // financialData.taxType = account.DB_ID_Prefere__c;
        financialData.taxType = taxType;
//        financialData.taxNumber = account.DB_Valeur_ID_Prefere__c;
        // financialData.taxNumber = account.DB_Valeur_Taxe__c;
        financialData.taxNumber = tax;
        financialData.salesOrg = salesAreaData.LegalEntityName__c;
        financialData.currencyCode = String.isNotBlank(account.CurrencyIsoCode) ? account.CurrencyIsoCode : 'EUR' ;
//        financialData.condPay = 'Transer'; //TODO check With Roméo
        financialData.language = account.TECH_SAP_Language__c == null ? LANGUAGE_DEFAULT : account.TECH_SAP_Language__c;
        financialData.departureCountry = FINANCIAL_DEP_COUNTRY;
        financialData.custTaxCategory = FINANCIAL_CUST_TAX_CAT;
        financialData.custTaxClassifaction = FINANCIAL_CUST_TAX_CLASS;
        financialData.paymentTerms = PAYMENT_TERMS;
        financialData.invoiceDate = INVOICE_DATE;
        financialData.invoiceGrouping = INVOICE_GROUPING;
        financialData.groupingType = GROUPING_TYPE;
        financialData.custPriceProcedure = '02';
        financialData.orderCombinationAllowed = true;
        financialData.custPriceGroup = '01';
        financialData.salesDistrict = '000001';

        if (frameworkAgreement != null) {
            String fieldSuffix = opportunity.TypeContrat__c;
            System.debug('========================== Intf_BusinessPartnerSchemaBuilder getB2BFinancialData fieldSuffix: ' + fieldSuffix);

            if (String.isNotBlank(fieldSuffix)) {
                String paymentMethodField = 'ModeReglement' + fieldSuffix + '__c';
                String paymentTypeField = 'ModeFacturation' + fieldSuffix + '__c';
                paymentMethod = (String)frameworkAgreement.get(paymentMethodField) != null ? (String)frameworkAgreement.get(paymentMethodField) : paymentMethod;
                paymentType = (String)frameworkAgreement.get(paymentTypeField) != null ? (String)frameworkAgreement.get(paymentTypeField) : paymentType;
            }
        }

//        financialData.paymentMethod = paymentMethod;
        financialData.paymentMethod = System.Label.Intf_Default_Payment_Methods;
        financialData.paymentType = paymentType;

        System.debug('========================== Intf_BusinessPartnerSchemaBuilder getB2BFinancialData paymentMethod: ' + financialData.paymentMethod);
        System.debug('========================== Intf_BusinessPartnerSchemaBuilder getB2BFinancialData paymentType: ' + financialData.paymentType);

        return financialData;

    }

//    private static ContactInfo getB2BContactInfo() {
//
//        ContactInfo contactInfo = new ContactInfo();
//        contactInfo.salutation = CONTACT_SALUTATION_B2B_DEFAULT;
//
//        return contactInfo;
//    }

    private static List<Address> getB2BAddresses() {

        List<Address> addresses = new List<Address>();

        Address address = new Address();
        address.address = account.Ligne1__c;
        address.line2 = account.Ligne2__c;
        address.line3 = account.Ligne3__c;
        address.line4 = account.Ligne4__c;
        address.city = account.Ville__c;
        address.zipCode = account.CodePostal__c;
//        address.state = account.Province__c;
        address.partnerFunction = PARTNER_FUNCTION_INVOICE;
        address.country = account.CodePays__c;

        addresses.add(address);

        return addresses;
    }

    private static List<Address> getB2CAddresses() {

        List<Address> addresses = new List<Address>();

        Address addressInvoice = new Address();
        addressInvoice.address = contact.Ligne1_Facturation__c;
        addressInvoice.city = contact.Ville_Facturation__c;
        addressInvoice.zipCode = contact.Code_Postal_Facturation__c;
        addressInvoice.partnerFunction = PARTNER_FUNCTION_INVOICE;
        addressInvoice.country = contact.PaysFacturation__c;

        addresses.add(addressInvoice);

        Address addressDelivery = new Address();
        addressDelivery.address = contact.Ligne1_Livraison__c;
        addressDelivery.city = contact.Ville_Livraison__c;
        addressDelivery.zipCode = contact.Code_Postal_Livraison__c;
        addressDelivery.partnerFunction = PARTNER_FUNCTION_DELIVERY;
        addressDelivery.country = contact.PaysLivraison__c;

        addresses.add(addressDelivery);

        return addresses;
    }


    public class BasicData {
        public String accountNumber { get; set; }
        public Integer category { get; set; }
        public String grouping { get; set; }
        public String businessPartnerName { get; set; }
        public String companyType { get; set; }
        public String activityDescr { get; set; }
        public String legalEntity { get; set; }
        public String codeLang { get; set; }
        public String paymentType { get; set; }
        public String partnerRole { get; set; }
        public String emailAddress { get; set; }
        public String salutation { get; set; }
        public String lastname { get; set; }
        public String firstname { get; set; }
        public String searchTerm { get; set; }

    }

    public class AdditionnalData {
        public String mainActivity { get; set; }
        public String partnerClass { get; set; }
        public String salesOrg { get; set; }
        public String distriChannel { get; set; }
        public String division { get; set; }

    }

    public class ContactInfo {
        public String salutation { get; set; }
        public String contactType { get; set; }
        public String grouping { get; set; }
        public String language { get; set; }
        public String lastName { get; set; }
        public String firstName { get; set; }
        public String salesforceId { get; set; }

        public ContactInfo(Contact contact) {
            this.salutation = contact.salutation;
            this.contactType = '1';
            this.grouping = '0001';
            this.language = String.isBlank(contact.TECH_SAP_Language__c) ? LANGUAGE_DEFAULT : contact.TECH_SAP_Language__c;
            this.lastName = contact.LastName;
            this.firstName = contact.FirstName;
            this.salesforceId = contact.Id;
        }

    }

    public class FinancialData {

        public String taxType { get; set; }
        public String taxNumber { get; set; }
        public String currencyCode { get; set; }
        public String condPay { get; set; }
        public String paymentType { get; set; }
        public String paymentMethod { get; set; }
        public String language { get; set; }
        public String departureCountry { get; set; }
        public String custTaxCategory { get; set; }
        public String custTaxClassifaction { get; set; }
        public String custPriceProcedure { get; set; }
        public String custPriceGroup { get; set; }
        public Boolean orderCombinationAllowed { get; set; }
        public String custGroup1 { get; set; }
        public String salesDistrict { get; set; }
        public String salesOrg { get; set; }
        public String paymentTerms { get; set; }
        public String invoiceDate { get; set; }
        public String invoiceGrouping { get; set; }
        public String groupingType { get; set; }

    }

    public class Address {

        public String partnerFunction { get; set; }
        public String city { get; set; }
        public String zipCode { get; set; }
        public String address { get; set; }
        public String country { get; set; }
        public String line2 { get; set; }
        public String line3 { get; set; }
        public String line4 { get; set; }
        public String state { get; set; }

    }

    public class ContactSAP {

        public ContactInfo contactInfo { get; set; }
        public ContactRel contactRel { get; set; }
    }

    public class ContactRel {
        public Integer relNumber { get; set; }
        public String contactSapId { get; set; }
        public String startDate { get; set; }
        public String endDate { get; set; }
        public String relCat { get; set ; }
        public String contactFunction { get; set; }
        public String contactService { get; set ;}
        public String mobilePhone { get; set; }
        public String fax { get; set; }
        public String email { get; set; }

        public ContactRel(Contact contact, Integer relNumber, String relCategory) {

            this.relNumber = relNumber;
            this.contactSapId = contact.SAP_ID__c;
            this.startDate = Datetime.now().format('dd/MM/YYYY');
            this.endDate = '31/12/9999';
//            this.relCat = 'Livré,Exploitant,Commerce';
            this.relCat = relCategory;
            this.contactFunction = contact.Fonction__c;
            this.contactService = contact.ServiceDepartement__c;
            this.mobilePhone = contact.MobilePhone;
            this.fax = contact.Fax;
            this.email = contact.Email;
        }
    }
}