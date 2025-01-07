public class AssetWarningHeader {
	public Asset currentAsset;
    
    public Boolean DisplayWarning {get;set;}
    
    public String WarningMessage {get;set;}
    
    public Boolean LastKmCompteurIsOK {get;set;}
    
    
	public AssetWarningHeader (ApexPages.StandardController controller) {
        this.currentAsset= (Asset) controller.getRecord();
        
        this.currentAsset=[SELECT WarningMajKmIgloo__c,LastKmCompteurIsOK__c FROM Asset WHERE Id =: this.currentAsset.Id][0];
        //Affichage du message d'avertissement si non vide
        if(String.isBlank(this.currentAsset.WarningMajKmIgloo__c)||this.currentAsset.WarningMajKmIgloo__c==null)
        {
        	this.DisplayWarning=false;
            this.LastKmCompteurIsOK=this.currentAsset.LastKmCompteurIsOK__c;
            this.WarningMessage='';
        }else
        {
            this.DisplayWarning=true;
            this.LastKmCompteurIsOK=this.currentAsset.LastKmCompteurIsOK__c;
            this.WarningMessage=this.currentAsset.WarningMajKmIgloo__c;
        }
        System.debug('DisplayWarning : '+String.valueOf(this.DisplayWarning));	
    }
    @AuraEnabled
    public static boolean IsLastKmCompteurOK(String AssetId){
        boolean LastKmCompteurOK=false;
        System.debug('##TEST :'+String.valueOf(AssetId));
        Asset currAsset= [SELECT LastKmCompteurIsOK__c FROM Asset WHERE Id =: AssetId][0];
		System.debug(currAsset.LastKmCompteurIsOK__c);
        LastKmCompteurOK=currAsset.LastKmCompteurIsOK__c;
        System.debug(LastKmCompteurOK);
        return LastKmCompteurOK;
    }
    
    @AuraEnabled
    public static boolean IsDisplayWarning(String AssetId){
        boolean displayWarning=false;
        System.debug('##TEST :'+String.valueOf(AssetId));
        Asset currAsset= [SELECT WarningMajKmIgloo__c FROM Asset WHERE Id =: AssetId][0];
		System.debug(currAsset.WarningMajKmIgloo__c);
        if(String.isBlank(currAsset.WarningMajKmIgloo__c)||currAsset.WarningMajKmIgloo__c==null)
        {
        	displayWarning=false;
        }else
        {
            displayWarning=true;
        }
        System.debug(displayWarning);
        return displayWarning;
    }
    
    
    @AuraEnabled
    public static string setDisplayWarningMessage(String AssetId){
        
        System.debug('##TEST :'+String.valueOf(AssetId));
        Asset currAsset= [SELECT WarningMajKmIgloo__c FROM Asset WHERE Id =: AssetId][0];

        if(String.isBlank(currAsset.WarningMajKmIgloo__c)||currAsset.WarningMajKmIgloo__c==null )
        {
        	return '';
        }else
        {
            return currAsset.WarningMajKmIgloo__c;
        }
    }
    
    @AuraEnabled
    public static String TransmitKmToIgloo(String AssetId,integer KmConstate)
    {
        return AP01Asset.TransmitKmCompteurToIgloo(AssetId,KmConstate);
    }
    
   
}