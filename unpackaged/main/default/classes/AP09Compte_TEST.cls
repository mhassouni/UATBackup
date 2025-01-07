@isTest
public class AP09Compte_TEST {

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

        insert customList;

        PolicyId_Legal_Entity__c customPolicy = new PolicyId_Legal_Entity__c();
        customPolicy.Name = 'Test';
        customPolicy.Legal_Entity__c = 'LegalEntity1';
        customPolicy.policyId__c = 'A0028307201';
        customPolicy.Business_Unit_Code__c = 'SFAC';
        customPolicy.Pays__c = 'FRANCE';
        insert customPolicy;
    }

    @isTest
    public static void processCreationTEST() {
        setupTestData();
        User u1 = new User(UserName='kevin.test@petitforestier.dev',LastName='Mell',
                          Email='kevin.melliand@ei-tehnologies.com',Alias='kMel',
                           TimeZoneSidKey='Europe/Paris',
                           LocaleSidKey='fr_FR_EURO',
                          EmailEncodingKey='ISO-8859-1',
                           ProfileId=Label.USR_ProfileId_PFReseau,LanguageLocaleKey='fr',
                          DefaultCurrencyIsoCode='EUR');
        /*
         * (alias = 'kbra', email='kbrazi@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='fr',
                            localesidkey='fr_FR_EURO', profileid = p.Id, country='France',
                            timezonesidkey='Europe/Paris', username='KBrazi@noemail.com',
                            IsActive = true);
         * */
         
         //Bypass Validation Rules  or Trigger on Running User////////////////////////////
        Bypass__c bypassSetting=Bypass__c.getInstance(UserInfo.getUserId());
        if (bypassSetting==null){
            bypassSetting=new Bypass__c();
        }
        bypassSetting.BypassValidationRules__c = true; //To bypass Validation Rules
       // bypassSetting.BypassTriggers__c = 'AP02Utilisateur';
        upsert bypassSetting;
        /////////////////////////////////////////////////////////////////////
        
        insert u1;
        TypeIdentifiantNational__c tin1 = new TypeIdentifiantNational__c(Name = '011',
                                                                        Code__c = 'SIREN',
                                                                        CodePays__c = 'FR',
                                                                        Libelle_fr__c = 'SIREN-FRA');
        insert tin1;
        /*RecordType rd1 = new RecordType(SObjectType='Account', Name = 'Compte Prospect / Client');
        insert rd1;*/
        /*WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_000',
                                                               EndPoint__c = 'https://api-test.petitforestier.fr/api/services/PFCustomersRepository/Account',
                                                               Methode__c = 'POST',
                                                               UserName__c = 'mdm_sfdc',
                                                               MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                               ContentType__c = 'application/xml',
                                                               ApplicationName__c = 'SFCD',
                                                               Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;*/
        CodesPays__c cp1 = new CodesPays__c(Name = '053',
                                           Code_Pays__c = 'FRA',
                                           Code_Pays2__c = 'FR',
                                           Libelle_fr__c = 'France');
        insert cp1;
        CodeAgence__c ca1 = new CodeAgence__c(Name = '001',
                                           Numero_Agence__c = '001',
                                           Libelle_fr__c = '001 - VILLEPINTE');
        insert ca1;
        Account acc1 = new Account(Name='AccountTest', RecordTypeId=Label.CPT_RecordTypeId_CompteClient,
                                   PaysRegionPF__c = 'RPF1', AgencePF__c = '001 - VILLEPINTE', Statut__c = Label.CPT_Statut_Draft,
                                  IdentifiantNational__c = '343134763',
                                  TypeIdentifiantNational__c = 'SIREN-FRA',
                                  Ligne1Exploitation__c = '42 avenue de Friedland',
                                  VilleExploitation__c = 'PARIS',
                                  CodePostalExploitation__c = '75008',
                                  PaysExploitation__c = 'France',
                                  Pays__c = 'FRANCE',
                                  Tech_AccountBeforeCreation__c=true);
                                                  
        System.debug('###juste avant le test');
        Test.startTest();
        insert acc1;        
        Test.stopTest();
        AP09Compte.isFirstRun=TRUE;
                 Account acc2 = new Account(Name='AccountTest2', RecordTypeId=Label.CPT_RecordTypeId_CompteClient,
                                   PaysRegionPF__c = 'RPF1', AgencePF__c = '001 - VILLEPINTE', Statut__c = Label.CPT_Statut_Draft,
                                  TypeIdentifiantNational__c = 'SIREN-FRA',
                                  Ligne1Exploitation__c = '42 avenue de Friedland',
                                  VilleExploitation__c = 'PARIS',
                                  CodePostalExploitation__c = '75008',
                                  PaysExploitation__c = 'France',
                                  Pays__c = 'FRANCE',
                                  Tech_AccountBeforeCreation__c = true,
                                  ParentId = acc1.Id);
                                  
        insert acc2;
        System.debug('###On est sortis du test');
        //HttpResponse resp = new HttpResponse();
        //AP09Compte.createLogEH(resp, acc1);
    }
    
    @isTest
    public static void UpdateAccountGradeInformationTEST()
    {
        setupTestData();
        TypeIdentifiantNational__c tin1 = new TypeIdentifiantNational__c(Name = '011',
                                                                        Code__c = 'SIREN',
                                                                        CodePays__c = 'FR',
                                                                        Libelle_fr__c = 'SIREN-FRA');
        insert tin1;
        CodesPays__c cp1 = new CodesPays__c(Name = '053',
                                           Code_Pays__c = 'FRA',
                                           Code_Pays2__c = 'FR',
                                           Libelle_fr__c = 'France');
        insert cp1;
        CodeAgence__c ca1 = new CodeAgence__c(Name = '001',
                                           Numero_Agence__c = '001',
                                           Libelle_fr__c = '001 - VILLEPINTE');
        insert ca1;
        Account account = new Account(Name='AccountTest', RecordTypeId=Label.CPT_RecordTypeId_CompteClient,
                                   PaysRegionPF__c = 'DRO SUD 6', AgencePF__c = '001 - VILLEPINTE', Statut__c = Label.CPT_Statut_Valide,
                                  IdentifiantNational__c = '343134763',
                                  TypeIdentifiantNational__c = 'SIREN-FRA',
                                  Ligne1Exploitation__c = '42 avenue de Friedland',
                                  VilleExploitation__c = 'PARIS',
                                  CodePostalExploitation__c = '75008',
                                  PaysExploitation__c = 'France',
                                  Pays__c = 'FRANCE',
                                  Tech_AccountBeforeCreation__c = true);
        
        
        insert(account);
        Contact Contact1 = Utils_TestMethods.createContact('Contact1',account.Id);
        Contact1.Ligne1__c='42 avenue de Friedland';
        Contact1.Ville__c='PARIS';
        Contact1.CodePostal__c='75008';
        Contact1.Pays__c='France';
        insert Contact1;
        Opportunity opp = Utils_TestMethods.createOpportunity('opp1',Label.OPP_RecordType_Vehicule_DRAFT,Date.today(),account);
        opp.AccountId = account.Id;  
        opp.Amount = 30;
        opp.TypeProduits__c = 'Containers';
        opp.RecordTypeId = Label.OPP_RecordType_Vehicule_DRAFT;
        opp.AgencePF__c = '000 - SIEGE';
        opp.PaysRegionPF__c = 'PFPF';
        
        Test.startTest();
        insert opp;  
        account.CotationPF__c=Decimal.valueOf(8);
        update account;
        Test.stopTest();
    }
    @isTest
    public static void UpdateGradeTEST()
    {
        setupTestData();
        TypeIdentifiantNational__c tin1 = new TypeIdentifiantNational__c(Name = '011',
                                                                        Code__c = 'SIREN',
                                                                        CodePays__c = 'FR',
                                                                        Libelle_fr__c = 'SIREN-FRA');
        insert tin1;
        CodesPays__c cp1 = new CodesPays__c(Name = '053',
                                           Code_Pays__c = 'FRA',
                                           Code_Pays2__c = 'FR',
                                           Libelle_fr__c = 'France');
        insert cp1;
        CodeAgence__c ca1 = new CodeAgence__c(Name = '001',
                                           Numero_Agence__c = '001',
                                           Libelle_fr__c = '001 - VILLEPINTE');
        insert ca1;
        Account account_X = new Account(Name='AccountTest', RecordTypeId=Label.CPT_RecordTypeId_CompteClient,
                                   PaysRegionPF__c = 'RPF1', AgencePF__c = '001 - VILLEPINTE', Statut__c = Label.CPT_Statut_Valide,
                                  IdentifiantNational__c = '343134763',
                                  TypeIdentifiantNational__c = 'SIREN-FRA',
                                  Ligne1Exploitation__c = '42 avenue de Friedland',
                                  VilleExploitation__c = 'PARIS',
                                  CodePostalExploitation__c = '75008',
                                  PaysExploitation__c = 'France',
                                  Pays__c = 'FRANCE',
                                  Tech_AccountBeforeCreation__c = true);
        account_X.TECHIdentifiantNational__c = '343134763';
     
        
        insert(account_X);
        Contact Contact1 = Utils_TestMethods.createContact('Contact1',account_X.Id);
        Contact1.Ligne1__c='42 avenue de Friedland';
        Contact1.Ville__c='PARIS';
        Contact1.CodePostal__c='75008';
        Contact1.Pays__c='France';
        insert Contact1;
        
        
        Test.startTest();
     	
        AP09Compte.UpdateGrade(account_X);
       
        Test.stopTest();
    }

    @isTest
    public static void companyInformationTEST() {
        setupTestData();
        Map<String, String> companyInformationTest = new Map<String, String>();
        companyInformationTest = AllianzWebServiceRest.companyInformation('countryCode', 'nationalIdType', 'nationalIdentifier', 'businessUnitCode', 'policyId');
        System.assert(companyInformationTest.size() > 0);
    }
}