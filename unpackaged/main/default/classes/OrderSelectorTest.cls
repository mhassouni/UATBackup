/**
* @Version: 1.0
* @Author: Remz Grges
* -----------------------------------------------------------------------------------------------
* Description: Test class for OrderSelector class
* Created: 27/08/2021
** -----------------------------------------------------------------------------------------------
*/
@IsTest
public with sharing class OrderSelectorTest {
    @IsTest
    static void testGetOrdersById() {
        Id accountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Compte_Client').getRecordTypeId();
        Account acc = Utils_TestMethods.createAccount('Test', 'Test', null, accountRTId);
        acc.Statut__c = 'Validé';
        insert acc;

        Id contactRT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Commercial').getRecordTypeId();

        Contact contact = Utils_TestMethods.createContact('My Contact', acc.Id);
        contact.RecordTypeId = contactRT;
        insert contact;

        Opportunity opportunity = Utils_TestMethods.createOpportunity('Test oppty', '1 - Opportunité créée', Date.today(), acc);
        opportunity.Type_Location__c = 'Courte Durée';
        insert opportunity;


        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Opportunity2__c = opportunity.Id;
        insert quote;

        Order order = new Order();
        order.AccountId = acc.Id;
        order.EffectiveDate = Date.today();
        order.EndDate = Date.today().addDays(20);
        order.Status = 'Draft';
        order.blng__BillingDayOfMonth__c = '7';
        insert order;

        Test.startTest();

        IOrderSelector orderSelector = new OrderSelector();
        Map<Id, Order> getOrdersByIds = orderSelector.getOrdersByIds(new Set<Id> {order.Id});
        Test.stopTest();
        System.assertEquals(1,getOrdersByIds.size());
    }
}