@RestResource(urlMapping='/gradeWebhook/*')
global with sharing class WebhookHandler {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        Map<String, Object> resp = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());
        AllianzWebServiceRest awr = new AllianzWebServiceRest();
        awr.registerMonitoningMessage('POST', String.valueOf(resp), '', 'GradeWebhook', 200, false, Intf_GenerallntService.getUMessageId(), false);
        Map<String,Object> gradeMap = new Map<String,Object>();
        Map<String, Map<String, String>> gradeByCompanyId = new Map<String, Map<String, String>>();
        if (resp.containsKey('gradePolicyCover')) {
            String companyId = String.valueOf(resp.get('companyId'));
            gradeMap = (Map<String,Object>)resp.get('gradePolicyCover');
            Account accToUpdate = new WithoutSharing().doQuery(companyId);
            accToUpdate.CotationPF__c = Decimal.valueOf(String.valueOf(gradeMap.get('gradeCode')));
            accToUpdate.DateCotationPF__c = Date.valueOf(String.valueOf(gradeMap.get('lastUpdateDate')));
            accToUpdate.Statut_du_grade__c = 'Processed';
            new WithoutSharing().doUpdate(accToUpdate);
        }
    }

    without sharing class WithoutSharing {
        Database.SaveResult doUpdate(SObject record) 
        {
            return Database.update(record);
        }

        Account doQuery(String companyId) {
            return [
                SELECT Id, CotationPF__c, DateCotationPF__c, IDEulerHermes__c 
                FROM Account 
                WHERE IDEulerHermes__c = :companyId
            ];
        }

        Database.SaveResult createChatter(Id accountId) 
        {
            FeedItem feed = new FeedItem();
            feed.ParentId =  accountId;
            feed.Body = 'Message which you want to post';
            return Database.insert(feed);
        }
    }
    
}