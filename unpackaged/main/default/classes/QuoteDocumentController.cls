public class QuoteDocumentController { 
    public String url { get; set; } 
    private static List<SFCPQ_Integration_Settings__mdt> integrationSettingsList = SFCPQ_Integration_Settings__mdt.getAll().values();
    private static List<SFCPQ_Fields_Mapping_Settings__mdt> fieldsMappingSettingsList = SFCPQ_Fields_Mapping_Settings__mdt.getAll().values();
  
    public QuoteDocumentController() { 
        String recordid = ApexPages.currentPage().getParameters().get('recordid'); 
        String accessToken = ApexPages.currentPage().getParameters().get('token'); 
        String action = ApexPages.currentPage().getParameters().get('action'); 
  
        SFCPQ_Integration_Settings__mdt integrationSettings = integrationSettingsList[0];
        String routerParameter = isFSSOEnabled(integrationSettings) ? '/fed/' + integrationSettings.IDP_Route__c + '/integrations' : '/integrations';
        String authTokenParameter = isFSSOEnabled(integrationSettings) ? '' : '&authtoken=' + accessToken; 
        if (action == 'create') { 
            this.url = integrationSettings.CPQ_Environment_URL__c + routerParameter + '/crm/landing?action=create' + 
                                '&opportunityid=' + recordid + 
                                '&apisessionid=' + UserInfo.getSessionId() + 
                                authTokenParameter; 
        } else {
             //action = 'edit', 'view', 'new'
            List<SFCPQ_Fields_Mapping_Settings__mdt> fieldsMappingSettingsList = SFCPQ_Fields_Mapping_Settings__mdt.getAll().values(); 
            if (! fieldsMappingSettingsList.isEmpty()) { 
                SFCPQ_Fields_Mapping_Settings__mdt fieldsMappingSettings = fieldsMappingSettingsList[0]; 
                String query = 'SELECT Name, ' + fieldsMappingSettings.Quote_ID_Field_API_Name__c + ', ' + 
                                        fieldsMappingSettings.CPQ_Owner_ID_Field_API_Name__c + ', ' + 
                                        fieldsMappingSettings.Opportunity_ID_Field_API_Name__c + ' ' + 
                                'FROM ' + fieldsMappingSettings.SF_SObject_API_Name__c + ' ' + 
                                'WHERE Id = \'' + recordid + '\' ' + 
                                'LIMIT 1'; 
                system.debug('recordid mo recordid:'+recordid);system.debug('debug mo action '+action);
                SObject sobj = Database.query(query); 
                this.url = integrationSettings.CPQ_Environment_URL__c + routerParameter + '/crm/landing?action=' + action + '&quotenumber=' + sobj.get('Name') + 
                                '&quoteid=' + sobj.get(fieldsMappingSettings.Quote_ID_Field_API_Name__c) + 
                                '&ownerid=' + sobj.get(fieldsMappingSettings.CPQ_Owner_ID_Field_API_Name__c) + 
                                '&opportunityid=' + sobj.get(fieldsMappingSettings.Opportunity_ID_Field_API_Name__c) + 
                                '&apisessionid=' + UserInfo.getSessionId() + 
                                authTokenParameter; 
                system.debug('debug mo URL '+url);
            } 
        }
    } 
    
  
    @AuraEnabled 
    public static String getAccessToken() { 
        SFCPQ_Integration_Settings__mdt integrationSettings = integrationSettingsList[0];
        String username = returnAuthUsername(integrationSettings);
        validateUsername(username);
        String accessToken;
        if (! isFSSOEnabled(integrationSettings)) {
            String jwtToken = SecurityService.generateJWT('HS256',
                                    username,
                                    integrationSettings.SF_Environment_URL__c, 
                                    integrationSettings.CPQ_Environment_URL__c, 
                                    5, 
                                    integrationSettings.JWT_Token_Signing_Key__c); 
            accessToken = generateAccessToken(jwtToken, integrationSettings);
            validateAccessToken(accessToken);
        }
        return accessToken; 
    } 
  
  
    private static String generateAccessToken(String jwtToken, SFCPQ_Integration_Settings__mdt integrationSettings) { 
        String accessToken; 
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST'); 
        req.setHeader('Content-Type','application/x-www-form-urlencoded'); 
        req.setEndpoint(integrationSettings.CPQ_Environment_URL__c + '/oauth2/token'); 
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(integrationSettings.Client_Identifier__c + ':' + integrationSettings.Client_Secret__c))); 
        req.setBody('grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer' + 
                    '&assertion=' + jwtToken + 
                    '&domain=' + integrationSettings.CPQ_Environment__c); 
        Http http = new Http(); 
        HTTPResponse response = http.send(req); 
                     
        if (response.getStatusCode() == 200) { 
            Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody()); 
            accessToken = responseMap.containsKey('access_token') ? String.valueOf(responseMap.get('access_token')) : null; 
        } 
        system.debug('Mo debug response :'+response);system.debug('Mo debug token:'+accessToken);
        return accessToken; 
    }
    
    
    private static String returnAuthUsername(SFCPQ_Integration_Settings__mdt integrationSettings) {
        String username = UserInfo.getUserName();
        if (integrationSettings.Use_SFCPQ_Usernames_Mapping__c == true) {
            List<SFCPQ_Usernames_Mapping_Settings__c> usernamesMapping = [
                SELECT SF_User__r.Username, CPQ_Username__c
                FROM SFCPQ_Usernames_Mapping_Settings__c 
                WHERE SF_User__r.Username = :username
                LIMIT 1];
            username = ! usernamesMapping.isEmpty() ? usernamesMapping[0].CPQ_Username__c : null;
            if (Test.isRunningTest()) { username = UserInfo.getUserName(); }
        }
        return username;
    }


    private static Boolean isFSSOEnabled(SFCPQ_Integration_Settings__mdt integrationSettings) {
        return (integrationSettings.FSSO__c && String.isNotBlank(integrationSettings.IDP_Route__c));
    }


    private static void validateUsername(String username) {
        username = Test.isRunningTest() ? UserInfo.getUserName() : username;
        if (username == null) {
            throw new AuraHandledException('Please contact Admin to add "' + UserInfo.getUserName() + '" to the User Mappings table.');
        }
    }


    private static void validateAccessToken(String accessToken) {
        if (accessToken == null) {
            throw new AuraHandledException('Please contact Admin to verify authentication setup in SAP CPQ and Salesforce.');
        }
    }
}