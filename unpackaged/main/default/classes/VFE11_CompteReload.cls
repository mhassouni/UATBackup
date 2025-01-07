public class VFE11_CompteReload {

    public Account currentAcc{get;set;}
    public boolean spaces{get;set;}
    public boolean showValidationButton{get;set;}
    public set<Id> creditManagementUsers{get;set;}
    public Boolean refreshPage {get; set;}
    
    public VFE11_CompteReload (ApexPages.StandardController controller) {
        this.currentAcc= (Account) controller.getRecord();
        System.debug('currentAcc : '+ currentAcc);
        currentAcc= [SELECT Statut__c, ModeCreation__c, CreatedBy.LastName
                     FROM Account
                     WHERE Id =: currentAcc.Id][0];
        refreshPage=FALSE;
        showValidationButton=FALSE;
        
        creditManagementUsers=new set<Id>();
        for(GroupMember gm: [select UserOrGroupId
                             from GroupMember
                             where Group.Name=:Label.GRP_CreditManagement_Name]){
            creditManagementUsers.add(gm.UserOrGroupId);
        }
    }
    
    public void reload() {
        spaces = !Utils_Methods.isSF1();
        
        if(currentAcc.Statut__c == Label.CPT_Statut_Draft) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, Label.CPT_Alert_RefreshPageDraft);
            ApexPages.addMessage(myMsg);
        }
        if(
           //Le bouton Validation EH est visible pour les utilisateurs du Credit Management (groupe public) si le compte est en statut Draft, Bloqué ou Erreur EH.
           ((currentAcc.Statut__c == Label.CPT_Statut_Draft
            || currentAcc.Statut__c == Label.CPT_Statut_Bloque
            || currentAcc.Statut__c == Label.CPT_Statut_Erreur_EH)
           &&
            creditManagementUsers.contains(UserInfo.getUserId())
           )
           ||
           //Le bouton Validation EH est visible pour tous les utilisateurs sur les comptes en statut "Draft", en mode de création "Import en masse" et créés par OP_TECH.
           (currentAcc.Statut__c==Label.CPT_Statut_Draft
            && currentAcc.ModeCreation__c==Label.CPT_ModeCreation_ImportEnMasse
           )
          ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.CPT_Alert_CliquerBoutonEH));
            showValidationButton=true;
        }
    }
    
    public PageReference validateAccount(){
        Account acc = [select id,CodePays__c,IdentifiantNational__c,TypeIdentifiantNational__c,BillingCountryCode,Statut__c,IDEulerHermes__c from account where id=:currentAcc.id];
        if(acc.Statut__c != 'Validé') {
            Account accValidated = AllianzWebServiceRest.validateCompany(acc);
            acc.IDEulerHermes__c = accValidated.IDEulerHermes__c;
            acc.Statut__c = accValidated.Statut__c;
            update acc;
        }
        refreshPage=TRUE;
        return null;
        
    }
}