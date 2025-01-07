@isTest
public class OptionsPickerController_Test {
    
    @testSetup
    public static void testSetup(){
        //Containers
        List<Asset> containers = new List<Asset>();
        containers.addAll(TestDataFactory.createContainersWithStatus(5, 'En Atelier', false));
        containers.addAll(TestDataFactory.createContainersWithStatus(5, 'En Location', false));
        containers.addAll(TestDataFactory.createContainersWithStatus(5, 'En Transport', false));
        containers.addAll(TestDataFactory.createContainersWithStatus(10, 'Disponible', false));
        insert containers;
        
        
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
    public static void test_getOptionProducts(){
        Test.startTest();
        List<Product2> options = OptionsPickerController.getOptionProducts();
        Test.stopTest();
        
        System.assertEquals(5, options.size());
    }
    
    @isTest
    public static void test_getOptionInstallees(){
        List<Asset> containers = [SELECT Id FROM Asset];
        Test.startTest();
        Asset container = OptionsPickerController.getOptionInstallees(containers.get(0).Id);
        Test.stopTest();
        
        System.assertEquals(true, container.Options__c != null);
    }
    
}