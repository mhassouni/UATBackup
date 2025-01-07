/**
 * @description       :
 * @author            : Yannick Ecard
 * @group             :
 * @last modified on  : 02-05-2024
 * @last modified by  : Yannick Ecard
**/

public with sharing class AllianzWebServiceRest {

    //Method to retrieved company Information
    public static Map<String, String> companyInformation(String countryCode, String nationalIdType, String nationalIdentifier, String businessUnitCode, String policyId){
        Map<String, String> companyInformation = new Map<String, String>();
        Map<String, Object> coverInformation = new Map<String, String>();
        Map<String, String> companyIdByStatusCode = new Map<String, String>();
        //Retrieve access token
        String accessToken = getNewAccessToken();
        if(accessToken != null && accessToken != ''){
            //Retrieve companyId
            companyIdByStatusCode.putAll(getCompanyInformation(accessToken, countryCode, nationalIdType, nationalIdentifier));
            if(companyIdByStatusCode.get('companyId') != null && companyIdByStatusCode.get('companyId') != ''){
                companyInformation.put('companyId', companyIdByStatusCode.get('companyId'));
                // Retrieve coverId
                coverInformation = searchCover(accessToken, businessUnitCode, policyId, new List<String>{companyIdByStatusCode.get('companyId')});
                if(coverInformation.size() > 0) {
                    Map<String, Object> coverInformationMap = (Map<String, Object>)coverInformation.get(companyIdByStatusCode.get('companyId'));
                    companyInformation.put('coverId', (String)coverInformationMap.get('coverId'));
                    //Retrieve grade and last refreshed date
                    companyInformation.putAll(getGradeInformation(accessToken, companyIdByStatusCode.get('companyId'), (String)coverInformationMap.get('coverId')));
                }
            }
        }
        return companyInformation;
    }
    public static String requestGrade(Account acc, String businessUnitCode, String policyId) {
        String companyId;
        String jobId;
        Map<String, String> companyIdByStatusCode = new Map<String, String>();
        
        //Retrieve access token
        String accessToken = getNewAccessToken();
        if(accessToken != null && accessToken != ''){
            //Retrieve companyId
            companyIdByStatusCode.putAll(getCompanyInformation(accessToken, acc.BillingCountryCode, acc.TypeIdentifiantNational__c, acc.IdentifiantNational__c));
            if(companyIdByStatusCode.get('statusCode') == '200' || companyIdByStatusCode.get('statusCode') == '206'){
                companyId = companyIdByStatusCode.get('companyId');
                if(companyId != null && companyId != '') {
                    jobId = getJobIdForGradeRequest(accessToken, businessUnitCode, policyId, companyId);
                }
            }
        }
        return companyId;
    }

    public static Map<String, Object> getCoverInformation(String businessUnitCode, String policyId, List<String> companysId){
        Map<String, Object> coverInformation = new Map<String, String>();
        String accessToken = getNewAccessToken();
        if(accessToken != null && accessToken != ''){
            // Retrieve coverId
            coverInformation = searchCover(accessToken, businessUnitCode, policyId, companysId);
        }
        return coverInformation;
    }

    // Method to check if company exist into Allianz WS
    public static Account validateCompany (Account acc) {
        Map<String, String> companyIdByStatusCode = new Map<String, String>();
        //Retrieve access token
        String accessToken = getNewAccessToken();
        if(accessToken != null && accessToken != ''){
            //Retrieve companyId
            companyIdByStatusCode.putAll(getCompanyInformation(accessToken, acc.BillingCountryCode, acc.TypeIdentifiantNational__c, acc.IdentifiantNational__c));
            if(companyIdByStatusCode.get('statusCode') == '200' || companyIdByStatusCode.get('statusCode') == '206'){
                acc.Statut__c = 'Validé';
                acc.IDEulerHermes__c = companyIdByStatusCode.get('companyId');
            } else if(companyIdByStatusCode.get('statusCode') == '204') {
                acc.Statut__c = 'Bloqué';
            } else {
                acc.Statut__c = 'Erreur EH';
            }
        } else {
            acc.Statut__c = 'Erreur EH';
        }
        return acc;
    }

    @future(callout = true)
    public static void validateCompanyForTrigger(Set<ID> recordIds) {
        Map<String, String> companyIdByStatusCode = new Map<String, String>();
        List<Account> accountList = new List<Account>();
        //Retrieve access token
        String accessToken = getNewAccessToken();
            //Retrieve companyId
            for(Account acc : [SELECT Id, BillingCountryCode, TypeIdentifiantNational__c, IdentifiantNational__c, Statut__c, IDEulerHermes__c FROM Account WHERE Id IN :recordIds]) {
                if(accessToken != null && accessToken != ''){
                    companyIdByStatusCode.putAll(getCompanyInformation(accessToken, acc.billingCountryCode, acc.TypeIdentifiantNational__c, acc.IdentifiantNational__c));
                    if(companyIdByStatusCode.get('statusCode') == '200' || companyIdByStatusCode.get('statusCode') == '206'){
                        acc.Statut__c = 'Validé';
                        acc.IDEulerHermes__c = companyIdByStatusCode.get('companyId');
                    } else if(companyIdByStatusCode.get('statusCode') == '204') {
                        acc.Statut__c = 'Bloqué';
                    } else {
                        acc.Statut__c = 'Erreur EH';
                    }
                } else {
                    acc.Statut__c = 'Erreur EH';
                }
                accountList.add(acc);
            }
            update accountList;
    }

    public static String getNewAccessToken() {
        String newAccessToken = '';
        try {
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            
            //Set information for HTTP call
            request.setEndpoint(allianz_api__c.getInstance('New access token').Endpoint__c);
            request.setMethod(allianz_api__c.getInstance('New access token').Method__c);
            request.setHeader('Content-Type', 'application/json');
    
            //Set body
            String requestBody = '{ "apiKey": "' + allianz_api__c.getInstance('New access token').API_KEY__c + '" }';
            request.setBody(requestBody);
            if(Test.isRunningTest()) {
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"access_token":"test"}');
                response.setStatusCode(200);
            } else {
                response = Http.send(request);
            }
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                //Parse request to read data
                JSONParser parser = JSON.createParser(responseBody);
                while(parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                        String fieldName = parser.getText();
                        parser.nextToken();
                        if(fieldName == 'access_token'){
                            newAccessToken = parser.getText();
                        }
                    }
                }
                System.debug('New Access Token Obtained.');
                return newAccessToken;
            } else {
                System.debug('Error occurred during authorization: ' + response.getStatusCode()  + '| ' + response.getBody());
                return newAccessToken;
            }
            
        } catch (Exception e) {
            System.debug('Error occurred during authorization: ' + e.getMessage());
            throw e;
        }
    }
    
    public static Map<String, String> getCompanyInformation(String accessToken, String countryCode, String nationalIdType, String nationalIdentifier){
        String responseBody;
        Map<String, String> companyIdByStatusCode = new Map<String, String>();
        try {
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            
            //Set information for HTTP call
            request.setEndpoint(allianz_api__c.getInstance('Company search').Endpoint__c);
            request.setMethod(allianz_api__c.getInstance('Company search').Method__c);
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            //Set body
            String requestBody = '{"countryCode": "' + countryCode + '", "idTypeCode": "' + nationalIdType + '", "idValue": "' + nationalIdentifier + '"}';
            request.setBody(requestBody);
            if(Test.isRunningTest()) {
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"companyId":"companyIdTest"}');
                response.setStatusCode(200);
            } else {
                response = Http.send(request);
            }
            companyIdByStatusCode.put('statusCode', String.valueOf(response.getStatusCode()));
            if (response.getStatusCode() == 200 || response.getStatusCode() == 206) {
                responseBody = response.getBody();
                //Parse request to read data
                JSONParser parser = JSON.createParser(responseBody);
                while(parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                        String fieldName = parser.getText();
                        parser.nextToken();
                        if(fieldName == 'companyId'){
                            companyIdByStatusCode.put('companyId', parser.getText());
                        }
                    }
                }
                return companyIdByStatusCode;
            } else if(response.getStatusCode() == 401) {
                return getCompanyInformation(getNewAccessToken(), countryCode, nationalIdType, nationalIdentifier);
            } else {
                System.debug('Call failed with status code: ' + response.getStatusCode() + '| ' + response.getBody());
                return companyIdByStatusCode;
            }
        } catch (Exception e) {
            System.debug('Exception during call: ' + e.getMessage());
            throw e;
        }
    }
    
    public static Map<String, Object> searchCover(String accessToken, String businessUnitCode, String policyId, List<String> companyIds) {
        String responseBody;
        Map<String, Object> cover = new Map<String, Object>();
        try {
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();

            //Set information for HTTP call
            request.setEndpoint(allianz_api__c.getInstance('Covers search').Endpoint__c);
            request.setMethod(allianz_api__c.getInstance('Covers search').Method__c);
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            //Set body
            String requestBody = '{"policies": [{"businessUnitCode": "' + businessUnitCode + '", "policyId": "'+ policyId +'"}], "companyIds": '+ JSON.serialize(companyIds) +'}';
            
            request.setBody(requestBody);
            if(Test.isRunningTest()) {
                response.setHeader('Content-Type', 'application/json');
                response.setBody('[{"coverId":"coverIdTest","lastUpdateDate":"2023-02-21", "totalAmount":400000, "companyId":"companyIdTest"}]');
                response.setStatusCode(200);
            } else {
                response = Http.send(request);
            }
            if (response.getStatusCode() == 200) {
                responseBody = response.getBody();
                //Parse request to read data
                List<Object> resp = (List<Object>)JSON.deserializeUntyped(responseBody);
                for(Object obj : resp) {
                    Map<String, Object> coverInformation = (Map<String, Object>)obj;
                    cover.put((String)coverInformation.get('companyId'), new Map<String, Object>{'coverId' => (String)coverInformation.get('coverId'), 'lastUpdateDate' => (String)coverInformation.get('lastUpdateDate'), 'totalAmount' => (Integer)coverInformation.get('totalAmount')});
                }
                return cover;
            } else if(response.getStatusCode() == 401) {
                return searchCover(getNewAccessToken(), businessUnitCode, policyId, companyIds);
            } else {
                System.debug('Call failed with status code: ' + response.getStatusCode() + '| ' + response.getBody());
                return cover;
            }
        } catch (Exception e) {
            System.debug('Exception during call: ' + e.getMessage());
            throw e;
        }
    }
    
    public static Map<String, String> getGradeInformation(String accessToken, String companyId, String coverId) {
        String responseBody;
        Map<String, String> grade = new Map<String, String>();
        try {
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            
            //Set information for HTTP call
            request.setEndpoint(allianz_api__c.getInstance('Company grade').Endpoint__c + companyId + '?coverId=' + coverId);
            request.setMethod(allianz_api__c.getInstance('Company grade').Method__c);
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            if(Test.isRunningTest()) {
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"gradeCode":"01", "lastRefreshDate":"2023-02-21"}');
                response.setStatusCode(200);
            } else {
                response = Http.send(request);
            }
            if (response.getStatusCode() == 200) {
                responseBody = response.getBody();
                //Parse request to read data
                JSONParser parser = JSON.createParser(responseBody);
                while(parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                        String fieldName = parser.getText();
                        parser.nextToken();
                        if(fieldName == 'gradeCode'){
                            grade.put(fieldName, parser.getText());
                        }
                        if(fieldName == 'lastRefreshDate'){
                            grade.put(fieldName, parser.getText());
                        }
                    }
                }
                return grade;
            } else if(response.getStatusCode() == 401) {
                return getGradeInformation(getNewAccessToken(), companyId, coverId);
            } else {
                System.debug('Call failed with status code: ' + response.getStatusCode() + '| ' + response.getBody());
                return grade;
            }
        } catch (Exception e) {
            System.debug('Exception during call: ' + e.getMessage());
            throw e;
        }
    }

    public static String getJobIdForGradeRequest(String accessToken, String businessUnitCode, String policyId, String companyId) {
        String jobId;
        try {
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();

            //Set information for HTTP call
            request.setEndpoint(allianz_api__c.getInstance('Request grade').Endpoint__c);
            request.setMethod(allianz_api__c.getInstance('Request grade').Method__c);
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Custom-Webhook', EncodingUtil.base64Encode(Blob.valueOf('{"callbackUrl": "'+ allianz_api__c.getInstance('Webhook').Endpoint__c +'","timeToLive": 24,"extendedNotification":true}')));
            //Set body
            String requestBody = '{"requestTypeCode": "GradePolicyCoverDeluxe", "policy" : {"businessUnitCode": "'+ businessUnitCode + '", "policyId": "' + policyId +'"}, "companyId" : "' + companyId + '"}';
            request.setBody(requestBody);
            if(Test.isRunningTest()) {
                response.setHeader('Content-Type', 'application/json');
                response.setBody('6cfb9b80-449b-4a0a-82fb-edea07d44414');
                response.setStatusCode(202);
            } else {
                response = Http.send(request);
            }
            if (response.getStatusCode() == 202) {
                jobId = response.getBody();
                return jobId;
            } else if(response.getStatusCode() == 401) {
                return getJobIdForGradeRequest(getNewAccessToken(), businessUnitCode, policyId, companyId);
            } else {
                System.debug('Call failed with status code: ' + response.getStatusCode() + '| ' + response.getBody());
                return jobId;
            }
        } catch (Exception e) {
            System.debug('Exception during call: ' + e.getMessage());
            throw e;
        }
    }

    public static Map<String, Map<String, String>> getLastUpdatedGrade(String accessToken, String businessUnitCode, String policyId) {
        String responseBody;
        Map<String, Map<String, String>> gradeByCompanyId = new Map<String, Map<String, String>>();
        LastUpdatedGradeWrapper LastUpdatedGradeWrapperbody = new LastUpdatedGradeWrapper(businessUnitCode, policyId);
        try {
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();

            //Set information for HTTP call
            request.setEndpoint(allianz_api__c.getInstance('Covers search').Endpoint__c);
            request.setMethod(allianz_api__c.getInstance('Covers search').Method__c);
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            //Set body
            String requestBody = JSON.serialize(LastUpdatedGradeWrapperbody);
            request.setBody(requestBody);
            if(Test.isRunningTest()) {
                response.setHeader('Content-Type', 'application/json');
                response.setBody('[{"companyId": "companyIdTest", "lastUpdateDate": "2024-06-13", "gradePolicyCoverGradeCode": "04"}]');
                response.setStatusCode(200);
            } else {
                response = Http.send(request);
            }
            if (response.getStatusCode() == 200) {
                responseBody = response.getBody();
                //Parse request to read data
                List<Object> resp = (List<Object>)JSON.deserializeUntyped(responseBody);
                for(Object obj : resp) {
                    Map<String, Object> gradeInformation = (Map<String, Object>)obj;
                    gradeByCompanyId.put((String)gradeInformation.get('companyId'), new Map<String, String>{'grade' => (String)gradeInformation.get('gradePolicyCoverGradeCode'), 'lastUpdateDate' => (String)gradeInformation.get('lastUpdateDate')});
                }
                return gradeByCompanyId;
            } else if(response.getStatusCode() == 401) {
                return getLastUpdatedGrade(getNewAccessToken(), businessUnitCode, policyId);
            } else {
                System.debug('Call failed with status code: ' + response.getStatusCode() + '| ' + response.getBody());
                return gradeByCompanyId;
            }
        } catch (Exception e) {
            System.debug('Exception during call: ' + e.getMessage());
            throw e;
        }
    }

    public static Map<String, Map<String,Object>> getLastUpdatedAgrement(String accessToken, List<PolicyId_Legal_Entity__c> policies) {
        String responseBody;
        Map<String, Map<String,Object>> agrementByCompanyId = new Map<String, Map<String,Object>>();
        List<policiesWrapper> policiesWrapperList = new List<policiesWrapper>();
        for(PolicyId_Legal_Entity__c policy : policies) {
            policiesWrapperList.add(new policiesWrapper(policy.Business_Unit_Code__c, policy.policyId__c.substringAfter('A')));
        }
        LastUpdatedAgrement LastUpdatedAgrementWrapperbody = new LastUpdatedAgrement(policiesWrapperList);
        try {
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();

            //Set information for HTTP call
            request.setEndpoint(allianz_api__c.getInstance('Covers search').Endpoint__c);
            request.setMethod(allianz_api__c.getInstance('Covers search').Method__c);
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            //Set body
            request.setBody(JSON.serialize(LastUpdatedAgrementWrapperbody));
            if(Test.isRunningTest()) {
                response.setHeader('Content-Type', 'application/json');
                response.setBody('[{"coverId":"coverIdTest","lastUpdateDate":"2023-02-21", "totalAmount":400000, "companyId":"companyIdTest", "policy": {"policyId": "0028307201","businessUnitCode": "SFAC"}}]');
                response.setStatusCode(200);
            } else {
                response = Http.send(request);
            }
            if (response.getStatusCode() == 200) {
                responseBody = response.getBody();
                //Parse request to read data
                List<Object> resp = (List<Object>)JSON.deserializeUntyped(responseBody);
                for(Object obj : resp) {
                    Map<String, Object> agrementInformation = (Map<String, Object>)obj;
                    if(!agrementByCompanyId.containsKey((String)agrementInformation.get('companyId'))){
                        agrementByCompanyId.put((String)agrementInformation.get('companyId'), new Map<String, Map<String, Object>>{(String)((Map<String,Object>)agrementInformation.get('policy'))?.get('policyId') => new Map<String, Object>{'coverId' => (String)agrementInformation.get('coverId'), 'lastUpdateDate' => (String)agrementInformation.get('lastUpdateDate'), 'totalAmount' => (Integer)agrementInformation.get('totalAmount')}});
                    }else {
                        agrementByCompanyId.get((String)agrementInformation.get('companyId')).put((String)((Map<String,Object>)agrementInformation.get('policy'))?.get('policyId'), new Map<String, Object>{'coverId' => (String)agrementInformation.get('coverId'), 'lastUpdateDate' => (String)agrementInformation.get('lastUpdateDate'), 'totalAmount' => (Integer)agrementInformation.get('totalAmount')}) ;
                    }
                }
                return agrementByCompanyId;
            } else if(response.getStatusCode() == 401) {
                return getLastUpdatedAgrement(getNewAccessToken(), policies);
            } else {
                System.debug('Call failed with status code: ' + response.getStatusCode() + '| ' + response.getBody());
                return agrementByCompanyId;
            }
        } catch (Exception e) {
            System.debug('Exception during call: ' + e.getMessage());
            throw e;
        }
    }

    public static Map<String, Map<String,Object>> getAllAgrement(String accessToken, List<PolicyId_Legal_Entity__c> policies, List<String> companiesId) {
        String responseBody;
        Map<String, Map<String,Object>> agrementByCompanyId = new Map<String, Map<String,Object>>();
        List<policiesWrapper> policiesWrapperList = new List<policiesWrapper>();
        for(PolicyId_Legal_Entity__c policy : policies) {
            policiesWrapperList.add(new policiesWrapper(policy.Business_Unit_Code__c, policy.policyId__c.substringAfter('A')));
        }
        allAgrementWrapper allAgrementWrapperbody = new allAgrementWrapper(policiesWrapperList, companiesId);
        try {
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();

            //Set information for HTTP call
            request.setEndpoint(allianz_api__c.getInstance('Covers search').Endpoint__c);
            request.setMethod(allianz_api__c.getInstance('Covers search').Method__c);
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            //Set body
            request.setBody(JSON.serialize(allAgrementWrapperbody));
            if(Test.isRunningTest()) {
                response.setHeader('Content-Type', 'application/json');
                response.setBody('[{"coverId":"coverIdTest","lastUpdateDate":"2023-02-21", "totalAmount":400000, "companyId":"companyIdTest", "policy": {"policyId": "0028307201","businessUnitCode": "SFAC"}}]');
                response.setStatusCode(200);
            } else {
                response = Http.send(request);
            }
            if (response.getStatusCode() == 200 || response.getStatusCode() == 206) {
                responseBody = response.getBody();
                //Parse request to read data
                List<Object> resp = (List<Object>)JSON.deserializeUntyped(responseBody);
                for(Object obj : resp) {
                    Map<String, Object> agrementInformation = (Map<String, Object>)obj;
                    if(!agrementByCompanyId.containsKey((String)agrementInformation.get('companyId'))){
                        agrementByCompanyId.put((String)agrementInformation.get('companyId'), new Map<String, Map<String, Object>>{(String)((Map<String,Object>)agrementInformation.get('policy'))?.get('policyId') => new Map<String, Object>{'coverId' => (String)agrementInformation.get('coverId'), 'lastUpdateDate' => (String)agrementInformation.get('lastUpdateDate'), 'totalAmount' => (Integer)agrementInformation.get('totalAmount')}});
                    }else {
                        agrementByCompanyId.get((String)agrementInformation.get('companyId')).put((String)((Map<String,Object>)agrementInformation.get('policy'))?.get('policyId'), new Map<String, Object>{'coverId' => (String)agrementInformation.get('coverId'), 'lastUpdateDate' => (String)agrementInformation.get('lastUpdateDate'), 'totalAmount' => (Integer)agrementInformation.get('totalAmount')}) ;
                    }
                }
                return agrementByCompanyId;
            } else if(response.getStatusCode() == 401) {
                return getAllAgrement(getNewAccessToken(), policies, companiesId);
            } else {
                System.debug('Call failed with status code: ' + response.getStatusCode() + '| ' + response.getBody());
                return agrementByCompanyId;
            }
        } catch (Exception e) {
            System.debug('Exception during call: ' + e.getMessage());
            throw e;
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

    public class LastUpdatedAgrement {
        public List<policiesWrapper> policies{get;set;}
        public List<String> coverTypeCodes{get;set;}
        public String minLastUpdateDate{get;set;}
        public String maxLastUpdateDate{get;set;}
        public paginationWrapper pagination{get;set;}
        public List<sortsWrapper> sorts{get;set;}

        public LastUpdatedAgrement(List<policiesWrapper> policiesId) {

            policies = new List<policiesWrapper>();
            policies.addAll(policiesId);
            coverTypeCodes = new List<String>{'gradePolicyCover'};
            minLastUpdateDate = String.valueOf(Date.today().addDays(-1));
            maxLastUpdateDate = String.valueOf(Date.today());
            pagination = new paginationWrapper(1, 10000, true);
            sorts = new List<sortsWrapper>();
            sorts.add(new sortsWrapper('companyName', 'DESC'));
        }
    }

    public static Decimal convertCurrencyWithApexCode(String toCurrency, Decimal amount) {
        Map<String, Decimal> conversionRates = new Map<String, Decimal>();
        CurrencyType cT = [SELECT ConversionRate FROM CurrencyType WHERE IsoCode = :toCurrency];

        amount = amount * cT.conversionRate;
        
        return amount;
    }

    public class allAgrementWrapper {
        public List<policiesWrapper> policies{get;set;}
        public List<String> companyIds{get;set;}

        public allAgrementWrapper(List<policiesWrapper> policiesId, List<String> companiesId) {
            policies = new List<policiesWrapper>();
            companyIds = new List<String>();
            policies.addAll(policiesId);
            companyIds.addAll(companiesId);
        }
    }

    public class LastUpdatedGradeWrapper {
        public List<policiesWrapper> policies{get;set;}
        public List<String> coverTypeCodes{get;set;}
        public List<String> coverSubTypeCodes{get;set;}
        public String minLastUpdateDate{get;set;}
        public String maxLastUpdateDate{get;set;}
        public paginationWrapper pagination{get;set;}
        public List<sortsWrapper> sorts{get;set;}

        public LastUpdatedGradeWrapper(String businessUnitCode, String policyId) {

            policies = new List<policiesWrapper>();
            policies.add(new policiesWrapper(businessUnitCode, policyId));
            coverTypeCodes = new List<String>{'gradePolicyCover'};
            coverSubTypeCodes = new List<String>{'Deluxe'};
            minLastUpdateDate = String.valueOf(Date.today().addDays(-1));
            maxLastUpdateDate = String.valueOf(Date.today());
            pagination = new paginationWrapper(1, 10000, true);
            sorts = new List<sortsWrapper>();
            sorts.add(new sortsWrapper('companyName', 'DESC'));
        }
    }
    public class policiesWrapper {
        public String businessUnitCode{get;set;}
        public String policyId{get;set;}

        public policiesWrapper(String businessUnitCode, String policyId) {
            this.businessUnitCode = businessUnitCode;
            this.policyId = policyId;
        }
    }
    public class paginationWrapper {
        public Integer page{get;set;}
        public Integer pageSize{get;set;}
        public Boolean isTotalRequired{get;set;}

        public paginationWrapper(Integer page, Integer pageSize, Boolean isTotalRequired) {
            this.page = page;
            this.pageSize = pageSize;
            this.isTotalRequired = isTotalRequired;
        }
    }
    public class sortsWrapper {
        public String attributeName{get;set;}
        public String orderTypeCode{get;set;}

        public sortsWrapper(String attributeName, String orderTypeCode) {
            this.attributeName = attributeName;
            this.orderTypeCode = orderTypeCode;
        }
    }

}