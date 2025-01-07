/*
* @Author Sara Barakat
* @TestClass for AP02Contact
*/
@isTest
private class AP02Contact_TEST {

    static testMethod void MAJPrenomMajusculesTest() {      
        Bypass__c MyBypass = Utils_TestMethods.createBypass(UserInfo.getUserId());
        MyBypass.BypassValidationRules__c = true;
        insert MyBypass;
    
        Account account1 = Utils_TestMethods.createAccount( 'Account1', null, null, Label.CPT_RecordTypeId_CompteClient);
        insert account1;
        
        Contact contact1 = Utils_TestMethods.createContact('Contact1',Account1.Id);
        contact1.firstname='jean paul';
        insert contact1;
        contact1=[select id, firstname from contact where id=:contact1.id];
        System.assertequals('Jean Paul',contact1.firstname);
        contact1.firstname='jean-paul';
        update contact1;
        contact1=[select id, firstname from contact where id=:contact1.id];
        System.assertequals('Jean-Paul',contact1.firstname);  
        
        Contact contact2 = Utils_TestMethods.createContact('Contact2',Account1.Id);
        contact2.firstname='jEan';
        insert contact2;
        contact2=[select id, firstname from contact where id=:contact2.id];
        System.assertequals('Jean',contact2.firstname);
        contact2.firstname='jEan Paul';
        update contact2;
        contact2=[select id, firstname from contact where id=:contact2.id];
        System.assertequals('Jean Paul',contact2.firstname); 
        contact2.firstname='jEan-pAul';
        update contact2;
        contact2=[select id, firstname from contact where id=:contact2.id];
        System.assertequals('Jean-Paul',contact2.firstname); 
        contact2.firstname='jEan-pAul junior';
        update contact2;
        contact2=[select id, firstname from contact where id=:contact2.id];
        System.assertequals('Jean-Paul Junior',contact2.firstname); 
        
        List<Contact> listContact = new List<Contact>();
        Contact contact01= Utils_TestMethods.createContact('Contact01',Account1.Id);
        contact01.firstname='jean paul gaultier';
        listContact.add(contact01);
        Contact contact02= Utils_TestMethods.createContact('Contact02',Account1.Id);
        contact02.firstname='jeAN-paUl junior';
        listContact.add(contact02);  
        Contact contact03= Utils_TestMethods.createContact('Contact03',Account1.Id);
        contact03.firstname='mariE-jOSé-juNior';
        listContact.add(contact03); 
        insert listContact;
        contact01=[select id, firstname from contact where lastname='Contact01'];
        System.assertequals('Jean Paul Gaultier',contact01.firstname); 
        contact02=[select id, firstname from contact where lastname='Contact02'];
        System.assertequals('Jean-Paul Junior',contact02.firstname);
        contact03=[select id, firstname from contact where lastname='Contact03'];
        System.assertequals('Marie-José-Junior',contact03.firstname);        
                    
    }
}