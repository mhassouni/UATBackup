@isTest
public class LC_CustomLookUpController_TEST {
    @isTest
    public static void TestAccount() {

        Account Account1 = new Account();
        Account1.Name = 'Account Test 1';
        Account1.RecordTypeId = Label.ACC_RT_AgencePF;
        Account1.Statut__c = Label.CPT_Statut_Valide;
        Account1.ListeNoire__c = false;

		insert account1;

        Test.startTest();        
        List<Account> accounts = LC_CustomLookUpController.fetchLookUpValues('Account','Account');
        System.assertEquals(1, accounts.size());
        Test.stopTest();    
    } 

    @isTest
    public static void TestServiceResource() {
        List<Profile> profiles = [SELECT Id, Name
                                    FROM Profile
                                    WHERE Name = 'PF Administrateur Système'
                                    LIMIT 1];
        
        System.assertEquals('PF Administrateur Système', profiles[0].Name);

        User user1 = new User(
            profileID = profiles[0].Id,
            LastName = 'Adi',
            Email = 'puser000@worldwideaz.com',
            Username = 'puser000@worldwideaz.com' + System.currentTimeMillis(),
            CompanyName = 'TEST', 
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Country = 'France'
        );

        insert user1;

        ServiceResource serviceResource1 = new ServiceResource();        
        serviceResource1.Name = 'Service One';
        serviceResource1.RelatedRecordId = user1.Id; 

		insert serviceResource1;

        Test.startTest();        
        List<ServiceResource> serviceResources = LC_CustomLookUpController.fetchLookUpValues('Service','ServiceResource');
        System.assertEquals(1, serviceResources.size());
        Test.stopTest();    
    } 

    
}