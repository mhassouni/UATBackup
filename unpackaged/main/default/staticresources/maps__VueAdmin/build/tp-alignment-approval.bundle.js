"use strict";(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[6293],{8025:(s,e,t)=>{t.r(e),t.d(e,{default:()=>o});var a=t(2646),l=t(5658),i=t(257);const p={components:{Checkbox:a.XZ,Picklist:a.Gp,Spinner:a.$j},data(){return{isLoading:!1,approvalSettings:{enabled:!1,approvalType:"tp",showTPStatuses:!0,publishPDF:!1,pdfAOnly:!1,pdfPubOnly:!1,exportCSV:!1,csvAOnly:!1,exCSVPubOnly:!1,publishCSV:!1,pubcsvAOnly:!1,pubCSVPubOnly:!1,publishETM:!1,etmAOnly:!1,etmPubOnly:!1,publishMaps:!1,mapAOnly:!1,mapPubOnly:!1,publishObj:!1,oAOnly:!1,objPubOnly:!1,publishFSL:!1,fslAOnly:!1,fslPubOnly:!1},searchTerm:{label:"",value:null},includeAlias:!1,searches:[{options:s=>this.$remote("maps.TPRemoteActions.GetUsers",[s.replace(/[^a-z\d\s]+/gi,"%")]).then((s=>s.data))}],approvers:[],publishers:[],approvalTypes:[{id:"tp",title:"Territory Planning"}]}},async created(){this.isLoading=!0,"Professional Edition"!==window.MA.Organization.Edition&&this.approvalTypes.push({id:"standard",title:"Salesforce"}),await this.getSettings(),await this.getApprovalSettings(),await this.getApprovers(""),await this.getPublishers(),this.isLoading=!1},methods:{searchUserProfile(s){return new Promise((e=>{const t={ajaxResource:"TooltipAJAXResources",action:"get_lookup_optionsv2",baseObject:"User",fieldApiName:"Id",fieldName:"Id",grandparentField:"--none--",term:s,keepSearch:!1};(new i.Z).setAction(this.$Remoting.processAJAXRequest).setErrorHandler((()=>{e({results:[]})})).invoke([t],(s=>{if(s.success){const{lookupOptions:t=[]}=s;e(t)}else e({results:[]})}),{escape:!1,buffer:!1})}))},async selectItem(s){this.searchTerm=s,"tp"===this.approvalSettings.approvalType?await this.updateApprover(s.Id,s.Name,!0):await this.updatePublisher(s.Id,s.Name,!0),this.clearResults()},clearResults(){this.searchTerm={label:"",value:null}},async getApprovalSettings(){try{const{data:s,message:e,success:t}=await this.$remote("maps.TPRemoteActions.GetAlignmentApprovalSettings");if(t){const e={enabled:!1,approvalType:"tp",publishFSL:!1,showTPStatuses:!0,publishMaps:!1,publishETM:!1,publishObj:!1,publishPDF:!1,publishCSV:!1,exportCSV:!1,...s.maps__Value__c?JSON.parse(s.maps__Value__c):{}},t={fslAOnly:!1,mapAOnly:!1,pdfAOnly:!1,csvAOnly:!1,pubcsvAOnly:!1,oAOnly:!1,etmAOnly:!1,...s.maps__Value2__c?JSON.parse(s.maps__Value2__c):{}},a={mapPubOnly:!1,pdfPubOnly:!1,exCSVPubOnly:!1,pubCSVPubOnly:!1,etmPubOnly:!1,objPubOnly:!1,fslPubOnly:!1,...s.maps__Value3__c?JSON.parse(s.maps__Value3__c):{}};this.approvalSettings={...e,...t,...a};const l=Object.keys(s.maps__Value__c?JSON.parse(s.maps__Value__c):{});l.includes("publishCSV")&&!l.includes("exportCSV")&&(this.approvalSettings.exportCSV=this.approvalSettings.publishCSV,this.approvalSettings.publishCSV=!1)}else console.error(e)}catch(s){console.error(s)}},async getSettings(){try{const{data:s,message:e,success:t}=await this.$remote("maps.TPRemoteActions.GetSettings",[["Include aliases on user search"]]);t?this.includeAlias=JSON.parse(s[0].maps__Value__c):console.error(e)}catch(s){console.error(s)}},async saveApprovalSettings(s){try{this.isLoading=!0,this.approvalSettings.enabled||(this.approvers.forEach((s=>{this.removeApprover(s.Id,s.Name)})),this.publishers.forEach((s=>{this.removePublisher(s.Id,s.Name)}))),"tp"===this.approvalSettings.approvalType&&(this.approvalSettings.showTPStatuses=!0);const e={enabled:this.approvalSettings.enabled,approvalType:this.approvalSettings.enabled?this.approvalSettings.approvalType:"tp",showTPStatuses:!this.approvalSettings.enabled||this.approvalSettings.showTPStatuses,publishPDF:this.approvalSettings.publishPDF,publishMaps:this.approvalSettings.publishMaps,publishETM:this.approvalSettings.publishETM,publishFSL:this.approvalSettings.publishFSL,publishObj:this.approvalSettings.publishObj,publishCSV:this.approvalSettings.publishCSV,exportCSV:this.approvalSettings.exportCSV},t={pdfAOnly:!!this.approvalSettings.enabled&&this.approvalSettings.pdfAOnly,csvAOnly:!!this.approvalSettings.enabled&&this.approvalSettings.csvAOnly,pubcsvAOnly:!!this.approvalSettings.enabled&&this.approvalSettings.pubcsvAOnly,etmAOnly:!!this.approvalSettings.enabled&&this.approvalSettings.etmAOnly,oAOnly:!!this.approvalSettings.enabled&&this.approvalSettings.oAOnly,mapAOnly:!!this.approvalSettings.enabled&&this.approvalSettings.mapAOnly,fslAOnly:!!this.approvalSettings.enabled&&this.approvalSettings.fslAOnly},a={mapPubOnly:!!this.approvalSettings.enabled&&this.approvalSettings.mapPubOnly,pdfPubOnly:!!this.approvalSettings.enabled&&this.approvalSettings.pdfPubOnly,exCSVPubOnly:!!this.approvalSettings.enabled&&this.approvalSettings.exCSVPubOnly,pubCSVPubOnly:!!this.approvalSettings.enabled&&this.approvalSettings.pubCSVPubOnly,etmPubOnly:!!this.approvalSettings.enabled&&this.approvalSettings.etmPubOnly,objPubOnly:!!this.approvalSettings.enabled&&this.approvalSettings.objPubOnly,fslPubOnly:!!this.approvalSettings.enabled&&this.approvalSettings.fslPubOnly},{data:l,message:i,success:p}=await this.$remote("maps.TPRemoteActions.SaveAlignmentApprovalSettings",[JSON.stringify(e),JSON.stringify(t),JSON.stringify(a)]);let o;if(o=this.approvalSettings.enabled&&!s?this.$Labels.settingsTPAlignmentApproval_Approver_Enabled:s?this.$Labels.settingsTPAlignmentApproval_Method_Updated:this.$Labels.settingsTPAlignmentApproval_Approver_Disabled,p){const s=JSON.parse(l.maps__Value__c),e=JSON.parse(l.maps__Value2__c),t=JSON.parse(l.maps__Value3__c);this.approvalSettings={...s,...e,...t},this.$root.$emit("toast",{message:o,state:"success",duration:8e3})}else console.error(i)}catch(s){console.error(s)}finally{this.isLoading=!1}},async updateApprover(s,e,t){try{this.isLoading=!0;const{message:a,success:i}=await this.$remote("maps.TPRemoteActions.UpdateObjectBatch",[[{Id:s,maps__TPApprover__c:t}],!0,""]);i?(t?this.approvers.push({Id:s,Name:e,maps__TPApprover__c:!0}):this.approvers.splice(this.approvers.findIndex((e=>e.Id===s)),1),this.$root.$emit("toast",{message:t?(0,l.N4)(this.$Labels.settingsTPAlignmentApproval_Approver_Added,[e]):(0,l.N4)(this.$Labels.settingsTPAlignmentApproval_Approver_Removed,[e]),state:"success",duration:8e3})):console.error(a)}catch(s){console.error(s)}finally{this.isLoading=!1}},async updatePublisher(s,e,t){try{this.isLoading=!0;const{message:a,success:i}=await this.$remote("maps.TPRemoteActions.UpdateObjectBatch",[[{Id:s,maps__TPPublisher__c:t}],!0,""]);i?(t?this.publishers.push({Id:s,Name:e,maps__TPPublisher__c:!0}):this.publishers.splice(this.publishers.findIndex((e=>e.Id===s)),1),this.$root.$emit("toast",{message:t?(0,l.N4)(this.$Labels.settingsTPAlignmentApproval_Publisher_Added,[e]):(0,l.N4)(this.$Labels.settingsTPAlignmentApproval_Publisher_Removed,[e]),state:"success",duration:8e3})):console.error(a)}catch(s){console.error(s)}finally{this.isLoading=!1}},async removeApprover(s,e){this.isLoading=!0,await this.updateApprover(s,e,!1),this.isLoading=!1},async getApprovers(s){try{const{data:e,message:t,success:a}=await this.$remote("maps.TPRemoteActions.GetApprovers",[s]);a?(e.approvers.forEach((s=>this.approvers.push(s))),e.lastId.length>0&&this.getApprovers(e.lastId)):console.error(t)}catch(s){console.error(s)}},async getPublishers(){try{const{data:s,message:e,success:t}=await this.$remote("maps.TPRemoteActions.GetPublishers");t?this.publishers=s.publishers:console.error(e)}catch(s){console.error(s)}},async removePublisher(s,e){this.isLoading=!0,await this.updatePublisher(s,e,!1),this.isLoading=!1}}},o=(0,t(1900).Z)(p,(function(){var s=this,e=s._self._c;return e("div",[s.isLoading?e("Spinner"):s._e(),s._v(" "),e("div",{staticClass:"slds-p-top_large",staticStyle:{display:"inline-block"}},[e("Checkbox",{attrs:{labels:{name:s.$Labels.MA_Alignment_Approval,stateOn:s.$Labels.MA_Enabled,stateOff:s.$Labels.MA_Disabled},toggleBuffer:500,showStateLabels:"",slide:!0},on:{changed:function(e){return s.saveApprovalSettings()}},model:{value:s.approvalSettings.enabled,callback:function(e){s.$set(s.approvalSettings,"enabled",e)},expression:"approvalSettings.enabled"}})],1),s._v(" "),s.approvalSettings.enabled?[e("div",{staticClass:"slds-grid slds-m-top--medium"},[e("Picklist",s._b({staticClass:"slds-size_3-of-12",attrs:{options:s.approvalTypes,labels:{name:s.$Labels.settingsTPAlignmentApproval_Approval_Method},helpText:s.$Labels.settingsTPAlignmentApproval_Approval_Method_HelpText},on:{changed:function(e){return s.saveApprovalSettings(!0)}},model:{value:s.approvalSettings.approvalType,callback:function(e){s.$set(s.approvalSettings,"approvalType",e)},expression:"approvalSettings.approvalType"}},"Picklist",s.$attrs,!1))],1),s._v(" "),e("div",{staticClass:"slds-p-top_large",staticStyle:{display:"inline-block"}},["standard"===s.approvalSettings.approvalType?e("Checkbox",{attrs:{labels:{name:s.$Labels.settingsTPAlignmentApproval_ShowTPStatuses,stateOn:s.$Labels.MA_Enabled,stateOff:s.$Labels.MA_Disabled},toggleBuffer:500,showStateLabels:"",slide:!0},on:{changed:function(e){return s.saveApprovalSettings(!0)}},model:{value:s.approvalSettings.showTPStatuses,callback:function(e){s.$set(s.approvalSettings,"showTPStatuses",e)},expression:"approvalSettings.showTPStatuses"}}):s._e()],1),s._v(" "),e("fieldset",{staticClass:"slds-form-element slds-p-top_medium"},["tp"===s.approvalSettings.approvalType?[e("div",{staticClass:"slds-grid slds-grid_vertical"},[e("Picklist",{staticClass:"slds-size_3-of-12",class:{"slds-has-error":0===s.approvers.length},attrs:{options:s.searches,filterable:"",idKey:"Id",titleKey:"Name",labels:{name:s.$Labels.settingsTPAlignmentApproval_AlignmentApprovers,search:s.$Labels.settingsTPAlignmentApproval_Search_For_Users,noSearchResults:s.$Labels.MA_NO_RESULTS_FOUND},helpText:s.$Labels.settingsTPAlignmentApproval_AlignmentApproversHelpText},on:{clear:s.clearResults,"selected-option":s.selectItem},scopedSlots:s._u([{key:"option",fn:function(t){return e("div",{staticClass:"slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-listbox__option_has-meta",attrs:{role:"option"}},[e("span",{staticClass:"slds-media__body"},[s.includeAlias?e("span",{staticClass:"slds-truncate",attrs:{title:t.option.Name}},[s._v(s._s(t.option.Name)+" ("+s._s(t.option.Alias)+")")]):e("span",{staticClass:"slds-truncate",attrs:{title:t.option.Name}},[s._v(s._s(t.option.Name))]),s._v(" "),t.option.Profile?e("span",{staticClass:"slds-listbox__option-meta"},[s._v(" "+s._s(t.option.Profile.Name))]):s._e()])])}}],null,!1,3687883574),model:{value:s.searchTerm.label,callback:function(e){s.$set(s.searchTerm,"label",e)},expression:"searchTerm.label"}})],1),s._v(" "),0===s.approvers.length?e("div",{staticClass:"slds-text-color_error slds-m-top_xx-small"},[s._v("\n                    "+s._s(s.$Labels.settingsTPAlignmentApproval_Approver_Error)+"\n                ")]):s._e(),s._v(" "),e("div",{staticClass:"slds-m-top_small"},[e("ul",{staticClass:"slds-grid slds-grid_vertical",attrs:{"aria-label":"Selected Options:"}},s._l(s.approvers,(function(t){return e("li",{key:t.Id,staticClass:"slds-size_2-of-7",attrs:{role:"presentation"}},[e("span",{staticClass:"slds-pill slds-p-around_x-small slds-m-bottom_xx-small",staticStyle:{width:"100%"},attrs:{role:"option","aria-selected":"true"}},[e("span",{staticClass:"slds-pill__label",attrs:{title:"Reports"}},[s._v(s._s(t.Name))]),s._v(" "),e("span",{staticStyle:{cursor:"pointer"},on:{click:function(e){return s.removeApprover(t.Id,t.Name)}}},[e("Icon",{attrs:{category:"utility",name:"close",assistiveText:"remove",size:"x-small"}})],1)])])})),0)])]:[e("div",{staticClass:"slds-grid slds-grid_vertical"},[e("Picklist",{staticClass:"slds-size_2-of-7",attrs:{options:s.searches,filterable:"",idKey:"Id",titleKey:"Name",labels:{name:s.$Labels.settingsTPAlignmentApproval_Publishers,search:s.$Labels.settingsTPAlignmentApproval_Search_For_Users,noSearchResults:s.$Labels.MA_NO_RESULTS_FOUND},helpText:s.$Labels.settingsTPAlignmentApproval_Publishers_HelpText},on:{clear:s.clearResults,"selected-option":s.selectItem},scopedSlots:s._u([{key:"option",fn:function(t){return e("div",{staticClass:"slds-media slds-listbox__option slds-listbox__option_plain slds-media_small slds-listbox__option_has-meta",attrs:{role:"option"}},[e("span",{staticClass:"slds-media__body"},[s.includeAlias?e("span",{staticClass:"slds-truncate",attrs:{title:t.option.Name}},[s._v(s._s(t.option.Name)+" ("+s._s(t.option.Alias)+")")]):e("span",{staticClass:"slds-truncate",attrs:{title:t.option.Name}},[s._v(s._s(t.option.Name))]),s._v(" "),t.option.Profile?e("span",{staticClass:"slds-listbox__option-meta"},[s._v(" "+s._s(t.option.Profile.Name))]):s._e()])])}}],null,!1,3687883574),model:{value:s.searchTerm.label,callback:function(e){s.$set(s.searchTerm,"label",e)},expression:"searchTerm.label"}})],1),s._v(" "),e("div",{staticClass:"slds-m-top_small"},[e("ul",{staticClass:"slds-grid slds-grid_vertical",attrs:{"aria-label":"Selected Options:"}},s._l(s.publishers,(function(t){return e("li",{key:t.Id,staticClass:"slds-size_2-of-7",attrs:{role:"presentation"}},[e("span",{staticClass:"slds-pill slds-p-around_x-small slds-m-bottom_xx-small",staticStyle:{width:"100%"},attrs:{role:"option","aria-selected":"true"}},[e("span",{staticClass:"slds-pill__label",attrs:{title:"Reports"}},[s._v(s._s(t.Name))]),s._v(" "),e("span",{staticStyle:{cursor:"pointer"},on:{click:function(e){return s.removePublisher(t.Id,t.Name)}}},[e("Icon",{attrs:{category:"utility",name:"close",assistiveText:"remove",size:"x-small"}})],1)])])})),0)])]],2)]:s._e()],2)}),[],!1,null,null,null).exports}}]);