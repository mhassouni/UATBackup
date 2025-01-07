/**
 * Created by Michael on 27-03-24.
 */


public with sharing class Intf_WebserviceCalloutKwote extends Intf_WebserviceCalloutAbstract implements Intf_WebserviceCallout {

    public static Map<String, String> headers;
    private List<String> fieldList = new List<String>{'DB_Valeur_ID_Prefere__c', 'DB_Valeur_Autre__c', 'DB_Valeur_Taxe__c', 'DB_Autre_Identifiant_National__c'};


    private String setInterfaceType() {
        return 'Kwote';
    }

    private String setNamedCredential() {
        return 'Intf_Kwote';
    }

    private String setCaller() {
        return 'Intf_WebserviceCalloutKwote';
    }

    private Boolean setQueueing() {
        return false;
    }

    private Integer setMode() {

        if (System.isBatch() || System.isFuture()) {
            return intf_WebserviceCalloutAbstract.MODE_DIRECT;
        } else {
            return Intf_WebserviceCalloutAbstract.MODE_FUTURE;
        }

    }

    private String setMethod() {
        return 'GET';
    }

    private Map<String, String> setHeaders() {

        return headers;
    }

    private Map<String, String> setTagRemap() {
        return new Map<String, String>();
    }

    public void executeCallout(List<Object> payloadObjects) {

        super.doCallout(payloadObjects);
    }

    public void handleResponse(Intf_ServiceResult serviceResult, String payload, Boolean technicalError) {

        List<KwoteMessage> kwoteMessages = (List<KwoteMessage>)JSON.deserialize(serviceResult.body, List<KwoteMessage>.class);
        System.debug('============================== Intf_WebserviceCalloutKwote handleResponse kwoteMessages#: ' + kwoteMessages.size());

        Map<String, List<SalesAreaData__c>> sadsByIdentifiers = new Map<String, List<SalesAreaData__c>>();
        Map<Id, SalesAreaData__c> sadsToUpdate = new Map<Id, SalesAreaData__c>();
        Map<String, KwoteMessage> kwoteMessagesByIndentifiantIds = new Map<String, KwoteMessage>();

        String legalEntityPayload = payload.remove('"');
        List<String> legalEntities = legalEntityPayload.split(',');
        System.debug('============================== Intf_WebserviceCalloutKwote handleResponse legalEntityPayload : ' + legalEntityPayload);

        for (KwoteMessage kwoteMessage : kwoteMessages) {
            System.debug('============================== Intf_WebserviceCalloutKwote handleResponse kwoteMessages: ' + kwoteMessage);
            if (String.isNotBlank(kwoteMessage.identifiantLegal)) {

                if (kwoteMessage.codePays != null) {
                    String code2Char = kwoteMessage.codePays.left(2);
//                    System.debug('============================== Intf_WebserviceCalloutKwote handleResponse code2Char: ' + code2Char);
                    if (kwoteMessage.identifiantLegal.contains(code2char)) {
                        kwoteMessagesByIndentifiantIds.put(kwoteMessage.identifiantLegal, kwoteMessage);
                    } else {
                        kwoteMessagesByIndentifiantIds.put(kwoteMessage.identifiantLegal, kwoteMessage);
                        kwoteMessagesByIndentifiantIds.put(code2Char + kwoteMessage.identifiantLegal, kwoteMessage);
                    }

                } else {
                    kwoteMessagesByIndentifiantIds.put(kwoteMessage.identifiantLegal, kwoteMessage);
                }
            }
        }

        Set<String> legalIdentifiers = kwoteMessagesByIndentifiantIds.keySet();

        for (SalesAreaData__c sad : [
                SELECT Id, LatePayment__c, Account__r.DB_Valeur_ID_Prefere__c, Account__r.DB_Valeur_Autre__c, Account__r.DB_Valeur_Taxe__c, Account__r.DB_Autre_Identifiant_National__c,
                        Encours__c, Score__c
                FROM SalesAreaData__c
                WHERE PFRegion__c in :legalEntities
                AND (Account__r.DB_Valeur_ID_Prefere__c in :legalIdentifiers
                    OR Account__r.DB_Valeur_Autre__c in :legalIdentifiers OR Account__r.DB_Valeur_Taxe__c in :legalIdentifiers OR Account__r.DB_Autre_Identifiant_National__c in :legalIdentifiers)]) {

            Account accountLink = sad.Account__r;
            for (String fieldNameApi :fieldList) {

                String value = (String)accountLink.get(fieldNameApi);
                    if (String.isNotBlank(value)) {
                         if(!sadsByIdentifiers.containsKey(value)) {
                             sadsByIdentifiers.put(value, new List<SalesAreaData__c>());
                         }

                        List<SalesAreaData__c> sads = sadsByIdentifiers.get(value);
                        sads.add(sad);
                    }
            }
        }

        System.debug('============================== Intf_WebserviceCalloutKwote handleResponse salesAreaDatas# : ' + sadsByIdentifiers.size());

        for (String legalIdentifier : sadsByIdentifiers.keySet()) {
//            System.debug('============================== Intf_WebserviceCalloutKwote handleResponse SAD legalIdentifier : ' + legalIdentifier);

            KwoteMessage kwoteMessage = kwoteMessagesByIndentifiantIds.get(legalIdentifier);

            if (kwoteMessage != null) {
                for (SalesAreaData__c sad : sadsByIdentifiers.get(legalIdentifier)) {
//                    System.debug('============================== Intf_WebserviceCalloutKwote handleResponse added kwoteMessage : ' + kwoteMessage);
                    if (!isSameInfo(sad, kwoteMessage)) {
                        sadsToUpdate.put(sad.Id, new SalesAreaData__c(
                                Id = sad.Id,
                                Encours__c = kwoteMessage.enCours,
                                Score__c = kwoteMessage.profilPayeur,
                                LatePayment__c = kwoteMessage.retard
                        ));
                    }
                }
            } else {
//                System.debug('============================== Intf_WebserviceCalloutKwote handleResponse no kwote message for  : ' + legalIdentifier);
            }
        }

        System.debug('============================== Intf_WebserviceCalloutKwote handleResponse sadsToUpdate# : ' + sadsToUpdate.size());
        if (!sadsToUpdate.isEmpty()) {
            List<Database.SaveResult> results = Database.update(sadsToUpdate.values(), false);
        }
    }

    public void registerMonitoningMessage(String method, String outgoingMessage, String responseMessage, String interfaceName, Integer statusCode, Boolean isError, Boolean isResponse) {

        System.debug('================================ Intf_WebserviceCalloutKwote registerMonitoningMessage method: ' + method);
        System.debug('================================ Intf_WebserviceCalloutKwote registerMonitoningMessage outgoingMessage: ' + outgoingMessage);
        System.debug('================================ Intf_WebserviceCalloutKwote registerMonitoningMessage interfaceName: ' + interfaceName);

        super.registerMonitoningMessage(method, outgoingMessage, responseMessage, interfaceName, statusCode, isError, Intf_GenerallntService.getUMessageId(), isResponse);

    }

    private Boolean isSameInfo(SalesAreaData__c sad, KwoteMessage kwoteMessage) {


        return (sad.Encours__c == kwoteMessage.enCours)
                && (sad.Score__c == kwoteMessage.profilPayeur)
                && (sad.LatePayment__c == kwoteMessage.retard);

    }

    public class KwoteMessage {

        public Decimal retard { get; set; }
        public Decimal enCours { get; set; }
        public Decimal retard30Jours { get; set; }
        public Decimal encoursDisponible { get; set; }
        public Decimal risque { get; set; }
        public Decimal profilPayeur { get; set; }
        public String identifiantLegal { get; set; }
        public String codePays { get; set; }

    }

}