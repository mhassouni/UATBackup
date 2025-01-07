/*   ************* GFC-1333 ************* 
*   Developed by : Hicham El Achboura
*   Date : 04/01/2023
*   Comment : This Component is used to Show Footer into Community Site. 
*/
import { LightningElement, track, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

/** Labels */
import CommunityLWCFooter_ViewCookiesLinkLabel from '@salesforce/label/c.CommunityLWCFooter_ViewCookiesLinkLabel';
import CommunityLWCFooter_Politique_de_Confidentialite_LinkLabel from '@salesforce/label/c.CommunityLWCFooter_Politique_de_Confidentialite_LinkLabel';

export default class CommunityLWCFooter extends NavigationMixin( LightningElement )  
{
    /* 
    * ************ Private Variables *************
    * ************      Labels      *************
    */ 
    CommunityLWCFooter_ViewCookiesLinkLabel = CommunityLWCFooter_ViewCookiesLinkLabel;
    CommunityLWCFooter_Politique_de_Confidentialite_LinkLabel = CommunityLWCFooter_Politique_de_Confidentialite_LinkLabel;
    
    /* 
    * ************ Public Variables *************
    * ************ Community Builder Configurations Params *************
    */ 
    @api informationButtonLink;

    /* 
    * ************ Method Actions *************
    * ************ Redirecte user to "Politique de Confidentialite" Page  *************
    */ 
    navigateToGreenforcePolitiqueConfidentialitePage() 
    {
        this.informationButtonLink.includes('https://') ? this.informationButtonLink : this.informationButtonLink = 'https://' + this.informationButtonLink;
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                "url": this.informationButtonLink
            },
        });
    }
    
    /* 
    * ************ Method Actions *************
    * ************ Redirecte user to View Cookies Page  *************
    */ 
    navigateToViewCookiesPage() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                "name": "cookies_page__c"    
            },
        });
    }
}