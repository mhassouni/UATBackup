/**
 * Created by ruthy on 2019-11-28.
 */

public with sharing class BDCController {
    public String workOrderId {get;set;}
    public WorkOrder currWorkOrderItem {get;set;}
    public static String PARAMETERS {get;set;}

    /**
     * BDC controller. Send BDC informations to BDC
     *
     *
     * @param controller
     */
    public BDCController(ApexPages.StandardController controller){

    }

    public PageReference process(){

        BDCController.PARAMETERS = 'WS_Param_005';

        workOrderId=ApexPages.currentPage().getParameters().get('id');
        currWorkOrderItem=[SELECT
                WorkOrder.WorkOrderNumber,
                WorkOrder.Referenced_supplier__r.Id,
                WorkOrder.Referenced_supplier__r.Name,
                WorkOrder.New_Supplier__c,
                WorkOrder.AccountId,
                WorkOrder.Account.Name,
                WorkOrder.Account.N_igloo__c,
                WorkOrder.N_Parc__c,
                WorkOrder.Asset.IMMAT__c,
                WorkOrder.Agence_Intervenante__r.Name,
                WorkOrder.Agence_Intervenante__r.Code__c,
                WorkOrder.OwnerId,
                WorkOrder.Purchase_order_link__c,
                WorkOrder.Client_purchase_order_number__c
        from WorkOrder where Id=:WorkOrderId];

        if(currWorkOrderItem.Client_purchase_order_number__c != null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'PO already exists. You cannot create a new purchase order'));
            return null;
        }

        String body = buildJson(currWorkOrderItem);

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(WSParametreRequete__c.getInstance(BDCController.PARAMETERS).EndPoint__c);
        req.setMethod(WSParametreRequete__c.getInstance(BDCController.PARAMETERS).Methode__c);
        req.setHeader('User', WSParametreRequete__c.getInstance(BDCController.PARAMETERS).UserName__c);
        req.setHeader('Password', WSParametreRequete__c.getInstance(BDCController.PARAMETERS).MotDePasse__c);
        req.setHeader('Content-Type', WSParametreRequete__c.getInstance(BDCController.PARAMETERS).ContentType__c);
        req.setHeader('Authorization', WSParametreRequete__c.getInstance(BDCController.PARAMETERS).Authorization__c);
        req.setBody(body);

        HttpResponse resp= new HttpResponse();
        req.setTimeout(60000);
        resp = http.send(req);
        System.debug('JSON: ' + body);
        System.debug('STATUS CODE : ' + resp.getStatusCode());
        if(resp.getStatusCode()==200){
            System.debug(resp.getBody());
            JSONParser parser = JSON.createParser(resp.getBody());
            String numBC = '';
            String IdBC = '';
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                        (parser.getText() == 'NumBC')) {
                    parser.nextToken();
                    numBC = parser.getText() ;

                }else if((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                        (parser.getText() == 'IdBC')){
                    parser.nextToken();
                    IdBC = parser.getText() ;
                }
            }

            currWorkOrderItem.Purchase_order_link__c = buildBdcUrlSF(IdBC);
            currWorkOrderItem.Client_purchase_order_number__c = numBC;
            currWorkOrderItem.Purchase_order_Status__c = 'Created';
            currWorkOrderItem.Idbc__c = IdBC;
            
            
            Database.update(currWorkOrderItem);
            return redirect(IdBC);



        }if(resp.getStatusCode()==404){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Supplier' +
                    currWorkOrderItem.Referenced_supplier__r.Name + 'does not exists'));
            return null;
        }else{
            System.debug(resp.getStatus());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred... Status code : ' + resp.getStatus()));
            return null;
        }


    }

    public PageReference redirect(String bdcId){
            PageReference pageRef = new PageReference(buildBdcUrl(bdcId));
            pageRef.setRedirect(true);
            return pageRef;
    }

    private String buildBdcUrl(String bdcId){
        return 'http://bdc/Modules/AjoutLignesCommande.aspx?From=SF&Mode=EDIT&NumCommande=' + bdcId;
    }
	private String buildBdcUrlSF(String bdcId){
       // return 'http://bdc-test/Modules/AjoutLignesCommande.aspx?Mode=EDIT&NumCommande=' + bdcId;
        return ' http://bdc/Modules/BonDeCommande.aspx?NumCommande='+bdcId+'&statut=1';
    }
    private String buildJson(WorkOrder currWorkOrderItem){
        String json = '{ "datas" : [{';
        json += '"WOId" : "' + workOrderId + '",';
        json += '"WONumber" : "' + currWorkOrderItem.WorkOrderNumber + '",';
        json += '"NumParc" : "' + replaceNullValues(currWorkOrderItem.N_Parc__c) + '",';
        json += '"NumAgence" : "' + replaceNullValues(currWorkOrderItem.Agence_Intervenante__r.Code__c) + '",';
        json += '"NomAgence" : "' + replaceNullValues(currWorkOrderItem.Agence_Intervenante__r.Name) + '",';
		json += '"IdClientIgloo" : "' + replaceNullValues(currWorkOrderItem.Account.N_igloo__c) + '",';
		json += '"NomClientIgloo" : "' + replaceNullValues(currWorkOrderItem.Account.Name) + '",';
        json += '"Immat" : "' + replaceNullValues(currWorkOrderItem.Asset.IMMAT__c) + '",';
        
        
        if(currWorkOrderItem.Referenced_supplier__r.Id != null){
            json += '"FourId" : "' + replaceNullValues(currWorkOrderItem.Referenced_supplier__r.Id) + '",';
            json += '"FourNom" : "' + replaceNullValues(currWorkOrderItem.Referenced_supplier__r.Name) + '",';
        }else if(currWorkOrderItem.New_Supplier__c != null){
            json += '"FourNom" : "' + currWorkOrderItem.New_Supplier__c + '",';
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill a supplier...'));
        }

        json += '"DemandeurNom" : "' + replaceNullValues(UserInfo.getName()) + '"}]}';
   



        return json;
    }

    private String replaceNullValues(string value)
    {
        if(value==null|| value.equalsIgnoreCase('null'))
            value='';
        return value;
    }

    private String replaceNullDateValues(Datetime currDate,string format)
    {
        if(currDate==null)
            return '';
        else
                return currDate.format(format);
    }
}