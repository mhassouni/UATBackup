public class OpportunityWarningHeader {
    public Opportunity currentOpp;
    @AuraEnabled
    public Boolean DisplayWarning {get;set;}
    
	public OpportunityWarningHeader (ApexPages.StandardController controller) {
        this.currentOpp= (Opportunity) controller.getRecord();
        this.currentOpp= [SELECT AccountId,Account.ListeNoire__c, Account.TECHDateListeNoire__c, Account.Statut__c,StageName  FROM Opportunity WHERE Id =: this.currentOpp.Id][0];
        Account acc= [SELECT  CotationPF__c,AgrementSFAC__c,Statut__c from Account where id =:this.currentOpp.AccountId];
        System.debug('##Cotation PF : '+String.valueOf(acc.CotationPF__c));
        decimal statutOpp=decimal.valueOf(this.currentOpp.StageName.substring(0,1));
        //Affichage du message d'avertissement cotation seulement si l'opportunité a un statut inférieur à 5
       
        	//this.DisplayWarning=acc.CotationPF__c>7?true:false;
        	if((statutOpp<5 && acc.Statut__c ==Label.OPP_Statut_Attente_Validation_CM) )
            {
                this.DisplayWarning = true;
               
            }
        	else
        	{
            this.DisplayWarning=false;
        	}
        System.debug('DisplayWarning : '+String.valueOf(this.DisplayWarning));	
    }
    @AuraEnabled
    public static boolean IsDisplayWarning(String opportunityId){
        boolean displayWarning=false;
        System.debug('##TEST :'+String.valueOf(opportunityId));
        Opportunity currOpp= [SELECT AccountId,Account.ListeNoire__c, Account.TECHDateListeNoire__c,Account.AgrementSFAC__c, Account.Statut__c,StageName  FROM Opportunity WHERE Id =: opportunityId][0];
        Account acc= [SELECT  CotationPF__c,AgrementSFAC__c,Statut__c, ListeNoire__c from Account where id =:currOpp.AccountId];
        System.debug('##Cotation PF : '+String.valueOf(acc.CotationPF__c));
        decimal statutOpp=decimal.valueOf(currOpp.StageName.substring(0,1));
        //Affichage du message d'avertissement cotation seulement si l'opportunité a un statut inférieur à 5
        if((statutOpp<5 && acc.Statut__c == Label.OPP_Statut_Attente_Validation_CM) )
            {
                displayWarning = true;
            }
        //Affichage du message d'avertissement cotation seulement lorsqu'un client a un grade 9 avec case à cocher "Refus"
        else if(acc.CotationPF__c == 9 && acc.ListeNoire__c == true  )
            {
            	displayWarning = true;
            }
        else
        {
            displayWarning=false;
        }
        return displayWarning;
    }
}