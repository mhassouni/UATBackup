/**
 * Created by Michael on 01-07-23.
 */

public interface Intf_WebserviceCallout {

    void executeCallout(List<Object> payloadObjects);
    void handleResponse(Intf_ServiceResult serviceResult, String payload, Boolean technicalError);
    void registerMonitoningMessage(String method, String outgoingMessage, String responseMessage, String interfaceName, Integer statusCode, Boolean isError, Boolean isResponse);

}