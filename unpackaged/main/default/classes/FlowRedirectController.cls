public with sharing class FlowRedirectController {

    public PageReference FlowRedirectController() 
		{ 
            //Get Page Variables - OBJ Separates two params
            String unique_id_brut = ApexPages.currentPage().getParameters().get('unique_id');
            String unique_id = unique_id_brut.substringBeforeLast('OBJ');
            String obj = unique_id_brut.substringAfterLast('OBJ');
            
            String RecordId='';
            system.debug('Unique_ID: '+unique_id);
            system.debug('obj: '+obj);
          
            if(unique_id == null){
			// Return Home if no ID 
			String url = '/home/home.jsp'; 
			return new PageReference(url); 
            } 
   			// Get Record ID and set Redirect 
   			
   			if(obj=='WorkOrder')
            {
             	RecordId = [SELECT Unique_Flow_Identifier__c, Id FROM WorkOrder WHERE Unique_Flow_Identifier__c =:unique_id ORDER BY CreatedDate DESC LIMIT 1].id;
				system.debug('WorkOrder Created: '+RecordId); 
            }
            else if(obj=='WorkOrderLineItem')
            {
            	RecordId = [SELECT Unique_Flow_Identifier__c, Id FROM WorkOrderLineItem WHERE Unique_Flow_Identifier__c =:unique_id ORDER BY CreatedDate DESC LIMIT 1].id;
 				system.debug('WorkOrderLineItem Created: '+RecordId); 

            }
            else if (obj=='Case')
            {
                RecordId = [SELECT Unique_Flow_Identifier__c, Id FROM Case WHERE Unique_Flow_Identifier__c =:unique_id ORDER BY CreatedDate DESC LIMIT 1].id;
            }
			else if(obj=='Quote')
            {
                RecordId = [SELECT Unique_Flow_Identifier__c, Id FROM Quote WHERE Unique_Flow_Identifier__c =:unique_id ORDER BY CreatedDate DESC LIMIT 1].id;
            }
			system.debug('RecordId Final:'+RecordId);
     
           
		// Did we find a Contact? 
		if (RecordId == null) {
		// Return Home if no ID 
			String url = '/home/home.jsp'; 
            return new PageReference(url); }
		// Redirect to Contact 
			String url = '/' + RecordId; 
            return new PageReference(url); }
}