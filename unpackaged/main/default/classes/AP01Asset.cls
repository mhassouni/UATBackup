public class AP01Asset {
	
    public static String PARAMETERS {get;set;}
    public static String TransmitKmCompteurToIgloo(String AssetId,integer KmConstate)
    {
        
        String ReturnMessage='';
        AP01Asset.PARAMETERS='WS_Param_004';
        System.debug(AP01Asset.PARAMETERS);
        Asset currAsset=[SELECT Name,KmCompteurConstate__c,WarningMajKmIgloo__c,LastKmCompteurIsOK__c,IMMAT__c from Asset where Id=:AssetId];
        
            if(KmConstate!=0)
            {
                
                ReturnMessage=updateKmCompteurFromSFDcToIgloo(currAsset,KmConstate);
                
            }
         return ReturnMessage;   
    }
    
    public static String updateKmCompteurFromSFDcToIgloo(Asset CurrAsset,integer KmConstate)
    {
        String fullMessage='';
        String message = '';
        String dateEffetreleveToSend=datetime.now().format('dd/MM/yyyy HH:mm:ss');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(WSParametreRequete__c.getInstance(AP01Asset.PARAMETERS).EndPoint__c);
        req.setMethod(WSParametreRequete__c.getInstance(AP01Asset.PARAMETERS).Methode__c);
        req.setHeader('User', WSParametreRequete__c.getInstance(AP01Asset.PARAMETERS).UserName__c);
        req.setHeader('Password', WSParametreRequete__c.getInstance(AP01Asset.PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(AP01Asset.PARAMETERS).ContentType__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(AP01Asset.PARAMETERS).Authorization__c);
        //string jsonBody='{ "ReleveCompteur":{ 	"ParcId":"'+CurrAsset.Name+'", 	"KmCompteur":'+String.valueOf(KmConstate)+', 	"DateEffetReleve":"'+dateEffetreleveToSend+'" } }';
        string jsonBody='{ "ReleveCompteur":{ 	"ParcId":"'+CurrAsset.Name+'", "Immat":"'+CurrAsset.IMMAT__c+'","KmCompteur":'+String.valueOf(KmConstate)+', 	"DateEffetReleve":"'+dateEffetreleveToSend+'" } }';

        req.setBody(jsonBody);
        HttpResponse resp= new HttpResponse();
        req.setTimeout(60000);
        resp = http.send(req);
        System.debug('Body : '+jsonBody);
        System.debug('Status Code : '+String.valueOf(resp.getStatusCode()));
        if(resp.getStatusCode()==208)
        {
            JSONParser parser = JSON.createParser(resp.getBody());
	        
	        while (parser.nextToken() != null) {
            	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'KmCompteurNotValid')) {
                    // Get the value.
                    parser.nextToken();
                    // Compute the grand total price for all invoices.
                    message += parser.getText();
                }
            }
            fullMessage=String.format(Label.Asset_Warning_KmInferieur,new String[]{String.valueOf(KmConstate), message});
            

            
        }else if(resp.getStatusCode()==207)
        {
            JSONParser parser = JSON.createParser(resp.getBody());
	        
	        while (parser.nextToken() != null) {
            	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'DateEffetReleveNotValid')) {
                    // Get the value.
                    parser.nextToken();
                    // Compute the grand total price for all invoices.
                    message += parser.getText();
                }
            }
            fullMessage=String.format(Label.Asset_Warning_DateEffetReleveInferieur, new String[]{dateEffetreleveToSend,message});
            
            
        }else if(resp.getStatusCode()==200)
        {
            fullMessage=String.format(Label.Asset_Statut_MajKmOK, new String[]{String.valueOf(KmConstate),dateEffetreleveToSend});
        }else
        {
            fullMessage=Label.Asset_Warning_KmServiceUnavailable;
        }
        System.debug(fullMessage);
        CurrAsset.WarningMajKmIgloo__c=fullMessage;
        if(resp.getStatusCode()==200)
        {
            CurrAsset.KmCompteurIgloo__c=KmConstate;
            CurrAsset.LastKmCompteurIsOK__c=true;
        }else
        {
            CurrAsset.LastKmCompteurIsOK__c=false;
        }
        update CurrAsset;
        
        return fullMessage;
    }
    
}