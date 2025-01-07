angular.module('wizardApp', ['toaster', 'ngResource'])
.config(['$sceDelegateProvider', '$compileProvider', function ($sceDelegateProvider, $compileProvider) {
    var a = $('<a>', { href: application_js })[0];
    var url = a.protocol + '//' + a.hostname + '/**';
    //var url1 = 'https://olbico.eu11.visual.force.com';
    console.log('url::' + url);

    $sceDelegateProvider.resourceUrlWhitelist([
        // Allow same origin resource loads.
        'self',
        // Allow loading from outer templates domain.
        url
    ]);
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|data|chrome-extension):/);

}])

.controller("WizardController", ["$scope", "$rootScope", "toaster", "$timeout", "$window", "$loader", function ($scope, $rootScope, toaster, $timeout, $window, $loader) {
    $scope.currentStep = 1;
    $scope.objCredit = { 'Username': '', 'Password': '', 'IsCheckCredit': '', 'Duns': '' };
    $scope.objDuplicate = { 'Username': '', 'Password': '', 'IsContact': '', 'IsAccount': '', 'ContactUsername': '', 'ContactPassword': '', 'IsAccountKvk': '', 'AccountKvkUsername': '', 'AccountKvkPassword': '', 'IsLeadKvk': '', 'LeadKvkUsername': '', 'LeadKvkPassword': '' };
    $scope.objVat = { 'IsCheckVat': '', 'Vat': '' };
    $scope.objLeadGlobal = { 'Accesstoken_URL': '', 'Consumer_Key': '', 'Consumer_Secret': '',  'Endpoint_URL': ''};
    $scope.objAccountGlobal = { 'Accesstoken_URL': '', 'Consumer_Key': '', 'Consumer_Secret': '',  'Endpoint_URL': ''};
    $scope.objAccountTradeCredit = { 'Accesstoken_URL': '', 'Consumer_Key': '', 'Consumer_Secret': '',  'Endpoint_URL': '', 'IsAccountTradeCreditTrigger':false};
    //start Global Decision Maker Service 
    $scope.objGDMService = {'UserId':'','Password':'','Duns':'','GDMServiceStatus':'','GDMServiceDate':''};
    //end Global Decision Maker Service 

    //toolkit management
    $scope.objToolkitEnterprise = { 'Username': '', 'Password': '', 'IsActiveToolkit': '', 'Duns': '', 'ToolkitStatus': '', 'ToolkitDate': '' };
    $scope.objToolkitQuickCheck = { 'Username': '', 'Password': '', 'IsActiveToolkit': '', 'Duns': '', 'ToolkitStatus': '', 'ToolkitDate': '' };
    $scope.toolkitFilterlogic = { 'Name': '' };
    $scope.toolkitQCFilterlogic = { 'Name': '' };

    $scope.lstOperator = [{ 'Name': '--None--' }, { 'Name': 'equal' }, { 'Name': 'not equal to' }, { 'Name': 'less than' }, { 'Name': 'greater than' }, { 'Name': 'less or equal' }, { 'Name': 'greater or equal' }, { 'Name': 'changed' }, { 'Name': 'contains'}, { 'Name': 'does not contain'}, { 'Name': 'begins'}, { 'Name': 'regex'}];

    $scope.accCriteriaArray = [];
    $scope.conCriteriaArray = [];
    $scope.creditCriteriaArray = [];
    $scope.vatCriteriaArray = [];
    $scope.accFilterlogic = { 'Name': '' };
    $scope.conFilterlogic = { 'Name': '' };
    $scope.vatFilterlogic = { 'Name': '' };
    $scope.creditFilterlogic = { 'Name': '' };
    $scope.accountKvkFilterlogic = { 'Name': '' };
    $scope.leadKvkFilterlogic = { 'Name': '' };
    $scope.leadGlobalFilterlogic = { 'Name': '' };
    $scope.accountGDMFilterlogic = { 'Name': '' };
    $scope.accountGlobalFilterlogic = { 'Name': '' };
    $scope.accountTradeCreditFilterlogic = { 'Name': '' };
    $scope.objDUNSValue = {'name':'','value':'dunsNumber'};

    $scope.serviceList = [];

    //for input field
    $scope.recordAccount = [];
    $scope.recordAccountTemp = [];
    $scope.recordContact = [];
    $scope.recordContactTemp = [];

    //for output field
    $scope.output_Account = [];
    $scope.output_AccountTemp = [];
    $scope.output_Contact = [];
    $scope.output_ContactTemp = [];

    $scope.leadFields = [];
    $scope.outputLeadFields = [];
    $scope.accountFields = [];
    $scope.contactFields = [];
    $scope.accOutPutFields = [];
    $scope.conOutPutFields = [];
    $scope.leadMapFields = [];
    $scope.leadMapConFields = [];

    $scope.leadMapFieldsFlag = false;
    $scope.leadFieldsFlag = false;
    $scope.leadMapConFieldsFlag = false;

    //output field
    $scope.leadMapOutFields = [];
    $scope.leadMapConOutFields = [];
    $scope.leadMapFieldsOutFlag = false;
    $scope.leadMapConOutFieldsFlag = false;

    //$scope.mapDuns = {};
    $scope.duplicateCheckAccount = false;
    $scope.duplicateCheckContact = false;
    $scope.vatCheck = true;
    //$scope.gdmCheck = false;
    $scope.creditCheck = false;
    $scope.toolkitErpManagement = false;
    $scope.toolkitQuickCheck = false;
    //start Global Decision Maker Service 
    $scope.gdmServiceAccount - false;
    //end Global Decision Maker Service 

    //IWS Service
    $scope.objIwsService = { 'Username': '', 'Password': '', 'Siren': '','IwsServiceStatus': '', 'IwsServiceDate': '','IsActiveIWS': ''};
    $scope.IWSFilterlogic = { 'Name': '' };
    $scope.iwsServiceAccount = false;
    $scope.iwsServiceInputField = { 'Name': 'Custom Siren Input Field' };
    $scope.iwsServiceMapOutputFields = [];
    $scope.gdmServiceInputMappingFields = [];
    $scope.gdmServiceOutputMappingFields = [];

    // Start IWS Advanced Address Information 
    $scope.iwsAdvancedAddressServiceAccount = false;
    $scope.objIwsAdvancedAddressService = { 'Username': '', 'Password': '', 'Siret': '','IwsAdvancedAddressServiceStatus': '', 'IwsAdvancedAddressServiceDate': '','IsActiveIWSAdvancedAddress': ''};    
    $scope.iwsAdvancedAddressServiceInputField = { 'Name': 'Custom Siret Input Field' };
    $scope.iwsAdvancedAddressServiceMapOutputFields = [];
    $scope.IWSAdvancedFilterlogic = { 'Name': '' };
    // End IWS Advanced Address Information Service

    //Start Risk Datablock Service
    $scope.riskDatablocksServiceAccount = false;
    $scope.objRiskDatablockService = { 'Consumer_Key': '', 
                                        'Consumer_Secret': '', 
                                        'criteriaMapping':'essential',
                                        'tradeUp':'',
                                        'customerReference':'',
                                        'orderReason':'',
                                        'isOnlyRecommended':false, 
                                        'dunsNumber':'', 
                                        'riskDatablockServiceStatus':'',
                                        'riskDatablockServiceDate': '',
                                        'IsActiveRiskDatablock': false};
    $scope.riskDatablockServiceInputField = { 'Name' : 'Custom DUNS  Input Field ' };
    $scope.riskDatablockServiceFilterlogic = { 'Name': '' };
    $scope.output_RiskDatablockAccountService = [];
    $scope.output_RiskDatablockAccountServiceTemp = [];
    $scope.input_RiskDatablockAccountService = [];
    $scope.input_RiskDatablockAccountServiceTemp = [];
    $scope.riskDatablockServiceResponseFields = [];
    $scope.riskDatablockServiceCriteriaArray = [];
    $scope.IsAccountRiskDatablockServiceInfoError = false;
    $scope.criteriaForOutputfieldMapping = [{"name":"Essential", "value":"essential"},{"name":"Detailed", "value":"detailed"},{"name":"Complete", "value":"complete"},{"name":"Custom", "value":"custom"}];
    $scope.tradeUpOptionsForRiskDatablock = [{"name":"No trade up", "value":""},{"name":"If DUNS is a Branch, the Headquarter DUNS is returned", "value":"hq"}, {"name":"If DUNS is a Branch, the Domestic Headquarter DUNS is returned", "value": "domhq"}];
    $scope.orderReasonOption = [{"name":"No order reason", "value":""},{"name":"6332 (Credit Decision)", "value":"6332"},{"name":"6333 (Assessment of credit solvency for intended business connection)", "value":"6333"},{"name":"6334 (Assessment of credit solvency for ongoing business connection)", "value":"6334"},{"name":"6335 (Debt Collection)", "value":"6335"},{"name":"6336 (Commercial Credit Insurance)", "value":"6336"},{"name":"6337 (Insurance Contract)", "value":"6337"},{"name":"6338 (Leasing Agreement)", "value":"6338"},{"name":"6339 (Rental Agreement)", "value":"6339"}];
    $scope.essentialResponseFields = [];
    $scope.detailedResponseFields = [];
    $scope.completeResponseFields = [];
    $scope.customResponseFields = [];
    //End Risk Datablock Service

    //Start Company Report Service
    $scope.companyReportServiceAccount = false;
    $scope.objCompanyReportService = { 'Consumer_Key': '', 
                                        'Consumer_Secret': '', 
                                        'tradeUp':'',
                                        'customerReference':'',
                                        'orderReason':'', 
                                        'dunsNumber':'', 
                                        'companyReportServiceStatus':'',
                                        'companyReportServiceDate': '',
                                        'inLangage': 'en-US',
                                        'Product_ID': 'birstd',
                                        'IsActiveCompanyReport': false};
    $scope.companyReportServiceInputField = { 'Name' : 'Custom DUNS  Input Field ' };
    $scope.companyReportServiceFilterlogic = { 'Name': '' };
    $scope.companyReportServiceCriteriaArray = [];
    $scope.IsAccountCompanyReportServiceInfoError = false;
    $scope.productIdOptionsForCompanyReport = [{"name":"birstd (Business Information Report)", "value":"birstd"},{"name":"comprh (Comprehensive Report)", "value":"comprh"}];                                    
    $scope.inLangageOptionsForCompanyReport = [{"name":"en-US", "value":"en-US"},{"name":"fr", "value":"fr"},{"name":"es", "value":"es"},{"name":"de", "value":"de"},{"name":"pt", "value":"pt"},{"name":"it", "value":"it"},{"name":"nl", "value":"nl"},{"name":"fr-BE", "value":"fr-BE"},{"name":"nl-BE", "value":"nl-BE"}];
    $scope.tradeUpOptionsForCompanyReport = [{"name":"No trade up", "value":""},{"name":"If DUNS is a Branch, the Headquarter DUNS is returned", "value":"hq"}, {"name":"If DUNS is a Branch, the Domestic Headquarter DUNS is returned", "value": "domhq"}];
    $scope.orderReasonOptionForCompanyReport = [{"name":"No order reason", "value":""},{"name":"6332 (Credit Decision)", "value":"6332"},{"name":"6333 (Assessment of credit solvency for intended business connection)", "value":"6333"},{"name":"6334 (Assessment of credit solvency for ongoing business connection)", "value":"6334"},{"name":"6335 (Debt Collection)", "value":"6335"},{"name":"6336 (Commercial Credit Insurance)", "value":"6336"},{"name":"6337 (Insurance Contract)", "value":"6337"},{"name":"6338 (Leasing Agreement)", "value":"6338"},{"name":"6339 (Rental Agreement)", "value":"6339"}];
                                        
    
    //End Company Report Service

    // Start IWS Bankruptcy Information Service
    $scope.iwsBankruptcyInfoServiceAccount = false;
    $scope.objIwsBankruptcyInfoService = { 'Username': '', 'Password': '', 'Siren': '','DocURL':'', 'Source': '','IwsBankruptcyInfoServiceStatus': '', 'IwsBankruptcyInfoServiceDate': '','IsActiveIWSBankruptcyInfo': ''};
    $scope.iwsBankruptcyInfoServiceInputField = { 'Name': 'Custom Siren Input Field' };
    $scope.output_IWSBankruptcyInfoAccountService = [];
    $scope.output_IWSBankruptcyInfoAccountServiceTemp = [];
    $scope.iwsBankruptcyInfoServiceMapOutputFields = [];
    $scope.IWSBankruptcyInfoFilterlogic = { 'Name': '' };
    $scope.iwsBankruptcyInfoCriteriaArray = [];  
    $scope.IsAccountIwsBankruptcyInfoError = false;
    // Start IWS Bankruptcy Information Service

    //IndueD Service
    $scope.induedService = false;
    $scope.objInduedService = { 'api_token': '', 
                                'duns':'', 
                                'tags':'',
                                'DueDiligenceId':'api_connector__indued_duediligence_id__c',
                                'DueDiligenceStatus':'api_connector__indued_duediligences_status__c',
                                'DueDiligenceDate':'',
                                'DueDiligenceServiceFpmStatus':'api_connector__indued_duediligencesfinal_fpm_status__c', 
                                'DueDiligenceServiceFpmDate':'' ,
                                'DueDiligenceDuedidServiceStatus': '',
                                'IsActiveDueDiligenceService': '', 
                                'ReportIdServiceReoprtStatus': 'api_connector__indued_reportsfinal_report_status__c', 
                                'ReportIdServiceStatus': '',
                                'ReportId':'api_connector__indued_reports_id__c', 
                                'ReportDate':'',
                                'ReportServiceStatus':'',
                                'ReportIdDate':'', 
                                'ReportUrl':'',
                                'sanctions':'',
                                'peps':'',
                                'adverse_medias':'',
                                'match_confidence':'',
                                'ownership_threshold':'',
                                'managers_scope':'',
                                'PortfolioStatus':'api_connector__indued_portfolio_status__c',
                                'PortfolioDate':'api_connector__indued_portfolio_date__c'};
    $scope.portFolioServiceInputField = { 'Name': 'Custom DUNS Number Input Field' };
    $scope.input_IndueDService = [];
    $scope.input_IndueDServiceTemp = [];
    $scope.output_IndueDService = [];
    $scope.output_IndueDServiceTemp = [];
    $scope.indueDServiceFilterlogic = { 'Name': ''};
    $scope.indueDserviceCriteriaArray = [];
    $scope.isIndueDServiceError = false;
    $scope.induedServiceResopnseFields = [];
    //End IndueD Service

    $scope.output_IWSAccountService = [];
    $scope.output_IWSAccountServiceTemp = [];
    $scope.output_IWSAdvancedAddressAccountService = [];
    $scope.output_IWSAdvancedAddressAccountServiceTemp = [];
    $scope.input_IWSAccountService = [];
    $scope.input_IWSAccountServiceTemp = [];
    $scope.input_GDMAccountService = [];
    $scope.input_GDMAccountServiceTemp = [];
    $scope.output_GDMAccountServiceTemp = [];
    $scope.output_GDMAccountService = [];
    $scope.input_GDMAccountDUNS = [];
    $scope.input_GDMAccountDUNSTemp = [];
    
    $scope.iwsCriteriaArray = [];  
    $scope.IsAccountIwsError = false;
    $scope.iwsAdvancedAddressCriteriaArray = [];  
    $scope.IsAccountIwsAdvancedAddressError = false;


    //Start IWS standred address information
    $scope.objIWSStdAddInfoService = { 'Username': '', 'Password': '', 'DocURL':'', 'Siren': '','IwsServiceStatus': '', 'IwsServiceDate': '','IsActiveIWS': ''};
    $scope.iwsStdAddInfoFilterlogic = { 'Name': '' };
    $scope.isIWSStdAddInfoServiceForAccount = false;
    $scope.iwsStdAddInfoServiceInputField = { 'Name': 'Custom Siren or Siret Input Field' };
    $scope.iwsStdAddInfoServiceResopnseFields = [];
    $scope.output_IWSStdAddInfoAccountService = [];
    $scope.output_IWSStdAddInfoAccountServiceTemp = [];
    $scope.input_IWSStdAddInfoAccountService = [];
    $scope.input_IWSStdAddInfoAccountServiceTemp = [];
    $scope.iwsStdAddInfoCriteriaArray = []; 
    $scope.isIWSStdAddInfoServiceError = false;

    // Start IWS Paydex Info Service
    $scope.objIWSPaydexInfoService = { 'Username': '', 'Password': '', 'DocURL':'', 'Siren': '','IwsServiceStatus': '', 'IwsServiceDate': '','IsActiveIWS': ''};
    $scope.iwsPaydexInfoFilterlogic = { 'Name': '' };
    $scope.isIWSPaydexInfoServiceForAccount = false;
    $scope.iwsPaydexInfoServiceInputField = { 'Name': 'Custom Siren or Siret Input Field' };
    $scope.iwsPaydexInfoServiceResopnseFields = [];
    $scope.output_IWSPaydexInfoAccountService = [];
    $scope.output_IWSPaydexInfoAccountServiceTemp = [];
    $scope.input_IWSPaydexInfoAccountService = [];
    $scope.input_IWSPaydexInfoAccountServiceTemp = [];
    $scope.iwsPaydexInfoCriteriaArray = []; 
    $scope.isIWSPaydexInfoServiceError = false;
    
    //End IWS Paydex Info Service

    //Start IWS Balance Sheet  
    $scope.objIWSBalanceSheetService = { 'Username': '', 'Password': '', 'DocURL':'', 'Siren': '','IwsServiceStatus': '', 'IwsServiceDate': '','IsActiveIWS': ''};
    $scope.iwsBalanceSheetFilterlogic = { 'Name': '' };
    $scope.isIWSBalanceSheetServiceForAccount = false;
    $scope.iwsBalanceSheetServiceInputField = { 'Name': 'Custom Siren Input Field' };
    $scope.iwsBalanceSheetResopnseFields = [];
    $scope.output_IWSBalanceSheetAccountService = [];
    $scope.output_IWSBalanceSheetAccountServiceTemp = [];
    $scope.input_IWSBalanceSheetAccountService = [];
    $scope.input_IWSBalanceSheetAccountServiceTemp = [];
    $scope.iwsBalanceSheetCriteriaArray = []; 
    $scope.isIWSBalanceSheetServiceError = false;
    //End IWS Balance Sheet


    //Start IWS risk information service
    $scope.objIWSRiskInfoService = { 'Username': '', 'Password': '', 'DocURL': '', 'Siren': '', 'IwsServiceStatus': '', 'IwsServiceDate': '', 'IsActiveIWS': ''};
    $scope.iwsRiskInfoFilterLogic = { 'Name': ''};
    $scope.isIWSRiskInfoServiceForAccount = false;
    $scope.iwsRiskInfoServiceInputField = { 'Name': 'Custom Siren or Siret Input Field' };
    $scope.iwsRiskInfoServiceResopnseFields = [];
    $scope.output_IWSRiskInfoAccountService = [];
    $scope.output_IWSRiskInfoAccountServiceTemp = [];
    $scope.input_IWSRiskInfoAccountService = [];
    $scope.input_IWSRiskInfoAccountServiceTemp = [];
    $scope.iwsRiskInfoCriteriaArray = []; 
    $scope.isIWSRiskInfoServiceError = false;
    //End IWS risk information service

    $scope.popUpCheck = true;

    $scope.IsAccError = false
    $scope.IsconError = false;
    $scope.IsCreditError = false;
    $scope.IsVatError = false;
    $scope.IsAccKvkError = false
    $scope.IsLeadKvkError = false;
    $scope.IslookUp = true;
    $scope.IsLeadGlobalError = false;
    $scope.IsAccountGDMError = false;
    $scope.IsAccountGlobalError = false;
    $scope.IsAccountTradeCreditError = false;

    //toolkit management
    $scope.IsToolkitError = false;
    $scope.output_toolkit = [];
    $scope.output_ToolkitTemp = [];
    
    //toolkit Quick Check
    $scope.IsToolkitQCError = false;
    $scope.output_toolkitQC = [];
    $scope.output_ToolkitQCTemp = [];

    $scope.recordPicklist = [];
    $scope.recordBooleanlist = [];

    $scope.searchKeyword = { 'Name': '' };
    $scope.IsPicklist = false;
    $scope.IsBoolean = false;
    $scope.selectedRecord = {};
    $scope.IsChecked = { 'Name': 'True' };
    //$scope.translation = {};
    $scope.IsFilterLogic = false;

    //output field
    $scope.vatRecord = { 'Value': '', 'Status': '', 'Date': '','Identifier':'','Limit': '' };
    $scope.creditRecord = { 'Value': '', 'Status': '', 'Date': '', 'Limit': '' };
    $scope.accRecord = { 'Value': '', 'Status': '', 'Date': '', 'Limit': '' };
    $scope.conRecord = { 'Value': '', 'Status': '', 'Date': '', 'Limit': '' };
    $scope.accKvkRecord = { 'Value': '', 'Status': '', 'Date': '' };
    $scope.leadKvkRecord = { 'Value': '', 'Status': '', 'Date': '' };
    $scope.leadGlobalOutRecord = { 'Value': '', 'Status': '', 'Date': '' };
    $scope.accountGlobalOutRecord = { 'Value': '', 'Status': '', 'Date': '' };
    $scope.accountTradeCreditDateStatusRecord = { 'Status': '', 'Date': '' };

    $scope.showModel = false;

    //translation goes here
    $scope.Services = 'Services';
    $scope.invalidLogic = false;
    $scope.customLogicFilter = { 'Name': '' };

    $scope.IsShowPassword = true;
    $scope.typePassword = 'password';

    //vat input mapping
    $scope.vatInputField = { 'Name': 'Custom VAT Number Input Field' };

    //creadit input mapping
    $scope.creditInputField = { 'Name': 'Custom DUNS Number Input Field' };

    //toolkit enterprise management
    $scope.toolkitEntrMngInputField = { 'Name': 'Custom DUNS Number Input Field' };
    $scope.arrToolkitOutPutField = [];
    $scope.toolkitCriteriaArray = [];
    $scope.outputFldsToolkit = [];

  //toolkit Quick Check
    $scope.toolkitQckChkInputField = { 'Name': 'Custom DUNS Number Input Field' };
    $scope.arrToolkitQCOutPutField = [];
    $scope.toolkitQCCriteriaArray = [];
    $scope.outputFldsToolkitQC = [];

    $scope.caseKeyRecord = { 'Account': '', 'Contact': '' ,'AccountKvk':'','LeadKvk':''};
    $scope.CaseKeylabel = 'Key';
    $scope.IsCredentialUpdate = false;
    $scope.preventCallWatchInitialy = 0;

    $scope.IsSave = false;

    //Dutch chamber account
    $scope.kvkAccInFieldsFlag = false
    $scope.kvkAccOutFieldsFlag = false;
    $scope.kvkInputFields = [];
    $scope.kvkOutputFields = [];
    $scope.accountKvk = false;
    $scope.Mapping_AccountKvk = [];
    $scope.Mapping_AccountKvkTemp = [];
    $scope.Output_AccountKvk = [];
    $scope.Output_AccountKvkTemp = [];
    $scope.accountKvkCriteriaArray = [];
    

    //dutch chamber lead
    $scope.leadKvk = false;
    $scope.Mapping_LeadKvk = [];
    $scope.Mapping_LeadKvkTemp = [];
    $scope.Output_LeadKvk = [];
    $scope.Output_LeadKvkTemp = [];
    $scope.leadKvkCriteriaArray = [];
    $scope.kvkLeadInputFields = [];
    $scope.kvkLeadOutputFields = [];
    $scope.kvkLeadInFieldsFlag = false;
    $scope.kvkLeadOutFieldsFlag = false;

    //Trade
    $scope.accountTradeCredit = false;
    $scope.recordAccountTradeCredit = [];
    $scope.accountTradeCreditCriteriaArray = [];  
    $scope.tradeUpOptions = [{"name":"No trade up", "value":""},{"name":"If DUNS is a Branch, the Headquarter DUNS is returned", "value":"hq"}, {"name":"If DUNS is a Branch, the Domestic Headquarter DUNS is returned", "value": "domhq"}];
    $scope.objAccountTradeCredit["tradeUp"] = "--None--";
    $scope.accountTradeCreditInputField = { 'Name': 'Custom DUNS Number Input Field' };
    $scope.output_AccountTradeCredit = [];
    $scope.output_AccountTradeCreditTemp = [];
    $scope.tradeCreditOutputOptionFields = [];



    //Global
    $scope.leadGlobal = false;
    $scope.accountGlobalMatch = false;

    $scope.recordAccountGlobal = [];
    $scope.recordAccountGlobalTemp = [];
    $scope.recordLeadGlobal = [];
    $scope.recordLeadGlobalTemp = [];

    $scope.output_AccountGlobal = [];
    $scope.output_LeadGlobal = [];


    $scope.output_LeadGlobalTemp = [];
    $scope.output_AccountGlobalTemp = [];

    $scope.leadGlobalMapInputFields = [];
    $scope.leadGlobalMapOutputFields = [];

    $scope.leadGlobalCriteriaArray = [];
    $scope.accountGDMCriteriaArray = [];
    $scope.accountGlobalCriteriaArray = [];   
    $scope.objLeadGlobal["confidenceLowerLevel"] = 1;
    $scope.confidenceLowerLevelOptions = ['--None--'];
    for(var index = 1; index <= 10; index++){
        $scope.confidenceLowerLevelOptions.push(index);
    }


    $scope.exclusionCriteriaOptions = [{'name':'Exclude non headquarters', 'value':'ExcludeNonHeadQuarters', 'disabled':false}, 
    {'name':'Exclude non marketable', 'value':'ExcludeNonMarketable', 'disabled':false},
    {'name':'Exclude out of business ', 'value':'ExcludeOutofBusiness', 'disabled':false },
    {'name':'Exclude undeliverable', 'value':'ExcludeUndeliverable', 'disabled':false },
    {'name':'Exclude unreachable', 'value':'ExcludeUnreachable', 'disabled':false }];
    $scope.lstLeadGlobalExclusionCriteriaSelection = [];
    $scope.lstAccountGlobalExclusionCriteriaSelection = [];

    $scope.selectedDataType;
   
    $rootScope.DataTypeTitle = 'Data Type';
        $scope.steps = [
      {
          step: 1,
          name: "Select Services",
          template: application_js + "templates/step1.html",
          icon: "glyphicon glyphicon-user",
          progress: "0%"
      },
      {
          step: 2,
          name: " Add Credentials",
          template: application_js + "templates/step2.html",
          icon: "glyphicon glyphicon-user",
          progress: "20%"
      },
      {
          step: 3,
          name: "Input Setting",
          template: application_js + "templates/step3.html",
          icon: "glyphicon glyphicon-user",
          progress: "40%"

      },
      {
          step: 4,
          name: "Input Field Mapping",
          template: application_js + "templates/step4.html",
          icon: "glyphicon glyphicon-user",
          progress: "60%"

      },
      {
          step: 5,
          name: "Output Field Mapping",
          template: application_js + "templates/step5.html",
          icon: "glyphicon glyphicon-user",
          progress: "80%"
      },
      {
        step: 6,
        name: "Set Triggers",
        template: application_js + "templates/step6.html",
        icon: "glyphicon glyphicon-user",
        progress: "100%"
    },
    ];

    $scope.inputAccountFieldsOnWizard = [];
    $scope.inputLeadFieldsOnWizard = [];
    $scope.exclusionCriteriaSelection = function (item, objName) {
        var lstExclusionCriteriaSelection ;
        if(objName === 'Account'){
            lstExclusionCriteriaSelection = $scope.lstAccountGlobalExclusionCriteriaSelection;
        }else{
            lstExclusionCriteriaSelection = $scope.lstLeadGlobalExclusionCriteriaSelection;
        }
        
        var idx =  lstExclusionCriteriaSelection.indexOf(item);
        if (idx > -1) {
            lstExclusionCriteriaSelection.splice(idx, 1);
        }  else {
            lstExclusionCriteriaSelection.push(item);
        }

        if(objName === 'Account'){
            $scope.lstAccountGlobalExclusionCriteriaSelection = lstExclusionCriteriaSelection;
        }else{
            $scope.lstLeadGlobalExclusionCriteriaSelection = lstExclusionCriteriaSelection;
        }
    }

    $scope.gotoStep = function (newStep) {
        if ($scope.IsCredentialUpdate == true) {
            toaster.pop("error", "Error", "Please Save the Credentials");
            return
        }   
        
        if ($scope.selectService.Name != '--None--') {
            if ($scope.currentStep == 5) {
                if($scope.output_AccountTradeCredit.findIndex(x => x.type == "JPathRow") >= 0){
                    API_Connector.Engine.validateJSON(
                        JSON.stringify($scope.output_AccountTradeCredit),
                        function(validateJSONResult, event) {
                            $scope.output_AccountTradeCredit = validateJSONResult;
                            $scope.$apply();
                            let validated = true;
                            for (let index = 0;index < $scope.output_AccountTradeCredit.length; index++) {
                              let outputMappingField = $scope.output_AccountTradeCredit[index];
                              if (outputMappingField.type == "JPathRow" && outputMappingField.value != "" &&  outputMappingField.isError == true) {
                                    validated = false;
                                }
                            }
                            if(validated){
                                $scope.gotoSpecifiedStep(newStep);
                                $scope.$apply();
                            }
                        }               
                      );
                }else {
                    $scope.gotoSpecifiedStep(newStep);
                }             
            } else{
                $scope.gotoSpecifiedStep(newStep);
            }
        } else {
            toaster.pop('error', "Error", "Please select the service");
        }
    }

    $scope.gotoSpecifiedStep = function (newStep)  {
        if ($scope.selectService.Name == $scope.serviceListObject.VAT) {
          var tempArray = [];
          if ($scope.objVat.Vat == "--None--") {
            tempArray.push({ name: "", value: "" });
          }

          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            $scope.IsSave = false;
          }
        }
        if ($scope.selectService.Name == $scope.serviceListObject.ACCOUNT_DUPLICATE) {
          var tempArray = [];

          angular.forEach($scope.recordAccount, function(value, key) {
            if (value.name == "--None--") {
              tempArray.push(value);
            }
          });

          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            $scope.IsSave = false;
          }
        }
        if (
          $scope.selectService.Name ==
          $scope.serviceListObject.CONTACT_DUPLICATE
        ) {
          var tempArray = [];

          angular.forEach($scope.recordContact, function(value, key) {
            if (value.name == "--None--") {
              tempArray.push(value);
            }
          });

          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            tempArray = [];
            $scope.IsSave = false;
          }
        }
        if (
          $scope.selectService.Name ==
          $scope.serviceListObject.CREDIT_CHECK
        ) {
          var tempArray = [];
          if ($scope.objCredit.Duns == "--None--") {
            tempArray.push({ name: "", value: "" });
          }

          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            tempArray = [];
            $scope.IsSave = false;
          }
        }
        if (
          $scope.selectService.Name == $scope.serviceListObject.ENTERPRISE
        ) {
          var tempArray = [];
          if ($scope.objToolkitEnterprise.Duns == "--None--") {
            tempArray.push({ name: "", value: "" });
          }

          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            tempArray = [];
            $scope.IsSave = false;
          }
        }
        // Start Issue - "Output field mapped and loader issue"
        if ($scope.selectService.Name == $scope.serviceListObject.ACCOUNT_TRADE) {
            var tempArray = [];
            if ($scope.objAccountTradeCredit.dunsNumber == "--None--") {
              tempArray.push({ name: "", value: "" });
            }
  
            if (tempArray.length > 0) {
              $scope.IsSave = true;
              toaster.pop(
                "error",
                "Error",
                "Please select the Appropriate Field"
              );
              return;
            } else {
              tempArray = [];
              $scope.IsSave = false;
            }
        }
        // End Issue - "Output field mapped and loader issue"
        if ($scope.selectService.Name == $scope.serviceListObject.QUICK) {
          var tempArray = [];
          if ($scope.objToolkitQuickCheck.Duns == "--None--") {
            tempArray.push({ name: "", value: "" });
          }

          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            tempArray = [];
            $scope.IsSave = false;
          }
        }

        // check validation of Iws service in Input Fields Mapping tab
        if ($scope.selectService.Name == $scope.serviceListObject.IWS_SERVICE) {
            var tempArray = [];
            if ($scope.objIwsService.Siren == "--None--") {
              tempArray.push({ name: "", value: "" });
            }  
            if (tempArray.length > 0) {
              $scope.IsSave = true;
              toaster.pop(
                "error",
                "Error",
                "Please select the Appropriate Field"
              );
              return;
            } else {
              tempArray = [];
              $scope.IsSave = false;
            }
        } 
         // check validation of Iws Advanced Address Service in Input Fields Mapping tab
         if ($scope.selectService.Name == $scope.serviceListObject.IWS_Advanced_Address_Information_Service) {
            var tempArray = [];
            if ($scope.objIwsAdvancedAddressService.Siret == "--None--") {
              tempArray.push({ name: "", value: "" });
            }  
            if (tempArray.length > 0) {
              $scope.IsSave = true;
              toaster.pop(
                "error",
                "Error",
                "Please select the Appropriate Field"
              );
              return;
            } else {
              tempArray = [];
              $scope.IsSave = false;
            }
        }
        
        // check validation of IWS Bankruptcy Information Service in Input Fields Mapping tab
        if ($scope.selectService.Name == $scope.serviceListObject.IWS_Bankruptcy_Information_Service) {
            var tempArray = [];
            if ($scope.objIwsBankruptcyInfoService.Siren == "--None--") {                
              tempArray.push({ name: "", value: "" });
            }  
            if (tempArray.length > 0) {
              $scope.IsSave = true;
              toaster.pop(
                "error",
                "Error",
                "Please select the Appropriate Field"
              );
              return;
            } else {
              tempArray = [];
              $scope.IsSave = false;
            }
        } 

         
        if (
          $scope.selectService.Name ==
          $scope.serviceListObject.ACCOUNT_KVK
        ) {
          var tempArray = [];

          angular.forEach($scope.Mapping_AccountKvk, function(
            value,
            key
          ) {
            if (value.name == "--None--") {
              tempArray.push(value);
            }
          });
          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            $scope.IsSave = false;
          }
        }
        if (
          $scope.selectService.Name == $scope.serviceListObject.LEAD_KVK
        ) {
          var tempArray = [];
          angular.forEach($scope.Mapping_LeadKvk, function(value, key) {
            if (value.name == "--None--") {
              tempArray.push(value);
            }
          });
          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            $scope.IsSave = false;
          }
        }
        if (
          $scope.selectService.Name ==
          $scope.serviceListObject.LEAD_GLOBAL
        ) {
          var tempArray = [];
          angular.forEach($scope.recordLeadGlobal, function(value, key) {
            if (value.name == "--None--") {
              tempArray.push(value);
            }
          });
          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            $scope.IsSave = false;
          }
        }
        if (
          $scope.selectService.Name ==
          $scope.serviceListObject.ACCOUNT_GLOBAL
        ) {
          var tempArray = [];
          angular.forEach($scope.recordAccountGlobal, function(
            value,
            key
          ) {
            if (value.name == "--None--") {
              tempArray.push(value);
            }
          });
          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            $scope.IsSave = false;
          }
        }
       
        if ($scope.selectService.Name == $scope.serviceListObject.ACCOUNT_TRADE) {
          var tempArray = [];
          angular.forEach($scope.recordAccountTradeCredit, function(value, key) {
            if (value.name == "--None--") {
              tempArray.push(value);
            }
          });
          if (tempArray.length > 0) {
            $scope.IsSave = true;
            toaster.pop(
              "error",
              "Error",
              "Please select the Appropriate Field"
            );
            return;
          } else {
            $scope.IsSave = false;
          }
        }
        if ($scope.selectService.Name == $scope.serviceListObject.GLOBAL_DECISION_MAKER && newStep-1 == 4 ) {
            var tempArray = [];
            angular.forEach($scope.input_GDMAccountService, function(value, key) {
              if (value.name == "--None--") {
                tempArray.push(value);
              }
            });
            if( $scope.objGDMService.Duns == "--None--" ) {
                    tempArray.push({'name':'--None--','value':'--None--'});
            }
            if (tempArray.length > 0) {
              $scope.IsSave = true;
              toaster.pop(
                "error",
                "Error",
                "Please select the Appropriate Field"
              );
              return;
            } else {
              $scope.IsSave = false;
            }
        }

        // check validation of IWS Standred Address Service in Input Fields Mapping tab
        if ($scope.selectService.Name == $scope.serviceListObject.IWS_STANDARD_ADDRESS_INFORMATION && 
            ($scope.objIWSStdAddInfoService.Siren == "--None--" || $scope.objIWSStdAddInfoService.Siren == "") && 
            newStep-1 == 4) {
                toaster.pop(
                    "error",
                    "Error",
                    "Please select the Appropriate Field"
                  );
                  return;              
        } 

        // check validation of Risk Datablock Service in Input Fields Mapping tab
        if ($scope.selectService.Name == $scope.serviceListObject.RISK_DATABLOCKS && 
            ($scope.objRiskDatablockService.dunsNumber == "--None--" || $scope.objRiskDatablockService.dunsNumber == "") && 
            newStep-1 == 4) {
                toaster.pop(
                    "error",
                    "Error",
                    "Please select the Appropriate Field"
                  );
                  return;              
        }

        // check validation of Company Report Service in Input Fields Mapping tab
        if ($scope.selectService.Name == $scope.serviceListObject.COMPANY_REPORT && 
            ($scope.objCompanyReportService.dunsNumber == "--None--" || $scope.objCompanyReportService.dunsNumber == "") && 
            newStep-1 == 4) {
                toaster.pop(
                    "error",
                    "Error",
                    "Please select the Appropriate Field"
                  );
                  return;              
        } 

        // check validation of Iws Paydex Information Service in Input Fields Mapping tab
        if ($scope.selectService.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION && 
            ($scope.objIWSPaydexInfoService.Siren == "--None--" || $scope.objIWSPaydexInfoService.Siren == "") && 
            newStep-1 == 4) {
                toaster.pop(
                    "error",
                    "Error",
                    "Please select the Appropriate Field"
                  );
                  return;              
        }
        
        // Check validation for IWS Risk Information Service in input field mapping tab
        if($scope.selectService.Name == $scope.serviceListObject.IWS_RISK_INFORMATION && 
            ($scope.objIWSRiskInfoService.Siren == "--None--" || $scope.objIWSRiskInfoService.Siren == "") &&
            newStep-1 == 4) {
                toaster.pop(
                    "error",
                    "Error",
                    "Please select the Appropriate Field"
                  );
                  return;              
        }

        if ($scope.selectService.Name == $scope.serviceListObject.IWS_BALANCE_SHEET && 
            ($scope.objIWSBalanceSheetService.Siren == "--None--" || $scope.objIWSBalanceSheetService.Siren == "") &&
            newStep-1 == 4) {
                toaster.pop(
                    "error",
                    "Error",
                    "Please select the Appropriate Field"
                  );
                  return;              
        } 

        if($scope.selectService.Name == $scope.serviceListObject.INDUED_SERVICE && 
            ($scope.objInduedService.duns == "--None--" || $scope.objInduedService.duns == "") &&
            newStep-1 == 4) {
                toaster.pop(
                    "error",
                    "Error",
                    "Please select the Appropriate Field"
                );
                return;
            }

        if($scope.selectService.Name == $scope.serviceListObject.INDUED_SERVICE && 
            ($scope.objInduedService.tags == "--None--" || $scope.objInduedService.tags == "") &&
            newStep-1 == 4) {
                toaster.pop(
                    "error",
                    "Error",
                    "Please select the Appropriate Field"
                );
                return;
            }

        if ($scope.IsSave) {
          toaster.pop(
            "error",
            "Error",
            "Please select the Appropriate Field"
          );
          return;
        }
        if (!$scope.IsSave) $scope.currentStep = newStep;
      }

    $scope.getStepTemplate = function () {
        for (var i = 0; i < $scope.steps.length; i++) {
            if ($scope.currentStep == $scope.steps[i].step) {
                return $scope.steps[i].template;
            }
        }
    }
    //adding loader into page
    $loader.getLoader();
    $loader.showProcessing();
    $timeout(function () {
        $loader.hideProcessing();
    }, 5000);
    $scope.$watchGroup(
      [
        "objDuplicate.Username",
        "objDuplicate.Password",
        "objCredit.Username",
        "objCredit.Password",
        "objToolkitEnterprise.Username",
        "objToolkitEnterprise.Password",
        "objToolkitQuickCheck.Username",
        "objToolkitQuickCheck.Password",
        "objIwsService.Username",
        "objIwsService.Password",
        "objIwsAdvancedAddressService.Username",
        "objIwsAdvancedAddressService.Password",
        "objIwsBankruptcyInfoService.Username",
        "objIwsBankruptcyInfoService.Password",
        "objGDMService.UserId",
        "objGDMService.Password",
        "objDuplicate.ContactUsername",
        "objDuplicate.ContactPassword",
        "caseKeyRecord.Contact",
        "caseKeyRecord.Account",
        "caseKeyRecord.AccountKvk",
        "objDuplicate.AccountKvkUsername",
        "objDuplicate.AccountKvkPassword",
        "objDuplicate.LeadKvkUsername",
        "objDuplicate.LeadKvkPassword",
        "caseKeyRecord.LeadKvk",
        "objLeadGlobal.Consumer_Key",
        "objLeadGlobal.Consumer_Secret",
        "objAccountGlobal.Consumer_Key",
        "objAccountGlobal.Consumer_Secret",
        "objAccountTradeCredit.Consumer_Key",
        "objAccountTradeCredit.Consumer_Secret",
        "objIWSStdAddInfoService.Username",
        "objIWSStdAddInfoService.Password",
        "objIWSPaydexInfoService.Username",
        "objIWSPaydexInfoService.Password",
        "objIWSRiskInfoService.Username",
        "objIWSRiskInfoService.Password",
        "objIWSBalanceSheetService.Username",
        "objIWSBalanceSheetService.Password",
        "objInduedService.api_token",
        "objRiskDatablockService.Consumer_Key",
        "objRiskDatablockService.Consumer_Secret",
        "objCompanyReportService.Consumer_Key",
        "objCompanyReportService.Consumer_Secret"
      ],
      function(newValue, oldValue) {
        if (newValue != oldValue && $scope.preventCallWatchInitialy != 1) {
          $scope.IsCredentialUpdate = true;
          $scope.preventCallWatchInitialy = 2;
        } else {
          $scope.preventCallWatchInitialy = 2;
        }
      }
    );
    $scope.myFunc = function (newValue) {
        //
        if (newValue == '--None--') {
            $scope.IsSave = true;
            //toaster.pop('error', "error", "Please Select Appropriate Field");
        } else
            $scope.IsSave = false;
        console.log('newValue::' + newValue);
    }
    $scope.onloadFun = function () {
        //getting labels
        $scope.customLabel = '';
        API_Connector.Engine.getlabels(function (resultLabels, event) {
            if (resultLabels != null) {
                $scope.customLabel = resultLabels;
                if (resultLabels.Select_Services != null) {
                    $scope.selectServiceLabel = resultLabels.Select_Services;
                    $scope.steps[0].name = resultLabels.Select_Services;
                    $scope.steps[1].name = resultLabels.Add_Credentials;
                    $scope.steps[2].name = resultLabels.Input_Setting;
                    $scope.steps[3].name = resultLabels.Input_Field_Mapping;
                    $scope.steps[4].name = resultLabels.Output_Field_Mapping;
                    $scope.steps[5].name = resultLabels.Enable_disable_Triggers;
                }

                $scope.selectService = { 'Name': '--None--' };
                $scope.serviceName = { 'Name': '--None--' };
                $scope.serviceList = [];
                $scope.serviceListObject = {
                  VAT: resultLabels.VAT_Number_Check,
                  ACCOUNT_DUPLICATE: resultLabels.Lead_Duplication_Check_Account,
                  CONTACT_DUPLICATE: resultLabels.Lead_Duplication_Check_Contact,
                  CREDIT_CHECK : resultLabels.Credit_Check,
                  ENTERPRISE : resultLabels.Toolkit_Enterprise_Management,
                  QUICK : resultLabels.Toolkit_Quick_Check,
                  ACCOUNT_KVK : resultLabels.Account_Kvk_Service,
                  LEAD_KVK : resultLabels.Lead_Kvk_Service,
                  ACCOUNT_GLOBAL : resultLabels.Account_Global_Match,
                  LEAD_GLOBAL  : resultLabels.Lead_Global_Match,
                  ACCOUNT_TRADE : resultLabels.Account_Trade_Credit_Risk,
                  IWS_SERVICE : resultLabels.IWS_Service,
                  GLOBAL_DECISION_MAKER : resultLabels.Global_Decision_Maker_Service,
                  IWS_STANDARD_ADDRESS_INFORMATION : resultLabels.IWS_Standard_Address_Information_Service,
                  IWS_Advanced_Address_Information_Service : resultLabels.IWS_Advanced_Address_Information_Service,
                  // Start IWS Bankruptcy Information Service
                  IWS_Bankruptcy_Information_Service : resultLabels.IWS_Bankruptcy_Information_Service,
                  // End IWS Bankruptcy Information Service
                  //Start IWS Paydex Info Service
                  IWS_PAYDEX_INFORMATION : resultLabels.IWS_Paydex_Information_Service,
                  //End IWS Paydex Info Service
                  //Start IWS Risk Information
                  IWS_RISK_INFORMATION: resultLabels.IWS_Risk_Information_Service,
                  //End IWS Risk Information
                  IWS_BALANCE_SHEET:resultLabels.IWS_Balance_Sheet_Service,
                  //Start IndueD Service
                  INDUED_SERVICE:resultLabels.IndueD_Service,
                  //Start Risk Datablocks Service
                  RISK_DATABLOCKS : resultLabels.Risk_Datablocks_Service,
                  //Start Company Report Service
                  COMPANY_REPORT : resultLabels.Company_Reports_Service
                }
                $scope.serviceList.push({ 'Name': '--None--' });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.ACCOUNT_GLOBAL });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.LEAD_GLOBAL });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.ACCOUNT_TRADE });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.QUICK });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.ENTERPRISE }); 
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.CREDIT_CHECK });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.VAT });        
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.ACCOUNT_DUPLICATE });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.CONTACT_DUPLICATE });       
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.ACCOUNT_KVK });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.LEAD_KVK });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.IWS_SERVICE });
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.GLOBAL_DECISION_MAKER }); 
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.IWS_STANDARD_ADDRESS_INFORMATION }); 
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.IWS_Advanced_Address_Information_Service });
                // Start IWS Advanced Address Information  
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.IWS_Bankruptcy_Information_Service });
                // End IWS Advanced Address Information
                //start IWS Paydex Info Service
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.IWS_PAYDEX_INFORMATION});
                //End IWS Paydex Info Service 
                //Start IWS Risk Information
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.IWS_RISK_INFORMATION});
                //End IWS Risk Information  
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.IWS_BALANCE_SHEET });
                //Start IndueD Service
                $scope.serviceList.push({ 'Name': $scope.serviceListObject.INDUED_SERVICE});
                //End
                //Start Risk Datablocks
                $scope.serviceList.push({'Name': $scope.serviceListObject.RISK_DATABLOCKS});
                //Start Company Report Service
                $scope.serviceList.push({'Name': $scope.serviceListObject.COMPANY_REPORT});
            }

        }, { escape: false })

        $scope.formatDate = function (date) {
            var d = new Date(date),
                month = '' + (d.getMonth() + 1),
                day = '' + d.getDate(),
                year = d.getFullYear();

            if (month.length < 2) month = '0' + month;
            if (day.length < 2) day = '0' + day;

            return [year, month, day].join('-');
        }

        //format ampm
        $scope.formatAMPM = function (date) {
            var hours = date.getHours();
            var minutes = date.getMinutes();
            var ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            hours = hours ? hours : 12;
            minutes = minutes < 10 ? '0' + minutes : minutes;
            var hr = hours > 9 ? hours : '0' + hours;
            var strTime = 'T' + hr + ':' + minutes;
            return strTime;
        }

        //chcking criteria for all service
        $scope.criteriaSetting = function (lstRecord, serviceType) {
            var count = 1;
            angular.forEach(lstRecord, function (value, key) {
                if (value.Type == 'date' && value.Value != undefined) {
                    var dDate = new Date(value.Value);
                    value.Value = dDate;
                    //var today = $filter('date')(new Date(), 'yyyy-MM-dd HH:mm:ss Z');
                }
                if (value.Type == 'datetime' && value.Value != undefined) {
                    var dDate = new Date(value.Value);
                    var p = $scope.formatDate(dDate);
                    p += $scope.formatAMPM(dDate);
                    value.Value = p;
                    value.Type = 'datetime-local';
                }
                value.IsError = false;
                value.IsReference = false;
                value.Id = count++;
                if (value.Condition == null || value.Condition == "") {
                    value.Condition = 'AND';
                }
            })
             //IWS Service
            if (serviceType == 'IWS_Criteria') {
                $scope.iwsCriteriaArray = angular.copy(lstRecord);
            }
            //IWS Advanced Service
             if (serviceType == 'IWSAdvanced_Criteria') {
                $scope.iwsAdvancedAddressCriteriaArray  = angular.copy(lstRecord);
            } 
            //IWS Bankruptcy Info service
            if (serviceType == 'IWSBankruptcyInfo_Criteria') {
                $scope.iwsBankruptcyInfoCriteriaArray  = angular.copy(lstRecord);
            }
            if (serviceType == 'Vat_Criteria') {
                $scope.vatCriteriaArray = angular.copy(lstRecord);
            }
            if (serviceType == 'Credit_Criteria') {
                $scope.creditCriteriaArray = angular.copy(lstRecord);
            }
            if (serviceType == 'Toolkit_Criteria') {
                $scope.toolkitCriteriaArray = angular.copy(lstRecord);
            }
            if (serviceType == 'ToolkitQC_Criteria') {
              $scope.toolkitQCCriteriaArray = angular.copy(lstRecord);
            }
            if (serviceType == 'Account_Criteria') {
                $scope.accCriteriaArray = angular.copy(lstRecord)
            }
            if (serviceType == 'Contact_Criteria') {
                $scope.conCriteriaArray = angular.copy(lstRecord)
            } 
            if (serviceType == 'AccountKvk_Criteria') {
                $scope.accountKvkCriteriaArray = angular.copy(lstRecord)
            }
            if (serviceType == 'LeadKvk_Criteria') {
                $scope.leadKvkCriteriaArray = angular.copy(lstRecord)
            }
            if (serviceType == 'LeadGlobal_Criteria') {
                $scope.leadGlobalCriteriaArray  = angular.copy(lstRecord)
            }
            if (serviceType == 'AccountGDM_Criteria') {
                $scope.accountGDMCriteriaArray  = angular.copy(lstRecord)
            }
            
            if (serviceType == 'AccountGlobal_Criteria') {
                $scope.accountGlobalCriteriaArray  = angular.copy(lstRecord)
            }
            if (serviceType == 'AccountTradeCredit_Criteria') {
                $scope.accountTradeCreditCriteriaArray  = angular.copy(lstRecord)
            }
            if (serviceType == 'IWSStdAddInfo_Criteria') {
                $scope.iwsStdAddInfoCriteriaArray = angular.copy(lstRecord);
            }
            // IWS Paydex Info Service
            if(serviceType == 'IWSPaydexInfo_Criteria') {
                $scope.iwsPaydexInfoCriteriaArray = angular.copy(lstRecord);
            }
            if (serviceType == 'IWSRiskInfo_Criteria') {
                $scope.iwsRiskInfoCriteriaArray = angular.copy(lstRecord);
            }    
            if (serviceType == 'IWSBalanceSheet_Criteria') {
                $scope.iwsBalanceSheetCriteriaArray = angular.copy(lstRecord);
            }
            //IndueD Service
            if(serviceType == 'IndueDService_Criteria') {
                $scope.indueDserviceCriteriaArray = angular.copy(lstRecord);
            }
            //Risk Datablock Service
            if(serviceType == 'RiskDatablock_Criteria') {
                $scope.riskDatablockServiceCriteriaArray = angular.copy(lstRecord);
            }
            //Company Report Service
            if(serviceType == 'CompanyReport_Criteria') {
                $scope.companyReportServiceCriteriaArray = angular.copy(lstRecord);
            }
        }
        API_Connector.Engine.mappingFields(function (resultFieldMap, event) {
            if (resultFieldMap != null) {
                if (resultFieldMap.GlobalInputFields != null) {
                    angular.forEach(resultFieldMap.GlobalInputFields, function (rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Value};
                        $scope.leadGlobalMapInputFields.push(obj);
                    });
                }

                if (resultFieldMap.GlobalOutputFields != null) {
                    angular.forEach(resultFieldMap.GlobalOutputFields, function (rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Path};
                        $scope.leadGlobalMapOutputFields.push(obj);
                    });
                }
                
                if (resultFieldMap.OutputFields_IwsService != null) {
                    angular.forEach(resultFieldMap.OutputFields_IwsService, function (rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Path};
                        $scope.iwsServiceMapOutputFields.push(obj);
                    });
                }

                if(resultFieldMap.ResponseFields_IWSStdAddInfoService  != null){
                    angular.forEach(resultFieldMap.ResponseFields_IWSStdAddInfoService,function(record){
                        var obj = {'name': record.Name, value: record.Path};
                        $scope.iwsStdAddInfoServiceResopnseFields.push(obj);
                    });
                }
                //Start IWS Balance Sheet Service
                if(resultFieldMap.ResponseFields_IWSBalanceSheetService  != null){
                    angular.forEach(resultFieldMap.ResponseFields_IWSBalanceSheetService,function(record){
                        var obj = {'name': record.Name, value: record.Path};
                        $scope.iwsBalanceSheetResopnseFields.push(obj);
                    });
                }
                //End IWS Balance Sheet Service

                // Start IWS Advanced Address Information Service
                if (resultFieldMap.OutputFields_IwsAdvancedAddressService != null) {
                    angular.forEach(resultFieldMap.OutputFields_IwsAdvancedAddressService, function (rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Path};
                        $scope.iwsAdvancedAddressServiceMapOutputFields.push(obj);
                    });
                }
                
                // Start IWS Bankruptcy Information Service
                if (resultFieldMap.OutputFields_IwsBankruptcyInfoService != null) {
                    angular.forEach(resultFieldMap.OutputFields_IwsBankruptcyInfoService, function (rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Path};
                        $scope.iwsBankruptcyInfoServiceMapOutputFields.push(obj);
                    });
                } 
                // End IWS Bankruptcy Information Service

                // Start IWS Paydex Information Service
                if(resultFieldMap.ResponseFields_IWSPaydexInfoService != null){
                    angular.forEach(resultFieldMap.ResponseFields_IWSPaydexInfoService, function(record){
                        var obj = {'name': record.Name, value: record.Path};
                        $scope.iwsPaydexInfoServiceResopnseFields.push(obj);
                    });
                }    
                //End IWS Paydex Information Service

                //Start IWS Risk Information Service
                if(resultFieldMap.ResponseFields_IWSRiskInfoService != null) {
                    angular.forEach(resultFieldMap.ResponseFields_IWSRiskInfoService, function(rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Path};
                        $scope.iwsRiskInfoServiceResopnseFields.push(obj);
                    })
                }
                //End IWS Risk Information Service

                if (resultFieldMap.InputMapping_Fields_GDMService != null) {
                    angular.forEach(resultFieldMap.InputMapping_Fields_GDMService, function (rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Path};
                        $scope.gdmServiceInputMappingFields.push(obj);
                    });
                }
                if (resultFieldMap.OutputMapping_Fields_GDMService != null) {
                    angular.forEach(resultFieldMap.OutputMapping_Fields_GDMService, function (rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Path};
                        $scope.gdmServiceOutputMappingFields.push(obj);
                    });
                }
                if (resultFieldMap.TradeOutputFields != null) {
                    angular.forEach(resultFieldMap.TradeOutputFields, function (rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Path};
                        $scope.tradeCreditOutputOptionFields.push(obj);
                    });
                }
                
                if (resultFieldMap.Account != null) {
                    $scope.recordAccount = angular.copy(resultFieldMap.Account);
                    $scope.recordAccountTemp = angular.copy(resultFieldMap.Account);
                } else if (resultFieldMap.Account == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.recordAccount.push(obj);
                    $scope.recordAccountTemp.push(obj);
                }
                if (resultFieldMap.Contact != null) {
                    $scope.recordContact = angular.copy(resultFieldMap.Contact);
                    $scope.recordContactTemp = angular.copy(resultFieldMap.Contact);
                } else if (resultFieldMap.Contact == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.recordContact.push(obj);
                    $scope.recordContactTemp.push(obj);
                }
             
                if (resultFieldMap.Casekey_Account != null)
                    $scope.caseKeyRecord.Account = resultFieldMap.Casekey_Account[0];
                if (resultFieldMap.Casekey_Contact != null)
                    $scope.caseKeyRecord.Contact = resultFieldMap.Casekey_Contact[0];
                if (resultFieldMap.Casekey_AccountKvk != null)
                    $scope.caseKeyRecord.AccountKvk = resultFieldMap.Casekey_AccountKvk[0];
                if (resultFieldMap.Casekey_LeadKvk != null)
                    $scope.caseKeyRecord.LeadKvk = resultFieldMap.Casekey_LeadKvk[0];


                //for output field mapping
                if (resultFieldMap.Output_Account != null) {
                    $scope.output_Account = angular.copy(resultFieldMap.Output_Account);
                    $scope.output_AccountTemp = angular.copy(resultFieldMap.Output_Account);
                } else if (resultFieldMap.Output_Account == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_Account.push(obj);
                    $scope.output_AccountTemp.push(obj);
                }

                if (resultFieldMap.Output_Contact != null) {
                    $scope.output_Contact = angular.copy(resultFieldMap.Output_Contact);
                    $scope.output_ContactTemp = angular.copy(resultFieldMap.Output_Contact);
                } else if (resultFieldMap.Output_Contact == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_Contact.push(obj);
                    $scope.output_ContactTemp.push(obj);
                }
                //Lead Global Match Input
                if (resultFieldMap.Input_LeadGlobal != null) {
                    $scope.recordLeadGlobal = angular.copy(resultFieldMap.Input_LeadGlobal);
                    $scope.recordLeadGlobalTemp = angular.copy(resultFieldMap.Input_LeadGlobal);
                } else if (resultFieldMap.Input_LeadGlobal == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.recordLeadGlobal.push(obj);
                    $scope.recordLeadGlobalTemp.push(obj);
                }
                //Global Decision Maker
                if (resultFieldMap.Input_AccountGDM != null) {
                    var index = resultFieldMap.Input_AccountGDM.findIndex(function(item, i){
                        return item.value === 'dunsNumber';
                    });
                    // $scope.objDUNSValue = resultFieldMap.Input_AccountGDM[index];
                    // $scope.objGDMService.Duns = resultFieldMap.Input_AccountGDM[index].name;
                    resultFieldMap.Input_AccountGDM.splice(index,1);
                    $scope.input_GDMAccountService = angular.copy(resultFieldMap.Input_AccountGDM);
                    $scope.input_GDMAccountServiceTemp = angular.copy(resultFieldMap.Input_AccountGDM);
                } else if (resultFieldMap.Input_AccountGDM == null) {
                    var obj = { 'name': '', 'value': '' };
                    $scope.input_GDMAccountService.push(obj);
                    $scope.input_GDMAccountServiceTemp.push(obj);
                }
                if (resultFieldMap.Output_AccountGDM != null) {
                    $scope.output_GDMAccountService = angular.copy(resultFieldMap.Output_AccountGDM);
                    $scope.output_GDMAccountServiceTemp = angular.copy(resultFieldMap.Output_AccountGDM);
                } 
                //Account Trade Credit Input
                if (resultFieldMap.Input_AccountTradeCredit != null && resultFieldMap.Input_AccountTradeCredit.length > 0) {
                    $scope.objAccountTradeCredit.tradeUp =  resultFieldMap.Input_AccountTradeCredit[0].value;
                }

                console.log('Input_Setting_RiskDatablockService',resultFieldMap.Input_Setting_RiskDatablockService);
                //Risk Datablock Service Input
                if(resultFieldMap.Input_Setting_RiskDatablockService != null && resultFieldMap.Input_Setting_RiskDatablockService.length > 0) {
                    $scope.objRiskDatablockService.criteriaMapping = resultFieldMap.Input_Setting_RiskDatablockService[0];
                    if(resultFieldMap.Input_Setting_RiskDatablockService[1])
                        $scope.objRiskDatablockService.tradeUp = resultFieldMap.Input_Setting_RiskDatablockService[1].substring(1,resultFieldMap.Input_Setting_RiskDatablockService[1].length-1);
                    if(resultFieldMap.Input_Setting_RiskDatablockService[2])
                        $scope.objRiskDatablockService.customerReference = resultFieldMap.Input_Setting_RiskDatablockService[2].substring(1,resultFieldMap.Input_Setting_RiskDatablockService[2].length-1);
                    if(resultFieldMap.Input_Setting_RiskDatablockService[3])
                        $scope.objRiskDatablockService.orderReason = resultFieldMap.Input_Setting_RiskDatablockService[3].substring(1,resultFieldMap.Input_Setting_RiskDatablockService[3].length-1);
                }

                console.log('Input_Setting_CompanyReportService',resultFieldMap.Input_Setting_CompanyReportService);
                //Company Report Service Input
                if(resultFieldMap.Input_Setting_CompanyReportService != null && resultFieldMap.Input_Setting_CompanyReportService.length > 0) {
                    if(resultFieldMap.Input_Setting_CompanyReportService[0])
                        $scope.objCompanyReportService.customerReference = resultFieldMap.Input_Setting_CompanyReportService[0].substring(1,resultFieldMap.Input_Setting_CompanyReportService[0].length-1);
                    if(resultFieldMap.Input_Setting_CompanyReportService[1])
                        $scope.objCompanyReportService.tradeUp = resultFieldMap.Input_Setting_CompanyReportService[1].substring(1,resultFieldMap.Input_Setting_CompanyReportService[1].length-1);
                    if(resultFieldMap.Input_Setting_CompanyReportService[2])
                        $scope.objCompanyReportService.orderReason = resultFieldMap.Input_Setting_CompanyReportService[2].substring(1,resultFieldMap.Input_Setting_CompanyReportService[2].length-1);
                    if(resultFieldMap.Input_Setting_CompanyReportService[3])
                        $scope.objCompanyReportService.inLangage = resultFieldMap.Input_Setting_CompanyReportService[3];
                    if(resultFieldMap.Input_Setting_CompanyReportService[4])
                        $scope.objCompanyReportService.Product_ID = resultFieldMap.Input_Setting_CompanyReportService[4];
                }

                //Lead Global Match Output
                if (resultFieldMap.Output_LeadGlobal != null) {
                    $scope.output_LeadGlobal = angular.copy(resultFieldMap.Output_LeadGlobal);
                    $scope.output_LeadGlobalTemp = angular.copy(resultFieldMap.Output_LeadGlobal);
                } else if (resultFieldMap.Output_LeadGlobal === null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_LeadGlobal.push(obj);
                    $scope.output_LeadGlobalTemp.push(obj);
                }
                //Account Global Match Input
                if (resultFieldMap.Input_AccountGlobal != null) {
                    $scope.recordAccountGlobal = angular.copy(resultFieldMap.Input_AccountGlobal);
                    $scope.recordAccountGlobalTemp = angular.copy(resultFieldMap.Input_AccountGlobal);
                } else if (resultFieldMap.Input_AccountGlobal == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.recordAccountGlobal.push(obj);
                    $scope.recordAccountGlobalTemp.push(obj);
                }
                //Account Global Match Output
                if (resultFieldMap.Output_AccountGlobal != null) {
                    $scope.output_AccountGlobal = angular.copy(resultFieldMap.Output_AccountGlobal);
                    $scope.output_AccountGlobalTemp = angular.copy(resultFieldMap.Output_AccountGlobal);
                } else if (resultFieldMap.Output_LeadGlobal === null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_LeadGlobal.push(obj);
                    $scope.output_LeadGlobalTemp.push(obj);
                }
        
                // Account IWS Advanced Output 
                if (resultFieldMap.Output_AccountIWSAdvancedAddress != null) {
                    $scope.output_IWSAdvancedAddressAccountService = angular.copy(resultFieldMap.Output_AccountIWSAdvancedAddress);
                    $scope.output_IWSAdvancedAddressAccountServiceTemp = angular.copy(resultFieldMap.Output_AccountIWSAdvancedAddress);
                } else if (resultFieldMap.Output_AccountIWSAdvancedAddress == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_IWSAdvancedAddressAccountService.push(obj);
                    $scope.output_IWSAdvancedAddressAccountServiceTemp.push(obj);
                }
                
                // Account IWS Bankruptcy Output 
                if (resultFieldMap.Output_AccountIWSBankruptcyInfo != null) {
                    $scope.output_IWSBankruptcyInfoAccountService = angular.copy(resultFieldMap.Output_AccountIWSBankruptcyInfo);
                    $scope.output_IWSBankruptcyInfoAccountServiceTemp = angular.copy(resultFieldMap.Output_AccountIWSBankruptcyInfo);
                } else if (resultFieldMap.Output_AccountIWSBankruptcyInfo == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_IWSBankruptcyInfoAccountService.push(obj);
                    $scope.output_IWSBankruptcyInfoAccountServiceTemp.push(obj);
                }

                 // Account IWS Input 
                 if (resultFieldMap.Input_AccountIWS != null) {
                    $scope.input_IWSAccountService = angular.copy(resultFieldMap.Input_AccountIWS);
                    $scope.input_IWSAccountServiceTemp = angular.copy(resultFieldMap.Input_AccountIWS);
                } else if (resultFieldMap.Input_AccountIWS == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.input_IWSAccountService.push(obj);
                    $scope.input_IWSAccountServiceTemp.push(obj);
                }
                
                // Account IWS Output 
                 if (resultFieldMap.Output_AccountIWS != null) {
                    $scope.output_IWSAccountService = angular.copy(resultFieldMap.Output_AccountIWS);
                    $scope.output_IWSAccountServiceTemp = angular.copy(resultFieldMap.Output_AccountIWS);
                } else if (resultFieldMap.Output_AccountIWS == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_IWSAccountService.push(obj);
                    $scope.output_IWSAccountServiceTemp.push(obj);
                }

                //Account IWS Standred Address Information Service output fields
                if (resultFieldMap.OutputFields_AccIWSStdAddInfoService  != null) {
                    $scope.output_IWSStdAddInfoAccountService = angular.copy(resultFieldMap.OutputFields_AccIWSStdAddInfoService);
                    $scope.output_IWSStdAddInfoAccountServiceTemp = angular.copy(resultFieldMap.OutputFields_AccIWSStdAddInfoService);
                } else if (resultFieldMap.OutputFields_AccIWSStdAddInfoService  == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_IWSStdAddInfoAccountService.push(obj);
                    $scope.output_IWSStdAddInfoAccountServiceTemp.push(obj);
                }

                //Account IWS Standred Address Information Service Input fields
                if (resultFieldMap.InputFields_AccIWSStdAddInfoService  != null) {
                    $scope.input_IWSStdAddInfoAccountService = angular.copy(resultFieldMap.InputFields_AccIWSStdAddInfoService );
                    $scope.input_IWSStdAddInfoAccountServiceTemp = angular.copy(resultFieldMap.InputFields_AccIWSStdAddInfoService );
                } else if (resultFieldMap.InputFields_AccIWSStdAddInfoService  == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.input_IWSStdAddInfoAccountService.push(obj);
                    $scope.input_IWSStdAddInfoAccountServiceTemp.push(obj);
                }

                //Account IWS Paydex Information Service output Fields
                if(resultFieldMap.OutputFields_AccIWSPaydexInfoService != null) {
                    $scope.output_IWSPaydexInfoAccountService = angular.copy(resultFieldMap.OutputFields_AccIWSPaydexInfoService);
                    $scope.output_IWSPaydexInfoAccountServiceTemp = angular.copy(resultFieldMap.OutputFields_AccIWSPaydexInfoService);
                } else if (resultFieldMap.OutputFields_AccIWSPaydexInfoService == null) {
                    var obj = { 'name': '', value: ''};
                    $scope.output_IWSPaydexInfoAccountService.push(obj);
                    $scope.output_IWSPaydexInfoAccountServiceTemp.push(obj);
                }

                //Account IWS Paydex Information Service input Fields
                if(resultFieldMap.InputFields_AccIWSPaydexInfoService != null) {
                     $scope.input_IWSPaydexInfoAccountService = angular.copy(resultFieldMap.InputFields_AccIWSPaydexInfoService );
                    $scope.input_IWSPaydexInfoAccountServiceTemp = angular.copy(resultFieldMap.InputFields_AccIWSPaydexInfoService );
                } else if(resultFieldMap.InputFields_AccIWSPaydexInfoService == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.input_IWSPaydexInfoAccountService.push(obj);
                    $scope.input_IWSPaydexInfoAccountServiceTemp.push(obj);
                }
                //Account IWS Risk Information Service output fields
                if(resultFieldMap.OutputFields_AccIWSRiskInfoService != null) {
                    $scope.output_IWSRiskInfoAccountService = angular.copy(resultFieldMap.OutputFields_AccIWSRiskInfoService);
                    $scope.output_IWSRiskInfoAccountServiceTemp = angular.copy(resultFieldMap.OutputFields_AccIWSRiskInfoService);
                } else if (resultFieldMap.OutputFields_AccIWSRiskInfoService == null) {
                    var obj = { 'name': '', value: ''};
                    $scope.output_IWSRiskInfoAccountService.push(obj);
                    $scope.output_IWSRiskInfoAccountServiceTemp.push(obj);
                }

                //Account IWS Risk Information Service Input fields
                if(resultFieldMap.InputFields_AccIWSRiskInfoService != null) {
                    $scope.input_IWSRiskInfoAccountService = angular.copy(resultFieldMap.InputFields_AccIWSRiskInfoService);
                    $scope.input_IWSRiskInfoAccountServiceTemp = angular.copy(resultFieldMap.InputFields_AccIWSRiskInfoService);
                } else if (resultFieldMap.InputFields_AccIWSRiskInfoService == null) {
                    var obj = { 'name': '', value: ''};
                    $scope.input_IWSRiskInfoAccountService.push(obj);
                    $scope.input_IWSRiskInfoAccountServiceTemp.push(obj);
                }

                //Risk Datablock Service output fields
                if(resultFieldMap.OutputFields_RiskDatablockService != null) {
                    $scope.output_RiskDatablockAccountService = angular.copy(resultFieldMap.OutputFields_RiskDatablockService);
                    $scope.output_RiskDatablockAccountServiceTemp = angular.copy(resultFieldMap.OutputFields_RiskDatablockService);
                } else if (resultFieldMap.OutputFields_RiskDatablockService == null) {
                    var obj = { 'name': '', value: ''};
                    $scope.output_RiskDatablockAccountService.push(obj);
                    $scope.output_RiskDatablockAccountServiceTemp.push(obj);
                }

                //Risk Datablock Service Input fields
                if(resultFieldMap.InputFields_RiskDatablockService != null) {
                    $scope.input_RiskDatablockAccountService = angular.copy(resultFieldMap.InputFields_RiskDatablockService);
                    $scope.input_RiskDatablockAccountServiceTemp = angular.copy(resultFieldMap.InputFields_RiskDatablockService);
                } else if (resultFieldMap.InputFields_RiskDatablockService == null) {
                    var obj = { 'name': '', value: ''};
                    $scope.input_RiskDatablockAccountService.push(obj);
                    $scope.input_RiskDatablockAccountServiceTemp.push(obj);
                }

                //Risk Datablock Service Response Field

                if(resultFieldMap.ResponseField_EssentialResponseFields != null) {
                    $scope.essentialResponseFields = angular.copy(resultFieldMap.ResponseField_EssentialResponseFields);
                }
                if(resultFieldMap.ResponseField_DetailedResponseFields != null) {
                    $scope.detailedResponseFields = angular.copy(resultFieldMap.ResponseField_DetailedResponseFields);
                }
                if(resultFieldMap.ResponseField_CompleteResponseFields != null) {
                    $scope.completeResponseFields = angular.copy(resultFieldMap.ResponseField_CompleteResponseFields);
                }
                if(resultFieldMap.ResponseField_CustomResponseFields != null) {
                    $scope.customResponseFields = angular.copy(resultFieldMap.ResponseField_CustomResponseFields);
                }

                $scope.assignmentOfResponseField();
                //IndueD Services
                if(resultFieldMap.InputFields_IndueDPorfolioService != null) {
                    $scope.input_IndueDService = angular.copy(resultFieldMap.InputFields_IndueDPorfolioService);
                    $scope.input_IndueDServiceTemp = angular.copy(resultFieldMap.InputFields_IndueDPorfolioService);
                } else if (resultFieldMap.InputFields_IndueDPorfolioService == null) {
                    var obj = { 'name': '', value: ''};
                    $scope.input_IndueDService.push(obj);
                    $scope.input_IndueDServiceTemp.push(obj);
                }
                
                if(resultFieldMap.OutputFields_IndueDueDiligenceDuedidService != null) {
                    $scope.output_IndueDService = angular.copy(resultFieldMap.OutputFields_IndueDueDiligenceDuedidService);
                    $scope.output_IndueDServiceTemp= angular.copy(resultFieldMap.OutputFields_IndueDueDiligenceDuedidService);
                } else if (resultFieldMap.OutputFields_IndueDueDiligenceDuedidService == null) {
                     var obj = { 'name': '', value: ''};
                    $scope.output_IndueDService.push(obj);
                    $scope.output_IndueDServiceTemp.push(obj);
                }

                if(resultFieldMap.ResponseFields_IndueDueDiligenceDuedidService != null) {
                    angular.forEach(resultFieldMap.ResponseFields_IndueDueDiligenceDuedidService, function(rec, key) {
                        var obj = { 'name': rec.Name, value: rec.Value};
                        $scope.induedServiceResopnseFields.push(obj);
                    })
                }
            
                //Account Balance Sheet Service output fields
                if (resultFieldMap.OutputFields_AccIWSBalanceSheetService != null) {
                    $scope.output_IWSBalanceSheetAccountService = angular.copy(resultFieldMap.OutputFields_AccIWSBalanceSheetService);
                    $scope.output_IWSBalanceSheetAccountServiceTemp = angular.copy(resultFieldMap.OutputFields_AccIWSBalanceSheetService);
                } else if (resultFieldMap.OutputFields_AccIWSBalanceSheetService  == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_IWSBalanceSheetAccountService.push(obj);
                    $scope.output_IWSBalanceSheetAccountServiceTemp.push(obj);
                }

                //Account Balance Sheet Service output fields
                if (resultFieldMap.InputFields_AccIWSBalanceSheetService != null) {
                    $scope.input_IWSBalanceSheetAccountService = angular.copy(resultFieldMap.InputFields_AccIWSBalanceSheetService);
                    $scope.input_IWSBalanceSheetAccountServiceTemp = angular.copy(resultFieldMap.InputFields_AccIWSBalanceSheetService);
                } else if (resultFieldMap.InputFields_AccIWSBalanceSheetService  == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.input_IWSBalanceSheetAccountService.push(obj);
                    $scope.input_IWSBalanceSheetAccountServiceTemp.push(obj);
                }



                if (resultFieldMap.Output_AccountTradeCredit != null) {
                    $scope.output_AccountTradeCredit = angular.copy(resultFieldMap.Output_AccountTradeCredit);
                    $scope.output_AccountTradeCreditTemp = angular.copy(resultFieldMap.Output_AccountTradeCredit);
                }
                //toolkit Enterprize Managment
                if (resultFieldMap.Output_Toolkit != null) {
                    $scope.output_toolkit = angular.copy(resultFieldMap.Output_Toolkit);
                    $scope.output_ToolkitTemp = angular.copy(resultFieldMap.Output_Toolkit);
                }
                else if (resultFieldMap.Output_Toolkit == null) {
                    var obj = { 'name': '', value: '' };
                    $scope.output_toolkit.push(obj);
                    $scope.output_ToolkitTemp.push(obj);
                }
                if (resultFieldMap.OutputFlds_Toolkit != null) {

                    $scope.outputFldsToolkit = angular.copy(resultFieldMap.OutputFlds_Toolkit);
                }
               //toolkit Quick Check
                if (resultFieldMap.Output_ToolkitQC != null) {
                  $scope.output_toolkitQC = angular.copy(resultFieldMap.Output_ToolkitQC);
                  $scope.output_ToolkitQCTemp = angular.copy(resultFieldMap.Output_ToolkitQC);
                }
                else if (resultFieldMap.Output_ToolkitQC == null) {
                  var obj = { 'name': '', value: '' };
                  $scope.output_toolkitQC.push(obj);
                  $scope.output_ToolkitQCTemp.push(obj);
                }
                if (resultFieldMap.OutputFlds_ToolkitQC != null) {

                  $scope.outputFldsToolkitQC = angular.copy(resultFieldMap.OutputFlds_ToolkitQC);
                }
                //account dutch chamber 
                if (resultFieldMap.Mapping_AccountKvk != null){
                    $scope.Mapping_AccountKvk = angular.copy(resultFieldMap.Mapping_AccountKvk);
                    $scope.Mapping_AccountKvkTemp = angular.copy(resultFieldMap.Mapping_AccountKvk);
                }
                //Output Field
                if (resultFieldMap.Output_AccountKvk != null) {
                    $scope.Output_AccountKvk = angular.copy(resultFieldMap.Output_AccountKvk);
                    $scope.Output_AccountKvkTemp = angular.copy(resultFieldMap.Output_AccountKvk);
                }
                //lead dutch chamber
                if (resultFieldMap.Mapping_LeadKvk != null) {
                    $scope.Mapping_LeadKvk = angular.copy(resultFieldMap.Mapping_LeadKvk);
                    $scope.Mapping_LeadKvkTemp = angular.copy(resultFieldMap.Mapping_LeadKvk);
                }
                //Output field lead
                if (resultFieldMap.Output_LeadKvk != null) {
                    $scope.Output_LeadKvk = angular.copy(resultFieldMap.Output_LeadKvk);
                    $scope.Output_LeadKvkTemp = angular.copy(resultFieldMap.Output_LeadKvk);
                }

                //vat criteria setting
                if (resultFieldMap.vatValues != null) {
                    $scope.criteriaSetting(resultFieldMap.vatValues, 'Vat_Criteria');
                }

                //credit criteria setting
                if (resultFieldMap.creditValues != null) {
                    $scope.criteriaSetting(resultFieldMap.creditValues, 'Credit_Criteria');

                }
                //toolkit management
                if (resultFieldMap.toolkitValues != null) {
                    $scope.criteriaSetting(resultFieldMap.toolkitValues, 'Toolkit_Criteria');
                }
                //toolkit Quick Check
                if (resultFieldMap.toolkitValues != null) {
                  $scope.criteriaSetting(resultFieldMap.toolkitQCValues, 'ToolkitQC_Criteria');
                }

                //IWS StandardAddress Information Service
                if (resultFieldMap.iwsStdAddInfoValues != null) {
                    $scope.criteriaSetting(resultFieldMap.iwsStdAddInfoValues, 'IWSStdAddInfo_Criteria');
                }

                //IWS Paydex Information Service
                if(resultFieldMap.iwsPaydexInfoValues != null){
                    $scope.criteriaSetting(resultFieldMap.iwsPaydexInfoValues, 'IWSPaydexInfo_Criteria');
                }

                if(resultFieldMap.iwsRiskInfoValues != null) {
                    $scope.criteriaSetting(resultFieldMap.iwsRiskInfoValues, 'IWSRiskInfo_Criteria');
                }    

                //IWS Balance Sheet Information Service
                if (resultFieldMap.iwsBalanceSheetValues != null) {
                    $scope.criteriaSetting(resultFieldMap.iwsBalanceSheetValues, 'IWSBalanceSheet_Criteria');
                }

                //IWS Service
                if (resultFieldMap.iwsServiceValues != null) {
                    $scope.criteriaSetting(resultFieldMap.iwsServiceValues, 'IWS_Criteria');
                }
                
                //IWS Advanced Address Service
                if (resultFieldMap.iwsAdvancedAddressServiceValues != null) {
                    $scope.criteriaSetting(resultFieldMap.iwsAdvancedAddressServiceValues, 'IWSAdvanced_Criteria');
                }
                
                //IndueD Service
                if (resultFieldMap.indueDValues != null) {
                    $scope.criteriaSetting(resultFieldMap.indueDValues, 'IndueDService_Criteria');
                }

                //Risk Datablock
                if(resultFieldMap.riskDatablockValues != null){
                    $scope.criteriaSetting(resultFieldMap.riskDatablockValues,'RiskDatablock_Criteria');
                }

                //Company Report
                if(resultFieldMap.companyReportValues != null){
                    $scope.criteriaSetting(resultFieldMap.companyReportValues,'CompanyReport_Criteria');
                }

                //IWS Bankruptcy Info Service
                 if (resultFieldMap.iwsBankruptcyInfoServiceValues != null) {
                    $scope.criteriaSetting(resultFieldMap.iwsBankruptcyInfoServiceValues, 'IWSBankruptcyInfo_Criteria');
                }

                // account criteria setting
                if (resultFieldMap.accountValues != null) {
                    $scope.criteriaSetting(resultFieldMap.accountValues, 'Account_Criteria');
                }
                // contact criteria setting
                if (resultFieldMap.contactValues != null) {
                    $scope.criteriaSetting(resultFieldMap.contactValues, 'Contact_Criteria');
                }
                //account kvk setting
                if (resultFieldMap.accountKvkValues != null) {
                    $scope.criteriaSetting(resultFieldMap.accountKvkValues, 'AccountKvk_Criteria');
                }
                //lead kvk setting
                if (resultFieldMap.leadKvkValues != null) {
                    $scope.criteriaSetting(resultFieldMap.leadKvkValues, 'LeadKvk_Criteria');
                }
                if (resultFieldMap.leadGlobalMatchValues != null) {
                    $scope.criteriaSetting(resultFieldMap.leadGlobalMatchValues, 'LeadGlobal_Criteria');
                }
                if (resultFieldMap.accountGDMValues != null) {
                    $scope.criteriaSetting(resultFieldMap.accountGDMValues, 'AccountGDM_Criteria');
                }
                if (resultFieldMap.accountGlobalMatchValues != null) {
                    $scope.criteriaSetting(resultFieldMap.accountGlobalMatchValues, 'AccountGlobal_Criteria');
                }
                if (resultFieldMap.accountTradeCreditValues != null) {
                    $scope.criteriaSetting(resultFieldMap.accountTradeCreditValues, 'AccountTradeCredit_Criteria');
                }

                if (resultFieldMap.accFilter != null) {
                    $scope.accFilterlogic.Name = resultFieldMap.accFilter[0] != null ? resultFieldMap.accFilter[0] : '';
                }
                if (resultFieldMap.conFilter != null) {
                    $scope.conFilterlogic.Name = resultFieldMap.conFilter[0] != null ? resultFieldMap.conFilter[0] : '';
                }
                if (resultFieldMap.creditFilter != null) {
                    $scope.creditFilterlogic.Name = resultFieldMap.creditFilter[0] != null ? resultFieldMap.creditFilter[0] : '';
                }
                if (resultFieldMap.vatFilter != null) {
                    $scope.vatFilterlogic.Name = resultFieldMap.vatFilter[0] != null ? resultFieldMap.vatFilter[0] : '';
                }
                if (resultFieldMap.toolkitFilter != null) {
                    $scope.toolkitFilterlogic.Name = resultFieldMap.toolkitFilter[0] != null ? resultFieldMap.toolkitFilter[0] : '';
                }
                if (resultFieldMap.toolkitQCFilter != null) {
                  $scope.toolkitQCFilterlogic.Name = resultFieldMap.toolkitQCFilter[0] != null ? resultFieldMap.toolkitQCFilter[0] : '';
                }
                if (resultFieldMap.IWSFilter != null) {
                    $scope.IWSFilterlogic.Name = resultFieldMap.IWSFilter[0] != null ? resultFieldMap.IWSFilter[0] : '';
                }
                if (resultFieldMap.IWSAdvancedAddressFilter != null) {
                    $scope.IWSAdvancedFilterlogic.Name = resultFieldMap.IWSAdvancedAddressFilter[0] != null ? resultFieldMap.IWSAdvancedAddressFilter[0] : '';
                }
                if (resultFieldMap.IWSBankruptcyInfoFilter != null) {
                    $scope.IWSBankruptcyInfoFilterlogic.Name = resultFieldMap.IWSBankruptcyInfoFilter[0] != null ? resultFieldMap.IWSBankruptcyInfoFilter[0] : '';
                }
                if (resultFieldMap.accountKvkFilter != null) {
                    $scope.accountKvkFilterlogic.Name = resultFieldMap.accountKvkFilter[0] != null ? resultFieldMap.accountKvkFilter[0] : '';
                } 
                if (resultFieldMap.leadKvkFilter != null) {
                    $scope.leadKvkFilterlogic.Name = resultFieldMap.leadKvkFilter[0] != null ? resultFieldMap.leadKvkFilter[0] : '';
                }
                if (resultFieldMap.leadGlobalMatchFilter != null) {
                    $scope.leadGlobalFilterlogic.Name = resultFieldMap.leadGlobalMatchFilter[0] != null ? resultFieldMap.leadGlobalMatchFilter[0] : '';
                }
                if (resultFieldMap.accountGDMFilter != null) {
                    $scope.accountGDMFilterlogic.Name = resultFieldMap.accountGDMFilter[0] != null ? resultFieldMap.accountGDMFilter[0] : '';
                }
                if (resultFieldMap.accountGlobalMatchFilter != null) {
                    $scope.accountGlobalFilterlogic.Name = resultFieldMap.accountGlobalMatchFilter[0] != null ? resultFieldMap.accountGlobalMatchFilter[0] : '';
                }
                if (resultFieldMap.accountTradeCreditFilter != null) {
                    $scope.accountTradeCreditFilterlogic.Name = resultFieldMap.accountTradeCreditFilter[0] != null ? resultFieldMap.accountTradeCreditFilter[0] : '';
                }
                if (resultFieldMap.iwsStdAddInfoFilter != null) {
                    $scope.iwsStdAddInfoFilterlogic.Name = resultFieldMap.iwsStdAddInfoFilter[0] != null ? resultFieldMap.iwsStdAddInfoFilter[0] : '';
                }
                if (resultFieldMap.iwsRiskInfoFilter != null) {
                    $scope.iwsRiskInfoFilterLogic.Name = resultFieldMap.iwsRiskInfoFilter[0] != null ? resultFieldMap.iwsRiskInfoFilter[0] : '';
                }
                //IWS Paydex Info Service
                if(resultFieldMap.iwsPaydexInfoFilter != null) {
                    $scope.iwsPaydexInfoFilterlogic.Name = resultFieldMap.iwsPaydexInfoFilter[0] != null ? resultFieldMap.iwsPaydexInfoFilter[0] : '';
                }
                if (resultFieldMap.iwsBalanceSheetFilter != null) {
                    $scope.iwsBalanceSheetFilterlogic.Name = resultFieldMap.iwsBalanceSheetFilter[0] != null ? resultFieldMap.iwsBalanceSheetFilter[0] : '';
                }
                //IndueD Service 
                if (resultFieldMap.indueDFilter != null) {
                    $scope.indueDServiceFilterlogic.Name = resultFieldMap.indueDFilter[0] != null ? resultFieldMap.indueDFilter[0] : '';
                }
                //Risk Datablock Service
                if (resultFieldMap.riskDatablockFilter != null) {
                    $scope.riskDatablockServiceFilterlogic.Name = resultFieldMap.riskDatablockFilter[0] != null ? resultFieldMap.riskDatablockFilter[0] : '';
                }
                if (resultFieldMap.companyReportFilter != null) {
                    $scope.companyReportServiceFilterlogic.Name = resultFieldMap.companyReportFilter[0] != null ? resultFieldMap.companyReportFilter[0] : '';
                }
            }

        }, { escape: false })

        //Assign value to output field mapping for Risk Datablock Service
        $scope.assignmentOfResponseField = function(criteriaMapping = null) {

            if(criteriaMapping != null) {
                $scope.objRiskDatablockService.criteriaMapping = criteriaMapping;
            }
            console.log('output mapping:',$scope.output_RiskDatablockAccountService);
                //Risk Datablock Service Response Field
                if($scope.objRiskDatablockService.criteriaMapping == 'essential')
                {
                    if($scope.essentialResponseFields.length > 0) {
                        $scope.riskDatablockServiceResponseFields = [];
                        if(!$scope.objRiskDatablockService.isOnlyRecommended) {
                            angular.forEach($scope.essentialResponseFields, function(rec, key) {
                                var obj = { 'name': rec.Name, value: rec.Path};
                                $scope.riskDatablockServiceResponseFields.push(obj);
                            })
                        }
                        else {
                            angular.forEach($scope.essentialResponseFields, function(rec, key) {
                                if(rec.isRequired == 'Yes')
                                {
                                    var obj = { 'name': rec.Name, value: rec.Path};
                                    $scope.riskDatablockServiceResponseFields.push(obj);
                                }
                            })
                        }
                    }
                }

                if($scope.objRiskDatablockService.criteriaMapping == 'detailed')
                {
                    if($scope.detailedResponseFields.length > 0) {
                        $scope.riskDatablockServiceResponseFields = [];
                        if(!$scope.objRiskDatablockService.isOnlyRecommended) {
                            angular.forEach($scope.detailedResponseFields, function(rec, key) {
                                var obj = { 'name': rec.Name, value: rec.Path};
                                $scope.riskDatablockServiceResponseFields.push(obj);
                            })
                        }
                        else {
                            angular.forEach($scope.detailedResponseFields, function(rec, key) {
                                if(rec.isRequired == 'Yes')
                                {
                                    var obj = { 'name': rec.Name, value: rec.Path};
                                    $scope.riskDatablockServiceResponseFields.push(obj);
                                }
                            })
                        }
                    }
                }

                if($scope.objRiskDatablockService.criteriaMapping == 'complete')
                {
                    if($scope.completeResponseFields.length > 0) {
                        $scope.riskDatablockServiceResponseFields = [];
                        if(!$scope.objRiskDatablockService.isOnlyRecommended) {
                            angular.forEach($scope.completeResponseFields, function(rec, key) {
                                var obj = { 'name': rec.Name, value: rec.Path};
                                $scope.riskDatablockServiceResponseFields.push(obj);
                            })
                        }
                        else {
                            angular.forEach($scope.completeResponseFields, function(rec, key) {
                                if(rec.isRequired == 'Yes')
                                {
                                    var obj = { 'name': rec.Name, value: rec.Path};
                                    $scope.riskDatablockServiceResponseFields.push(obj);
                                }
                            })
                        }
                    }
                }

                if($scope.objRiskDatablockService.criteriaMapping == 'custom')
                {
                    if($scope.customResponseFields.length > 0) {
                        $scope.riskDatablockServiceResponseFields = [];
                        if(!$scope.objRiskDatablockService.isOnlyRecommended) {
                            angular.forEach($scope.customResponseFields, function(rec, key) {
                                var obj = { 'name': rec.Name, value: rec.Path};
                                $scope.riskDatablockServiceResponseFields.push(obj);
                            })
                        }
                        else {
                            angular.forEach($scope.customResponseFields, function(rec, key) {
                                if(rec.isRequired == 'Yes')
                                {
                                    var obj = { 'name': rec.Name, value: rec.Path};
                                    $scope.riskDatablockServiceResponseFields.push(obj);
                                }
                            })
                        }
                    }
                }

                if($scope.riskDatablockServiceResponseFields.length > 0 && $scope.output_RiskDatablockAccountService.length > 0 && $scope.objRiskDatablockService.isOnlyRecommended == true) {
                    angular.forEach($scope.output_RiskDatablockAccountService, function(record1, key1) {
                        angular.forEach($scope.riskDatablockServiceResponseFields, function(record2, key2) {
                            if (record1.value != record2.value) {
                                // record1.value = '--None--';
                                console.log('value',record1.value);
                            }
                        });
                    });
                }
        }
        API_Connector.Engine.leadFields(function (resultleadflds, event) {
            if (resultleadflds != null) {                
                $scope.contactFields.push({ 'Name': '--None--' });
                angular.forEach(resultleadflds.Contact, function (value, key) {
                    var obj = { 'Name': value };
                    $scope.contactFields.push(obj);
                });

                //account output field
                $scope.accOutPutFields.push({ 'Name': '--None--' });
                angular.forEach(resultleadflds.AccountOutPutField, function (value, key) {
                    var obj = { 'Name': value };
                    $scope.accOutPutFields.push(obj);
                });

                //contact output field
                $scope.conOutPutFields.push({ 'Name': '--None--' });
                angular.forEach(resultleadflds.ContactOutPutField, function (value, key) {
                    var obj = { 'Name': value };
                    $scope.conOutPutFields.push(obj);
                });

                $scope.leadFieldsFlag = true;
                $scope.$apply();
            }
        }, { escape: true });
        
        API_Connector.APIConectorResult.getAPIConectorResult(function (result, event)
        {
          if (result != null) {
            //------------------------Input fields mapping-----------------------------------
            $scope.inputLeadFields = [];
            for (var i = 0; i < result.lstLeadFields.length; i++) 
              $scope.inputLeadFields.push({ 'Name': result.lstLeadFields[i] });
            $scope.inputAccountFields = [];
            for (var i = 0; i < result.lstAccountFields.length; i++)
              $scope.inputAccountFields.push({ 'Name': result.lstAccountFields[i], 'value': '' });
            // if( $scope.objDUNSValue.name == '--None--' ) {
            //     $scope.objDUNSValue.name = $scope.inputAccountFields[0].Name;
            // }
            if( $scope.objGDMService.Duns == '--None--' ) {
                $scope.objGDMService.duns = $scope.inputAccountFields[0].Name;
            }
            //------------------------Output fields mapping----------------------------------
            $scope.accountFieldsDataTypeList = [];
            angular.forEach(result.mapAccountFieldType, function (DataTypeList, DataTypeName)
            {
              $scope.accountFieldsDataTypeList.push(DataTypeName);
              for(var i = 0; i < DataTypeList.length; i++ )
              {
                $scope.accountFields.push({ 'Name': DataTypeList[i], 'DataType': DataTypeName });
                $scope.inputAccountFieldsOnWizard.push({ 'Name': DataTypeList[i], 'value': '' });
                if (DataTypeList[i] == $scope.vatRecord.Status)
                  $scope.vatRecord.StatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.vatRecord.Date)
                  $scope.vatRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.vatRecord.Identifier)
                  $scope.vatRecord.IdentifierDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objToolkitEnterprise.ToolkitStatus)
                  $scope.objToolkitEnterprise.ToolkitStatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objToolkitEnterprise.ToolkitDate)
                  $scope.objToolkitEnterprise.ToolkitDateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objToolkitQuickCheck.ToolkitStatus)
                  $scope.objToolkitQuickCheck.ToolkitStatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objToolkitQuickCheck.ToolkitDate)
                  $scope.objToolkitQuickCheck.ToolkitDateDataType = DataTypeName;
                
                //IWS Service
                if (DataTypeList[i] == $scope.objIwsService.IwsServiceStatus)
                  $scope.objIwsService.IwsServiceStatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objIwsService.IwsServiceDate)
                  $scope.objIwsService.IwsServiceDateDataType = DataTypeName;

                //Start IWS Standrad Address Information Service  
                if (DataTypeList[i] == $scope.objIWSStdAddInfoService.IwsServiceStatus)
                    $scope.objIWSStdAddInfoService.IwsServiceStatusDataType = DataTypeName
                if (DataTypeList[i] == $scope.objIWSStdAddInfoService.IwsServiceDate)
                    $scope.objIWSStdAddInfoService.IwsServiceDateDataType = DataTypeName
                //End IWS Standrad Address Information Service

                //Start IWS Balance Sheet Service  
                if (DataTypeList[i] == $scope.objIWSBalanceSheetService.IwsServiceStatus)
                    $scope.objIWSBalanceSheetService.IwsServiceStatusDataType = DataTypeName
                if (DataTypeList[i] == $scope.objIWSBalanceSheetService.IwsServiceDate)
                    $scope.objIWSBalanceSheetService.IwsServiceDateDataType = DataTypeName
                //End IWS Balance Sheet Service

                // Start IWS Advanced Address Information Service
                if (DataTypeList[i] == $scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceStatus)
                  $scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceStatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceDate)
                  $scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceDateDataType = DataTypeName;
                // End IWS Advanced Address Information Service

                // Start IWS Bankruptcy Information Service
                if (DataTypeList[i] == $scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceStatus)
                  $scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceStatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceDate)
                 $scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceDateDataType = DataTypeName;
                // End IWS Bankruptcy Information Service

                // Start IWS Paydex Info Service 
                if(DataTypeList[i] == $scope.objIWSPaydexInfoService.IwsServiceStatus)
                    $scope.objIWSPaydexInfoService.IwsServiceStatusDataType = DataTypeName
                if(DataTypeList[i] == $scope.objIWSPaydexInfoService.IwsServiceDate)
                    $scope.objIWSPaydexInfoService.IwsServiceDateDataType = DataTypeName
                //End IWS Paydex Info Service      
                //Start IWS Risk Information Service
                if(DataTypeList[i] == $scope.objIWSRiskInfoService.IwsServiceStatus)
                    $scope.objIWSRiskInfoService.IwsServiceStatusDataType = DataTypeName
                if(DataTypeList[i] == $scope.objIWSRiskInfoService.IwsServiceDate) 
                    $scope.objIWSRiskInfoService.IwsServiceDateDataType = DataTypeName
                // End IWS Risk Information Service

                //Risk Datablock Service
                if(DataTypeList[i] == $scope.objRiskDatablockService.riskDatablockServiceStatus)
                    $scope.objRiskDatablockService.riskDatablockServiceStatusDataType = DataTypeName
                if(DataTypeList[i] == $scope.objRiskDatablockService.riskDatablockServiceDate)
                    $scope.objRiskDatablockService.riskDatablockServiceDateDataType = DataTypeName
                //End Risk Datablock Service  
                
                //Company Report Service
                if(DataTypeList[i] == $scope.objCompanyReportService.companyReportServiceStatus)
                    $scope.objCompanyReportService.companyReportServiceStatusDataType = DataTypeName
                if(DataTypeList[i] == $scope.objCompanyReportService.companyReportServiceDate)
                    $scope.objCompanyReportService.companyReportServiceDateDataType = DataTypeName
                //End Company Report Service  

                //Start IndueD service
                if(DataTypeList[i] == $scope.objInduedService.DueDiligenceServiceFpmDate) 
                    $scope.objInduedService.InduedSServiceDateDataType = DataTypeName
                if(DataTypeList[i] == $scope.objInduedService.DueDiligenceId)
                    $scope.objInduedService.InduedSServiceIdDataType = DataTypeName
                if(DataTypeList[i] == $scope.objInduedService.ReportIdDate)
                    $scope.objInduedService.InduedSServiceReportDateDataType = DataTypeName
                if(DataTypeList[i] == $scope.objInduedService.ReportDate)
                    $scope.objInduedService.InduedSServiceReportServiceDateDataType = DataTypeName    
                if(DataTypeList[i] == $scope.objInduedService.ReportId)
                    $scope.objInduedService.InduedSServiceReportIdDataType = DataTypeName
                if(DataTypeList[i] == $scope.objInduedService.ReportUrl)
                    $scope.objInduedService.InduedSServiceReportUrlDataType = DataTypeName
                if(DataTypeList[i] == $scope.objInduedService.DueDiligenceStatus)
                    $scope.objInduedService.InduedSServiceDueDiligenceStatusDataType = DataTypeName
                if(DataTypeList[i] == $scope.objInduedService.DueDiligenceDate) 
                    $scope.objInduedService.InduedSServiceDueDiligenceDateDataType = DataTypeName
                if(DataTypeList[i] == $scope.objInduedService.DueDiligenceDuedidServiceStatus)
                    $scope.objInduedService.InduedSServiceDuedidStatusDataType = DataTypeName    
                if(DataTypeList[i] == $scope.objInduedService.ReportServiceStatus)
                    $scope.objInduedService.InduedSServiceReportServiceStatusDataType = DataTypeName
                if(DataTypeList[i] == $scope.objInduedService.ReportIdServiceStatus)
                    $scope.objInduedService.InduedSServiceReportIdServiceStatusDataType = DataTypeName        

                if (DataTypeList[i] == $scope.creditRecord.Status)
                  $scope.creditRecord.StatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.creditRecord.Date)
                  $scope.creditRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.creditRecord.Value)
                  $scope.creditRecord.ValueDataType = DataTypeName;
                if (DataTypeList[i] == $scope.accKvkRecord.Status)
                  $scope.accKvkRecord.StatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.accKvkRecord.Date)
                  $scope.accKvkRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.accountGlobalOutRecord.Date)
                  $scope.accountGlobalOutRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.accountGlobalOutRecord.Status)
                  $scope.accountGlobalOutRecord.StatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.accountTradeCreditDateStatusRecord.Date)
                  $scope.accountTradeCreditDateStatusRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.accountTradeCreditDateStatusRecord.Status)
                  $scope.accountTradeCreditDateStatusRecord.StatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objGDMService.GDMServiceStatus)
                  $scope.objGDMService.StatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.objGDMService.GDMServiceDate)
                  $scope.objGDMService.DateDataType = DataTypeName;
              }
            });
             
            $scope.leadFieldsDataTypeList = [];
            angular.forEach(result.mapLeadFieldType, function (DataTypeList, DataTypeName)
            {
              $scope.leadFieldsDataTypeList.push(DataTypeName);
              for (var i = 0; i < DataTypeList.length; i++) {
                $scope.leadFields.push({ 'Name': DataTypeList[i], 'DataType': DataTypeName });
                $scope.inputLeadFieldsOnWizard.push({ 'Name': DataTypeList[i], 'value': '' });
                if (DataTypeList[i] == $scope.accRecord.Status)
                  $scope.accRecord.StatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.accRecord.Date)
                  $scope.accRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.conRecord.Status)
                  $scope.conRecord.StatusDataType = DataTypeName; 
                if (DataTypeList[i] == $scope.conRecord.Date)
                  $scope.conRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.leadKvkRecord.Status)
                  $scope.leadKvkRecord.StatusDataType = DataTypeName;
                if (DataTypeList[i] == $scope.leadKvkRecord.Date)
                  $scope.leadKvkRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.leadGlobalOutRecord.Date)
                  $scope.leadGlobalOutRecord.DateDataType = DataTypeName;
                if (DataTypeList[i] == $scope.leadGlobalOutRecord.Status)
                  $scope.leadGlobalOutRecord.StatusDataType = DataTypeName;
              }
             
            });
            $scope.outputLeadFields = angular.copy($scope.leadFields);
            $scope.outputLeadFieldsDataTypeList = angular.copy($scope.leadFieldsDataTypeList);
          }
        }, { escape: true });

        $scope.UpdateAccountCallOut();
        $scope.UpdateContactCallOut();
        $scope.UpdateAccountkvkCallout();
        $scope.UpdateLeadkvkCallout();

    },

  $scope.getDataTypeFilteredLst = function(dataTypeName,lstRecords, isIndued = false )
  {
    if(!isIndued){
        var tempLst = [];
        for (var i = 0; i < lstRecords.length;i++)
        {
        if (lstRecords[i].DataType == dataTypeName)
            tempLst.push(lstRecords[i]);
        }
        return tempLst;
    } else {
        var tempLst = [];
        for (var i = 0; i < lstRecords.length;i++)
        {
        if (lstRecords[i].DataType == dataTypeName && (lstRecords[i].Name !== 'api_connector__indued_portfolio_status__c' && lstRecords[i].Name !== 'api_connector__indued_duediligence_id__c' && lstRecords[i].Name !== 'api_connector__indued_duediligences_status__c' && lstRecords[i].Name !== 'api_connector__indued_duediligencesfinal_fpm_status__c' && lstRecords[i].Name !== 'api_connector__indued_reports_id__c' && lstRecords[i].Name !== 'api_connector__indued_reportsfinal_report_status__c'))
            tempLst.push(lstRecords[i]);
        }
        return tempLst;
    }
  }

    $scope.UpdateAccountkvkCallout = function () {
        API_Connector.Engine.accountKvkIOCallout(function (resultMapAccflds, event) {
            if (resultMapAccflds != null) {
                
                if (resultMapAccflds.InputFields != null) {
                    angular.forEach(resultMapAccflds.InputFields, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.kvkInputFields.push(obj);
                    });
                    $scope.kvkAccInFieldsFlag = true;
                    $scope.$apply();
                }
                if (resultMapAccflds.OutputFields != null) {
                    angular.forEach(resultMapAccflds.OutputFields, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.kvkOutputFields.push(obj);
                    });
                    $scope.kvkAccOutFieldsFlag = true;
                    $scope.$apply();
                }
            } else {
                $scope.kvkInputFields = [];
                $scope.kvkOutputFields = [];
                $scope.kvkAccOutFieldsFlag = false;
                $scope.kvkAccInFieldsFlag = false;
            }
        })
    }

    $scope.UpdateLeadkvkCallout = function () {
        API_Connector.Engine.leadKvkIOCallout(function (resultMapAccflds, event) {
            if (resultMapAccflds != null) {
                
                if (resultMapAccflds.InputFields != null) {
                    angular.forEach(resultMapAccflds.InputFields, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.kvkLeadInputFields.push(obj);
                    });
                    $scope.kvkLeadInFieldsFlag = true;
                    $scope.$apply();
                }
                if (resultMapAccflds.OutputFields != null) {
                    angular.forEach(resultMapAccflds.OutputFields, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.kvkLeadOutputFields.push(obj);
                    });
                    $scope.kvkLeadOutFieldsFlag = true;
                    $scope.$apply();
                }
            } else {
                $scope.kvkLeadInputFields = [];
                $scope.kvkLeadOutputFields = [];
                $scope.kvkLeadInFieldsFlag = false;
                $scope.kvkLeadOutFieldsFlag = false;
            }
        })

    }

    $scope.UpdateAccountCallOut = function () {
        API_Connector.Engine.makeGetAccCallout(function (resultMapflds, event) {
            if (resultMapflds != null) {
                if (resultMapflds.InputFields != null) {
                    angular.forEach(resultMapflds.InputFields, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.leadMapFields.push(obj);
                    });
                    $scope.leadMapFieldsFlag = true;
                    $scope.$apply();
                }

                if (resultMapflds.OutputFields != null) {
                    angular.forEach(resultMapflds.OutputFields, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.leadMapOutFields.push(obj);
                    });
                    $scope.leadMapFieldsOutFlag = true;
                    $scope.$apply();
                }
            } else {
                $scope.leadMapFields = [];
                $scope.leadMapFieldsFlag = false;
                $scope.leadMapOutFields = [];
                $scope.leadMapFieldsOutFlag = false;
                $scope.$apply();
            }

        }, { escape: false });

    }
    $scope.UpdateContactCallOut = function () {

        API_Connector.Engine.makeGetConCallout(function (resultMapConflds, event) {
            if (resultMapConflds != null) {
                if (resultMapConflds.InputFields != null) {
                    angular.forEach(resultMapConflds.InputFields, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.leadMapConFields.push(obj);
                    });
                    $scope.leadMapConFieldsFlag = true;
                    $scope.$apply();
                }
                if (resultMapConflds.OutputFields != null) {
                    angular.forEach(resultMapConflds.OutputFields, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.leadMapConOutFields.push(obj);
                    });
                    $scope.leadMapConOutFieldsFlag = true;
                    $scope.$apply();
                }
            } else {
                $scope.leadMapConFields = [];
                $scope.leadMapConFieldsFlag = false;
                $scope.leadMapConOutFields = [];
                $scope.leadMapConOutFieldsFlag = false;
                $scope.$apply();
            }

        }, { escape: false });
    }
    $scope.saveAccountMapping = function (recordAccount, outputAccount, caseKeyRecord) {
        if(outputAccount.length > 0){
            outputAccount = checkBlank(outputAccount);
        }
        if (recordAccount.length > 0) {
            recordAccount = checkBlank(recordAccount);
            angular.forEach(recordAccount, function (value, key) {
                delete value.$$hashKey;
            })
        }
        API_Connector.Engine.saveAccountMapping(JSON.stringify(recordAccount), JSON.stringify(outputAccount), JSON.stringify(caseKeyRecord), function (result, event) {
            if (result != null) {
                //$toaster.showSuccess("Account Mapping Updated Successfully");
                toaster.pop('success', "Success", "Account Mapping Updated Successfully");
            }
            else {
                toaster.pop('error', "Error", "Error in Account Mapping");
            }
        }, { buffer: false, escape: false, timeout: 30000 });

    }
    //getting search record
    $scope.findRecord = function (objectName) {
        API_Connector.Engine.getRecordList($scope.searchKeyword.Name, objectName, function (recordlist, event) {
            if (recordlist != null) {
                $scope.lstRecordModel = angular.copy(recordlist);
            }
        })

    }

    //deselecting multiple record 
    $scope.uncheckMultiRecord = function (recordList, selectedRec) {
        angular.forEach(recordList, function (value, key) {
            if (value.$$hashKey != selectedRec.$$hashKey)
                value.selected = false;
        })

    }
    $scope.OpenPopupWindow = function (objRec) {
        $scope.showModel = true;
        $scope.selectedRecord = objRec;

    }
    $scope.closeModel = function () {
        $scope.showModel = false;
    }
    $scope.saveContactMapping = function (recordContact, outputContact, caseKeyRecord) {
        if(outputContact.length > 0){
            outputContact = checkBlank(outputContact);
        }
        if (recordContact.length > 0) {
            recordContact = checkBlank(recordContact);
            angular.forEach(recordContact, function (value, key) {
                delete value.$$hashKey;
            })
        }
        API_Connector.Engine.saveContactMapping(JSON.stringify(recordContact), JSON.stringify(outputContact), JSON.stringify(caseKeyRecord), function (result, event) {
            if (result != null) {
                //$toaster.showSuccess("Contact Mapping Updated Successfully");
                toaster.pop('success', "Success", "Contact Mapping Updated Successfully");
            } else {
                toaster.pop('error', "Error", "Error in Contact Mapping");
            }
        }, { escape: false });

    }
    API_Connector.Engine.userInformation(function (resultUserInfo, event) {
        if (resultUserInfo != null) {
            
            $scope.preventCallWatchInitialy = 1;
            $scope.objDuplicate.Username = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Username__c) : '';
            $scope.objDuplicate.Password = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Password__c) : '';
            $scope.objDuplicate.IsAccount = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__IsAccountTrigger__c) : false;
            $scope.objDuplicate.IsContact = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__IsContactTrigger__c) : false;
            $scope.objDuplicate.ContactUsername = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Contact_Username__c) : '';
            $scope.objDuplicate.ContactPassword = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Contact_Password__c) : '';

            $scope.objDuplicate.AccountKvkUsername = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Account_Kvk_Username__c) : '';
            $scope.objDuplicate.AccountKvkPassword = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Account_Kvk_Password__c) : '';
            $scope.objDuplicate.IsAccountKvk = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__IsAccountkvk__c) : false;

            $scope.objDuplicate.LeadKvkUsername = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Lead_Kvk_Username__c) : '';
            $scope.objDuplicate.LeadKvkPassword = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Lead_Kvk_Password__c) : '';
            $scope.objDuplicate.IsLeadKvk = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__IsLeadkvk__c) : false;

            $scope.objCredit.Duns = resultUserInfo.Credit != null ? makeUndefinedBlank(resultUserInfo.Credit.API_Connector__D_U_N_S_Number_Custom_Field__c) : '';
            $scope.objCredit.Username = resultUserInfo.Credit != null ? makeUndefinedBlank(resultUserInfo.Credit.API_Connector__Username__c) : '';
            $scope.objCredit.Password = resultUserInfo.Credit != null ? makeUndefinedBlank(resultUserInfo.Credit.API_Connector__Password__c) : '';
            $scope.objCredit.IsCheckCredit = angular.copy(resultUserInfo.Trigger != null ? makeUndefinedBlank(resultUserInfo.Trigger.API_Connector__IsActive__c) : false);

            //toolkit management
            if (resultUserInfo.Toolkit_Enterprise != null) {
              $scope.objToolkitEnterprise.Duns = makeUndefinedBlank(resultUserInfo.Toolkit_Enterprise.API_Connector__D_U_N_S_Number_Custom_Field__c);
              $scope.objToolkitEnterprise.Username = makeUndefinedBlank(resultUserInfo.Toolkit_Enterprise.API_Connector__Username__c);
              $scope.objToolkitEnterprise.Password = makeUndefinedBlank(resultUserInfo.Toolkit_Enterprise.API_Connector__Password__c);
              $scope.objToolkitEnterprise.IsActiveToolkit = makeUndefinedBlank(resultUserInfo.Toolkit_Enterprise.API_Connector__IsActive__c);
              $scope.objToolkitEnterprise.ToolkitDate = makeUndefinedBlank(resultUserInfo.Toolkit_Enterprise.API_Connector__Date__c);
              $scope.objToolkitEnterprise.ToolkitStatus = makeUndefinedBlank(resultUserInfo.Toolkit_Enterprise.API_Connector__Status__c);
            }
           //toolkit QuickCheck
            if (resultUserInfo.Toolkit_QuickCheck != null) {
              $scope.objToolkitQuickCheck.Duns = makeUndefinedBlank(resultUserInfo.Toolkit_QuickCheck.API_Connector__D_U_N_S_Number_Custom_Field__c);
              $scope.objToolkitQuickCheck.Username = makeUndefinedBlank(resultUserInfo.Toolkit_QuickCheck.API_Connector__Username__c);
              $scope.objToolkitQuickCheck.Password = makeUndefinedBlank(resultUserInfo.Toolkit_QuickCheck.API_Connector__Password__c);
              $scope.objToolkitQuickCheck.IsActiveToolkit = makeUndefinedBlank(resultUserInfo.Toolkit_QuickCheck.API_Connector__IsActive__c);
              $scope.objToolkitQuickCheck.ToolkitDate = makeUndefinedBlank(resultUserInfo.Toolkit_QuickCheck.API_Connector__Date__c);
              $scope.objToolkitQuickCheck.ToolkitStatus = makeUndefinedBlank(resultUserInfo.Toolkit_QuickCheck.API_Connector__Status__c);
            }

            //IWS Service
            if (resultUserInfo.IwsService_Setting != null) {
                $scope.objIwsService.Siren = makeUndefinedBlank(resultUserInfo.IwsService_Setting.API_Connector__Siren_Number_Input_Field__c);
                $scope.objIwsService.Username = makeUndefinedBlank(resultUserInfo.IwsService_Setting.API_Connector__Username__c);
                $scope.objIwsService.Password = makeUndefinedBlank(resultUserInfo.IwsService_Setting.API_Connector__Password__c);
                $scope.objIwsService.IsActiveIWS = makeUndefinedBlank(resultUserInfo.IwsService_Setting.API_Connector__IsActive__c);
                $scope.objIwsService.IwsServiceDate  = makeUndefinedBlank(resultUserInfo.IwsService_Setting.API_Connector__Date__c);
                $scope.objIwsService.IwsServiceStatus = makeUndefinedBlank(resultUserInfo.IwsService_Setting.API_Connector__Status__c);
            }

            //IWS Standard Address Service
            if (resultUserInfo.IWS_Standred_Address_Service_Setting != null) {
                $scope.objIWSStdAddInfoService.Siren = makeUndefinedBlank(resultUserInfo.IWS_Standred_Address_Service_Setting.API_Connector__Input_Field_Number__c);
                $scope.objIWSStdAddInfoService.Username = makeUndefinedBlank(resultUserInfo.IWS_Standred_Address_Service_Setting.API_Connector__Username__c);
                $scope.objIWSStdAddInfoService.Password = makeUndefinedBlank(resultUserInfo.IWS_Standred_Address_Service_Setting.API_Connector__Password__c);
                $scope.objIWSStdAddInfoService.IsActiveIWS = makeUndefinedBlank(resultUserInfo.IWS_Standred_Address_Service_Setting.API_Connector__IsActive__c);
                $scope.objIWSStdAddInfoService.IwsServiceDate  = makeUndefinedBlank(resultUserInfo.IWS_Standred_Address_Service_Setting.API_Connector__Date__c);
                $scope.objIWSStdAddInfoService.IwsServiceStatus = makeUndefinedBlank(resultUserInfo.IWS_Standred_Address_Service_Setting.API_Connector__Status__c);
                $scope.objIWSStdAddInfoService.DocURL = makeUndefinedBlank(resultUserInfo.IWS_Standred_Address_Service_Setting.API_Connector__API_Documentation_URL__c);

            }

            //IWS Paydex Information Service
            if(resultUserInfo.IWS_Paydex_Information_Service_Setting != null){
                $scope.objIWSPaydexInfoService.Siren = makeUndefinedBlank(resultUserInfo.IWS_Paydex_Information_Service_Setting.API_Connector__Input_Field_Number__c);
                $scope.objIWSPaydexInfoService.Username = makeUndefinedBlank(resultUserInfo.IWS_Paydex_Information_Service_Setting.API_Connector__Username__c);
                $scope.objIWSPaydexInfoService.Password = makeUndefinedBlank(resultUserInfo.IWS_Paydex_Information_Service_Setting.API_Connector__Password__c);
                $scope.objIWSPaydexInfoService.IsActiveIWS = makeUndefinedBlank(resultUserInfo.IWS_Paydex_Information_Service_Setting.API_Connector__IsActive__c);
                $scope.objIWSPaydexInfoService.IwsServiceDate  = makeUndefinedBlank(resultUserInfo.IWS_Paydex_Information_Service_Setting.API_Connector__Date__c);
                $scope.objIWSPaydexInfoService.IwsServiceStatus = makeUndefinedBlank(resultUserInfo.IWS_Paydex_Information_Service_Setting.API_Connector__Status__c);
                $scope.objIWSPaydexInfoService.DocURL = makeUndefinedBlank(resultUserInfo.IWS_Paydex_Information_Service_Setting.API_Connector__API_Documentation_URL__c);
            }

            // IWS Bankruptcy Information Service
            if (resultUserInfo.IWS_Bankruptcy_Information_Service_Setting != null) {
                $scope.objIwsBankruptcyInfoService.Siren = makeUndefinedBlank(resultUserInfo.IWS_Bankruptcy_Information_Service_Setting.API_Connector__Input_Field_Number__c);
                $scope.objIwsBankruptcyInfoService.Username = makeUndefinedBlank(resultUserInfo.IWS_Bankruptcy_Information_Service_Setting.API_Connector__Username__c);
                $scope.objIwsBankruptcyInfoService.Password = makeUndefinedBlank(resultUserInfo.IWS_Bankruptcy_Information_Service_Setting.API_Connector__Password__c);
                $scope.objIwsBankruptcyInfoService.IsActiveIWSBankruptcyInfo = makeUndefinedBlank(resultUserInfo.IWS_Bankruptcy_Information_Service_Setting.API_Connector__IsActive__c);
                $scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceDate  = makeUndefinedBlank(resultUserInfo.IWS_Bankruptcy_Information_Service_Setting.API_Connector__Date__c);
                $scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceStatus = makeUndefinedBlank(resultUserInfo.IWS_Bankruptcy_Information_Service_Setting.API_Connector__Status__c);
                $scope.objIwsBankruptcyInfoService.DocURL = makeUndefinedBlank(resultUserInfo.IWS_Bankruptcy_Information_Service_Setting.API_Connector__API_Documentation_URL__c);
                $scope.objIwsBankruptcyInfoService.Source = makeUndefinedBlank(resultUserInfo.IWS_Bankruptcy_Information_Service_Setting.API_Connector__Sources__c);
            }    
            //IWS Balance Sheet 
            if (resultUserInfo.IWS_Balance_Sheet_Service_Setting != null) {
                $scope.objIWSBalanceSheetService.Siren = makeUndefinedBlank(resultUserInfo.IWS_Balance_Sheet_Service_Setting.API_Connector__Input_Field_Number__c);
                $scope.objIWSBalanceSheetService.Username = makeUndefinedBlank(resultUserInfo.IWS_Balance_Sheet_Service_Setting.API_Connector__Username__c);
                $scope.objIWSBalanceSheetService.Password = makeUndefinedBlank(resultUserInfo.IWS_Balance_Sheet_Service_Setting.API_Connector__Password__c);
                $scope.objIWSBalanceSheetService.IsActiveIWS = makeUndefinedBlank(resultUserInfo.IWS_Balance_Sheet_Service_Setting.API_Connector__IsActive__c);
                $scope.objIWSBalanceSheetService.IwsServiceDate  = makeUndefinedBlank(resultUserInfo.IWS_Balance_Sheet_Service_Setting.API_Connector__Date__c);
                $scope.objIWSBalanceSheetService.IwsServiceStatus = makeUndefinedBlank(resultUserInfo.IWS_Balance_Sheet_Service_Setting.API_Connector__Status__c);
                $scope.objIWSBalanceSheetService.DocURL = makeUndefinedBlank(resultUserInfo.IWS_Balance_Sheet_Service_Setting.API_Connector__API_Documentation_URL__c);
            }
            
            //IWS Risk Information Service 
            if (resultUserInfo.IWS_Risk_Information_Service_Setting != null) {
                $scope.objIWSRiskInfoService.Siren = makeUndefinedBlank(resultUserInfo.IWS_Risk_Information_Service_Setting.API_Connector__Input_Field_Number__c);
                $scope.objIWSRiskInfoService.Username = makeUndefinedBlank(resultUserInfo.IWS_Risk_Information_Service_Setting.API_Connector__Username__c);
                $scope.objIWSRiskInfoService.Password = makeUndefinedBlank(resultUserInfo.IWS_Risk_Information_Service_Setting.API_Connector__Password__c);
                $scope.objIWSRiskInfoService.IsActiveIWS = makeUndefinedBlank(resultUserInfo.IWS_Risk_Information_Service_Setting.API_Connector__IsActive__c);
                $scope.objIWSRiskInfoService.IwsServiceDate  = makeUndefinedBlank(resultUserInfo.IWS_Risk_Information_Service_Setting.API_Connector__Date__c);
                $scope.objIWSRiskInfoService.IwsServiceStatus = makeUndefinedBlank(resultUserInfo.IWS_Risk_Information_Service_Setting.API_Connector__Status__c);
                $scope.objIWSRiskInfoService.DocURL = makeUndefinedBlank(resultUserInfo.IWS_Risk_Information_Service_Setting.API_Connector__API_Documentation_URL__c);

            }

            //Risk Datablock Service
            if(resultUserInfo.RiskDatablockServiceMapping != null) {
                $scope.objRiskDatablockService.dunsNumber = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceMapping.API_Connector__Input_Field_Number__c);
                $scope.objRiskDatablockService.Consumer_Key = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceMapping.API_Connector__Consumer_Key__c);
                $scope.objRiskDatablockService.Consumer_Secret = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceMapping.API_Connector__Consumer_Secret__c);
                $scope.objRiskDatablockService.riskDatablockServiceDate = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceMapping.API_Connector__Date__c);
                $scope.objRiskDatablockService.riskDatablockServiceStatus = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceMapping.API_Connector__Status__c);
                $scope.objRiskDatablockService.IsActiveRiskDatablock = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceMapping.API_Connector__IsActive__c);
            }

            if(resultUserInfo.RiskDatablockServiceInputMapping != null) {
                $scope.objRiskDatablockService.isOnlyRecommended = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceInputMapping.API_Connector__isOnlyRecommended__c);
                $scope.objRiskDatablockService.criteriaMapping = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceInputMapping.API_Connector__Input_Setting_Mapping__c);
                $scope.objRiskDatablockService.tradeUp = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceInputMapping.API_Connector__tradeUp__c);
                $scope.objRiskDatablockService.customerReference = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceInputMapping.API_Connector__customerReference__c);
                $scope.objRiskDatablockService.orderReason = makeUndefinedBlank(resultUserInfo.RiskDatablockServiceInputMapping.API_Connector__orderReason__c);
            }

            //Company Report Service
            if(resultUserInfo.CompanyReportServiceMapping != null) {
                $scope.objCompanyReportService.dunsNumber = makeUndefinedBlank(resultUserInfo.CompanyReportServiceMapping.API_Connector__Input_Field_Number__c);
                $scope.objCompanyReportService.Consumer_Key = makeUndefinedBlank(resultUserInfo.CompanyReportServiceMapping.API_Connector__Consumer_Key__c);
                $scope.objCompanyReportService.Consumer_Secret = makeUndefinedBlank(resultUserInfo.CompanyReportServiceMapping.API_Connector__Consumer_Secret__c);
                $scope.objCompanyReportService.companyReportServiceDate = makeUndefinedBlank(resultUserInfo.CompanyReportServiceMapping.API_Connector__Date__c);
                $scope.objCompanyReportService.companyReportServiceStatus = makeUndefinedBlank(resultUserInfo.CompanyReportServiceMapping.API_Connector__Status__c);
                $scope.objCompanyReportService.IsActiveCompanyReport = makeUndefinedBlank(resultUserInfo.CompanyReportServiceMapping.API_Connector__IsActive__c);
            }

            if(resultUserInfo.CompanyReportServiceInputMapping != null) {
                $scope.objCompanyReportService.inLangage = makeUndefinedBlank(resultUserInfo.CompanyReportServiceInputMapping.API_Connector__inLangage__c);
                $scope.objCompanyReportService.Product_ID = makeUndefinedBlank(resultUserInfo.CompanyReportServiceInputMapping.API_Connector__Product_ID__c);
                $scope.objCompanyReportService.tradeUp = makeUndefinedBlank(resultUserInfo.CompanyReportServiceInputMapping.API_Connector__tradeUp__c);
                $scope.objCompanyReportService.customerReference = makeUndefinedBlank(resultUserInfo.CompanyReportServiceInputMapping.API_Connector__customerReference__c);
                $scope.objCompanyReportService.orderReason = makeUndefinedBlank(resultUserInfo.CompanyReportServiceInputMapping.API_Connector__orderReason__c);
            }

            //IWS Advanced Address Information Service
            if (resultUserInfo.IWSAdvancedAddressService_Setting != null) {
                $scope.objIwsAdvancedAddressService.Siret = makeUndefinedBlank(resultUserInfo.IWSAdvancedAddressService_Setting.API_Connector__Siret_Number_Input_Field__c);
                $scope.objIwsAdvancedAddressService.Username = makeUndefinedBlank(resultUserInfo.IWSAdvancedAddressService_Setting.API_Connector__Username__c);
                $scope.objIwsAdvancedAddressService.Password = makeUndefinedBlank(resultUserInfo.IWSAdvancedAddressService_Setting.API_Connector__Password__c);
                $scope.objIwsAdvancedAddressService.IsActiveIWSAdvancedAddress = makeUndefinedBlank(resultUserInfo.IWSAdvancedAddressService_Setting.API_Connector__IsActive__c);
                $scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceDate  = makeUndefinedBlank(resultUserInfo.IWSAdvancedAddressService_Setting.API_Connector__Date__c);
                $scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceStatus = makeUndefinedBlank(resultUserInfo.IWSAdvancedAddressService_Setting.API_Connector__Status__c);
            }

             //GDM Service
             if (resultUserInfo.GDM_Service_Setting != null) {
                $scope.objGDMService.UserId = makeUndefinedBlank(resultUserInfo.GDM_Service_Setting.API_Connector__UserId__c);
                $scope.objGDMService.Password = makeUndefinedBlank(resultUserInfo.GDM_Service_Setting.API_Connector__Password__c);
                $scope.objGDMService.GDMServiceStatus = makeUndefinedBlank(resultUserInfo.GDM_Service_Setting.API_Connector__Status__c);
                $scope.objGDMService.GDMServiceDate = makeUndefinedBlank(resultUserInfo.GDM_Service_Setting.API_Connector__Date__c);
                $scope.objGDMService.Duns = makeUndefinedBlank(resultUserInfo.GDM_Service_Setting.API_Connector__DUNS__c);
                $scope.objGDMService.IsAccountGDMActive = makeUndefinedBlank(resultUserInfo.GDM_Service_Setting.API_Connector__Is_Active__c);
                // $scope.objGDMService.IwsServiceDate  = makeUndefinedBlank(resultUserInfo.IwsService_Setting.API_Connector__Date__c);
                
            }

            //IndueD Service
            if(resultUserInfo.IndueD_Service_SettingsStep_1 != null) {
                $scope.objInduedService.api_token = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_1.API_Connector__API_Token__c);
                $scope.objInduedService.duns = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_1.API_Connector__Duns__c);
                $scope.objInduedService.tags = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_1.API_Connector__tags__c);
                $scope.objInduedService.IsActiveDueDiligenceService = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_1.API_Connector__IsActive__c);
            }

            if(resultUserInfo.IndueD_Service_SettingsStep_2 != null) {
                $scope.objInduedService.DueDiligenceDate = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_2.API_Connector__Date__c);
            }

            if(resultUserInfo.IndueD_Service_SettingsStep_3 != null) {
                $scope.objInduedService.DueDiligenceDuedidServiceStatus = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_3.API_Connector__Status__c);
                $scope.objInduedService.DueDiligenceServiceFpmDate = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_3.API_Connector__Date__c);
            }

            if(resultUserInfo.IndueD_Service_SettingsStep_4 != null) {
                $scope.objInduedService.ReportServiceStatus = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_4.API_Connector__Status__c);
                $scope.objInduedService.ReportDate = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_4.API_Connector__Date__c);
            }

            if(resultUserInfo.IndueD_Service_SettingsStep_5 != null) {
                 $scope.objInduedService.ReportIdDate = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_5.API_Connector__Date__c);
                 $scope.objInduedService.ReportUrl = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_5.API_Connector__IndueD_ReportsFinal_URL__c);
                 $scope.objInduedService.ReportIdServiceStatus = makeUndefinedBlank(resultUserInfo.IndueD_Service_SettingsStep_5.API_Connector__Status__c);
                }

            if( resultUserInfo.IndueDServiceInputSetting.API_Connector__sanctions__c != null && makeUndefinedBlank( resultUserInfo.IndueDServiceInputSetting.API_Connector__sanctions__c ) != ''){
                if(makeUndefinedBlank(resultUserInfo.IndueDServiceInputSetting.API_Connector__sanctions__c) != null){
                    $scope.objInduedService.sanctions = resultUserInfo.IndueDServiceInputSetting.API_Connector__sanctions__c;
                }
            }

            if( resultUserInfo.IndueDServiceInputSetting.API_Connector__peps__c != null && makeUndefinedBlank( resultUserInfo.IndueDServiceInputSetting.API_Connector__peps__c ) != ''){
                if(makeUndefinedBlank(resultUserInfo.IndueDServiceInputSetting.API_Connector__peps__c) != null){
                    $scope.objInduedService.peps = resultUserInfo.IndueDServiceInputSetting.API_Connector__peps__c;
                }
            }

            if( resultUserInfo.IndueDServiceInputSetting.API_Connector__adverse_medias__c != null && makeUndefinedBlank( resultUserInfo.IndueDServiceInputSetting.API_Connector__adverse_medias__c ) != ''){
                if(makeUndefinedBlank(resultUserInfo.IndueDServiceInputSetting.API_Connector__adverse_medias__c) != null){
                    $scope.objInduedService.adverse_medias = resultUserInfo.IndueDServiceInputSetting.API_Connector__adverse_medias__c;
                }
            }

            if( resultUserInfo.IndueDServiceInputSetting.API_Connector__match_confidence__c != null && makeUndefinedBlank( resultUserInfo.IndueDServiceInputSetting.API_Connector__match_confidence__c ) != ''){
                if(makeUndefinedBlank(resultUserInfo.IndueDServiceInputSetting.API_Connector__match_confidence__c) != null){
                    $scope.objInduedService.match_confidence = resultUserInfo.IndueDServiceInputSetting.API_Connector__match_confidence__c;
                }
            }

            if( resultUserInfo.IndueDServiceInputSetting.API_Connector__ownership_threshold__c != null && makeUndefinedBlank( resultUserInfo.IndueDServiceInputSetting.API_Connector__ownership_threshold__c ) != ''){
                if(makeUndefinedBlank(resultUserInfo.IndueDServiceInputSetting.API_Connector__ownership_threshold__c) != null){
                    $scope.objInduedService.ownership_threshold = resultUserInfo.IndueDServiceInputSetting.API_Connector__ownership_threshold__c;
                }
            }
            
            if( resultUserInfo.IndueDServiceInputSetting.API_Connector__managers_scope__c != null && makeUndefinedBlank( resultUserInfo.IndueDServiceInputSetting.API_Connector__managers_scope__c ) != ''){
                if(makeUndefinedBlank(resultUserInfo.IndueDServiceInputSetting.API_Connector__managers_scope__c) != null){
                    $scope.objInduedService.managers_scope = resultUserInfo.IndueDServiceInputSetting.API_Connector__managers_scope__c;
                }
            }

            if( resultUserInfo.AccountGDMInputSettings.API_Connector__Billing_Reference__c != null && makeUndefinedBlank( resultUserInfo.AccountGDMInputSettings.API_Connector__Billing_Reference__c ) != ''){
                var objBillingReference = JSON.parse(resultUserInfo.AccountGDMInputSettings.API_Connector__Billing_Reference__c);
                if(makeUndefinedBlank(objBillingReference.billingReference) != ''){
                    $scope.objGDMService.billingReference = objBillingReference.billingReference;
                }
            }
            if( resultUserInfo.AccountGDMInputSettings.API_Connector__Ruleset_name__c	!= null && makeUndefinedBlank( resultUserInfo.AccountGDMInputSettings.API_Connector__Ruleset_name__c	 ) != ''){
                var objRulesetName = JSON.parse(resultUserInfo.AccountGDMInputSettings.API_Connector__Ruleset_name__c	);
                if(makeUndefinedBlank(objRulesetName.rulesetName) != ''){
                    $scope.objGDMService.rulesetName = objRulesetName.rulesetName;
                }
            }
            if( resultUserInfo.AccountGDMInputSettings.API_Connector__Ruleset_version__c != null && makeUndefinedBlank( resultUserInfo.AccountGDMInputSettings.API_Connector__Ruleset_version__c ) != ''){
                var objRulesetVersion = JSON.parse(resultUserInfo.AccountGDMInputSettings.API_Connector__Ruleset_version__c);
                if(makeUndefinedBlank(objRulesetVersion.rulesetVersion) != ''){
                    $scope.objGDMService.rulesetVersion = objRulesetVersion.rulesetVersion;
                }
            }

            $scope.objVat.Vat = resultUserInfo.Vat != null ? makeUndefinedBlank(resultUserInfo.Vat.API_Connector__Custom_VAT_Number_Field__c) : '';
            $scope.objVat.IsCheckVat = resultUserInfo.Vat != null ? makeUndefinedBlank(resultUserInfo.Vat.API_Connector__VAT_Validation_trigger_on_Account__c) : '';
            
            //GlobalMatch Lead UserName Passwords
            if (resultUserInfo.GlobalLeadCredentials != null) {
                $scope.objLeadGlobal.Consumer_Key = makeUndefinedBlank(resultUserInfo.GlobalLeadCredentials.API_Connector__Consumer_Key__c);
                $scope.objLeadGlobal.Consumer_Secret = makeUndefinedBlank(resultUserInfo.GlobalLeadCredentials.API_Connector__Consumer_Secret__c);
            }
            //GlobalMatch Account UserName Passwords
            if (resultUserInfo.GlobalAccountCredentials != null) {
                $scope.objAccountGlobal.Consumer_Key = makeUndefinedBlank(resultUserInfo.GlobalAccountCredentials.API_Connector__Consumer_Key__c);
                $scope.objAccountGlobal.Consumer_Secret = makeUndefinedBlank(resultUserInfo.GlobalAccountCredentials.API_Connector__Consumer_Secret__c);
            }

            if(resultUserInfo.AccountTradeCreditCredentials != null){
                $scope.objAccountTradeCredit.Consumer_Key = makeUndefinedBlank(resultUserInfo.AccountTradeCreditCredentials.API_Connector__Consumer_Key__c);
                $scope.objAccountTradeCredit.Consumer_Secret = makeUndefinedBlank(resultUserInfo.AccountTradeCreditCredentials.API_Connector__Consumer_Secret__c);
            }

            $scope.objLeadGlobal.IsLeadGlobalMatchTrigger = angular.copy(resultUserInfo.LeadGlobalMatchTrigger != null ? makeUndefinedBlank(resultUserInfo.LeadGlobalMatchTrigger.API_Connector__IsActive__c) : false);
            $scope.objAccountGlobal.IsAccountGlobalMatchTrigger = angular.copy(resultUserInfo.AccountGlobalMatchTrigger != null ? makeUndefinedBlank(resultUserInfo.AccountGlobalMatchTrigger.API_Connector__IsActive__c) : false);
            $scope.objAccountTradeCredit.IsAccountTradeCreditTrigger = angular.copy(resultUserInfo.AccountTradeCreditTrigger != null ? makeUndefinedBlank(resultUserInfo.AccountTradeCreditTrigger.API_Connector__IsActive__c) : false);

            //output field
            $scope.creditRecord.Value = resultUserInfo.Credit != null ? makeUndefinedBlank(resultUserInfo.Credit.API_Connector__Credit_Rating__c) : '';
            $scope.creditRecord.Date = resultUserInfo.Credit != null ? makeUndefinedBlank(resultUserInfo.Credit.API_Connector__Credit_Check_Last_Date__c) : '';
            $scope.creditRecord.Status = resultUserInfo.Credit != null ? makeUndefinedBlank(resultUserInfo.Credit.API_Connector__Credit_Check_Status__c) : '';

            $scope.vatRecord.Value = resultUserInfo.Vat != null ? makeUndefinedBlank(resultUserInfo.Vat.API_Connector__VAT_Validation_Status__c) : '';
            $scope.vatRecord.Date = resultUserInfo.Vat != null ? makeUndefinedBlank(resultUserInfo.Vat.API_Connector__Vat_Date__c) : '';
            $scope.vatRecord.Status = resultUserInfo.Vat != null ? makeUndefinedBlank(resultUserInfo.Vat.API_Connector__Vat_Status__c) : '';
            $scope.vatRecord.Identifier = resultUserInfo.Vat != null ? makeUndefinedBlank(resultUserInfo.Vat.API_Connector__Vat_Request_Identifier__c) : '';

            $scope.accRecord.Value = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Duplicate_Account__c) : '';
            $scope.accRecord.Date = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Output_Account_Date__c) : '';
            $scope.accRecord.Status = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Output_Account_Map_Field__c) : '';

            $scope.conRecord.Value = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Duplicate_Contact__c) : '';
            $scope.conRecord.Date = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Output_Contact_Date__c) : '';
            $scope.conRecord.Status = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Output_Contact_Map_Field__c) : '';

            $scope.accKvkRecord.Status = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Account_Kvk_Status__c) : '';
            $scope.accKvkRecord.Date = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Account_Kvk_Date__c) : '';

            $scope.leadKvkRecord.Status = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Lead_Kvk_Status__c) : '';
            $scope.leadKvkRecord.Date = resultUserInfo.Duplicate != null ? makeUndefinedBlank(resultUserInfo.Duplicate.API_Connector__Lead_Kvk_Date__c) : '';

            $scope.leadGlobalOutRecord.Status = resultUserInfo.LeadGlobalMatchMapping != null ? makeUndefinedBlank(resultUserInfo.LeadGlobalMatchMapping.API_Connector__Status_Field__c) : '';
            $scope.leadGlobalOutRecord.Date = resultUserInfo.LeadGlobalMatchMapping != null ? makeUndefinedBlank(resultUserInfo.LeadGlobalMatchMapping.API_Connector__Date_Field__c) : '';

            $scope.accountGlobalOutRecord.Status = resultUserInfo.AccountGlobalMatchMapping != null ? makeUndefinedBlank(resultUserInfo.AccountGlobalMatchMapping.API_Connector__Status_Field__c) : '';
            $scope.accountGlobalOutRecord.Date = resultUserInfo.AccountGlobalMatchMapping != null ? makeUndefinedBlank(resultUserInfo.AccountGlobalMatchMapping.API_Connector__Date_Field__c) : '';

            $scope.accountTradeCreditDateStatusRecord.Status = resultUserInfo.AccountTradeCreditMapping != null ? makeUndefinedBlank(resultUserInfo.AccountTradeCreditMapping.API_Connector__Status_Field__c) : '';
            $scope.accountTradeCreditDateStatusRecord.Date = resultUserInfo.AccountTradeCreditMapping != null ? makeUndefinedBlank(resultUserInfo.AccountTradeCreditMapping.API_Connector__Date_Field__c) : '';

            $scope.objAccountTradeCredit.dunsNumber = resultUserInfo.AccountTradeCreditMapping != null ? makeUndefinedBlank(resultUserInfo.AccountTradeCreditMapping.API_Connector__Input_Fields_Mapping__c) : '';

            $scope.objLeadGlobal.confidenceLowerLevelThresholdValue = resultUserInfo.LeadGlobalMatchInputSetting != null ? makeUndefinedBlank(resultUserInfo.LeadGlobalMatchInputSetting.API_Connector__confidenceLowerLevelThresholdValue__c) : '';
            $scope.objLeadGlobal.exclusionCriteria = resultUserInfo.LeadGlobalMatchInputSetting != null ? makeUndefinedBlank(resultUserInfo.LeadGlobalMatchInputSetting.API_Connector__exclusionCriteria__c) : '';
            if(resultUserInfo.LeadGlobalMatchInputSetting != null){
                var objExclusionCriteria = JSON.parse(resultUserInfo.LeadGlobalMatchInputSetting.API_Connector__exclusionCriteria__c);
                if( objExclusionCriteria.exclusionCriteria != null && makeUndefinedBlank(objExclusionCriteria.exclusionCriteria) != ''){
                    var lstexclusion = objExclusionCriteria.exclusionCriteria.split(",");
                    for(var index = 0; index <  lstexclusion.length; index++){
                        var idx = $scope.exclusionCriteriaOptions.findIndex(x => x.value==lstexclusion[index]);
                        if (idx != -1) {
                            var item = $scope.exclusionCriteriaOptions[idx];
                            item['selected'] = true;
                            $scope.lstLeadGlobalExclusionCriteriaSelection.push(item);
                        } 
                    }
                }
                if( resultUserInfo.LeadGlobalMatchInputSetting.API_Connector__confidenceLowerLevelThresholdValue__c != null && makeUndefinedBlank(resultUserInfo.LeadGlobalMatchInputSetting.API_Connector__confidenceLowerLevelThresholdValue__c) != ''){
                    var objConfidenceLowerLevel = JSON.parse(resultUserInfo.LeadGlobalMatchInputSetting.API_Connector__confidenceLowerLevelThresholdValue__c);
                    if(makeUndefinedBlank(objConfidenceLowerLevel.confidenceLowerLevelThresholdValue) != ''){
                        $scope.objLeadGlobal.confidenceLowerLevel = objConfidenceLowerLevel.confidenceLowerLevelThresholdValue;
                    }
                } 
            }
            $scope.objAccountGlobal.confidenceLowerLevelThresholdValue = resultUserInfo.AccountGlobalMatchInputSetting != null ? makeUndefinedBlank(resultUserInfo.AccountGlobalMatchInputSetting.API_Connector__confidenceLowerLevelThresholdValue__c) : '';
            $scope.objAccountGlobal.exclusionCriteria = resultUserInfo.AccountGlobalMatchInputSetting != null ? makeUndefinedBlank(resultUserInfo.AccountGlobalMatchInputSetting.API_Connector__exclusionCriteria__c) : '';
            if(resultUserInfo.AccountGlobalMatchInputSetting != null){
                var objExclusionCriteria = JSON.parse(resultUserInfo.AccountGlobalMatchInputSetting.API_Connector__exclusionCriteria__c);
                if( objExclusionCriteria.exclusionCriteria != null && makeUndefinedBlank(objExclusionCriteria.exclusionCriteria) != ''){
                    var lstexclusion = objExclusionCriteria.exclusionCriteria.split(",");
                    for(var index = 0; index <  lstexclusion.length; index++){
                        var idx = $scope.exclusionCriteriaOptions.findIndex(x => x.value==lstexclusion[index]);
                        if (idx != -1) {
                            var item = $scope.exclusionCriteriaOptions[idx];
                            item['selected'] = true;
                            $scope.lstAccountGlobalExclusionCriteriaSelection.push(item);
                        } 
                    }
                }
                if( resultUserInfo.AccountGlobalMatchInputSetting.API_Connector__confidenceLowerLevelThresholdValue__c != null && makeUndefinedBlank(resultUserInfo.LeadGlobalMatchInputSetting.API_Connector__confidenceLowerLevelThresholdValue__c) != ''){
                    var objConfidenceLowerLevel = JSON.parse(resultUserInfo.AccountGlobalMatchInputSetting.API_Connector__confidenceLowerLevelThresholdValue__c);
                    if(makeUndefinedBlank(objConfidenceLowerLevel.confidenceLowerLevelThresholdValue) != ''){
                        $scope.objAccountGlobal.confidenceLowerLevel = objConfidenceLowerLevel.confidenceLowerLevelThresholdValue;
                    }
                } 
            }
        }

    }, { escape: false })
    $scope.serviceCall = function (service) {
        $scope.invalidLogic = false;
        $scope.serviceName.Name = service;
        $scope.IsShowPassword = true;
        $scope.typePassword = 'password';
        $scope.creditCheck = ($scope.serviceName.Name == $scope.serviceListObject.CREDIT_CHECK)? true: false;
        $scope.duplicateCheckAccount = ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_DUPLICATE)? true: false;
        $scope.duplicateCheckContact = ($scope.serviceName.Name == $scope.serviceListObject.CONTACT_DUPLICATE)? true: false;
        $scope.vatCheck = ($scope.serviceName.Name == $scope.serviceListObject.VAT)? true: false;
        $scope.toolkitErpManagement = ($scope.serviceName.Name == $scope.serviceListObject.ENTERPRISE)? true: false;
        $scope.toolkitQuickCheck = ($scope.serviceName.Name == $scope.serviceListObject.QUICK)? true: false;
        $scope.accountKvk = ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_KVK)? true: false;
        $scope.leadKvk = ($scope.serviceName.Name == $scope.serviceListObject.LEAD_KVK)? true: false;
        $scope.accountGlobalMatch = ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_GLOBAL)? true: false;
        $scope.leadGlobal = ($scope.serviceName.Name == $scope.serviceListObject.LEAD_GLOBAL)? true: false;
        $scope.accountTradeCredit = ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_TRADE)? true: false;
        $scope.iwsServiceAccount = ($scope.serviceName.Name == $scope.serviceListObject.IWS_SERVICE)? true: false;
        //start Global Decision Maker Service 
        $scope.gdmServiceAccount = ($scope.serviceName.Name == $scope.serviceListObject.GLOBAL_DECISION_MAKER)? true: false;
        //end Global Decision Maker Service 
        $scope.isIWSStdAddInfoServiceForAccount = ($scope.serviceName.Name == $scope.serviceListObject.IWS_STANDARD_ADDRESS_INFORMATION) ? true : false;
        $scope.iwsAdvancedAddressServiceAccount = ($scope.serviceName.Name == $scope.serviceListObject.IWS_Advanced_Address_Information_Service)? true: false;   
        // Start IWS Bankruptcy Information Service
        $scope.iwsBankruptcyInfoServiceAccount = ($scope.serviceName.Name == $scope.serviceListObject.IWS_Bankruptcy_Information_Service)? true: false;   
        // End IWS Bankruptcy Information Service  
        //Start IWS Paydex Information Service
        $scope.isIWSPaydexInfoServiceForAccount = ($scope.serviceName.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION) ? true : false;      
        //End IWS Paydex Information Service
        //Start IWS Risk Information
        $scope.isIWSRiskInfoServiceForAccount = ($scope.serviceName.Name == $scope.serviceListObject.IWS_RISK_INFORMATION) ? true : false;
        //End IWS Risk Information
        $scope.isIWSBalanceSheetServiceForAccount = ($scope.serviceName.Name == $scope.serviceListObject.IWS_BALANCE_SHEET)? true: false;   
        //Start IndueD Service
        $scope.induedService = ($scope.serviceName.Name == $scope.serviceListObject.INDUED_SERVICE)? true: false;
        //Start Risk Datablock Service
        $scope.riskDatablocksServiceAccount = ($scope.serviceName.Name == $scope.serviceListObject.RISK_DATABLOCKS)? true: false;
        //Start Company Report Service
        $scope.companyReportServiceAccount = ($scope.serviceName.Name == $scope.serviceListObject.COMPANY_REPORT)? true: false;
    }
   
    $scope.addTradeNewRow = function (recordType, rowType) {
        var newRec = { 'name': '', 'value': '', 'type': rowType};
        if (recordType == 'output_AccountTradeCredit'){          
            $scope.output_AccountTradeCredit.push(newRec);
            $scope.output_AccountTradeCreditTemp.push(newRec);
        }       
    }
    $scope.addNewRow = function (recordType) {
        var newRec = { 'name': '', 'value': '' };
        if (recordType == 'Account'){
            $scope.recordAccount.push(newRec);
            $scope.recordAccountTemp.push(newRec);
        }
        else if (recordType == 'Contact'){
            $scope.recordContact.push(newRec);
            $scope.recordContactTemp.push(newRec);
        }
        else if (recordType == 'Output_Account'){
            $scope.output_Account.push(newRec);
            $scope.output_AccountTemp.push(newRec);
        }
        else if (recordType == 'Output_Contact'){
            $scope.output_Contact.push(newRec);
            $scope.output_ContactTemp.push(newRec);
        }
        else if (recordType == 'toolkit'){
            $scope.output_toolkit.push(newRec);
            $scope.output_ToolkitTemp.push(newRec);
        }
        else if (recordType == 'toolkitQC'){
            $scope.output_toolkitQC.push(newRec);
            $scope.output_ToolkitQCTemp.push(newRec);
        }
        else if (recordType == 'AccountKvk'){
            $scope.Mapping_AccountKvk.push(newRec);
            $scope.Mapping_AccountKvkTemp.push(newRec);
        }
        else if (recordType == 'AccountKvkOutFld'){
            $scope.Output_AccountKvk.push(newRec);
            $scope.Output_AccountKvkTemp.push(newRec);
        }
        else if (recordType == 'LeadKvk'){
            $scope.Mapping_LeadKvk.push(newRec);
            $scope.Mapping_LeadKvkTemp.push(newRec);
        } 
        else if (recordType == 'LeadKvkOutFld'){
            $scope.Output_LeadKvk.push(newRec);
            $scope.Output_LeadKvkTemp.push(newRec);
        }
        else if (recordType == 'output_LeadGlobal'){
            $scope.output_LeadGlobal.push(newRec);
            $scope.output_LeadGlobalTemp.push(newRec);
        } 
        else if (recordType == 'input_leadGlobal'){
            $scope.recordLeadGlobal.push(newRec);
            $scope.recordLeadGlobalTemp.push(newRec);

        }
        else if (recordType == 'output_AccountGlobal'){
            $scope.output_AccountGlobal.push(newRec);
            $scope.output_AccountGlobalTemp.push(newRec);
        }
        else if (recordType == 'input_AccountGlobal'){
            $scope.recordAccountGlobal.push(newRec);
            $scope.recordAccountGlobalTemp.push(newRec);
        }
        else if (recordType == 'output_IWSAccountService'){
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_IWSAccountService.push(newRec);
            $scope.output_IWSAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'output_IWSAdvancedAddressAccountService'){
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_IWSAdvancedAddressAccountService.push(newRec);
            $scope.output_IWSAdvancedAddressAccountServiceTemp.push(newRec);
        }  
        else if (recordType == 'output_IWSBankruptcyInfoAccountService'){
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_IWSBankruptcyInfoAccountService.push(newRec);
            $scope.output_IWSBankruptcyInfoAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'input_IWSAccountService'){
            $scope.input_IWSAccountService.push(newRec);
            $scope.input_IWSAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'output_IWSStdAddInfoAccountService'){
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_IWSStdAddInfoAccountService.push(newRec);
            $scope.output_IWSStdAddInfoAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'input_IWSStdAddInfoAccountServiceTemp'){
            $scope.input_IWSStdAddInfoAccountService.push(newRec);
            $scope.input_IWSStdAddInfoAccountServiceTemp.push(newRec);
        } 
        else if (recordType == 'output_IWSPaydexInfoAccountService'){
            var newRec = { 'name': '--None--', 'value': '--None--'};
            $scope.output_IWSPaydexInfoAccountService.push(newRec);
            $scope.output_IWSPaydexInfoAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'output_IWSBalanceSheetAccountService'){
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_IWSBalanceSheetAccountService.push(newRec);
            $scope.output_IWSBalanceSheetAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'input_IWSBalanceSheetAccountService '){
            $scope.input_IWSBalanceSheetAccountService.push(newRec);
            $scope.input_IWSBalanceSheetAccountServiceTemp.push(newRec);
        } 
        else if (recordType == 'input_accountGDM'){
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.input_GDMAccountService.push(newRec);
            $scope.input_GDMAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'output_accountGDM'){
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_GDMAccountService.push(newRec);
            $scope.output_GDMAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'output_IWSRiskInfoAccountService'){
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_IWSRiskInfoAccountService.push(newRec);
            $scope.output_IWSRiskInfoAccountServiceTemp.push(newRec);
        }
        else if (recordType == 'input_IWSRiskInfoAccountService'){
            $scope.input_IWSRiskInfoAccountService.push(newRec);
            $scope.input_IWSRiskInfoAccountServiceTemp.push(newRec);
        }
        else if(recordType == 'output_IndueDService') {
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_IndueDService.push(newRec);
            $scope.output_IndueDServiceTemp.push(newRec);
        }
        else if(recordType == 'input_IndueDService') {
            $scope.input_IndueDService.push(newRec);
            $scope.input_IndueDServiceTemp.push(newRec);
        }
        //Risk Datablock Service
        else if(recordType == 'output_RiskDatablockAccountService') {
            var newRec = { 'name': '--None--', 'value': '--None--' };
            $scope.output_RiskDatablockAccountService.push(newRec);
            $scope.output_RiskDatablockAccountServiceTemp.push(newRec);
        }
        else if(recordType == 'input_RiskDatablockAccountService') {
            $scope.input_RiskDatablockAccountService.push(newRec);
            $scope.input_RiskDatablockAccountServiceTemp.push(newRec);
        }
    }
    function checkBlank(records) {
        console.log('records ::' +records);
        for (var i = records.length - 1 ; i >= 0; i--) {                       
            if (records[i].name == "" || records[i].name == '--None--' || records[i].value == '--None--' || records[i].value == '' ) {
                records.splice(i, 1);
            }
        //Start Issue - "Output field mapped and loader issue"
            if (records[i] != null && records[i].value != "" && records[i].value != '--None--' ) {
                records[i].value = records[i].value.replace('&amp;', '&');
            }
        //End Issue - "Output field mapped and loader issue"            
        }
        return records;
    } 
    $scope.removeRow = function (record, objType) {

        if (objType == 'Account') {
            var index = $scope.recordAccount.indexOf(record);
            if (index >= 0){
                $scope.recordAccount.splice(index, 1);
                $scope.recordAccountTemp.splice(index, 1);
            }    
        }
        if (objType == 'Contact') {
            var index = $scope.recordContact.indexOf(record);
            if (index >= 0){
                $scope.recordContact.splice(index, 1);
                $scope.recordContactTemp.splice(index, 1);
            }
        }
        if (objType == 'Output_Account') {
            var index = $scope.output_Account.indexOf(record);
            if (index >= 0){
                $scope.output_Account.splice(index, 1);
                $scope.output_AccountTemp.splice(index, 1);
            }   
        }
        if (objType == 'Output_Contact') {
            var index = $scope.output_Contact.indexOf(record);
            if (index >= 0){
                $scope.output_Contact.splice(index, 1);
                $scope.output_ContactTemp.splice(index, 1);
            }      
        }
        if (objType == 'Toolkit') {
            var index = $scope.output_toolkit.indexOf(record);
            if (index >= 0) {
                $scope.output_toolkit.splice(index, 1);
                $scope.output_ToolkitTemp.splice(index, 1);
            }
        }
        if (objType == 'ToolkitQC') {
          var index = $scope.output_toolkitQC.indexOf(record);
          if (index >= 0){
            $scope.output_toolkitQC.splice(index, 1);
            $scope.output_ToolkitQCTemp.splice(index, 1);
          }            
        }
        if (objType == 'AccountKvk') {
            var index = $scope.Mapping_AccountKvk.indexOf(record);
            if (index >= 0){
                $scope.Mapping_AccountKvk.splice(index, 1);
                $scope.Mapping_AccountKvkTemp.splice(index, 1);}
        }
        if (objType == 'AccountKvkOutFld') {
            var index = $scope.Output_AccountKvk.indexOf(record);
            if (index >= 0){
                $scope.Output_AccountKvk.splice(index, 1);
                $scope.Output_AccountKvkTemp.splice(index, 1);
            }
        }
        if (objType == 'LeadKvk') {
            var index = $scope.Mapping_LeadKvk.indexOf(record);
            if (index >= 0){
                $scope.Mapping_LeadKvk.splice(index, 1);
                $scope.Mapping_LeadKvkTemp.splice(index, 1);
            }
        }
        if (objType == 'LeadKvkOutFld') {
            var index = $scope.Output_LeadKvk.indexOf(record);
            if (index >= 0){
                $scope.Output_LeadKvk.splice(index, 1);
                $scope.Output_LeadKvkTemp.splice(index, 1);}
        }
        if (objType == 'output_LeadGlobal') {
            var index = $scope.output_LeadGlobal.indexOf(record);
            if (index >= 0){
                $scope.output_LeadGlobal.splice(index, 1);
                $scope.output_LeadGlobalTemp.splice(index, 1);}
        }
        if (objType == 'input_leadGlobal') {
            var index = $scope.recordLeadGlobal.indexOf(record);
            if (index >= 0){
                $scope.recordLeadGlobal.splice(index, 1);
                $scope.recordLeadGlobalTemp.splice(index, 1);
            }
        }
        if (objType == 'output_AccountGlobal') {
            var index = $scope.output_AccountGlobal.indexOf(record);
            if (index >= 0){
                $scope.output_AccountGlobal.splice(index, 1);
                $scope.output_AccountGlobalTemp.splice(index, 1);
            }
        }
        if (objType == 'input_AccountGlobal') {
            var index = $scope.recordAccountGlobal.indexOf(record);
            if (index >= 0){
                $scope.recordAccountGlobal.splice(index, 1);
                $scope.recordAccountGlobalTemp.splice(index, 1);
            }
        }
        if (objType == 'output_IWSAccountService') {
            var index = $scope.output_IWSAccountService.indexOf(record);
            if (index >= 0){
                $scope.output_IWSAccountService.splice(index, 1);
                $scope.output_IWSAccountServiceTemp.splice(index, 1);
            }
        } 
        if (objType == 'output_IWSAdvancedAddressAccountService') {
            var index = $scope.output_IWSAdvancedAddressAccountService.indexOf(record);
            if (index >= 0){
                $scope.output_IWSAdvancedAddressAccountService.splice(index, 1);
                $scope.output_IWSAdvancedAddressAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'output_IWSBankruptcyInfoAccountService') {
            var index = $scope.output_IWSBankruptcyInfoAccountService.indexOf(record);
            if (index >= 0){
                $scope.output_IWSBankruptcyInfoAccountService.splice(index, 1);
                $scope.output_IWSBankruptcyInfoAccountServiceTemp.splice(index, 1);
            }
        }
        
        if (objType == 'input_IWSAccountService') {
            var index = $scope.input_IWSAccountService.indexOf(record);
            if (index >= 0){
                $scope.input_IWSAccountService.splice(index, 1);
                $scope.input_IWSAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'output_IWSStdAddInfoAccountService') {
            var index = $scope.output_IWSStdAddInfoAccountService.indexOf(record);
            if (index >= 0){
                $scope.output_IWSStdAddInfoAccountService.splice(index, 1);
                $scope.output_IWSStdAddInfoAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'input_IWSStdAddInfoAccountService') {
            var index = $scope.input_IWSStdAddInfoAccountService.indexOf(record);
            if (index >= 0){
                $scope.input_IWSStdAddInfoAccountService.splice(index, 1);
                $scope.input_IWSStdAddInfoAccountService.splice(index, 1);
            }
        }
        if(objType == 'output_IWSPaydexInfoAccountService') {
            var index = $scope.output_IWSPaydexInfoAccountService.indexOf(record);
            if(index >= 0 ){
                $scope.output_IWSPaydexInfoAccountService.splice(index, 1);
                $scope.output_IWSPaydexInfoAccountServiceTemp.splice(index, 1);
            }
        }            
        if (objType == 'output_IWSBalanceSheetAccountService') {
            var index = $scope.output_IWSBalanceSheetAccountService.indexOf(record);
            if (index >= 0){
                $scope.output_IWSBalanceSheetAccountService.splice(index, 1);
                $scope.output_IWSBalanceSheetAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'input_IWSBalanceSheetAccountService') {
            var index = $scope.input_IWSBalanceSheetAccountService.indexOf(record);
            if (index >= 0){
                $scope.input_IWSBalanceSheetAccountService.splice(index, 1);
                $scope.input_IWSBalanceSheetAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'input_accountGDM') {
            var index = $scope.input_GDMAccountService.indexOf(record);
            if (index >= 0){
                $scope.input_GDMAccountService.splice(index, 1);
                $scope.input_GDMAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'output_accountGDM') {
            var index = $scope.output_GDMAccountService.indexOf(record);
            if (index >= 0){
                $scope.output_GDMAccountService.splice(index, 1);
                $scope.output_GDMAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'output_AccountTradeCredit') {
            var index = $scope.output_AccountTradeCredit.indexOf(record);
            if (index >= 0){
                $scope.output_AccountTradeCredit.splice(index, 1);
                $scope.output_AccountTradeCreditTemp.splice(index, 1);
            }
        }
        if (objType == 'output_IWSRiskInfoAccountService') {
            var index = $scope.output_IWSRiskInfoAccountService.indexOf(record);
            if (index >= 0){
                $scope.output_IWSRiskInfoAccountService.splice(index, 1);
                $scope.output_IWSRiskInfoAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'input_IWSRiskInfoAccountService') {
            var index = $scope.input_IWSRiskInfoAccountService.indexOf(record);
            if (index >= 0){
                $scope.input_IWSRiskInfoAccountService.splice(index, 1);
                $scope.input_IWSRiskInfoAccountServiceTemp.splice(index, 1);
            }
        }

        if (objType == 'output_IndueDService' ) {
            var index = $scope.output_IndueDService.indexOf(record);
            if (index >= 0){
                $scope.output_IndueDService.splice(index, 1);
                $scope.output_IndueDServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'input_IndueDService') {
            var index = $scope.input_IndueDService.indexOf(record);
            if (index >= 0){
                $scope.input_IndueDService.splice(index, 1);
                $scope.input_IndueDServiceTemp.splice(index, 1);
            }
        }
        //Risk Datablock Service
        if (objType == 'output_RiskDatablockAccountService' ) {
            var index = $scope.output_RiskDatablockAccountService.indexOf(record);
            if (index >= 0){
                $scope.output_RiskDatablockAccountService.splice(index, 1);
                $scope.output_RiskDatablockAccountServiceTemp.splice(index, 1);
            }
        }
        if (objType == 'input_RiskDatablockAccountService') {
            var index = $scope.input_RiskDatablockAccountService.indexOf(record);
            if (index >= 0){
                $scope.input_RiskDatablockAccountService.splice(index, 1);
                $scope.input_RiskDatablockAccountServiceTemp.splice(index, 1);
            }
        }
    }
    $scope.CancelMapping = function (typeOfMapping) {
        if (typeOfMapping == 'Contact'){
            $scope.recordContactTemp = checkBlank($scope.recordContactTemp);
            $scope.recordContact = angular.copy($scope.recordContactTemp);
        }
        if (typeOfMapping == 'Account'){
            $scope.recordAccountTemp = checkBlank($scope.recordAccountTemp);
            $scope.recordAccount = angular.copy($scope.recordAccountTemp);
        }
        if (typeOfMapping == 'Output_Account'){
            $scope.output_AccountTemp = checkBlank($scope.output_AccountTemp);
            $scope.output_Account = angular.copy($scope.output_AccountTemp);
        }
        if (typeOfMapping == 'Output_Contact'){
            $scope.output_ContactTemp = checkBlank($scope.output_ContactTemp);
            $scope.output_Contact = angular.copy($scope.output_ContactTemp);
        }
        if (typeOfMapping == 'Toolkit'){
            $scope.output_ToolkitTemp = checkBlank($scope.output_ToolkitTemp);
            $scope.output_toolkit = angular.copy($scope.output_ToolkitTemp);
        }
        if (typeOfMapping == 'ToolkitQC'){
            $scope.output_ToolkitQCTemp = checkBlank($scope.output_ToolkitQCTemp);
            $scope.output_toolkitQC = angular.copy($scope.output_ToolkitQCTemp);
        }
        if (typeOfMapping == 'AccountKvk'){
            $scope.Mapping_AccountKvkTemp = checkBlank($scope.Mapping_AccountKvkTemp);
            $scope.Mapping_AccountKvk = angular.copy($scope.Mapping_AccountKvkTemp);
        }            
        if (typeOfMapping == 'AccountKvkOutFld'){
            $scope.Output_AccountKvkTemp = checkBlank($scope.Output_AccountKvkTemp);
            $scope.Output_AccountKvk = angular.copy($scope.Output_AccountKvkTemp);
        }
        if (typeOfMapping == 'LeadKvk'){
            $scope.Mapping_LeadKvkTemp = checkBlank($scope.Mapping_LeadKvkTemp);
            $scope.Mapping_LeadKvk = angular.copy($scope.Mapping_LeadKvkTemp);
        }            
        if (typeOfMapping == 'LeadKvkOutFld'){
            $scope.Output_LeadKvkTemp = checkBlank($scope.Output_LeadKvkTemp);
            $scope.Output_LeadKvk = angular.copy($scope.Output_LeadKvkTemp);
        }            
        if (typeOfMapping == 'output_LeadGlobal'){
            $scope.output_LeadGlobalTemp = checkBlank($scope.output_LeadGlobalTemp);
            $scope.output_LeadGlobal = angular.copy($scope.output_LeadGlobalTemp);
        }            
        if (typeOfMapping == 'input_leadGlobal'){
            $scope.recordLeadGlobalTemp = checkBlank($scope.recordLeadGlobalTemp);
            $scope.recordLeadGlobal = angular.copy($scope.recordLeadGlobalTemp);
        }            
        if (typeOfMapping == 'output_AccountGlobal'){
            $scope.output_AccountGlobalTemp = checkBlank($scope.output_AccountGlobalTemp);
            $scope.output_AccountGlobal = angular.copy($scope.output_AccountGlobalTemp);
        }   
        if (typeOfMapping == 'output_AccountTradeCredit'){
            $scope.output_AccountTradeCreditTemp = checkBlank($scope.output_AccountTradeCredit);
            $scope.output_AccountTradeCredit = angular.copy($scope.output_AccountTradeCreditTemp);
        }            
        if (typeOfMapping == 'input_AccountGlobal'){
            $scope.recordAccountGlobalTemp = checkBlank($scope.recordAccountGlobalTemp);
            $scope.recordAccountGlobal = angular.copy($scope.recordAccountGlobalTemp);
        } 
        if (typeOfMapping == 'output_IWSAccountService'){
            $scope.output_IWSAccountServiceTemp = checkBlank($scope.output_IWSAccountServiceTemp);
            $scope.output_IWSAccountService = angular.copy($scope.output_IWSAccountServiceTemp);
        }
        if (typeOfMapping == 'output_IWSAdvancedAddressAccountService'){
            $scope.output_IWSAdvancedAddressAccountServiceTemp = checkBlank($scope.output_IWSAdvancedAddressAccountServiceTemp);
            $scope.output_IWSAdvancedAddressAccountService = angular.copy($scope.output_IWSAdvancedAddressAccountServiceTemp);
        } 
        if (typeOfMapping == 'output_IWSBankruptcyInfoAccountService'){
            $scope.output_IWSBankruptcyInfoAccountServiceTemp = checkBlank($scope.output_IWSBankruptcyInfoAccountServiceTemp);
            $scope.output_IWSBankruptcyInfoAccountService = angular.copy($scope.output_IWSBankruptcyInfoAccountServiceTemp);
        }
        if (typeOfMapping == 'input_IWSAccountService'){
            $scope.input_IWSAccountServiceTemp = checkBlank($scope.input_IWSAccountServiceTemp);
            $scope.input_IWSAccountService = angular.copy($scope.input_IWSAccountService);
        }
        if (typeOfMapping == 'output_IWSStdAddInfoAccountService'){
            $scope.output_IWSStdAddInfoAccountServiceTemp = checkBlank($scope.output_IWSStdAddInfoAccountServiceTemp);
            $scope.output_IWSStdAddInfoAccountService = angular.copy($scope.output_IWSStdAddInfoAccountServiceTemp);
        }
        if (typeOfMapping == 'input_IWSStdAddInfoAccountService'){
            $scope.input_IWSStdAddInfoAccountServiceTemp = checkBlank($scope.input_IWSStdAddInfoAccountServiceTemp);
            $scope.input_IWSStdAddInfoAccountService = angular.copy($scope.input_IWSStdAddInfoAccountServiceTemp);
        } 
        if (typeOfMapping == 'output_IWSPaydexInfoAccountService') {
            $scope.output_IWSPaydexInfoAccountServiceTemp = checkBlank($scope.output_IWSPaydexInfoAccountServiceTemp);
            $scope.output_IWSPaydexInfoAccountService = angular.copy($scope.output_IWSPaydexInfoAccountServiceTemp);
        }
        if (typeOfMapping == 'input_IWSPaydexInfoAccountService'){
            $scope.input_IWSPaydexInfoAccountServiceTemp = checkBlank($scope.input_IWSPaydexInfoAccountServiceTemp);
            $scope.input_IWSPaydexInfoAccountService = angular.copy($scope.input_IWSPaydexInfoAccountServiceTemp);
        } 
        if (typeOfMapping == 'output_IWSBalanceSheetAccountService'){
            $scope.output_IWSBalanceSheetAccountServiceTemp = checkBlank($scope.output_IWSBalanceSheetAccountServiceTemp);
            $scope.output_IWSBalanceSheetAccountService = angular.copy($scope.output_IWSBalanceSheetAccountServiceTemp);
        }
        if (typeOfMapping == 'input_IWSBalanceSheetAccountService'){
            $scope.input_IWSBalanceSheetAccountServiceTemp = checkBlank($scope.input_IWSBalanceSheetAccountService);
            $scope.input_IWSBalanceSheetAccountService = angular.copy($scope.input_IWSBalanceSheetAccountService);
        }
        if (typeOfMapping == 'input_accountGDM'){
            $scope.input_GDMAccountServiceTemp = checkBlank($scope.input_GDMAccountServiceTemp);
            $scope.input_GDMAccountService = angular.copy($scope.input_GDMAccountServiceTemp);
            
        }   
        if (typeOfMapping == 'output_accountGDM'){
            $scope.output_GDMAccountServiceTemp = checkBlank($scope.output_GDMAccountServiceTemp);
            $scope.output_GDMAccountService = angular.copy($scope.output_GDMAccountServiceTemp);
            
        } 
        if (typeOfMapping == 'output_IWSRiskInfoAccountService'){
            $scope.output_IWSRiskInfoAccountServiceTemp = checkBlank($scope.output_IWSRiskInfoAccountServiceTemp);
            $scope.output_IWSRiskInfoAccountService = angular.copy($scope.output_IWSRiskInfoAccountServiceTemp);
        }
        if (typeOfMapping == 'input_IWSRiskInfoAccountService'){
            $scope.input_IWSRiskInfoAccountServiceTemp = checkBlank($scope.input_IWSRiskInfoAccountServiceTemp);
            $scope.input_IWSRiskInfoAccountService = angular.copy($scope.input_IWSRiskInfoAccountServiceTemp);
        }      
        if (typeOfMapping == 'input_IndueDService'){
            $scope.input_IndueDServiceTemp = checkBlank($scope.input_IndueDServiceTemp);
            $scope.input_IndueDService = angular.copy($scope.input_IndueDServiceTemp);
        } 
        if (typeOfMapping == 'output_IndueDService'){
            $scope.output_IndueDServiceTemp = checkBlank($scope.output_IndueDServiceTemp);
            $scope.output_IndueDService = angular.copy($scope.output_IndueDServiceTemp);
        }
        //Risk Datablock Service
        if (typeOfMapping == 'output_RiskDatablockAccountService'){
            $scope.output_RiskDatablockAccountServiceTemp = checkBlank($scope.output_RiskDatablockAccountServiceTemp);
            $scope.output_RiskDatablockAccountService = angular.copy($scope.output_RiskDatablockAccountServiceTemp);
        }
        if (typeOfMapping == 'input_RiskDatablockAccountService'){
            $scope.input_RiskDatablockAccountServiceTemp = checkBlank($scope.input_RiskDatablockAccountServiceTemp);
            $scope.input_RiskDatablockAccountService = angular.copy($scope.input_RiskDatablockAccountServiceTemp);
        }
    }
    $scope.changeFierldType = function (fieldType, objRecord, serviceType) {
        $scope.recordPicklist = [];
        $scope.recordBooleanlist = [];
        if (fieldType.PICKLIST != null) {
            objRecord.Type = 'text';
            $scope.IsPicklist = true;
            $scope.IsBoolean = false;
            angular.forEach(fieldType.PICKLIST, function (objPick, key) {
                $scope.recordPicklist.push({ 'Name': objPick });
            })
        }
        else if (fieldType.BOOLEAN != null) {
            objRecord.Type = 'boolean';
            $scope.IsPicklist = false;
            $scope.IsBoolean = true;
            angular.forEach(fieldType.BOOLEAN, function (objBool, key) {
                $scope.recordBooleanlist.push({ 'Name': objBool });
            })
        }
        else if (fieldType.STRING != null)
            objRecord.Type = 'text';
        else if (fieldType.DATE != null)
            objRecord.Type = 'date';
        else if (fieldType.DATETIME != null)
            objRecord.Type = 'datetime-local';
        else if (fieldType.DOUBLE != null)
            objRecord.Type = 'number';
        else if (fieldType.PHONE != null)
            objRecord.Type = 'text';
        else if (fieldType.CURRENCY != null)
            objRecord.Type = 'number';
        else if (fieldType.URL != null)
            objRecord.Type = 'url';
        else if (fieldType.EMAIL != null)
            objRecord.Type = 'email';
        else
            objRecord.Type = 'text';
        if (serviceType == 'Vat_Criteria') {
            angular.forEach($scope.vatCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'Credit_Criteria') {
            angular.forEach($scope.creditCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'Toolkit_Criteria') {
            angular.forEach($scope.toolkitCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'ToolkitQC_Criteria') {
          angular.forEach($scope.toolkitQCCriteriaArray, function (value, key) {
            if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
              value.IsReference = true;
            } else {
              value.IsReference = false;
            }
          })
        }
        if (serviceType == 'Account_Criteria') {
            angular.forEach($scope.accCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'Contact_Criteria') {
            angular.forEach($scope.conCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'Accountkvk_Criteria') {
            angular.forEach($scope.accountKvkCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'Leadkvk_Criteria') {
            angular.forEach($scope.leadKvkCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'LeadGlobal_Criteria') {
            angular.forEach($scope.leadGlobalCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'AccountGDM_Criteria') {
            angular.forEach($scope.accountGDMCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'AccountGlobal_Criteria') {
            angular.forEach($scope.accountGlobalCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'IWS_Criteria') {
            angular.forEach($scope.iwsCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'IWSStdAddInfo_Criteria') {
            angular.forEach($scope.iwsStdAddInfoCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }

        //Start IWS Paydex Information Service
        if(serviceType == 'IWSPaydexInfo_Criteria') {
            angular.forEach($scope.iwsPaydexInfoCriteriaArray, function (value, key) {
                if(value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        //Start IWS Bankruptcy Information Service
        if (serviceType == 'IWSBankruptcyInfo_Criteria') {
            angular.forEach($scope.iwsBankruptcyInfoCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        //End IWS Bankruptcy Information Service

        // Start IWS Advanced Address Information Service
        if (serviceType == 'IWSAdvanced_Criteria') {
            angular.forEach($scope.iwsAdvancedAddressCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        // End IWS Advanced Address Information Service

        //Start IWS Risk Information Service
        if(serviceType == 'IWSRiskInfo_Criteria') {
            angular.forEach($scope.iwsRiskInfoCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        // End IWS Risk Information Service

        //Start Risk Datablock Service
        if(serviceType == 'RiskDatablock_Criteria') {
            angular.forEach($scope.riskDatablockServiceCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        // End Risk Datablock Service
        //Start Company Report Service
        if(serviceType == 'CompanyReport_Criteria') {
            angular.forEach($scope.companyReportServiceCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        //End Company Report Service

        //Start IndueD Services
        if(serviceType == 'IndueDService_Criteria') {
            angular.forEach($scope.indueDserviceCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }

        //End IndueD Services

        if (serviceType == 'AccountTradeCredit_Criteria') {
            angular.forEach($scope.accountTradeCreditCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
        if (serviceType == 'AccountGDM_Criteria') {
            angular.forEach($scope.accountTradeCreditCriteriaArray, function (value, key) {
                if (value.Id == objRecord.Id && (fieldType.PICKLIST != null || fieldType.BOOLEAN != null)) {
                    value.IsReference = true;
                } else {
                    value.IsReference = false;
                }
            })
        }
    }

    $scope.updateField = function (fieldName, objectName, objRecord) {
        $loader.showProcessing();
        if ((fieldName == '--None--' && objRecord.Operator != '--None--') || (fieldName == '--None--' && objRecord.Operator == '--None--') || (fieldName != '--None--' && objRecord.Operator != '--None--')){
            if(objRecord.Operator != '--None--'){
                objRecord.Value = '';
                objRecord.Operator = '--None--';
            }
            else
                $scope.updateRecordOperator(objRecord);
        }
            
        if (fieldName != '--None--') {
            objRecord.Value = '';
            API_Connector.Engine.getFieldType(fieldName, objectName, function (fieldType, event) {
                if (fieldType != null) {
                    // VAT Number Check
                    if ($scope.serviceName.Name == $scope.serviceListObject.VAT) {

                        $scope.changeFierldType(fieldType, objRecord, 'Vat_Criteria');
                    }
                    // IWS Service
                    if ($scope.serviceName.Name == $scope.serviceListObject.IWS_SERVICE) {

                        $scope.changeFierldType(fieldType, objRecord, 'IWS_Criteria');
                    }
                    // IWS Advanced Address Service
                    if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Advanced_Address_Information_Service) {
                        $scope.changeFierldType(fieldType, objRecord, 'IWSAdvanced_Criteria');
                    }
                    // Start IWS Bankruptcy Information Service
                    if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Bankruptcy_Information_Service) {
                        $scope.changeFierldType(fieldType, objRecord, 'IWSBankruptcyInfo_Criteria');
                    }
                    //IWS Paydex Information Service
                    if($scope.serviceName.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION){
                        $scope.changeFierldType(fieldType, objRecord, 'IWSPaydexInfo_Criteria');
                    }    
                    // IWS Risk Information Service
                    if ($scope.serviceName.Name == $scope.serviceListObject.IWS_RISK_INFORMATION) {
                        $scope.changeFierldType(fieldType, objRecord, 'IWSRiskInfo_Criteria');
                    }

                    //IndueD Service
                    if ($scope.serviceName.Name == $scope.serviceListObject.INDUED_SERVICE) {
                        $scope.changeFierldType(fieldType, objRecord, ' IndueDService_Criteria');
                    }

                    //Credit Check 
                    if ($scope.serviceName.Name == $scope.serviceListObject.CREDIT_CHECK) {
                        $scope.changeFierldType(fieldType, objRecord, 'Credit_Criteria');
                    }
                    //toolkit management  
                    if ($scope.serviceName.Name == $scope.serviceListObject.ENTERPRISE) {

                        $scope.changeFierldType(fieldType, objRecord, 'Toolkit_Criteria');
                    }
                    //toolkit Quick Check  
                      if ($scope.serviceName.Name == $scope.serviceListObject.QUICK) {

                        $scope.changeFierldType(fieldType, objRecord, 'ToolkitQC_Criteria');
                      }

                    //Lead Duplication Check - Account
                    if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_DUPLICATE) {
                        $scope.changeFierldType(fieldType, objRecord, 'Account_Criteria');
                    }
                    //Lead Duplication Check - Contact
                    if ($scope.serviceName.Name == $scope.serviceListObject.CONTACT_DUPLICATE) {
                        $scope.changeFierldType(fieldType, objRecord, 'Contact_Criteria');
                    }
                    if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_KVK) {
                        $scope.changeFierldType(fieldType, objRecord, 'Accountkvk_Criteria');
                    }
                    if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_KVK ) {
                        $scope.changeFierldType(fieldType, objRecord, 'Leadkvk_Criteria');
                    }
                    if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_GLOBAL ) {
                        $scope.changeFierldType(fieldType, objRecord, 'LeadGlobal_Criteria');
                    }
                    if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_GLOBAL ) {
                        $scope.changeFierldType(fieldType, objRecord, 'AccountGlobal_Criteria');
                    }
                    if ($scope.serviceName.Name == $scope.serviceListObject.GLOBAL_DECISION_MAKER ) {
                        $scope.changeFierldType(fieldType, objRecord, 'AccountGDM_Criteria');
                    }
                }
                $timeout(function () {
                    $loader.hideProcessing();
                }, 4000);
            })
        } else {
                    objRecord.Type = 'text';
            objRecord.IsReference = false;
            $timeout(function () {
                $loader.hideProcessing();
            }, 4000);
        }

    }
    $scope.updateRecordOperator = function (objRecord) {
        if (objRecord.Operator == 'changed'){
            objRecord.Value = '';
            objRecord.Type = 'text';
        }
        if(objRecord.Operator != 'changed'){
            if($scope.serviceName.Name != null || $scope.serviceName.Name != undefined){
                var input = $scope.serviceName.Name;
                var fields = input.split('| ');
                var street = fields[1];
                var objectName = street.split('object'); 
                if(objectName[0].indexOf('Account') >= 0){
                    objectName[0] = 'Account';
                }
                else if(objectName[0].indexOf('Lead') >= 0){
                    objectName[0] = 'Lead';
                }
                if (objRecord.Field != '--None--') {
                    objRecord.Value = '';
                    $loader.showProcessing();
                    API_Connector.Engine.getFieldType(objRecord.Field, objectName[0], function (fieldType, event) {
                        if (fieldType != null) {
                            // VAT Number Check
                            if ($scope.serviceName.Name == $scope.serviceListObject.VAT) {
        
                                $scope.changeFierldType(fieldType, objRecord, 'Vat_Criteria');
                            }
                            // IWS Service
                             if ($scope.serviceName.Name == $scope.serviceListObject.IWS_SERVICE) {
                             $scope.changeFierldType(fieldType, objRecord, 'IWS_Criteria');
                             }

                             // IWS Risk Information Service
                            if ($scope.serviceName.Name == $scope.serviceListObject.IWS_RISK_INFORMATION) {
                                $scope.changeFierldType(fieldType, objRecord, 'IWSRiskInfo_Criteria');
                            }
                            
                             // IWS Advanced Address Service
                             if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Advanced_Address_Information_Service) {
                                $scope.changeFierldType(fieldType, objRecord, 'IWSAdvanced_Criteria');
                            }
                            // Start IWS Bankruptcy Information Service
                            if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Bankruptcy_Information_Service) {
                                $scope.changeFierldType(fieldType, objRecord, 'IWSBankruptcyInfo_Criteria');
                            }
                            // End IWS Bankruptcy Information Service
                            //Start IWS Paydex Information Service
                            if($scope.serviceName.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION){
                                $scope.changeFierldType(fieldType, objRecord, 'IWSPaydexInfo_Criteria');
                            }
                            //End IWS Paydex Information Service

                            //Start IndueD Service
                            if($scope.serviceName.Name == $scope.serviceListObject.INDUED_SERVICE){
                                $scope.changeFierldType(fieldType, objRecord, 'IndueDService_Criteria');
                            }
                            //End IndueD Service

                            //Credit Check 
                            if ($scope.serviceName.Name == $scope.serviceListObject.CREDIT_CHECK) {
                                $scope.changeFierldType(fieldType, objRecord, 'Credit_Criteria');
                            }
                            //toolkit management  
                            if ($scope.serviceName.Name == $scope.serviceListObject.ENTERPRISE) {
        
                                $scope.changeFierldType(fieldType, objRecord, 'Toolkit_Criteria');
                            }
                            //toolkit Quick Check  
                              if ($scope.serviceName.Name == $scope.serviceListObject.QUICK) {
        
                                $scope.changeFierldType(fieldType, objRecord, 'ToolkitQC_Criteria');
                              }
        
                            //Lead Duplication Check - Account
                            if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_DUPLICATE) {
                                $scope.changeFierldType(fieldType, objRecord, 'Account_Criteria');
                            }
                            //Lead Duplication Check - Contact
                            if ($scope.serviceName.Name == $scope.serviceListObject.CONTACT_DUPLICATE) {
                                $scope.changeFierldType(fieldType, objRecord, 'Contact_Criteria');
                            }
                            if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_KVK) {
                                $scope.changeFierldType(fieldType, objRecord, 'Accountkvk_Criteria');
                            }
                            if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_KVK ) {
                                $scope.changeFierldType(fieldType, objRecord, 'Leadkvk_Criteria');
                            }
                            if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_GLOBAL ) {
                                $scope.changeFierldType(fieldType, objRecord, 'LeadGlobal_Criteria');
                            }
                            if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_GLOBAL ) {
                                $scope.changeFierldType(fieldType, objRecord, 'AccountGlobal_Criteria');
                            }
                            if ($scope.serviceName.Name == $scope.serviceListObject.GLOBAL_DECISION_MAKER ) {
                                $scope.changeFierldType(fieldType, objRecord, 'AccountGDM_Criteria');
                            }
                        }
                        $timeout(function () {
                            $loader.hideProcessing();
                        }, 4000);
                    })
                } else {
                    objRecord.Value = '';
                    objRecord.Type = 'text';
                    objRecord.IsReference = false;
                    $timeout(function () {
                        $loader.hideProcessing();
                    }, 4000);
                }
            }
        }
       
        
        //Lead Duplication Check - Account
        if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_DUPLICATE) {

            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsAccError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsAccError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsAccError = false;
                objRecord.IsError = false;
            }
        }
        //Lead Duplication Check - Contact
        if ($scope.serviceName.Name == $scope.serviceListObject.CONTACT_DUPLICATE) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsConError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsConError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsConError = false;
                objRecord.IsError = false;
            }
        }
        //Credit Check
        if ($scope.serviceName.Name == $scope.serviceListObject.CREDIT_CHECK) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsCreditError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsCreditError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsCreditError = false;
                objRecord.IsError = false;
            }
        }

        //toolkit management
        if ($scope.serviceName.Name == $scope.serviceListObject.ENTERPRISE) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsToolkitError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsToolkitError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsToolkitError = false;
                objRecord.IsError = false;
            }
        }
      //toolkit Quick check
        if ($scope.serviceName.Name == $scope.serviceListObject.QUICK) {
          if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
            $scope.IsToolkitQCError = true;
            objRecord.IsError = true;
          }
          else {
            $scope.IsToolkitQCError = false;
            objRecord.IsError = false;
          }
          if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
            $scope.IsToolkitQCError = false;
            objRecord.IsError = false;
          }
        }
        //dutch chamber account
        if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_KVK) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsAccKvkError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsAccKvkError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsAccKvkError = false;
                objRecord.IsError = false;
            }
        }
        //dutch chamber lead
        if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_KVK ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsLeadKvkError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsLeadKvkError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsLeadKvkError = false;
                objRecord.IsError = false;
            }
        }
        //VAT Number Check
        if ($scope.serviceName.Name == $scope.serviceListObject.VAT) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsVatError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsVatError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsVatError = false;
                objRecord.IsError = false;
            }
        }
        //Lead Global Match
        if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_GLOBAL ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsLeadGlobalError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsLeadGlobalError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsLeadGlobalError = false;
                objRecord.IsError = false;
            }
        }
        //Account Global Match
        if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_GLOBAL ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsAccountGlobalError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsAccountGlobalError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsAccountGlobalError = false;
                objRecord.IsError = false;
            }
        }
         //IWS Service
         if ($scope.serviceName.Name == $scope.serviceListObject.IWS_SERVICE ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsAccountIwsError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsAccountIwsError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsAccountIwsError = false;
                objRecord.IsError = false;
            }
        }
        //IWS StandardAddress Information Service
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_STANDARD_ADDRESS_INFORMATION ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.isIWSStdAddInfoServiceError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.isIWSStdAddInfoServiceError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.isIWSStdAddInfoServiceError = false;
                objRecord.IsError = false;
            }
        }

        //IndueD Service
        if ($scope.serviceName.Name == $scope.serviceListObject.INDUED_SERVICE ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.isIndueDServiceError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.isIndueDServiceError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.isIndueDServiceError = false;
                objRecord.IsError = false;
            }
        }
        //IWS Paydex Information Service 
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.isIWSPaydexInfoServiceError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.isIWSPaydexInfoServiceError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.isIWSPaydexInfoServiceError = false;
                objRecord.IsError = false;
            }
        }

         //IWS Risk Information Service
         if ($scope.serviceName.Name == $scope.serviceListObject.IWS_RISK_INFORMATION ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.isIWSRiskInfoServiceError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.isIWSRiskInfoServiceError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.isIWSRiskInfoServiceError = false;
                objRecord.IsError = false;
            }
        }
        //IWS Advanced Address Service
         if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Advanced_Address_Information_Service ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsAccountIwsAdvancedAddressError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsAccountIwsAdvancedAddressError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsAccountIwsAdvancedAddressError = false;
                objRecord.IsError = false;
            }
        }
         //Start IWS Bankruptcy Information Service
         if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Bankruptcy_Information_Service) {            
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsAccountIwsBankruptcyInfoError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsAccountIwsBankruptcyInfoError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsAccountIwsBankruptcyInfoError = false;
                objRecord.IsError = false;
            }
        }
         //GDM Service
         if ($scope.serviceName.Name == $scope.serviceListObject.GLOBAL_DECISION_MAKER ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsAccountGDMError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsAccountGDMError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsAccountGDMError = false;
                objRecord.IsError = false;
            }
        }
        if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_TRADE ) {
            if ((objRecord.Field != '--None--' && objRecord.Operator == '--None--') || (objRecord.Field == '--None--' && objRecord.Operator != '--None--')) {
                $scope.IsAccountTradeCreditError = true;
                objRecord.IsError = true;
            }
            else {
                $scope.IsAccountTradeCreditError = false;
                objRecord.IsError = false;
            }
            if (objRecord.Field == '--None--' && objRecord.Operator == '--None--') {
                $scope.IsAccountTradeCreditError = false;
                objRecord.IsError = false;
            }
        }
    }
    $scope.pushLookUpValue = function () {

        if ($scope.IsPicklist) {
            $scope.selectedRecord.Value = '';
            angular.forEach($scope.recordPicklist, function (value, key) {
                if (value.selected)
                    $scope.selectedRecord.Value = value.Name;
                //$scope.selectedRecord.Value += value.Name +',';

            })
        }
        if ($scope.IsBoolean)
            $scope.selectedRecord.Value = $scope.IsChecked.Name;
        $scope.showModel = false;
    }
    $scope.showFilterLogic = function (addOrRemoveText) {
        if ($scope.IsFilterLogic == false)
            $scope.IsFilterLogic = true;
        else
            $scope.IsFilterLogic = false;
    }
    $scope.showHidePassword = function () {
        if ($scope.IsShowPassword) {
            $scope.IsShowPassword = false;
            $scope.typePassword = 'text';
        }

        else {
            $scope.typePassword = 'password';
            $scope.IsShowPassword = true;
        }

    }
    //validation for logic filter
    $scope.isValidLogicalStatement = function (text) {
        if (text) {
            var noSpecialChars = /^[a-z A-Z()1-5]*$/;
            if (noSpecialChars.test(text)) {
                $scope.specialCharsFound = false;
                var re_paren = /\(\s*[+-]?\d+(?:(?:\s+AND\s+[+-]?\d+)+|(?:\s+OR\s+[+-]?\d+)+)\s*\)/ig;
                var re_valid = /^\s*[+-]?\d+(?:(?:\s+AND\s+[+-]?\d+)+|(?:\s+OR\s+[+-]?\d+)+)\s*$/ig;
                while (text.search(re_paren) !== -1) {
                    // Iterate from the inside out. 
                    text = text.replace(re_paren, "0"); // Replace innermost parenthesized units with integer. 
                }
                $scope.invalidLogic = !(text.search(re_valid) === 0);
            } else {
                $scope.invalidLogic = true;
                $scope.specialCharsFound = true;
            }
        } else $scope.invalidLogic = false;
    };
    $scope.saveServiceCall = function (lstRecord, serviceType) {
        /*if (lstRecord[0].Field == '--None--' && lstRecord[1].Field == '--None--' && lstRecord[2].Field == '--None--' && lstRecord[3].Field == '--None--' && lstRecord[4].Field == '--None--') {
            if (serviceType == 'Credit_Criteria')
                $scope.IsCreditError = true;
            if (serviceType == 'Toolkit_Criteria')
              $scope.IsToolkitError = true;
            if (serviceType == 'ToolkitQC_Criteria')
              $scope.IsToolkitQCError = true;
            if (serviceType == 'Account_Criteria')
                $scope.IsAccError = true;
            if (serviceType == 'Contact_Criteria')
                $scope.IsConError = true;
            if (serviceType == 'Vat_Criteria') 
                $scope.IsVatError = true;
            if (serviceType == 'AccountKvk_Criteria')
                $scope.IsAccKvkError = true;
            if (serviceType == 'LeadKvk_Criteria')
                $scope.IsLeadKvkError = true;

            toaster.pop('error', "error", "Please select at least one criteria");
            $loader.hideProcessing();
        }
        */
       angular.forEach(lstRecord, function (value, key) {
            if (value.Field != '--None--' && value.Operator == '--None--')
                value.IsError = true;
            if (value.Type == 'date' && value.Value != undefined) {
                var dDate = $scope.formatDate(value.Value);
                value.Value = dDate;
            }
            if (value.Type == 'datetime-local' && value.Value != undefined) {
                var d = new Date(value.Value);
                value.Value = d;
                value.Type = 'datetime';
            }
            if (value.Field != '--None--')
                if (value.Id == '1')
                    $scope.customLogicFilter.Name = '1' + ' ';
                else
                    $scope.customLogicFilter.Name += 'OR' + ' ' + value.Id + ' ';


            if (value.IsError) {
                if (serviceType == 'Credit_Criteria')
                    $scope.IsCreditError = true;
                if (serviceType == 'Toolkit_Criteria')
                  $scope.IsToolkitError = true;
                if (serviceType == 'ToolkitQC_Criteria')
                  $scope.IsToolkitQCError = true;
                if (serviceType == 'Account_Criteria')
                    $scope.IsAccError = true;
                if (serviceType == 'Contact_Criteria')
                    $scope.IsConError = true;
                if (serviceType == 'Vat_Criteria')
                    $scope.IsVatError = true;
                if (serviceType == 'AccountKvk_Criteria')
                    $scope.IsAccKvkError = true;
                if (serviceType == 'LeadKvk_Criteria')
                    $scope.IsLeadKvkError = true;
                if (serviceType == 'LeadGlobal_Criteria')
                    $scope.IsLeadGlobalError = true;
                if (serviceType == 'AccountGlobal_Criteria')
                    $scope.IsAccountGlobalError = true;
                if (serviceType == 'AccountIWS_Criteria')
                    $scope.IsAccountIwsError = true;
                if (serviceType == 'AccountIWSAdvanced_Criteria')
                    $scope.IsAccountIwsAdvancedAddressError = true;
                if (serviceType == 'AccountIWSBankruptcy_Criteria')
                    $scope.IsAccountIwsBankruptcyInfoError = true; 
                if (serviceType == 'AccountTradeCredit_Criteria')
                    $scope.IsAccountTradeCreditError = true;
                if (serviceType == 'AccountGDM_Criteria')
                    $scope.IsAccountGDMError = true;
                if (serviceType == 'AccountIWSStdAddInfo_Criteria')
                    $scope.isIWSStdAddInfoServiceError = true;
                if (serviceType == 'AccountIWSPaydexInfo_Criteria')
                    $scope.isIWSPaydexInfoServiceError = true;
                if (serviceType == 'AccountIWSRiskInfo_Criteria')
                    $scope.isIWSRiskInfoServiceError = true;    
                if (serviceType == 'AccountIWSBalanceSheet_Criteria')
                    $scope.isIWSBalanceSheetServiceError = true;
                if (serviceType == 'AccountIndueD_Criteria')    
                    $scope.isIndueDServiceError = true;
                if (serviceType == 'AccountRiskDatablock_Criteria')
                    $scope.IsAccountRiskDatablockServiceInfoError = true;   
                if (serviceType == 'AccountCompanyReport_Criteria')
                $scope.IsAccountCompanyReportServiceInfoError = true;  
            }

        })
        if (!$scope.IsCreditError && serviceType == 'Credit_Criteria') {
            $scope.creditCriteriaArray = lstRecord;
            angular.forEach($scope.creditCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                delete value.IsError;
            })
            $scope.saveCreditCheck();
        }
        else if (!$scope.IsToolkitError && serviceType == 'Toolkit_Criteria') {
            $scope.toolkitCriteriaArray = lstRecord;
            angular.forEach($scope.toolkitCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                delete value.IsError;
            })
            $scope.saveToolkit();
        }
        else if (!$scope.IsToolkitQCError && serviceType == 'ToolkitQC_Criteria') {
          $scope.toolkitQCCriteriaArray = lstRecord;
          angular.forEach($scope.toolkitQCCriteriaArray, function (value, key) {
            if(value.Field == '--None--')
            value.Type = 'text';
            delete value.IsError;
          })
          $scope.saveToolkitQuickCheck();
        }
        else if (!$scope.IsAccKvkError && serviceType == 'AccountKvk_Criteria') {
            $scope.accountKvkCriteriaArray = lstRecord;
            angular.forEach($scope.accountKvkCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                delete value.IsError;
            })
            $scope.saveAccountKvk();
        }
        else if (!$scope.IsLeadKvkError && serviceType == 'LeadKvk_Criteria') {
            $scope.leadKvkCriteriaArray = lstRecord;
            angular.forEach($scope.leadKvkCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                delete value.IsError;
            })
            $scope.saveLeadKvk();
        }
        else if (!$scope.IsAccError && serviceType == 'Account_Criteria') {
            $scope.accCriteriaArray = lstRecord;
            if ($scope.customLogicFilter.Name != '')
                var custlogic = $scope.customLogicFilter.Name;
            else
                var custlogic = $scope.accFilterlogic.Name;
            var newCustLogic = '';

            angular.forEach($scope.accCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;
            })
            $scope.saveAccountMapping($scope.recordAccount, $scope.output_Account, $scope.caseKeyRecord);
            $scope.saveInfo('Account');
            toaster.pop('success', "Success", "Lead Duplication Check - Account Service Save Successfully.");
        }
        else if (!$scope.IsConError && serviceType == 'Contact_Criteria') {
            $scope.conCriteriaArray = lstRecord;
            angular.forEach($scope.conCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;

            })
            $scope.saveContactMapping($scope.recordContact, $scope.output_Contact, $scope.caseKeyRecord);
            $scope.saveInfo('Contact');
            toaster.pop('success', "Success", "Lead Duplication Check - Contact Service Save Successfully.");

        }
        else if (!$scope.IsVatError && serviceType == 'Vat_Criteria') {
            $scope.vatCriteriaArray = lstRecord;
            angular.forEach($scope.vatCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                delete value.IsError;
            })
           // if ($scope.vatCriteriaArray[4].Condition != null)
          //      delete $scope.vatCriteriaArray[4].Condition;
            $scope.saveVatCheck();
        }
        else if (!$scope.IsLeadGlobalError && serviceType == 'LeadGlobal_Criteria') {
            $scope.leadGlobalCriteriaArray = lstRecord;
            angular.forEach($scope.leadGlobalCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;

            })
            $scope.saveleadGlobalMapping();
        } 
        else if (!$scope.IsAccountGDMError && serviceType == 'AccountGDM_Criteria') {
            $scope.accountGDMCriteriaArray = lstRecord;
            angular.forEach($scope.accountGDMCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;

            })
            $scope.saveAccountGDMMapping();
        } 
        //IWS Service
        else if (!$scope.IsAccountIwsError && serviceType == 'AccountIWS_Criteria') {
            $scope.iwsCriteriaArray = lstRecord;
            angular.forEach($scope.iwsCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;

            })
            $scope.saveAccountIWSMapping();
        }
        else if (!$scope.isIWSStdAddInfoServiceError && serviceType == 'AccountIWSStdAddInfo_Criteria') {
            $scope.iwsStdAddInfoCriteriaArray = lstRecord;
            angular.forEach($scope.iwsStdAddInfoCriteriaArray , function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;

            })
            $scope.saveIWSServiceDetails();
        } 
        //IWS Paydex Information Service
        else if (!$scope.isIWSPaydexInfoServiceError && serviceType == 'AccountIWSPaydexInfo_Criteria') {
            $scope.iwsPaydexInfoCriteriaArray = lstRecord;
            angular.forEach($scope.iwsPaydexInfoCriteriaArray, function(value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;    
            })
            $scope.saveIWSServiceDetails();
        }

        //IWS Risk Info Service
        else if(!$scope.isIWSRiskInfoServiceError && serviceType == 'AccountIWSRiskInfo_Criteria') {
            $scope.iwsRiskInfoCriteriaArray = lstRecord;
            angular.forEach($scope.iwsRiskInfoCriteriaArray, function(value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;
            })
            $scope.saveIWSServiceDetails();
        }

        //IndueD Service
        else if(!$scope.isIndueDServiceError && serviceType == 'AccountIndueD_Criteria') {
            $scope.indueDserviceCriteriaArray = lstRecord;
            angular.forEach($scope.indueDserviceCriteriaArray, function(value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;
            })
            $scope.saveIndueDServiceDetails();
        }
        
        //IWS Advanced Address Service
        else if (!$scope.IsAccountIwsAdvancedAddressError  && serviceType == 'AccountIWSAdvanced_Criteria'){
            $scope.iwsAdvancedAddressCriteriaArray  = lstRecord;
            angular.forEach($scope.iwsAdvancedAddressCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;

            })
            $scope.saveAccountIWSAdvancedMapping();
        } 
        else if (!$scope.isIWSBalanceSheetServiceError && serviceType == 'AccountIWSBalanceSheet_Criteria') {
            $scope.iwsBalanceSheetCriteriaArray = lstRecord;
            angular.forEach($scope.iwsBalanceSheetCriteriaArray , function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;
            })
            $scope.saveIWSServiceDetails();
        }    
         //Start IWS Bankruptcy Information Service
         else if (!$scope.IsAccountIwsBankruptcyInfoError  && serviceType == 'AccountIWSBankruptcy_Criteria'){
            $scope.iwsBankruptcyInfoCriteriaArray  = lstRecord;
            angular.forEach($scope.iwsBankruptcyInfoCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;
            })
           $scope.saveIWSBankruptcyServiceDetails();
        }
        // End IWS Bankruptcy Information Service
         //Start Risk datablock Service
         else if (!$scope.IsAccountRiskDatablockServiceInfoError  && serviceType == 'AccountRiskDatablock_Criteria'){
            $scope.riskDatablockServiceCriteriaArray  = lstRecord;
            angular.forEach($scope.riskDatablockServiceCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;
            })
          $scope.saveRiskDatablockServiceDetails();
        }
        // End Risk datablock Service

        //Start Company Report Service
        else if (!$scope.IsAccountCompanyReportServiceInfoError  && serviceType == 'AccountCompanyReport_Criteria'){
            $scope.companyReportServiceCriteriaArray  = lstRecord;
            angular.forEach($scope.companyReportServiceCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;
            })
          $scope.saveCompanyReportServiceDetails();
        }
        // End Company Report Service


        else if (!$scope.IsAccountGlobalError && serviceType == 'AccountGlobal_Criteria') {
            $scope.accountGlobalCriteriaArray = lstRecord;
            angular.forEach($scope.accountGlobalCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;

            })
            $scope.saveAccountGlobalMapping();
        }else if (!$scope.IsAccountTradeCreditError && serviceType == 'AccountTradeCredit_Criteria') {
            $scope.accountTradeCreditCriteriaArray = lstRecord;
            angular.forEach($scope.accountTradeCreditCriteriaArray, function (value, key) {
                if(value.Field == '--None--')
                    value.Type = 'text';
                value.IsError = false;
                delete value.IsError;
            })
            $scope.saveAccountTradeCreditMapping();
        } else {
            toaster.pop('error', "Error", "Something Went Wrong");
            $loader.hideProcessing();
        }
    }

    $scope.saveDetails = function () {
        $loader.showProcessing();
        if ($scope.IsSave) {
            toaster.pop('error', "Error", "Something Went Wrong");
            return;
        }        
        if ($scope.IsCredentialUpdate) {
            var duplicateCredential = { 'UserName': $scope.objDuplicate.Username, 'Password': $scope.objDuplicate.Password, 'ContactUsername': $scope.objDuplicate.ContactUsername, 'ContactPassword': $scope.objDuplicate.ContactPassword, 'AccountCaseKey': $scope.caseKeyRecord.Account, 'ContactCaseKey': $scope.caseKeyRecord.Contact, 'AccountKvkUsername': $scope.objDuplicate.AccountKvkUsername, 'AccountKvkPassword': $scope.objDuplicate.AccountKvkPassword, 'AccountKvkCaseKey': $scope.caseKeyRecord.AccountKvk, 'LeadKvkUsername': $scope.objDuplicate.LeadKvkUsername, 'LeadKvkPassword': $scope.objDuplicate.LeadKvkPassword, 'LeadKvkCaseKey': $scope.caseKeyRecord.LeadKvk };
            var creditCredential = { 'UserName': $scope.objCredit.Username, 'Password': $scope.objCredit.Password };
            var toolkitEntrPrizeCredential = { 'UserName': $scope.objToolkitEnterprise.Username, 'Password': $scope.objToolkitEnterprise.Password };
            var toolkitQckChkCredential = { 'UserName': $scope.objToolkitQuickCheck.Username, 'Password': $scope.objToolkitQuickCheck.Password };
            var globalLeadMatchCredentials = {'Consumer_Key': $scope.objLeadGlobal.Consumer_Key, 'Consumer_Secret':$scope.objLeadGlobal.Consumer_Secret};
            var globalAccountMatchCredentials = {'Consumer_Key': $scope.objAccountGlobal.Consumer_Key, 'Consumer_Secret':$scope.objAccountGlobal.Consumer_Secret};
            var accountTradeCreditCredentials = {'Consumer_Key': $scope.objAccountTradeCredit.Consumer_Key, 'Consumer_Secret':$scope.objAccountTradeCredit.Consumer_Secret};
            var iwsServiceCredential = { 'UserName': $scope.objIwsService.Username, 'Password': $scope.objIwsService.Password };
            var iwsAdvancedAddressServiceCredential = { 'UserName': $scope.objIwsAdvancedAddressService.Username, 'Password': $scope.objIwsAdvancedAddressService.Password };
            var iwsBankruptcyInfoServiceCredential = { 'UserName': $scope.objIwsBankruptcyInfoService.Username, 'Password': $scope.objIwsBankruptcyInfoService.Password };
            //start Global Decision Maker Service 
            var gdmServiceCredentials = { 'UserId': $scope.objGDMService.UserId, 'Password': $scope.objGDMService.Password };
            //end Global Decision Maker Service 
            var iwsStandredAddressServiceCredential = { 'UserName': $scope.objIWSStdAddInfoService.Username, 'Password': $scope.objIWSStdAddInfoService.Password };
            //start payDex Ifo Service
            var iwsPaydexServiceCredential = { 'UserName': $scope.objIWSPaydexInfoService.Username, 'Password': $scope.objIWSPaydexInfoService.Password };

            //start risk information service
            var iwsRiskInfoServiceCredential = { 'UserName': $scope.objIWSRiskInfoService.Username, 'Password': $scope.objIWSRiskInfoService.Password};
            //end risk information service
            var iwsBalanceSheetServiceCredential = { 'UserName': $scope.objIWSBalanceSheetService.Username, 'Password': $scope.objIWSBalanceSheetService.Password };

            //start indued service
            var induedServiceCredential = { 'api_token': $scope.objInduedService.api_token};
            //start risk datablock service
            var riskDatablockCredential = {'Consumer_Key': $scope.objRiskDatablockService.Consumer_Key, 'Consumer_Secret':$scope.objRiskDatablockService.Consumer_Secret};

            //Start of Company Report Service
            var companyReportCredential = {'Consumer_Key': $scope.objCompanyReportService.Consumer_Key, 'Consumer_Secret':$scope.objCompanyReportService.Consumer_Secret};

            var serviceCredentials = {'duplicateCredential' : JSON.stringify(duplicateCredential),
            'creditCredential': JSON.stringify(creditCredential),
            'toolkitEntrPrizeCredential' : JSON.stringify(toolkitEntrPrizeCredential),
            'toolkitQckChkCredential': JSON.stringify(toolkitQckChkCredential),
            'globalLeadMatchCredentials': JSON.stringify(globalLeadMatchCredentials),
            'globalAccountMatchCredentials': JSON.stringify(globalAccountMatchCredentials),
            'accountTradeCreditCredentials': JSON.stringify(accountTradeCreditCredentials),
            'iwsServiceCredential': JSON.stringify(iwsServiceCredential),
            'gdmServiceCredentials': JSON.stringify(gdmServiceCredentials),
            "iwsStandredAddressServiceCredential" : JSON.stringify(iwsStandredAddressServiceCredential),
            // Start IWS Advanced Address Information Service
            'iwsAdvancedAddressServiceCredential': JSON.stringify(iwsAdvancedAddressServiceCredential),
            // End IWS Advanced Address Information Service
            // Start IWS Bankruptcy Information Service
            'iwsBankruptcyInfoServiceCredential': JSON.stringify(iwsBankruptcyInfoServiceCredential),
            // End IWS Bankruptcy Information Service  
            //Start IWS paydex Info Service
            'iwsPaydexServiceCredential': JSON.stringify(iwsPaydexServiceCredential),
            //Start IWS Risk Information Service
            'iwsRiskInfoServiceCredential': JSON.stringify(iwsRiskInfoServiceCredential),
            'iwsBalanceSheetServiceCredential' :  JSON.stringify(iwsBalanceSheetServiceCredential),
            'induedServiceCredential': JSON.stringify(induedServiceCredential),
            'riskDatablockCredential': JSON.stringify(riskDatablockCredential),
            'companyReportCredential': JSON.stringify(companyReportCredential)
            };
        
            API_Connector.Engine.updateCredentialSettings(serviceCredentials, function (SettingUpdate, event) {
                if (SettingUpdate != null) {
                    if (SettingUpdate) {
                        $scope.IsCredentialUpdate = false;
                        $loader.hideProcessing();
                        toaster.pop('success', "Success", "Credential Updated Successfully");
                        $scope.UpdateAccountCallOut();
                        $scope.UpdateContactCallOut();
                        $scope.UpdateAccountkvkCallout();
                        $scope.UpdateLeadkvkCallout();
                    } else {
                        $scope.IsCredentialUpdate = false;
                        $loader.hideProcessing();
                        toaster.pop('error', "Error", "Something went wrong");
                    }
                }
            })
            return;
        }
        if ($scope.serviceName.Name == '--None--') {
            toaster.pop('error', "Error", "Please Select the Service");
            return;
        }
        if ($scope.currentStep < 6) {
            toaster.pop('error', "Error", "Please Complete All the Steps.");
            $loader.hideProcessing();
            return;
        }
        // if ($scope.objDUNSValue.name == '--None--') {
        //     toaster.pop('error', "Error", "Please select appropriate field in Input Field Mapping.");
        //     $loader.hideProcessing();
        //     return;
        // }
        $scope.IsFilterLogic = true;
        $scope.makeOutputFieldsToBlank();
        //credit 
        if ($scope.serviceName.Name == $scope.serviceListObject.CREDIT_CHECK) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.creditFilterlogic.Name);
            var ckLengthLogic = $scope.creditFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.creditCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.creditCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.creditCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.creditCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.creditCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }

            if (!$scope.invalidLogic) {

                $scope.saveServiceCall($scope.creditCriteriaArray, 'Credit_Criteria');
            } else
                $loader.hideProcessing();
        }
        //toolkit management
        if ($scope.serviceName.Name == $scope.serviceListObject.ENTERPRISE) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.toolkitFilterlogic.Name);
            var ckLengthLogic = $scope.toolkitFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.toolkitCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.toolkitCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.toolkitCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.toolkitCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.toolkitCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }

            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.toolkitCriteriaArray, 'Toolkit_Criteria');
            } else
                $loader.hideProcessing();
        }

        // Start IWS Bankruptcy Information Service    
         if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Bankruptcy_Information_Service) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.IWSBankruptcyInfoFilterlogic.Name);
            var ckLengthLogic = $scope.IWSBankruptcyInfoFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.iwsBankruptcyInfoCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.iwsBankruptcyInfoCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.iwsBankruptcyInfoCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.iwsBankruptcyInfoCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.iwsBankruptcyInfoCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {           
                $scope.saveServiceCall($scope.iwsBankruptcyInfoCriteriaArray, 'AccountIWSBankruptcy_Criteria');
            } else
                $loader.hideProcessing();
        }
        // End IWS Bankruptcy Information Service

        //IWS Service     
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_SERVICE) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.IWSFilterlogic.Name);
            var ckLengthLogic = $scope.IWSFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.iwsCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.iwsCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.iwsCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.iwsCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.iwsCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.iwsCriteriaArray, 'AccountIWS_Criteria');
            } else
                $loader.hideProcessing();
        }

        //IWS StandardAddress Information Service     
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_STANDARD_ADDRESS_INFORMATION) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.iwsStdAddInfoFilterlogic.Name);
            var ckLengthLogic = $scope.iwsStdAddInfoFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.iwsStdAddInfoCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.iwsStdAddInfoCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.iwsStdAddInfoCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.iwsStdAddInfoCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.iwsStdAddInfoCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.iwsStdAddInfoCriteriaArray, 'AccountIWSStdAddInfo_Criteria');
            } else
            $loader.hideProcessing();
        }

        //IWS Paydex Information Service     
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.iwsPaydexInfoFilterlogic.Name);
            var ckLengthLogic = $scope.iwsPaydexInfoFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.iwsPaydexInfoCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.iwsPaydexInfoCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.iwsPaydexInfoCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.iwsPaydexInfoCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.iwsPaydexInfoCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.iwsPaydexInfoCriteriaArray, 'AccountIWSPaydexInfo_Criteria');
            } else
            $loader.hideProcessing();
        }

        //IWS Risk Info Service
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_RISK_INFORMATION) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.iwsRiskInfoFilterLogic.Name);
            var ckLengthLogic = $scope.iwsRiskInfoFilterLogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.iwsRiskInfoCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.iwsRiskInfoCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.iwsRiskInfoCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.iwsRiskInfoCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.iwsRiskInfoCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.iwsRiskInfoCriteriaArray, 'AccountIWSRiskInfo_Criteria');
            } else
            $loader.hideProcessing();
        }


         //IWS Advanced Address Service     
         if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Advanced_Address_Information_Service) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.IWSAdvancedFilterlogic.Name);
            var ckLengthLogic = $scope.IWSAdvancedFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.iwsAdvancedAddressCriteriaArray [0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.iwsAdvancedAddressCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.iwsAdvancedAddressCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.iwsAdvancedAddressCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.iwsAdvancedAddressCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
               
                $scope.saveServiceCall($scope.iwsAdvancedAddressCriteriaArray, 'AccountIWSAdvanced_Criteria');
            } else
                $loader.hideProcessing();
        }
        //IWS Balance Sheet Service     
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_BALANCE_SHEET) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.iwsBalanceSheetFilterlogic.Name);
            var ckLengthLogic = $scope.iwsBalanceSheetFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.iwsBalanceSheetCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.iwsBalanceSheetCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.iwsBalanceSheetCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.iwsBalanceSheetCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.iwsBalanceSheetCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.iwsBalanceSheetCriteriaArray, 'AccountIWSBalanceSheet_Criteria');
            } else
            $loader.hideProcessing();
        }

         //Global Match Account         
         if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_GLOBAL) {

            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.accountGlobalFilterlogic.Name);

            var ckLengthLogic = $scope.accountGlobalFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.accountGlobalCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.accountGlobalCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.accountGlobalCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.accountGlobalCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.accountGlobalCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }

            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.accountGlobalCriteriaArray, 'AccountGlobal_Criteria');
            } else
                $loader.hideProcessing();

        }

        //IndueD Service
        if ($scope.serviceName.Name == $scope.serviceListObject.INDUED_SERVICE) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.indueDServiceFilterlogic.Name);
            var ckLengthLogic = $scope.indueDServiceFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.indueDserviceCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.indueDserviceCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.indueDserviceCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.indueDserviceCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.indueDserviceCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.indueDserviceCriteriaArray, 'AccountIndueD_Criteria');
            } else
            $loader.hideProcessing();
        }

      //toolkit Quick Check
        if ($scope.serviceName.Name == $scope.serviceListObject.QUICK) {
          $loader.showProcessing();
          $scope.customLogicFilter.Name = '';
          $scope.isValidLogicalStatement($scope.toolkitQCFilterlogic.Name);
          var ckLengthLogic = $scope.toolkitQCFilterlogic.Name;
          if (ckLengthLogic != '') {
            for (var i = 0; i < ckLengthLogic.length; i++) {
              if ((ckLengthLogic.charAt(i) == '1' && $scope.toolkitQCCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.toolkitQCCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.toolkitQCCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.toolkitQCCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.toolkitQCCriteriaArray[4].Field == '--None--')) {
                $scope.invalidLogic = true;
              }
            }
          }

          if (!$scope.invalidLogic) {
            $scope.saveServiceCall($scope.toolkitQCCriteriaArray, 'ToolkitQC_Criteria');
          } else
            $loader.hideProcessing();
        }

        //Dutch Chamber Account
        if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_KVK) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.accountKvkFilterlogic.Name);
            var ckLengthLogic = $scope.accountKvkFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.accountKvkCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.accountKvkCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.accountKvkCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.accountKvkCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.accountKvkCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.accountKvkCriteriaArray, 'AccountKvk_Criteria');
            } else
                $loader.hideProcessing();
        }

        //Dutch chamber lead
        if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_KVK ) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.leadKvkFilterlogic.Name);
            var ckLengthLogic = $scope.leadKvkFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.leadKvkCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.leadKvkCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.leadKvkCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.leadKvkCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.leadKvkCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.leadKvkCriteriaArray, 'LeadKvk_Criteria');
            } else
                $loader.hideProcessing();
        }

        //Lead Duplication Check - Account
        if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_DUPLICATE) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.accFilterlogic.Name);

            var ckLengthLogic = $scope.accFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.accCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.accCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.accCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.accCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.accCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {

                $scope.saveServiceCall($scope.accCriteriaArray, 'Account_Criteria');
            } else
                $loader.hideProcessing();

        }
        //Lead Duplication Check - Contact
        if ($scope.serviceName.Name == $scope.serviceListObject.CONTACT_DUPLICATE) {

            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.conFilterlogic.Name);

            var ckLengthLogic = $scope.conFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.conCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.conCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.conCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.conCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.conCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }

            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.conCriteriaArray, 'Contact_Criteria');
            } else
                $loader.hideProcessing();

        }
        //VAT Number Check
        if ($scope.serviceName.Name == $scope.serviceListObject.VAT) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.vatFilterlogic.Name);

            var ckLengthLogic = $scope.vatFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.vatCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.vatCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.vatCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.vatCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.vatCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }

            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.vatCriteriaArray, 'Vat_Criteria');
            }
            else
                $loader.hideProcessing();
        }
        //Global Match Lead         
         if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_GLOBAL) {

            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.leadGlobalFilterlogic.Name);

            var ckLengthLogic = $scope.leadGlobalFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.leadGlobalCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.leadGlobalCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.leadGlobalCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.leadGlobalCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.leadGlobalCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }

            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.leadGlobalCriteriaArray, 'LeadGlobal_Criteria');
            } else
                $loader.hideProcessing();

        }
       
        //Global Decision Maker 
        if ($scope.serviceName.Name == $scope.serviceListObject.GLOBAL_DECISION_MAKER) {

            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.accountGDMFilterlogic.Name);

            var ckLengthLogic = $scope.accountGDMFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.accountGDMCriteriaArray[0].Field == '--None--') ||
                     (ckLengthLogic.charAt(i) == '2' && $scope.accountGDMCriteriaArray[1].Field == '--None--') || 
                     (ckLengthLogic.charAt(i) == '3' && $scope.accountGDMCriteriaArray[2].Field == '--None--') || 
                     (ckLengthLogic.charAt(i) == '4' && $scope.accountGDMCriteriaArray[3].Field == '--None--') || 
                     (ckLengthLogic.charAt(i) == '5' && $scope.accountGDMCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }

            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.accountGDMCriteriaArray, 'AccountGDM_Criteria');
            } else
                $loader.hideProcessing();

        }

        //Account Trade Credit
        if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_TRADE) {

            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.accountTradeCreditFilterlogic.Name);

            var ckLengthLogic = $scope.accountTradeCreditFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.accountTradeCreditCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.accountTradeCreditCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.accountTradeCreditCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.accountTradeCreditCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.accountTradeCreditCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }

            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.accountTradeCreditCriteriaArray, 'AccountTradeCredit_Criteria');
            } else
                $loader.hideProcessing();

        }
    
        //Risk Datablock Service     
        if ($scope.serviceName.Name == $scope.serviceListObject.RISK_DATABLOCKS) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.riskDatablockServiceFilterlogic.Name);
            var ckLengthLogic = $scope.riskDatablockServiceFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.riskDatablockServiceCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.riskDatablockServiceCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.riskDatablockServiceCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.riskDatablockServiceCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.riskDatablockServiceCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.riskDatablockServiceCriteriaArray, 'AccountRiskDatablock_Criteria');
            } else
            $loader.hideProcessing();
        }

        //Company Report Service     
        if ($scope.serviceName.Name == $scope.serviceListObject.COMPANY_REPORT) {
            $loader.showProcessing();
            $scope.customLogicFilter.Name = '';
            $scope.isValidLogicalStatement($scope.companyReportServiceFilterlogic.Name);
            var ckLengthLogic = $scope.companyReportServiceFilterlogic.Name;
            if (ckLengthLogic != '') {
                for (var i = 0; i < ckLengthLogic.length; i++) {
                    if ((ckLengthLogic.charAt(i) == '1' && $scope.companyReportServiceCriteriaArray[0].Field == '--None--') || (ckLengthLogic.charAt(i) == '2' && $scope.companyReportServiceCriteriaArray[1].Field == '--None--') || (ckLengthLogic.charAt(i) == '3' && $scope.companyReportServiceCriteriaArray[2].Field == '--None--') || (ckLengthLogic.charAt(i) == '4' && $scope.companyReportServiceCriteriaArray[3].Field == '--None--') || (ckLengthLogic.charAt(i) == '5' && $scope.companyReportServiceCriteriaArray[4].Field == '--None--')) {
                        $scope.invalidLogic = true;
                    }
                }
            }
            if (!$scope.invalidLogic) {
                $scope.saveServiceCall($scope.companyReportServiceCriteriaArray, 'AccountCompanyReport_Criteria');
            } else
            $loader.hideProcessing();
        }
    }

    
    $scope.saveVatCheck = function () {
        var objVat = { 'CustomVatField': $scope.objVat.Vat, 'IsChecked': $scope.objVat.IsCheckVat, 'VatDate': $scope.vatRecord.Date, 'VatStatus': $scope.vatRecord.Status, 'VatLogic': $scope.vatFilterlogic.Name,'VatRequestIdentifier':$scope.vatRecord.Identifier, 'VatCustomLogic': $scope.customLogicFilter.Name };
        API_Connector.Engine.saveVatCheck(JSON.stringify(objVat), JSON.stringify($scope.vatCriteriaArray), function (vatCheck, event) {

            if (vatCheck != null && vatCheck == true) {
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }
            else {
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }

        })
    }
    $scope.saveToolkit = function () {
        if($scope.output_toolkit.length > 0){
            $scope.output_toolkit = checkBlank($scope.output_toolkit);
        }
      API_Connector.Engine.saveToolkitCheck(JSON.stringify($scope.objToolkitEnterprise),  JSON.stringify($scope.toolkitCriteriaArray), $scope.toolkitFilterlogic.Name, $scope.customLogicFilter.Name, JSON.stringify($scope.arrToolkitOutPutField), JSON.stringify($scope.output_toolkit), function (toolkitResponse, event) {
            if (toolkitResponse != null && toolkitResponse == true) {
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }
            else {
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }

        })
    }
    $scope.saveToolkitQuickCheck = function () {
        if($scope.output_toolkitQC.length > 0){
            $scope.output_toolkitQC = checkBlank($scope.output_toolkitQC);
        }
      API_Connector.Engine.saveToolkitQuickCheck(JSON.stringify($scope.objToolkitQuickCheck), JSON.stringify($scope.toolkitQCCriteriaArray), $scope.toolkitQCFilterlogic.Name, $scope.customLogicFilter.Name, JSON.stringify($scope.arrToolkitQCOutPutField), JSON.stringify($scope.output_toolkitQC), function (toolkitQCResponse, event) {
        if (toolkitQCResponse != null && toolkitQCResponse == true) {
          $loader.hideProcessing();
          $scope.popUpCheck = true;
          $timeout(callAtTimeout, 3000);
        }
        else {
          $scope.popUpCheck = false;
          $timeout(callAtTimeout, 100);
        }

      })
    }
    $scope.saveCreditCheck = function () {
      API_Connector.Engine.saveCreditCheck($scope.objCredit.Username, $scope.objCredit.Password, $scope.objCredit.Duns, $scope.objCredit.IsCheckCredit, $scope.creditRecord.Value, $scope.creditRecord.Date, $scope.creditRecord.Status, JSON.stringify($scope.creditCriteriaArray), $scope.creditFilterlogic.Name, $scope.customLogicFilter.Name, function (creditCheckResult, event) {
        if (creditCheckResult != null) {
          $loader.hideProcessing();
          $scope.popUpCheck = true;
          $timeout(callAtTimeout, 3000);
        }
        else {
          $scope.popUpCheck = false;
          $timeout(callAtTimeout, 100);
        }
      })
    }
    
    $scope.saveAccountKvk = function () {
        $scope.Mapping_AccountKvk = checkBlank($scope.Mapping_AccountKvk);
        $scope.Output_AccountKvk = checkBlank($scope.Output_AccountKvk);
        var IOMappingAccountKvk = { 'InputMapping': $scope.Mapping_AccountKvk, 'OutputMapping': $scope.Output_AccountKvk };
        API_Connector.Engine.saveAccountKvkDetails(JSON.stringify($scope.objDuplicate), JSON.stringify($scope.accountKvkCriteriaArray), $scope.accountKvkFilterlogic.Name, $scope.customLogicFilter.Name, JSON.stringify(IOMappingAccountKvk), JSON.stringify($scope.accKvkRecord), JSON.stringify($scope.caseKeyRecord), function (accKvkResponse, event) {
            if (accKvkResponse != null && accKvkResponse == true) {
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }
            else {
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }
        })
    }
    $scope.saveLeadKvk = function () {
        $scope.Mapping_LeadKvk = checkBlank($scope.Mapping_LeadKvk);
        $scope.Output_LeadKvk = checkBlank($scope.Output_LeadKvk);
        var IOMappingLeadKvk = { 'InputMapping': $scope.Mapping_LeadKvk, 'OutputMapping': $scope.Output_LeadKvk };
        API_Connector.Engine.saveLeadKvkDetails(JSON.stringify($scope.objDuplicate), JSON.stringify($scope.leadKvkCriteriaArray), $scope.leadKvkFilterlogic.Name, $scope.customLogicFilter.Name, JSON.stringify(IOMappingLeadKvk), JSON.stringify($scope.leadKvkRecord), JSON.stringify($scope.caseKeyRecord),  function (leadKvkResponse, event) {
            
            if (leadKvkResponse != null && leadKvkResponse == true) {
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }
            else {
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }
        })
    }
    $scope.saveleadGlobalMapping = function () {
        $scope.recordLeadGlobal = checkBlank($scope.recordLeadGlobal);
        $scope.output_LeadGlobal = checkBlank($scope.output_LeadGlobal);
        var leadGlobalIOMapping = {'InputMapping': $scope.recordLeadGlobal, 'OutputMapping': $scope.output_LeadGlobal};
        var leadExclusionCriteria = '';

        for(var index = 0; index <  $scope.lstLeadGlobalExclusionCriteriaSelection.length; index++){
                var item = $scope.lstLeadGlobalExclusionCriteriaSelection[index];
                if(leadExclusionCriteria===''){
                    leadExclusionCriteria = item.value;
                }else{
                    leadExclusionCriteria = leadExclusionCriteria +','+item.value;
                }
        }
        var confidenceLowerLevel = {'confidenceLowerLevelThresholdValue':$scope.objLeadGlobal.confidenceLowerLevel=='--None--'?8:$scope.objLeadGlobal.confidenceLowerLevel};
        var objLeadGlobal = {
            'leadGlobalIOMapping' : JSON.stringify(leadGlobalIOMapping),
            'leadGlobalStatusField' : $scope.leadGlobalOutRecord.Status,
            'leadGlobalDateField' : $scope.leadGlobalOutRecord.Date,
            'IsLeadGlobalMatchTrigger' : JSON.stringify($scope.objLeadGlobal.IsLeadGlobalMatchTrigger),
            'leadGlobalFilterlogic' : $scope.leadGlobalFilterlogic.Name,
            'leadGlobalCustomFilterlogic' : $scope.customLogicFilter.Name,
            'leadGlobalCriteriaArray' : JSON.stringify($scope.leadGlobalCriteriaArray),
            'leadExclusionCriteria' : JSON.stringify({'exclusionCriteria' : leadExclusionCriteria}),
            'leadConfidenceLowerLevel' : JSON.stringify(confidenceLowerLevel)
        }

            API_Connector.Engine.saveLeadGlobalMatchDetails(objLeadGlobal,  function (leadGlobalResponse, event) {
                if(leadGlobalResponse.success){
                    $loader.hideProcessing();
                    $scope.popUpCheck = true;
                    $timeout(callAtTimeout, 3000);
                }else {
                    console.log('Global Lead Match Error', leadGlobalResponse.message );
                    $scope.popUpCheck = false;
                    $timeout(callAtTimeout, 100);
                }
            });
    }

    $scope.saveAccountGDMMapping = function () {
         $scope.input_GDMAccountService.unshift({'name':$scope.objGDMService.Duns,'value':'dunsNumber'});
         $scope.recordGDMInputMap = checkBlank($scope.input_GDMAccountService);
         $scope.recordGDMOutputMap = checkBlank($scope.output_GDMAccountService);
         var accountGDMIOMapping = {'InputMapping': $scope.recordGDMInputMap,'OutputMapping': $scope.recordGDMOutputMap != null ? $scope.recordGDMOutputMap : null };
        
        if( $scope.objGDMService.billingReference == null ) {
            $scope.objGDMService.billingReference = '';
        }
        if( $scope.objGDMService.rulesetName == null ) {
            $scope.objGDMService.rulesetName = '';
        }
        if( $scope.objGDMService.rulesetVersion == null ) {
            $scope.objGDMService.rulesetVersion = '';
        }
        
        var billingReference = {'billingReference':$scope.objGDMService.billingReference};
        var rulesetName = {'rulesetName':$scope.objGDMService.rulesetName};
        var rulesetVersion = {'rulesetVersion':$scope.objGDMService.rulesetVersion};
        
        if( $scope.objGDMService.IsAccountGDMActive == null || $scope.objGDMService.IsAccountGDMActive == undefined ) {
            $scope.objGDMService.IsAccountGDMActive = false;
        }
        
        var objAccountGDM = {
            'dunsNumber':$scope.objGDMService.Duns,
            'accountBillingReference' : billingReference != "" ? JSON.stringify(billingReference) : "",
            'accountRulesetName' : rulesetName != "" ?  JSON.stringify(rulesetName) : "",
            'accountRulesetVersion' : rulesetVersion != "" ? JSON.stringify(rulesetVersion) : "",
            'accountGDMIOMapping' : JSON.stringify(accountGDMIOMapping),
            'accountGDMStatusField' : $scope.objGDMService.GDMServiceStatus,
            'accountGDMDateField' : $scope.objGDMService.GDMServiceDate,
            'accountGDMFilterlogic' : $scope.accountGDMFilterlogic.Name,
            'accountGDMCustomFilterlogic' : $scope.customLogicFilter.Name,
            'accountGDMCriteriaArray' : JSON.stringify($scope.accountGDMCriteriaArray),
            'IsAccountGDMActive' :JSON.stringify($scope.objGDMService.IsAccountGDMActive)
            
        }

            API_Connector.Engine.saveAccountGDMDetails(objAccountGDM,  function (accountGDMResponse, event) {
                if(accountGDMResponse.success){
                    $loader.hideProcessing();
                    $scope.popUpCheck = true;
                    $timeout(callAtTimeout, 3000);
                }else {
                    console.log('Account GDM Error', accountGDMResponse.message );
                    $scope.popUpCheck = false;
                    $timeout(callAtTimeout, 100);
                }
            });
    }

    $scope.saveAccountTradeCreditMapping = function() {
        let objAccountTradeCredit = $scope.objAccountTradeCredit;
        $scope.output_AccountTradeCredit = checkBlank($scope.output_AccountTradeCredit);

        var accountTradeCreditIOMapping = {"InputMapping": [{"name" : "tradeUp", "value" :objAccountTradeCredit.tradeUp}], 'OutputMapping': $scope.output_AccountTradeCredit != undefined ||  $scope.output_AccountTradeCredit != null ?$scope.output_AccountTradeCredit : null };
        var objAccountGlobal = {
           // Start Issue - "Output field mapped and loader issue"
            "dunsNumber" : ((objAccountTradeCredit.dunsNumber == undefined || objAccountTradeCredit.dunsNumber == null || objAccountTradeCredit.dunsNumber == '--None--')?"":objAccountTradeCredit.dunsNumber),          
           // End Issue - "Output field mapped and loader issue"
            "accountTradeCreditIOMapping" : JSON.stringify(accountTradeCreditIOMapping),
            "accountTradeCreditDateField" : $scope.accountTradeCreditDateStatusRecord.Date,
            "accountTradeCreditStatusField" : $scope.accountTradeCreditDateStatusRecord.Status,
            "IsAccountTradeCreditTrigger" : JSON.stringify(objAccountTradeCredit.IsAccountTradeCreditTrigger),
            "accountTradeCreditFilterlogic" : $scope.accountTradeCreditFilterlogic.Name,
            "accountTradeCreditCustomFilterlogic" : $scope.customLogicFilter.Name,
            "accountTradeCreditCriteriaArray" : JSON.stringify($scope.accountTradeCreditCriteriaArray),
        };

        API_Connector.Engine.saveAccountTradeCreditDetails(objAccountGlobal,  function (accountTradeCreditResponse, event) {
            if(accountTradeCreditResponse.success){
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }else {
                console.log('Global Account Match Error', accountTradeCreditResponse.message );
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }
           
        });
    }
    $scope.saveAccountIWSMapping = function() {
        let objIwsService = $scope.objIwsService;
        $scope.output_IWSAccountService = checkBlank($scope.output_IWSAccountService);
        var accountIwsIOMapping = {"InputMapping": [{"name" : "sirenRna", "value" : objIwsService.Siren}], "OutputMapping" : $scope.output_IWSAccountService};
  
        var objAccountIws = {
            'accountIwsIOMapping' : JSON.stringify(accountIwsIOMapping),
            'accountIwsFilterlogic' : $scope.IWSFilterlogic.Name,
            'accountIwsCustomFilterlogic' : $scope.customLogicFilter.Name,
            'accountIwsCriteriaArray' : JSON.stringify($scope.iwsCriteriaArray),       
        }

            API_Connector.Engine.saveIntuizWebServiceDetails(objAccountIws, JSON.stringify($scope.objIwsService), function (accountIwsResponse, event) {
                if(accountIwsResponse.success){
                    $loader.hideProcessing();
                    $scope.popUpCheck = true;
                    $timeout(callAtTimeout, 3000);
                }else {
                    console.log('IWS Account Error', accountIwsResponse.message );
                    $scope.popUpCheck = false;
                    $timeout(callAtTimeout, 100);
                }              
            });
    } 
    // Start IWS Bankruptcy Information Service
    $scope.saveIWSBankruptcyServiceDetails = function() {
        let objIwsBankruptcyInfoService = $scope.objIwsBankruptcyInfoService;
        $scope.output_IWSBankruptcyInfoAccountService = checkBlank($scope.output_IWSBankruptcyInfoAccountService);
        var accountIwsBankruptcyIOMapping = {"InputMapping": [{"name" : "siren", "value" : objIwsBankruptcyInfoService.Siren}], "OutputMapping" : $scope.output_IWSBankruptcyInfoAccountService};
  
        var objAccountIwsBankruptcy = {
            'accountIwsBankruptcyIOMapping' : JSON.stringify(accountIwsBankruptcyIOMapping),
            'accountIwsBankruptcyFilterlogic' : $scope.IWSBankruptcyInfoFilterlogic.Name,
            'accountIwsBankruptcyCustomFilterlogic' : $scope.customLogicFilter.Name,
            'accountIwsBankruptcyCriteriaArray' : JSON.stringify($scope.iwsBankruptcyInfoCriteriaArray),       
        }

            API_Connector.Engine.saveIWSBankruptcyServiceDetails(objAccountIwsBankruptcy, JSON.stringify($scope.objIwsBankruptcyInfoService), function (accountIwsBankruptcyResponse, event) {
                if(accountIwsBankruptcyResponse.success){
                    $loader.hideProcessing();
                    $scope.popUpCheck = true;
                    $timeout(callAtTimeout, 3000);
                }else {
                    console.log('IWS Bankruptcy Info Service Account Error', accountIwsBankruptcyResponse.message );
                    $scope.popUpCheck = false;
                    $timeout(callAtTimeout, 100);
                }             
            }); 
    }
    // End IWS Bankruptcy Information Service

    $scope.saveAccountIWSAdvancedMapping = function() {
        let objIwsAdvancedAddressService = $scope.objIwsAdvancedAddressService;
        $scope.output_IWSAdvancedAddressAccountService = checkBlank($scope.output_IWSAdvancedAddressAccountService);
        var accountIwsAdvancedIOMapping = {"InputMapping": [{"name" : "sirenSiret", "value" : objIwsAdvancedAddressService.Siret}], "OutputMapping" : $scope.output_IWSAdvancedAddressAccountService};
  
        var objAccountIwsAdvanced = {
            'accountIwsAdvancedIOMapping' : JSON.stringify(accountIwsAdvancedIOMapping),
            'accountIwsAdvancedFilterlogic' : $scope.IWSAdvancedFilterlogic.Name,
            'accountIwsAdvancedCustomFilterlogic' : $scope.customLogicFilter.Name,
            'accountIwsAdvancedCriteriaArray' : JSON.stringify($scope.iwsAdvancedAddressCriteriaArray),       
        }

            API_Connector.Engine.saveIWSAdvancedAddressDetails(objAccountIwsAdvanced, JSON.stringify($scope.objIwsAdvancedAddressService), function (accountIwsAdvancedResponse, event) {
                if(accountIwsAdvancedResponse.success){
                    $loader.hideProcessing();
                    $scope.popUpCheck = true;
                    $timeout(callAtTimeout, 3000);
                }else {
                    console.log('IWS Advanced Account Error', accountIwsAdvancedResponse.message );
                    $scope.popUpCheck = false;
                    $timeout(callAtTimeout, 100);
                }             
            }); 
    }

    $scope.saveIWSServiceDetails = function(){
        var objAccountIws;
        let objIwsService, ServiceName;
        
        if($scope.serviceName.Name == $scope.serviceListObject.IWS_STANDARD_ADDRESS_INFORMATION){
            ServiceName = 'IWSStandardAddressInformationService';
            objIwsService = $scope.objIWSStdAddInfoService;
            $scope.output_IWSStdAddInfoAccountService = checkBlank($scope.output_IWSStdAddInfoAccountService);
            var accountIwsIOMapping = {"InputMapping": [{"name" : "sirenSiret", "value" : objIwsService.Siren}], "OutputMapping" : $scope.output_IWSStdAddInfoAccountService};      
            objAccountIws = {
                'accountIwsIOMapping' : JSON.stringify(accountIwsIOMapping),
                'accountIwsFilterlogic' : $scope.iwsStdAddInfoFilterlogic.Name,
                'accountIwsCustomFilterlogic' : $scope.customLogicFilter.Name,
                'accountIwsCriteriaArray' : JSON.stringify($scope.iwsStdAddInfoCriteriaArray),       
            }            
        }
        if($scope.serviceName.Name == $scope.serviceListObject.IWS_BALANCE_SHEET){
            ServiceName = 'IWSBalanceSheetService';
            objIwsService = $scope.objIWSBalanceSheetService;
            $scope.output_IWSBalanceSheetAccountService = checkBlank($scope.output_IWSBalanceSheetAccountService);
            var accountIwsIOMapping = {"InputMapping": [{"name" : "siren", "value" : objIwsService.Siren}], "OutputMapping" : $scope.output_IWSBalanceSheetAccountService};      
            objAccountIws = {
                'accountIwsIOMapping' : JSON.stringify(accountIwsIOMapping),
                'accountIwsFilterlogic' : $scope.iwsBalanceSheetFilterlogic.Name,
                'accountIwsCustomFilterlogic' : $scope.customLogicFilter.Name,
                'accountIwsCriteriaArray' : JSON.stringify($scope.iwsBalanceSheetCriteriaArray),       
            }            
        }

        //IWS Paydex Info Service 
        if($scope.serviceName.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION) {
            ServiceName = 'IWSPaydexInformationService';
            objIwsService = $scope.objIWSPaydexInfoService;
            $scope.output_IWSPaydexInfoAccountService = checkBlank($scope.output_IWSPaydexInfoAccountService);
            var accountIwsIOMapping = {"InputMapping": [{"name": "siren", "value" : objIwsService.Siren}], "OutputMapping" : $scope.output_IWSPaydexInfoAccountService};
            objAccountIws = {
                'accountIwsIOMapping' : JSON.stringify(accountIwsIOMapping),
                'accountIwsFilterlogic' : $scope.iwsPaydexInfoFilterlogic.Name,
                'accountIwsCustomFilterlogic' : $scope.customLogicFilter.Name,
                'accountIwsCriteriaArray' : JSON.stringify($scope.iwsPaydexInfoCriteriaArray),       
            }
        }  
        
        //IWS Risk Info Service
        if($scope.serviceName.Name == $scope.serviceListObject.IWS_RISK_INFORMATION){
            ServiceName = 'IWSRiskInformationService';
            objIwsService = $scope.objIWSRiskInfoService;
            $scope.output_IWSRiskInfoAccountService = checkBlank($scope.output_IWSRiskInfoAccountService);
            var accountIwsIOMapping = {"InputMapping": [{"name" : "siren", "value" : objIwsService.Siren}], "OutputMapping" : $scope.output_IWSRiskInfoAccountService};      
            objAccountIws = {
                'accountIwsIOMapping' : JSON.stringify(accountIwsIOMapping),
                'accountIwsFilterlogic' : $scope.iwsRiskInfoFilterLogic.Name,
                'accountIwsCustomFilterlogic' : $scope.customLogicFilter.Name,
                'accountIwsCriteriaArray' : JSON.stringify($scope.iwsRiskInfoCriteriaArray),       
            }            
        }

        API_Connector.Engine.saveIWSServiceDetails(ServiceName, objAccountIws, JSON.stringify(objIwsService), function (accountIwsResponse, event) {
            if(accountIwsResponse.success){
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }else {
                console.log('IWS Account Error', accountIwsResponse.message );
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }              
        });
    }

    $scope.saveIndueDServiceDetails = function () {
        let objInduedServiceInfo = $scope.objInduedService;
        $scope.output_IndueDService = checkBlank($scope.output_IndueDService);
        var accountIndueDMappingStep1 = {"InputMapping": [{"name" : "duns", "value" : objInduedServiceInfo.duns},{"name" : "tags", "value" : objInduedServiceInfo.tags}], "OutputMapping" : []};
        var accountIndueDMappingStep2 = {"InputMapping": [{"name" : "duns", "value" : objInduedServiceInfo.duns}], "OutputMapping" : []};
        var accountIndueDMappingStep3 = {"InputMapping": [{"name" : "dued_id", "value" : objInduedServiceInfo.DueDiligenceId}], "OutputMapping" : $scope.output_IndueDService};
        var accountIndueDMappingStep4 = {"InputMapping": [{"name" : "dued_id", "value" : objInduedServiceInfo.DueDiligenceId}], "OutputMapping" : []};
        var accountIndueDMappingStep5 = {"InputMapping": [{"name" : "id", "value" : objInduedServiceInfo.ReportId}], "OutputMapping" : []};
        
        if( $scope.objInduedService.sanctions == null) {
            $scope.objInduedService.sanctions = '';
        }
        if( $scope.objInduedService.peps == null) {
            $scope.objInduedService.peps = '';
        }
        if( $scope.objInduedService.adverse_medias == null) {
            $scope.objInduedService.adverse_medias = '';
        }
        if( $scope.objInduedService.match_confidence == null) {
            $scope.objInduedService.match_confidence = '';
        }
        if( $scope.objInduedService.ownership_threshold == null) {
            $scope.objInduedService.ownership_threshold = '';
        }
        if( $scope.objInduedService.managers_scope == null) {
            $scope.objInduedService.managers_scope = '';
        }

        if( $scope.objInduedService.IsActiveDueDiligenceService == null || $scope.objInduedService.IsActiveDueDiligenceService == undefined ) {
            $scope.objInduedService.IsActiveDueDiligenceService = false;
        }
        
        var objInduedService = {
            'sanctions': $scope.objInduedService.sanctions != '' ? $scope.objInduedService.sanctions : '',
            'peps': $scope.objInduedService.peps != '' ? $scope.objInduedService.peps : '',
            'adverseMedias': $scope.objInduedService.adverse_medias != '' ? $scope.objInduedService.adverse_medias : '',
            'matchConfidence': $scope.objInduedService.match_confidence != '' ? $scope.objInduedService.match_confidence : '',
            'ownershipThreshold': $scope.objInduedService.ownership_threshold != '' ? $scope.objInduedService.ownership_threshold : '',
            'managersScope': $scope.objInduedService.managers_scope != '' ? $scope.objInduedService.managers_scope : '',
            'accountIndueDMappingStep1' : JSON.stringify(accountIndueDMappingStep1),
            'accountIndueDMappingStep2' : JSON.stringify(accountIndueDMappingStep2),
            'accountIndueDMappingStep3' : JSON.stringify(accountIndueDMappingStep3),
            'accountIndueDMappingStep4' : JSON.stringify(accountIndueDMappingStep4),
            'accountIndueDMappingStep5' : JSON.stringify(accountIndueDMappingStep5),
            'accountIndueDFilterlogic' : $scope.indueDServiceFilterlogic.Name,
            'accountIndueDCustomFilterlogic' : $scope.customLogicFilter.Name,
            'accountIndueDCriteriaArray' : JSON.stringify($scope.indueDserviceCriteriaArray), 
            'IsActiveDueDiligenceService' : JSON.stringify($scope.objInduedService.IsActiveDueDiligenceService)      
        }

        API_Connector.Engine.saveInduedServiceDetails(objInduedService, JSON.stringify(objInduedServiceInfo), function (indueDServiceResponse, event) {
            if(indueDServiceResponse.success){
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }else {
                console.log('IndueD Service Error', indueDServiceResponse.message );
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }              
        });
    }

    $scope.saveRiskDatablockServiceDetails = function () {
        let objRiskDatablockServiceInfo = $scope.objRiskDatablockService;
        $scope.output_RiskDatablockAccountService = checkBlank($scope.output_RiskDatablockAccountService);
        var riskDatablockIOMapping = {"InputMapping": [], 'OutputMapping': $scope.output_RiskDatablockAccountService != undefined ||  $scope.output_RiskDatablockAccountService != null ?$scope.output_RiskDatablockAccountService : null };
        var objRiskDatablock = {
            "dunsNumber" : ((objRiskDatablockServiceInfo.dunsNumber == undefined || objRiskDatablockServiceInfo.dunsNumber == null || objRiskDatablockServiceInfo.dunsNumber == '--None--')?"":objRiskDatablockServiceInfo.dunsNumber),
            "riskDatablockIOMapping" : JSON.stringify(riskDatablockIOMapping),
            "riskDatablockDateField" : $scope.objRiskDatablockService.riskDatablockServiceDate,
            "riskDatablockStatusField" : $scope.objRiskDatablockService.riskDatablockServiceStatus,
            "IsActiveRiskDatablock" : JSON.stringify(objRiskDatablockServiceInfo.IsActiveRiskDatablock),
            "IsOnlyRecommended" : JSON.stringify(objRiskDatablockServiceInfo.isOnlyRecommended),
            "CriteriaMapping": objRiskDatablockServiceInfo.criteriaMapping,
            "TradeUp": JSON.stringify(objRiskDatablockServiceInfo.tradeUp),
            "CustomerReference": JSON.stringify(objRiskDatablockServiceInfo.customerReference),
            "OrderReason": JSON.stringify(objRiskDatablockServiceInfo.orderReason),
            "riskDatablockServiceFilterlogic" : $scope.riskDatablockServiceFilterlogic.Name,
            "riskDatablockCustomFilterlogic" : $scope.customLogicFilter.Name,
            "riskDatablockServiceCriteriaArray" : JSON.stringify($scope.riskDatablockServiceCriteriaArray)
        }


        API_Connector.Engine.saveRiskDatablockDetails(objRiskDatablock,  function (riskDatablockResponse, event) {
            if(riskDatablockResponse.success){
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }else {
                console.log('Risk Datablock Error', riskDatablockResponse.message );
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }
           
        });
    }

    //Start Company Report Service
    $scope.saveCompanyReportServiceDetails = function () {
        let objCompanyReportServiceInfo = $scope.objCompanyReportService;
        //$scope.output_RiskDatablockAccountService = checkBlank($scope.output_RiskDatablockAccountService);
        //var riskDatablockIOMapping = {"InputMapping": [], 'OutputMapping': $scope.output_RiskDatablockAccountService != undefined ||  $scope.output_RiskDatablockAccountService != null ?$scope.output_RiskDatablockAccountService : null };
        var objCompanyReport = {
            "dunsNumber" : ((objCompanyReportServiceInfo.dunsNumber == undefined || objCompanyReportServiceInfo.dunsNumber == null || objCompanyReportServiceInfo.dunsNumber == '--None--')?"":objCompanyReportServiceInfo.dunsNumber),
            //"riskDatablockIOMapping" : JSON.stringify(riskDatablockIOMapping),
            "companyReportDateField" : $scope.objCompanyReportService.companyReportServiceDate,
            "companyReportStatusField" : $scope.objCompanyReportService.companyReportServiceStatus,
            "IsActiveCompanyReport" : JSON.stringify(objCompanyReportServiceInfo.IsActiveCompanyReport),
            "inLangage" : objCompanyReportServiceInfo.inLangage,
            "Product_ID": objCompanyReportServiceInfo.Product_ID,
            "TradeUp": JSON.stringify(objCompanyReportServiceInfo.tradeUp),
            "CustomerReference": JSON.stringify(objCompanyReportServiceInfo.customerReference),
            "OrderReason": JSON.stringify(objCompanyReportServiceInfo.orderReason),
            "companyReportServiceFilterlogic" : $scope.companyReportServiceFilterlogic.Name,
            "companyReportCustomFilterlogic" : $scope.customLogicFilter.Name,
            "companyReportServiceCriteriaArray" : JSON.stringify($scope.companyReportServiceCriteriaArray)
        }


        API_Connector.Engine.saveCompanyReportDetails(objCompanyReport,  function (companyReportResponse, event) {
            if(companyReportResponse.success){
                $loader.hideProcessing();
                $scope.popUpCheck = true;
                $timeout(callAtTimeout, 3000);
            }else {
                console.log('Company Report Error', companyReportResponse.message );
                $scope.popUpCheck = false;
                $timeout(callAtTimeout, 100);
            }
           
        });
    }

    $scope.saveAccountGlobalMapping = function () {
        $scope.recordAccountGlobal = checkBlank($scope.recordAccountGlobal);
        $scope.output_AccountGlobal = checkBlank($scope.output_AccountGlobal);
        var accountGlobalIOMapping = {'InputMapping': $scope.recordAccountGlobal, 'OutputMapping': $scope.output_AccountGlobal};
        var accountExclusionCriteria = '';

        for(var index = 0; index <  $scope.lstAccountGlobalExclusionCriteriaSelection.length; index++){
                var item = $scope.lstAccountGlobalExclusionCriteriaSelection[index];
                if(accountExclusionCriteria===''){
                    accountExclusionCriteria = item.value;
                }else{
                    accountExclusionCriteria = accountExclusionCriteria +','+item.value;
                }
        }
        var confidenceLowerLevel = {'confidenceLowerLevelThresholdValue' : $scope.objAccountGlobal.confidenceLowerLevel=='--None--'?8:$scope.objAccountGlobal.confidenceLowerLevel};

        var objAccountGlobal = {
            'accountGlobalIOMapping' : JSON.stringify(accountGlobalIOMapping),
            'accountGlobalStatusField' : $scope.accountGlobalOutRecord.Status,
            'accountGlobalDateField' : $scope.accountGlobalOutRecord.Date,
            'IsAccountGlobalMatchTrigger' : JSON.stringify($scope.objAccountGlobal.IsAccountGlobalMatchTrigger),
            'accountGlobalFilterlogic' : $scope.accountGlobalFilterlogic.Name,
            'accountGlobalCustomFilterlogic' : $scope.customLogicFilter.Name,
            'accountGlobalCriteriaArray' : JSON.stringify($scope.accountGlobalCriteriaArray),
            'accountExclusionCriteria' : JSON.stringify({'exclusionCriteria':accountExclusionCriteria}),
            'accountConfidenceLowerLevel' : JSON.stringify(confidenceLowerLevel)
                }

            API_Connector.Engine.saveAccountGlobalMatchDetails(objAccountGlobal,  function (accountGlobalResponse, event) {
                if(accountGlobalResponse.success){
                    $loader.hideProcessing();
                    $scope.popUpCheck = true;
                    $timeout(callAtTimeout, 3000);
                }else {
                    console.log('Global Account Match Error', accountGlobalResponse.message );
                    $scope.popUpCheck = false;
                    $timeout(callAtTimeout, 100);
                }
               
            });
    }
    function callAtTimeout() {
      var message;
        if ($scope.popUpCheck == true) {
            //'VAT Number Check
            if ($scope.serviceName.Name == $scope.serviceListObject.VAT)
              message = "VAT Number Service Save Successfully.";
            //Credit Check
            if ($scope.serviceName.Name == $scope.serviceListObject.CREDIT_CHECK) 
              message = "Credit Service Save Successfully.";
            //toolkit 
            if ($scope.serviceName.Name == $scope.serviceListObject.ENTERPRISE) 
              message = "Toolkit Enterprise Management Service Save Successfully.";
           //toolkit Quick Check
            if ($scope.serviceName.Name == $scope.serviceListObject.QUICK) 
              message = "Quick Check Service Save Successfully.";
            //dutch chamber account
            if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_KVK) 
              message = "Dutch Chamber Account Service Save Successfully.";
            //dutch chamber account
            if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_KVK ) 
              message = "Dutch Chamber Lead Service Save Successfully.";
            if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_GLOBAL ) 
              message = "Global Match Lead Service Save Successfully.";
            if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_GLOBAL ) 
              message = "Global Match Account Service Save Successfully.";
            if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_TRADE ) 
              message = "Trade Credit Risk Service Saved Successfully.";
            if ($scope.serviceName.Name == $scope.serviceListObject.IWS_SERVICE) 
              message = "Intuiz Web Service Saved Successfully.";
            if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Advanced_Address_Information_Service)            
            message = "IWS Advanced Address Information Service Saved Successfully.";

            // Start IWS Bankruptcy Information Service
            if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Bankruptcy_Information_Service)           
            message = "IWS Bankruptcy Information Service Saved Successfully.";
            // End IWS Bankruptcy Information Service

            if ($scope.serviceName.Name == $scope.serviceListObject.IWS_STANDARD_ADDRESS_INFORMATION)           
            message = "IWS Standard Address Information Service Saved Successfully.";

            // Start Paydex Information Service
            if ($scope.serviceName.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION)
            message = "IWS Paydex Information Service Saved Successfully.";
            // End Paydex Information Service
            
            if ($scope.serviceName.Name == $scope.serviceListObject.IWS_BALANCE_SHEET)
            message = "IWS Balance Sheet Information Service Saved Successfully.";

            //start Global Decision Maker Service   
            if ( $scope.serviceName.Name == $scope.serviceListObject.GLOBAL_DECISION_MAKER ) 
              message = "Global Decision Maker Service Saved Successfully.";
            //end Global Decision Maker Service 
            
            //start risk info service
            if($scope.serviceName.Name == $scope.serviceListObject.IWS_RISK_INFORMATION)
              message = "IWS Risk Information Service Saved Successfully.";
            // end risk info service

             //start risk info service
             if($scope.serviceName.Name == $scope.serviceListObject.INDUED_SERVICE)
             message = "indueD Service Saved Successfully.";
           // end risk info service

            //start risk info service
            if($scope.serviceName.Name == $scope.serviceListObject.RISK_DATABLOCKS)
              message = "Risk Datablocks Service Saved Successfully.";
            // end risk info service

             //start risk info service
             if($scope.serviceName.Name == $scope.serviceListObject.COMPANY_REPORT)
             message = "Company Reports Service Saved Successfully.";
           // end risk info service

            toaster.pop('success', "Success", message);
            $window.location.reload();
        }
        else {
          if ($scope.serviceName.Name == $scope.serviceListObject.VAT)
            message = "VAT Number : Service Not Saved.";
          //Credit Check
          if ($scope.serviceName.Name == $scope.serviceListObject.CREDIT_CHECK)
            message = "Credit : Service Not Saved.";
          //toolkit 
          if ($scope.serviceName.Name == $scope.serviceListObject.ENTERPRISE)
            message = "Toolkit Enterprise Management : Service Not Saved.";
          //toolkit Quick Check
          if ($scope.serviceName.Name == $scope.serviceListObject.QUICK)
            message = "Quick Check : Service Not Saved.";
          //dutch chamber account
          if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_KVK)
            message = "Dutch Chamber Account : Service Not Saved.";
          //dutch chamber account
          if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_KVK )
            message = "Dutch Chamber Lead : Service Not Saved.";
          //Lead Global Match 
         if ($scope.serviceName.Name == $scope.serviceListObject.LEAD_GLOBAL )
            message = "Global Match Lead : Service Not Saved.";
        if ($scope.serviceName.Name == $scope.serviceListObject.ACCOUNT_TRADE )
            message = "Trade Credit Risk : Service Not Saved.";
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_SERVICE) 
            message = "Intuiz Web Service : Service Not Saved.";   
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Advanced_Address_Information_Service)            
        message = "IWS Advanced Address Information : Service Not Saved.";
        // Start IWS Bankruptcy Information Service
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_Bankruptcy_Information_Service)           
        message = "IWS Bankruptcy Information Service : Service Not Saved.";
        // End IWS Bankruptcy Information Service
        
        // Start IWS Paydex Informaion Service
        if($scope.serviceName.Name == $scope.serviceListObject.IWS_PAYDEX_INFORMATION)
        message = "IWS Paydex Information Service : Service Not Saved.";
        // End Paydex Information Service

        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_BALANCE_SHEET)
            message = "IWS Balance Sheet Information Service : Service Not Saved.";
        //start Global Decision Maker Service 
        if ( $scope.serviceName.Name == $scope.serviceListObject.GLOBAL_DECISION_MAKER ) 
            message = "Global Decision Maker : Service Not Saved.";
        //end Global Decision Maker Service    
        if ($scope.serviceName.Name == $scope.serviceListObject.IWS_STANDARD_ADDRESS_INFORMATION)           
        message = "IWS Standard Address Information : Service Not Saved.";  

        //start risk information service
        if($scope.serviceName.Name == $scope.serviceListObject.IWS_RISK_INFORMATION)
            message = "IWS Risk Information : Service Not Saved";
        //end risk information service
          toaster.pop('error', "Error", message);
          $loader.hideProcessing();
        }
    }
   
    $scope.saveInfo = function (objName) {
        var objInfo = { 'DuplicateUserName': $scope.objDuplicate.Username, 'DuplicatePassword': $scope.objDuplicate.Password, 'ContactUsername': $scope.objDuplicate.ContactUsername, 'ContactPassword': $scope.objDuplicate.ContactPassword, 'IsAccount': $scope.objDuplicate.IsAccount, 'IsContact': $scope.objDuplicate.IsContact, 'AccountStatus': $scope.accRecord.Status, 'AccountDate': $scope.accRecord.Date, 'ContactStatus': $scope.conRecord.Status, 'ContactDate': $scope.conRecord.Date, 'AccFilterLogic': $scope.accFilterlogic.Name, 'ConFilterLogic': $scope.conFilterlogic.Name, 'ObjName': objName, 'CustomLogic': $scope.customLogicFilter.Name };
        API_Connector.Engine.saveUserInfo(JSON.stringify(objInfo), JSON.stringify($scope.accCriteriaArray), JSON.stringify($scope.conCriteriaArray), function (result, event) {
            if (result != null && result == true) {
                $loader.hideProcessing();
                toaster.pop('success', "Success", "User Info Save Successfully");
                $window.location.reload();

            } else {
                $loader.hideProcessing();
                toaster.pop('error', "Error", "Something Went Wrong");
            }

        }, { buffer: true, escape: false })
    },

    $scope.makeOutputFieldsToBlank = function () {
      if ($scope.vatRecord.Status == '--None--') {
        $scope.vatRecord.Status = '';
      }
      if ($scope.vatRecord.Date == '--None--') {
        $scope.vatRecord.Date = '';
      }
      if ($scope.vatRecord.Identifier == '--None--') {
        $scope.vatRecord.Identifier = '';
      }
      if ($scope.accRecord.Date == '--None--') {
        $scope.accRecord.Date = '';
      }
      if ($scope.accRecord.Status == '--None--') {
        $scope.accRecord.Status = '';
      }
      angular.forEach($scope.output_Account, function (value, key) {
        if (value.name == '--None--') {
          value.name = '';
        }
      })
      if ($scope.conRecord.Status == '--None--') {
        $scope.conRecord.Status = '';
      }
      if ($scope.conRecord.Date == '--None--') {
        $scope.conRecord.Date = '';
      }
      angular.forEach($scope.output_Contact, function (value, key) {
        if (value.name == '--None--') {
          value.name = '';
        }
      })
      angular.forEach($scope.recordLeadGlobal, function (value, key) {
        if (value.name == '--None--') {
          value.name = '';
        }
        })
      angular.forEach($scope.output_LeadGlobal, function (value, key) {
        if (value.name == '--None--') {
          value.name = '';
        }
        })
       angular.forEach($scope.output_AccountGlobal, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })
        angular.forEach($scope.recordAccountGlobal, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })
        //Start Issue - "Output field mapped and loader issue"
        angular.forEach($scope.output_AccountTradeCredit, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })
        angular.forEach($scope.output_toolkitQC, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })       
        angular.forEach($scope.output_IWSAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })
       
        angular.forEach($scope.output_IWSAdvancedAddressAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        }) 
        
        // Start IWS Bankruptcy Information Service
        angular.forEach($scope.output_IWSBankruptcyInfoAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        }) 
        // End IWS Bankruptcy Information Service
        angular.forEach($scope.input_IWSAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        }) 
        angular.forEach($scope.output_IWSStdAddInfoAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })
        //Start IWS Paydex Information Service
        angular.forEach($scope.output_IWSPaydexInfoAccountService, function (value, key) {
            if(value.name == '--None--') {
                value.name = '';
            }
        })
        //End IWS Paydex Info Service

        angular.forEach($scope.input_IWSStdAddInfoAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        //start IWS Risk Info Service    
        angular.forEach($scope.output_IWSRiskInfoAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        angular.forEach($scope.input_IWSRiskInfoAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
            //End IWS Risk Info Service    
            })   
        })    
        })
        //Start Risk Datablock service
        angular.forEach($scope.output_RiskDatablockAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })
        angular.forEach($scope.input_RiskDatablockAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        //End Risk Datablock Service    
        }) 
        angular.forEach($scope.output_IWSBalanceSheetAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })
        angular.forEach($scope.input_IWSBalanceSheetAccountService, function (value, key) {
            if (value.name == '--None--') {
                value.name = '';
            }
        })
        //End Issue - "Output field mapped and loader issue"
      if ($scope.creditRecord.Status == '--None--' || $scope.creditRecord.Status == undefined) {
        $scope.creditRecord.Status = '';
      }
      if ($scope.creditRecord.Date == '--None--' || $scope.creditRecord.Date ==  undefined) {
        $scope.creditRecord.Date = '';
      }
      if ($scope.creditRecord.Value == '--None--' || $scope.creditRecord.Value == undefined) {
        $scope.creditRecord.Value = '';
      }
      if ($scope.objToolkitEnterprise.ToolkitDate == '--None--') {
        $scope.objToolkitEnterprise.ToolkitDate = '';
      }
      if ($scope.objToolkitEnterprise.ToolkitStatus == '--None--') {
        $scope.objToolkitEnterprise.ToolkitStatus = '';
      }
      if ($scope.objToolkitQuickCheck.ToolkitDate == '--None--') {
        $scope.objToolkitQuickCheck.ToolkitDate = '';
      }
      if ($scope.objToolkitQuickCheck.ToolkitStatus == '--None--') {
        $scope.objToolkitQuickCheck.ToolkitStatus = '';
      }
      // IWS Service
      if ($scope.objIwsService.IwsServiceDate == '--None--') {
        $scope.objIwsService.IwsServiceDate = '';
      }
      if ($scope.objIwsService.IwsServiceStatus == '--None--') {
        $scope.objIwsService.IwsServiceStatus = '';
      }
      //End IWS Service

      // IWS Paydex Info Service
      if ($scope.objIWSPaydexInfoService.IwsServiceDate == '--None--') {
        $scope.objIWSPaydexInfoService.IwsServiceDate = '';
      }
      if ($scope.objIWSPaydexInfoService.IwsServiceStatus == '--None--') {
        $scope.objIWSPaydexInfoService.IwsServiceStatus = '';
      }
      //End Paydex Info Service

      // IWS Risk Info Service
      if ($scope.objIWSRiskInfoService.IwsServiceDate == '--None--') {
        $scope.objIWSRiskInfoService.IwsServiceDate = '';
      }
      if ($scope.objIWSRiskInfoService.IwsServiceStatus == '--None--') {
        $scope.objIWSRiskInfoService.IwsServiceStatus = '';
      }
      //End Risk Info Service

      // Risk Datablock Service
      if ($scope.objRiskDatablockService.riskDatablockServiceDate == '--None--') {
        $scope.objRiskDatablockService.riskDatablockServiceDate = '';
      }
      if ($scope.objRiskDatablockService.riskDatablockServiceStatus == '--None--') {
        $scope.objRiskDatablockService.riskDatablockServiceStatus = '';
      }
      //End Risk Info Service
      // IWS Standard Advance Info Service
      if ($scope.objIWSStdAddInfoService.IwsServiceDate == '--None--') {
        $scope.objIWSStdAddInfoService.IwsServiceDate = '';
      }
      if ($scope.objIWSStdAddInfoService.IwsServiceStatus == '--None--') {
        $scope.objIWSStdAddInfoService.IwsServiceStatus = '';
      }
      //End Standard Advance Info Service

      // IWS Balance Sheet Service
      if ($scope.objIWSBalanceSheetService.IwsServiceDate == '--None--') {
        $scope.objIWSBalanceSheetService.IwsServiceDate = '';
      }
      if ($scope.objIWSBalanceSheetService.IwsServiceStatus == '--None--') {
        $scope.objIWSBalanceSheetService.IwsServiceStatus = '';
      }
      //End Balance Sheet Service

      // Start IWS Advanced Address Information Service
      if ($scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceDate == '--None--') {
        $scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceDate = '';
      }
      if ($scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceStatus == '--None--') {
        $scope.objIwsAdvancedAddressService.IwsAdvancedAddressServiceStatus = '';
      }

      // Start IWS Bankruptcy Information Service
      if ($scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceDate == '--None--') {
        $scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceDate = '';
      }
      if ($scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceStatus == '--None--') {
        $scope.objIwsBankruptcyInfoService.IwsBankruptcyInfoServiceStatus = '';
      }
      // End IWS Bankruptcy Information Service

      if ($scope.leadGlobalOutRecord.Date == '--None--') {
        $scope.leadGlobalOutRecord.Date = '';
      }
      if ($scope.leadGlobalOutRecord.Status == '--None--') {
        $scope.leadGlobalOutRecord.Status = '';
      }
      if ($scope.accountGlobalOutRecord.Date == '--None--') {
        $scope.accountGlobalOutRecord.Date = '';
      }
      if ($scope.accountGlobalOutRecord.Status == '--None--') {
        $scope.accountGlobalOutRecord.Status = '';
      }
      if ($scope.accountTradeCreditDateStatusRecord.Date == '--None--') {
        $scope.accountTradeCreditDateStatusRecord.Date = '';
      }
      if ($scope.accountTradeCreditDateStatusRecord.Status == '--None--') {
        $scope.accountTradeCreditDateStatusRecord.Status = '';
      }
      angular.forEach($scope.output_toolkit, function (value, key) {
        if (value.name == '--None--') {
          value.name = '';
        }
      })
      if ($scope.accKvkRecord.Date == '--None--') {
        $scope.accKvkRecord.Date = '';
      }
      if ($scope.accKvkRecord.Status == '--None--') {
        $scope.accKvkRecord.Status = '';
      }
      angular.forEach($scope.Output_AccountKvk, function (value, key) {
        if (value.name == '--None--') {
          value.name = '';
        }
      })
      if ($scope.leadKvkRecord.Date == '--None--') {
        $scope.leadKvkRecord.Date = '';
      }
      if ($scope.leadKvkRecord.Status == '--None--') {
        $scope.leadKvkRecord.Status = '';
      }
      angular.forEach($scope.Output_LeadKvk, function (value, key) {
        if (value.name == '--None--') {
          value.name = '';
        }
      })
    }
    function makeUndefinedBlank(input) {
      if (input == undefined)
        return '';
      else
        return input;
    }

    $scope.criteriaMappingChange = function(criteriaName) {
        $scope.assignmentOfResponseField(criteriaName);
    }
}])
.directive('lookUpWindow', function () {
return {
    restrict: 'EA',
    templateUrl: application_js + "templates/show-window.html",
    scope: {
        recordList: '=recordList'
    },
    controller: ["$scope", function ($scope) {
        $scope.searchKeyword = '';

    }]
}


})
.directive('addRow', function ($rootScope) {
return {
  templateUrl: function (element, template) {
    
    if (template['template'] != undefined)
      return application_js + template['template'];
    else
      return application_js + "templates/addRowTemplate.html";
    },
    restrict: 'AE',
    scope: {
        outputToolkit: '=outputToolkit',
        customlabel: '=customlabel',
        accountFieldsDataTypeList: '=accountFieldsDataTypeList',
        accountFields: '=accountFields',
        outputfldsToolkit: '=outputfldsToolkit',
        addNewRow: '&',
        removeRow: '&',
        cancelMapping: '&',
        objToolkitEnterprise: '=objToolkitEnterprise',
        service: '=service',
        currentstep: '=',

    },

    controller: ['$scope', 'toaster', function ($scope, toaster) {
        
        console.log('service::' + $scope.service);
        $scope.objType = $scope.service;
        $scope.myFunc = function (NewValue) {
          if ($scope.currentstep != undefined && $scope.currentstep == 5) {
            $scope.$parent.IsSave = false;
          }
          else{
            if (NewValue == '--None--') {
                toaster.pop('error', "Error", "Something Went Wrong");
                $scope.$parent.IsSave = true;
            } else {
                $scope.$parent.IsSave = false;
            }
          }

        },
      $scope.getDataTypeFilteredLst = function (dataTypeName, lstRecords) {
        var tempLst = [];
        for (var i = 0; i < lstRecords.length; i++) {
          if (lstRecords[i].DataType == dataTypeName)
            tempLst.push(lstRecords[i]);
        }
        console.log('tempLst:'+tempLst);
        return tempLst;
      }
    }]
}

})
.factory("$loader", function () {
var loader = {
    getLoader: function () {
        if ($("#loadingContainer").length == 0) {
            $('body').append('<div id="loadingContainer" style="z-index: 9999;"><img class="loader" src="' + application_css + "images/ring.gif" + '"/><p style="font-family: solid; font-size: 25px; color: white;">Loading..</p></div>');
            $("#loadingContainer").hide();
        }
    },
    showProcessing: function () {
        $("#loadingContainer").show();
    },
    hideProcessing: function () {
        $("#loadingContainer").hide();
    }
}
return loader;
});
