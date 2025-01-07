@isTest
public class AllianzWebServiceRest_TEST {
    static void setupTestData() {

        List<allianz_api__c> customList = new List<allianz_api__c>();
        allianz_api__c customTest = new allianz_api__c();
        customTest.Name = 'Company grade';
        customTest.Endpoint__c = 'test';
        customTest.Method__c = 'test';
        customTest.API_KEY__c = 'test';
        customList.add(customTest);

        allianz_api__c customTest2 = new allianz_api__c();
        customTest2.Name = 'New access token';
        customTest2.Endpoint__c = 'test';
        customTest2.Method__c = 'test';
        customTest2.API_KEY__c = 'test';
        customList.add(customTest2);

        allianz_api__c customTest3 = new allianz_api__c();
        customTest3.Name = 'Company search';
        customTest3.Endpoint__c = 'test';
        customTest3.Method__c = 'test';
        customTest3.API_KEY__c = 'test';
        customList.add(customTest3);

        allianz_api__c customTest4 = new allianz_api__c();
        customTest4.Name = 'Covers search';
        customTest4.Endpoint__c = 'test';
        customTest4.Method__c = 'test';
        customTest4.API_KEY__c = 'test';
        customList.add(customTest4);

        allianz_api__c customTest5 = new allianz_api__c();
        customTest5.Name = 'Get jobId';
        customTest5.Endpoint__c = 'test';
        customTest5.Method__c = 'test';
        customTest5.API_KEY__c = 'test';
        customList.add(customTest5);

        allianz_api__c customTest6 = new allianz_api__c();
        customTest6.Name = 'Request grade';
        customTest6.Endpoint__c = 'test';
        customTest6.Method__c = 'test';
        customTest6.API_KEY__c = 'test';
        customList.add(customTest6);

        allianz_api__c customTest7 = new allianz_api__c();
        customTest7.Name = 'Webhook';
        customTest7.Endpoint__c = 'test';
        customTest7.Method__c = 'test';
        customTest7.API_KEY__c = 'test';
        customList.add(customTest7);

        insert customList;

        PolicyId_Legal_Entity__c customPolicy = new PolicyId_Legal_Entity__c();
        customPolicy.Name = 'Test';
        customPolicy.Legal_Entity__c = 'LegalEntity1';
        customPolicy.policyId__c = 'A0028307201';
        customPolicy.Business_Unit_Code__c = 'SFAC';
        customPolicy.Pays__c = 'FRANCE';
        insert customPolicy;

        // Créer des données de test - comptes et enregistrements SalesAreaData__c associés
		
        String recordtypeCLIENT = Label.ACC_RecordTypeId_CompteClient;
        String recordtypePROSPECT = Label.ACC_RecordTypeId_CompteProspect;
        // Création d'un compte GU
        Account guAccount = new Account(RecordTypeId = recordtypeCLIENT, Name='Global Ultimate', DB_DUNS_Number__c='GU1', DB_DUNS_DU__c='GU1', DB_DUNS_GU__c='GU1',  PaysRegionPF__c='DRO IDF 1');
        // Création des comptes enfants DU avec différentes empreintes
        Account child1 = new Account(RecordTypeId = recordtypePROSPECT, Name='Child DU 1', DB_DUNS_Number__c='DU1', DB_DUNS_GU__c='GU1', PaysRegionPF__c='DRO IDF 1',Compte_Parent_legal__c=guAccount.id, IDEulerHermes__c = 'companyIdTest');
        insert new List<Account>{child1, guAccount};
    }

    @isTest
    public static void companyInformationTEST() {
        setupTestData();
        Map<String, String> companyInformationTest = new Map<String, String>();
        companyInformationTest = AllianzWebServiceRest.companyInformation('countryCode', 'nationalIdType', 'nationalIdentifier', 'businessUnitCode', 'policyId');
        System.assert(companyInformationTest.size() > 0);
    }

    @isTest
    public static void validateCompanyTest() {
        setupTestData();
        Account currAccount=Utils_TestMethods.createAccount('Account1',null,null, Label.CPT_RecordTypeId_CompteClient);
        Account accountValidated = AllianzWebServiceRest.validateCompany(currAccount);
        System.assert(accountValidated.Statut__c == 'Validé');
    }

    @isTest
    public static void getCoverInformationTest() {
        setupTestData();
        List<String> companyIds = new List<String>();
        companyIds.add('21753656');
        Map<String, Object> coverInformation = AllianzWebServiceRest.getCoverInformation('businessUnitCode', 'policyId', companyIds);
        System.assert(coverInformation.size() > 0);
    }

    @isTest
    public static void getLastUpdatedAgrementTest() {
        setupTestData();
        List<PolicyId_Legal_Entity__c> policies = PolicyId_Legal_Entity__c.getAll().values();
        Map<String, Object> lastUpdatedAgrementMap = AllianzWebServiceRest.getLastUpdatedAgrement('accessToken', policies);
        System.assert(lastUpdatedAgrementMap.size() > 0);
    }

    @isTest
    public static void requestGradeTest() {
        setupTestData();
        Account acc = [SELECT Id, BillingCountryCode, TypeIdentifiantNational__c, IdentifiantNational__c FROM Account WHERE Name = 'Child DU 1' LIMIT 1];
        String companyId = AllianzWebServiceRest.requestGrade(acc, 'businessUnitCode', 'policyId');
        System.assert(!String.isEmpty(companyId));
    }

    @isTest
    public static void getLastUpdatedGradeTest() {
        setupTestData();
        Map<String, Map<String, String>> gradeByCompanyId = AllianzWebServiceRest.getLastUpdatedGrade('accessToken', 'businessUnitCode', 'policyId');
        System.assert(gradeByCompanyId.size() > 0);
    }

    @isTest
    public static void getAllAgrementTest() {
        setupTestData();
        List<PolicyId_Legal_Entity__c> policies = PolicyId_Legal_Entity__c.getAll().values();
        List<String> companiesId = new List<String>();
        Map<String, Object> agrementByCompanyId = AllianzWebServiceRest.getAllAgrement('accessToken', policies, companiesId);
        System.assert(agrementByCompanyId.size() > 0);
    }

    @isTest
    public static void convertCurrencyWithApexCodeTest() {

        Decimal amount = AllianzWebServiceRest.convertCurrencyWithApexCode('EUR', 50.00);
        System.Assert(amount == 50.00);
    }
}