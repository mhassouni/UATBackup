trigger QuoteAfterUpdate on Quote (After Update) 
{
    List<Tarification__c> LesTarifications =new List<Tarification__c>();
    List<Quote> QuoteToDesync = new List<Quote>();
    List<Quote> ToUpdate = new List<Quote>();
    
    for(Quote Q : trigger.new)
    {
  
     if((Q.RecordTypeId== Label.Quote_RecordTypeId_HorsStandard ||Q.RecordTypeId==Label.Quote_RecordTypeId_HorsStandardLectureSeule|| Q.RecordTypeId == Label.Quote_RecordTypeId_Parc || Q.RecordTypeId == Label.Quote_RecordTypeId_Parc_LectureSeule))
     {
        if(Q.Duree_de_location__c<> NULL && Q.Kilom_trage__c<>NULL && 
            (Trigger.oldmap.get(Q.id).Duree_de_location__c!=Q.Duree_de_location__c && Trigger.oldmap.get(Q.id).Kilom_trage__c != Q.Kilom_trage__c )) 
        {
            //Delete Old Tarifications;
            QuoteClass.deleteTarifications(Q.id);
            //Generate new Tarifications
            QuoteClass.generateTarifications(Q.Id,Q.CurrencyIsoCode);   
        }
         else if (Q.Duree_de_location__c<> NULL && Q.Kilom_trage__c<>NULL && 
                  (Trigger.oldmap.get(Q.id).Duree_de_location__c==Q.Duree_de_location__c && Trigger.oldmap.get(Q.id).Kilom_trage__c != Q.Kilom_trage__c ) )
         {
             QuoteClass.updateTarifications(Q.id,Q.Kilom_trage__c);
             
         }

     }
     
      //Synchroniser la quote
      if(Q.Synchronise__c==true && Q.Synchronise__c <> Trigger.oldmap.get(Q.id).Synchronise__c)
      {
          QuoteClass.Synchronisation(Q.Id);  
      }
    }
 
}