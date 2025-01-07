trigger QuoteAfterInsert on Quote (After insert) {
    
    List<Tarification__c> LesTarifications =new List<Tarification__c>();
    List<Quote> ToUpdate = new list<Quote>();
   
   for(Quote Q : trigger.new)
    {
        //Si Nombre KM et Durées de location sont renseignées => Générer les lignes de tarifications
        if((Q.RecordTypeId== Label.Quote_RecordTypeId_HorsStandard || Q.RecordTypeId == Label.Quote_RecordTypeId_Parc)
           && Q.Duree_de_location__c<> NULL && Q.Kilom_trage__c<>NULL)
        {
                    QuoteClass.generateTarifications(Q.Id,Q.CurrencyIsoCode);
        }
        
    }
        
}