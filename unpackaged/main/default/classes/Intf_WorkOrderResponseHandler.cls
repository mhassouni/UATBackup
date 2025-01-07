/**
 * Created by Michael on 20-03-24.
 */

public with sharing class Intf_WorkOrderResponseHandler implements Intf_ResponseHandlerInterface {

    private static final String OK_SAP_STATUS = 'S';
    private static final String ERROR_SAP_STATUS = 'E';
    private static final String INCOMING_SAP_STATUS = 'I';
    private static final String TREATMENT_OK = 'Done';
    private static final String TREATMENT_ERROR = 'Error';
    private static final String WO_RECTYPE_YARD_CHECK = 'Tour_de_parc';
    private static final String WO_RECTYPE_YARD_CHECK_RO = 'Tour_de_parc_Lecture_Seule';
    private static final String WO_RECTYPE_YARD_CHECK_HAT = 'Tour_de_parc_Chapeau';

    private static Map<String,String> agenceIdsByNames = new Map<String,String>();
    private static Map<String,String> accountIdsBySapAccountIds = new Map<String,String>();
    private static Map<String,String> assetIdsByNames = new Map<String,String>();
    private static Map<String,Workorder> workOrdersBySapIds = new Map<String,Workorder>();
    private static Map<String,Workorder> parentWorkOrdersBySapIds = new Map<String,Workorder>();

    private static Id woRecTypeROId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get(WO_RECTYPE_YARD_CHECK_RO).getRecordTypeId();
    private static Id woRecTypeHATId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get(WO_RECTYPE_YARD_CHECK_HAT).getRecordTypeId();

    public void handleResponses(List<Interface_Response__c> newMessages) {

        //We receive from SAP no need to send it back !!!
        Intf_Framework_Triggers.handlerBypass('sendWorkOrderToSAP');

        List<Interface_Response__c> interfaceResponsesToUpdate = new List<Interface_Response__c>();
        List<WorkOrder> workordersToUpdate = new List<WorkOrder>();

        populateWorkOrderMaps(newMessages);

        for (Interface_Response__c interfaceResponse : newMessages) {

            Interface_Response__c intRepToUpdate = new Interface_Response__c(
                    Id = interfaceResponse.Id
            );

            switch on interfaceResponse.Status__c {
                when 'S' {
                    // Success

                    try {
                        workordersToUpdate.add(new WorkOrder(
                                Id = interfaceResponse.CRM_Number__c,
                                Intf_Sync_Status__c = 'Sync',
                                Intf_Synchronisation_Message__c = null,
                                SAP_ID__c = interfaceResponse.ERP_Number__c

                        ));

                        intRepToUpdate.Treatment_Status__c = TREATMENT_OK;

                    } catch (Exception e) {
                        intRepToUpdate.Treatment_Status__c = TREATMENT_ERROR;
                        intRepToUpdate.Treatment_Message__c = e.getMessage();
                    }

                }
                when 'E' {
                    // Errors

                    workordersToUpdate.add(new WorkOrder(
                            Id = interfaceResponse.CRM_Number__c,
                            Intf_Sync_Status__c = 'Error',
                            Intf_Synchronisation_Message__c = interfaceResponse.Response_Message__c
                    ));

                    intRepToUpdate.Treatment_Status__c = TREATMENT_OK;
                }
                when 'I' {
                    // Tour de parce et changement de status
                    System.debug('===================== Intf_WorkOrderResponseHandler handleResponses Tour de parce et changement de status');

                    try {

                        Intf_WorkOrderSAPMessage workOrderSAPMessage = (Intf_WorkOrderSAPMessage)JSON.deserialize(interfaceResponse.Response_Message__c, Intf_WorkOrderSAPMessage.class);
                        System.debug('===================== Intf_WorkOrderResponseHandler handleResponses workOrderSAPMessage : ' + workOrderSAPMessage);

                        String sapId = workOrderSAPMessage.basicData.sapid;
                        if (String.isBlank(sapId)) { throw new Intf_Exception('Pas de SAP Id pour le workorder '); }

                        if (!accountIdsBySapAccountIds.containsKey(workOrderSAPMessage.basicData.sapaccountId)) { throw new Intf_Exception('Pas de compte correspondant au sap id ' + workOrderSAPMessage.basicData.sapaccountId + ' dans Salesforce'); }

                        if (workOrderSAPMessage.basicData.type == WO_RECTYPE_YARD_CHECK) {
                            System.debug('===================== Intf_WorkOrderResponseHandler handleResponses Tour de parc confirmed');

                            // Check if parent WO exists

                            if (!parentWorkOrdersBySapIds.containsKey(sapId)) {
                                //Create new HAT WO + children WO
                                WorkOrder parentWO = new WorkOrder(
                                        Status = workOrderSAPMessage.basicData.statut,
                                        RecordTypeId = woRecTypeHATId,
                                        AccountId = accountIdsBySapAccountIds.get(workOrderSAPMessage.basicData.sapaccountId),
                                        Agence_Intervenante__c = agenceIdsByNames.containsKey(workOrderSAPMessage.basicData.agenceintervenante) ? agenceIdsByNames.get(workOrderSAPMessage.basicData.agenceintervenante) : null,
                                        SAP_ID__c = sapId,
                                        Intf_Sync_Status__c = 'Sync'
                                );
                                insert parentWO;
                                System.debug('===================== Intf_WorkOrderResponseHandler handleResponses parentWO: ' + parentWO);

                                List<WorkOrder> childrenWOs = new List<WorkOrder>();

                                for (Intf_WorkOrderSAPMessage.Parc parc : workOrderSAPMessage.parcs) {

                                    if (!assetIdsByNames.containsKey(parc.numasset)) { throw new Intf_Exception('Pas d\'asset portant le numéro ' + parc.numasset + ' dans Salesforce'); }

                                    childrenWOs.add(new WorkOrder(
                                            Status = workOrderSAPMessage.basicData.statut,
                                            RecordTypeId = woRecTypeROId,
                                            AccountId = parentWO.AccountId,
                                            ParentWorkOrderId = parentWO.Id,
                                            Agence_Intervenante__c = parentWO.Agence_Intervenante__c,
                                            TECH_MERGE_Observations__c = parc.observations,
                                            AssetId = assetIdsByNames.get(parc.numasset)
                                    ));
                                }
                                insert childrenWOs;


                            } else {
                                //Update on yard check

                                Map<String, WorkOrder> workordersByAssetNames = new Map<String, WorkOrder>();

                                WorkOrder parentWO = parentWorkOrdersBySapIds.get(sapId);
                                for (WorkOrder wo : [SELECT Id, Asset.Name, Status, TECH_MERGE_Observations__c FROM WorkOrder WHERE ParentWorkOrderId = :parentWO.Id]) {
                                    workordersByAssetNames.put(wo.Asset.Name, wo);
                                }

                                for (Intf_WorkOrderSAPMessage.Parc parc : workOrderSAPMessage.parcs) {
                                    WorkOrder wo = workordersByAssetNames.get(parc.numasset);

                                    if (wo != null) {
                                        wo.TECH_MERGE_Observations__c = parc.observations;
                                        wo.Status = workOrderSAPMessage.basicData.statut;
                                    }
                                }

                                parentWO.Status = workOrderSAPMessage.basicData.statut;

                                update parentWO;
                                update workordersByAssetNames.values();

                            }

                        } else {

                            Id woRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get(workOrderSAPMessage.basicData.type).getRecordTypeId();

                            Intf_WorkOrderSAPMessage.Parc parc = workOrderSAPMessage.parcs[0];
                            if (parc == null) { throw new Intf_Exception('Aucune information de Parc dans le message !');}
                            if (!assetIdsByNames.containsKey(parc.numasset)) { throw new Intf_Exception('Pas d\'asset portant le numéro ' + parc.numasset + ' dans Salesforce'); }

                            Datetime datetimeInfo = getDateTimeFromString(parc.daterelisation);
                            WorkOrder wo = new WorkOrder(
                                    Status = workOrderSAPMessage.basicData.statut,
                                    //RecordTypeId = woRecordTypeId,
                                    AccountId = accountIdsBySapAccountIds.get(workOrderSAPMessage.basicData.sapaccountId),
                                    Agence_Intervenante__c = agenceIdsByNames.containsKey(workOrderSAPMessage.basicData.agenceintervenante) ? agenceIdsByNames.get(workOrderSAPMessage.basicData.agenceintervenante) : null,
                                    TECH_MERGE_Observations__c = parc.observations,
                                    AssetId = assetIdsByNames.get(parc.numasset),
                                    Travaux_demandes__c = parc.notetravaux,
                                    Precisions_Long__c = parc.realtravaux,
                                    Organe_controler__c = parc.organe,
                                    Priority = workOrderSAPMessage.basicData.priorite,
                                    SAP_ID__c = sapId,
                                    Date_Heure_De_transmission__c = datetimeInfo,
                                    Date_Heure_Appel_technicien__c = datetimeInfo,
                                    Earliest_Start_Permitted__c = getDateTimeFromString(workOrderSAPMessage.basicData.earliestStartPermitted),
                                    Date_de_realisation__c = getDateTimeFromString(parc.daterelisation),
                                    Description = workOrderSAPMessage.basicData.titreordre,
                                    Lieu_Intervention__c = workOrderSAPMessage.basicData.lieuIntervention,
                                    //TODO Voir avec Roméo comment gérer ces 2 champs
                                    //Parc_Assistance__c = assetIdsByNames.get(parc.numasset),
                                    //Parc_Relais__c = assetIdsByNames.get(parc.numasset),
                                    StartDate = getDateTimeFromString(workOrderSAPMessage.basicData.startDate),
                                    EndDate = getDateTimeFromString(workOrderSAPMessage.basicData.endDate),
                                    Nom_du_technicien__c = workOrderSAPMessage.basicData.nomTechnicien,
                                    Origine__c = workOrderSAPMessage.basicData.origine,
                                    type_OE__c = workOrderSAPMessage.basicData.typeOE,
                                    Anomalie__c = workOrderSAPMessage.basicData.anomalie,
                                    Intervenant__c = workOrderSAPMessage.basicData.intervenant,
                                    Intervenant_Externe_txt__c = workOrderSAPMessage.basicData.intervenantExterne,
                                    Date_Heure_Depart__c = getDateTimeFromString(workOrderSAPMessage.basicData.datetimeDepart),
                                    Date_Heure_Arrivee__c = getDateTimeFromString(workOrderSAPMessage.basicData.datetimeArrivee),
                                    Date_Heure_Fin__c = getDateTimeFromString(workOrderSAPMessage.basicData.datetimeFin),
                                    Date_Heure_Retour__c = getDateTimeFromString(workOrderSAPMessage.basicData.datetimeRetour),
                                    Raison_de_fermeture__c = workOrderSAPMessage.basicData.raisonFermeture
                            );
                            upsert wo SAP_ID__c;
                        }

                        intRepToUpdate.Treatment_Status__c = TREATMENT_OK;


                    } catch (Exception e) {

                        intRepToUpdate.Treatment_Status__c = TREATMENT_ERROR;
                        intRepToUpdate.Treatment_Message__c = e.getMessage();
                        System.debug('===================== Intf_WorkOrderResponseHandler handleResponses Exception: ' + e.getMessage());
                    }

                }
                when else {
                    // Code inconnu

                    intRepToUpdate.Treatment_Status__c = TREATMENT_ERROR;
                    intRepToUpdate.Treatment_Message__c = 'Unknown status code';

                }
            }
            interfaceResponsesToUpdate.add(intRepToUpdate);

        }

        update workordersToUpdate;
        update interfaceResponsesToUpdate;

    }

    private static void populateWorkOrderMaps(List<Interface_Response__c> newMessages) {

        Set<String> accountSAPIds = new Set<String>();
        Set<String> assetNames = new Set<String>();
        Set<String> sapWoIds = new Set<String>();
        Set<String> agencies = new Set<String>();

        for (Interface_Response__c interfaceResponse : newMessages) {
            if (interfaceResponse.Status__c == 'I') {
                try {

                    Intf_WorkOrderSAPMessage workOrderSAPMessage = (Intf_WorkOrderSAPMessage)JSON.deserialize(interfaceResponse.Response_Message__c, Intf_WorkOrderSAPMessage.class);

                    accountSAPIds.add(workOrderSAPMessage.basicData.sapaccountId);
                    sapWoIds.add(workOrderSAPMessage.basicData.sapid);
                    agencies.add(workOrderSAPMessage.basicData.agenceintervenante);

                    for (Intf_WorkOrderSAPMessage.Parc parc : workOrderSAPMessage.parcs) {
                        assetNames.add(parc.numasset);
                    }

                } catch (Exception e) {
                    // Not important just trying to get some Ids from message for bulkification
                    System.debug('===================== Cannot deserialize');
                }
            }
        }

        for (Account agency : [SELECT Id, Name FROM Account WHERE RecordType.DeveloperName = 'Agence_PF' AND Name in :agencies]) {
            agenceIdsByNames.put(agency.Name, agency.Id);
        }

        System.debug('accountSAPIds : ' + accountSAPIds);
        for (Account account : [SELECT Id, Name, Tech_SAP_Id__c FROM Account WHERE Tech_SAP_Id__c in :accountSAPIds]) {
            accountIdsBySapAccountIds.put(account.Tech_SAP_Id__c, account.Id);
        }

        for (WorkOrder parentWO : [SELECT Id, Status, SAP_ID__c FROM WorkOrder WHERE SAP_ID__c in :sapWoIds AND RecordTypeId = :woRecTypeHATId]) {
            parentWorkOrdersBySapIds.put(parentWO.SAP_ID__c, parentWO);
        }

        for (WorkOrder workOrder : [SELECT Id, Status, SAP_ID__c FROM WorkOrder WHERE SAP_ID__c in :sapWoIds AND RecordTypeId <> :woRecTypeHATId]) {
            workOrdersBySapIds.put(workOrder.SAP_ID__c, workOrder);
        }

        for (Asset asset : [SELECT Id, Name FROM Asset WHERE Name in :assetNames]) {
            assetIdsByNames.put(asset.Name, asset.Id);
        }

    }

    private static Datetime getDateTimeFromString(String dateStr) {

        if (String.isBlank(dateStr)) { return null; }

        Integer year;
        Integer month;
        Integer day;
        Integer hour;
        Integer minute;
        Integer second;

        try {

            year = Integer.valueOf(dateStr.substring(0,4));
            month = Integer.valueOf(dateStr.substring(4,6));
            day = Integer.valueOf(dateStr.substring(6,8));
            hour = Integer.valueOf(dateStr.substring(8,10));
            minute = Integer.valueOf(dateStr.substring(10,12));
            second = Integer.valueOf(dateStr.substring(12,14));

//            System.debug ('==== year : ' + year);
//            System.debug ('==== month : ' + month);
//            System.debug ('==== day : ' + day);
//            System.debug ('==== hour : ' + hour);
//            System.debug ('==== minute : ' + minute);
//            System.debug ('==== second : ' + second);

            return Datetime.newInstance(year, month, day, hour, minute, second);

        } catch (Exception e) {
            throw new Intf_Exception('Error invalid date received. Please check date received in JSON. Value received: ' + dateStr);
        }

    }

}