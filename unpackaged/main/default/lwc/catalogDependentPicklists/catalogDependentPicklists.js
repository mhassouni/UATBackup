/*   ************* GFC-1192 ************* 
*   Developed by : Hicham El Achboura
*   Date : 27/12/2022
*   Comment : This Component is used to Search Catalogues availabilities consuming Talend Webservices 
*/
import { LightningElement, wire, track , api } from 'lwc';
/** Update an specific Record */
import { getRecordNotifyChange } from "lightning/uiRecordApi";
/** SObjects */
import BaseProduit from '@salesforce/schema/Base_produit__c';
import Quote from '@salesforce/schema/Quote';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
/** Apex methods from SampleLookupController */
import getCatalogDependentValues from '@salesforce/apex/DependentPicklistGenerator.getCatalogDependentValues';
import getAllBaseProduitRecords from '@salesforce/apex/DependentPicklistGenerator.getAllBaseProduitRecords';
import SearchCatalogueFromLWC from '@salesforce/apex/CatalogueController.SearchCatalogueFromLWC';
/** Standard Refresh Method */
import { refreshApex } from '@salesforce/apex';
/** Standard Show Toast Event => Alert POPUP */
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
/** Labels */
import Catalogue_DisplayErrorDM from "@salesforce/label/c.Catalogue_DisplayErrorDM";
import Catalogue_DisplayInfo from "@salesforce/label/c.Catalogue_DisplayInfo";
import Catalogue_DisplayNotFound from "@salesforce/label/c.Catalogue_DisplayNotFound";
import Catalogue_DisplayCreated from "@salesforce/label/c.Catalogue_DisplayCreated";
import Catalogue_DisplayError from "@salesforce/label/c.Catalogue_DisplayError";
import Catalogue_DisplayNotAllowed from "@salesforce/label/c.Catalogue_DisplayNotAllowed";
import Catalogue_CatalogueNotAllowed from "@salesforce/label/c.Catalogue_CatalogueNotAllowed";
import Catalogue_DisplayErrorDM_title from "@salesforce/label/c.Catalogue_DisplayErrorDM_title";
import Catalogue_LWC_Chercher from "@salesforce/label/c.Catalogue_LWC_Chercher";
import Catalogue_LWC_Reset from "@salesforce/label/c.Catalogue_LWC_Reset";
import Catalogue_Select_catalogue from "@salesforce/label/c.Catalogue_Select_catalogue";
import Catalogue_Select_CodePays from "@salesforce/label/c.Catalogue_Select_CodePays";
import Catalogue_Select_CodePF from "@salesforce/label/c.Catalogue_Select_CodePF";
import Catalogue_Select_Marque from "@salesforce/label/c.Catalogue_Select_Marque";
import Catalogue_Select_Modele from "@salesforce/label/c.Catalogue_Select_Modele";
import Catalogue_Select_StandardPF from "@salesforce/label/c.Catalogue_Select_StandardPF";
import Catalogue_Label_CataloguePF from "@salesforce/label/c.Catalogue_Label_CataloguePF";
import Catalogue_Label_CodePays from "@salesforce/label/c.Catalogue_Label_CodePays";
import Catalogue_Label_CodePF from "@salesforce/label/c.Catalogue_Label_CodePF";
import Catalogue_Label_Marque from "@salesforce/label/c.Catalogue_Label_Marque";
import Catalogue_Label_Modele from "@salesforce/label/c.Catalogue_Label_Modele";
import Catalogue_Label_StandardPF from "@salesforce/label/c.Catalogue_Label_StandardPF";
import Catalogue_DisplayError_EmptyFields from "@salesforce/label/c.Catalogue_DisplayError_EmptyFields";
import Catalogue_Response_Title from "@salesforce/label/c.Catalogue_Response_Title";

export default class CatalogDependentPicklists extends LightningElement 
{
    // Private Variables        
    CurrentExecution = 0; 
    QueryPart_01 = 'Select  Code_Pays__c, Catalogue__c, Code_PF__c, Standard__c, Marque__c, Modele__c from Base_produit__c  ' ;
    QueryPart_011 = 'Select  Code_Pays__c, Catalogue__c, Code_PF__c, Standard__c, Marque__c, Modele__c from Base_produit__c ' ;
    QueryPart_02 = ' Group By  Code_Pays__c, Catalogue__c, Code_PF__c, Standard__c, Marque__c, Modele__c '; 
    OperatorAND = ' AND ';
    //OperatorAND = ' OR ';
    OperatorWhere = ' WHERE ';
    QueryCode_Pays = ' Code_Pays__c = :CodePaysParam ' ;
    QueryCatalogue = ' Catalogue__c = :CatalogueParam ' ;
    QueryCode_PF = ' Code_PF__c = :CodePFParam ' ;
    QueryStandard = ' Standard__c = :StandardPFParam ' ;
    QueryMarque = ' Marque__c = :MarqueParam ' ;
    QueryModele = ' Modele__c = :ModeleParam ' ;
    Catalogue_DisplayInfo = Catalogue_DisplayInfo;
    Catalogue_LWC_Chercher = Catalogue_LWC_Chercher;
    Catalogue_LWC_Reset = Catalogue_LWC_Reset;
    Catalogue_Select_catalogue = Catalogue_Select_catalogue;
    Catalogue_Select_CodePays = Catalogue_Select_CodePays;
    Catalogue_Select_CodePF = Catalogue_Select_CodePF;
    Catalogue_Select_Marque = Catalogue_Select_Marque;
    Catalogue_Select_Modele = Catalogue_Select_Modele;
    Catalogue_Select_StandardPF = Catalogue_Select_StandardPF;
    Catalogue_Label_CodePays = Catalogue_Label_CodePays;
    Catalogue_Label_CodePF = Catalogue_Label_CodePF;
    Catalogue_Label_Marque = Catalogue_Label_Marque;
    Catalogue_Label_Modele = Catalogue_Label_Modele;
    Catalogue_Label_StandardPF = Catalogue_Label_StandardPF;
    Catalogue_Label_CataloguePF = Catalogue_Label_CataloguePF;
    Catalogue_DisplayError_EmptyFields = Catalogue_DisplayError_EmptyFields;
    Catalogue_Response_Title = Catalogue_Response_Title;

    // Public Variables        
    @api recordId;
    @api codePaysLabel = Catalogue_Label_CodePays;
    @api codePaysFieldName = 'Code_Pays__c';
    @api catalogueLabel = Catalogue_Label_CataloguePF;
    @api catalogueFieldName = 'Catalogue__c';
    @api codePFLabel = Catalogue_Label_CodePF;
    @api codePFFieldName = 'Code_PF__c';
    @api standardPFLabel = Catalogue_Label_StandardPF;
    @api standardPFFieldName = 'Standard__c';
    @api marqueLabel = Catalogue_Label_Marque;
    @api marqueFieldName = 'Marque__c';
    @api modeleLabel = Catalogue_Label_Modele;
    @api modeleFieldName = 'Mod_le__c';

    // Tracked Variables    
    @track showpicklist = true;     
    @track CodePaysOptionsValue = [];
    @track CodePaysOptionsValueBackUp = [];
    @track CodePaysOptionsValueTemp = [{label : Catalogue_Select_CodePays, value :''}];
    @track CodePaysSelectedValue = '';
    @track CatalogueOptionsValue = []; 
    @track CatalogueOptionsValueBackUp = []; 
    @track CatalogueOptionsValueTemp = [{label : Catalogue_Select_catalogue, value :''}]; 
    @track CatalogueSelectedValue = '';
    @track CodePFOptionsValue = [];
    @track CodePFOptionsValueBackUp = [];
    @track CodePFOptionsValueTemp = [{label : Catalogue_Select_CodePF, value :''}];    
    @track CodePFSelectedValue = '';
    @track StandardPFOptionsValue = []; 
    @track StandardPFOptionsValueBackUp = []; 
    @track StandardPFOptionsValueTemp = [{label : Catalogue_Select_StandardPF, value :''}]; 
    @track StandardPFSelectedValue = '';
    @track MarqueOptionsValue = [];
    @track MarqueOptionsValueBackUp = [];
    @track MarqueOptionsValueTemp = [{label : Catalogue_Select_Marque, value :''}]; 
    @track MarqueSelectedValue = '';
    @track ModeleOptionsValue = [];
    @track ModeleOptionsValueBackUp = [];
    @track ModeleOptionsValueTemp = [{label : Catalogue_Select_Modele, value :''}]; 
    @track ModeleSelectedValue = '';
    @track CodePaysParam = '';
    @track CatalogueParam = '';
    @track CodePFParam = '';
    @track StandardPFParam = '';
    @track MarqueParam = '';
    @track ModeleParam = '';
    @track DataLength;
    @track QueryToApexMethod =   this.QueryPart_01; 
    @track QueryToApexMethod2 =   this.QueryPart_011; 
    @track wiredgetAllBaseProduitRecords;
    @track KeyToSortMethod = 'value';
    @track DirectionToSortMethod = 'asc';
    @track LoadingSpinner = false;
    

    /* 
    *   This method is used to sort data
    *   KeyToSortMethod => key of the array
    *   DirectionToSortMethod => the direction of the sorting method => ASC or DESC
    */
    sortData(Data, Key, Direction) 
    {
        let keyValue = (a) => 
        {
            return a[Key];
        };
        //let isReverse = Direction === "asc" ? 1 : -1;
        //let isReverse = 1;
        Data.sort((x, y) => 
        {
            x = keyValue(x) ? keyValue(x) : "";
            y = keyValue(y) ? keyValue(y) : "";
            x = typeof x === 'string' ? x.toLowerCase() : x.toString();
            y = typeof y === 'string' ? y.toLowerCase() : y.toString();
            return x.localeCompare(y);
        });
        return Data;
    }

    /* 
    *   This method is used to get all Base Produit ( SObject ) records
    *   We're also going to use apex method (getAllRecords)
    *   in order to get all records from Salesforce
    */
    @wire(getAllBaseProduitRecords)
    wiredgetAllBaseProduitRecords({ error, data }) 
    {
        this.wiredgetAllBaseProduitRecords = data;
        if(data)
        {          
            let Accepted = false; 
            let CodePaysTemp = [];
            let CatalogueTemp = [];
            let CodePFTemp = [];
            let StandardTemp = [];
            let MarqueTemp = [];
            let ModeleTemp = [];
            let CodePaysTempDuplicated = [];
            let CatalogueTempDuplicated = [];
            let CodePFTempDuplicated = [];
            let StandardTempDuplicated = [];
            let MarqueTempDuplicated = [];
            let ModeleTempDuplicated = [];
            var values = data;

            for(var keys in values)
            {
                keys.includes('Code_Pays__c') == true ? CodePaysTempDuplicated.push(values[keys]) : CodePaysTempDuplicated ;
                keys.includes('Catalogue__c') == true ? CatalogueTempDuplicated.push(values[keys]) : CatalogueTempDuplicated ;
                keys.includes('Code_PF__c') == true ? CodePFTempDuplicated.push(values[keys]) : CodePFTempDuplicated ;
                keys.includes('Standard__c') == true ? StandardTempDuplicated.push(values[keys]) : StandardTempDuplicated ;
                keys.includes('Marque__c') == true ? MarqueTempDuplicated.push(values[keys]) : MarqueTempDuplicated ;
                keys.includes('Modele__c') == true ? ModeleTempDuplicated.push(values[keys]) : ModeleTempDuplicated ;
            };
            
            CodePaysTemp = new Set(CodePaysTempDuplicated);
            CatalogueTemp = new Set(CatalogueTempDuplicated);
            CodePFTemp = new Set(CodePFTempDuplicated);
            StandardTemp = new Set(StandardTempDuplicated);
            MarqueTemp = new Set(MarqueTempDuplicated);
            ModeleTemp = new Set(ModeleTempDuplicated);

            this.CodePaysOptionsValueBackUp.includes(CodePaysTemp) == true ?  Accepted = true : '' ;
            this.CatalogueOptionsValueBackUp.includes(CatalogueTemp) == true ?  Accepted = true : '' ;
            this.CodePFOptionsValueBackUp.includes(CodePFTemp) == true ?  Accepted = true : '' ;
            this.StandardPFOptionsValueBackUp.includes(StandardTemp) == true ?  Accepted = true : '' ;
            this.MarqueOptionsValueBackUp.includes(MarqueTemp) == true ?  Accepted = true : '' ;
            this.ModeleOptionsValueBackUp.includes(ModeleTemp) == true ?  Accepted = true : '' ;
    
            CodePaysTemp.forEach(optionData => {
                this.CodePaysOptionsValueTemp.push({label : optionData, value : optionData});
            });
            CatalogueTemp.forEach(optionData => {
            this.CatalogueOptionsValueTemp.push({label : optionData, value : optionData});
            });
            CodePFTemp.forEach(optionData => {
            this.CodePFOptionsValueTemp.push({label : optionData, value : optionData});
            });
            StandardTemp.forEach(optionData => {
            this.StandardPFOptionsValueTemp.push({label : optionData, value : optionData});
            });
            MarqueTemp.forEach(optionData => {
            this.MarqueOptionsValueTemp.push({label : optionData, value : optionData});
            });
            ModeleTemp.forEach(optionData => {
            this.ModeleOptionsValueTemp.push({label : optionData, value : optionData});
            });
            this.sortData(this.CodePaysOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
            this.sortData(this.CatalogueOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
            this.sortData(this.CodePFOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
            this.sortData(this.StandardPFOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
            this.sortData(this.MarqueOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
            this.sortData(this.ModeleOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
                   

            this.CodePaysOptionsValue = this.CodePaysOptionsValueTemp;
            this.CodePaysOptionsValueBackUp = this.CodePaysOptionsValue;
            this.CatalogueOptionsValue = this.CatalogueOptionsValueTemp;
            this.CatalogueOptionsValueBackUp = this.CatalogueOptionsValue;
            this.CodePFOptionsValue = this.CodePFOptionsValueTemp;
            this.CodePFOptionsValueBackUp = this.CodePFOptionsValue;
            this.StandardPFOptionsValue = this.StandardPFOptionsValueTemp;
            this.StandardPFOptionsValueBackUp = this.StandardPFOptionsValue;
            this.MarqueOptionsValue = this.MarqueOptionsValueTemp;
            this.MarqueOptionsValueBackUp = this.MarqueOptionsValue;
            this.ModeleOptionsValue = this.ModeleOptionsValueTemp;
            this.ModeleOptionsValueBackUp = this.ModeleOptionsValue;            
        }
       else if (error) 
        {
            this.template.querySelector("[data-id='Code_Pays__c']").value = '';
            this.template.querySelector("[data-id='Catalogue__c']").value = '';
            this.template.querySelector("[data-id='Code_PF__c']").value = '';
            this.template.querySelector("[data-id='Standard__c']").value = '';
            this.template.querySelector("[data-id='Marque__c']").value = '';
            this.template.querySelector("[data-id='Modele__c']").value = '';
            
            this.CodePaysOptionsValue = this.CodePaysOptionsValueBackUp;
            this.CatalogueOptionsValue = this.CatalogueOptionsValueBackUp;
            this.CodePFOptionsValue = this.CodePFOptionsValueBackUp;
            this.StandardPFOptionsValue = this.StandardPFOptionsValueBackUp;
            this.MarqueOptionsValue = this.MarqueOptionsValueBackUp;
            this.ModeleOptionsValue = this.ModeleOptionsValueBackUp;
            console.log('error');
            console.log(error);
             /** Standard Show Toast Event => Alert POPUP */
             const evt = new ShowToastEvent(
                {
                    title: 'Error Type : ' + error.statusText ,
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissible',
                });
                this.dispatchEvent(evt);
        }
    } 

    /* 
    *   This method is used to handle OnChange event 
    *   We need to generate SOQL Query. We're also going
    *   to populate the generated SOQL query into apex method (getCodePaysDependentValues)
    *   in order to get all dependent Base Produit records
    */
    fetchDependentPicklistsValues(event)
    {  
        this.LoadingSpinner = true;
        if( ( (event.target.name == 'Code_Pays__c' || event.target.name == 'Code_Pays_FlowInput__c') && this.QueryToApexMethod.includes(':CodePaysParam') == false  && this.CurrentExecution != 0 )  )
        {
            this.QueryToApexMethod += this.OperatorAND + this.QueryCode_Pays;
            this.CurrentExecution += 1;
            this.CodePaysParam = event.target.value;
        }
        
        else if( ( (event.target.name == 'Code_Pays__c' || event.target.name == 'Code_Pays_FlowInput__c') && this.QueryToApexMethod.includes(':CodePaysParam') == false  && this.CurrentExecution == 0 )  )
        {
            this.QueryToApexMethod += this.OperatorWhere + this.QueryCode_Pays;
            this.CurrentExecution += 1;
            this.CodePaysParam = event.target.value;
        }
        
        else if ( ( (event.target.name == 'Code_Pays__c' || event.target.name == 'Code_Pays_FlowInput__c') && this.QueryToApexMethod.includes(':CodePaysParam') == true && this.CurrentExecution != 0 ) )
        {
            this.CodePaysParam = event.target.value;
        }

        else if( ( (event.target.name == 'Catalogue__c' || event.target.name == 'Catalogue_FlowInput__c') && this.QueryToApexMethod.includes(':CatalogueParam') == false  && this.CurrentExecution != 0 )  )
        {
            this.QueryToApexMethod += this.OperatorAND + this.QueryCatalogue;
            this.CurrentExecution += 1;
            this.CatalogueParam = event.target.value;
        }
        
        else if( ( (event.target.name == 'Catalogue__c' || event.target.name == 'Catalogue_FlowInput__c') && this.QueryToApexMethod.includes(':CatalogueParam') == false  && this.CurrentExecution == 0 )  )
        {
            this.QueryToApexMethod += this.OperatorWhere + this.QueryCatalogue;
            this.CurrentExecution += 1;
            this.CatalogueParam = event.target.value;
        }
        
        else if ( ( (event.target.name == 'Catalogue__c' || event.target.name == 'Catalogue_FlowInput__c') && this.QueryToApexMethod.includes(':CatalogueParam') == true && this.CurrentExecution != 0 ) )
        {
            this.CatalogueParam = event.target.value;
        }

        else if( ( (event.target.name == 'Code_PF__c' || event.target.name == 'Code_PF_FlowInput__c') && this.QueryToApexMethod.includes(':CodePFParam') == false  && this.CurrentExecution != 0 )  )
        {
            this.QueryToApexMethod += this.OperatorAND + this.QueryCode_PF;
            this.CurrentExecution += 1;
            this.CodePFParam = event.target.value;
        }
        
        else if( ( (event.target.name == 'Code_PF__c' || event.target.name == 'Code_PF_FlowInput__c') && this.QueryToApexMethod.includes(':CodePFParam') == false  && this.CurrentExecution == 0 )  )
        {
            this.QueryToApexMethod += this.OperatorWhere + this.QueryCode_PF;
            this.CurrentExecution += 1;
            this.CodePFParam = event.target.value;
        }
        
        else if ( ( (event.target.name == 'Code_PF__c' || event.target.name == 'Code_PF_FlowInput__c') && this.QueryToApexMethod.includes(':CodePFParam') == true && this.CurrentExecution != 0 ) )
        {
            this.CodePFParam = event.target.value;
        }

        else if( ( (event.target.name == 'Standard__c' || event.target.name == 'Standard_PF_FlowInput__c') && this.QueryToApexMethod.includes(':StandardPFParam') == false  && this.CurrentExecution != 0 )  )
        {
            this.QueryToApexMethod += this.OperatorAND + this.QueryStandard;
            this.CurrentExecution += 1;
            this.StandardPFParam = event.target.value;
        }
        
        else if( ( (event.target.name == 'Standard__c' || event.target.name == 'Standard_PF_FlowInput__c') && this.QueryToApexMethod.includes(':StandardPFParam') == false  && this.CurrentExecution == 0 )  )
        {
            this.QueryToApexMethod += this.OperatorWhere + this.QueryStandard;
            this.CurrentExecution += 1;
            this.StandardPFParam = event.target.value;
        }
        
        else if ( ( (event.target.name == 'Standard__c' || event.target.name == 'Standard_PF_FlowInput__c') && this.QueryToApexMethod.includes(':StandardPFParam') == true && this.CurrentExecution != 0 ) )
        {
            this.StandardPFParam = event.target.value;
        }

        else if( ( (event.target.name == 'Marque__c' ) && this.QueryToApexMethod.includes(':MarqueParam') == false  && this.CurrentExecution != 0 )  )
        {
            this.QueryToApexMethod += this.OperatorAND + this.QueryMarque;
            this.CurrentExecution += 1;
            this.MarqueParam = event.target.value;
        }
        
        else if( ( (event.target.name == 'Marque__c' ) && this.QueryToApexMethod.includes(':MarqueParam') == false  && this.CurrentExecution == 0 )  )
        {
            this.QueryToApexMethod += this.OperatorWhere + this.QueryMarque;
            this.CurrentExecution += 1;
            this.MarqueParam = event.target.value;
        }
        
        else if ( ( (event.target.name == 'Marque__c' ) && this.QueryToApexMethod.includes(':MarqueParam') == true && this.CurrentExecution != 0 ) )
        {
            this.MarqueParam = event.target.value;
        }

        else if( ( (event.target.name == 'Modele__c' || event.target.name == 'Mod_le__c') && this.QueryToApexMethod.includes(':ModeleParam') == false  && this.CurrentExecution != 0 )  )
        {
            this.QueryToApexMethod += this.OperatorAND + this.QueryModele;
            this.CurrentExecution += 1;
            this.ModeleParam = event.target.value;
        }
        
        else if( ( (event.target.name == 'Modele__c' || event.target.name == 'Mod_le__c') && this.QueryToApexMethod.includes(':ModeleParam') == false  && this.CurrentExecution == 0 )  )
        {
            this.QueryToApexMethod += this.OperatorWhere + this.QueryModele;
            this.CurrentExecution += 1;
            this.ModeleParam = event.target.value;
        }
        
        else if ( ( (event.target.name == 'Modele__c' || event.target.name == 'Mod_le__c') && this.QueryToApexMethod.includes(':ModeleParam') == true && this.CurrentExecution != 0 ) )
        {
            this.ModeleParam = event.target.value;
        }

        this.CodePaysOptionsValueTemp = [{label : Catalogue_Select_CodePays, value :''}];
        this.CatalogueOptionsValueTemp = [{label : Catalogue_Select_catalogue, value :''}]; 
        this.CodePFOptionsValueTemp = [{label : Catalogue_Select_CodePF, value :''}];    
        this.StandardPFOptionsValueTemp = [{label : Catalogue_Select_StandardPF, value :''}]; 
        this.MarqueOptionsValueTemp = [{label : Catalogue_Select_Marque, value :''}]; 
        this.ModeleOptionsValueTemp = [{label : Catalogue_Select_Modele, value :''}]; 

        this.CodePaysOptionsValue = [];
        this.CatalogueOptionsValue = [];
        this.CodePFOptionsValue = [];
        this.StandardPFOptionsValue = [];
        this.MarqueOptionsValue = [];
        this.ModeleOptionsValue = [];
        //console.log('this.QueryToApexMethod');
        //console.log(this.QueryToApexMethod);
        getCatalogDependentValues({QueryToApexMethod: this.QueryToApexMethod, CodePaysParam: this.CodePaysParam, CatalogueParam: this.CatalogueParam, CodePFParam: this.CodePFParam, StandardPFParam: this.StandardPFParam, MarqueParam: this.MarqueParam, ModeleParam: this.ModeleParam })  
        .then(data => 
        {
            this.error = undefined;
            this.DataLength = data.length;
            let Accepted = false;  

            if(this.DataLength > 0)
            {
                let CodePaysTemp = [];
                let CatalogueTemp = [];
                let CodePFTemp = [];
                let StandardTemp = [];
                let MarqueTemp = [];
                let ModeleTemp = [];
                let CodePaysTempDuplicated = [];
                let CatalogueTempDuplicated = [];
                let CodePFTempDuplicated = [];
                let StandardTempDuplicated = [];
                let MarqueTempDuplicated = [];
                let ModeleTempDuplicated = [];

                data.forEach(optionData => {
                CodePaysTempDuplicated.push(optionData.Code_Pays__c);
                CatalogueTempDuplicated.push(optionData.Catalogue__c);
                CodePFTempDuplicated.push(optionData.Code_PF__c);
                StandardTempDuplicated.push(optionData.Standard__c);
                MarqueTempDuplicated.push(optionData.Marque__c);
                ModeleTempDuplicated.push(optionData.Modele__c);
                });

                CodePaysTemp = new Set(CodePaysTempDuplicated);
                CatalogueTemp = new Set(CatalogueTempDuplicated);
                CodePFTemp = new Set(CodePFTempDuplicated);
                StandardTemp = new Set(StandardTempDuplicated);
                MarqueTemp = new Set(MarqueTempDuplicated);
                ModeleTemp = new Set(ModeleTempDuplicated);

                this.CodePaysOptionsValueBackUp.includes(CodePaysTemp) == true ?  Accepted = true : '' ;
                this.CatalogueOptionsValueBackUp.includes(CatalogueTemp) == true ?  Accepted = true : '' ;
                this.CodePFOptionsValueBackUp.includes(CodePFTemp) == true ?  Accepted = true : '' ;
                this.StandardPFOptionsValueBackUp.includes(StandardTemp) == true ?  Accepted = true : '' ;
                this.MarqueOptionsValueBackUp.includes(MarqueTemp) == true ?  Accepted = true : '' ;
                this.ModeleOptionsValueBackUp.includes(ModeleTemp) == true ?  Accepted = true : '' ;
                        
                CodePaysTemp.forEach(optionData => {
                    this.CodePaysOptionsValueTemp.push({label : optionData, value : optionData});
                });
                CatalogueTemp.forEach(optionData => {
                this.CatalogueOptionsValueTemp.push({label : optionData, value : optionData});
                });

                CodePFTemp.forEach(optionData => {
                this.CodePFOptionsValueTemp.push({label : optionData, value : optionData});
                });

                StandardTemp.forEach(optionData => {
                this.StandardPFOptionsValueTemp.push({label : optionData, value : optionData});
                });

                MarqueTemp.forEach(optionData => {
                this.MarqueOptionsValueTemp.push({label : optionData, value : optionData});
                });

                ModeleTemp.forEach(optionData => {
                this.ModeleOptionsValueTemp.push({label : optionData, value : optionData});
                });


                this.sortData(this.CodePaysOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
                this.sortData(this.CatalogueOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
                this.sortData(this.CodePFOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
                this.sortData(this.StandardPFOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
                this.sortData(this.MarqueOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
                this.sortData(this.ModeleOptionsValueTemp, this.KeyToSortMethod, this.DirectionToSortMethod); 
                       

                this.CodePaysOptionsValue = this.CodePaysOptionsValueTemp;
                this.CatalogueOptionsValue = this.CatalogueOptionsValueTemp;
                this.CodePFOptionsValue = this.CodePFOptionsValueTemp;
                this.StandardPFOptionsValue = this.StandardPFOptionsValueTemp;
                this.MarqueOptionsValue = this.MarqueOptionsValueTemp;
                this.ModeleOptionsValue = this.ModeleOptionsValueTemp;

                event.target.name == 'Code_Pays_FlowInput__c' ? this.template.querySelector("[data-id='Code_Pays__c']").value = this.CodePaysSelectedValue : '' ;
                event.target.name == 'Code_Pays__c' ? this.template.querySelector("[data-id='Code_Pays__c']").value = this.CodePaysSelectedValue : '' ;
                event.target.name == 'Catalogue_FlowInput__c' ? this.template.querySelector("[data-id='Catalogue__c']").value = this.CatalogueSelectedValue : '' ;
                event.target.name == 'Catalogue__c' ? this.template.querySelector("[data-id='Catalogue__c']").value = this.CatalogueSelectedValue : '' ;
                event.target.name == 'Code_PF_FlowInput__c' ? this.template.querySelector("[data-id='Code_PF__c']").value = this.CodePFSelectedValue : '' ;
                event.target.name == 'Code_PF__c' ? this.template.querySelector("[data-id='Code_PF__c']").value = this.CodePFSelectedValue : '' ;
                event.target.name == 'Standard_PF_FlowInput__c' ? this.template.querySelector("[data-id='Standard__c']").value = this.StandardPFSelectedValue : '' ;
                event.target.name == 'Standard__c' ? this.template.querySelector("[data-id='Standard__c']").value = this.StandardPFSelectedValue : '' ;
                event.target.name == 'Marque__c' ? this.template.querySelector("[data-id='Marque__c']").value = this.MarqueSelectedValue : '' ;
                event.target.name == 'Marque__c' ? this.template.querySelector("[data-id='Marque__c']").value = this.MarqueSelectedValue : '' ;
                event.target.name == 'Modele__c' ? this.template.querySelector("[data-id='Modele__c']").value = this.ModeleSelectedValue : '' ;
                event.target.name == 'Mod_le__c' ? this.template.querySelector("[data-id='Modele__c']").value = this.ModeleSelectedValue : '' ;
                this.LoadingSpinner = false;
            }
            else
            {
                this.template.querySelector("[data-id='Code_Pays__c']").value = '';
                this.template.querySelector("[data-id='Catalogue__c']").value = '';
                this.template.querySelector("[data-id='Code_PF__c']").value = '';
                this.template.querySelector("[data-id='Standard__c']").value = '';
                this.template.querySelector("[data-id='Marque__c']").value = '';
                this.template.querySelector("[data-id='Modele__c']").value = '';

                this.CodePaysOptionsValue = this.CodePaysOptionsValueBackUp;
                this.CatalogueOptionsValue = this.CatalogueOptionsValueBackUp;
                this.CodePFOptionsValue = this.CodePFOptionsValueBackUp;
                this.StandardPFOptionsValue = this.StandardPFOptionsValueBackUp;
                this.MarqueOptionsValue = this.MarqueOptionsValueBackUp;
                this.ModeleOptionsValue = this.ModeleOptionsValueBackUp;
                this.LoadingSpinner = false;
            }

        })
        .catch(error => 
        {
            this.LoadingSpinner = false;
            console.log(error);
             /** Standard Show Toast Event => Alert POPUP */
             const evt = new ShowToastEvent(
                {
                    title: 'Error Type : ' + error.statusText ,
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissible',
                });
                this.dispatchEvent(evt);
        })
    }
    
    handleReset(event)
    {
        this.template.querySelector("[data-id='Code_Pays__c']").value = '';
        this.template.querySelector("[data-id='Catalogue__c']").value = '';
        this.template.querySelector("[data-id='Code_PF__c']").value = '';
        this.template.querySelector("[data-id='Standard__c']").value = '';
        this.template.querySelector("[data-id='Marque__c']").value = '';
        this.template.querySelector("[data-id='Modele__c']").value = '';

        this.CodePaysOptionsValue = this.CodePaysOptionsValueBackUp;
        this.CatalogueOptionsValue = this.CatalogueOptionsValueBackUp;
        this.CodePFOptionsValue = this.CodePFOptionsValueBackUp;
        this.StandardPFOptionsValue = this.StandardPFOptionsValueBackUp;
        this.MarqueOptionsValue = this.MarqueOptionsValueBackUp;
        this.ModeleOptionsValue = this.ModeleOptionsValueBackUp;

        this.QueryToApexMethod = this.QueryPart_01;
        this.CurrentExecution = 0;
        this.LoadingSpinner = false;
    }   

    /* 
    *   This method is used to handle search event 
    *   that we need to check response from Talend Webservice. We're also going
    *   to populate all picklists values selected by user into apex method (SearchCatalogueFromLWC)
    *   in order to get response from Talend Webservice
    */
    async handleSearch(event)
    {
        this.LoadingSpinner = true;
        if(this.isInputValid()) 
        {
            let AlertType;
            let Message;
            SearchCatalogueFromLWC({CodePaysParam: this.CodePaysParam, CodePFParam: this.CodePFParam, CatalogueParam:  this.CatalogueParam, StandardPFParam: this.StandardPFParam, currentQuoteID: this.recordId, MarqueParam: this.MarqueParam, ModeleParam: this.ModeleParam })  
            .then(data => 
            {        
                //console.log('Result : data');    
                //console.log(data);   
                data == 'Catalogue_Not_Allowed' ? (AlertType = 'error' , Message = Catalogue_CatalogueNotAllowed) : ( '' );  
                data == 'OK' ? (AlertType = 'success' , Message = Catalogue_DisplayCreated) : ( '' );
                data == 'null' ? (AlertType = 'warning' , Message = Catalogue_DisplayNotFound) : ( '' );
                data == 'Erreur' ? (AlertType = 'error' , Message = Catalogue_DisplayError) : ( '' );
                data == 'ErreurDM' ? (AlertType = 'warning' , Message = Catalogue_DisplayErrorDM) : ( '' );
                data == 'NOT_ALLOWED' ? (AlertType = 'error' , Message = Catalogue_DisplayNotAllowed) : ( '' );
                    
                //console.log('Response : Search Catalogue');
                //console.log(data);
                //console.log('AlertType');
                //console.log(AlertType);
                //console.log('Message');
                //console.log(Message);
                
                /** Standard Show Toast Event => Alert POPUP */
                const evt = new ShowToastEvent(
                {
                    title: Catalogue_Response_Title,
                    message: Message,
                    variant: AlertType,
                    mode: 'dismissible',
                });
                this.dispatchEvent(evt);  
                // Notify LDS that you've changed the record outside its mechanisms.
                getRecordNotifyChange([{recordId: this.recordId}]);
                this.LoadingSpinner = false;
            })
            .catch(error => 
            {
                this.LoadingSpinner = false;
                console.log('Error : Search Catalogue');
                console.log(error);
                //console.log('getRecordNotifyChange4');

                /** Standard Show Toast Event => Alert POPUP */
                const evt = new ShowToastEvent(
                {
                    title: 'Error Type : ' + error.statusText ,
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissible',
                });
                this.dispatchEvent(evt);
            })

           
        }
        else
        {
            this.LoadingSpinner = false;
            /** Standard Show Toast Event => Alert POPUP */
            const evt = new ShowToastEvent(
            {
                title: Catalogue_DisplayErrorDM_title,
                message: Catalogue_DisplayError_EmptyFields,
                variant: 'error',
                mode: 'dismissible',
            });
            this.dispatchEvent(evt);
        }
    } 
    
    /* 
    *   This method is used to check if all the input fields 
    *   that we need to validate are valid or not. We're also going
    *   to populate our contact object so that it can be sent to apex
    *   in order to save the details in salesforce
    */
    isInputValid() 
    {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('lightning-combobox');
        inputFields.forEach(inputField => 
        {
            if(!inputField.checkValidity()) 
            {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;
    }
}