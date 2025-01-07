public class QuoteClass {
 
    //Générer les lignes de tarifications en fonctions des champs Duree_de_location__c 
    public static void generateTarifications(String Devis_ID,string CurrencyIsoCode)
    {
        //Quote
        Quote Q = [SELECT Duree_de_location__c,Kilom_trage__c  FROM Quote where Id=:Devis_ID];
         string[] LesDurees = Q.Duree_de_location__c.split(';');
        
     for(String D : LesDurees)
        {            
            Tarification__c T = new Tarification__c();
            T.Duree__c =integer.valueof(D);
            T.Kilometrage__c = Q.Kilom_trage__c;
            T.Devis__c = Devis_ID;
            T.CurrencyIsoCode= CurrencyIsoCode;
            Insert T;   
        }   
    }
    //En cas d'update,supprimer les anciennes lignes de tarifications.
    public static void deleteTarifications(String DEVIS_ID)
    {
         List<Tarification__c> OldTarifications = new List<Tarification__c>(); 
        OldTarifications = [SELECT id from Tarification__c where devis__c =:DEVIS_ID];
        Delete OldTarifications;
        
    }
    
    //En cas de synchronisation du devis,désynchroniser les autres devis associés à la même opportunité
    public static void Synchronisation(String DEVIS_ID)
    {
        List<Quote> QuoteToDesync = new List<Quote>();
        Quote Q = [SELECT synchronise__c,OpportunityId from quote where id=:DEVIS_ID];
        
        for(Quote Qt : [SELECT Id,synchronise__c from Quote where synchronise__c=true AND OpportunityId =:Q.OpportunityId])
          {
               if(Q.Id<>Qt.Id)
                {
                Qt.Synchronise__c=false;
                QuoteToDesync.add(Qt); 
                }
          }
        IF(QuoteToDesync.size()!=0){update QuoteToDesync;}
    }
    
    //Modifier les tarifications suite à la modification du KM sur devis
    public static void updateTarifications(String DEVIS_ID,decimal KM)
    {
        List<Tarification__c> Tarifications = [SELECT id,Kilometrage__c from Tarification__c where devis__c=:DEVIS_ID];
        
        for(Tarification__c T : Tarifications)
        {
            T.Kilometrage__c = KM;
        }
        if(Tarifications.size()>0){update Tarifications;}
    }
}