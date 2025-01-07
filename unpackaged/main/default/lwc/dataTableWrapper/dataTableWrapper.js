import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecords from '@salesforce/apex/DataTableWrapperController.getRecords';
import getFieldDetails from '@salesforce/apex/DataTableWrapperController.getFieldDetails';
import updateRecords from '@salesforce/apex/DataTableWrapperController.updateRecords';
import { refreshApex } from "@salesforce/apex";

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';

const FIELDS = ['User.Profile.Name'];


export default class DataTableWrapper extends LightningElement {
    @track allRecords;
    @track filteredRecords;
    @track viewRecords;
    @track columns;
    @track defaultSortDirection = 'asc';
    @track sortDirection = 'asc';
    @track sortedBy;
    @track recordCount = 0;
    @track hasRecords = false;
    @track beginIndex = 0;
    @track endndex = 0;
    @track currentPage = 0;
    @track totalPages = 0;
    @track disableBack = true;
    @track disableForward = true;
    @track searchText = '';
    @track objectPluralName = '';
    @api objectName;
    @api fieldsToQuery;
    @api filters;
    @api fieldToOrder;
    @api disableSort;
    @api disableSearch;
    @api recordsPerPage;

    //Properties for Message / Alert
    //@track hasMessage = true;
    @track hasMessage;
    @track pageMessageParentDivClass = 'slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_warning';
    @track pageMessageChildDivClass = 'slds-icon_container slds-icon-utility-warning slds-m-right_x-small'
    @track messageTitle = 'No Records';
    @track messageSummary = 'No records found.';
    @track messageIcon = 'utility:warning';
    draftValues = [];
    @track updatedRows;
    @track retrievedRecords;
    @track isRefreshed = false;
    
// Déclarez une variable pour stocker le filaire du filaire
wiredRecordsVar;



@track profileName;

    @wire(getRecord, { recordId: USER_ID, fields: FIELDS })
    wireuser({ error, data }) {
        if (data) {
            this.profileName = data.fields.Profile.value.fields.Name.value;
        } else if (error) {
            // Handle errors
            console.error('Error fetching user profile', JSON.stringify(error));
        }
    }


connectedCallback() 
{

    if (!this.isRefreshed) {
        // Actions à effectuer après l'actualisation de la page
        //this.handleRefresh();
        this.isRefreshed = true;
    }
    
}

/*
disconnectedCallback() {

        this.handleRefresh();
}
*/

    //Get the from APEX Controller
    @wire (getRecords, {objectName : '$objectName', fieldsToQuery : '$fieldsToQuery', filters : '$filters', fieldToOrder : '$fieldToOrder'})
    //wiredRecords({error, data}) {
        wiredRecords(result) {
            this.wiredRecordsVar = result;
        console.log(result.data);
        if (result.data) {
            var allRecords = [];

            const rawRecords = result.data; // Supposons que les données sont dans un format différent

            // Adapter les données pour correspondre à la structure attendue
            this.retrievedRecords = rawRecords.map((rawRecord) => {
                return {
                    Id: rawRecord.Id, // Adapter les champs nécessaires
                    Annees_des_enquetes__c: rawRecord.Annees_des_enquetes__c, // Adapter les champs nécessaires
                    Interroge_qualite_client__c: rawRecord.Interroge_qualite_client__c, // Adapter les champs nécessaires
                    Note_globale_PF__c: rawRecord.Note_globale_PF__c,
                    Note_satisfaction_client_Field__c: rawRecord.Note_satisfaction_client_Field__c, 
                    Evolution_note_satisfaction__c: rawRecord.Evolution_note_satisfaction__c
                };
            });

            for (var index in result.data) {
                var record = result.data[index];
                var compatibleRecord = {};
                for (var key in record) {
                    if (typeof record[key] == 'object') {
                        for (var childKey in record[key]) {
                            var parentChildkey = key + '_' +childKey;
                            compatibleRecord[parentChildkey] = record[key][childKey];
                        }
                    } else {
                        compatibleRecord[key] = record[key];
                    }
                }
                allRecords.push(compatibleRecord);
                console.log(compatibleRecord);
            }
            this.allRecords = allRecords;
            this.calculateEvolutionLogic(this.allRecords);

            this.filteredRecords = allRecords;
            if (this.allRecords && this.allRecords.length > 0) {
                this.hasRecords = true;
                this.hasMessage = false;
                console.log('this.allRecordsallRecordsallRecordsallRecordsallRecords');
                console.log(this.allRecords);
            } else {
                this.hasRecords = false;
                this.hasMessage = true;
                this.preparePageMessage(
                    'slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_warning',
                    'slds-icon_container slds-icon-utility-warning slds-m-right_x-small',
                    'No Records',
                    'No records found.',
                    'utility:warning'
                );
            }
            console.log(this.filterRecords);
            this.filterRecords(0);
        } else if (result.error) {
            console.log(result.error);
            this.hasRecords = false;
            this.hasMessage = true;
            this.preparePageMessage(
                'slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error',
                'slds-icon_container slds-icon-utility-error slds-m-right_x-small',
                'Error',
                result.error.body.exceptionType + ' ' + result.error.body.message + ' ' + result.error.body.stackTrace,
                'utility:error'
            );
        }
    };

    //Get details about the queried fields
    @wire (getFieldDetails, {objectName : '$objectName', fieldsToQuery : '$fieldsToQuery', filters : '$filters'})
    wiredFields({error, data}) {
        console.log('wiredFields 2');
        console.log(error);
        console.log(data);
        var columns = [];
        if (data) {
            for (var fieldName in data) {
                console.log(data[fieldName]);
                var fieldLabel = data[fieldName]["label"];
                var fieldDisplaytype = data[fieldName]["displaytype"];
                var fieldApiName = data[fieldName]["apiname"];
                if(fieldApiName == 'Interroge_qualite_client__c'  || fieldApiName == 'Evolution_note_satisfaction__c' )
                {
                    columns.push({
                        label: fieldLabel,
                        fieldName: fieldApiName,
                        type: fieldDisplaytype,
                        sortable: true,
                        editable: false
                    });
                    
                }
                else if(fieldApiName == 'Id'   )
                {
                    
                }
                else if ( this.profileName == 'PF Administrateur Système')
                {
                    columns.push({
                        label: fieldLabel,
                        fieldName: fieldApiName,
                        type: fieldDisplaytype,
                        sortable: true,
                        editable: false
                    });
                }
                else
                {
                    columns.push({
                        label: fieldLabel,
                        fieldName: fieldApiName,
                        type: fieldDisplaytype,
                        sortable: true,
                        editable: false
                    });
                }

                this.objectPluralName = data[fieldName]["objectPluralName"];
                console.log(this.objectPluralName);
            }
            this.columns = columns;
            this.hasMessage = false;
            console.log(this.columns);
        } else if (error) {
            console.log(error);
            this.hasMessage = true;
            this.hasRecords = false;
            this.preparePageMessage(
                'slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_error',
                'slds-icon_container slds-icon-utility-error slds-m-right_x-small',
                'Error',
                error.body.exceptionType + ' ' + error.body.message + ' ' + error.body.stackTrace,
                'utility:error'
            );
        }
    };

    sortBy(field, reverse, primer) {
        const key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };
        return function(a, b) {
            a = key(a) === undefined ? "" : key(a);
            b = key(b) === undefined ? "" : key(b);
            a = a.toString().toLowerCase();
            b = b.toString().toLowerCase();
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.filteredRecords];
        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.filteredRecords = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
        this.filterRecords(0);

    }

    goToFirst(event) {
        this.filterRecords(0);
    }

    goToPrevious(event) {
        var newIndex = (this.beginIndex - Number(this.recordsPerPage));
        newIndex--;
        this.filterRecords(newIndex);
    }

    goToNext(event) {
        var newIndex = (this.beginIndex + Number(this.recordsPerPage));
        newIndex--;
        this.filterRecords(newIndex);
    }

    goToLast(event) {
        var newIndex = (this.totalPages-1) * Number(this.recordsPerPage);
        this.filterRecords(newIndex);
    }

    handleSearchText(event) {
        this.searchText = event.target.value;
        console.log(this.searchText);
        if (this.searchText && this.searchText.length >= 2) {
            var filteredRecords = [];
            for (var index in this.allRecords) {
                var record = this.allRecords[index];
                for (var key in record) {
                    var value = record[key].toString();
                    if (value && value.length > 0 && value.toLowerCase().includes(this.searchText.toLowerCase())) {
                        filteredRecords.push(record);
                    }
                }
            }
            this.filteredRecords = filteredRecords;
        } else {
            this.filteredRecords = this.allRecords;
        }
        this.filterRecords(0);
    }

    filterRecords(startingIndex) {
        if (this.filteredRecords && this.filteredRecords.length > 0) {
            this.recordCount = this.filteredRecords.length;
            this.totalPages = Math.ceil(this.recordCount / Number(this.recordsPerPage));
            var viewRecords = [];
            var endingIndex = startingIndex + Number(this.recordsPerPage);
            if (endingIndex > this.recordCount) {
                endingIndex = this.recordCount;
            }
            this.beginIndex = startingIndex + 1;
            this.endndex = endingIndex;

            var index = startingIndex;
            this.currentPage = Math.ceil(this.beginIndex / Number(this.recordsPerPage));
            while(index < endingIndex) {
                viewRecords.push(this.filteredRecords[index]);
                index++;
            }
            this.viewRecords = viewRecords;
            console.log('this.viewRecordsthis.viewRecordsthis.viewRecordsthis.viewRecordsthis.viewRecords');
            console.log(this.viewRecords);
        } else {
            this.recordCount = 0;
            this.totalPages = 0;
            this.currentPage = 0;
            this.beginIndex = 0;
            this.endndex = 0;
            this.viewRecords = [];
        }
        this.renderButtons();        
    }

    preparePageMessage(pageMessageParentDivClass, pageMessageChildDivClass, messageTitle, messageSummary, messageIcon) {
        this.pageMessageParentDivClass = pageMessageParentDivClass;
        this.pageMessageChildDivClass = pageMessageChildDivClass;
        this.messageTitle = messageTitle;
        this.messageSummary = messageSummary;
        this.messageIcon = messageIcon;
    }

    renderButtons() {
        if (this.beginIndex < Number(this.recordsPerPage)) {
            this.disableBack = true;
        } else {
            this.disableBack = false;
        }

        if (this.currentPage == this.totalPages) {
            this.disableForward = true;
        } else {
            this.disableForward = false;
        }
    }

     handleSave(event) {

// Initialisation de la liste pour stocker les champs clés et valeurs
this.draftValues = event.detail.draftValues;
        this.updatedRows = event.detail.draftValues.map(row => {
            let objFields = {};
            this.fieldsToQuery.split(',').forEach(field => {
                objFields[field.trim()] = row[field.trim()];
            });
            objFields['sobjectType'] = this.objectName;
            objFields['Id'] = row.Id;
            return objFields;
        });
    
                // Mettre à jour les enregistrements avec les valeurs récupérées
        if (this.updatedRows.length > 0) {
           
const formattedUpdatedRecords = this.retrievedRecords.map(record => {
    const updatedRecord = this.draftValues.find(draftRecord => draftRecord.Id === record.Id);

    if (updatedRecord) {
        // Merge the updated fields from this.draftValues into the record
        Object.assign(record, updatedRecord);
    }

    let objFields = {};
    // Assurez-vous d'avoir toutes les clés requises dans objFields pour l'appel Apex
    objFields['Id'] = record.Id;
    objFields['Interroge_qualite_client__c'] = record.Interroge_qualite_client__c;
    objFields['Annees_des_enquetes__c'] = record.Annees_des_enquetes__c;
    objFields['Note_globale_PF__c'] = record.Note_globale_PF__c;
    objFields['Note_satisfaction_client_Field__c'] = record.Note_satisfaction_client_Field__c;
    objFields['Evolution_note_satisfaction__c'] = record.Evolution_note_satisfaction__c;
    objFields['sobjectType'] = this.objectName; // Assurez-vous de l'objet cible

    return objFields;
});

// Maintenant retrievedRecords a la structure attendue pour calculateEvolutionLogic()
//const updatedRecords = this.calculateEvolutionLogic(this.retrievedRecords);
const updatedRecords = this.calculateEvolutionLogic(formattedUpdatedRecords);
            //updateRecords({ recordsToUpdate: this.updatedRows })
                updateRecords({ recordsToUpdate: updatedRecords }).then(() => {
                    this.showToast('Enregistrements mis à jour avec succès', 'Succès', 'success');
                    // Mettre à jour la variable pour masquer les boutons
                    // Clear all datatable draft values
                    this.draftValues = []; // Effacez toutes les valeurs de brouillon
 
                    // Rafraîchir les données après le succès de la sauvegarde
                    //this.refreshData();
                    refreshApex(this.wiredRecordsVar);
              })
                .catch(error => {
                    this.showToast('Erreur', 'Erreur lors de la mise à jour des enregistrements : ' + error.body.message, 'error');
                });
        } else {
            console.log('Aucune donnée mise à jour trouvée');
        }
    }


    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

   // Méthode pour rafraîchir les données
refreshData() 
{
    return refreshApex(this.wiredRecordsVar);
}




/*
calculateEvolutionLogic(records)
{
    const groupedByInterrogeQualite = {};

    records.forEach((record) => {
        const key = record.Interroge_qualite_client__c;
        if (!groupedByInterrogeQualite[key]) {
            groupedByInterrogeQualite[key] = [];
        }
        groupedByInterrogeQualite[key].push(record);
    });

    for (const key in groupedByInterrogeQualite) {
        const groupedRecords = groupedByInterrogeQualite[key];
        let smallestYear = Infinity;
        let smallestRecord;

        groupedRecords.forEach((record) => {
            if (record.Annees_des_enquetes__c < smallestYear) {
                smallestYear = record.Annees_des_enquetes__c;
                smallestRecord = record;
            }
        });

        const recordsToCalculate = groupedRecords.filter(record => record.Annees_des_enquetes__c !== smallestYear);

        recordsToCalculate.forEach((currentRecord, index) => {
            if (index >= 0 && index < recordsToCalculate.length - 1) {
                const previousRecord = recordsToCalculate[index - 1] || smallestRecord;
                const nextRecord = recordsToCalculate[index + 1];

                const previousNote = parseFloat(previousRecord.Note_satisfaction_client_Field__c);
                const currentNote = parseFloat(currentRecord.Note_satisfaction_client_Field__c);
                const nextNote = parseFloat(nextRecord.Note_satisfaction_client_Field__c);

                if (!isNaN(previousNote) && !isNaN(currentNote) && !isNaN(nextNote) && previousNote !== 0) {
                    const prevEvolution = (((currentNote - previousNote) / previousNote)).toFixed(2);
                    const nextEvolution = (((nextNote - currentNote) / currentNote)).toFixed(2);

                    if (prevEvolution > 0) {
                        currentRecord.Evolution_note_satisfaction__c = '+' + prevEvolution + '%';
                    } else {
                        currentRecord.Evolution_note_satisfaction__c = prevEvolution + '%';
                    }

                    if (nextEvolution > 0) {
                        nextRecord.Evolution_note_satisfaction__c = '+' + nextEvolution + '%';
                    } else {
                        nextRecord.Evolution_note_satisfaction__c = nextEvolution + '%';
                    }
                }
            }
        });

        if (smallestRecord) {
            smallestRecord.Evolution_note_satisfaction__c = '';
        }

    }
    */





    calculateEvolutionLogic(records) {
        const groupedByInterrogeQualite = {};
    
        // Grouper les enregistrements par Interroge_qualite_client__c
        records.forEach((record) => {
            const key = record.Interroge_qualite_client__c;
            if (!groupedByInterrogeQualite[key]) {
                groupedByInterrogeQualite[key] = [];
            }
            groupedByInterrogeQualite[key].push(record);
        });
    
        // Pour chaque groupe
        for (const key in groupedByInterrogeQualite) {
            const groupedRecords = groupedByInterrogeQualite[key];
            // Trier les enregistrements par Annees_des_enquetes__c
            groupedRecords.sort((a, b) => a.Annees_des_enquetes__c - b.Annees_des_enquetes__c);
    
            // Ignorer l'enregistrement le plus ancien
            const oldestRecord = groupedRecords.shift();
    
            // Pour les autres enregistrements
            for (let i = 0; i < groupedRecords.length; i++) {
                const currentRecord = groupedRecords[i];
                const previousRecord = i > 0 ? groupedRecords[i - 1] : oldestRecord;
    
                const currentNote = parseFloat(currentRecord.Note_satisfaction_client_Field__c);
                const previousNote = parseFloat(previousRecord.Note_satisfaction_client_Field__c);
    
                if (!isNaN(currentNote) && !isNaN(previousNote)) {
                    const evolution = (((currentNote - previousNote) / previousNote) * 100).toFixed(2);
    
                    if (evolution > 0) {
                        currentRecord.Evolution_note_satisfaction__c = `+${evolution}%`;
                    } else {
                        currentRecord.Evolution_note_satisfaction__c = `${evolution}%`;
                    }
                }
            }
    
            // Effacer l'évolution pour l'enregistrement le plus ancien
            if (oldestRecord) {
                oldestRecord.Evolution_note_satisfaction__c = '';
            }
        }
    
    







    console.log('records555555555111111111111');
                console.log(records);
/*
                if (records.length > 0) {
                    // Appel de la méthode Apex pour mettre à jour les enregistrements avec la constante records
                    updateRecords({ recordsToUpdate: records })
                        .then(() => {
                            // Succès de la mise à jour dans Salesforce
                            this.showToast('Success', 'Records updated successfully', 'success');
                        })
                        .catch(error => {
                            // Gestion des erreurs lors de la mise à jour
                            const errorMessage = error && error.body && error.body.message ? error.body.message : 'Unknown error';
                            this.showToast('Error', 'Error updating records: ' + errorMessage, 'error');
                        });
                }
                
             */   




               
            
                        // Mettre à jour les enregistrements avec les valeurs récupérées
                if (records.length > 0) {
                   
        const formattedUpdatedRecords = records.map(record => {
           /* const updatedRecord = records.find(draftRecord => draftRecord.Id === record.Id);
        
            if (updatedRecord) {
                // Merge the updated fields from this.draftValues into the record
                Object.assign(record, updatedRecord);
            }
        */
            let objFields = {};
            // Assurez-vous d'avoir toutes les clés requises dans objFields pour l'appel Apex
            objFields['Id'] = record.Id;
            objFields['Interroge_qualite_client__c'] = record.Interroge_qualite_client__c;
            objFields['Annees_des_enquetes__c'] = record.Annees_des_enquetes__c;
            objFields['Note_globale_PF__c'] = record.Note_globale_PF__c;
            objFields['Note_satisfaction_client_Field__c'] = record.Note_satisfaction_client_Field__c;
            objFields['Evolution_note_satisfaction__c'] = record.Evolution_note_satisfaction__c;
            objFields['sobjectType'] = this.objectName; // Assurez-vous de l'objet cible
        
            return objFields;
        });
        
        // Maintenant retrievedRecords a la structure attendue pour calculateEvolutionLogic()
        //const updatedRecords = this.calculateEvolutionLogic(this.retrievedRecords);
        //const updatedRecords = this.calculateEvolutionLogic(formattedUpdatedRecords);
                    //updateRecords({ recordsToUpdate: this.updatedRows })
                    console.log('formattedUpdatedRecords6666666666666666');
                    console.log(formattedUpdatedRecords);
                        updateRecords({ recordsToUpdate: formattedUpdatedRecords }).then(() => {
                            this.showToast('Évolution des notes de satisfaction ont été calculées', 'Succès', 'success');
                            // Mettre à jour la variable pour masquer les boutons
                            // Clear all datatable draft values
                            //this.draftValues = []; // Effacez toutes les valeurs de brouillon
         
                            // Rafraîchir les données après le succès de la sauvegarde
                            //this.refreshData();
                            //refreshApex(this.wiredRecordsVar);
                            console.log('formattedUpdatedRecords666666666666666677777777777');
                            console.log(formattedUpdatedRecords);
                      })
                        .catch(error => {
                            this.showToast('Erreur', 'Erreur lors de la mise à jour des enregistrements : ' + error.body.message, 'error');
                        });
                } else {
                    console.log('Aucune donnée mise à jour trouvée');
                }













    return records;
}
 handleRefresh()
 {     /*       

    console.log('this.filteredRecords0000000000000000');
                console.log(this.filteredRecords);
                refreshApex(this.wiredRecordsVar);
                console.log('this.filteredRecords0000000111111111111');
                console.log(this.filteredRecords);
                console.log('this.allRecords000011111111111122222222222222233333333');
                console.log(this.allRecords);
    this.updatedRows = this.calculateEvolutionLogic(this.retrievedRecords);
    console.log('this.filteredRecords0000222222111111111111');
                console.log(this.filteredRecords);
                console.log('this.allRecords0000111111111111222222222222222');
                console.log(this.allRecords);
    const formattedUpdatedRecords = this.retrievedRecords.map(record => {
        const updatedRecord = this.updatedRows.find(updatedRec => updatedRec.Id === record.Id);
    
        if (updatedRecord) {
            // Fusionner les champs mis à jour de this.updatedRows dans l'enregistrement record
            Object.assign(record, updatedRecord);
            console.log('this.updatedRows888888888');
            console.log(this.updatedRows);
        }
    
        // Préparer les champs pour l'appel Apex
        let objFields = {};
    
        // Assurez-vous d'avoir toutes les clés requises dans objFields pour l'appel Apex
        objFields['Id'] = record.Id;
        objFields['Interroge_qualite_client__c'] = record.Interroge_qualite_client__c;
        objFields['Annees_des_enquetes__c'] = record.Annees_des_enquetes__c;
        objFields['Note_globale_PF__c'] = record.Note_globale_PF__c;
        objFields['Note_satisfaction_client_Field__c'] = record.Note_satisfaction_client_Field__c;
        objFields['Evolution_note_satisfaction__c'] = record.Evolution_note_satisfaction__c;
        objFields['sobjectType'] = this.objectName; // Assurez-vous de l'objet cible
    
        return objFields;
    });
    








    //const updatedRecords = this.calculateEvolutionLogic(this.retrievedRecords);
    //console.log('updatedRecords');
    //console.log(updatedRecords);
    console.log('formattedUpdatedRecords000001111');
    console.log(formattedUpdatedRecords);
    console.log('formattedUpdatedRecords000001111lengthlengthlength');
    console.log(formattedUpdatedRecords.length);
    //refreshApex(this.wiredRecordsVar);

    //console.log('this.retrievedRecords');
    //console.log(this.retrievedRecords);
    if(formattedUpdatedRecords && formattedUpdatedRecords.length > 0)
    {
        updateRecords({ recordsToUpdate: formattedUpdatedRecords }).then(() => {
            this.showToast('Succès', 'Les évolutions sont actualisés avec Succès', 'success');
            // Mettre à jour la variable pour masquer les boutons
            // Clear all datatable draft values
            //this.draftValues = []; // Effacez toutes les valeurs de brouillon
    
            // Rafraîchir les données après le succès de la sauvegarde
            //this.refreshData();
            //console.log('this.wiredRecordsVar');
            //console.log(this.wiredRecordsVar);
            //refreshApex(this.wiredRecordsVar);
      })
        .catch(error => {
            this.showToast('Erreur', 'Erreur lors de la mise à jour des enregistrements : ' + error.body.message, 'error');
        });
        //refreshApex(this.wiredRecordsVar);
    
    

    }
 
*/
refreshApex(this.wiredRecordsVar);
/*
// Appeler la méthode calculateEvolutionLogic pour mettre à jour les enregistrements
const updatedRecords = this.calculateEvolutionLogic(this.records); // Assurez-vous d'avoir récupéré vos enregistrements dans "this.records"

// Appel de la méthode Apex pour mettre à jour les enregistrements
updateRecords({ recordsToUpdate: updatedRecords })
    .then(() => {
        // Succès de la mise à jour dans Salesforce
        this.showToast('Success', 'Records updated successfully', 'success');
    })
    .catch(error => {
        // Gestion des erreurs lors de la mise à jour
        this.showToast('Error', 'Error updating records: ' + error.body.message, 'error');
    }); }
    */
}
}