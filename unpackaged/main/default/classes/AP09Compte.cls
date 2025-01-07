/**
 * @author Kevin Melliand
 * sends account informations to MDM then get back supplementary informations and add it add to account 
 * Class Test : AP09Compte_TEST
 * Code coverage: 87%
 * */

public class AP09Compte {

    public static string UserLanguage
    {
        get{
            string temp = UserInfo.getLanguage();
            /*if(temp !='it'
                && temp !='es'
                && temp !='de'
                && temp !='en_GB')
            {*/
                temp = 'fr';
            //}
            return temp;
        }
        set;
    }

    public static Boolean isFirstRun=TRUE;
   
    public static final String PARAMETERS = 'WS_Param_000';
    public static final String PARAMETERS_GradeInformation = 'WS_Param_002'; 
    
    public static Boolean isDuplicate=FALSE;
    
    public static map<string,wrapperOldSFAC> OldSFACMap= new map<string,wrapperOldSFAC>();
    
    public static map<string,string> EffectifByworkForceeMap = new map<string,string>();
        
    public static set<id> creditManagementUsers = new set<id>();

    @future (callout=true)
    public static void processCreation (Set<Id> newsIdSet, Boolean isManual) {
        
    List<Account> news = [SELECT Id, Name, OwnerId, RecordTypeId, PaysRegionPF__c, TECHIdentifiantNational__c,
                              Ligne1__c, Ligne2__c, Ligne3__c, Ligne4__c, Pays__c, CodePostal__c, Ville__c,
                              TECHTypeIdentifiantNational__c, Ligne1Exploitation__c, Ligne2Exploitation__c,
                              Ligne3Exploitation__c, Ligne4Exploitation__c, VilleExploitation__c,
                              DateCotationPF__c, CotationPF__c, DateAgrementEH__c, AgrementSFAC__c, ListeNoire__c, 
                              CodePostalExploitation__c, PaysExploitation__c,  ParentId,
                              Statut__c, AgencePF__c, CategorieCompte__c, IrreductibleVIP__c, TECHCompteurAppelsWS__c, TECHWS__c,
                              Parent.TECHTypeIdentifiantNational__c, Parent.TECHIdentifiantNational__c , RecopierAdressePrincipale__c, TECHIdNatCPExp__c                         
                              FROM Account WHERE Id IN :newsIdSet];
                                                            
    processCreation2(news,false, isManual);         
        
    }
    
    public static void processCreation2 (List<Account> newsAccountSet, boolean reSend, boolean isManual) {
        System.debug('###Dans processCreation');
        
        if(Test.isRunningTest()){
            WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_000',
                                                                   EndPoint__c = 'https://api-test.petitforestier.fr/api/services/PFCustomersRepository/Account',
                                                                   Methode__c = 'POST',
                                                                   UserName__c = 'mdm_sfdc',
                                                                   MotDePasse__c = '5:?MWWE6-tm9fcW4',
                                                                   ContentType__c = 'application/xml',
                                                                   ApplicationName__c = 'SFCD',
                                                                   Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
            insert wspr1;
            CodeAgence__c CODEAG = new CodeAgence__c(Name='001',Libelle_fr__c='001 - VILLEPINTE',Nom_Agence__c='001 - VILLEPINTE',Numero_Agence__c='001');
            upsert CODEAG;
        }
        
        List<Account> news = newsAccountSet;
        
        /*RG ANNULEE
        //check if duplicate, do not call WS
        if(news.size()==1 && !isManual){
            string dupKey=news[0].TECHIdNatCPExp__c;
            list<Account> listDuplicates=[select Id
                                          from Account
                                          where ( RecordTypeId=:Label.CPT_RecordTypeId_CompteProspectClient
                                            or RecordTypeId=:Label.CPT_RecordTypeId_Administration15
                                            or RecordTypeId=:Label.CPT_RecordTypeId_MultiNiveau
                                            or RecordTypeId=:Label.CPT_RecordTypeId_GrandCompte)
                                          and EstCompteEnfant__c=TRUE
                                          and Statut__c!=:Label.CPT_Statut_Inactif
                                          and TECHIdNatCPExp__c=:dupKey];
            if(listDuplicates.size()>1){
                isDuplicate=TRUE;
            }
        }*/
        
        // Retrieving all RecordType
        List<RecordType> rts = [SELECT Id, Name FROM RecordType 
                                WHERE SObjectType='ACCOUNT'];
        // all RecordType put in a map with Id as key and Name as value
        Map<String, String> allRtMap = new Map<String, String>();
        for(RecordType rt : rts) {
            allRtMap.put(rt.Id, rt.Name);
        }
        
        // Retrieving all TECHTypeIdentifiantNational__c
        Map<String, TypeIdentifiantNational__c> allTinMap = TypeIdentifiantNational__c.getAll();
        // TECHTypeIdentifiantNational__c put in a new map with Libelle_[USER LANGUAGE]__c as key
        Map<String, TypeIdentifiantNational__c> tinByLibelleMap = new Map<String, TypeIdentifiantNational__c>();
        for(TypeIdentifiantNational__c tin : allTinMap.values()) {
            tinByLibelleMap.put(string.valueof(tin.get('Libelle_'+UserLanguage+'__c')), tin);
        }
        
        // Retrieving all CodeAgence__c
        //Map<String, CodeAgence__c> allCodesAgences = [SELECT id,Name,Libelle_fr__c,Nom_Agence__c,Numero_Agence__c from CodeAgence__c];//CodeAgence__c.getAll();
        // CodeAgence__c put in a new map with Libelle_[USER LANGUAGE]__c as key
        Map<String, CodeAgence__c> codeAgenceByNomMap = new Map<String, CodeAgence__c>();
        for(CodeAgence__c ca : [SELECT id,Name,Libelle_fr__c,Nom_Agence__c,Numero_Agence__c from CodeAgence__c]/*allCodesAgences.values()*/) {
            codeAgenceByNomMap.put(string.valueof(ca.get('Libelle_'+UserLanguage+'__c')), ca);
        }
        
        // Retrieving all Effectifs
        Map<String, Effectifs__c> allEffectifs = Effectifs__c.getAll();
        // Effectif__c put in a new map with workForce__c as key
        for(Effectifs__c e : allEffectifs.values()) {
            EffectifByworkForceeMap.put(e.workForce__c, e.Effectif__c);
        }
        
        // Retrieving all CodesPays__c
        Map<String, CodesPays__c> allCodesPaysMap = CodesPays__c.getAll();
        
        // According to user language, we choose which libelle language to use
        //schema.describefieldresult dfield = AP09Compte.retrieveLibelleCodePays();
        
        if(!isDuplicate) { //dfield != null && 
            // CodesPays__c put in a new map with Libelle_[USER LANGUAGE]__c as key
            Map<String, String> cpByLibelleMap = new Map<String, String>();
            for(SObject cp : allCodesPaysMap.values()) {
                
                cpByLibelleMap.put(String.valueOf(cp.get('Libelle_'+UserLanguage+'__c')), ((CodesPays__c)cp).Code_Pays2__c);
              
            }
            // CodesPays__c put in a new map with Code_Pays__c as key
            Map<String, String> cpByCodePays2Map = new Map<String, String>();
            for(CodesPays__c cp : allCodesPaysMap.values()) {
                cpByCodePays2Map.put(((CodesPays__c)cp).Code_Pays2__c, String.valueOf(cp.get('Libelle_'+UserLanguage+'__c')));
            }
            
            
            // creating a set of userId whom made the last modification on news accounts
            Set<Id> lastModifUserIdSet = new Set<Id>();
            for(Account a : news) {
                lastModifUserIdSet.add(a.OwnerId);
            }
            // retrieving users whose Id is in lastModifUserIdSet
            List<User> lastModifUsers = [SELECT Id, Username FROM User 
                                         WHERE Id IN :lastModifUserIdSet];
            // creating a map with userId as key and username as value
            Map<String, String> lastModifUserNamesMap = new Map<String, String>();
            for(User u : lastModifUsers) {
                lastModifUserNamesMap.put(u.Id, u.Username);
            }
            
            map<string,Account> newsToUpdate = new map<string,Account>(); 
            List<Account> ToBeResend = new List<Account>(); 
            List<LogInterfaces__c> logs = new List<LogInterfaces__c>();
            // Calling the Web Service for each account in news
            for(Account a : news) {
                Http http = new Http();
                
                // setting the request header parameters
                HttpRequest req = AP09Compte.prepareRequestHeader(a, lastModifUserNamesMap);
                 
                
                // Setting the body of the request
                req.setBody(AP09Compte.createXmlString(a, allRtMap, tinByLibelleMap, cpByLibelleMap, codeAgenceByNomMap));
                system.debug('Request BODY ==>'+req.getBody());
                system.debug('Request Header User ==>'+req.getHeader('User'));
                system.debug('Request Header Password ==>'+req.getHeader('Password'));
                system.debug('Request Header ApplicationName ==>'+req.getHeader('ApplicationName'));
                system.debug('Request Header ApplicationInstanceId ==>'+req.getHeader('ApplicationInstanceId'));
                system.debug('Request Header ApplicationUsername ==>'+req.getHeader('ApplicationUsername'));

                
                HttpResponse resp = new HttpResponse();
                if(!Test.isRunningTest()) {
                    // The request is sent again in case of response status equal to 500, 502, 504
                    
                        resp = http.send(req);
                        
                        LogInterfaces__c log = new LogInterfaces__c(CodeRetour__c = resp.getStatusCode(),
                                                   IDSalesforceEnregistrement__c = a.Id,
                                                   StatutMessage__c = resp.getStatus(),
                                                   TypeObjet__c = 'Compte',
                                                   Flux__c = 'Euler-Hermès');
                        logs.add(log);                       
                }
                else {
                    // Create a response when running a test
                    if(a.Name == 'AccountTest')
                    {resp = AP09Compte.generateTestResponse2(resp);}
                    else
                    {resp = AP09Compte.generateTestResponse3(resp);}
                    
                    newsToUpdate = AP09Compte.completeAccountsWithWSInfo(newsToUpdate, ToBeResend, a, resp,
                                                                    cpByCodePays2Map);
                    resp = AP09Compte.generateTestResponse(resp);
                    newsToUpdate = new map<string,Account>();
                }
                System.debug('###Retour du web service : ' + resp.getBody());
                System.debug('###Statut réponse : '+ resp.getStatusCode());
                System.debug('###Statut réponse : '+ resp.getStatus());
                newsToUpdate = AP09Compte.completeAccountsWithWSInfo(newsToUpdate, ToBeResend, a, resp,
                                                                    cpByCodePays2Map);
            }
            System.debug('###On arrive à l\'update');
            if(ToBeResend.size()>0)
            {
                processCreation2(ToBeResend, true, false);
            }
            if (!Resend)
            {
                //update newsToUpdate;
                
                Database.SaveResult[] srList = Database.update(newsToUpdate.values(), false);
                list<FeedItem> ParentlessPosts = new list<FeedItem>();
                list<FeedItem> SeparatedPosts = new list<FeedItem>();
                list<FeedItem> Posts = new list<FeedItem>();
                list<Account> ReUpdate = new list<Account>();
                
                //Get Credit Management Users
                for(GroupMember gm: [   select UserOrGroupId
                                        from GroupMember
                                        where Group.Id=: Label.PBG_Id_CreditManagement]){
                    creditManagementUsers.add(gm.UserOrGroupId);
                }

                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get('Account');
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

                // Iterate through each returned result
                for (Integer i = 0; i < srList.size(); i++) {
                    Database.SaveResult sr = srList[i];
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully updated account. Account ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errorscaused by SFAC
                            Database.Error err = sr.getErrors()[0];
                            set<string> Fields = new set<string>(err.getFields());
                            if(Fields.contains('DateCotationPF__c')
                                || Fields.contains('ListeNoire__c')
                                || Fields.contains('DateAgrementEH__c')
                                || Fields.contains('AgrementSFAC__c')
                                || Fields.contains('CotationPF__c'))
                                {
                                    //ReUpdate failed Accounts
                                    Account tempAccount = newsToUpdate.get(newsToUpdate.values()[i].Id);                                    
                                    tempAccount.DateCotationPF__c = oldSFACMap.get(newsToUpdate.values()[i].Id).DateCotationPF;
                                    tempAccount.CotationPF__c = oldSFACMap.get(newsToUpdate.values()[i].Id).CotationPF;
                                    system.debug(tempAccount.CotationPF__c);
                                    tempAccount.DateAgrementEH__c = oldSFACMap.get(newsToUpdate.values()[i].Id).DateAgrementEH;
                                    tempAccount.AgrementSFAC__c = oldSFACMap.get(newsToUpdate.values()[i].Id).AgrementSFAC;
                                    tempAccount.ListeNoire__c = oldSFACMap.get(newsToUpdate.values()[i].Id).ListeNoire;
                                    ReUpdate.add(tempAccount);
                                    
                                    //Post Chatter to Credit Management Users
                                    //for(Id s : creditManagementUsers)
                                    //{
                                    
                                    if(!creditManagementUsers.contains(newsToUpdate.values()[i].OwnerId))
                                    {
                                        FeedItem temp0 = new FeedItem();
                                        temp0.ParentId = newsToUpdate.values()[i].OwnerId;
                                        temp0.Body = Label.CPT_ChatterNotif_ErreurSuivante
                                                    + ' '
                                                    + newsToUpdate.values()[i].Name
                                                    + ', ID - '
                                                    + newsToUpdate.values()[i].Id
                                                    + ':\n"' 
                                                    + err.getStatusCode() 
                                                    + ': ' 
                                                    + err.getMessage() 
                                                    + '"\n' 
                                                    + Label.CPT_ChatterNotif_ChampsErreur
                                                    + ' ' 
                                                    + fieldMap.get(err.getFields()[0]).getDescribe().getLabel()
                                                    + (err.getFields().size()>1?', '+fieldMap.get(err.getFields()[1]).getDescribe().getLabel():'')
                                                    + (err.getFields().size()>2?', '+fieldMap.get(err.getFields()[2]).getDescribe().getLabel():'')
                                                    + (err.getFields().size()>3?', '+fieldMap.get(err.getFields()[3]).getDescribe().getLabel():'')
                                                    + (err.getFields().size()>4?', '+fieldMap.get(err.getFields()[4]).getDescribe().getLabel():'')
                                                    + '\n'
                                                    +Label.CPT_ChatterNotif_NoSFAC;
                                        Posts.add(temp0);
                                     }
                                    
                                        FeedItem temp = new FeedItem();
                                        //temp.ParentId = s;
                                        temp.Body = Label.CPT_ChatterNotif_ErreurSuivante
                                                    + ' '
                                                    + newsToUpdate.values()[i].Name
                                                    + ', ID - '
                                                    + newsToUpdate.values()[i].Id
                                                    + ':\n"' 
                                                    + err.getStatusCode() 
                                                    + ': ' 
                                                    + err.getMessage() 
                                                    + '"\n' 
                                                    + Label.CPT_ChatterNotif_ChampsErreur
                                                    + ' ' 
                                                    + fieldMap.get(err.getFields()[0]).getDescribe().getLabel()
                                                    + (err.getFields().size()>1?', '+fieldMap.get(err.getFields()[1]).getDescribe().getLabel():'')
                                                    + (err.getFields().size()>2?', '+fieldMap.get(err.getFields()[2]).getDescribe().getLabel():'')
                                                    + (err.getFields().size()>3?', '+fieldMap.get(err.getFields()[3]).getDescribe().getLabel():'')
                                                    + (err.getFields().size()>4?', '+fieldMap.get(err.getFields()[4]).getDescribe().getLabel():'')
                                                    + '\n'
                                                    +Label.CPT_ChatterNotif_NoSFAC;
                                        ParentlessPosts.add(temp);
                                    //}
                                }
                        //}
                    }
                }
                for(Id s : creditManagementUsers)
                {
                    SeparatedPosts.add(new FeedItem(ParentId = s));
                    list<FeedItem> ClonedList = ParentlessPosts.DeepClone();
                    SeparatedPosts.addAll(ClonedList);
                }
                string tempParentId = '';
                for(FeedItem fi : SeparatedPosts)
                {
                    if(fi.ParentId != null)
                    {
                        tempParentId = fi.ParentId;
                    }
                    else
                    {
                        fi.ParentId = tempParentId;
                        Posts.add(fi);
                    }
               }
               if(Posts.size()>0)
               {
                   insert Posts;
               }
                update ReUpdate;
            }
            insert logs;
            System.debug('###On a fait l\'update');
        }
    }
    
    public static String createXmlString(Account account, Map<String, String> allRtMap, 
                                        Map<String, TypeIdentifiantNational__c> tinByLibelleMap,
                                        Map<String, String> cpByLibelleMap,
                                        Map<String, CodeAgence__c> codeAgenceByNomMap) {
                                  System.debug('###Dans createXMLString');
        String xmlString = '<AccountCreate><AccountName><![CDATA[' +account.Name+ ']]></AccountName>';
        xmlString += '<AccountType><![CDATA[' +allRtMap.get(account.RecordTypeId)+ ']]></AccountType>';
        xmlString += '<AccountStatus><![CDATA[' +account.Statut__c+ ']]></AccountStatus>';
        xmlString += '<AccountCategory><![CDATA[' +account.CategorieCompte__c+ ']]></AccountCategory>';
        xmlString += '<IsVIP><![CDATA[' +account.IrreductibleVIP__c+ ']]></IsVIP>';
        xmlString += '<AccountParentId><![CDATA[' +account.ParentId+ ']]></AccountParentId>';
        xmlString += '<CompanyCodePF><![CDATA[' +account.PaysRegionPF__c+ ']]></CompanyCodePF>';
        xmlString += '<AgencyCodePF><![CDATA[';
        if(account.AgencePF__c != null && account.AgencePF__c != '') {     
            xmlString += codeAgenceByNomMap.get(account.AgencePF__c).Numero_Agence__c;
        }
        xmlString += ']]></AgencyCodePF>';
        if(account.TECHIdentifiantNational__c != null) {     
            //Si l'identifiant est un SIRET, envoyer le SIREN correspondant à EH.
            string idNat=account.TECHIdentifiantNational__c;//.replace(' ', '');
            /*VALEUR DE TYPE D'IDENTIFIANT "SIRET" SUPPRIMEE
            if(account.TECHTypeIdentifiantNational__c==Label.CPT_TypeIdentifiantNational_SIRET){
                idNat=idNat.substring(0, 9);
            }*/
            
            xmlString += '<LegalIdentifier country ="' 
                +tinByLibelleMap.get(account.TECHTypeIdentifiantNational__c).CodePays__c
                + '" type="' 
                +tinByLibelleMap.get(account.TECHTypeIdentifiantNational__c).Code__c
                + '"><![CDATA[' 
                +idNat+ ']]></LegalIdentifier>';
        }
        else if(account.ParentId!=null){
            if(account.Parent.TECHIdentifiantNational__c!=null){     
                //Si l'identifiant est un SIRET, envoyer le SIREN correspondant à EH.
                string parentIdNat=account.Parent.TECHIdentifiantNational__c.replace(' ', '');
                /*VALEUR DE TYPE D'IDENTIFIANT "SIRET" SUPPRIMEE
                if(account.Parent.TECHTypeIdentifiantNational__c==Label.CPT_TypeIdentifiantNational_SIRET){
                    parentIdNat=parentIdNat.substring(0, 9);
                }*/
                
                xmlString += '<LegalIdentifier country ="' 
                    +tinByLibelleMap.get(account.Parent.TECHTypeIdentifiantNational__c).CodePays__c
                    + '" type="' 
                    +tinByLibelleMap.get(account.Parent.TECHTypeIdentifiantNational__c).Code__c
                    + '">' 
                    +parentIdNat+ '</LegalIdentifier>';
            }
        }
        else {
            xmlString += '<LegalIdentifier />';
        }
        xmlString += '<Address type="Operating">';
        xmlString += '<AddressLine1><![CDATA[' +(account.Ligne1Exploitation__c==null?'':account.Ligne1Exploitation__c)+ ']]></AddressLine1>';
        xmlString += '<AddressLine2><![CDATA[' +(account.Ligne2Exploitation__c==null?'':account.Ligne2Exploitation__c)+ ']]></AddressLine2>';
        xmlString += '<AddressLine3><![CDATA[' +(account.Ligne3Exploitation__c==null?'':account.Ligne3Exploitation__c)+ ']]></AddressLine3>';
        xmlString += '<AddressLine4><![CDATA[' +(account.Ligne4Exploitation__c==null?'':account.Ligne4Exploitation__c)+ ']]></AddressLine4>';
        xmlString += '<PostalCode><![CDATA[' +(account.CodePostalExploitation__c==null?'':account.CodePostalExploitation__c)+ ']]></PostalCode>';
        xmlString += '<City><![CDATA[' +(account.VilleExploitation__c==null?'':account.VilleExploitation__c)+ ']]></City>';
        xmlString += '<CountryCode><![CDATA[' +(cpByLibelleMap.get(account.PaysExploitation__c)==null?'':cpByLibelleMap.get(account.PaysExploitation__c))+ ']]></CountryCode>';
        xmlString += '</Address></AccountCreate>';
        
        System.debug('XML : '+xmlString);
        return xmlString;
                                            
    }
    
    

    public static HttpRequest prepareRequestHeader(Account a, Map<String, String> lastModifUserNamesMap) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).EndPoint__c);
        req.setMethod(WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).Methode__c);
        req.setHeader('User', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).UserName__c);
        req.setHeader('Password', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).ContentType__c);
        req.setHeader('ApplicationName', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).ApplicationName__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).Authorization__c);
        req.setHeader('ApplicationInstanceId', UserInfo.getOrganizationId());
        req.setHeader('ApplicationInstanceName', Label.WS_ApplicationInstanceName);
        // The user needed is the account last modifier one, not the account owner
        req.setHeader('ApplicationUserId', a.OwnerId);
        req.setHeader('ApplicationUsername', 
                     lastModifUserNamesMap.get(a.OwnerId));
        req.setHeader('ApplicationRecordId', a.Id);
        return req;
        
    }
    
    /*public static void createLogEH(HttpResponse resp, Account a) {
        LogInterfaces__c log = new LogInterfaces__c(CodeRetour__c = resp.getStatusCode(),
                                                   IDSalesforceEnregistrement__c = a.Id,
                                                   StatutMessage__c = resp.getStatus(),
                                                   TypeObjet__c = 'Compte',
                                                   Flux__c = 'Euler-Hermès');
        insert log;
    }*/
    
    public static HttpResponse generateTestResponse(HttpResponse resp) {
        resp.setStatusCode(200);
                resp.setHeader('Server', 'nginx/1.8.0');
                resp.setHeader('Date', 'Wed, 04 Nov 2015 17:44:58 GMT ');
                resp.setHeader('Content-Type', 'application/xml');
                resp.setHeader('Transfer-Encoding', 'chunked');
                resp.setHeader('Connection', 'keep-alive');
                resp.setHeader('ApplicationName', 'PF_MDM');
                resp.setHeader('ApplicationRecordId', 'a64de8be-01ad-40c9-bbc4-fb3fc96eb18c');
                resp.setBody('<AccountCreateResponse><AccountId>a64de8be-01ad-40c9-bbc4-fb3fc96eb18c</AccountId>'
                             +'<AccountName>GAUTHIER</AccountName><AccountType>Compte Multi-Niveaux</AccountType>'
                             +'<AccountParentId /><LegalInformations><LegalSourceId source="EH">9999'
                             +'</LegalSourceId><LegalIdentifier country="FR" type="SIREN">481842888'
                             +'</LegalIdentifier><LegalName>GAUTHIER</LegalName><CreationDate>2010-03-04'
                            +'</CreationDate>'
                             +'<LegalForm code="SA16">AUTRE SA A DIRECTOIRE</LegalForm><LegalType code="C">Société'
                             +'</LegalType><ActiveStatus code="A">Actif</ActiveStatus><TradeSector code="7415">'
                             +'ACT. DE GESTION ET ADM. DE HOLDINGS</TradeSector><Address code="A" type="Siège '
                             +'social"><AddressLine1>42 AV DE FRIEDLAND</AddressLine1><AddressLine2 />'
                             +'<AddressLine3 /><AddressLine4 /><PostalCode>75008</PostalCode><City>PARIS 8</City>'
                             +'<CountryCode>FR</CountryCode><PhoneNumber>0144902300</PhoneNumber><FaxNumber />'
                             +'<EmailAddress /><WebSiteAddress /></Address><CompanyExternalIdentifiers>'
                             +'<LegalIdentifier country="FR" type="SIREN" priorityNumber="1" '
                             +'nationalIdentifierFlag="true">481842888</LegalIdentifier>'
                             +'</CompanyExternalIdentifiers><ParentSourceId /><capitalAmount currencyCode="EUR">'
                             +'20000000</capitalAmount></LegalInformations><SFAC CompanyCodePF="RPF1">'
                             +'<CotationDate>2015-03-04T09:12:31</CotationDate><Grade>70000</Grade><AgrementDate>'
                             +'2015-03-04T00:00:00</AgrementDate><Agrement>20000</Agrement><isConfidential>'
                             +'false</isConfidential></SFAC><CrossRefs><CrossRef ApplicationName="SFDC" '
                             +'ApplicationInstanceName="GF" ApplicationInstanceId="abcd0123456789">'
                             +'40cfad6c-8226-11e5-8bcf-feff819cdc9f</CrossRef></CrossRefs></AccountCreateResponse>') ;
        return resp;
    }
    
    public static HttpResponse generateTestResponse2(HttpResponse resp) {
        resp.setStatusCode(400);
                resp.setHeader('Server', 'nginx/1.8.0');
                resp.setHeader('Date', 'Wed, 04 Nov 2015 17:44:58 GMT ');
                resp.setHeader('Content-Type', 'application/xml');
                resp.setHeader('Transfer-Encoding', 'chunked');
                resp.setHeader('Connection', 'keep-alive');
                resp.setHeader('ApplicationName', 'PF_MDM');
                resp.setHeader('ApplicationRecordId', 'a64de8be-01ad-40c9-bbc4-fb3fc96eb18c');
        return resp;
    }

    public static HttpResponse generateTestResponse3(HttpResponse resp) {
        resp.setStatusCode(404);
                resp.setHeader('Server', 'nginx/1.8.0');
                resp.setHeader('Date', 'Wed, 04 Nov 2015 17:44:58 GMT ');
                resp.setHeader('Content-Type', 'application/xml');
                resp.setHeader('Transfer-Encoding', 'chunked');
                resp.setHeader('Connection', 'keep-alive');
                resp.setHeader('ApplicationName', 'PF_MDM');
                resp.setHeader('ApplicationRecordId', 'a64de8be-01ad-40c9-bbc4-fb3fc96eb18c');
        return resp;
    }

    
    public static map<string,Account> completeAccountsWithWSInfo(
        map<string,Account> newsToUpdate, List<Account> ToBeResend, Account a, HttpResponse resp, 
        Map<String, String> cpByCodePays2Map) {
            
            //Saving old SFAC values
            if(!oldSFACMap.keyset().contains(a.Id))
            {
                OldSFACMap.put(a.Id, new wrapperOldSFAC(a));
            }
            
        String body = resp.getBody();
        system.debug('Response Body: '+body);
        // Changing the account fields according to the response status
        if(resp.getStatusCode() == 200){
            //if(a.Statut__c != Label.CPT_Statut_Valide) {
                            
                a.Statut__c = Label.CPT_Statut_Valide;
                
                a.IDMDM__c = body.substringBetween('<AccountId>', '</AccountId>');    
                
                a.Type = body.substringBetween('<AccountType>', '</AccountType>');
                a.IDEulerHermes__c = 
                    body.substringBetween('<LegalSourceId source="EH">', '</LegalSourceId>');
                
                //a.NomCommercial__c = a.Name;
                
                a.NomCommercial__c = body.substringBetween('<LegalName>', '</LegalName>')!=NULL?body.substringBetween('<LegalName>', '</LegalName>').unescapeHtml4():body.substringBetween('<LegalName>', '</LegalName>');
                
                String anneeCreation = body.substringBetween('<CreationDate>', '</CreationDate>');
                if(anneeCreation != '') {
                    a.AnneeCreation__c = Integer.valueOf(anneeCreation.substring(0, 4));
                }
                
                a.Ownership = body.substringBetween('<LegalForm code="', '">');
                
                String tradeSector = body.substringBetween('<TradeSector code="', '</TradeSector>');
                a.CodeNACE__c = tradeSector.substringBefore('">')!=NULL?tradeSector.substringBefore('">').unescapeHtml4():tradeSector.substringBefore('">');
                
                a.ActivitePrincipaleExercee__c = tradeSector.substringAfter('">').unescapeHtml4();
                
               // a.Ligne1__c = body.substringBetween('<AddressLine1>', '</AddressLine1>')!=NULL?body.substringBetween('<AddressLine1>', '</AddressLine1>').unescapeHtml4():body.substringBetween('<AddressLine1>', '</AddressLine1>');
                
               // a.Ligne2__c = body.substringBetween('<AddressLine2>', '</AddressLine2>')!=NULL?body.substringBetween('<AddressLine2>', '</AddressLine2>').unescapeHtml4():body.substringBetween('<AddressLine2>', '</AddressLine2>');
                //a.Ligne3__c = body.substringBetween('<AddressLine3>', '</AddressLine3>')!=NULL?body.substringBetween('<AddressLine3>', '</AddressLine3>').unescapeHtml4():body.substringBetween('<AddressLine3>', '</AddressLine3>');
               // a.Ligne4__c = body.substringBetween('<AddressLine4>', '</AddressLine4>')!=NULL?body.substringBetween('<AddressLine4>', '</AddressLine4>').unescapeHtml4():body.substringBetween('<AddressLine4>', '</AddressLine4>');
               // a.CodePostal__c = body.substringBetween('<PostalCode>', '</PostalCode>')!=NULL?body.substringBetween('<PostalCode>', '</PostalCode>').unescapeHtml4():body.substringBetween('<PostalCode>', '</PostalCode>');
               // a.Ville__c = body.substringBetween('<City>', '</City>')!=NULL?body.substringBetween('<City>', '</City>').unescapeHtml4():body.substringBetween('<City>', '</City>');
              //  String codePays = body.substringBetween('<CountryCode>', '</CountryCode>')!=NULL?body.substringBetween('<CountryCode>', '</CountryCode>').unescapeHtml4():body.substringBetween('<CountryCode>', '</CountryCode>');
               // a.Pays__c = cpByCodePays2Map.get(codePays);
                
                a.Phone = body.substringBetween('<PhoneNumber>', '</PhoneNumber>');
               
                a.Fax = body.substringBetween('<FaxNumber>', '</FaxNumber>');
                
                a.EmailPrincipal__c = body.substringBetween('<EmailAddress>', '</EmailAddress>')!=NULL?body.substringBetween('<EmailAddress>', '</EmailAddress>').unescapeHtml4():body.substringBetween('<EmailAddress>', '</EmailAddress>');
                
                a.Website = body.substringBetween('<c>', '</WebSiteAddress>')!=NULL?body.substringBetween('<c>', '</WebSiteAddress>').unescapeHtml4():body.substringBetween('<c>', '</WebSiteAddress>');
                
                a.Effectif__c = EffectifByworkForceeMap.get(body.substringBetween('<workForce>', '</workForce>'));    

                if(!body.contains('<capitalAmount currencyCode="" />')) {
                    String capitalAmount = body.substringBetween('<capitalAmount currencyCode="', '</capitalAmount>');
                    if(capitalAmount != '') {
                        String devise = capitalAmount.substringBefore('\">');
                        String amount = capitalAmount.substringAfter('\">');
                        if(amount.containsNone('.')) {
                            amount += '.00';
                        }
                        amount = amount.replace(' ', '');
                        a.CapitalSocial__c = Decimal.valueOf(amount);
                        System.debug('###a.CapitalSocial__c : '+a.CapitalSocial__c);
                    }
                }
                String dateCotation = body.substringBetween('<CotationDate>', '</CotationDate>');
            System.debug('DateCotation :'+dateCotation);
                if(dateCotation !=NULL && dateCotation!='') {
                    System.debug('###CotationDateParsing');
                    string dateString=dateCotation.substringBefore('T');
                    list<string> listDateElements=dateString.split('-');
                    
                        if(listDateElements[2].length()>2){
                        	dateString=listDateElements[2]+'-'+listDateElements[1]+'-'+listDateElements[0];
                    	}
                    
                    a.DateCotationPF__c = Date.valueOf(dateString.substringBefore('T'));
                    System.debug('###a.DateCotationPF__c : '+a.DateCotationPF__c);
                }
                String grade = body.substringBetween('<Grade>', '</Grade>');
            	system.debug('GRADE :'+grade);
                if(grade!=NULL && grade!='' && grade!='NA' ) {
                    
                    a.CotationPF__c = Decimal.valueOf(grade);
                    
                }
            
                String agrementDate = body.substringBetween('<AgrementDate>', '</AgrementDate>');
                /*On reçoit parfois une date de format 'dd-mm-yyyy'. Le format désiré est 'yyyy-mm-dd'.
                Le traitement ci-dessous est spécifique pour ce cas, et ne traite pas d'autre formats de date possibles.*/
                if(agrementDate != '') {
                    string dateString=agrementDate.substringBefore('T');
                    list<string> listDateElements=dateString.split('-');
                    if(listDateElements[2].length()>2){
                        dateString=listDateElements[2]+'-'+listDateElements[1]+'-'+listDateElements[0];
                    }
                    a.DateAgrementEH__c = Date.valueOf(dateString);
                }
                String agrement = body.substringBetween('<Agrement>', '</Agrement>');
                if(agrement != '') {
                    a.AgrementSFAC__c = Decimal.valueOf(agrement);
                
                }
                String listeNoire = body.substringBetween('<isConfidential>', '</isConfidential>');
                if(listeNoire != '' && listeNoire != null) {
                    a.ListeNoire__c = Boolean.valueOf(listeNoire);
                
                }
                // Setting the Web Service Attempts Counter to 0 as it succeded
                a.TECHCompteurAppelsWS__c = 0;
                system.debug('Compteur apres : '+a.TECHCompteurAppelsWS__c);
                System.debug('###Compte avec infos supplémentaires From MDM : ' + a);
                // Setting the update by web service control 
                a.TECHWS__c = !a.TECHWS__c;
              /*		  if(a.RecopierAdressePrincipale__c
                    && (a.Ligne1__c != a.Ligne1Exploitation__c
                        || a.Ligne2__c != a.Ligne2Exploitation__c
                        || a.Ligne3__c != a.Ligne3Exploitation__c
                        || a.Ligne4__c != a.Ligne4Exploitation__c
                        || a.CodePostal__c != a.CodePostalExploitation__c
                        || a.Ville__c != a.VilleExploitation__c
                        || a.Pays__c != a.PaysExploitation__c)
                )
                {
                    a.Ligne1Exploitation__c = a.Ligne1__c;
                    a.Ligne2Exploitation__c = a.Ligne2__c;
                    a.Ligne3Exploitation__c = a.Ligne3__c;
                    a.Ligne4Exploitation__c = a.Ligne4__c;
                    a.CodePostalExploitation__c = a.CodePostal__c;
                    a.VilleExploitation__c = a.Ville__c;
                    a.PaysExploitation__c = a.Pays__c;
                    ToBeResend.add(a);
                    a.TECHWS__c = !a.TECHWS__c;
                }*/

                newsToUpdate.put(a.id,a);
            //}
        }
            
        else if(resp.getStatusCode() == 400) {
            a.TECHCompteurAppelsWS__c = 0;
            //if(a.Statut__c != Label.CPT_Statut_Bloque) {
            if(!System.isBatch()
                ||(System.isBatch() && a.Statut__c==Label.CPT_Statut_Draft))
            {
                a.Statut__c = Label.CPT_Statut_Bloque;
            }
                a.TECHWS__c = !a.TECHWS__c;
               

                newsToUpdate.put(a.id,a);
            //}   
            /*else if(a.RecopierAdressePrincipale__c
                    && (a.Ligne1__c != a.Ligne1Exploitation__c
                        || a.Ligne2__c != a.Ligne2Exploitation__c
                        || a.Ligne3__c != a.Ligne3Exploitation__c
                        || a.Ligne4__c != a.Ligne4Exploitation__c
                        || a.CodePostal__c != a.CodePostalExploitation__c
                        || a.Ville__c != a.VilleExploitation__c
                        || a.Pays__c != a.PaysExploitation__c)
                )
                {
                    a.Ligne1Exploitation__c = a.Ligne1__c;
                    a.Ligne2Exploitation__c = a.Ligne2__c;
                    a.Ligne3Exploitation__c = a.Ligne3__c;
                    a.Ligne4Exploitation__c = a.Ligne4__c;
                    a.CodePostalExploitation__c = a.CodePostal__c;
                    a.VilleExploitation__c = a.Ville__c;
                    a.PaysExploitation__c = a.Pays__c;
                    //a.TECHWS__c = !a.TECHWS__c;
                    ToBeResend.add(a);
                    newsToUpdate.put(a.id,a);
                }*/

        }
            
        /*if(resp.getStatusCode() == 404) {
            if(a.Statut__c != Label.CPT_Statut_Erreur_EH) {
                a.Statut__c = Label.CPT_Statut_Erreur_EH;
                a.TECHCompteurAppelsWS__c = 0;
                a.TECHWS__c = !a.TECHWS__c;
                newsToUpdate.put(a.id,a);
            }
        }*/
            
        else if(resp.getStatusCode() == 404 || resp.getStatusCode() == 500 || 
           resp.getStatusCode() == 502 || resp.getStatusCode() == 504) {
            //if(a.Statut__c != Label.CPT_Statut_Erreur_EH) {
                a.Statut__c = Label.CPT_Statut_Erreur_EH;
                if(a.TECHCompteurAppelsWS__c == null) {
                    a.TECHCompteurAppelsWS__c = 0;
                }
                a.TECHCompteurAppelsWS__c = 
                    (a.TECHCompteurAppelsWS__c == Decimal.valueOf(Label.CalloutRepetitionNumber)) ? 
                    0 : ++a.TECHCompteurAppelsWS__c;
                a.TECHWS__c = !a.TECHWS__c;
                

                newsToUpdate.put(a.id,a);
            //}  
        }
        return newsToUpdate;
    }
    
    @future (callout=true)
    public static void ProcessUpdateAccountGradeInformation(Set<Id> accSetIds)
    {
        List<Account> AccounList =[SELECT ID,TECHTypeIdentifiantNational__c,TECHIdentifiantNational__c,Name,TypeIdentifiantNational__c,IdentifiantNational__c,Policy_Id__c,CotationPF__c,Pays__c
                                  from Account where Id in :accSetIds];
        for(Account acc : AccounList)
        {
            UpdateAccountGradeInformation(acc);
        }
    }
    
    
    
    public static void UpdateAccountGradeInformation(Account acc)
    {
        
        Map<String, String> companyInformation = new Map<String, String>();
        String policyId = '';
        String businessUnitCode;
        Map<String, TypeIdentifiantNational__c> allTinMap = TypeIdentifiantNational__c.getAll();
        Map<String, TypeIdentifiantNational__c> tinByLibelleMap = new Map<String, TypeIdentifiantNational__c>();
        for(TypeIdentifiantNational__c tin : allTinMap.values()) {
            tinByLibelleMap.put(string.valueof(tin.get('Libelle_'+UserLanguage+'__c')), tin);
        }

        if(acc.TypeIdentifiantNational__c != null && acc.IdentifiantNational__c != null) {
            List<PolicyId_Legal_Entity__c> tempList = PolicyId_Legal_Entity__c.getAll().values();
            Map<String,String> PolicyIdByCountryMap = new Map<String, String>();
            Map<String,String> businessUnitCodeByCountryMap = new Map<String, String>();
            for(PolicyId_Legal_Entity__c ple : tempList) {
                PolicyIdByCountryMap.put(ple.Pays__c, ple.policyId__c);
                businessUnitCodeByCountryMap.put(ple.Pays__c, ple.Business_Unit_Code__c);
            }
            policyId = PolicyIdByCountryMap.get(acc.Pays__c).substringAfter('A');
            businessUnitCode = businessUnitCodeByCountryMap.get(acc.Pays__c);
            companyInformation = AllianzWebServiceRest.companyInformation(tinByLibelleMap.get(acc.TypeIdentifiantNational__c).CodePays__c, acc.TypeIdentifiantNational__c, acc.IdentifiantNational__c, businessUnitCode, policyId);
            if(companyInformation.containsKey('gradeCode') && (companyInformation.get('gradeCode') != null && companyInformation.get('gradeCode') != '')) {
                String grade = companyInformation.get('gradeCode');
                ////Apply results
                acc.CotationPF__c = Decimal.valueOf(grade);
                acc.Tech_ListeEH__c = true;
                acc.DateCotationPF__c = Date.valueOf(companyInformation.get('lastRefreshDate'));
                Update acc;
            }
        }
        
        // Decimal gradeValue=null;
        // Http http = new Http();
        // HttpRequest req = new HttpRequest();
        // String endpoint='';
        //  if(Test.isRunningTest()){
        //     WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_000',
        //                                                            EndPoint__c = 'https://api-test.petitforestier.fr/api/services/PFCustomersRepository/Account',
        //                                                            Methode__c = 'POST',
        //                                                            UserName__c = 'mdm_sfdc',
        //                                                            MotDePasse__c = '5:?MWWE6-tm9fcW4',
        //                                                            ContentType__c = 'application/xml',
        //                                                            ApplicationName__c = 'SFCD',
        //                                                            Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        //     insert wspr1;
        //  }
        // else 
        // {
        //       if(account.TECHIdentifiantNational__c != null){
        //     endpoint=WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).EndPoint__c+'/'+tinByLibelleMap.get(acc.TECHTypeIdentifiantNational__c).CodePays__c+'/'+tinByLibelleMap.get(acc.TECHTypeIdentifiantNational__c).Code__c+'/'+acc.TECHIdentifiantNational__c;
        // 		}
        //     System.debug(endpoint);
        
        // req.setEndpoint(endpoint);
        // req.setMethod(WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).Methode__c);
        // req.setHeader('User', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).UserName__c);
        // req.setHeader('Password', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).MotDePasse__c);
        // req.setHeader('Content-Type', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).ContentType__c);
        // req.setHeader('Authorization', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).Authorization__c);
        // HttpResponse resp = new HttpResponse();
        // resp = http.send(req);
        // System.debug('###ResponseCode '+resp.getStatus());
        // // Changing the account fields according to the response status
        // if(resp.getStatusCode() == 200){
        // 	String body=resp.getBody();
        //     System.debug('###response body :'+body);
        //     String grade = body.substringBetween('<Grade>', '</Grade>');
        //     system.debug('GRADE :'+grade);
        //     if(grade!=NULL && grade!='' && grade!='NA') {
                
        //         acc.CotationPF__c = Decimal.valueOf(grade);
        //         gradeValue=Decimal.valueOf(grade);
        //         acc.Tech_ListeEH__c=true;
                
        //     }
        //     String dateCotation = body.substringBetween('<CotationDate>', '</CotationDate>');
        //     System.debug('DateCotation :'+dateCotation);
        //     if(dateCotation !=NULL && dateCotation!='') {
        //         System.debug('###CotationDateParsing');
        //         string dateString=dateCotation.substringBefore('T');
        //         list<string> listDateElements=dateString.split('-');
                
        //         if(listDateElements[2].length()>2){
        //             dateString=listDateElements[2]+'-'+listDateElements[1]+'-'+listDateElements[0];
        //         }
                
        //         acc.DateCotationPF__c = Date.valueOf(dateString.substringBefore('T'));
        //         System.debug('###acc.DateCotationPF__c : '+acc.DateCotationPF__c);
        //     }
        //     Update acc;
        // }
            
        //}
       
       /* else if(account.ParentId!=null){
            if(account.Parent.TECHIdentifiantNational__c!=null){
            	endpoint=WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).EndPoint__c+'/'+tinByLibelleMap.get(acc.Parent.TECHTypeIdentifiantNational__c).CodePays__c+'/'+tinByLibelleMap.get(acc.Parent.TECHTypeIdentifiantNational__c).Code__c+'/'+acc.Parent.TECHIdentifiantNational__c;
            }
        }*/
    }   
        
        
 public static String UpdateGrade(Account acc)
    {
        String Result;
        String policyId = '';
        String businessUnitCode;
        Map<String, String> companyInformation = new Map<String, String>();
        Map<String, TypeIdentifiantNational__c> allTinMap = TypeIdentifiantNational__c.getAll();
        Map<String, TypeIdentifiantNational__c> tinByLibelleMap = new Map<String, TypeIdentifiantNational__c>();
        for(TypeIdentifiantNational__c tin : allTinMap.values()) {
            tinByLibelleMap.put(string.valueof(tin.get('Libelle_'+UserLanguage+'__c')), tin);
        }

        if(acc.TypeIdentifiantNational__c != null && acc.IdentifiantNational__c != null) {
            if(acc.RecordTypeId == Label.ACC_RecordTypeId_CompteProspect && acc.CotationPF__c == null) {
                String companyIdForRequestedGrade = AllianzWebServiceRest.requestGrade(acc, System.Label.Business_Unit_Code, System.Label.PolicyId);
                if(companyIdForRequestedGrade != null && companyIdForRequestedGrade != '') {
                    acc.IDEulerHermes__c = companyIdForRequestedGrade;
                    acc.Statut_du_grade__c = 'Processing';
                    acc.Grade_Request_Date__c = Datetime.now();
                    update acc;
                    Result = 'Requested';
                } else {
                    Result = 'null';
                }
            }else {
                List<PolicyId_Legal_Entity__c> tempList = PolicyId_Legal_Entity__c.getAll().values();
                Map<String,String> PolicyIdByCountryMap = new Map<String, String>();
                Map<String,String> businessUnitCodeByCountryMap = new Map<String, String>();
                for(PolicyId_Legal_Entity__c ple : tempList) {
                    PolicyIdByCountryMap.put(ple.Pays__c, ple.policyId__c);
                    businessUnitCodeByCountryMap.put(ple.Pays__c, ple.Business_Unit_Code__c);
                }
                policyId = PolicyIdByCountryMap.get(acc.Pays__c).substringAfter('A');
                businessUnitCode = businessUnitCodeByCountryMap.get(acc.Pays__c);
                Account accValidated = AllianzWebServiceRest.validateCompany(acc);
                companyInformation = AllianzWebServiceRest.companyInformation(acc.BillingCountryCode, acc.TypeIdentifiantNational__c, acc.IdentifiantNational__c, businessUnitCode, policyId);
                if(companyInformation.containsKey('gradeCode') && (companyInformation.get('gradeCode') != null && companyInformation.get('gradeCode') != '')) {
                    String grade = companyInformation.get('gradeCode');
                    if(acc.CotationPF__c == integer.valueof(grade)){
                        Result = 'Same';
                    }else {
                        Result= 'Different';
                        ////Apply results
                    }
                    acc.CotationPF__c = Decimal.valueOf(grade);
                    acc.Tech_ListeEH__c = true;
                    acc.DateCotationPF__c = Date.valueOf(companyInformation.get('lastRefreshDate'));
                    acc.Statut__c = accValidated.Statut__c;
                    acc.IDEulerHermes__c = accValidated.IDEulerHermes__c;
                    update acc;
                } else {
                    Result = 'null';
                    
                }
            }
            
        }
        
        
        // Http http = new Http();
        // HttpRequest req = new HttpRequest();
        // String endpoint='';
        //  if(Test.isRunningTest()){
        //     WSParametreRequete__c wspr1 = new WSParametreRequete__c(Name='WS_Param_000',
        //                                                            EndPoint__c = 'https://api-test.petitforestier.fr/api/services/PFCustomersRepository/Account',
        //                                                            Methode__c = 'POST',
        //                                                            UserName__c = 'mdm_sfdc',
        //                                                            MotDePasse__c = '5:?MWWE6-tm9fcW4',
        //                                                            ContentType__c = 'application/xml',
        //                                                            ApplicationName__c = 'SFCD',
        //                                                            Authorization__c = 'Basic bWRtX3NmZGM6NTo/TVdXRTYtdG05ZmNXNA==');
        //     insert wspr1;
        //  }
        // else 
        // {
        //       if(account.TECHIdentifiantNational__c != null){
        //     endpoint=WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).EndPoint__c+'/'+tinByLibelleMap.get(acc.TECHTypeIdentifiantNational__c).CodePays__c+'/'+tinByLibelleMap.get(acc.TECHTypeIdentifiantNational__c).Code__c+'/'+acc.TECHIdentifiantNational__c;
        // 		}
        //     System.debug(endpoint);
        
        // req.setEndpoint(endpoint);
        // req.setMethod(WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).Methode__c);
        // req.setHeader('User', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).UserName__c);
        // req.setHeader('Password', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).MotDePasse__c);
        // req.setHeader('Content-Type', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS_GradeInformation).ContentType__c);
        // req.setHeader('Authorization', WSParametreRequete__c.getInstance(AP09Compte.PARAMETERS).Authorization__c);
        // HttpResponse resp = new HttpResponse();
        // resp = http.send(req);
        // System.debug('###ResponseCode '+resp.getStatus());
        // // Changing the account fields according to the response status
        // if(resp.getStatusCode() == 200){
        // 	String body=resp.getBody();
        //     System.debug('###response body :'+body);
        //     String grade = body.substringBetween('<Grade>', '</Grade>');
        //     system.debug('GRADE :'+grade);
        //     if(grade!=NULL && grade!='' && grade!='NA') {
        //              //Define the result 
        //         if(acc.CotationPF__c == integer.valueof(grade)){Result ='Same';}else{Result='Different';}
            
        //     ////Apply results
        //         acc.CotationPF__c = Decimal.valueOf(grade);
        //         gradeValue=Decimal.valueOf(grade);
        //         acc.Tech_ListeEH__c=true;
                
        //     }
        //     else
        //     {
        //         Result='null';
        //     }
        //     String dateCotation = body.substringBetween('<CotationDate>', '</CotationDate>');
        //     System.debug('DateCotation :'+dateCotation);
        //     if(dateCotation !=NULL && dateCotation!='') {
        //         System.debug('###CotationDateParsing');
        //         string dateString=dateCotation.substringBefore('T');
        //         list<string> listDateElements=dateString.split('-');
                
        //         if(listDateElements[2].length()>2){
        //             dateString=listDateElements[2]+'-'+listDateElements[1]+'-'+listDateElements[0];
        //         }
                
        //         acc.DateCotationPF__c = Date.valueOf(dateString.substringBefore('T'));
        //         System.debug('###acc.DateCotationPF__c : '+acc.DateCotationPF__c);
        //     }
        //     Update acc;
        // }
           
        //  }
        
   
       return Result;
        
        
        
  
    }
    /*public static schema.describefieldresult retrieveLibelleCodePays() {
        // Getting the Language set by the User
        String language = UserInfo.getLanguage();
        System.debug(' language : ' + language);
        String libelleName = 'Libelle_' +language+ '__c';
        Map <String, Schema.SObjectField> fieldMap = 
            Schema.getGlobalDescribe().get('CodesPays__c').getDescribe().fields.getMap();
       schema.describefieldresult dfield = null;
       for(Schema.SObjectField field : fieldMap.values()) {
            schema.describefieldresult dfieldtmp = field.getDescribe();
            if(dfieldtmp.Name == libelleName) {
                 dfield = dfieldtmp;
            }
       }
        return dfield;
    }*/

    

    //Wrapper to hold Old SFAC values
    public class wrapperOldSFAC {
        
        public date DateCotationPF{get;set;}
        public decimal CotationPF{get;set;}
        public date DateAgrementEH{get;set;}
        public decimal AgrementSFAC{get;set;}
        public boolean ListeNoire{get;set;}
        
        public wrapperOldSFAC (Account a) {
            this.DateCotationPF = a.DateCotationPF__c;
            this.CotationPF = a.CotationPF__c;
            this.DateAgrementEH = a.DateAgrementEH__c;
            this.AgrementSFAC = a.AgrementSFAC__c;
            this.ListeNoire = a.ListeNoire__c;
        }
    }
}