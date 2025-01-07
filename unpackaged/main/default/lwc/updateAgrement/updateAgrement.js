import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateAgrement from '@salesforce/apex/UpdateAgrementController.updateAgrement';

export default class UpdateAgrement extends LightningElement {
    @api recordId;
    @api invoke() {
        
        this.updateAgrement();
    }
    // displays the record Id in the toast
    showToastInfo() {
        const event = new ShowToastEvent({
            title: "Information",
            message: "Demande de mise à jour de l'agrément envoyé",
            variant: "Info",
            mode: "pester"
        });
        this.dispatchEvent(event);
    }
    showToastFinish(message, variant) {
        const event = new ShowToastEvent({
            title: "Mise à jour",
            message: message,
            variant: variant,
            mode: "pester"
        });
        this.dispatchEvent(event);
    }
    updateAgrement() {
        this.showToastInfo();
        updateAgrement({recordId: this.recordId})
            .then(result => {
                if(result == 'Done') {
                    this.showToastFinish("Mise à jour d'/des agrément(s) réalisé", "Success");
                }else if(result == 'Agrement not found') {
                    this.showToastFinish("Aucun agrément n'a été trouvé", "Warning");
                }else if(result == 'Problem with policyId') {
                    this.showToastFinish("Aucun policyId n'a été trouvé", "Warning");
                } else if (result == 'No change'){
                    this.showToastFinish("Aucune modification nécessaire", "Info");
                } else if (result == 'No Sales Area Data'){
                    this.showToastFinish("Veuillez vérifier si une Vue commerciale client existe", "Error");
                }
                
            })
    }
}