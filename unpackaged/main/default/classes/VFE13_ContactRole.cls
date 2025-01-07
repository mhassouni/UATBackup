public with sharing class VFE13_ContactRole {
    
    public RoleContact__c rc {get; set;}
    public list<Contact> c {get; set;}
    public string subtitle {get; set;}
    
    public VFE13_ContactRole(ApexPages.StandardController controller) {
        rc=(RoleContact__c)controller.getRecord();
        if(rc.Id!=null){
            rc=[select Name, Opportunite__c, CompteOpportunite__c, Contact__c, ServiceDepartement__c, InfluenceAchat__c, Role__c, Commentaires__c
                from RoleContact__c
                where Id=:rc.Id];
            subtitle=rc.Name;
        }
        else{
            rc.CompteOpportunite__c=[select AccountId from Opportunity where Id=:rc.Opportunite__c].AccountId;
            subtitle=Label.RDC_VFPSubtitle_NouveauRoleContact;
        }
    }
    
    public void selectContact(){
        c=[select ServiceDepartement__c, InfluenceAchat__c, Role__c
           from Contact
           where Id=:rc.Contact__c];
        if(c.size()>0){
            rc.ServiceDepartement__c=c[0].ServiceDepartement__c;
            rc.InfluenceAchat__c=c[0].InfluenceAchat__c;
            rc.Role__c=c[0].Role__c;
        }
    }
    
    public PageReference saveContact(){
        try{
            if(rc.Id==null){
                insert rc;
            }
            else{
                update rc;
            }
            PageReference p=new PageReference('/'+rc.Id);
            p.setRedirect(true);
            return p;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage().substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,').substringBeforeLast(':'));
            if(ApexPages.getMessages().size()==0)
            {    ApexPages.addmessage(myMsg);    }
        }
        return null;
    }
    
    public PageReference saveAndNewContact(){
        try{
            if(rc.Id==null){
                insert rc;
            }
            else{
                update rc;
            }
            
            PageReference p=new PageReference('/apex/VFP13_ContactRole?'+Label.RCN_OppId_Id+'='+rc.Opportunite__c+'&scontrolCaching=1&retURL=%2F'+rc.Opportunite__c+'&sfdc.override=1');
            p.setRedirect(true);
            return p;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage().substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,').substringBeforeLast(':'));
            if(ApexPages.getMessages().size()==0)
            {    ApexPages.addmessage(myMsg);    }
        }
        return null;
    }
    
}