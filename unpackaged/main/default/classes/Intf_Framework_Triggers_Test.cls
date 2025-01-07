/**
 * Created by Michael on 27-09-24.
 */

@IsTest
private class Intf_Framework_Triggers_Test {
    @IsTest
    static void testBehavior() {

        Intf_Framework_Triggers.clearHandlerBypass('Test');
        Intf_Framework_Triggers.clearAllHandlerBypasses();
        Intf_Framework_Triggers.handlerBypass('Test');
        Boolean test = Intf_Framework_Triggers.isHandlerBypassed('Test');

        System.assertEquals(true, test);

    }
}