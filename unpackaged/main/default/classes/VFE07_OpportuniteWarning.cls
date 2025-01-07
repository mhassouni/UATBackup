public class VFE07_OpportuniteWarning{

    Opportunity opp;
    public boolean spaces{get;set;}
    //public List<Opportunity> accs{get;set;}

    public VFE07_OpportuniteWarning(ApexPages.StandardController controller) {
        this.opp= (Opportunity) controller.getRecord(); 
        opp= [SELECT AccountId,Account.ListeNoire__c, Account.TECHDateListeNoire__c, Account.Statut__c  FROM Opportunity WHERE Id =: opp.Id][0];
        //accs = [SELECT ListeNoire__c,TECHDateListeNoire__c FROM Account WHERE Id =: opp.AccountId];
    }

    public void alert()
    {
        spaces = !Utils_Methods.isSF1();
        if (opp.AccountId!=null)
        {   
            string message = Label.OPP_Info_Compte + ' ';
            boolean warning = false;
            //Account acc = accs[0];
            if(opp.Account.statut__c == Label.CPT_Statut_Inactif){
                warning=true;
                message += Label.MSG_Statut_Inactif;
            }
            else if (opp.Account.statut__c == Label.CPT_Statut_Refuse)
            {
                warning= true;
                message += Label.MSG_Statut_Refuse;
            }
            if (opp.Account.ListeNoire__c) 
            {
                message += (warning?' et ':'') + Label.CPT_ListeNoireDepuis +' '+string.valueof(opp.Account.TECHDateListeNoire__c);
                warning = true;
            }
            if(!warning)
            {
                if(opp.Account.statut__c == Label.CPT_Statut_Draft)
                {
                    message += Label.CPT_EnStatut + ' ' + Label.MSG_Statut_Draft;
                }
                if(opp.Account.statut__c == Label.CPT_Statut_Valide)
                {
                    message += Label.MSG_Statut_Valide;
                }
                if(opp.Account.statut__c == Label.CPT_Statut_ValideCM)
                {
                    message += Label.MSG_Statut_ValideCM;
                }
                if(opp.Account.statut__c == Label.CPT_Statut_Bloque)
                {
                    message += Label.MSG_Statut_Bloque;
                }
            }
            
            ApexPages.Message myMsg = new ApexPages.Message((warning?ApexPages.Severity.WARNING:ApexPages.Severity.INFO),message+'.');
            ApexPages.addMessage(myMsg);
        }
    }
}