import{bq as U,f as C,ac as P,X as N,b2 as E,Q as A,_ as T,S as $,l as I,P as q,a5 as F,r as _,o as O,b as L,w as b,e as v,h as n,t as h,i,j as k}from"../bundle.js";import{M as B}from"./Modal.76578f76.js";const D=s=>new Promise((e,a)=>{U({onError:l=>{console.warn("error",l),a(l)}}).then(l=>{const{layerMap:t,chunkSize:d}=s;l.addListener("processedFeatures",u=>{l.terminate(),e(u)}),l.sendQuery("processRecords",{batchSize:d,layerMap:JSON.parse(JSON.stringify(t))})})}),J=s=>{const e=C(),{chunks:a,ownerId:l,transferAttachments:t,transferEvents:d,transferNotes:u,transferTasks:f}=s;let r=a.length||0,m=0,p=0;const o=P();let g=[];a.forEach(c=>{g=[...g,...c]});const y=async c=>{const{success:w,results:S}=await MAPS.Utils.Apex.invoke("maps.RemoteFunctions.processAJAXRequest",[c]);r-=1,w&&S.forEach(M=>{M.success?m+=1:p+=1});const R=e.toasts.find(M=>M.id===o);R.subMessage=A(MAPS.app.config.globalProperties.$Labels.Chatter_Updating_Batches_Remaining,[r])},V=new N({maxConcurrency:6,workers:a.map(c=>y.bind(globalThis,{ajaxResource:"TooltipAJAXResources",ownerId:l,action:"change_owner",transferAttachments:t,transferEvents:d,transferNotes:u,transferTasks:f,serializedRecordIds:JSON.stringify(c)})),done:async()=>{await E.queueDmlSymbologyUpdates({recordIds:g,toastId:o});const c=p>0?"warning":"success",w=e.toasts.findIndex(S=>S.id===o);e.toasts.splice(w,1),e.toast({message:MAPS.app.config.globalProperties.$Labels.Change_Owner_Results,subMessage:A(MAPS.app.config.globalProperties.$Labels.Change_Owner_Records_Updated,[m,p]),state:c,duration:5e3})}});e.toast({message:MAPS.app.config.globalProperties.$Labels.Change_Owner_Status,subMessage:MAPS.app.config.globalProperties.$Labels.Change_Owner_Updating_Records,state:"info",position:"bottom-right",duration:0,id:o}),V.start()},z={components:{Modal:B,Spinner:$,SLDSButton:I,Picklist:q,Checkbox:F},props:{modalOptions:{type:Object,required:!0}},emits:["close-modal"],setup(){return{mainStore:C()}},data(){return{loading:!1,recordsAreValid:!1,newOwner:"",defaultSubordinates:!1,foundUsers:[],notes:!0,attachments:!0,tasks:!0,futureEvents:!0,getUsers:[{options:async s=>{const e={ajaxResource:"TooltipAJAXResources",subordinatesOnly:this.defaultSubordinates,action:"get_users",searchTerm:s};this.isLoading=!0;const a=await MAPS.Utils.Apex.invoke("maps.RemoteFunctions.processAJAXRequest",[e]),{success:l=!1,users:t=[]}=a;return this.isLoading=!1,l?t:[]}}]}},async created(){const{chunks:s,recordLayerMap:e}=await D({layerMap:this.modalOptions,chunkSize:this.mainStore?.settings?.general?.MassFieldUpdateScopeSize});s.length===0?(this.mainStore.toast({message:this.$Labels.Change_Owner_Cannot_Change_Owner,subMessage:this.$Labels.Change_Owner_No_Records_Found,state:"warning",duration:5e3}),this.$nextTick(()=>{this.close()})):(this.chunks=s,this.recordLayerMap=e,this.recordsAreValid=!0,this.defaultSubordinates=this.mainStore?.settings?.general?.showOnlySubordinates||!1)},methods:{close(){this.$emit("close-modal")},clearOptions(){this.notes=!0,this.attachments=!0,this.tasks=!0,this.futureEvents=!0},updateOwner(){J({chunks:this.chunks,recordLayerMap:this.recordLayerMap,ownerId:this.newOwner,transferAttachments:this.attachments,transferEvents:this.futureEvents,transferNotes:this.notes,transferTasks:this.tasks}),this.close()}}},X={id:"step1"},j={class:"slds-p-left_medium"},Q={class:"slds-text-title_caps"},x={class:"slds-grid slds-p-left_medium"},K={class:"slds-col slds-p-top_small"},G={class:"slds-col slds-m-top_small slds-p-top_large slds-p-left_medium"},W={id:"step2",class:"slds-m-top_medium"},H={class:"slds-p-around_medium"},Y={class:"slds-text-title_caps"},Z={class:"slds-m-top_small"},ee={class:"slds-form-element__legend slds-form-element__label"},se={class:"slds-form-element"},te={class:"slds-form-element__control"},oe={class:"slds-form-element"},ne={class:"slds-form-element__control"},le={class:"slds-form-element"},ae={class:"slds-form-element__control"},re={class:"slds-form-element"},ie={class:"slds-form-element__control"};function de(s,e,a,l,t,d){const u=_("Spinner"),f=_("Picklist"),r=_("Checkbox"),m=_("SLDSButton"),p=_("Modal");return t.recordsAreValid?(O(),L(p,{key:0,id:"changeOwnerModal",title:s.$Labels.ActionFramework_Change_Owner,labels:{close:s.$Labels.MA_Close},onClose:e[9]||(e[9]=o=>s.$emit("close-modal"))},{content:b(()=>[t.loading?(O(),L(u,{key:0,loadingLabel:s.$Labels.MA_Loading},null,8,["loadingLabel"])):v("",!0),n("div",X,[n("div",j,[n("h4",Q,h(s.$Labels.MA_Step_1_Select_New_Owner),1)]),n("div",x,[n("div",K,[i(f,{modelValue:t.newOwner,"onUpdate:modelValue":e[0]||(e[0]=o=>t.newOwner=o),required:!0,idKey:"Id",titleKey:"Name",filterable:"",labels:{name:s.$Labels.MA_Name},options:t.getUsers,onChanged:d.clearOptions,onClear:d.clearOptions},null,8,["modelValue","labels","options","onChanged","onClear"])]),n("div",G,[i(r,{modelValue:t.defaultSubordinates,"onUpdate:modelValue":e[1]||(e[1]=o=>t.defaultSubordinates=o),labels:{name:s.$Labels.MA_Show_Only_Subordinates},onChanged:e[2]||(e[2]=o=>t.getUsers())},null,8,["modelValue","labels"])])])]),n("div",W,[n("div",H,[n("h4",Y,h(s.$Labels.MA_Step_2_Transfer_Options),1),n("div",Z,[n("div",null,[n("h4",ee,h(s.$Labels.MA_Related_items_transfer),1),n("div",se,[n("div",te,[i(r,{modelValue:t.notes,"onUpdate:modelValue":e[3]||(e[3]=o=>t.notes=o),labels:{name:s.$Labels.MA_Notes},disabled:t.newOwner===""},null,8,["modelValue","labels","disabled"])])]),n("div",oe,[n("div",ne,[i(r,{modelValue:t.attachments,"onUpdate:modelValue":e[4]||(e[4]=o=>t.attachments=o),labels:{name:s.$Labels.MA_Attachments},disabled:t.newOwner===""},null,8,["modelValue","labels","disabled"])])]),n("div",le,[n("div",ae,[i(r,{modelValue:t.tasks,"onUpdate:modelValue":e[5]||(e[5]=o=>t.tasks=o),labels:{name:s.$Labels.MA_Open_Tasks},disabled:t.newOwner===""},null,8,["modelValue","labels","disabled"])])]),n("div",re,[n("div",ie,[i(r,{modelValue:t.futureEvents,"onUpdate:modelValue":e[6]||(e[6]=o=>t.futureEvents=o),labels:{name:s.$Labels.MA_Future_Events},disabled:t.newOwner===""},null,8,["modelValue","labels","disabled"])])])])])])])]),footer:b(()=>[i(m,{variant:"neutral",onClick:e[7]||(e[7]=o=>s.$emit("close-modal"))},{default:b(()=>[k(h(s.$Labels.MA_Cancel),1)]),_:1}),i(m,{class:"slds-button_brand",onClick:e[8]||(e[8]=o=>d.updateOwner())},{default:b(()=>[k(h(s.$Labels.MA_Save_Close),1)]),_:1})]),_:1},8,["title","labels"])):v("",!0)}const me=T(z,[["render",de]]);export{me as default};