/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 22-04-2023
 * @last modified by  : Michaël Cabaraux
**/

@IsTest
private class Intf_RequestInput_Test {
    @IsTest
    static void testBehavior() {

        Intf_RequestInput request1 = new Intf_RequestInput('url1', 'POST', 'params');

        System.assertEquals('params', request1.parameters);

        Intf_RequestInput request2 = new Intf_RequestInput('url2', 'POST', 'params', new Map<String, String>{'test' => 'test'});

        System.assertEquals('test', request2.headers.get('test'));

    }
}