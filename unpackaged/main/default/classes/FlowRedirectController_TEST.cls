@isTest
public class FlowRedirectController_TEST {
    @isTest
    public static void FlowRedirectControllerTEST(){
        //Controller 
        //FlowRedirectController Cont = new FlowRedirectController();
        //Create WorkOrder
        WorkOrder OT = new WorkOrder();
        OT.RecordTypeId =Label.OT_RecordTypeID_Principal;
        OT.Unique_Flow_Identifier__c='ABCDEFGH1234';
        insert OT;
        //PARAMS
        ApexPages.currentPage().getParameters().put('unique_id','ABCDEFGH1234');
        ApexPages.currentPage().getParameters().put('OBJ','WorkOrder');
        String Unique_id = ApexPages.currentPage().getParameters().get('unique_id');
        String OBJ = ApexPages.currentPage().getParameters().get('OBJ');
        //Page Reference
        String url = '/home/home.jsp';
        PageReference pg = new PageReference(url);
        String pgURL = pg.getUrl();
        //TEST
        Test.startTest();
        FlowRedirectController Cont = new FlowRedirectController();
        PageReference O = Cont.FlowRedirectController();
        String OURL = O.getUrl();
        //system.debug(Cont.FlowRedirectController());
        Test.stopTest();
       	system.assertNotEquals(pgURL, OURL);
    }
}