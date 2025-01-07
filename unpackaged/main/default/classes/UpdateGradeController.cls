public class UpdateGradeController {
private String recordId;
    public Boolean DisplayNull{get;set;}public Boolean DisplaySame{get;set;}public Boolean DisplayDifferent{get;set;}
    public Boolean DisplayInfo{get;set;}public Boolean DisplayRequested{get;set;}
public Account currentAcc{get;set;}
    
    public UpdateGradeController(ApexPages.StandardController controller) {
        DisplayInfo=true;
        this.currentAcc= (Account) controller.getRecord();
        currentAcc= [Select id,CotationPF__c,TECHTypeIdentifiantNational__c,TECHIdentifiantNational__c,Name,TypeIdentifiantNational__c,IdentifiantNational__c,Policy_Id__c,BillingCountryCode, RecordType.Name, Pays__c from account where id=:currentAcc.id];
    }
    
 	public void method() {
       
    String Result = AP09Compte.UpdateGrade(currentAcc);
        switch on Result {
            when 'null' {		
                DisplayNull = true;DisplayDifferent=false;DisplaySame=false;DisplayInfo=false;DisplayRequested=false;
            }
            when 'Different' {		
                DisplayDifferent = true;DisplayNull=false;DisplaySame=false;DisplayInfo=false;DisplayRequested=false;
            }
            when 'Same' {
                DisplaySame = true;DisplayDifferent=false;Displaynull=false;DisplayInfo=false;DisplayRequested=false;
            }
            when 'Requested' {
                DisplayRequested=true;DisplaySame=false;DisplayDifferent=false;Displaynull=false;DisplayInfo=false;
            }
           }
    }
}