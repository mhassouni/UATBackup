trigger ContactBeforeUpdate on Contact (Before update) {
System.debug('##Contact Before Update##');
    List<contact> listContact = new List<Contact>();
    if(Bypass.canTrigger('AP02Contact'))
    {
         for(Contact contact: trigger.new)
         {
             if(!(contact.FirstName!=NULL?contact.FirstName:'').equals((trigger.oldMap.get(contact.Id)).FirstName!=NULL?(trigger.oldMap.get(contact.Id)).FirstName:''))
             {
                 listContact.add(contact);
             }
         }    
         if(listContact.size()>0)
         {
              AP02Contact.MAJPrenomMajuscules(listContact);         
         }
    }
}