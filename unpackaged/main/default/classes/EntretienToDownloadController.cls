public class EntretienToDownloadController {
     
    public static String PARAMETERS {get;set;}
    public Transient String document {get; set;}
	public boolean displayLoader {get; set;}
    public boolean displayError {get; set;}
    public boolean displayDocument {get; set;}

    // Constructor
    
    public EntretienToDownloadController()
    {
        displayDocument=true;
    	displayLoader=true;
    	displayError=false;
    }

    public void getDocument()
    {		
        PARAMETERS = 'WS_Param_011';
        document =null;
        String nomParc;
        
        // Get the fields values => fileName and nomParc. from Controle Page
         
		String dataFromControl = ApexPages.currentPage().getParameters().get('id');
        String fileNameWithExtension = dataFromControl.substringAfter('/');
       // String fileName = fileNameWithExtension.substringBefore('.pdf');
        nomParc  = dataFromControl.substringBefore('/');
        
        // Generate the Json File
        
        Map<String, String> dataToJson = new Map<String, String>();
        dataToJson.put('NoParc', nomParc);
        dataToJson.put('Filename', fileNameWithExtension);
        String body = buildJson(dataToJson);
        System.debug('body : '+body);
        
        // Send the Post Request to the webservice
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WSParametreRequete__c.getInstance(PARAMETERS).EndPoint__c);
        req.setMethod(WSParametreRequete__c.getInstance(PARAMETERS).Methode__c);
        req.setHeader('User', WSParametreRequete__c.getInstance(PARAMETERS).UserName__c);
        req.setHeader('Password', WSParametreRequete__c.getInstance(PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(PARAMETERS).ContentType__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(PARAMETERS).Authorization__c);
        req.setBody(body);
        
        // Get the response
        
        HttpResponse resp= new HttpResponse();req.setTimeout(60000);
        try
        {
           resp = http.send(req); 
        }catch(Exception E){
            displayError = true;
           displayDocument=false;
        }
        
        
        System.debug('JSON: ' + body);
        System.debug('STATUS CODE : ' + resp.getStatusCode());
        STRING respbody=null;
        if(resp.getStatusCode()==200)
        {
            System.debug(resp.getBody());
            respbody = resp.getBody();
			document= respbody.substringBetween('<Result>','</Result>');
            displayLoader = false;  
            
        }
        else
        {
           displayError = true;
           displayDocument=false;
        }  
    }
	
    // Build the Json File
    
	private static String buildJson(Map<String, String> dataToJson)
    {
		String json = '{ "datas" : [{';
        json += '"NoParc" : "' + dataToJson.get('NoParc') + '",';
        json += '"Filename" : "' + dataToJson.get('Filename') + '"}]}';
        return json;
    }
   
}