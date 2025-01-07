/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 22-04-2023
 * @last modified by  : Michaël Cabaraux
**/

global class Intf_WebserviceMock implements HttpCalloutMock {
    public static Integer status;
    public static String interfaceToTest;


    global HTTPResponse respond(HTTPRequest request) {

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');

        if (status == 200) {

            if (interfaceToTest == 'KWOTE') {
                Intf_WebserviceCalloutKwote.KwoteMessage kwoteMessage = new Intf_WebserviceCalloutKwote.KwoteMessage();
                kwoteMessage.codePays = 'BE';
                kwoteMessage.identifiantLegal = 'BE0547562822';
                kwoteMessage.enCours = 1;
                kwoteMessage.encoursDisponible = 1;
                kwoteMessage.retard = 1;
                kwoteMessage.retard30Jours = 1;
                kwoteMessage.risque = 1;
                kwoteMessage.profilPayeur = 1;

                List<Intf_WebserviceCalloutKwote.KwoteMessage> kwoteMessages = new List<Intf_WebserviceCalloutKwote.KwoteMessage>{kwoteMessage};

                response.setBody(JSON.serialize(kwoteMessages));

            } else {
                response.setBody('OK');
            }
            response.setStatusCode(200);

        } else if (status == 403) {

            response.setStatusCode(403);

            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Unauthorized endpoint');
            throw e;

        }

//        switch on interfaceToTest {
//            when 'TEST' {
//
//            }
//        }

        return response;
    }
}