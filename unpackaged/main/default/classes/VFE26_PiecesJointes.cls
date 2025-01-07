public with sharing class VFE26_PiecesJointes {

    public list<string> OldAccessUsers{get;set;}
    public Piece_Jointe__c PieceJointe{get;set;}
    public List<WrapperClassEx> WrapperList{get; set;}
    public List<Attachment> Attachments{get; set;}
    
    public VFE26_PiecesJointes(ApexPages.StandardController controller) {
    
        OldAccessUsers = new list<string>();
        
        PieceJointe = [ SELECT Id, Name, TECH_AccesUtilisateurs__c, OwnerId, Compte__r.Name,
                               Opportunite__r.Name, Opportunite__r.Account.Name, 
                               Compte__r.TECHLienSF__c, Opportunite__r.TECHLienSF__c
                        FROM Piece_Jointe__c 
                        WHERE Id = :apexpages.currentpage().getparameters().get('Id')];
                        
        Attachments = [SELECT Name, Body FROM Attachment WHERE ParentId =: PieceJointe.Id];
                        
        OldAccessUsers.add(PieceJointe.OwnerId);
        if(PieceJointe.TECH_AccesUtilisateurs__c!=NULL && PieceJointe.TECH_AccesUtilisateurs__c!='')
        {
            OldAccessUsers.addAll(PieceJointe.TECH_AccesUtilisateurs__c.split('-'));
        }
        WrapperList = GetWrapperUsers();
    }
    
    public pagereference Redirect(){
        
        if(WrapperList.size()==0)
        {
            PageReference pageRef = new PageReference('/' + PieceJointe.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }
        else
        {
            return null;
        }
        
    }
        
    public pagereference Partage(){
    
        list<Piece_Jointe__Share> SelectedUsers = new list<Piece_Jointe__Share>();
        
        if(PieceJointe.TECH_AccesUtilisateurs__c==NULL)
        {
            PieceJointe.TECH_AccesUtilisateurs__c='';
        }
                
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        list<Messaging.EmailFileAttachment> EmailAttachments = new list<Messaging.EmailFileAttachment>();
        
        for(Attachment a : Attachments)
        {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            EmailAttachments.add(efa);
        }
        
        for(WrapperClassEx wc : WrapperList)
        {
            if(wc.CheckBoxEmail == true)
            {
                SelectedUsers.add(wc.User);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {wc.User.UserOrGroupId};
                
                if(PieceJointe.Opportunite__c==NULL)
                {
                    message.subject = Label.VFP_PJAccountEmailSubject + ' ' + PieceJointe.Compte__r.Name;
                    message.plainTextBody = Label.VFP_PJEmailBody + '\n' + Label.VFP_AssociatedAccount + ': ' + PieceJointe.Compte__r.TECHLienSF__c;
                }
                else
                {
                    message.subject = Label.VFP_PJOpportunityEmailSubject + ' ' + PieceJointe.Opportunite__r.Name + ' (' + Label.VFP_Account + ': ' + PieceJointe.Opportunite__r.Account.Name + ')';
                    message.plainTextBody = Label.VFP_PJEmailBody + '\n' + Label.VFP_AssociatedOpportunity + ': ' + PieceJointe.Opportunite__r.TECHLienSF__c;
                }
                
                message.setFileAttachments(EmailAttachments);
                messages.add(message);
            }
            PieceJointe.TECH_AccesUtilisateurs__c += wc.User.UserOrGroupId + '-';
        }
        
        update PieceJointe;
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if(SelectedUsers.size()>0)
        {
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } 
            else 
            {
                System.debug('The email failed to send: '+ results[0].errors[0].message);
            }
        }
            
        PageReference pageRef = new PageReference('/' + PieceJointe.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    Public List<WrapperClassEx> GetWrapperUsers(){
    
        List<WrapperClassEx> WrapperList = New List<WrapperClassEx>();
        
        list<Piece_Jointe__Share> PJShareList = [  SELECT UserOrGroupId, UserOrGroup.Name, UserOrGroup.Email 
                                                    FROM Piece_Jointe__Share 
                                                    WHERE ParentId = :apexpages.currentpage().getparameters().get('Id') 
                                                        AND UserOrGroup.Type = 'User'
                                                        AND UserOrGroupID NOT in: OldAccessUsers];
                                                        
        for(Piece_Jointe__Share ctct : PJShareList)
        {
            WrapperList.add(New WrapperClassEx(true,ctct)); 
        }
        return WrapperList;
    }
    
    Public Class WrapperClassEx{
    
        public Piece_Jointe__Share User{get;set;}
        public Boolean CheckBoxEmail{get;set;}
        
        public WrapperClassEx(boolean selectboxEmail, Piece_Jointe__Share contactRecord)
        {   
           User = contactRecord;
           CheckBoxEmail = selectboxEmail;
        }
    }

}