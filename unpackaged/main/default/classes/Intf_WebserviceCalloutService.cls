/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 03-01-2024
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_WebserviceCalloutService {

    public static final String SYNCED_STATUS = 'Sync';
    public static final String SYNC_IN_PROGRESS_STATUS = 'InProgress';
    public static final String SYNC_PAS_SYNCHRO_STATUS = 'Notsync';
    public static final String TO_BE_FIXED_STATUS = 'Error';
    public static final String WORK_ORDER_PROP = 'WorkOrderMsg';

    public static List<Intf_WebserviceCalloutService.ResponseModel> responses = new List<Intf_WebserviceCalloutService.ResponseModel>();

    @future(callout=true)
    public static void fireFutureCallout(String jsonPayload, String namedCredential, String caller, String interfaceName, Map<String, String> headers, String method, Map<String, String> tagRemap) {

        Intf_WebserviceCallout instance = (Intf_WebserviceCallout)Type.forName(caller).newInstance();

        List<String> payloads = (List<String>)JSON.deserialize(jsonPayload, List<String>.class);

        for (String payload : payloads) {

            calloutWebservice(payload, namedCredential, caller, interfaceName, headers, method, tagRemap);
        }

        System.debug('==============================  Intf_WebserviceCalloutService Intf_WebserviceCalloutService fireFutureCallout !!:' + responses);

        for (Intf_WebserviceCalloutService.ResponseModel responseModel : responses) {
            instance.handleResponse(responseModel.serviceResult, responseModel.payload, responseModel.isTechnicalError);
            instance.registerMonitoningMessage(method, responseModel.payload, responseModel.responseMessage, interfaceName, responseModel.statusCode, responseModel.isError, false);
        }
    }

    public static List<Intf_WebserviceCalloutService.ResponseModel> calloutWebserviceBatch(String jsonPayload, String namedCredential, String caller, String interfaceName, Map<String, String> headers, String method, Map<String, String> tagRemap) {

        System.debug('==============================  Intf_WebserviceCalloutService calloutWebserviceBatch callout Webservice Batch !!:' + namedCredential);


        calloutWebservice(jsonPayload, namedCredential, caller, interfaceName, headers, method, tagRemap);

        System.debug('==============================  Intf_WebserviceCalloutService calloutWebserviceBatch:' + responses);

        return responses;

    }

    public static void calloutWebservice(String jsonPayload, String namedCredential, String caller, String interfaceName, Map<String, String> headers, String method, Map<String, String> tagRemap) {

        System.debug('==============================  Intf_WebserviceCalloutService calloutWebservice namedCredential:' + namedCredential);

        Boolean isError = true;
        Boolean isTechnicalError = false;
        String responseMessage;
        Integer statusCode;

        String urlString = 'callout:' +namedCredential;

        if (method == 'GET') {
//            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonPayload.remove('"').replaceAll('@','"'));
//
//            urlString = urlString + '/' + (String)responseMap.get('parameter');
        }

        System.debug('==============================  Intf_WebserviceCalloutService calloutWebservice urlString:' + urlString);
        String remappedPayload = remapTagInPayload(jsonPayload, tagRemap);

        Intf_RequestInput requestInput = new Intf_RequestInput(urlString, method, remappedPayload);

        if (headers != null && !headers.isEmpty()) {
            requestInput.headers = headers;
        }

        Intf_NetworkService network = new Intf_NetworkService();
        Intf_ServiceResult serviceResult;

        try {
            serviceResult = network.execute(requestInput);

            responseMessage = serviceResult.body;
            statusCode = serviceResult.statusCode;

            if ((serviceResult.statusCode == 200) || (serviceResult.statusCode == 201)) {
                if (serviceResult.isSuccess) {
                    isError = false;

                }
            } else {
                isTechnicalError = true;
            }
            System.debug('==============================  Intf_WebserviceCalloutService calloutWebservice isError:' + isError);
            System.debug('==============================  Intf_WebserviceCalloutService calloutWebservice isTechnicalError:' + isTechnicalError);

        } catch (Exception e) {
            isError = true;
            isTechnicalError = true;
            responseMessage = e.getMessage();
            statusCode = 999;

            serviceResult = new Intf_ServiceResult(responseMessage, statusCode);

        }

        Intf_WebserviceCallout instance = (Intf_WebserviceCallout)Type.forName(caller).newInstance();

        if (!System.isFuture() && !System.isBatch()) {
            instance.handleResponse(serviceResult, jsonPayload, isTechnicalError);
            instance.registerMonitoningMessage(method, jsonPayload, responseMessage, interfaceName, statusCode, isError, false);

        } else {

            responses.add(new Intf_WebserviceCalloutService.ResponseModel(method, responseMessage, jsonPayload, statusCode, isTechnicalError, isError, serviceResult));
        }
    }

    public static String remapTagInPayload(String serializedPayload, Map<String, String> tagRemap) {

        String remappedString = serializedPayload;

        if (tagRemap!= null && !tagRemap.isEmpty()) {
            for (String origTag : tagRemap.keySet()) {

                String replacingTag = tagRemap.get(origTag);
                remappedString = remappedString.replace(origTag, replacingTag);
            }
        }

        return remappedString;
    }

    public class ResponseModel {

        public Boolean isTechnicalError { get; set; }
        public Boolean isError { get; set; }
        public String responseMessage { get; set; }
        public String payload { get; set; }
        public Integer statusCode { get; set; }
        public Intf_ServiceResult serviceResult { get; set; }
        public String method { get; set; }

        public responseModel(String method, String responseMessage, String payload, Integer statusCode, Boolean isTechnicalError, Boolean isError,  Intf_ServiceResult serviceResult) {
            this.isError = isError;
            this.isTechnicalError = isTechnicalError;
            this.responseMessage = responseMessage;
            this.statusCode = statusCode;
            this.payload = payload;
            this.serviceResult = serviceResult;
            this.method = method;
        }
    }

}