import{_ as D,S as w,l as O,P as I,f as N,ac as E,Q as $,bB as j,bC as q,X as x,bD as C,r as b,o as f,b as R,w as y,s as P,v as V,i as g,c as S,F as T,e as A,h as p,t as F,q as W,j as L,p as B,k as G}from"../bundle.js";import{M as J}from"./Modal.76578f76.js";import{c as Q,b as k}from"./click-2-create-mixin.44f9d4c1.js";import"./DatePicker.899772b4.js";import"./TimePicker.bfa4e2f9.js";const U={components:{Spinner:w,Modal:J,SLDSButton:O,Picklist:I},mixins:[Q],props:{modalOptions:{type:Object,required:!0}},emits:["close-modal"],setup(){return{mainStore:N()}},data(){return{isLoading:!1,fieldsetName:"",c2cSettings:{},recordtypeid:"",sObjectApiName:"",dataType:"",features:[],results:{apexError:"",errors:[],warnings:[],totals:{success:0,failure:0},failures:[]},type:"",c2cErrors:[],disableMarker:"false",nameField:"",singleMarkerFieldsMap:{},esriTemplateMap:new Map,esriTemplateOptions:[],esriTemplateName:""}},async created(){this.isLoading=!0;const{features:e,fieldsetName:t,sObjectApiName:s,recordtypeid:i,selectedObjOptions:a,isMassAction:r,objectFieldSetMap:c=new Map,settings:l={},type:n="",dataType:d="",templateFieldMappings:o=new Map}=this.$props.modalOptions,u=c.get(s)??{};this.nameField=u?.nameField,this.c2cSettings=a,this.esriTemplateMap=o,this.fieldsetName=t,this.sObjectApiName=s,this.recordtypeid=i,this.features=e,this.isMassAction=r,this.dataType=d||this.features[0]?.attributes?.dataSource,this.type=n,this.singleMarkerFieldsMap=l[s]?.record,this.qid=E(),this.disableMarker=this.mainStore.settings?.click2create?.disableMarkers??"false",await this.initFieldSetForm({fieldSet:t,sObject:s,recordTypeId:i})},methods:{formatLabel:$,async initFieldSetForm({fieldSet:e,sObject:t,recordTypeId:s}){this.isLoading=!0;const i="clicktocreateform";await this.base_buildFieldSetHTML({fieldSet:e,sObject:t,recordTypeId:s,htmlElementId:i,visualForcePage:"maps__ClickToCreateForm"}),await this.$nextTick(),this.base_attachCssIcons({htmlElementId:i}),this.isMassAction?this.isLoading=!1:this.type==="dataLayerMarkers"?await this.populateDataLayerInputsWithMAIOData():this.type==="esriLayer"?await this.buildEsriTemplateData():await this.populateInputsWithMarkerData(),this.isLoading=!1},async buildEsriTemplateData(){await this.$nextTick(),this.esriTemplateOptions=Array.from(this.esriTemplateMap.keys());const[e]=this.esriTemplateOptions;e&&(this.esriTemplateName=e,this.populateInputsWithEsriTemplateData())},clearC2CForm(){const{FieldsFoundArray:e=[]}=k("clicktocreateform",!0),t=[];e.forEach(s=>{t.push({name:s,value:""})}),this.insertFieldData(t)},insertFieldData(e){e.forEach(t=>{const{name:s,value:i}=t,a=this.$el.querySelector(".ClickToCreateFormTable.fieldSetTable").querySelectorAll(`.fieldInput[data-field="${s}"]`);if(a.length){const r=a[0].querySelector(".get-input");r&&(r.value=i)}})},async populateInputsWithEsriTemplateData(){const[e]=this.features;if(e){this.clearC2CForm();const{FieldsFoundArray:t=[]}=k("clicktocreateform",!0),s=new Set(t),i=this.esriTemplateMap.get(this.esriTemplateName);if(i){const{fieldMappings:a}=i,r=[],{attributes:c={}}=e;a.forEach(l=>{const{staticFieldPath:n,webMapPath:d}=l,o=c?.[d];o&&s.has(n)&&r.push({name:n,value:o})}),r.push(...this.buildEsriGeoFields()),this.insertFieldData(r)}}},async populateDataLayerInputsWithMAIOData(){if(this.isMassAction||this.type!=="dataLayerMarkers")return;await this.$nextTick();const t=(await this.getServerData())?.data?.data[0];t&&Object.keys(t).forEach(s=>{const i=t[s],a=this.$el.querySelector(".ClickToCreateFormTable.fieldSetTable").querySelectorAll(`.fieldInput[data-field="${s}"]`);if(a.length){const r=a[0].querySelector(".get-input");r&&(r.value=i)}})},async populateInputsWithMarkerData(){await this.$nextTick();const e=this.buildSingleActionGeoFields([]);this.insertFieldData(e)},close(){this.$emit("close-modal")},async getServerData(){const{fields:e}=k("clicktocreateform",!0),t=Object.values(e),{fields:s}=this.c2cSettings,i=this.$props.modalOptions.features.map(l=>l.attributes.uid),a=Object.keys(s).map(l=>({topic_id:l.replace("dmp_",""),field:s[l]})),r={uIds:i,topicData:a,sfdcData:t,dataType:this.dataType};return await j(r)},buildEsriGeoFields(){const e=this.esriTemplateMap.get(this.esriTemplateName)??{},{latlng:t}=e,s=[];if(t){const{lat:i,lng:a}=t;s.push({name:i,value:this.features[0].lat}),s.push({name:a,value:this.features[0].lng})}return s},buildSingleActionGeoFields(e){if(this.features.length===0)return[];const t={myPosition:"maps__MyPosition",poi:"maps__POI",mapClick:"maps__MapClick"},[s]=this.features,i=t[this.type],a=this.singleMarkerFieldsMap,r=new Set(e.map(({name:h})=>h)),{attributes:c={},lat:l,lng:n,title:d}=s,{addressFields:o={}}=c,u={Latitude__c:l,Longitude__c:n,Name__c:d,Phone__c:c.phone,Website__c:c.website,Street__c:o.street,City__c:o.city,State__c:o.state,StateShort__c:o.stateCode,PostalCode__c:o.zipCode,Country__c:o.country,CountryShort__c:o.countryCode,maps__DefaultField__c:a[`${i}DefaultValue__c`]};return Object.keys(u).forEach(h=>{const m=a[`${h.indexOf("maps__")===0?"":i}${h}`],_=u[h];m&&_&&!r.has(m)&&e.push({name:m,value:_})}),e},handleSaveForm(){this.isMassAction||this.type==="dataLayerMarkers"?this.saveDataLayerForm():this.saveSingleActionForm()},async saveDataLayerForm(){this.c2cErrors=[],this.isLoading=!0;const{data:e,success:t,message:s}=await this.getServerData();if(!t&&s){this.mainStore.toast({message:this.$Labels.Almost_There,subMessage:s??this.$Labels.Common_Refresh_And_Try_Again,state:"error"}),this.close();return}const i={...e,fieldSetName:this.fieldsetName,objectType:this.sObjectApiName,recordtypeid:this.recordtypeid},a=q(i),r=async l=>{try{const{success:n,data:d}=await MAPS.Utils.Apex.invoke("maps.RemoteFunctions.processAJAXRequest",[l]);if(n&&d){const{totals:{success:o=0,failure:u=0},errors:h,failures:m,warnings:_,records:M}=d;!this.isMassAction&&M.length&&(this.features[0].linkId=M[0].id,this.features[0].layerId=this.qid),this.results.totals.success+=o,this.results.totals.failure+=u,this.results.errors=this.results.errors.concat(h),this.results.failures=this.results.failures.concat(m),this.results.warnings=this.results.warnings.concat(_)}}catch(n){this.results.apexError=n}};await new x({maxConcurrency:3,workers:a.map(l=>r.bind(this,l)),done:async()=>{if(this.close(),this.isLoading=!1,this.isMassAction)this.modalOptions.callback({results:this.results,contentType:"results"});else if(this.results.errors.length)this.modalOptions.callback({results:this.results,contentType:"results"});else{if(this.mainStore.toast({message:this.$Labels.MA_Record_Created??"Record Created.",state:"success"}),this.disableMarker==="true")return;C(this.features[0])}}}).start()},async saveSingleActionForm(){this.isLoading=!0,this.c2cErrors=[];const{fields:e}=k("clicktocreateform",!0);let t=Object.keys(e).map(l=>({name:l,value:e[l].value}));this.type==="esriLayer"?t.push(...this.buildEsriGeoFields()):t=this.buildSingleActionGeoFields(t);const s={action:"createRecord",ajaxResource:"TooltipAJAXResources",fieldSet:this.fieldsetName,fields:JSON.stringify(t),recordtypeid:this.recordtypeid,sobject:this.sObjectApiName},{record:i,success:a,error:r,errors:c=[]}=await MAPS.Utils.Apex.invoke("maps.RemoteFunctions.processAJAXRequest",[s]);if(!a)this.mainStore.toast({message:this.$Labels.MA_Something_Went_Wrong??"Something went wrong",subMessage:this.$Labels.MA_Record_Not_Created??"Record Not Created.",state:"error"}),r&&c.push(r),this.c2cErrors=c;else{if(this.features[0].title=i[this.nameField]??this.features[0].title,this.features[0].linkId=i.Id,this.features[0].uid=this.qid,this.features[0].layerId=this.qid,this.mainStore.toast({message:this.$Labels.MA_Record_Created??"Record Created.",state:"success"}),this.disableMarker==="true"){this.close();return}C(this.features[0]),this.close()}this.isLoading=!1}}},v=e=>(B("data-v-bcea6a8d"),e=e(),G(),e),X=v(()=>p("div",{class:"slds-border_bottom slds-p-top_small slds-m-bottom_x-small"},null,-1)),H={class:"clicktocreateform"},K={class:"slds-text-body_regular slds-m-bottom_medium"},z=v(()=>p("div",{id:"clicktocreateform",class:"fieldSetHTML"},null,-1)),Y={class:"slds-p-top_small"},Z={key:0,class:"createrecord2-fieldset-errors"},ee={class:"slds-grid slds-grid_align-end"},te={class:"slds-col"};function se(e,t,s,i,a,r){const c=b("Spinner"),l=b("Picklist"),n=b("SLDSButton"),d=b("Modal");return f(),R(d,{id:"clickToCreateModal",title:e.$Labels.Click2Create_CreateARecord,labels:{close:e.$Labels.MA_Close},class:"slds-modal-fullscreen-phone js-search-modal-wrapper",onClose:t[2]||(t[2]=o=>e.$emit("close-modal"))},{content:y(()=>[P(g(c,null,null,512),[[V,a.isLoading]]),a.type==="esriLayer"?(f(),S(T,{key:0},[g(l,{modelValue:a.esriTemplateName,"onUpdate:modelValue":t[0]||(t[0]=o=>a.esriTemplateName=o),inputAttrs:{"data-q3-id":"c2c-select-data-layer"},options:a.esriTemplateOptions,labels:{name:e.$Labels.Click2Create_ArcGIS_SelectATemplate},titleKey:"label",idKey:"path",onSelectedOption:r.populateInputsWithEsriTemplateData,onClear:r.clearC2CForm},null,8,["modelValue","options","labels","onSelectedOption","onClear"]),X],64)):A("",!0),p("div",H,[p("div",null,[p("div",K,F(e.$Labels.Log_A_Call_Fill_Fields),1),z])]),p("div",Y,[a.c2cErrors.length?(f(),S("ul",Z,[(f(!0),S(T,null,W(a.c2cErrors,(o,u)=>(f(),S("li",{key:u},F(o),1))),128))])):A("",!0)])]),footer:y(()=>[p("div",ee,[p("div",te,[g(n,{"data-q3-id":"c2c-close-button",disabled:a.isLoading,class:"slds-button slds-button_neutral",onClick:t[1]||(t[1]=o=>e.$emit("close-modal"))},{default:y(()=>[L(F(e.$Labels.MA_Cancel),1)]),_:1},8,["disabled"]),g(n,{"data-q3-id":"c2c-finish-button",disabled:a.isLoading,class:"slds-button slds-button_brand",onClick:r.handleSaveForm},{default:y(()=>[L(F(e.$Labels.MA_Finish),1)]),_:1},8,["disabled","onClick"])])])]),_:1},8,["title","labels"])}const ce=D(U,[["render",se],["__scopeId","data-v-bcea6a8d"]]);export{ce as default};