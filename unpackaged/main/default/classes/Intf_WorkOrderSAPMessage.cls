/**
 * Created by Michael on 05-05-24.
 */

public with sharing class Intf_WorkOrderSAPMessage {

    public BasicData basicData;
    public List<Parc> parcs;

    public class BasicData {
        public String type { get; set; }

        public String sapaccountId { get; set; }
        public String infocontact { get; set; }
        public String titreordre { get; set; }
        public String priorite { get; set; }
        public String sfcaseid { get; set; }
        public String agenceintervenante { get; set; }
        public String sapid { get; set; }
        public String statut { get; set; }
        public String earliestStartPermitted { get; set; }
        public String lieuIntervention { get; set; }
        public String parcAssistance { get; set; }
        public String parcRelais { get; set; }
        public String startDate { get; set; }
        public String endDate { get; set; }
        public String nomTechnicien { get; set; }
        public String origine { get; set; }
        public String typeOE { get; set; }
        public String anomalie { get; set; }
        public String intervenant { get; set; }
        public String intervenantExterne { get; set; }
        public String datetimeArrivee { get; set; }
        public String datetimeFin { get; set; }
        public String datetimeRetour { get; set; }
        public String datetimeDepart { get; set; }
        public String raisonFermeture { get; set; }
    }

    public class Parc {
        public String organe { get; set; }
        public String numasset { get; set; }
        public String notetravaux { get; set; }
        public String realtravaux { get; set; }
        public String observations { get; set; }
        public String daterelisation { get; set; }
    }

}