/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 06-07-2023
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_NetworkService {

    public Intf_ServiceResult execute(Intf_RequestInput requestInput) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setTimeout(requestInput.timeout);
        request.setEndpoint(requestInput.urlString);
        request.setMethod(requestInput.method);

        for (String key : requestInput.headers.keySet()) {
            request.setHeader(key, requestInput.headers.get(key));
        }

        switch on requestInput.method {
//            when 'GET' {
//                request.setBody(buildQueryStrings(requestInput.headers));
//            }
            when 'POST' {
                request.setBody(requestInput.parameters);
                request.setTimeout(120000);
            }
        }

        HttpResponse response = http.send(request);
        Intf_ServiceResult serviceResult = new Intf_ServiceResult(response.getBody(), response.getStatusCode());

        return serviceResult;
    }
}