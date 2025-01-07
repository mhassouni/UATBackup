@isTest
public class FleetManagementController_Test {

    public static String reservation_atelierRTID = Schema.SObjectType.Reservation__c.getRecordTypeInfosByDeveloperName().get('Atelier').getRecordTypeId();
    public static String reservation_locationRTID = Schema.SObjectType.Reservation__c.getRecordTypeInfosByDeveloperName().get('Location').getRecordTypeId();
    public static String reservation_transportRTID = Schema.SObjectType.Reservation__c.getRecordTypeInfosByDeveloperName().get('Transport').getRecordTypeId();
    
        
    @testSetup
    public static void testSetup(){
        //Containers
        List<Asset> containers = new List<Asset>();
        containers.addAll(TestDataFactory.createContainersWithStatus(5, 'En Atelier', false));
        containers.addAll(TestDataFactory.createContainersWithStatus(5, 'En Location', false));
        containers.addAll(TestDataFactory.createContainersWithStatus(5, 'En Transport', false));
        containers.addAll(TestDataFactory.createContainersWithStatus(10, 'Disponible', false));
        insert containers;
        
        //Order
        List<Order> orders = TestDataFactory.createOrders(5, null, true);
        
        //Reservations
        List<Reservation__c> reservations = new List<Reservation__c>();
        for(Order order : orders){
            reservations.addAll(TestDataFactory.createReservationsAtelier(1, order.AccountId, order.Id, System.today().addDays(7), false));
            reservations.addAll(TestDataFactory.createReservationsTransport(1, order.AccountId, order.Id, System.today().addDays(15), false));
            reservations.addAll(TestDataFactory.createReservationsLocation(1, order.AccountId, order.Id, System.today().addDays(20), false));
        }
        insert reservations;
        
        //Products
        List<Product2> products = TestDataFactory.createOptionsProducts(5, true);
        Integer count = 0;
        for(Asset container : containers){
            if(count == 5) count = 0;
            container.Options__c = products.get(count).Name;
            count++;
        }
        update containers;
    }
    
    @isTest
    public static void test_getReservations_all(){
        Test.startTest();
        Map<Id, String> recordTypes = FleetManagementController.getRecordTypes('Reservation__c');
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Reservation__c', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Reservation__c', 'Fleet_Management_Result_Fields');
        List<Reservation__c> allReservations = FleetManagementController.getReservations(searchFields, resultFields, null, null);
        Test.stopTest();
        
        System.assertEquals(15, allReservations.size());
    }
    
    @isTest
    public static void test_getReservations_withFilter(){
        Reservation__c filter = new Reservation__c(RecordTypeId = reservation_atelierRTID, Date_de_debut__c = System.today().addDays(7), Date_de_fin__c = System.today().addDays(30));
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Reservation__c', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Reservation__c', 'Fleet_Management_Result_Fields');
        List<Reservation__c> allReservations = FleetManagementController.getReservations(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(5, allReservations.size());
    }
    
    @isTest
    public static void test_getReservations_withFilter3(){
        Account client = [SELECT Id FROM Account LIMIT 1];
        Reservation__c filter = new Reservation__c(Client__c = client.Id);
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Reservation__c', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Reservation__c', 'Fleet_Management_Result_Fields');
        List<Reservation__c> allReservations = FleetManagementController.getReservations(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(15, allReservations.size());
    }
    
    @isTest
    public static void test_getContainers_all(){
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> allContainers = FleetManagementController.getAssets(searchFields, resultFields, null, null);
        Test.stopTest();
        
        System.assertEquals(10, allContainers.size());
    }
    
    @isTest
    public static void test_getContainers_withFilter_Status(){
        Asset filter = new Asset(Status_de_location__c = 'En Atelier;En Location');
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssets(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(10, containers.size());
    }
    
    @isTest
    public static void test_getContainers_withFilter_Status_Periode(){
        List<Asset> allContainers = [SELECT Id FROM Asset];
        List<Reservation__c> reservations = [SELECT Id FROM Reservation__c WHERE RecordTypeId =: reservation_atelierRTID];
        Integer count = 0;
        for(Reservation__c reservation : reservations){
            if(count == allContainers.size()) count = 0;
            reservation.Asset_Assigne__c = allContainers.get(count).Id;
            count++;
        }
        update reservations;
        
        Asset filter = new Asset(Status_de_location__c = 'En Atelier', Date_de_debut_asset__c = System.today());
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssets(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(5, containers.size());
    }
    
    @isTest
    public static void test_getContainers_withFilter_Periode(){
        Asset filter = new Asset(Date_de_debut_asset__c = System.today().addDays(10));
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssets(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(25, containers.size());
    }
    
    @isTest
    public static void test_getContainers_withFilter_Options(){
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        Asset filter = new Asset();
        
        Test.startTest();
        List<Product2> products = FleetManagementController.getOptionProducts();
        filter.Options__c = products.get(0).Name + ';';  
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssets(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(2, containers.size());
    }
    
    @isTest
    public static void test_getContainers_withFilter1(){
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        Asset filter = new Asset(Parc__c = asset.Id, Name = 'Asset', SBQQ__Discount__c  = 1, Temp__c  = 'Test', CurrencyIsoCode = 'EUR;');
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        searchFields.add(new FleetManagementController.Field('Name', 'Name', 'String', false, 255));
        searchFields.add(new FleetManagementController.Field('Temp__c', 'Equipement Article', 'String', false, 255));
        searchFields.add(new FleetManagementController.Field('SBQQ__Discount__c', 'SBQQ__Discount', 'Percent', false, 0));
        searchFields.add(new FleetManagementController.Field('CurrencyIsoCode', 'CurrencyIsoCode', 'Picklist', false, 0));
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssets(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(0, containers.size());
    }
    
    @isTest
    public static void test_getUpdateReservationsFSL(){
        List<Asset> allAssets = [SELECT Id FROM Asset];
        List<Reservation__c> allReservations = [SELECT Id FROM Reservation__c WHERE Asset_Assigne__c = null];
        
        
        Test.startTest();
        FleetManagementController.updateReservationSObjects(new FleetManagementController.EventCalendar(allReservations[0].Id, '2021-01-28', '2021-01-31'), allAssets[0].Id);
        List<Reservation__c> reservations = FleetManagementController.getReservationsFSL(String.valueOf(allAssets[0].Id));
        Test.stopTest();
        
        System.assertEquals([SELECT Id FROM Reservation__c WHERE Asset_assigne__c =: allAssets[0].Id].size(), reservations.size());
    }
    
    @isTest
    public static void test_getReservationSObjects(){
        Test.startTest();
        List<Reservation__c> reservations = FleetManagementController.getReservationSObjects(null);
        Test.stopTest();
        
        System.assertEquals(0, reservations.size());
    }
    
    @isTest
    public static void test_getReservationSObjects_withAsset(){
        List<Asset> allAssets = [SELECT Id FROM Asset];
        List<Reservation__c> allReservations = [SELECT Id FROM Reservation__c WHERE Asset_Assigne__c = null];
        
        
        Test.startTest();
        FleetManagementController.updateReservationSObjects(new FleetManagementController.EventCalendar(allReservations[0].Id, '2021-01-28', '2021-01-31'), allAssets[0].Id);
        List<Reservation__c> reservations = FleetManagementController.getReservationSObjects(String.valueOf(allAssets[0].Id));
        Test.stopTest();
        
        System.assertEquals([SELECT Id FROM Reservation__c WHERE Asset_assigne__c =: allAssets[0].Id].size(), reservations.size());
    }
    
    @isTest
    public static void test_scheduleReservations(){
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        Map<Id, Reservation__c> allReservations = new Map<Id, Reservation__c>([SELECT Id FROM Reservation__c WHERE Asset_Assigne__c = null]);
        
        Test.startTest();
        FleetManagementController.scheduleReservations(asset.Id, new List<Id>(allReservations.keySet()));
        Test.stopTest();
        
        System.assertEquals([SELECT Id FROM Reservation__c WHERE Asset_assigne__c =: asset.Id].size(), allReservations.size());
    }
    
    @isTest
    public static void test_getAssetsFSL(){
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssetsFSL(searchFields, resultFields, null, null);
        Test.stopTest();
        
        System.assertEquals(10, containers.size());
    }
    
    
    @isTest
    public static void test_getAssetsFSL_withFilter_Period(){
        Asset filter = new Asset(Status_de_location__c = 'Disponible;', Date_de_debut_asset__c = System.today().addDays(10));
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssetsFSL(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(25, containers.size());
    }
    
    @isTest
    public static void test_getAssetsFSL_withFilter_Period_2(){
        Asset filter = new Asset(Status_de_location__c = 'Atelier;', Date_de_debut_asset__c = System.today().addDays(-10), Date_de_fin_asset__c = System.today().addDays(10));
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssetsFSL(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(0, containers.size());
    }
    
    @isTest
    public static void test_getAssetsFSL_withFilter_Status(){
        Asset filter = new Asset(Status_de_location__c = 'Atelier;');
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssetsFSL(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(0, containers.size());
    }
    
    @isTest
    public static void test_getAssetsFSL_withFilter_Options(){
        Asset filter = new Asset();
        
        Test.startTest();
        List<Product2> products = FleetManagementController.getOptionProducts();
        filter.Options__c = products.get(0).Name + ';' + products.get(1).Name;  
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssetsFSL(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(4, containers.size());
    }
    
    @isTest
    public static void test_getAssetsFSL_withFilter1(){
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        Asset filter = new Asset(Parc__c = asset.Id, Name = 'Asset', SBQQ__Discount__c  = 1, Temp__c  = 'Test', CurrencyIsoCode = 'EUR;');
        
        Test.startTest();
        List<FleetManagementController.Field> searchFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Search_Fields');
        searchFields.add(new FleetManagementController.Field('Name', 'Name', 'String', false, 255));
        searchFields.add(new FleetManagementController.Field('Temp__c', 'Equipement Article', 'String', false, 255));
        searchFields.add(new FleetManagementController.Field('SBQQ__Discount__c', 'SBQQ__Discount', 'Percent', false, 0));
        searchFields.add(new FleetManagementController.Field('CurrencyIsoCode', 'CurrencyIsoCode', 'Picklist', false, 0));
        List<FleetManagementController.Field> resultFields = FleetManagementController.getFieldSet('Asset', 'Fleet_Management_Result_Fields');
        List<Asset> containers = FleetManagementController.getAssetsFSL(searchFields, resultFields, null, filter);
        Test.stopTest();
        
        System.assertEquals(0, containers.size());
    }
    
    @isTest
    public static void test_getOrder(){
        Order order = [SELECT Id FROM ORDER LIMIT 1];
        
        Test.startTest();
        FleetManagementController.getOrder(order.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void test_getHolidayRecords(){
        Test.startTest();
        FleetManagementController.getHolidayRecords();
        Test.stopTest();
    }
}