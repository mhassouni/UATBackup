@isTest
public class AssetCalendarController_Test {

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
    }
    
    @isTest
    public static void test_getReservations(){
        List<Asset> containers = [SELECT Id FROM Asset];
        Test.startTest();
        List<Reservation__c> reservations = AssetCalendarController.getReservations(containers.get(0).Id);
        Test.stopTest();
        
        System.assertEquals(0, reservations.size());
    }
    
    @isTest
    public static void test_getHolidays(){
        Test.startTest();
        List<Holiday> holidays = AssetCalendarController.getHolidays();
        Test.stopTest();
    }
    
    
    
}