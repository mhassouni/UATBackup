/*
* Les champs Pays / Région PF et Agence PF d'une opportunité doivent être préremplis par les valeurs du compte, mais restent modifiables.
* @Author Natasha Maalouf
* @TestClass VFE12_OpportunityPrefill_TEST
* @CodeCoverage 100%
*/

public class VFE12_OpportunityPrefill{

    public string RecordType {get;set;}
    public boolean isOppEnfant=FALSE;
    public string theme{get;set;}
    public Opportunity a{get;set;}
    public list<RecordType> RecordTypes{get;set;}
    public boolean isBrowser{
        get
        {
            if(theme == 'Theme4t')
            {
                return false;
            }
            return true;
        }
        set;
   }
    public VFE12_OpportunityPrefill(ApexPages.StandardSetController controller) {
       theme = UserInfo.getUiTheme();
       a = new Opportunity();
   }

    
    public VFE12_OpportunityPrefill(ApexPages.StandardController controller) {
        theme = UserInfo.getUiTheme();
        a = new Opportunity();
        //Recordtype = a.RecordTypeId;
        RecordTypes = [SELECT Name, Description 
                        FROM RecordType 
                        WHERE sObjectType = 'Opportunity'
                        AND (Id = :label.OPP_RecordTypeId_OppMonoProduit15 or Id = :label.OPP_RecordTypeId_OppMultiProduits15)
                        ORDER BY Name];
    }

    public PageReference prefillOpportunity(){
        PageReference p;

        Id accId=ApexPages.currentPage().getParameters().get('accId');
        Id parentOppId=ApexPages.currentPage().getParameters().get('parentOppId');
        string pageRefURL='/'+Label.OPP_CreateNew_Id+'/e?retURL=%2F'+Label.OPP_CreateNew_Id+'%2Fo'+'&nooverride=1';
        Recordtype = a.RecordTypeId;
        boolean Mono = FALSE;
        if(Recordtype!=null)
        {
            Mono = Recordtype.substring(0,15) == Label.OPP_RecordTypeId_OppMonoProduit15;
        }
        
        //Si on crée l'opportunité à partir de la liste associée sur un compte
        if(!isOppEnfant){
            
            pageRefURL=pageRefURL+'&RecordType='+Recordtype ;
            if(accId!=NULL){
                pageRefURL=pageRefURL+'&accid='+accId;
                Account acc=[select PaysRegionPF__c, AgencePF__c
                             from account
                             where id=:accId];
                //Si le compte a une valeur de Pays / Région
                if(acc.PaysRegionPF__c!='' && acc.PaysRegionPF__c!=NULL){
                    pageRefURL=pageRefURL+'&'+Label.OPP_PaysRegionPF_Id+'='+acc.PaysRegionPF__c;
                    //Si le compte a une valeur d'Agence PF (en plus de la valeur Pays / Région)
                    if(acc.AgencePF__c!='' && acc.AgencePF__c!=NULL){
                        pageRefURL=pageRefURL+'&'+Label.OPP_AgencePF_Id+'='+acc.AgencePF__c;
                    }
                }
            }
        }
        
        //Si on crée l'opportunité à partir de la liste associée d'une opportunité multi-produits
        else{
            pageRefURL=pageRefURL+'&RecordType='+Label.OPP_RecordTypeId_OppMonoProduit15;
            Mono = true;
            if(parentOppId!=NULL){
                pageRefURL=pageRefURL+'&CF'+Label.OPP_FieldID_OpportuniteParent+'_lkid='+parentOppId;
                Opportunity parentOpp=[select Name, AccountId, PaysRegionPF__c, AgencePF__c
                                       from Opportunity
                                       where id=:parentOppId];
                pageRefURL=pageRefURL+'&CF'+Label.OPP_FieldID_OpportuniteParent+'='+parentOpp.Name;
                if(parentOpp.AccountId!=NULL){
                    pageRefURL=pageRefURL+'&accid='+parentOpp.AccountId;
                }
                //Si l'opportunité mère a une valeur de Pays / Région
                if(parentOpp.PaysRegionPF__c!='' && parentOpp.PaysRegionPF__c!=NULL){
                    pageRefURL=pageRefURL+'&'+Label.OPP_PaysRegionPF_Id+'='+parentOpp.PaysRegionPF__c;
                    //Si l'opportunité mère a une valeur d'Agence PF (en plus de la valeur Pays / Région)
                    if(parentOpp.AgencePF__c!='' && parentOpp.AgencePF__c!=NULL){
                        pageRefURL=pageRefURL+'&'+Label.OPP_AgencePF_Id+'='+parentOpp.AgencePF__c;
                    }
                }
            }
        }
                
        //Préremplir le nom d'une opportunité mono-produit par "Nouvelle Opportunité XX..X"
        if(Mono)
        {
            string NewOppName = Label.OPP_Name_NewOpp + '%';
            list<Opportunity> NouvellesOpps = [ SELECT Name
                                                FROM Opportunity
                                                WHERE Name like :NewOppName];
            list<integer> Numbers = new list<integer>();
            for(Opportunity o : NouvellesOpps)
            {
                string digits = o.Name.substring(o.Name.lastindexof(' ')+1);
                if(digits.isNumeric())
                {
                    Numbers.add((integer.valueof(digits)));
                }
            }
            Numbers.sort();
            if(Numbers.size()>0)
            {   pageRefURL += '&opp3=' + Label.OPP_Name_NewOpp + ' ' + (Numbers[Numbers.size()-1]+1); }
            else
            {   pageRefURL += '&opp3=' + Label.OPP_Name_NewOpp + ' 1'; }
        }
        
        //pageRefURL=pageRefURL+'&save_new=1';
        p=new PageReference(pageRefURL);
        p.setRedirect(true);
        return p;
    }
    
    public PageReference prefillChildOpportunity(){       
        isOppEnfant=TRUE;
        PageReference p1=prefillOpportunity();
        return p1;
        }
}