public with sharing class FactureVehiculeToDownloadController {


     
    public static String PARAMETERS {get;set;}
    public Transient String document {get; set;}
    public boolean displayLoader {get; set;}
    public boolean displayError {get; set;}
    public boolean displayDocument {get; set;}
    
    // Constructor
    
    public  FactureVehiculeToDownloadController () {
    	displayDocument=true;
    	displayLoader=true;
    	displayError=false;
        
    }
    
    public void getDocument() {
    	PARAMETERS='WS_Param_010';
        document =null;
        
        // Get the field value => parcName. from CarteGrise Page
        
        String FactureID = ApexPages.currentPage().getParameters().get('id');
        Facture_vehicule__c FV= [Select id,Numero_de_facture_IGLOO__c from Facture_vehicule__c where id=:FactureID limit 1];
        system.debug('Numero_de_facture_IGLOO__c : '+FV.Numero_de_facture_IGLOO__c);
        // Send the Get Request to the webservice
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WSParametreRequete__c.getInstance(PARAMETERS).EndPoint__c + FV.Numero_de_facture_IGLOO__c);
        req.setMethod(WSParametreRequete__c.getInstance(PARAMETERS).Methode__c);
        req.setHeader('User', WSParametreRequete__c.getInstance(PARAMETERS).UserName__c);
        req.setHeader('Password', WSParametreRequete__c.getInstance(PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(PARAMETERS).ContentType__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(PARAMETERS).Authorization__c);
        
        // Get the response
        
        HttpResponse resp= new HttpResponse();
        req.setTimeout(60000);
        resp = http.send(req);
        System.debug('Status Code : '+String.valueOf(resp.getStatusCode()));
        if(resp.getStatusCode()==200)
        {
        	String body = resp.getBody();
            document=body.substringBetween('<Result>','</Result>');
            //document=resp.getBody();
            displayLoader = false;

        }
        else
        {
            System.debug(resp.getStatus());
            displayError = true;
            displayDocument=false;


        }
	}  

}