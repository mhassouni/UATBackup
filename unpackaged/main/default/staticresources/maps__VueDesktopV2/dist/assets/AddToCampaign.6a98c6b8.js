import{_ as w,S as k,l as y,P,O as T,a5 as D,f as R,Q as O,br as $,r as m,o as n,b as u,w as d,e as c,c as _,h as p,t as r,i as h,s as I,v as N,j as S}from"../bundle.js";import{M as V}from"./Modal.76578f76.js";import{D as x}from"./DataTable.354d08d2.js";const B={components:{Modal:V,Spinner:k,SLDSButton:y,DataTable:x,Picklist:P,TextInput:T,Checkbox:D},props:{modalOptions:{type:Object,required:!0}},emits:["close-modal"],setup(){return{mainStore:R()}},data(){return{recordsAreValid:!0,loading:!1,currentStep:"step1",searchTerm:"",columns:[{id:"1",name:MAPS.app.config.globalProperties.$Labels.MA_Name,sortColumn:null,sortDir:null,sortable:!1},{id:"2",name:MAPS.app.config.globalProperties.$Labels.MA_Type,sortColumn:null,sortDir:null,sortable:!1},{id:"3",name:MAPS.app.config.globalProperties.$Labels.MA_Status,sortColumn:null,sortDir:null,sortable:!1},{id:"4",name:MAPS.app.config.globalProperties.$Labels.MA_Start_Date,sortColumn:null,sortDir:null,sortable:!1},{id:"5",name:MAPS.app.config.globalProperties.$Labels.MA_End_Date,sortColumn:null,sortDir:null,sortable:!1},{id:"6",name:`# ${MAPS.app.config.globalProperties.$Labels.MA_Lead}`,sortColumn:null,sortDir:null,sortable:!1},{id:"7",name:`# ${MAPS.app.config.globalProperties.$Labels.MA_Contact}`,sortColumn:null,sortDir:null,sortable:!1},{id:"8",name:`# ${MAPS.app.config.globalProperties.$Labels.MA_Responses}`,sortColumn:null,sortDir:null,sortable:!1}],optionsColumns:[{id:"1",name:MAPS.app.config.globalProperties.$Labels.MA_Name,sortColumn:null,sortDir:null,sortable:!1},{id:"2",name:MAPS.app.config.globalProperties.$Labels.MA_Member_Status,sortColumn:null,sortDir:null,sortable:!1},{id:"3",name:MAPS.app.config.globalProperties.$Labels.MA_Override_Status,sortColumn:null,sortDir:null,sortable:!1}],campaignAnchorMap:new Map,rows:[],optionsRows:[],selectedCampaigns:new Map,campaignSearchIsLoading:!1,debounceSearch:null}},methods:{formatLabel:O,close(){this.$emit("close-modal")},handleSelectedCampaign(e){const{row:s}=e;if(s.selected){this.selectedCampaigns.set(s.id,{id:s.id,memberStatus:"Sent",overrideStatus:!1});return}this.selectedCampaigns.has(s.id)&&this.selectedCampaigns.delete(s.id)},handleSelectAll(){this.rows.forEach(e=>{this.handleSelectedCampaign({row:e})})},addToCampaign(){const{recordIds:e}=this.modalOptions,s=[];this.optionsRows.forEach(t=>{const{name:l}=t.data[1].options[t.data[1].value-1],o=t.data[2].value;s.push({id:t.id,memberStatus:l,overrideStatus:o})}),$({campaignRows:s,recordIds:e,batchSize:this.mainStore?.settings?.general?.MassFieldUpdateScopeSize||200}),this.close()},clearToCampaign(){this.selectedCampaigns.clear(),this.rows=this.rows.map(e=>({...e,selected:!1})),this.currentStep="step1"},toStep2(){if(this.selectedCampaigns.size===0){this.mainStore.toast({message:MAPS.app.config.globalProperties.$Labels.Campaing_Status,subMessage:MAPS.app.config.globalProperties.$Labels.Campaing_Select_One_Or_More,state:"warning",position:"bottom-right",duration:5e3});return}this.currentStep="step2",this.getCampaignStatuses()},toStep1(){this.currentStep="step1",this.optionsRows.splice(0)},formatRowData(e){const s=[];return e.forEach(t=>{const l={type:"custom",subType:"anchor",label:t.Name,value:t.Id};this.campaignAnchorMap.set(t.Id,l),s.push({id:t.Id,data:[l,t.Type,t.Status,t.StartDate,t.EndDate,t.NumberOfLeads,t.NumberOfContacts,t.NumberOfResponses],selected:this.selectedCampaigns.has(t.Id)})}),s},getCampaigns(){this.debounceSearch&&clearTimeout(this.debounceSearch),this.campaignSearchIsLoading=!0,this.debounceSearch=setTimeout(async()=>{try{const e={action:"searchObjectForName",ajaxResource:"TooltipAJAXResources",fieldsToReturn:"Id, Name, Type, Status, IsActive, StartDate, EndDate, NumberOfLeads, NumberOfContacts, NumberOfResponses",searchTerm:this.searchTerm,sf_object:"Campaign"},{success:s,data:t}=await MAPS.Utils.Apex.invoke("maps.RemoteFunctions.processAJAXRequest",[e]);s?this.rows=this.formatRowData(t):(this.rows.splice(0),this.campaignAnchorMap.clear())}catch(e){console.warn("unable to find campaigns",e),this.rows=[]}finally{this.campaignSearchIsLoading=!1}},300)},async getCampaignStatuses(){this.loading=!0;const e={ajaxResource:"TooltipAJAXResources",action:"get_campaign_statuses",serializedCampaignIds:JSON.stringify(this.rows.filter(l=>l.selected===!0).map(l=>l.id))},{success:s,campaignStatuses:t}=await MAPS.Utils.Apex.invoke("maps.RemoteFunctions.processAJAXRequest",[e]);s&&Object.keys(t).forEach(l=>{const o=t[l],i=[];o.forEach((g,f)=>{i.push({id:f+1,name:g})}),this.optionsRows.push({id:l,data:[this.campaignAnchorMap.get(l),{type:"custom",value:1,options:i},{type:"custom",value:!1}]})}),this.loading=!1}}},E={key:1,id:"step1"},q={class:"slds-p-left_medium"},z={class:"slds-text-title_caps"},U={class:"slds-grid slds-p-left_medium"},j={class:"slds-col slds-p-top_small slds-p-right_medium"},F={"data-id-q3":"addCampaignClearSelection",class:"slds-col slds-p-top_small slds-p-left_medium slds-grid slds-grid_vertical-align-start"},J={class:"slds-m-right_xx-small"},X=["href"],K={key:2,id:"step2"},Q={class:"slds-p-left_medium"},G={class:"slds-text-title_caps"},H=["href"];function W(e,s,t,l,o,i){const g=m("Spinner"),f=m("TextInput"),b=m("SLDSButton"),C=m("DataTable"),M=m("Picklist"),L=m("Checkbox"),v=m("Modal");return o.recordsAreValid?(n(),u(v,{key:0,id:"changeOwnerModal",title:e.$Labels.ActionFramework_Add_to_Campaign,labels:{close:e.$Labels.MA_Close},onClose:s[4]||(s[4]=a=>e.$emit("close-modal"))},{content:d(()=>[o.loading?(n(),u(g,{key:0,loadingLabel:e.$Labels.MA_Loading},null,8,["loadingLabel"])):c("",!0),o.currentStep==="step1"?(n(),_("div",E,[p("div",q,[p("h4",z,r(e.$Labels.MA_Step_1_Select_Campaigns),1)]),p("div",U,[p("div",j,[h(f,{modelValue:o.searchTerm,"onUpdate:modelValue":s[0]||(s[0]=a=>o.searchTerm=a),inputAttrs:{"data-q3-id":"acSearchInputResource"},class:"slds-input-has-icon slds-input-has-icon_right",required:!0,labels:{name:e.$Labels.MA_Name},onInput:i.getCampaigns},{extend:d(()=>[o.campaignSearchIsLoading?(n(),u(g,{key:0,class:"slds-input__icon",size:"x-small",theme:"brand",withoutContainer:""})):c("",!0)]),_:1},8,["modelValue","labels","onInput"])])]),p("div",F,[p("div",J,r(i.formatLabel(e.$Labels.Layers_Markers_Selected,[o.selectedCampaigns.size])),1),h(b,{label:e.$Labels.MA_Clear_Selections,variant:"base",style:{"font-size":"12px",height:"20px"},onClick:s[1]||(s[1]=a=>i.clearToCampaign())},null,8,["label"])]),h(C,{ref:"dataTable",class:"slds-m-top_small slds-p-left_medium slds-p-right_medium",columns:o.columns,rows:o.rows,multiselectable:"",columnsBordered:"",onSelectRow:i.handleSelectedCampaign,onSelectAll:i.handleSelectAll},{cell:d(a=>[a.data.subType==="anchor"?(n(),_("a",{key:0,class:"slds-button",href:`/${a.data.value}`,target:"_blank"},r(a.data.label),9,X)):c("",!0)]),_:1},8,["columns","rows","onSelectRow","onSelectAll"]),I(p("div",{class:"slds-p-vertical_x-small slds-m-horizontal_medium slds-border_bottom"},r(e.$Labels.MA_SearchAboveEllipsis),513),[[N,o.rows.length===0]])])):(n(),_("div",K,[p("div",Q,[p("h4",G,r(e.$Labels.MA_Step_2_Options),1)]),h(C,{ref:"dataTable",class:"slds-m-top_small slds-p-left_medium slds-p-right_medium",columns:o.optionsColumns,rows:o.optionsRows,columnsBordered:""},{cell:d(a=>[a.data.subType==="anchor"?(n(),_("a",{key:0,class:"slds-button",href:`/${a.data.value}`,target:"_blank"},r(a.data.label),9,H)):Array.isArray(a.data.options)?(n(),u(M,{key:1,id:a.data.key,modelValue:a.data.value,"onUpdate:modelValue":A=>a.data.value=A,idKey:"id",titleKey:"name",options:a.data.options},null,8,["id","modelValue","onUpdate:modelValue","options"])):c("",!0),typeof a.data.value=="boolean"?(n(),u(L,{key:2,modelValue:a.data.value,"onUpdate:modelValue":A=>a.data.value=A,hideLabel:""},null,8,["modelValue","onUpdate:modelValue"])):c("",!0)]),_:1},8,["columns","rows"])]))]),footer:d(()=>[h(b,{id:"cancel",class:"slds-button",variant:"neutral",onClick:s[2]||(s[2]=a=>e.$emit("close-modal"))},{default:d(()=>[S(r(e.$Labels.MA_Cancel),1)]),_:1}),o.currentStep==="step1"?(n(),u(b,{key:0,class:"slds-button slds-button_brand",onClick:i.toStep2},{default:d(()=>[S(r(e.$Labels.MA_Next),1)]),_:1},8,["onClick"])):c("",!0),o.currentStep==="step2"?(n(),u(b,{key:1,class:"slds-button slds-button_brand",onClick:i.toStep1},{default:d(()=>[S(r(e.$Labels.MA_Back),1)]),_:1},8,["onClick"])):c("",!0),o.currentStep==="step2"?(n(),u(b,{key:2,class:"slds-button slds-button_brand",onClick:s[3]||(s[3]=a=>i.addToCampaign())},{default:d(()=>[S(r(e.$Labels.MA_Add_Close),1)]),_:1})):c("",!0)]),_:1},8,["title","labels"])):c("",!0)}const se=w(B,[["render",W]]);export{se as default};