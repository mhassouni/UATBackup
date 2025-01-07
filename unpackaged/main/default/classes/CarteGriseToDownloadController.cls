public with sharing class CarteGriseToDownloadController {
     
    public static String PARAMETERS {get;set;}
    public Transient String document {get; set;}
    public boolean displayLoader {get; set;}
    public boolean displayError {get; set;}
    public boolean displayDocument {get; set;}
    
    // Constructor
    
    public  CarteGriseToDownloadController () {
    	displayDocument=true;
    	displayLoader=true;
    	displayError=false;
        
    }
    
    public void getDocument() {
    	PARAMETERS='WS_Param_008';
        document =null;
        
        // Get the field value => parcName. from CarteGrise Page
        
        String parcName = ApexPages.currentPage().getParameters().get('id');
        
        // Send the Get Request to the webservice
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WSParametreRequete__c.getInstance(PARAMETERS).EndPoint__c + parcName);
        req.setMethod(WSParametreRequete__c.getInstance(PARAMETERS).Methode__c);
        req.setHeader('User', WSParametreRequete__c.getInstance(PARAMETERS).UserName__c);
        req.setHeader('Password', WSParametreRequete__c.getInstance(PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(PARAMETERS).ContentType__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(PARAMETERS).Authorization__c);
        
        // Get the response
        
        HttpResponse resp= new HttpResponse();
        req.setTimeout(Integer.valueOf(Label.ApexVar_TimeOut));
        resp = http.send(req);
        System.debug('Status Code : '+String.valueOf(resp.getStatusCode()));
        if(resp.getStatusCode()==200)
        {
        	String body = resp.getBody();
            document=body.substringBetween('<Result>','</Result>');
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