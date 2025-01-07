/*   ************* GFC-1328 ************* 
*   Edited by : Hicham El Achboura
*   Date : 03/01/2023
*   Comment : This Component is used to gather consent from Community visitors and give them control over their cookies. 
*/
import { LightningElement, track, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


/** Apex methods from SampleLookupController */
import getCookieData from "@salesforce/apex/CookieConsentService.getCookieData";
import createCookieConsentRecords from "@salesforce/apex/CookieConsentServiceGuestHelper.createCookieConsentRecords";
import verifyBrowserId from "@salesforce/apex/CookieConsentService.verifyBrowserId";
import getCookiesToDelete from "@salesforce/apex/CookieConsentServiceGuestHelper.getCookiesToDelete";
import getCookieConsentGranted from "@salesforce/apex/CookieConsentServiceGuestHelper.getCookieConsentGranted";
import updateCookieConsentGranted from "@salesforce/apex/CookieConsentServiceGuestHelper.updateCookieConsentGranted";
import insertCookieConsentGranted from "@salesforce/apex/CookieConsentServiceGuestHelper.insertCookieConsentGranted";


/** Standard methods To Update and Refresh records */
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

/** Fields */
import STATUS_FIELD from '@salesforce/schema/CookieConsent__c.Status__c';
import NAME_FIELD from '@salesforce/schema/CookieConsent__c.Name';
import COOKIECONSENTCATEGORY_FIELD from '@salesforce/schema/CookieConsent__c.CookieConsentCategory__c';
import CONSENTCAPTUREDSOURCE_FIELD from '@salesforce/schema/CookieConsent__c.ConsentCapturedSource__c';
import CONSENTCAPTUREDSOURCETYPE_FIELD from '@salesforce/schema/CookieConsent__c.ConsentCapturedSourceType__c';
import CONSENTGIVERID_FIELD from '@salesforce/schema/CookieConsent__c.ConsentGiverId__c';
import ID_FIELD from '@salesforce/schema/CookieConsent__c.Id';
import Id from '@salesforce/user/Id';

/** Labels */
import CookieConsent_LWC_HeaderLabel from '@salesforce/label/c.CookieConsent_LWC_HeaderLabel';
import CookieConsent_LWC_Instructions from '@salesforce/label/c.CookieConsent_LWC_Instructions';
import CookieConsent_LWC_InstructionsWithLink from '@salesforce/label/c.CookieConsent_LWC_InstructionsWithLink';
import CookieConsent_LWC_InformationButtonLabel from '@salesforce/label/c.CookieConsent_LWC_InformationButtonLabel';
import CookieConsent_LWC_ConfirmButtonLabel from '@salesforce/label/c.CookieConsent_LWC_ConfirmButtonLabel';
import CookieConsent_LWC_RejectButtonLabel from '@salesforce/label/c.CookieConsent_LWC_RejectButtonLabel';
import CookieConsent_LWC_ViewCookiesLinkLabel from '@salesforce/label/c.CookieConsent_LWC_ViewCookiesLinkLabel';
import CookieConsent_LWC_ModifierAutorisationsButtonLabel from '@salesforce/label/c.CookieConsent_LWC_ModifierAutorisationsButtonLabel';
import CookieConsent_LWC_HeadingLabelUserConfiguration from '@salesforce/label/c.CookieConsent_LWC_HeadingLabelUserConfiguration';
import CookieConsent_LWC_AfficherAutorisationsButtonLabel from '@salesforce/label/c.CookieConsent_LWC_AfficherAutorisationsButtonLabel';
import CookieConsent_LWC_ModifierAutorisationsTitle from '@salesforce/label/c.CookieConsent_LWC_ModifierAutorisationsTitle';
import CookieConsent_LWC_AnnulerAutorisationsButtonLabel from '@salesforce/label/c.CookieConsent_LWC_AnnulerAutorisationsButtonLabel';

export default class CookieConsent extends NavigationMixin( LightningElement ) 
{
  /* 
  * ************ Private Variables *************
  * ************      Labels      *************
  */ 
  CookieConsent_LWC_HeaderLabel = CookieConsent_LWC_HeaderLabel;
  CookieConsent_LWC_Instructions = CookieConsent_LWC_Instructions;
  CookieConsent_LWC_InstructionsWithLink = CookieConsent_LWC_InstructionsWithLink;
  CookieConsent_LWC_InformationButtonLabel = CookieConsent_LWC_InformationButtonLabel;
  CookieConsent_LWC_ConfirmButtonLabel = CookieConsent_LWC_ConfirmButtonLabel;
  CookieConsent_LWC_RejectButtonLabel = CookieConsent_LWC_RejectButtonLabel;
  CookieConsent_LWC_ViewCookiesLinkLabel = CookieConsent_LWC_ViewCookiesLinkLabel;
  CookieConsent_LWC_ModifierAutorisationsButtonLabel = CookieConsent_LWC_ModifierAutorisationsButtonLabel;
  CookieConsent_LWC_HeadingLabelUserConfiguration = CookieConsent_LWC_HeadingLabelUserConfiguration;
  CookieConsent_LWC_AfficherAutorisationsButtonLabel = CookieConsent_LWC_AfficherAutorisationsButtonLabel;
  CookieConsent_LWC_ModifierAutorisationsTitle = CookieConsent_LWC_ModifierAutorisationsTitle;
  CookieConsent_LWC_AnnulerAutorisationsButtonLabel = CookieConsent_LWC_AnnulerAutorisationsButtonLabel;
  /* 
  * ************ Public Variables *************
  * ************      State      *************
  */ 
  @api displayType = "footer";
  @api useRelaxedCSP = false;
  
  /* 
  * ************ Private Variables *************
  * ************      State      *************
  */ 
  VarToTrue = true;
  @track showCookieDialog;
  preview;
  loading = true;
  loadingEditScreen = true;
  finterprintInitialized = false;
  showConnectionError;
  @track modalToEdit = false;
  @track modalToEditUserConfiguration = false;
  /* 
  * ************ Private Variables *************
  * ************      Data      *************
  */  
  @track cookiePreferences = [];
  @track cookieData;
  @track CookieConsentrecords;
  @track CookieConsentrecordsName = [];
  @track CookieConsentrecordsId = [];
  @track CookieConsentrecordsStatus = [];
  @track CookieConsentrecordToUpdate = [];
  @track CookieConsentrecordToUpdateBackup = [];
  @track CurrentStatusList = [];
  @track ConsentGiverId = [];
  @track CookieConsentRec = {};
  uniqueId;
  userId = Id;

  /* 
  * ************ Public Variables *************
  * ************      Design      *************
  */ 
  //@api headingLabel = "Manage Cookies";
  @api headingLabel = CookieConsent_LWC_HeaderLabel;
  //@api instructions = "Cookie Instructions";
  @api instructions = CookieConsent_LWC_Instructions;
  //@api instructionsWithLink = "Cookie Instructions With Link";
  @api instructionsWithLink = CookieConsent_LWC_InstructionsWithLink;
  //@api informationButtonLabel = "View Privacy Policy";
  @api informationButtonLabel = CookieConsent_LWC_InformationButtonLabel;
  @api informationButtonLink = "https://www.salesforce.com";
  //@api viewCookiesLabel = "View Cookies";
  @api viewCookiesLabel = CookieConsent_LWC_ViewCookiesLinkLabel;
  @api viewCookiesLink = "https://www.salesforce.com";
  //@api confirmButtonLabel = "Confirm Preferences";
  @api confirmButtonLabel = CookieConsent_LWC_ConfirmButtonLabel;
  //@api rejectButtonLabel = "Leave Site";
  @api rejectButtonLabel = CookieConsent_LWC_RejectButtonLabel;
  @api cookieFooterRelative = false;
  @api cookieFooterPadding = "small";
  @api cookieFooterButtonAlignment = "center";
  @api cookieFooterBackgroundColor = "rgb(0,0,0)";
  @api cookieFooterLinkColor = "rgb(250, 250, 250)";
  @api cookieFooterTextColor = "rgb(250, 250, 250)";
  @api previewInBuilder = false;
  
  /* 
  * ************ Private Variables *************
  * ************      Design      *************
  */ 
  error;

  connectedCallback() 
  {
    this.headingLabel = CookieConsent_LWC_HeaderLabel;
    this.instructions = CookieConsent_LWC_Instructions;
    this.instructionsWithLink = CookieConsent_LWC_InstructionsWithLink;
    this.informationButtonLabel = CookieConsent_LWC_InformationButtonLabel;
    this.viewCookiesLabel = CookieConsent_LWC_ViewCookiesLinkLabel;
    this.confirmButtonLabel = CookieConsent_LWC_ConfirmButtonLabel;
    this.rejectButtonLabel = CookieConsent_LWC_RejectButtonLabel;
    this.uniqueId = this.userId;
    this.checkIfInPreview();
    
    if (!this.useRelaxedCSP && !this.preview) 
    {
      this.verifyBrowserIdWithUniqueId();
    } 

    else if (this.previewInBuilder) 
    {
      this.uniqueId = Math.random();
      this.verifyBrowserIdWithUniqueId();
    }
  }

  checkIfInPreview() 
  {
    let urlToCheck = window.location.href;
    if (!urlToCheck) 
    {
      urlToCheck = window.location.hostname;
    }
    if (!urlToCheck) 
    {
      this.preview = false;
    } 
    else 
    {
      urlToCheck = urlToCheck.toLowerCase();
      this.preview = urlToCheck.indexOf("sitepreview") >= 0 || urlToCheck.indexOf("livepreview") >= 0;  
    }
  }

  @api
  verifyBrowserIdWithUniqueId() 
  { 
    if(this.uniqueId != null)
    {
      verifyBrowserId({ browserId: this.uniqueId })
      .then(data => 
      {
        if (data === false) 
        {
          this.getCookieSectionsAndData();
        }
        else if (this.displayType === "page") 
        {
          this.getCookieSectionsAndData();
        }
        else if (data === true) 
        {

        }

        this.showCookieDialog = !data;
      })
      .catch(error => 
      {
        this.error = error.message; 
         /** Standard Show Toast Event => Alert POPUP */
         const evt = new ShowToastEvent(
          {
            title: 'Error Type : ' + error.statusText ,
            message: error.body.message,
              variant: 'error',
              mode: 'dismissible',
          });
          this.dispatchEvent(evt);
      });

    }
    else
    {
      this.getCookieSectionsAndData();
      this.showCookieDialog = true;
    }
    
  }

  @api
  getCookieSectionsAndData() 
  {
    getCookieData()
      .then(data => 
      {
        this.cookieData = JSON.parse(JSON.stringify(data));
        this.setStartingCookiePreferences(data);
        this.loading = false;
      })
      .catch(error => 
        {
          console.log("error" );
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
        });
  }

  @api
  setStartingCookiePreferences(cookieData) 
  {
    for (let i = 0, len = cookieData.length; i < len; i++) 
    {
      this.cookiePreferences.push({ authorizationFormId: cookieData[i].RelatedAuthorizationFormId, value: cookieData[i].DefaultValue });
    }
  }

  acceptCookies() 
  { 
    createCookieConsentRecords({ browserId: this.uniqueId, cookiePreferences: this.cookiePreferences })
      .then(data => 
      {
        this.showCookieDialog = false;
        this.modalToEdit = false;
        this.modalToEditUserConfiguration = false;
      })
      .catch(error => 
      {
        this.error = error.message;
         /** Standard Show Toast Event => Alert POPUP */
         const evt = new ShowToastEvent(
          {
              title: 'Error Type : ' + error.statusText ,
              message: error.body.message,
              variant: 'error',
              mode: 'dismissible',
          });
          this.dispatchEvent(evt);
      });
  }

  rejectCookies() 
  {
    this.cookiePreferences = [];

    for (let i = 0, len = this.cookieData.length; i < len; i++) 
    {
      this.cookieData[i].Mandatory == true ? this.cookiePreferences.push({ authorizationFormId: this.cookieData[i].RelatedAuthorizationFormId, value: true }) : this.cookiePreferences.push({ authorizationFormId: this.cookieData[i].RelatedAuthorizationFormId, value: false });
    }

    createCookieConsentRecords({ browserId: this.uniqueId, cookiePreferences: this.cookiePreferences })
    .then(data => 
    {
      this.showCookieDialog = false;
      this.modalToEdit = false;
      this.modalToEditUserConfiguration = false;
      this.showConnectionError = false;
    })
    .catch(error => 
    {
      this.error = error.message;
       /** Standard Show Toast Event => Alert POPUP */
       const evt = new ShowToastEvent(
        {
            title: 'Error Type : ' + error.statusText ,
            message: error.body.message,
            variant: 'error',
            mode: 'dismissible',
        });
        this.dispatchEvent(evt);
    });

    //window.history.back();
    /*this[NavigationMixin.Navigate](
    {
      type: 'comm__loginPage',
      attributes: 
      {
        actionName: 'logout'
      }
    });
    */
  }

  get shouldIShowCookieDialog() 
  {
    if (this.showCookieDialog === true) 
    {
      return true;
    }
    return false;
  }

  dedupeCookiePreferences(cookiePreferences) 
  {
    let obj = {};
    for (let i = 0, len = cookiePreferences.length; i < len; i++) 
    {
      obj[cookiePreferences[i]["authorizationFormId"]] = cookiePreferences[i];
    }
    cookiePreferences = new Array();
    for (let key in obj) 
    {
      cookiePreferences.push(obj[key]);
    }
    this.cookiePreferences = cookiePreferences;
  }

  showSection(event) 
  {
    let arrayCopy = JSON.parse(JSON.stringify(this.cookieData));
    let sectionName = event.currentTarget.dataset.value;
    for (let key in arrayCopy) 
    {
      if (arrayCopy[key].SectionName === sectionName) 
      {
        try 
        {
          arrayCopy[key].ShowSection = !arrayCopy[key].ShowSection;
          if (arrayCopy[key].ShowSection === true) 
          {
            arrayCopy[key].SectionIcon = "utility:chevrondown";
          } 
          else 
          {
            arrayCopy[key].SectionIcon = "utility:chevronright";
          }
        } 
        catch (error) 
        {
          this.error = error.message;
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
    }
    this.cookieData = arrayCopy;
  }

  informationButtonSelected() 
  {
    let url = this.informationButtonLink;
    window.open(url, "_blank");
  }

  cookiesButtonSelected() 
  {
    let url = this.viewCookiesLink;
    window.open(url);
  }

  get headingStyle() 
  {
    return "font-size:1.2rem;font-weight:bold;color:" + this.cookieFooterTextColor;
  }

  get textStyle() 
  {
    return "font-size:.9rem;color:" + this.cookieFooterTextColor;
  }

  get linkStyle() 
  {
    return "font-size:.9rem;font-weight:bold;color:" + this.cookieFooterLinkColor;
  }

  get backgroundStyle() 
  {
    return "background-color:" + this.cookieFooterBackgroundColor;
  }

  get footerState() 
  {
    return this.displayType === "footer" && this.showCookieDialog === true;
  }

  get modalState() 
  {
    return this.displayType === "modal";
  }

  get pageState() 
  {
    return this.displayType === "page";
  }

  get footerButtonClass() 
  {
    switch (this.cookieFooterButtonAlignment) 
    {
      case "left":
        return "slds-grid slds-wrap";
      case "center":
        return "slds-grid slds-wrap slds-grid--align-center";
      case "right":
        return "slds-grid slds-wrap slds-grid--align-end";
      default:
        return "slds-grid slds-wrap";
    }
  }

  get footerContainerPadding() 
  {
    return "slds-size--1-of-1 slds-p-around_" + this.cookieFooterPadding;
  }

  get footerContainerClass() 
  {
    if (this.cookieFooterRelative === false) 
    {
      return "cookiecon-footer-container-fixed";
    } 
    else 
    {
      return "cookiecon-footer-container-relative";
    }
  }  

  /*   ************* GFC-1373 ************* 
  *   Edited by : Hicham El Achboura
  *   Date : 25/01/2023
  *   Comment : This Component is used to edit cookie consent records from Community visitors and give them control over their autorisations. 
  */
  async editAutorisations()
  {
    // Create the recordInput object
    let AuthorizationFormIdList = [];
    let AuthorizationFormRecList = [];
    if(this.CurrentStatusList.length != 0)
    {
      this.CurrentStatusList.forEach(item => 
      {
        AuthorizationFormIdList.push(item.authorizationFormId);
        item.value == true ?    AuthorizationFormRecList.push({Status__c : 'Agreed', Id :item.authorizationFormId}) : AuthorizationFormRecList.push({Status__c : 'Declined', Id : item.authorizationFormId});
      });
      
      updateCookieConsentGranted({AuthorizationFormRecList : AuthorizationFormRecList}).then(data => 
      {
        this.closeShowUserConfigurationModal();
      })
      .catch(error => 
      {
        console.log("error" );
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
      });
    }
    else
    {
      this.closeShowUserConfigurationModal();
    }   
  }

  async createCookieConsentRec(CookieConsentRec) 
  {    
    insertCookieConsentGranted({ CookieConsentList : CookieConsentRec })
    .then(result => 
    {
      this.message = result;
      this.error = undefined;
      this.closeShowUserConfigurationModal();
      this.showAutorisations();
    })
    .catch(error => 
    {
      this.message = undefined;
      this.error = error;
      this.dispatchEvent(new ShowToastEvent(
      {
        title: 'Error creating record',
        message: error.body.message,
        variant: 'error',
      }),);
    
      console.log("error", JSON.stringify(this.error));
    });
  } 
  
  //Function to remove duplicates
  removeDuplicates(arr)
  {
    let resultArray = [];
    arr.forEach(item => 
    {
      if (!resultArray.some(subItem => Object.keys(subItem).every(key => subItem[key] === item[key]))) 
      {
        resultArray.push(item);
      }
    });
    
    this.CurrentStatusList = resultArray;    
  }

  updateSectionStatus(event) 
  {
    let authorizationFormId = event.target.name;
    let value = event.target.checked;
    let updatedPreference = { authorizationFormId: authorizationFormId, value: value };
    const newArray = [].concat(this.cookiePreferences, updatedPreference);
    this.CurrentStatusList.push({ authorizationFormId: authorizationFormId, value: value })  
    for (let i = 0, len = this.CurrentStatusList.length; i < len; i++) 
    {
      authorizationFormId == this.CurrentStatusList[i]['authorizationFormId']  ?  this.CurrentStatusList[i]['value'] = value : this.CurrentStatusList = this.CurrentStatusList;
    }
     
    this.cookiePreferences = newArray;
    this.dedupeCookiePreferences(this.cookiePreferences);
    this.CurrentStatusList.length != 0 ?  this.removeDuplicates(this.CurrentStatusList) : this.CurrentStatusList = this.CurrentStatusList;
  }
  
  showSectionEditAutorisations(event) 
  {
    let arrayCopy = JSON.parse(JSON.stringify(this.CookieConsentrecords));
    let sectionName = event.currentTarget.dataset.value;
    for (let key in arrayCopy) 
    {
      if (arrayCopy[key].SectionName === sectionName) 
      {
        try 
        {
          arrayCopy[key].ShowSection = !arrayCopy[key].ShowSection;
          if (arrayCopy[key].ShowSection === true) 
          {
            arrayCopy[key].SectionIcon = "utility:chevrondown";
          } 
          else 
          {
            arrayCopy[key].SectionIcon = "utility:chevronright";
          }
        } 
        catch (error) 
        {
          this.error = error.message;
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
    }

    this.CookieConsentrecords = arrayCopy;
  }

  /*   ************* GFC-1328 ************* 
  *   Edited by : Hicham El Achboura
  *   Date : 03/01/2023
  *   Comment : This Component is used to gather consent from Community visitors and give them control over their cookies. 
  */
  async showAutorisations()
  {
    verifyBrowserId({ browserId: this.uniqueId })
    .then(data => 
    {
      if(data == true)
      {
        this.loadingEditScreen = true;
        this.CookieConsentrecordToUpdate = [];
        this.CookieConsentrecordsName = []; 
        this.CookieConsentrecordsId = []; 
        this.CookieConsentrecordsStatus = []; 
        this.CookieConsentrecords = []; 
        this.modalToEditUserConfiguration = true;
        this.getCookieSectionsAndData();
        
        getCookieConsentGranted({ browserId: this.uniqueId })
        .then(data => 
        {  

          this.CookieConsentrecords = data;
          this.CookieConsentrecords.forEach(CookieConsentRecordTemp => 
          {
            this.CookieConsentrecordsName.push(CookieConsentRecordTemp.SectionName);
            this.CookieConsentrecordsId.push(CookieConsentRecordTemp.RelatedAuthorizationFormId);
            this.CookieConsentrecordsStatus.push(CookieConsentRecordTemp.Status);
            this.ConsentGiverId.push(CookieConsentRecordTemp.ConsentGiverId);    
          }); 
          this.cookieData.forEach(CookieConsentrecordTemp => 
          {
            if(this.CookieConsentrecordsName.includes(CookieConsentrecordTemp.SectionName) == false)
            {
              this.CookieConsentRec.Name = CookieConsentrecordTemp.SectionName;
              this.CookieConsentRec.Status__c = 'Agreed';
              this.CookieConsentRec.CookieConsentCategory__c = CookieConsentrecordTemp.RelatedAuthorizationFormId;
              this.CookieConsentRec.ConsentCapturedSource__c= 'Salesforce Community';
              this.CookieConsentRec.ConsentCapturedSourceType__c= 'Web';
              this.CookieConsentRec.ConsentGiverId__c= this.ConsentGiverId[0];
              this.createCookieConsentRec(this.CookieConsentRec);
              this.loadingEditScreen = false;
            }
            else 
            {
              this.loadingEditScreen = false;
            }  
          }); 
            
          this.CookieConsentrecordToUpdateBackup = this.CookieConsentrecordToUpdate;
        })
        .catch(error => 
        {
          this.error = error.message; 
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
        });
      }
      else
      {
        this[NavigationMixin.Navigate]({
          type: 'standard__namedPage',
          attributes: {
              pageName: 'home'
          },
      });
      }
    })
    .catch(error => 
    {
      this.error = error.message; 
       /** Standard Show Toast Event => Alert POPUP */
       const evt = new ShowToastEvent(
        {
          title: 'Error Type : ' + error.statusText ,
          message: error.body.message,
            variant: 'error',
            mode: 'dismissible',
        });
        this.dispatchEvent(evt);
    });
  }

  closeShowUserConfigurationModal()
  {
    this.modalToEditUserConfiguration = false;
    this.CurrentStatusList = [];
  }

  /*   ************* GFC-1414 ************* 
  *   Edited by : Hicham El Achboura
  *   Date : 06/02/2023
  *   Comment : This Method is used to edit cookie consent records. 
  */
  async editAutorisationsWithReject()
  {
    // Create the recordInput object
    let AuthorizationFormIdList = [];
    let AuthorizationFormRecList = [];
    
    for (let i = 0, len = this.CookieConsentrecords.length; i < len; i++) 
    {
      this.CookieConsentrecords[i].Mandatory == true  ?  AuthorizationFormRecList.push({Status__c : 'Agreed', Id :this.CookieConsentrecords[i].RelatedAuthorizationFormId}) : AuthorizationFormRecList.push({Status__c : 'Declined', Id : this.CookieConsentrecords[i].RelatedAuthorizationFormId});
    }
    
    updateCookieConsentGranted({AuthorizationFormRecList : AuthorizationFormRecList}).then(data => 
    {
      this.closeShowUserConfigurationModal();
    })
    .catch(error => 
    {
      console.log("error" );
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
    });
  }
}