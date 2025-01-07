public class FicheDepannageRIVController {
    
    public String FicheDepannageContent{get;set;}
    public String RIVContent{get;set;}
    public String WorkOrderId {get;set;}
    public WorkOrder CurrWorkOrderItem {get;set;}
    public static String PARAMETERS {get;set;}
        
    public FicheDepannageRIVController(ApexPages.StandardController controller)
    {
        WorkOrderId=ApexPages.currentPage().getParameters().get('id');
        CurrWorkOrderItem=[SELECT  WorkOrder.Case.Owner.Name,WorkOrder.Ressource_Interne__r.Name, WorkOrder.Case.Asset.Name,    
        WorkOrder.Case.Asset.IMMAT__c,WorkOrder.Case.Asset.Categorie__c,    
        WorkOrder.Case.Asset.Code_PF__c,  WorkOrder.Case.Asset.Marque__c,   
        WorkOrder.Case.Asset.cat_ptc__c,  WorkOrder.Agence_Intervenante__r.Name,  
        WorkOrder.Case.Agence_compte__c,  WorkOrder.Case.Account.Name,WorkOrder.Case.Account.NomCommercial__c,    
        WorkOrder.Case.CreatedDate,WorkOrder.Case.Account.Owner.Name,    
        WorkOrder.Case.Contact_Chauffeur__r.Name,WorkOrder.Case.Contact_Chauffeur__r.MobilePhone,    
        WorkOrder.Case.Rue_Lieu__c,WorkOrder.Case.Code_postal__c,    
        WorkOrder.Case.Ville__c,WorkOrder.Case.Precision__c,  
        WorkOrder.Case.Description_incident_client__c,WorkOrder.Case.Qualification__c,  
        WorkOrder.Case.Detail_Pb_Requete__c,  WorkOrder.Case.Type_de_marchandise__c,    
        WorkOrder.Case.Quantite_en_charge__c, WorkOrder.Case.Accident__c,   
        WorkOrder.Case.Incendie__c,   WorkOrder.Case.Vandalisme__c,     
        WorkOrder.Case.Vehicule_immobilis__c,  WorkOrder.Case.Relais_Necessaire__c,  
        WorkOrder.Case.Depannage_autoroute__c, WorkOrder.Parc_Assistance__r.Name,    
        WorkOrder.Parc_relais__r.Name,WorkOrder.Parc_relais__r.Code_PF__c, WorkOrder.Parc_relais__r.IMMAT__c, WorkOrder.Date_Heure_Appel_technicien__c,    
        WorkOrder.Date_Heure_De_transmission__c, WorkOrder.Date_Heure_Depart__c, 
        WorkOrder.Date_Heure_Retour__c,WorkOrder.Date_Heure_Arrivee__c, WorkOrder.Date_Heure_Fin__c,    
          WorkOrder.Precisions_Long__c  from WorkOrder where Id=:WorkOrderId];
        FicheDepannageRIVController.PARAMETERS='WS_Param_003';
        RIVContent=getRIV(CurrWorkOrderItem);
        //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt;filename=RIV.pdf');
        
        
    }
    
    
    public PageReference RedirectToWorkOrderItem()
    {
        
        
        System.debug('Content :'+RIVContent);
        PageReference previousPage = new PageReference('/'+WorkOrderId);
        
        return previousPage;
    }
    
    
    public static String getRIV(WorkOrder CurrWorkOrderItem)
    {
      
    	String riv=null;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WSParametreRequete__c.getInstance(FicheDepannageRIVController.PARAMETERS).EndPoint__c);
        req.setMethod(WSParametreRequete__c.getInstance(FicheDepannageRIVController.PARAMETERS).Methode__c);
        req.setHeader('User', WSParametreRequete__c.getInstance(FicheDepannageRIVController.PARAMETERS).UserName__c);
        req.setHeader('Password', WSParametreRequete__c.getInstance(FicheDepannageRIVController.PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(FicheDepannageRIVController.PARAMETERS).ContentType__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(FicheDepannageRIVController.PARAMETERS).Authorization__c);
        string xmlBody='<Parameters>';
        xmlBody+='<ReportName>report.parcRIV</ReportName>';
        xmlBody+='<app_langue>FR</app_langue>';
        xmlBody+='<noParc><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Asset.Name),'UTF-8')+']]></noParc>';
        xmlBody+='<agence><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Agence_Intervenante__r.Name),'UTF-8')+']]></agence>';
        xmlBody+='<codePF><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Asset.Code_PF__c),'UTF-8')+']]></codePF>';
        xmlBody+='<immat><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Asset.IMMAT__c),'UTF-8')+']]></immat>';
        xmlBody+='<nomClient><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Account.NomCommercial__c),'UTF-8')+']]></nomClient>';
        xmlBody+='<typeCnt> </typeCnt>';
        xmlBody+='<parcReplaced> </parcReplaced>';
        xmlBody+='<Categorie><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Asset.Categorie__c),'UTF-8')+']]></Categorie>';
        xmlBody+='<Marque><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Asset.Marque__c),'UTF-8')+']]></Marque>';
        xmlBody+='<CategoriePTC><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Asset.cat_ptc__c),'UTF-8')+']]></CategoriePTC>';
        xmlBody+='<AgenceProprietaire><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Agence_compte__c),'UTF-8')+']]></AgenceProprietaire>';
        xmlBody+='<ContactClient><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Account.Owner.Name),'UTF-8')+']]></ContactClient>';
        xmlBody+='<ContactDepannage><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Owner.Name),'UTF-8')+']]></ContactDepannage>';
        xmlBody+='<DateOuverture><![CDATA['+EncodingUtil.urlEncode(replaceNullDateValues(CurrWorkOrderItem.Case.CreatedDate,'dd/MM/yyyy HH:mm'),'UTF-8')+']]></DateOuverture>';
        xmlBody+='<NomChauffeur><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Contact_Chauffeur__r.Name),'UTF-8')+']]></NomChauffeur>';
        xmlBody+='<LieuIntervention><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Rue_Lieu__c)+'<br/>'+replaceNullValues(CurrWorkOrderItem.Case.Code_postal__c)+' - '+replaceNullValues(CurrWorkOrderItem.Case.Ville__c)+'<br/>'+replaceNullValues(CurrWorkOrderItem.Case.Precision__c),'UTF-8')+']]></LieuIntervention>';
        xmlBody+='<DescriptionIncident><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Description_incident_client__c),'UTF-8')+']]></DescriptionIncident>';
        xmlBody+='<Qualification><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Qualification__c),'UTF-8')+']]></Qualification>';
        xmlBody+='<Details><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Detail_Pb_Requete__c),'UTF-8')+']]></Details>';
        
        xmlBody+='<Marchandise><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Type_de_marchandise__c),'UTF-8')+']]></Marchandise>';
        xmlBody+='<QuantiteEnCharge><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Quantite_en_charge__c),'UTF-8')+']]></QuantiteEnCharge>';
        if(CurrWorkOrderItem.Case.Accident__c==true)
        {
            xmlBody+='<Accident><![CDATA[True]]></Accident>';
        }else
        {
            xmlBody+='<Accident><![CDATA[False]]></Accident>';
        }
        if(CurrWorkOrderItem.Case.Vandalisme__c==true)
        {
            xmlBody+='<Vandalisme><![CDATA[True]]></Vandalisme>';
        }else
        {
            xmlBody+='<Vandalisme><![CDATA[False]]></Vandalisme>';    
        }
        
        if(CurrWorkOrderItem.Case.Vehicule_immobilis__c==true)
        {
            xmlBody+='<VehiculeImmobilise><![CDATA[True]]></VehiculeImmobilise>';
        }else
        {
            xmlBody+='<VehiculeImmobilise><![CDATA[False]]></VehiculeImmobilise>';    
        }
        
        if(CurrWorkOrderItem.Case.Relais_Necessaire__c==true)
        {
            xmlBody+='<RelaisNecessaire><![CDATA[True]]></RelaisNecessaire>';
        }else
        {
            xmlBody+='<RelaisNecessaire><![CDATA[False]]></RelaisNecessaire>';    
        }
        
        if(CurrWorkOrderItem.Case.Depannage_autoroute__c==true)
        {
            xmlBody+='<DepannageAutoroute><![CDATA[True]]></DepannageAutoroute>';
        }else
        {
            xmlBody+='<DepannageAutoroute><![CDATA[False]]></DepannageAutoroute>';    
        }
        
        if(CurrWorkOrderItem.Case.Incendie__c==true)
        {
            xmlBody+='<Incendie><![CDATA[True]]></Incendie>';
        }else
        {
            xmlBody+='<Incendie><![CDATA[False]]></Incendie>';    
        }
        
        
        xmlBody+='<noParcIntervention><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Parc_Assistance__r.Name),'UTF-8')+']]></noParcIntervention>';
        xmlBody+='<noParcRelais><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Parc_relais__r.Name),'UTF-8')+']]></noParcRelais>';
        xmlBody+='<HeureAppelTechnicien><![CDATA['+EncodingUtil.urlEncode(replaceNullDateValues(CurrWorkOrderItem.Date_Heure_Appel_technicien__c,'dd/MM/yyyy HH:mm'),'UTF-8')+']]></HeureAppelTechnicien>';
        xmlBody+='<HeureTransmission><![CDATA['+EncodingUtil.urlEncode(replaceNullDateValues(CurrWorkOrderItem.Date_Heure_De_transmission__c,'dd/MM/yyyy HH:mm'),'UTF-8')+']]></HeureTransmission>';
        xmlBody+='<HeureDepart><![CDATA['+EncodingUtil.urlEncode(replaceNullDateValues(CurrWorkOrderItem.Date_Heure_Depart__c,'dd/MM/yyyy HH:mm'),'UTF-8')+']]></HeureDepart>';
        xmlBody+='<HeureArrivee><![CDATA['+EncodingUtil.urlEncode(replaceNullDateValues(CurrWorkOrderItem.Date_Heure_Arrivee__c,'dd/MM/yyyy HH:mm'),'UTF-8')+']]></HeureArrivee>';
        xmlBody+='<HeureFinIntervention><![CDATA['+EncodingUtil.urlEncode(replaceNullDateValues(CurrWorkOrderItem.Date_Heure_Fin__c,'dd/MM/yyyy HH:mm'),'UTF-8')+']]></HeureFinIntervention>';
        xmlBody+='<HeureRetour><![CDATA['+EncodingUtil.urlEncode(replaceNullDateValues(CurrWorkOrderItem.Date_Heure_Retour__c,'dd/MM/yyyy HH:mm'),'UTF-8')+']]></HeureRetour>';
        xmlBody+='<Travaux><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Precisions_Long__c),'UTF-8')+']]></Travaux>';
        xmlBody+='<RelaisMisADisposition><![CDATA[False]]></RelaisMisADisposition>';
        xmlBody+='<DepannageProvisoire><![CDATA[False]]></DepannageProvisoire>';
        xmlBody+='<NegligenceAveree><![CDATA[False]]></NegligenceAveree>';
        xmlBody+='<ARevoirAgence><![CDATA[False]]></ARevoirAgence>';
        xmlBody+='<codePFRelais><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Parc_relais__r.Code_PF__c),'UTF-8')+']]></codePFRelais>';
        xmlBody+='<ImmatRelais><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Parc_relais__r.IMMAT__c),'UTF-8')+']]></ImmatRelais>';
        xmlBody+='<ResponsablePFDepannage><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Owner.Name),'UTF-8')+']]></ResponsablePFDepannage>';
        system.debug('ResponsablePFRealisation '+CurrWorkOrderItem.Ressource_Interne__r.Name);
        xmlBody+='<ResponsablePFRealisation><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Ressource_Interne__r.Name),'UTF-8')+']]></ResponsablePFRealisation>';
        xmlBody+='<TelephoneChauffeur><![CDATA['+EncodingUtil.urlEncode(replaceNullValues(CurrWorkOrderItem.Case.Contact_Chauffeur__r.MobilePhone),'UTF-8')+']]></TelephoneChauffeur>';
        
        xmlBody+='</Parameters>';
        req.setBody(xmlBody);
        HttpResponse resp= new HttpResponse();
        req.setTimeout(60000);
        resp = http.send(req);
        System.debug('Body : '+xmlBody);
        System.debug('Status Code : '+String.valueOf(resp.getStatusCode()));
        if(resp.getStatusCode()==200)
        {
            String body = resp.getBody();
           // System.debug('Result '+body);
          //  System.debug('Result : '+EncodingUtil.base64Decode(body.substringBetween('<Result>','</Result>')));
            riv=body.substringBetween('<Result>','</Result>');
            
        }else
        {
            System.debug(resp.getStatus());
        }
        return riv;
		
        
        
    }
    
    
    public static string replaceNullValues(string value)
    {
        if(value==null|| value.equalsIgnoreCase('null'))
            value='';
        return value;
    }
    
    public static string replaceNullDateValues(Datetime currDate,string format)
    {
        if(currDate==null)
            return '';
        else
            return currDate.format(format);
    }
}