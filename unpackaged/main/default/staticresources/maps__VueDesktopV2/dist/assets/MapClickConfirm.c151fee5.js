import{_ as C,I as f,l as h,B as g,f as v,aV as _,aW as y,aX as M,aY as k,r as l,o as S,c as B,i as t,a6 as L,h as s,t as a,w as p,j as m}from"../bundle.js";const A={components:{Icon:f,SLDSButton:h,ButtonIcon:g},setup(){return{mainStore:v()}},methods:{abortMapClick(){_()},async createRecord(){MAPS.c2cSketch.complete();const n=MAPS.view.map.findLayerById("c2cDropPin")?.graphics?.items[0],{qid:c,geometry:d}=n,o=await y();o.objectFieldSetMap.size===0?this.mainStore.toast({message:MAPS.app.config.globalProperties.$Labels.Drop_Pin_Ask_Admin_For_C2C,state:"warning"}):(o.features=await M({qid:c,geometry:d}),k(o),this.$bus.emit("displayMapClickConfirm",!1)),_()}}},I={"aria-describedby":"dialog-body-id-326","aria-labelledby":"dialog-heading-id-5",class:"slds-popover slds-popover_prompt slds-popover_prompt_top",role:"dialog"},$={id:"dialog-body-id-326",class:"slds-popover__body"},D={class:"slds-media"},w={class:"slds-media__body"},P={class:"slds-media"},R={class:"slds-media__body slds-m-left--small"},N={id:"dialog-heading-id-5",class:"slds-popover_prompt__heading"},T={class:"slds-popover__footer"},V={class:"slds-grid slds-grid_vertical-align-center"};function j(e,n,c,d,o,i){const b=l("ButtonIcon"),u=l("Icon"),r=l("SLDSButton");return S(),B("section",I,[t(b,{ref:"closeButton",variant:"bare",title:e.$Labels.MA_Close,class:"slds-float_right slds-popover__close",iconCategory:"utility",size:"small",iconName:"close",assistiveText:e.$Labels.MA_Close,onClick:L(i.abortMapClick,["stop"])},null,8,["title","assistiveText","onClick"]),s("div",$,[s("div",D,[s("div",w,[s("div",P,[t(u,{category:"utility",assistiveText:"info",size:"small",name:"info",variant:"default"}),s("div",R,[s("h2",N,a(e.$Labels.MA_Create_Rec_Map),1),s("p",null,a(e.$Labels.MA_Create_Rec_Map_Drag_Info),1)])])])])]),s("footer",T,[s("div",V,[t(r,{class:"slds-button slds-button_neutral slds-col_bump-right",onClick:i.abortMapClick},{default:p(()=>[m(a(e.$Labels.MA_Cancel),1)]),_:1},8,["onClick"]),t(r,{class:"slds-button slds-button_brand",onClick:i.createRecord},{default:p(()=>[m(a(e.$Labels.MA_Create_Record),1)]),_:1},8,["onClick"])])])])}const F=C(A,[["render",j]]);export{F as default};