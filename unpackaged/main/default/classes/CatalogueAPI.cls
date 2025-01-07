public class CatalogueAPI{
public static String PARAMETERS {get;set;}
    
@AuraEnabled
    public static String WSCallCatalogue(String CodePaysParam, String CodePFParam, String CatalogueParam, String StandardPFParam,String currentQuote,String MarqueParam,String ModeleParam)
    {
       //Init
       String message = '';
       Quote Q =[SELECT id, Energie__c, Status,PTRA_Kg__c,Hauteur_passage_arriere_mm__c	,Poids_vide_Kg_5__c,Code_PF__c,Charge_utile_Kg__c,STANDARD__c,Marque__c,PTAC_kgs__c,Mod_le__c,Amenagements_Caisse__c,Amenagements_Chassis__c,
                      Amenagements_Groupe__c,Amenagements_Hayon__c,Longueur_Interieur__c,Largeur_Interieur__c,Hauteur_Interieur__c,Hauteur_maxi_Hors_tout__c,
                      Chassis_largeur__c,Chassis_longueur__c,Chassis_Porte_faux_arriere__c,Chassis_hauteur_seuil__c,Empattement__c,Volume_Palettes__c
                      from Quote where Id=:currentQuote];
//Check status and return error if status <> Draft        
if(Q.Status == 'Draft') 
{		CatalogueAPI.PARAMETERS='WS_Param_006';
		//Check for empty fields
        if(CodePaysParam == '-' || CodePFParam == '-' || CatalogueParam == '-'||StandardPFParam == '-' )
        {
            message = 'ErreurDM';
        }
        else
        {
         Catalogue_JSON CatalogueJSON;
           
			//WS Call
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        //Clean params
        String CodePaysParamClean = CodePaysParam.replaceAll(' ', '%20');
        String CodePFParamClean = CodePFParam.replaceAll(' ', '%20');
        String CatalogueParamClean = CatalogueParam.replaceAll(' ', '%20');
        String StandardPFParamClean = StandardPFParam.replaceAll(' ', '%20');
        String endpoint=WSParametreRequete__c.getInstance(CatalogueAPI.PARAMETERS).EndPoint__c+'/'+CodePaysParamClean+'/'+CodePFParamClean+'/'+StandardPFParam+'/'+CatalogueParamClean;
        //Setup Call
        req.setEndpoint(endpoint);
        req.setMethod(WSParametreRequete__c.getInstance(CatalogueAPI.PARAMETERS).Methode__c);
        req.setHeader('User', WSParametreRequete__c.getInstance(CatalogueAPI.PARAMETERS).UserName__c);
        req.setHeader('Password', WSParametreRequete__c.getInstance(CatalogueAPI.PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(CatalogueAPI.PARAMETERS).ContentType__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(CatalogueAPI.PARAMETERS).Authorization__c);
        //Setup response
        HttpResponse resp= new HttpResponse();
        req.setTimeout(60000);
        resp = http.send(req);
        system.debug('resp.getStatusCode'+resp.getStatusCode());
       
        //Response = pas de catalogue
        if(resp.getStatusCode()==404)
        {
         message = 'null';
            
        }
        //Response OK
        else if(resp.getStatusCode()==200)
        {
            message = 'OK';
            
               CatalogueJSON = (Catalogue_JSON) System.JSON.deserialize(resp.getBody(),Catalogue_JSON.class); 
         
            
             //Parsing the response and updating the Quote   
            Q.Code_PF__c = CatalogueJSON.body.produit.code_pf;
            
            if(CatalogueJSON.body.produit.charge_utile <> '' && CatalogueJSON.body.produit.charge_utile <> null)
            {Q.Charge_utile_Kg__c = integer.valueof(CatalogueJSON.body.produit.charge_utile);}
            else
            {Q.Charge_utile_Kg__c=null;}
            
            Q.STANDARD__c = CatalogueJSON.body.produit.standard_pf;
            Q.Marque__c = CatalogueJSON.body.produit.marque;
            
            
             if(CatalogueJSON.body.produit.ptac <> '' && CatalogueJSON.body.produit.ptac <> null)
            {Q.PTAC_kgs__c = integer.valueof(CatalogueJSON.body.produit.ptac);}
            else
            {Q.PTAC_kgs__c=null;}
            
            Q.Mod_le__c = CatalogueJSON.body.produit.modele;
            
            if(CatalogueJSON.body.produit.longueur_interieur <> '' && CatalogueJSON.body.produit.longueur_interieur <> null)
            {Q.Longueur_Interieur__c = integer.valueof(CatalogueJSON.body.produit.longueur_interieur);}
            else
            {Q.Longueur_Interieur__c=null;}
            
            if(CatalogueJSON.body.produit.largeur_interieur <> '' && CatalogueJSON.body.produit.largeur_interieur <> null)
            {Q.Largeur_Interieur__c = integer.valueof(CatalogueJSON.body.produit.largeur_interieur);}
            else
            {Q.Largeur_Interieur__c=null;}
            
            if(CatalogueJSON.body.produit.hauteur_interieur <> '' && CatalogueJSON.body.produit.hauteur_interieur <> null)
            {Q.Hauteur_Interieur__c = integer.valueof(CatalogueJSON.body.produit.hauteur_interieur);}
            else
            {Q.Hauteur_Interieur__c=null;}
            
            if(CatalogueJSON.body.produit.hauteur_maxi_hors_tout <> '' && CatalogueJSON.body.produit.hauteur_maxi_hors_tout <> null)
            {Q.Hauteur_maxi_Hors_tout__c = integer.valueof(CatalogueJSON.body.produit.hauteur_maxi_hors_tout);}
            else
            {Q.Hauteur_maxi_Hors_tout__c=null;}
            
            if(CatalogueJSON.body.produit.largeur <> '' && CatalogueJSON.body.produit.largeur <> null)
            {Q.Chassis_largeur__c = integer.valueof(CatalogueJSON.body.produit.largeur);}
            else
            {Q.Chassis_largeur__c=null;}
            
         	if(CatalogueJSON.body.produit.longueur <> '' && CatalogueJSON.body.produit.longueur <> null)
            {Q.Chassis_longueur__c = integer.valueof(CatalogueJSON.body.produit.longueur);}
            else
            {Q.Chassis_longueur__c=null;}
            
            if(CatalogueJSON.body.produit.porte_a_faux_arr <> '' && CatalogueJSON.body.produit.porte_a_faux_arr <> null)
            {Q.Chassis_Porte_faux_arriere__c = integer.valueof(CatalogueJSON.body.produit.porte_a_faux_arr);}
            else
            {Q.Chassis_Porte_faux_arriere__c=null;}
            
             if(CatalogueJSON.body.produit.hauteur_seuil <> '' && CatalogueJSON.body.produit.hauteur_seuil <> null)
            {Q.Chassis_hauteur_seuil__c = integer.valueof(CatalogueJSON.body.produit.hauteur_seuil);}
            else
            {Q.Chassis_hauteur_seuil__c=null;}
            
            if(CatalogueJSON.body.produit.empattement <> '' && CatalogueJSON.body.produit.empattement <> null)
            {Q.Empattement__c = integer.valueof(CatalogueJSON.body.produit.empattement);}
            else
            {Q.Empattement__c=null;}
             
             
            if(CatalogueJSON.body.produit.Energie <> '' && CatalogueJSON.body.produit.Energie <> null)
            {Q.Energie__c = CatalogueJSON.body.produit.Energie;} else {Q.energie__c = NULL;}
             
            Q.Volume_Palettes__c = CatalogueJSON.body.produit.volume_palettes.replaceall(',','\n');
            Q.Amenagements_Caisse__c = CatalogueJSON.body.produit.amenagement_caisse.replaceall(',','\n');
            Q.Amenagements_Chassis__c = CatalogueJSON.body.produit.amenagement_chassis.replaceall(',','\n');
            Q.Amenagements_Groupe__c = CatalogueJSON.body.produit.amenagement_groupe.replaceall(',','\n');
            Q.Amenagements_Hayon__c = CatalogueJSON.body.produit.amenagement_hayon.replaceall(',','\n');
            
            ///
            if(CatalogueJSON.body.produit.poids_a_vide <> '' && CatalogueJSON.body.produit.poids_a_vide <> null )
            {Q.Poids_vide_Kg_5__c = integer.valueof(CatalogueJSON.body.produit.poids_a_vide);}
            else
            {Q.Poids_vide_Kg_5__c =null;}
            
            if(CatalogueJSON.body.produit.hauteur_passage_arriere <> '' && CatalogueJSON.body.produit.hauteur_passage_arriere <> null)
            {Q.Hauteur_passage_arriere_mm__c = integer.valueof(CatalogueJSON.body.produit.hauteur_passage_arriere);}
            else
            {Q.Hauteur_passage_arriere_mm__c =null;}
            
            if(CatalogueJSON.body.produit.ptra <> ''  && CatalogueJSON.body.produit.ptra <> null)
            {Q.PTRA_Kg__c = integer.valueof(CatalogueJSON.body.produit.ptra);}
            else
            {Q.PTRA_Kg__c =null;}
            
			Q.designation__c = CatalogueJSON.body.produit.libelle_descriptif;
            //Stock params values
            Q.Code_Pays_Catalogue__c = CodePaysParam;
            Q.Code_PF_Catalogue__c = CodePFParam;
            Q.Standard_PF_Catalogue__c	= StandardPFParam;
          	Q.Catalogue_PF_Catalogue__c = CatalogueParam;
            Q.Marque_Catalogue__c = MarqueParam;
            Q.Modele_Catalogue__c= ModeleParam;
            update Q; 
            
            
        }
        //Erreur WS    
        else{
            message = 'Erreur';
        }
        
        
        
        }
}
else
{
 message = 'NOT_ALLOWED';   
}
		
    return message;    
    }
}//END