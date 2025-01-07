trigger Lead_Besoin on Lead (Before insert, Before Update) {
for(Lead led : trigger.new )
	{ 
        if (led.Attente_Client__c == 'Demande de devis' && led.RecordTypeId == '0123X0000015wnMQAQ' && led.Besoin__c != null)
            { 
        led.Besoin__c = led.Besoin__c.replaceAll(',','<br>');
            } else         {
                system.debug('Do Nothing');
            }  
  }      
}