/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 03-01-2024
 * @last modified by  : Michaël Cabaraux
**/

public abstract class Intf_WebserviceCalloutAbstract {

    public static final Integer MODE_DIRECT = 1;
    public static final Integer MODE_FUTURE = 2;

    private String interfaceType = setInterfaceType();
    private String namedCredential = setNamedCredential();
    private String caller = setCaller();
    private Integer mode = setMode();
    private Map<String, String> headers = setHeaders();
    private String method = setMethod();
    private Map<String, String> tagRemap = setTagRemap();

    private abstract String setInterfaceType();
    private abstract String setNamedCredential();
    private abstract String setCaller();
    private abstract Integer setMode();
    private abstract String setMethod();
    private abstract Map<String, String> setHeaders();
    private abstract Map<String, String> setTagRemap();

    public void doCallout(List<Object> objectPayloads) {
        System.debug('============================ Intf_WebserviceCalloutAbstract doCallout mode: ' + mode);


        if (!objectPayloads.isEmpty()) {
            switch on mode {
                when 1 {
                    // Direct
                    System.debug('============================ Intf_WebserviceCalloutAbstract doCallout Direct calls !!!');
                    List<Intf_WebserviceCalloutService.ResponseModel> responses = new List<Intf_WebserviceCalloutService.ResponseModel>();

                    for (Object payload : objectPayloads) {
                        System.debug('============================ Intf_WebserviceCalloutAbstract doCallout System.objectPayloads.size(): ' + objectPayloads.size());

                        if (System.isBatch()) {
                            System.debug('============================ Intf_WebserviceCalloutAbstract doCallout Batch initiated');
                            responses = Intf_WebserviceCalloutService.calloutWebserviceBatch(JSON.serialize(payload), namedCredential, caller, interfaceType, headers, method, tagRemap);

                        } else {
                            System.debug('============================ Intf_WebserviceCalloutAbstract doCallout direct sending no batch');
                            Intf_WebserviceCalloutService.calloutWebservice(JSON.serialize(payload), namedCredential, caller, interfaceType, headers, method, tagRemap);
                        }
                    }

                    System.debug('============================ Intf_WebserviceCalloutAbstract doCallout System.isBatch(): ' + System.isBatch());

                    if (!Intf_WebserviceCalloutService.responses.isEmpty()) {

                        Intf_WebserviceCallout instance = (Intf_WebserviceCallout)Type.forName(caller).newInstance();

                        for (Intf_WebserviceCalloutService.ResponseModel responseModel : Intf_WebserviceCalloutService.responses) {
                            instance.handleResponse(responseModel.serviceResult, responseModel.payload, responseModel.isTechnicalError);
                            instance.registerMonitoningMessage(method, responseModel.payload, responseModel.responseMessage, interfaceType, responseModel.statusCode, responseModel.isError, false);
                        }
                    }
                }
                when 2 {
                    // Future
                    System.debug('============================ Intf_WebserviceCalloutAbstract doCallout Direct future calls !!! ');

                    //Slicing needed
                    List<List<String>> slicedPayloads = sliceListObjects(objectPayloads, 90);
                    for (List<String> payloads : slicedPayloads)  {
                        String serializedPayloads = JSON.serialize(payloads);
                        Intf_WebserviceCalloutService.fireFutureCallout(serializedPayloads, namedCredential, caller, interfaceType, headers, method, tagRemap);

                    }
                }
            }
        }
    }

    public void registerMonitoningMessage(String method, String outgoingMessage, String responseMessage, String interfaceName, Integer statusCode, Boolean isError, String transactionId, Boolean isResponse) {

        Interface_Monitoring__c intfMonitoring = new Interface_Monitoring__c();

        intfMonitoring.MessageId__c = transactionId;
        intfMonitoring.InterfaceName__c = interfaceName;

        if (!isResponse) {
            intfMonitoring.OutgoingMessage__c = (outgoingMessage!=null && outgoingMessage.length()> 131072) ? outgoingMessage.substring(0, 131071) : outgoingMessage;
            intfMonitoring.Status__c = 'I';
            intfMonitoring.Start_Date__c = System.now();
        }

        intfMonitoring.ResponseMessage__c = (responseMessage!=null && responseMessage.length()> 131072) ?responseMessage.substring(0, 131071) : responseMessage;
        intfMonitoring.Status_Code__c = String.valueOf(statusCode);
        intfMonitoring.End_Date__c = System.now();
        intfMonitoring.Method__c = method;
        intfMonitoring.Status__c = isError ? 'Error' : 'Success';

        upsert intfMonitoring MessageId__c;
    }

    private List<List<String>> sliceListObjects(List<Object> objects, integer maxItems) {

        List<List<String>> slicedList = new List<List<String>>();

        for(Integer i = 0 ; i < (objects.size() / maxItems) + 1 ; i++){
            List<String> lstTemp = new List<String>();
            for(Integer j=(i * maxItems); (j < (i * maxItems)+ maxItems) && j < objects.size(); j++){
                lstTemp.add(JSON.serialize(objects.get(j)));
            }
            slicedList.add(lstTemp);
        }

        return slicedList;
    }

}