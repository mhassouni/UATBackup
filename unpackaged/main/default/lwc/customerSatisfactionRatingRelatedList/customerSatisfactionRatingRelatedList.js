import { LightningElement, track, wire, api } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import JqueryResource from '@salesforce/resourceUrl/Jquery_3_7_0';
import JqueryDataTablesCSS_13_7 from '@salesforce/resourceUrl/JqueryDataTablesCSS_13_7';
import JqueryDataTablesJS_13_7 from '@salesforce/resourceUrl/JqueryDataTablesJS_13_7';
import getBusinessLinesData from '@salesforce/apex/DataTableWrapperController.getBusinessLinesData';
import getAccountData from '@salesforce/apex/DataTableWrapperController.getAccountData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CustomerSatisfactionRatingRelatedList extends LightningElement {
    @api recordId; // This attribute holds the record Id
    @track isListVisible = true;
    @track satisfactionData = [];
    @track showLoading = false; // Données vides initiales
    @track objectName = 'Note_satisfaction_client__c';
    // ID must be included in this Variable
    @track fieldsToQuery = 'id, Annees_des_enquetes__c, Note_globale_PF__c, Interroge_qualite_client__c, Note_satisfaction_client_Field__c, Evolution_note_satisfaction__c';
    @track filter;
    @track fieldToOrder = 'Annees_des_enquetes__c DESC';
    @track recordsPerPage = 5;
    @track disableSort = false;
    @track disableSearch = false;
    @track objectNameToSend;
    @track fieldNamesToSend;
    @track filtersToSend;
    @track recordsPerPageToSend;
    @track disableSortToSend;
    @track disableSearchToSend;
    @track isAscending = true;
    @track sortedBy;
    @track sortedByAnneesDesEnquetes = true; // Utilisez votre logique pour définir cette variable
    @track sortedByNoteGlobale = true; // Utilisez votre logique pour définir cette variable
    @track sortedByInterrogeQualite = true; // Utilisez votre logique pour définir cette variable
    @track sortedByNoteSatisfaction = true; // Utilisez votre logique pour définir cette variable
    @track sortedByEvolutionNote = true; // Utilisez votre logique pour définir cette variable
    
    columnSorting = {
        Annees_des_enquetes__c: { sortedBy: false, isAscending: true },
        Note_globale_PF__c: { sortedBy: false, isAscending: true },
        Interroge_qualite_client__c: { sortedBy: false, isAscending: true },
        Note_satisfaction_client_Field__c: { sortedBy: false, isAscending: true },
        Evolution_note_satisfaction__c: { sortedBy: false, isAscending: true },
    };

    @track accounts = [];
    error;
    @track recordsQueried;  // array property to store list of Opportunity 
    @track AccountData = [];
    @track NbContractYTD;
    @track NbContractN1FY;
    @track IsCustomerProfileVisible = true;
    @track IsActiveContractsVisible = true;
    @track IsCustomerSatisfactionVisible = true;
    @track IsExpiringContractsVisible = true;
    @track BusinessLinesDataRecords= [];
    @track BusinessLinesTotalList= [];

    caytdTotal = 0;
    can1ytdTotal = 0;
    can1fyTotal = 0;
    totalNbContratCD = 0;
    totalNbContratMD = 0;
    totalNbContratLD = 0;
    totalSum = 0;
    @track sumsList = [];
    @track showSpinner = true;
    @track CAYTDTotal;
    @track CAN1YTDTotal;
    @track CAN1FYTotal;
    VarFalse = false;

    
    
    constructor() 
    {
        super();
       //this.loadExternalLibraries();
    }
    
    loadExternalLibraries() 
    {
        loadScript(this, JqueryResource).then(() => { loadScript(this, JqueryDataTablesJS_13_7).then(() => {loadStyle(this, JqueryDataTablesCSS_13_7 ).then(() => 
            {                                

                let helpIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-info-circle-fill" viewBox="0 0 16 16"><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16m.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2"/></svg>';
                const CustomerProfile = this.template.querySelector('.CustomerProfile');
                const CustomerProfileColumnNames = [ helpIcon, 'Chiffre d\'affaires YTD', 'Chiffre d\'affaires N-1 YTD', 'Chiffre d\'affaires N-1 FY'];
                let CustomerProfileTableHeaders = '<thead> <tr>';
                CustomerProfileColumnNames.forEach(header => { CustomerProfileTableHeaders += '<th>' + header + '</th>';});
                CustomerProfileTableHeaders += '</tr></thead>';
                CustomerProfile.innerHTML = CustomerProfileTableHeaders;
                let CustomerProfileJqTable = $(CustomerProfile).DataTable({ dom: 'Z<"top">rt<"bottom"lp>', paging: false,  columnDefs: [{ orderable: false, targets: 0 }], "order": [[ 1, 'desc' ]] });
                $('div.dataTables_filter input').addClass('slds-input');
                $('div.dataTables_filter input').css("marginBottom", "10px");
                if(this.BusinessLinesDataRecords.length > 0)
                {
                    let CustomerProfileFirstRows = [];
                    //let tableTotalRows = [];

                    CustomerProfileFirstRows.push( 'Total'   );
                    //CustomerProfileFirstRows.push( this.caytdTotal);
                    //CustomerProfileFirstRows.push( this.can1ytdTotal);
                    //CustomerProfileFirstRows.push( this.can1fyTotal);

                    this.CAYTDTotal !=null ? CustomerProfileFirstRows.push( this.CAYTDTotal) : CustomerProfileFirstRows.push( 0 );
                    this.CAN1YTDTotal !=null ? CustomerProfileFirstRows.push(this.CAN1YTDTotal) : CustomerProfileFirstRows.push( 0 );
                    this.CAN1FYTotal !=null ? CustomerProfileFirstRows.push( this.CAN1FYTotal ) : CustomerProfileFirstRows.push( 0 );

                    CustomerProfileJqTable.row.add(CustomerProfileFirstRows);
                    CustomerProfileJqTable.draw();
                    this.BusinessLinesDataRecords.forEach(rec => 
                    {
                        let tableRows = [];
                        rec.BusinessLine__c !=null ? tableRows.push( rec.BusinessLine__c ) : tableRows.push( '' );
                        rec.CAYTD__c !=null ? tableRows.push( rec.CAYTD__c) : tableRows.push( 0 );
                        rec.CAN1YTD__c !=null ? tableRows.push(rec.CAN1YTD__c) : tableRows.push( 0 );
                        rec.CAN1FY__c !=null ? tableRows.push( rec.CAN1FY__c) : tableRows.push( 0 );
                        CustomerProfileJqTable.row.add(tableRows);
                    });
                     CustomerProfileJqTable.draw();
                }
           

        const ActiveContracts = this.template.querySelector('.ActiveContracts');         
        const ActiveContractsColumnNames = [ helpIcon, 'Courte durée', 'N-1 YTD', 'N-1 FY', 'Moyenne durée', 'N-1 YTD', 'N-1 FY','Longue durée', 'N-1 YTD', 'N-1 FY', 'Total'];
        let ActiveContractsTableHeaders = '<thead> <tr>';
        ActiveContractsColumnNames.forEach(header => 
        {
            ActiveContractsTableHeaders += '<th>' + header + '</th>';
        });
        ActiveContractsTableHeaders += '</tr></thead>';
        ActiveContracts.innerHTML = ActiveContractsTableHeaders;
        let ActiveContractsJqTable = $(ActiveContracts).DataTable({ dom: 'Z<"top">rt<"bottom"lp>', paging: false,  columnDefs: [{ orderable: false, targets: 0 }], "order": [[ 1, 'desc' ]] });
        $('div.dataTables_filter input').addClass('slds-input');
        $('div.dataTables_filter input').css("marginBottom", "10px");
        if(this.BusinessLinesDataRecords.length > 0 && this.sumsList.length > 0)
        {

            console.log('this.sumsList.length88888888888888888888888888888888888888888888888888888888888889999999999999999999999');
            console.log(this.sumsList.length);
            console.log('this.sumsList');
            console.log(this.sumsList);

            for(let i=0; i<this.BusinessLinesDataRecords.length ; i++ )
            {
                if (this.sumsList[i]) 
                {
                    
                    let tableRows = [];
                    this.BusinessLinesDataRecords[i].BusinessLine__c != null ? tableRows.push( this.BusinessLinesDataRecords[i].BusinessLine__c ) : tableRows.push( '' );
                    //this.sumsList[i].totalNbContratCD != null ? tableRows.push( this.sumsList[i].totalNbContratCD) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratCDYTD__c != null ? tableRows.push(this.BusinessLinesDataRecords[i].NbContratCDYTD__c) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratCDN1YTD__c != null ? tableRows.push(this.BusinessLinesDataRecords[i].NbContratCDN1YTD__c) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratCDN1FY__c != null ? tableRows.push( this.BusinessLinesDataRecords[i].NbContratCDN1FY__c) : tableRows.push( 0 );
                    //this.sumsList[i].totalNbContratMD != null ? tableRows.push( this.sumsList[i].totalNbContratMD) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratMDYTD__c != null ? tableRows.push(this.BusinessLinesDataRecords[i].NbContratMDYTD__c) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratMDN1YTD__c != null ? tableRows.push(this.BusinessLinesDataRecords[i].NbContratMDN1YTD__c) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratMDN1FY__c != null ? tableRows.push( this.BusinessLinesDataRecords[i].NbContratMDN1FY__c) : tableRows.push( 0 );
                    //this.sumsList[i].totalNbContratLD != null ? tableRows.push( this.sumsList[i].totalNbContratLD) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratLDYTD__c != null ? tableRows.push(this.BusinessLinesDataRecords[i].NbContratLDYTD__c) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratLDN1YTD__c != null ? tableRows.push(this.BusinessLinesDataRecords[i].NbContratLDN1YTD__c) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].NbContratLDN1FY__c != null ? tableRows.push(this.BusinessLinesDataRecords[i].NbContratLDN1FY__c) : tableRows.push( 0 );
                    this.BusinessLinesDataRecords[i].TotalContratsActifs__c != null ? tableRows.push(this.BusinessLinesDataRecords[i].TotalContratsActifs__c) : tableRows.push( 0 );
                    //this.sumsList[i].totalSum != null ? tableRows.push( this.sumsList[i].totalSum ) : tableRows.push( 0 );      
                    ActiveContractsJqTable.row.add(tableRows);
                }
                
                else
                {
                    let tableRows = [];
                    tableRows.push( '' );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    tableRows.push( 0 );
                    ActiveContractsJqTable.row.add(tableRows);
                }
            }
        ActiveContractsJqTable.draw();
        }

        const ExpiringContracts = this.template.querySelector('.ExpiringContracts');
        const ExpiringContractsColumnNames = [ helpIcon, 'CD', 'MD', 'LD'];
        let ExpiringContractsTableHeaders = '<thead> <tr>';
        ExpiringContractsColumnNames.forEach(header => 
        {
            ExpiringContractsTableHeaders += '<th>' + header + '</th>';
        });
        ExpiringContractsTableHeaders += '</tr></thead>';
        ExpiringContracts.innerHTML = ExpiringContractsTableHeaders;

        /*
        let ExpiringContractsJqTable = $(ExpiringContracts).DataTable({ dom: 'Z<"top"i>rt<"bottom"lp>', paging: false,  columnDefs: [{ orderable: false, targets: 0 }], "order": [[ 1, 'desc' ]],  
            "language": 
            {
                "decimal":        "",
                "emptyTable":     "No data available in table",
                "info":           "Showing _START_ to _END_ of _TOTAL_ entries",
                "infoEmpty":      "Showing 0 to 0 of 0 entries",
                "infoFiltered":   "(filtered from _MAX_ total entries)",
                "infoPostFix":    "",
                "thousands":      ",",
                "lengthMenu":     "Show _MENU_ entries",
                "loadingRecords": "Loading...",
                "processing":     "",
                "search":         "Rechercher:",
                "zeroRecords":    "No matching records found",
                "paginate": {
                                "first":      "First",
                                "last":       "Last",
                                "next":       "Next",
                                "previous":   "Previous"
                            },
                "aria": {
                    "sortAscending":  ": activate to sort column ascending",
                    "sortDescending": ": activate to sort column descending"
                }
            }

        });

    */
        let ExpiringContractsJqTable = $(ExpiringContracts).DataTable({ dom: 'Z<"top">rt<"bottom"lp>', paging: false,  columnDefs: [{ orderable: false, targets: 0 }], "order": [[ 1, 'desc' ]] });
        $('div.dataTables_filter input').addClass('slds-input');
        $('div.dataTables_filter input').css("marginBottom", "10px");
        if(this.BusinessLinesDataRecords.length > 0)
        {
            this.BusinessLinesDataRecords.forEach(rec => 
            {
                let tableRows = [];
                rec.BusinessLine__c != null ? tableRows.push( rec.BusinessLine__c ) : tableRows.push( '' );
                rec.Total_Contrats_echeance_CD__c != null ? tableRows.push( rec.Total_Contrats_echeance_CD__c ) : tableRows.push( 0 );
                rec.Total_Contrats_echeance_MD__c != null ? tableRows.push( rec.Total_Contrats_echeance_MD__c ) : tableRows.push( 0 );
                rec.Total_Contrats_echeance_LD__c != null ? tableRows.push( rec.Total_Contrats_echeance_LD__c ) : tableRows.push( 0 );
                rec.BusinessLine__c != null ? tableRows.push( rec.BusinessLine__c ) : tableRows.push( '' );
                ExpiringContractsJqTable.row.add(tableRows);
            });
            ExpiringContractsJqTable.draw();
            this.showSpinner = false ;

        }
        })})})
    }


     renderedCallback() 
    {
        

    }


     hideStyle() 
    {
        
   
        // Exécuter le code après le chargement des bibliothèques externes
        const dataTablesLengthElements = this.template.querySelectorAll('.dataTables_length');
        dataTablesLengthElements.forEach(element => 
            {
                element.style.display = 'none'; // Pour masquer chaque élément ayant la classe dataTables_length
            });

        const dataTables_filterElements = this.template.querySelectorAll('.dataTables_filter');
        dataTables_filterElements.forEach(element => 
            {
                element.style.display = 'none'; // Pour masquer chaque élément ayant la classe dataTables_length
            });            
       
    }
async connectedCallback() {
    if (this.recordId) {
        try {
            this.BusinessLinesDataRecords = await getBusinessLinesData({ recordId: this.recordId });
            
            const businessLineMap = {};

            // Calculer la somme pour chaque Business Line
            this.calculateSums(this.BusinessLinesDataRecords);


             // Mettre à jour le tableau businessLines avec les sommes calculées
             this.BusinessLinesTotalList = Object.values(businessLineMap);
             //console.log('this.BusinessLinesTotalList1111111111111111111111111111111111111111111111111111111111111111111111111111111111');
             //console.log(this.BusinessLinesTotalList);
            await getAccountData({ recordId: this.recordId }).then(data => {
                if (data) {
                    this.AccountData = data;
                    this.NbContractYTD = this.AccountData[0].NbContractYTD__c;
                    this.NbContractN1FY = this.AccountData[0].NbContractN1FY__c;
                    this.CAYTDTotal = this.AccountData[0].CAYTDTotal__c;
                    this.CAN1YTDTotal = this.AccountData[0].CAN1YTDTotal__c;
                    this.CAN1FYTotal = this.AccountData[0].CAN1FYTotal__c;
                }
            }).catch(error => {
                this.showToast('Erreur', 'Erreur lors du chargements des données : ' + error.body.message, 'error');
            });

            //this.accounts = await getUniqueBusinessLinesData();
            // Gérer la réponse de l'appel à la méthode Apex ici


            //this.loadExternalLibraries();
            
           // await this.hide();

            
            
        } catch (error) {
            // Gérer les erreurs ici
        }

    }

        this.objectNameToSend = this.objectName;
        this.fieldNamesToSend = this.fieldsToQuery;
        //this.filtersToSend = this.filter;
        this.filtersToSend =  this.recordId;
        this.recordsPerPageToSend = this.recordsPerPage;
        this.disableSortToSend = this.disableSort;
        this.disableSearchToSend = this.disableSearch;
        this.fieldToOrderToSend = this.fieldToOrder;
        this.showSpinner = false ;

    }

/*
    async fetchAccoutns() {
        await getAccounts()
            .then(data => {
                if (data) {
                    this.accounts = data;
                }
            })
            .catch(error => {
                this.error = error;
                this.accounts = undefined;
                this.error = 'Unknown error';
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    this.error = error.body.message;
                }
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error!!',
                        message: error,
                        variant: 'error',
                    }),
                );
            });
    }
*/

    CustomerProfileToggle() 
    {
        this.IsCustomerProfileVisible = !this.IsCustomerProfileVisible;
        if(!this.IsCustomerProfileVisible)
        {
            const divElement = this.template.querySelector('.CustomerProfileContainer');
            divElement.style.display = 'none'; // Pour masquer le div
        }
        else
        {
            const divElement = this.template.querySelector('.CustomerProfileContainer');
            divElement.style.display = 'block'; // Pour masquer le div
        }       
    }

    ActiveContractsToggle() 
    {
        this.IsActiveContractsVisible = !this.IsActiveContractsVisible;
        if(!this.IsActiveContractsVisible)
        {
            const divElement = this.template.querySelector('.ActiveContractsContainer');
            divElement.style.display = 'none'; // Pour masquer le div
        }
        else
        {
            const divElement = this.template.querySelector('.ActiveContractsContainer');
            divElement.style.display = 'block'; // Pour masquer le div
        }       
    }

    CustomerSatisfactionToggle() 
    {
        this.IsCustomerSatisfactionVisible = !this.IsCustomerSatisfactionVisible;
        if(!this.IsCustomerSatisfactionVisible)
        {
            const divElement = this.template.querySelector('.CustomerSatisfactionContainer');
            divElement.style.display = 'none'; // Pour masquer le div
        }
        else
        {
            const divElement = this.template.querySelector('.CustomerSatisfactionContainer');
            divElement.style.display = 'block'; // Pour masquer le div
        }       
    }

    ExpiringContractsToggle() 
    {
        this.IsExpiringContractsVisible = !this.IsExpiringContractsVisible;
        if(!this.IsExpiringContractsVisible)
        {
            const divElement = this.template.querySelector('.ExpiringContractsContainer');
            divElement.style.display = 'none'; // Pour masquer le div
        }
        else
        {
            const divElement = this.template.querySelector('.ExpiringContractsContainer');
            divElement.style.display = 'block'; // Pour masquer le div
        }  

        
    }
    

    handleObjectNameChange(event) {
        this.objectName = event.target.value;
    }

    handleObjectFieldsChange(event) {
        this.fieldsToQuery = event.target.value;
    }

    handleFilterChange(event) {
        this.filter = event.target.value;
    }
    handleRecordsPerPageChange(event) {
        this.recordsPerPage = event.target.value;
    }
    handleSortChange(event) {
        this.disableSort = event.target.checked;
    }
    handleSearchChange(event) {
        this.disableSearch = event.target.checked;
    }

    handleClick(event) {
        this.objectNameToSend = this.objectName;
        this.fieldNamesToSend = this.fieldsToQuery;
        this.filtersToSend = this.filter;
        this.recordsPerPageToSend = this.recordsPerPage;
        this.disableSortToSend = this.disableSort;
        this.disableSearchToSend = this.disableSearch;
    }


 // Obtient une liste distincte de valeurs BusinessLine__c de la liste des comptes
 get distinctBusinessLines() {
    return [...new Set(this.BusinessLinesDataRecords.map(BusinessLinesDataRecord => BusinessLinesDataRecord.BusinessLine__c))];
}

 // Obtient une liste distincte de valeurs BusinessLine__c de la liste des comptes
 get distinctBusinessLines() {
    return [...new Set(this.BusinessLinesDataRecords.map(BusinessLinesDataRecord => BusinessLinesDataRecord.BusinessLine__c))];
}


get distinctBusinessLines() {
        return [...new Set(this.BusinessLinesDataRecords.map(BusinessLinesDataRecord => BusinessLinesDataRecord.BusinessLine__c))];
    }
    
    get pillItems() {
        const pillMap = {
            Containers: { iconName: 'utility:archive', label: 'Containers', class: 'slds-pill Containers' },
            Meubles: { iconName: 'utility:collection_alt', label: 'Meubles', class: 'slds-pill Meubles' },
            'Véhicules Frigorifiques': { iconName: 'utility:truck', label: 'Véhicules Frigorifiques', class: 'slds-pill VehiculesFrigorifiques' },
            'Véhicules Secs': { iconName: 'utility:truck', label: 'Véhicules Secs', class: 'slds-pill VehiculesSecs' }
        };

        return this.distinctBusinessLines.map(businessLine => {
            const pill = pillMap[businessLine];
            pill.cssClass = `slds-pill slds-pill_link ${pill.color}`;
            return pill;
        });
    }


    calculateSums(records) 
    {
        const caytdMap = {};
        const can1ytdMap = {};
        const can1fyMap = {};
        let sumNbContratCD = 0;
        let sumNbContratMD = 0;
        let sumNbContratLD = 0;
        let totalNbContratCD = 0;
        let totalNbContratMD = 0;
        let totalNbContratLD = 0;
        let totalSum = 0;
        let BusinessLine = '';
        records.forEach(record => 
        {
            if (record.CAYTD__c) 
            {
                caytdMap[record.CAYTD__c] = (caytdMap[record.CAYTD__c] || 0) + record.CAYTD__c;
            }
            if (record.CAN1YTD__c) 
            {
                can1ytdMap[record.CAN1YTD__c] = (can1ytdMap[record.CAN1YTD__c] || 0) + record.CAN1YTD__c;
            }
            if (record.CAN1FY__c) 
            {
                can1fyMap[record.CAN1FY__c] = (can1fyMap[record.CAN1FY__c] || 0) + record.CAN1FY__c;
            }
        });

        this.caytdTotal = Object.values(caytdMap).reduce((total, value) => total + value, 0);
        this.can1ytdTotal = Object.values(can1ytdMap).reduce((total, value) => total + value, 0);
        this.can1fyTotal = Object.values(can1fyMap).reduce((total, value) => total + value, 0);
        this.sumsList = records.map(record => 
        {
            /*if (record.NbContratCDN1YTD__c  && record.NbContratCDN1FY__c   ) 
            {
                totalNbContratCD = (record.NbContratCDN1YTD__c || 0) + (record.NbContratCDN1FY__c || 0);
            }

            if (record.NbContratMDN1YTD__c  && record.NbContratMDN1FY__c  ) 
            {
                totalNbContratMD = (record.NbContratMDN1YTD__c || 0) + (record.NbContratMDN1FY__c || 0);
            }

            if (record.NbContratLDN1YTD__c   && record.NbContratLDN1FY__c  ) 
            {
                totalNbContratLD = (record.NbContratLDN1YTD__c || 0) + (record.NbContratLDN1FY__c || 0);
            }

            record.BusinessLine__c != null ? BusinessLine = record.BusinessLine__c : BusinessLine = '';
            totalSum = totalNbContratCD + totalNbContratMD + totalNbContratLD;
*/
            totalNbContratCD = (record.NbContratCDN1YTD__c || 0) + (record.NbContratCDN1FY__c || 0);
            totalNbContratMD = (record.NbContratMDN1YTD__c || 0) + (record.NbContratMDN1FY__c || 0);
            totalNbContratLD = (record.NbContratLDN1YTD__c || 0) + (record.NbContratLDN1FY__c || 0);
            totalSum = totalNbContratCD + totalNbContratMD + totalNbContratLD;

            return {
                BusinessLine__c: record.BusinessLine__c, // Assurez-vous de remplacer 'Name' par le champ que vous utilisez pour identifier chaque ligne
                totalNbContratCD,
                totalNbContratMD,
                totalNbContratLD,
                totalSum
            };
           /* return 
            {
                BusinessLine__c: record.BusinessLine__c, // Assurez-vous de remplacer 'Name' par le champ que vous utilisez pour identifier chaque ligne
                totalNbContratCD,
                totalNbContratMD,
                totalNbContratLD,
                totalSum
            };*/
        });
    }
}