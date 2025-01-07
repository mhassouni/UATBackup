@isTest
public class AP09Compte_BATCH_TEST {

    //@isTest
    public static testMethod void launchBatchTest() {
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
       // bypassSetting.BypassTriggers__c = 'AP02Utilisateur'; //To bypass Class
        bypassSetting.BypassValidationRules__c = true; //To bypass Validation Rules
        upsert bypassSetting;
        /////////////////////////////////////////////////////////////////////
        
        UtilsBatch__c ub = new UtilsBatch__c(Name = 'ERG 1');
        insert ub;
        
        insert u1;
        TypeIdentifiantNational__c tin1 = new TypeIdentifiantNational__c(Name = '011',
                                                                        Code__c = 'SIREN',
                                                                        CodePays__c = 'FR',
                                                                        Libelle_fr__c = 'SIREN-FRA');
        insert tin1;
        /*RecordType rd1 = new RecordType(SObjectType='Account', Name = 'Compte Prospect / Client');
        insert rd1;*/
        WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_000',
                                                               EndPoint__c = 'https://api-test.petitforestier.fr/api/services/PFCustomersRepository/Account',
                                                               Methode__c = 'POST',
                                                               UserName__c = 'mdm_sfdc',
                                                               MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                               ContentType__c = 'application/xml',
                                                               ApplicationName__c = 'SFCD',
                                                               Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        insert wspr1;
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
                                   PaysRegionPF__c = 'DO1B', AgencePF__c = '001 - VILLEPINTE', Statut__c = Label.CPT_Statut_Erreur_EH,
                                  IdentifiantNational__c = '343134763',
                                  TypeIdentifiantNational__c = 'SIREN-FRA',
                                  Ligne1Exploitation__c = '42 avenue de Friedland',
                                  VilleExploitation__c = 'PARIS',
                                  CodePostalExploitation__c = '75008',
                                  PaysExploitation__c = 'France');
        insert acc1;
        
        acc1.statut__c = Label.CPT_Statut_Erreur_EH;
        update acc1;
        
        List<Account> accs = new List<Account>();
        accs.add(acc1);
        
        /*batch.start(null);
        batch.execute(null, accs);
        batch.finish(null);*/
        
        Test.startTest();
        AP09Compte_BATCH batch = new AP09Compte_BATCH();
        ID batchprocessid = Database.executeBatch(batch);
        Test.stopTest();
        
        ID batchprocessid_RDD = Database.executeBatch(new AP13Compte_BATCH());
    }
}