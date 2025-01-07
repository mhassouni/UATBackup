public with sharing class EstimatedTravelTime implements Schedulable
{	    
    //Calculate estimated Travel Time Method using Google WebService 
	@future (callout=true)
	public Static Void getEstimatedTravelTime(String Origine, String Destination, String RecordId_1, String RecordId_2, String RecordId_3, String DriverPhone, String SMS_Sender, String SMS_Message, String SMSType) 
    {
		String Endpoint = 'https://maps.googleapis.com/maps/api/directions/json?origin='+Origine+'&destination='+Destination+'&key=AIzaSyANl_xzJcEYaItw6TNeqTJ-CRHeuYjLjp8';
        System.debug('Endpoint ' + Endpoint);
 		string EndpointFormatted = Endpoint.replace(' ','%20');
        System.debug('EndpointFormatted ' + EndpointFormatted);
        Http http = new Http();
        HttpRequest Req = new HttpRequest();
        Req.setEndpoint(EndpointFormatted);
        Req.setMethod('GET');
        HttpResponse Resp= new HttpResponse();
        Req.setTimeout(60000);
        Resp = http.send(Req);
        System.debug('Status Code : '+String.valueOf(Resp.getStatusCode()));
        Integer  EstimatedTravelTime_Sec;
        String ResponseBody = Resp.getBody();
        DirectionsService_JsonParser Duration = new DirectionsService_JsonParser();
        Duration = DirectionsService_JsonParser.parse(ResponseBody);  
        EstimatedTravelTime_Sec = Duration.routes[0].legs[0].duration.value;
        System.debug('Duration ( TEXT ) ' + Duration.routes[0].legs[0].duration.text);
        System.debug('Duration ( Minutes ) ' + Duration.routes[0].legs[0].duration.value);       
        System.debug(Resp.getStatus());
        List<ServiceResource> ServiceResourceRecord = new List<ServiceResource> ();
        ServiceResourceRecord = [SELECT Id, LastKnownLatitude, LastKnownLongitude, LastKnownLocation FROM ServiceResource where id =  :RecordId_2];
        if(ServiceResourceRecord.size() > 0 || !ServiceResourceRecord.isEmpty()) 
        {
        	if(EstimatedTravelTime_Sec < 700 && SMSType != 'Immediately')
            {
                CallR_SMSService.scheduleThis('Last Schedule', getUUID(), Origine, Destination, RecordId_1, RecordId_2, RecordId_3, DriverPhone, SMS_Sender, SMS_Message);
            }
                
            else if ( EstimatedTravelTime_Sec >= 1200 && EstimatedTravelTime_Sec <= 3600  && SMSType != 'Immediately')
            {
                String LastOrigine = ServiceResourceRecord[0].LastKnownLatitude + ',' + ServiceResourceRecord[0].LastKnownLongitude ;
                EstimatedTravelTime.scheduleThis(EstimatedTravelTime_Sec, RecordId_1, RecordId_2, RecordId_3, LastOrigine, Destination, '10min', getUUID(), 500, DriverPhone, SMS_Sender,  SMS_Message, '');
            }
    
            else if ( EstimatedTravelTime_Sec > 3600 && SMSType != 'Immediately')
            {
                String LastOrigine = ServiceResourceRecord[0].LastKnownLatitude + ',' + ServiceResourceRecord[0].LastKnownLongitude ;
                EstimatedTravelTime.scheduleThis(EstimatedTravelTime_Sec, RecordId_1, RecordId_2, RecordId_3, LastOrigine, Destination, '10min', getUUID(), EstimatedTravelTime_Sec - 1200, DriverPhone, SMS_Sender,  SMS_Message, '');
            }
                
            else if (SMSType == 'Immediately')
            {
                String LastOrigine = ServiceResourceRecord[0].LastKnownLatitude + ',' + ServiceResourceRecord[0].LastKnownLongitude ;
                EstimatedTravelTime.scheduleThis(EstimatedTravelTime_Sec, RecordId_1, RecordId_2, RecordId_3, LastOrigine, Destination, '10min', getUUID(), 40, DriverPhone, SMS_Sender,  SMS_Message, SMSType);
            }
            else
            {
                String LastOrigine = ServiceResourceRecord[0].LastKnownLatitude + ',' + ServiceResourceRecord[0].LastKnownLongitude ;
                EstimatedTravelTime.scheduleThis(EstimatedTravelTime_Sec, RecordId_1, RecordId_2, RecordId_3, LastOrigine, Destination, '10min', getUUID(), 240, DriverPhone, SMS_Sender,  SMS_Message, '');
            }
        }
    }
    
    //Execute the schedule Action of the class
	public void execute(SchedulableContext SC) 
    {
        String TriggerId;
        String TriggerId15;
        List<Google_Callr_Services_Params__c> GoogleCallrServicesParamRecord = new List<Google_Callr_Services_Params__c>();
        String Origine_Param;
        String Destination_Param;
        String RecordId_1;
        String RecordId_2;
        String RecordId_3;
        String Recipient_Phone;
        String SMS_Sender; 
        String SMS_Message;
        String CronTriggerId15;
		TriggerId = SC.getTriggerId();
        TriggerId15 = 'JobId_' + SC.getTriggerId().to15();
		GoogleCallrServicesParamRecord = [SELECT Id, Recipient_Phone__c, RecordId_1__c, RecordId_2__c, RecordId_3__c, MasterLabel__c, Origine_Param__c, Destination_Param__c, SMS_Message__c, SMS_Sender__c, EstimatedTravelTime_Sec__c, SMSType__c from Google_Callr_Services_Params__c where MasterLabel__c = :TriggerId15];
        Origine_Param = GoogleCallrServicesParamRecord[0].Origine_Param__c;
        Destination_Param =   GoogleCallrServicesParamRecord[0].Destination_Param__c;
        RecordId_1 =   GoogleCallrServicesParamRecord[0].RecordId_1__c;
        RecordId_2 =   GoogleCallrServicesParamRecord[0].RecordId_2__c;
        RecordId_3 =    GoogleCallrServicesParamRecord[0].RecordId_3__c;
        Recipient_Phone =     GoogleCallrServicesParamRecord[0].Recipient_Phone__c;
        SMS_Sender =   GoogleCallrServicesParamRecord[0].SMS_Sender__c; 
        SMS_Message =    GoogleCallrServicesParamRecord[0].SMS_Message__c;
		EstimatedTravelTime.getEstimatedTravelTime(Origine_Param, Destination_Param, RecordId_1, RecordId_2, RecordId_3, Recipient_Phone, SMS_Sender, SMS_Message, '') ;
        if ( GoogleCallrServicesParamRecord[0].SMSType__c == 'Immediately' )
        {
            Datetime EstimatedTravelTimeDateTime_01 = Datetime.now().addSeconds(GoogleCallrServicesParamRecord[0].EstimatedTravelTime_Sec__c.intValue());  
            Datetime EstimatedTravelTimeDateTime_02 = Datetime.now().addSeconds(GoogleCallrServicesParamRecord[0].EstimatedTravelTime_Sec__c.intValue() + 600);  
            String EstimatedTravelTimeFormatted_01 = EstimatedTravelTimeDateTime_01.format('HH:mm');
            String EstimatedTravelTimeFormatted_02 = EstimatedTravelTimeDateTime_02.format('HH:mm');
            String SMS_Message_Immediately = 'Notre technicien est en route pour vous dépanner. Son heure estimée d\'arrivée est entre ' +  EstimatedTravelTimeFormatted_01 + ' et ' + EstimatedTravelTimeFormatted_02 + '. Nous vous préviendrons lorsqu’il sera à 10 minutes du ' +  GoogleCallrServicesParamRecord[0].Destination_Param__c + '.';
            CallR_SMSService.sendSMS(GoogleCallrServicesParamRecord[0].Recipient_Phone__c, GoogleCallrServicesParamRecord[0].SMS_Sender__c, SMS_Message_Immediately, GoogleCallrServicesParamRecord[0].RecordId_3__c) ;
        }
    }
    
    //Used to invoke the schedule job
	public Static void scheduleThis (Integer EstimatedTravelTime_Sec, String RecordId_1, String RecordId_2, String RecordId_3, String Origine, String Destination, String argPass, String name, Integer SecondsToAdd, String DriverPhone, String SMS_Sender, String SMS_Message, String SMSType)
    {
		List<Google_Callr_Services_Params__c> MetadataList = new List<Google_Callr_Services_Params__c>();
        String cronExp;
        String CreationDate;
        if ( '10min'.equals( argPass ) ) 
        {
            Datetime dt = Datetime.now().addSeconds(SecondsToAdd);  
			cronExp = dt.format('s m H d M \'?\' yyyy');
        } 
        System.assertNotEquals(null, cronExp, 'Please pass "10min" argument to this method.');
        String ScheduledJobID  = System.schedule(getUUID(), cronExp, new EstimatedTravelTime());
        CreationDate = Datetime.now().formatGMT('yyyy-MM-dd\' \'HH:mm:ss');
        Google_Callr_Services_Params__c Google_Callr_Services_Param_Record = new Google_Callr_Services_Params__c(Creation_Date__c = CreationDate, RecordId_1__c= RecordId_1, RecordId_2__c = RecordId_2, RecordId_3__c = RecordId_3, MasterLabel__c='JobId_'+ ScheduledJobID, Job_Id__c= ScheduledJobID, Origine_Param__c = Origine, Destination_Param__c = Destination, Recipient_Phone__c = DriverPhone, SMS_Message__c = SMS_Message, SMS_Sender__c = SMS_Sender, SMSType__c =  SMSType, EstimatedTravelTime_Sec__c = EstimatedTravelTime_Sec);
        insert Google_Callr_Services_Param_Record;
    }
    
    //Flow Method
    @InvocableMethod(label='Get Estimated Travel Time in Minutes' description='Returns Estimated Travel Time in Minutes' category='WorkOrder')
    public static Void getEstimatedTravelTime (List<FlowParams> FlowParams) 
    {
		getEstimatedTravelTime(FlowParams[0].Origine, FlowParams[0].Destination, FlowParams[0].RecordId_1, FlowParams[0].RecordId_2, FlowParams[0].RecordId_3, FlowParams[0].DriverPhone, FlowParams[0].SMS_Sender, FlowParams[0].SMS_Message, FlowParams[0].SMSType);   
    }
    
    //Flow Variables 
    public class FlowParams 
    {
        @InvocableVariable(label='Origine' description='Origine' required=true)
        public String Origine;
        @InvocableVariable(label='Destination' description='Destination' required=true)
        public String Destination;
        @InvocableVariable(label='Record Id 1' description='Record Id 1' required=true)
        public String RecordId_1;
        @InvocableVariable(label='Record Id 2' description='Record Id 2' required=false)
        public String RecordId_2;
        @InvocableVariable(label='Record Id 3' description='Record Id 3' required=false)
        public String RecordId_3;
        @InvocableVariable(label='N° Tel - Chauffeur' description='N° Tel - Chauffeur' required=true)
        public String DriverPhone;
        @InvocableVariable(label='N° Tel - Expéditeur' description='N° Tel - Expéditeur' required=true)
        public String SMS_Sender;
        @InvocableVariable(label='Message du SMS' description='Message du SMS' required=true)
        public String SMS_Message;
        @InvocableVariable(label='Type du SMS' description='Type du SMS' required=false)
        public String SMSType;
    } 
    
    //Generate Unique Names. used on Schedule jobs Method
	public static String getUUID()
	{
		Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '_' + h.SubString(8,12) + '_' + h.SubString(12,16) + '_' + h.SubString(16,20) + '_' + h.substring(20);
        return guid;
    }
}