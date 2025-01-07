@isTest
private class PRG_AlertGoogleControllerTest {
   @isTest
    static   void CurrentLocation_Test(){
        //creation d'une alerte
        Asset asset = new asset();
        asset.Name = 'Name-Asset-XXXX';
        Insert asset;
        
        Alerte__c a = getAlerte(asset, 'Tension batterie basse'); 
        INSERT  a;
        
        WebserviceTelematicsData__c ws = getWebserviceTelematicsData();
        insert ws;
        
        Test.setMock(HttpCalloutMock.class, new MockAlertHttpResponseGenerator());        
        test.startTest();
        PRG_AlertGoogleController.CurrentLocation(string.valueof(a.id)); 
        test.stopTest();
    } 

    @isTest static  void RefreshLowBattery_Test(){

        Asset asset = new asset();
        asset.Name = 'Name-Asset-XXXX';
        Insert asset;
        
        WebserviceTelematicsData__c ws = getWebserviceTelematicsData();
        insert ws;
        
        Alerte__c a = getAlerte(asset, 'Tension batterie basse'); 
        INSERT  a;
        
        Test.setMock(HttpCalloutMock.class, new MockAlertHttpResponseGenerator());        
        Test.startTest();
        PRG_AlertGoogleController.JSonLOwBat = null;
        PRG_AlertGoogleController.RefreshLowBattery(string.valueof(a.id)); 
        Test.stopTest();
    }
    
    @isTest static  void RefreshVoyantMoteur_Test(){

        Asset asset = new asset();
        asset.Name = 'Name-Asset-XXXX';
        Insert asset;
        
        WebserviceTelematicsData__c ws = getWebserviceTelematicsData();
        insert ws;
        
        Alerte__c a = getAlerte(asset, 'Voyant moteur');
        INSERT  a;
        
        Test.setMock(HttpCalloutMock.class, new MockAlertHttpResponseGenerator());        
        test.startTest();
        PRG_AlertGoogleController.JSonLOwBat = null;
        PRG_AlertGoogleController.RefreshLowBattery(string.valueof(a.id)); 
        test.stopTest();
    }
    
    @isTest static  void RefreshCoupureBassePression_Test(){

        Asset asset = new asset();
        asset.Name = 'Name-Asset-XXXX';
        Insert asset;
        
        WebserviceTelematicsData__c ws = getWebserviceTelematicsData();
        insert ws;
        
        Alerte__c a = getAlerte(asset, 'Coupure basse pression');
        a.DateTime_Alerte__c = DateTime.now();
        INSERT  a;
        
        Test.setMock(HttpCalloutMock.class, new MockAlertHttpResponseGenerator());        
        test.startTest();
        PRG_AlertGoogleController.JSonLOwBat = null;
        PRG_AlertGoogleController.RefreshLowBattery(string.valueof(a.id)); 
        test.stopTest();
    }
    
    @isTest static  void LBGraphEvolution_Test(){

        Asset asset = new asset();
        asset.Name = 'Name-Asset-XXXX';
        Insert asset;
        
        WebserviceTelematicsData__c ws = getWebserviceTelematicsData();
        insert ws;
        
        Alerte__c a = getAlerte(asset, 'Tension batterie basse');
		a.DateTime_Alerte__c = DateTime.now();        
        INSERT  a;
        
        Test.setMock(HttpCalloutMock.class, new MockBatteryEvolutionHttpResponse());
        test.startTest();
        List<GraphController.LineChartVar> myLineChartVarList = new List<GraphController.LineChartVar>();
        myLineChartVarList.add(new GraphController.LineChartVar('', 1));
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), 'live'); 
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), '12h'); 
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), '6h'); 
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), '3h'); 
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), ''); 
        test.stopTest();
    }
    
    @isTest static  void LB24GraphEvolution_Test(){

        Asset asset = new asset();
        asset.Name = 'Name-Asset-XXXX';
        Insert asset;
        
        WebserviceTelematicsData__c ws = getWebserviceTelematicsData();
        insert ws;
        
        Alerte__c a = getAlerte(asset, 'Tension batterie basse');
        a.Type_De_Batterie__c = '24 Volts';
        INSERT  a;
        
        Test.setMock(HttpCalloutMock.class, new MockBatteryEvolutionHttpResponse());
        test.startTest();
        List<GraphController.LineChartVar> myLineChartVarList = new List<GraphController.LineChartVar>();
        myLineChartVarList.add(new GraphController.LineChartVar('', 1));
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), 'live'); 
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), '12h'); 
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), '6h'); 
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), '3h'); 
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), ''); 
        test.stopTest();
    }
    
    @isTest static  void VMGraphEvolution_Test(){

        Asset asset = new asset();
        asset.Name = 'Name-Asset-XXXX';
        Insert asset;
        
        WebserviceTelematicsData__c ws = getWebserviceTelematicsData();
        insert ws;
        
        Alerte__c a = getAlerte(asset, 'Voyant moteur');
        INSERT  a;
        
        Test.setMock(HttpCalloutMock.class, new MockVoyantMoteurEvolutionHttpResponse());
        test.startTest();
        //List<GraphController.LineChartVar> myLineChartVarList = new List<GraphController.LineChartVar>();
        //myLineChartVarList.add(new GraphController.LineChartVar('', 1));
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), ''); 
        test.stopTest();
    }
    
    @isTest static  void CBPGraphEvolution_Test(){

        Asset asset = new asset();
        asset.Name = 'Name-Asset-XXXX';
        Insert asset;
        
        WebserviceTelematicsData__c ws = getWebserviceTelematicsData();
        insert ws;
        
        Alerte__c a = getAlerte(asset, 'Coupure basse pression');
        a.Code_Alarme__c = 'A01/P01';
        INSERT  a;
        
        Test.setMock(HttpCalloutMock.class, new MockVoyantMoteurEvolutionHttpResponse());
        test.startTest();
        GraphController.NewRefreshLowBatteryEvolution(string.valueof(a.id), ''); 
        test.stopTest();
    }

    
    @isTest static void dateDiff_Test(){
        DateTime startDate = DateTime.now();
        PRG_AlertGoogleController.dateDifference(startDate.addDays(-1));
        PRG_AlertGoogleController.dateDifference(startDate.addHours(-1));
        PRG_AlertGoogleController.dateDifference(startDate.addMinutes(-10));
            
    	//PRG_AlertGoogleController.dateDifference(startDate);
    }

    static Alerte__c getAlerte(Asset asset, String typeAlerte){
        Alerte__c a =new Alerte__c();
        a.Type_Alerte__c = typeAlerte;        
        a.Statut_du_vehicule__c = 'MOTEUR_TOURNANT_VEHICULE_ROULANT';
        a.Parc__c = asset.id;
        a.Parc_Id__c ='XXXXXX';
        a.Location_Latitude__c  =10.0;
        a.Location_Longitude__c = 10.0 ;        
        return a;
    }
    
    static WebserviceTelematicsData__c getWebserviceTelematicsData(){
        WebserviceTelematicsData__c ws = new WebserviceTelematicsData__c();
        ws.name = 'sandbox-infra-dev';
        ws.Endpoint__c= 'https://data-iot-mcs-5unavwdk4q-ew.a.run.app/secured/basic';
        ws.Authorization__c= 'Basic VXNlclJlc3Q6akFaU1dINFJoUzNrZU1qRThNS055WjZFbWdNWDlXaFo='; 
        ws.Environnement__c= 'dev'; 
        ws.Sandbox__c= 'infra';
        return ws;
    }
        
}