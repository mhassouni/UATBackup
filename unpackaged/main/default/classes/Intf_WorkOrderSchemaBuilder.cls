/**
 * @description       :
 * @author            : Michaël Cabaraux
 * @group             :
 * @last modified on  : 15-02-2024
 * @last modified by  : Michaël Cabaraux
**/

public with sharing class Intf_WorkOrderSchemaBuilder {

    private static WorkOrder workOrder;
    private static Case caseInfo;

    private static final String WO_TYPE_BREAKDOWN = 'Depannage';

    public class WorkOrderMsg {

        public String messid { get; set; }
        public String salesforceId { get; set; }
        public BasicData BasicData;

        public WorkOrderMsg(WorkOrder wo, Case caseInf, String agenceSAP) {

            System.debug('============================== Intf_WorkOrderSchemaBuilder WorkOrderMsg caseInf: ' + caseInf);
            System.debug('============================== Intf_WorkOrderSchemaBuilder WorkOrderMsg wo: ' + wo);

            workOrder = wo;
            caseInfo = caseInf;

            this.messid = Intf_GenerallntService.getUMessageId();
            this.salesforceId = wo.Id;
            this.BasicData = new BasicData(agenceSAP);

            System.debug('============================== Intf_WorkOrderSchemaBuilder WorkOrderMsg workOrder: ' + workOrder);
            System.debug('============================== Intf_WorkOrderSchemaBuilder WorkOrderMsg caseInfo: ' + caseInfo);

        }
    }

    public class BasicData {

        public String type { get; set; }
        public String organe { get; set; }
        public String numasset { get; set; }
        public String sapaccountId { get; set; }
        public String infocontact { get; set; }
        public Datetime datedebut { get; set; }
        public Datetime datefin { get; set; }
        public String titreordre { get; set; }
        public String priorite { get; set; }
        public String notetravaux { get; set; }
        public String sfcaseid { get; set; }
        public String agenceintervenante { get; set; }
        public String organisationservice { get; set; }

        public BasicData(String agenceSAP) {

            this.sfcaseid = workOrder.CaseId;
            this.type = workOrder.Recordtype__c;
            this.organe = workOrder.Organe_controler__c;
            this.titreordre = workOrder.Recordtype__c;
            this.priorite = caseInfo.Priority;

            String infoContact;

            if (workOrder.Recordtype__c.contains(WO_TYPE_BREAKDOWN)) {
                infoContact = caseInfo.Nom_Chauffeur__c + ' -- ' + caseInfo.N_Tel_Chauffeur__c + '-- Adresse: ' + caseInfo.Rue_Lieu__c + ' ';
                infoContact += caseInfo.Code_postal__c + ' ' + caseInfo.Ville__c + ' ' + caseInfo.Pays__c;
                infoContact += ' -- Incident client: ' + caseInfo.Description_incident_client__c;

//                this.notetravaux = caseInfo.Description_incident_client__c;

            } else {
                Contact contact;
                contact = caseInfo.Contact_Chauffeur__c != null ? caseInfo.Contact_Chauffeur__r : caseInfo.Contact_responsable_parc__r;

                infoContact = (String)contact.get('Name') + ' -- ';
                infoContact += (String)contact.get('MobilePhone') + ' -- ';
                infoContact += (String)contact.get('Phone') + ' -- ';
                infoContact += (String)contact.get('Email');

                infoContact += '-- Travaux demandés: ' + workOrder.Travaux_demandes__c;
//                this.notetravaux = workOrder.Travaux_demandes__c;
            }
            this.infocontact = infoContact;
            this.numasset = caseInfo.Asset.Name;
            this.sapaccountId = caseInfo.Account.Tech_SAP_Id__c;
//            this.agenceintervenante = workOrder.TECH_AgenceIntervenante_Name__c;
//            this.organisationservice = workOrder.TECH_AgenceIntervenante_Name__c;
            this.agenceintervenante = agenceSAP;
            this.organisationservice = agenceSAP;
            // this.datedebut = workOrder.Earliest_Start_Permitted__c;
            // this.datefin = workOrder.Fin_disponibilite_vehicule__c;
            this.datedebut = workOrder.Fin_disponibilite_vehicule__c;
            this.datefin = workOrder.Earliest_Start_Permitted__c;
        }
    }
}