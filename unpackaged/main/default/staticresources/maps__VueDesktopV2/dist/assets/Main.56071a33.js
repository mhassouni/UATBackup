import{_ as M,d as k,a as p,S as h,$ as B,Z as x,l as H,f as I,g as V,b6 as c,y as C,b7 as R,W as b,r as g,o as P,b as E,w as d,h as m,s as F,v as U,i as a,a0 as A,t as S,j as y}from"../bundle.js";import{u as O}from"./index.d251dbc7.js";import{M as N}from"./Modal.76578f76.js";const z=k({loader:()=>p(()=>import("./General.802bf507.js"),[MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/General.802bf507.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "bundle.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/main.feeda730.css" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/index.0172543b.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/index.d251dbc7.js" })],import.meta.url),loadingComponent:h}),W=k({loader:()=>p(()=>import("./RoutesSchedule.fab6bce5.js"),[MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/RoutesSchedule.fab6bce5.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "bundle.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/main.feeda730.css" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/TimePicker.bfa4e2f9.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/RoutesSchedule.ec812b15.css" })],import.meta.url),loadingComponent:h}),j=k({loader:()=>p(()=>import("./ListSettings.cd859c35.js"),[MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/ListSettings.cd859c35.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/vuedraggable.umd.c7e4adc2.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "bundle.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/main.feeda730.css" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/ListSettings.2da0a139.css" })],import.meta.url),loadingComponent:h}),G=k({loader:()=>p(()=>import("./DataSources.96f78be8.js"),[MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/DataSources.96f78be8.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "bundle.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/main.feeda730.css" })],import.meta.url),loadingComponent:h}),q={name:"SettingsMain",components:{Modal:N,Spinner:h,Tabs:B,Tab:x,General:z,RoutesSchedule:W,ListSettings:j,DataSources:G,SLDSButton:H},props:{modalOptions:{type:Object,default:()=>{}}},emits:["close-modal"],setup(){const e=I(),t=V();return{mainStore:e,layersStore:t}},data(){return{v$:O(),originalInvertProximityValue:!1,routesInvalid:!1,isLoading:!1,activeTabId:this.$props.modalOptions.activeTabId||"generalTab",proximitySettings:{defaultProximityType:{value:"Circle",unlocked:!0},circleRadius:{value:"50",unlocked:!0},circleRadiusUnits:{value:"MILES",unlocked:!0},radius:{value:"50",unlocked:!0},travelDistanceRadius:{value:"50",unlocked:!0},travelDistanceRadiusUnits:{value:"MILES",unlocked:!0},travelTimeRadiusMinutes:{value:"0",unlocked:!0},travelTimeRadiusHours:{value:"0",unlocked:!0},unit:{value:"MILES",unlocked:!0}},workingHours:{sunday:{start:{hours:9,minutes:0},end:{hours:17,minutes:0},overnight:!1,unlocked:!0,workingDay:!1},monday:{start:{hours:9,minutes:0},end:{hours:17,minutes:0},overnight:!1,unlocked:!0,workingDay:!0},tuesday:{start:{hours:9,minutes:0},end:{hours:17,minutes:0},overnight:!1,unlocked:!0,workingDay:!0},wednesday:{start:{hours:9,minutes:0},end:{hours:17,minutes:0},overnight:!1,unlocked:!0,workingDay:!0},thursday:{start:{hours:9,minutes:0},end:{hours:17,minutes:0},overnight:!1,unlocked:!0,workingDay:!0},friday:{start:{hours:9,minutes:0},end:{hours:17,minutes:0},overnight:!1,unlocked:!0,workingDay:!0},saturday:{start:{hours:9,minutes:0},end:{hours:17,minutes:0},overnight:!1,unlocked:!0,workingDay:!1}},routeSettings:{mode:{value:"driving",unlocked:!0},driveProfile:{value:"driving",unlocked:!0},optimizationType:{value:"fastest shift completion",unlocked:!0},unit:{value:"mi",unlocked:!0},startLocation:{id:"",label:"",unlocked:!0},startLocationId:{value:"",unlocked:!0},startLocationLabel:{value:"",unlocked:!0},endLocationId:{value:"",unlocked:!0},endLocationLabel:{value:"",unlocked:!0},endLocation:{id:"",label:"",unlocked:!0},type:{value:"Standard",unlocked:!0},duration:{value:"0 hr, 30 min",unlocked:!0},displayTrafficTime:!0,enabledDuplicateStops:!0,enableCurrentLocationTime:!0,enableDraggableWaypoints:!1},floatingBreak:{enabled:{unlocked:!0,value:!1},start:{hours:11,minutes:0},end:{hours:12,minutes:0},overnight:!1,unlocked:!0,workingDay:!0},listView:{selected:[],available:[],unlocked:!0}}},computed:{version(){return this.$Labels.MapSettings_Version.replace("{0}",MAPS.version)},saveInvalid(){return this.v$.$invalid}},created(){this.buildSettingsFromStore()},methods:{openLink(e){window.open(e,"_blank")},createStoreDataFromFloatinBreak(){return this.floatingBreak?.enabled?.value||(this.floatingBreak.end={hours:12,minutes:0},this.floatingBreak.start={hours:11,minutes:0},this.floatingBreak.overnight=!1),{startTime:c({hour:this.floatingBreak.start.hours,minute:this.floatingBreak.start.minutes,hour12:!0}),endTime:c({hour:this.floatingBreak.end.hours,minute:this.floatingBreak.end.minutes,hour12:!0}),startHour:this.floatingBreak.start.hours,startMinute:this.floatingBreak.start.minutes,endHour:this.floatingBreak.end.hours,endMinute:this.floatingBreak.end.minutes,overnight:this.floatingBreak.overnight,workingDay:this.floatingBreak.workingDay,unlocked:this.floatingBreak.unlocked,enabled:this.floatingBreak.enabled}},createStoreDataFromWorkingHours(){const e=Object.keys(this.workingHours),t={};return e.forEach(o=>{const s=this.workingHours[o];t[o]={endHour:s.end.hours,endMinute:s.end.minutes,endTime:c({hour:s.end.hours,minute:s.end.minutes,hour12:!0}),overnight:s.overnight,startHour:s.start.hours,startMinute:s.start.minutes,startTime:c({hour:s.start.hours,minute:s.start.minutes,hour12:!0}),unlocked:s.unlocked,workingDay:s.workingDay}}),t},async save(){this.isLoading=!0;try{const e=this.buildForSaveSettings(),t=await C.save(e);if(t.success){this.mainStore.settings.routes=this.routeSettings,this.mainStore.settings.proximitySettings=this.proximitySettings;const o=this.createStoreDataFromWorkingHours();this.mainStore.settings.workingHours=o;const{monday:s={}}=o;this.mainStore.settings.routes.start=c({hour:s.startHour,minute:s.startMinute,hour12:!0}),this.mainStore.settings.routes.end=c({hour:s.endHour,minute:s.endMinute,hour12:!0}),this.mainStore.settings.floatingBreak=this.createStoreDataFromFloatinBreak(),this.mainStore.settings.listView.columns.selected=e.listViewColumns,this.mainStore.settings.routes.startLocationId.value=this.routeSettings.startLocation.id,this.mainStore.settings.routes.startLocationLabel.value=this.routeSettings.startLocation.label,this.mainStore.settings.routes.endLocationId.value=this.routeSettings.endLocation.id,this.mainStore.settings.routes.endLocationLabel.value=this.routeSettings.endLocation.label,this.mainStore.toast({message:this.$Labels.MA_Success,state:"success"}),this.originalInvertProximityValue!==this.proximitySettings.invertProximity.value&&this.layersStore.proximityActivatedLayers.size!==0&&await R(),this.$emit("close-modal")}else this.mainStore.toast({message:"Unable to save settings.",state:"error",duration:null}),console.error("Save Setting Error",t)}catch{this.mainStore.toast({message:"Unable to save settings.",state:"error",duration:null})}finally{this.isLoading=!1}},createWorkingHoursFromSavedData(e){const t=Object.keys(e),o={};return t.forEach(s=>{const i=e[s];o[s]={unlocked:i.unlocked,overnight:i.overnight,workingDay:i.workingDay,start:{hours:i.startHour,minutes:i.startMinute},end:{hours:i.endHour,minutes:i.endMinute}}}),o},createFloatingBreakFromSavedData(e){return{enabled:e.enabled,unlocked:e.unlocked,overnight:e.overnight,workingDay:e.workingDay,start:{hours:e.startHour,minutes:e.startMinute},end:{hours:e.endHour,minutes:e.endMinute}}},buildSettingsFromStore(){const{settings:e={}}=this.mainStore,t=JSON.parse(JSON.stringify(e));this.proximitySettings={...this.proximitySettings,...t.proximitySettings},this.originalInvertProximityValue=t.proximitySettings.invertProximity.value,this.routeSettings={...this.routeSettings,...t.routes},this.routeSettings.startLocation={id:this.routeSettings?.startLocationId?.value||"",label:this.routeSettings?.startLocationLabel?.value||"",unlocked:this.routeSettings?.startLocationId?.unlocked??!0},this.routeSettings.endLocation={id:this.routeSettings?.endLocationId?.value||"",label:this.routeSettings?.endLocationLabel?.value||"",unlocked:this.routeSettings?.endLocationId?.unlocked??!0};const o=this.createWorkingHoursFromSavedData(t.workingHours);this.workingHours={...this.workingHours,...o};const s=this.createFloatingBreakFromSavedData(t.floatingBreak);this.floatingBreak={...this.floatingBreak,...s};const i=t.listView,{columns:r={}}=i;let u;r?.selected?.visible?u=b(r?.selected.visible):u=b(r?.selected),this.listView.available=u.available,this.listView.selected=u.selected,this.listView.unlocked=r.unlocked??!1},buildForSaveSettings(){const e=new Map;e.set("DefaultProximityType",this.proximitySettings?.defaultProximityType?.value||"Circle"),e.set("circleRadius",this.proximitySettings?.circleRadius?.value||"50"),e.set("circleRadiusUnits",this.proximitySettings?.circleRadiusUnits?.value||"MILES"),e.set("radius",this.proximitySettings?.radius?.value||"50"),e.set("travelDistanceRadius",this.proximitySettings?.travelDistanceRadius?.value||"50"),e.set("travelDistanceRadiusUnits",this.proximitySettings?.travelDistanceRadiusUnits?.value||"MILES"),e.set("travelTimeRadiusHours",this.proximitySettings?.travelTimeRadiusHours?.value||""),e.set("travelTimeRadiusMinutes",this.proximitySettings?.travelTimeRadiusMinutes?.value||""),e.set("unit",this.proximitySettings?.units?.value||"MILES");const t=new Map;t.set("mode",this.routeSettings?.mode?.value||"driving"),t.set("driveProfile",this.routeSettings?.mode?.value||"driving"),t.set("optimizationType",this.routeSettings?.optimizationType?.value||"fastest shift completion"),t.set("unit",this.routeSettings?.units?.value||"mi"),t.set("startLocationId",this.routeSettings?.startLocation?.label?this.routeSettings?.startLocation?.id:""),t.set("startLocationLabel",this.routeSettings?.startLocation?.label||""),t.set("endLocationId",this.routeSettings?.endLocation?.label?this.routeSettings?.endLocation?.id:""),t.set("endLocationLabel",this.routeSettings?.endLocation?.label||""),t.set("type",this.routeSettings?.type?.value||"Standard"),t.set("duration",this.routeSettings?.duration?.value||"0 hr, 30 min"),t.set("displayTrafficTime",this.routeSettings?.displayTrafficTime?.value??!0),t.set("enabledDuplicateStops",this.routeSettings?.enabledDuplicateStops?.value??!1),t.set("enableCurrentLocationTime",this.routeSettings?.enableCurrentLocationTime?.value??!0),t.set("enableDraggableWaypoints",!1);const o=new Map;o.set("enabled",this.floatingBreak?.enabled?.value??!1),o.set("endHour",this.floatingBreak?.end?.hours||12),o.set("endMinute",this.floatingBreak?.end?.minutes||0),o.set("startHour",this.floatingBreak?.start?.hours||11),o.set("startMinute",this.floatingBreak?.start?.minutes||0);const s=["monday","tuesday","wednesday","thursday","friday","saturday","sunday"],i=new Map;s.forEach(u=>{const l=this.workingHours[u];i.set(u,{startHour:Number(l.start.hours||9),startMinute:Number(l.start.minutes||0),endHour:Number(l.end.hours||17),endMinute:Number(l.end.minutes||0),overnight:l.overnight,workingDay:l.workingDay})});const r={};return this.listView.selected.forEach((u,l)=>{r[l]={id:u.id}}),{invertProximity:this.proximitySettings?.invertProximity?.value??!1,proximitySettings:e,routeSettings:t,floatingBreak:o,workingHours:i,listViewColumns:r}},updateListView(e){this.selectedListViewColumns=e}}},$={id:"settings-tabs",style:{height:"100%"}},J={class:"slds-grid slds-grid_vertical-align-center"},Z={class:"slds-p-horizontal_xx-small"},K={class:"slds-col slds-grow-none slds-col_bump-left"},Q={class:"slds-p-horizontal_x-small"},X={class:"slds-col"};function Y(e,t,o,s,i,r){const u=g("Spinner"),l=g("General"),v=g("Tab"),L=g("RoutesSchedule"),_=g("ListSettings"),w=g("DataSources"),D=g("Tabs"),f=g("SLDSButton"),T=g("Modal");return P(),E(T,{id:"maSettings",title:e.$Labels.MapsSetting_Settings,labels:{close:e.$Labels.MA_Close},size:"large",onClose:t[10]||(t[10]=n=>e.$emit("close-modal"))},{content:d(()=>[m("div",$,[F(a(u,null,null,512),[[U,i.isLoading]]),a(D,{modelValue:i.activeTabId,"onUpdate:modelValue":t[7]||(t[7]=n=>i.activeTabId=n),vertical:"",class:"content"},{default:d(()=>[a(v,{id:"generalTab",title:e.$Labels.MapsSetting_General},{default:d(()=>[a(l,{proximitySettings:i.proximitySettings,"onUpdate:proximitySettings":t[0]||(t[0]=n=>i.proximitySettings=n),routeSettings:i.routeSettings,"onUpdate:routeSettings":t[1]||(t[1]=n=>i.routeSettings=n)},null,8,["proximitySettings","routeSettings"])]),_:1},8,["title"]),a(v,{id:"routesScheduleTab",invalid:i.routesInvalid,class:A({invalid:i.routesInvalid}),title:e.$Labels.MapsSetting_Route_Schedule},{default:d(()=>[a(L,{routesInvalid:i.routesInvalid,"onUpdate:routesInvalid":t[2]||(t[2]=n=>i.routesInvalid=n),floatingBreak:i.floatingBreak,"onUpdate:floatingBreak":t[3]||(t[3]=n=>i.floatingBreak=n),routeSettings:i.routeSettings,"onUpdate:routeSettings":t[4]||(t[4]=n=>i.routeSettings=n),workingHours:i.workingHours,"onUpdate:workingHours":t[5]||(t[5]=n=>i.workingHours=n)},null,8,["routesInvalid","floatingBreak","routeSettings","workingHours"])]),_:1},8,["invalid","class","title"]),a(v,{id:"listTab",title:e.$Labels.MA_List},{default:d(()=>[a(_,{listView:i.listView,"onUpdate:listView":t[6]||(t[6]=n=>i.listView=n)},null,8,["listView"])]),_:1},8,["title"]),a(v,{id:"dataSourcesTab",title:e.$Labels.DataSources_Data_Sources},{default:d(()=>[a(w)]),_:1},8,["title"])]),_:1},8,["modelValue"])])]),footer:d(()=>[m("div",J,[m("div",Z,S(r.version),1),m("div",K,[m("div",Q,[a(f,{class:"slds-text-body_small","data-q3-id":"open-documentation-help-link",variant:"base",iconCategory:"utility",iconClass:["slds-button_icon-xx-small"],iconName:"link",iconPosition:"left",onClick:t[8]||(t[8]=n=>r.openLink("https://help.salesforce.com/articleView?id=salesforce_maps_intro.htm&type=5"))},{default:d(()=>[y(S(e.$Labels.MA_Documentation),1)]),_:1})])]),m("div",X,[a(f,{class:"slds-text-body_small","data-q3-id":"userSettingsCancelBtn",onClick:t[9]||(t[9]=n=>e.$emit("close-modal"))},{default:d(()=>[y(S(e.$Labels.MA_Cancel),1)]),_:1}),a(f,{variant:"brand",class:"slds-text-body_small","data-q3-id":"userSettingsSaveBtn",disabled:r.saveInvalid,onClick:r.save},{default:d(()=>[y(S(e.$Labels.MA_Save),1)]),_:1},8,["disabled","onClick"])])])]),_:1},8,["title","labels"])}const st=M(q,[["render",Y],["__scopeId","data-v-31b79020"]]);export{st as default};