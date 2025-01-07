public class CreateDevisIglooContoller {
    private String recordId;
    public Boolean DisplayNotQalified{get;set;}public Boolean DisplayDone{get;set;}public Boolean DisplayError{get;set;}
    public Boolean DisplayInfo{get;set;} public Boolean DisplayExiste{get;set;}
    public String IDPropspect{get;set;}
public Lead currentLead{get;set;}
    
    public CreateDevisIglooContoller(ApexPages.StandardController controller) {
        //recordId = controller.getRecord().Id;
        DisplayInfo=true;
        this.currentLead= (Lead) controller.getRecord();
        System.debug('currentLead : '+ currentLead);
        currentLead= [Select id, Status, Particulier_Professionnel__c, TypeIdentifiantNational__c,IdentifiantNational__c ,Code_Agence__c,Code_Agence_PF__c,Code_prospect_Igloo__c,
                      TypeActivite__c,Produits__c, Rue__c,Pays__c, Ville__c, Gender__c, Name, Company,LeadSource, Phone, Email, CodePostal__c, Fonction__c   from Lead where id=:currentLead.id];
    }
    
 	public void method() {
       string codeProspect = currentLead.Code_prospect_Igloo__c;
    String Result = CreateDevisIgloo.CreateDevis(currentLead);
        switch on Result {
            when 'NotQalified' {		
                DisplayNotQalified = true;DisplayError=false;DisplayDone=false;DisplayInfo=false;DisplayExiste=false;
            }
            when 'ProspectExiste' {		
                DisplayExiste = true;DisplayError=false;DisplayDone=false;DisplayInfo=false;DisplayNotQalified=false;
            }
            when 'Error' {		
                DisplayError = true;DisplayNotQalified=false;DisplayDone=false;DisplayInfo=false;DisplayExiste=false;
            }
            when 'Done' {
                DisplayDone = true;DisplayError=false;DisplayNotQalified=false;DisplayInfo=false;DisplayExiste=false;
            }
           
           }
    }

}