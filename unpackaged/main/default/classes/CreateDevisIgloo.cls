public class CreateDevisIgloo {
   public static String PARAMETERS {get;set;}
   Public static string CreateDevis(Lead led){
       String message = '';
       String Result;
       string Start ='{ "datas" : [';
       string finish = '"]}';
       CreateDevisIgloo.PARAMETERS='WS_Param_007';
       if(led.status == 'Créée'|| led.Status == 'Abandonnée'){
           system.debug('Lead not Qalified');
           Result = 'NotQalified';
           }
       
       else if(led.Code_prospect_Igloo__c != null){
           
           Result = 'ProspectExiste';
       }
       else
        {
            string jsonBody =CreateDevisIgloo.buildJson(led);
            
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        //Setup Call
        string ApplicationName = 'SFCD';
        req.setEndpoint(WSParametreRequete__c.getInstance(CreateDevisIgloo.PARAMETERS).EndPoint__c);
        req.setMethod(WSParametreRequete__c.getInstance(CreateDevisIgloo.PARAMETERS).Methode__c);
        req.setHeader('ApplicationName',ApplicationName);
        req.setHeader('User', WSParametreRequete__c.getInstance(CreateDevisIgloo.PARAMETERS).UserName__c);
        req.setHeader('pwd', WSParametreRequete__c.getInstance(CreateDevisIgloo.PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(CreateDevisIgloo.PARAMETERS).ContentType__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(CreateDevisIgloo.PARAMETERS).Authorization__c);
        req.setBody(jsonBody);
        system.debug('Endpoint'+req.getEndpoint());
        HttpResponse resp= new HttpResponse();
        req.setTimeout(60000);
        resp = http.send(req);
        system.debug(jsonBody);
        system.debug(resp.getStatusCode());
        if(resp.getStatusCode()==404)
        {
         Result = 'Error';
            system.debug('error');
        }
            else if(resp.getStatusCode()==200)
        {
            system.debug('Done');
            JSONParser parser = JSON.createParser(resp.getBody());
            String CodeProspect = '';
            String Doublon = '';
            system.debug(parser);
            while (parser.nextToken() != null){
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'ProspectId')){
                        parser.nextToken();
                        CodeProspect = parser.getText() ;
                        system.debug(CodeProspect);
                    }else if((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                        (parser.getText() == 'IsDoublon')){
                    parser.nextToken();
                    Doublon = parser.getText() ;
                            system.debug(Doublon);
                }
            }
            
            if(Doublon == '1'){
           
           Result = 'ProspectExiste';
            }else {
                Result = 'Done';
            }
            
            led.Code_prospect_Igloo__c = CodeProspect;
            Database.update(led);
            
        }
            
                    else
       {
           Result = 'Error';
       }
     
            }
       
       return Result;
}
    
    Public static String buildJson(Lead currentLead){
        string json ='{ "datas" : [{';
        json += '"Pays" : "' + currentLead.Pays__c + '",';
        json += '"Region" : "NULL",';
        json += '"TypeProspect" : "' + currentLead.Particulier_Professionnel__c + '",';
        json += '"TypeIdNational" : "' + currentLead.TypeIdentifiantNational__c + '",';
        json += '"IdentifiantNational" : "' + currentLead.IdentifiantNational__c + '",';
		json += '"NomSociete" : "' + currentLead.Company + '",';
		json += '"Agence" : "' + currentLead.Code_Agence_PF__c +'",';
        json += '"Activite" : "' + currentLead.TypeActivite__c + '",';
        json += '"Sourcing" : "' + currentLead.LeadSource + '",';
        json += '"CP" : "' + currentLead.CodePostal__c + '",';
        json += '"Ville" : "' + currentLead.Ville__c + '",';
        json += '"Adresse" : "' + currentLead.Rue__c + '",';
        json += '"Civilite" : "' + currentLead.Gender__c + '",';
        json += '"Nom" : "' + currentLead.Name + '",';
        json += '"Prenom" : "' + currentLead.Name + '",';
		json += '"Telephone" : "' + currentLead.Phone + '",';
        json += '"Mail" : "' + currentLead.Email + '",';
        json += '"ProductName" : "' + currentLead.Produits__c + '",';
		json += '"Service" : "' + currentLead.Fonction__c + '"}]}';
        return json;
    }
}