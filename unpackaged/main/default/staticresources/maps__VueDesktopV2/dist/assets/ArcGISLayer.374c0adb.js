import{_ as O,H as V,B,J as R,K as G,l as E,a5 as T,g as U,aH as P,aG as N,bk as L,cf as F,r as g,o as c,c as h,h as o,t as _,s as y,v as b,i as p,w as f,F as I,q as S,b as k,c6 as M,e as A,p as D,k as z}from"../bundle.js";const $=async e=>{const s=[],i=e.type==="tile";return e?.parent?.id==="mapTileLayer"?(s.push({active:!0,label:e.title,type:"toggle",id:e.id,uid:e.uid,readOnly:!1,ref:e.id,hasLegend:!1,sublayers:[]}),s):(await MAPS.Utils.Async.forEach(e.sublayers.items,async l=>{l=await l.load();const a=l.legendEnabled;if(l.sublayers){const d={active:l.visible,label:l.title,type:"group",id:l.id,uid:l.uid,ref:l.id,readOnly:i,hasLegend:a,sublayers:[]};l.sublayers.forEach(n=>{d.sublayers.push({active:n.visible,label:n.title,type:"toggle",id:n.id,uid:n.uid,readOnly:i,ref:n.id,hasLegend:n?.legendEnabled||!1})}),s.push(d)}else{const d={active:l.visible,label:l.title,type:l.sublayers?"group":"toggle",id:l.id,uid:l.uid,ref:l.id,readOnly:i,hasLegend:a,sublayers:[]};s.push(d)}}),s)},W=e=>{const s=[],i={active:e.visible,label:e.title,type:"toggle",id:e.id,uid:e.uid,ref:e.id,hasLegend:e.legendEnabled,sublayers:[]};return e.allLayers&&(i.type="group",e.allLayers.forEach(l=>{i.sublayers.push({active:l.visible,label:l.title,type:"toggle",id:l.id,uid:l.uid,ref:l.id,hasLegend:l.legendEnabled,sublayers:[]})})),s.push(i),s},H=e=>{const s=MAPS.view.map.findLayerById(e);return s?.sublayers!==void 0?$(s):W(s)};const{Legend:x,reactiveUtils:J}=await V(["esri/widgets/Legend","esri/core/reactiveUtils"]),j={components:{ButtonIcon:B,ActionMenu:R,ActionMenuItem:G,SLDSButton:E,Checkbox:T},props:{layer:{type:Object,default:()=>{},required:!0}},setup(){return{layersStore:U()}},data(){return{loading:!0,legend:[],loadingMsg:"",errorMessage:"",layerIsVisible:!1,refreshWatcher:null,loadingMoreData:!1}},computed:{layerIcon(){return P().arcgisonline},layerOptions(){const e=[{label:this.$Labels.MA_REFRESH,action:"refresh",types:[]},{label:this.$Labels.MA_Zoom_To_Fit,action:"zoom",types:[]}];return this.layer.type!=="livingAtlas"&&e.unshift({label:this.$Labels.MA_Edit,action:"edit",types:[]}),e}},async created(){await this.loadLayer(),this.layersStore.updateIsLoading(this.layer.qid)},unmounted(){this.removeGraphic()},methods:{async refreshLayer(){this.removeGraphic(),await this.$nextTick(),await this.loadLayer()},removeLayer(){this.layersStore.removePlottedLayer(this.layer.qid)},removeGraphic(){this.refreshWatcher&&this.refreshWatcher.remove(),N.removeTileLayer({id:this.layer.qid}),this.legend=[],L.removeLayer({id:this.layer.qid})},async handleAction(e){e==="zoom"?await F({layerUIDs:[this.layer.qid]}):e==="refresh"?this.refreshLayer():e==="edit"&&this.$bus.emit("open-modal",{name:"save-arcgis",config:{layerId:this.layer.id,isPlotted:!0,callback:async s=>{s.plotOnSave&&this.refreshLayer()}}})},showError(e){this.loading=!1,this.errorMessage=e},findLayerFromUID(e){const s=MAPS.view.map.findLayerById(this.layer.qid);let i;return s?s.findSublayerById?i=s.allSublayers.find(l=>l.uid===e):s.findLayerByUid&&(i=s.findLayerByUid(e)):i=MAPS.view.map.findLayerByUid(this.layer.qid),i||s},async loadLayer(){this.loading=!0,this.loadingMsg="Gathering layer information";let e,s;if(this.layer.type==="livingAtlas")e=this.layer.id,await this.plotLivingAtlasId(e);else if(this.layer.type==="arcgisonline"){const i=await this.getLayerFromSF(this.layer.id);this.layer.name=i.Name||this.layer.name;const l=i?.maps__Options__c?.baseURL;if(s=i?.maps__Options__c?.automaticRefresh||"UseLayerSetting",s==="ForceRefresh"){let n=Number(i?.maps__Options__c?.refreshInterval);console.warn("refresh interval is not a number",n),Number.isNaN(n)&&(n=0),s=n}else s==="NoRefresh"?s=0:s="UseLayerSetting";const a=await L.plotEsriItem({url:l,qid:this.layer.qid,refreshInterval:s,name:this.layer.name},n=>{this.loadingMsg=n}),[d]=a;d.hasErrors?this.showError(d.errorMessage):(await this.createLegend(a),this.attachRefreshInterval())}else this.loading=!1},async plotLivingAtlasId(e){const s=await L.addPortalItem({id:e,qid:this.layer.qid,name:this.layer.name},i=>{this.loadingMsg=i});s.hasErrors?this.showError(s.errorMessage):await this.createLegend([s])},async getLayerFromSF(e){const s={action:"editArcGISWebMapLayer",ajaxResource:"QueryBuilderAPI",recId:e},{success:i,data:l}=await MAPS.Utils.Apex.invoke("maps.RemoteFunctions.processAJAXRequest",[s]);if(i){const[a]=l,d=a.maps__Options__c||"{}",n=a.maps__ArcGISWebMapC2C__c||"[]";try{a.maps__Options__c=JSON.parse(d)}catch(u){console.error(u),a.maps__Options__c=[],this.showError("The selected layer is invalid, some options may be missing.")}try{a.maps__ArcGISWebMapC2C__c=JSON.parse(n)}catch(u){console.error(u),a.maps__ArcGISWebMapC2C__c=[],this.showError("The selected layer has invalid Click2Create templates, some data may be missing.")}return a}throw new Error},async createLegend(){const e=MAPS.view.map.findLayerById(this.layer.qid),s=e?.sublayers!==void 0;this.legend=await H(this.layer.qid),await this.$nextTick(),this.loadingMsg="Building Legend...",await MAPS.Utils.Async.forEachParallel(this.legend,async i=>{if(i.hasLegend){const l=i.id;let a;s?a=[{layer:e,sublayerIds:[l]}]:a=[{layer:e.findLayerById?e.findLayerById(l):e}],i.type==="group"?await MAPS.Utils.Async.forEach(i.sublayers,d=>{s?a=[{layer:e,sublayerIds:[d.id]}]:a=[{layer:e.findLayerById(d.id)}],new x({view:MAPS.view,container:this.$refs[d.ref][0],respectLayerVisibility:!1,layerInfos:a})}):new x({view:MAPS.view,container:this.$refs[i.ref][0],respectLayerVisibility:!1,layerInfos:a})}}),this.loading=!1,this.loadingMsg="",this.layerIsVisible=!0},async attachRefreshInterval(){const e=MAPS.view.map.findLayerById(this.layer.qid),s=await MAPS.view.whenLayerView(e);this.refreshWatcher=J.watch(()=>s.updating,i=>{this.loadingMoreData=i})},toggleVisibility(){this.layerIsVisible=!this.layerIsVisible;const e=MAPS.view.map.allLayers.items.find(i=>i.qid===this.layer.qid);e.visible=this.layerIsVisible;const s=(this.legend||[]).length;for(let i=0;i<s;i++){const l=this.legend[i];if(l.id===this.layer.qid){l.active=e.visible;break}}},hideMarkersInSection(e){const s=this.findLayerFromUID(e);s.visible=!s.visible,this.layer.qid===s?.qid&&(this.layerIsVisible=s.visible)}}},v=e=>(D("data-v-951a2947"),e=e(),z(),e),K={class:"PlottedRowUnit-ArcGISLayer"},Q={class:"slds-grid slds-grid_vertical-align-center slds-p-around_x-small"},X={class:"slds-col slds-grow-none",style:{position:"relative",width:"20px"}},Z={key:0,role:"status",class:"slds-spinner slds-spinner_x-small slds-spinner_brand"},Y={class:"slds-assistive-text"},ee=v(()=>o("div",{class:"slds-spinner__dot-a"},null,-1)),se=v(()=>o("div",{class:"slds-spinner__dot-b"},null,-1)),ie=["src"],le={class:"basicinfo slds-col slds-p-left_x-small slds-col_bump-right slds-size_9-of-12"},ae={class:"slds-text-heading_small slds-truncate","data-q3-id":"mapARCGISLayerName"},te={class:"slds-p-around_x-small slds-border_bottom","data-q3-id":"mapARCGISLayerOptionsHeader"},re={class:"slds-grid slds-grid_vertical slds-border_top"},oe={key:0,class:"slds-grid slds-grid_vertical-align-center slds-p-horizontal_x-small slds-border_bottom"},de=["data-q3-id"],ne=["id","onUpdate:modelValue","aria-labelledby","onClick"],ce=["id","for"],he=v(()=>o("span",{class:"slds-checkbox_faux"},null,-1)),_e={class:"slds-form-element__label slds-assistive-text"},ye={class:"slds-truncate"},pe=["data-q3-id"],ue=["id","onUpdate:modelValue","aria-labelledby","onClick"],ge=["id","for"],be=v(()=>o("span",{class:"slds-checkbox_faux"},null,-1)),fe={class:"slds-form-element__label slds-assistive-text"},ve={class:"slds-truncate"},me={class:"slds-col"},Le={class:"slds-grid slds-grid_vertical"},Ie={key:3,class:"slds-col"},Se={class:"slds-grid slds-grid_vertical"};function we(e,s,i,l,a,d){const n=g("ButtonIcon"),u=g("ActionMenuItem"),C=g("ActionMenu"),w=g("SLDSButton"),q=g("Checkbox");return c(),h("div",K,[o("div",Q,[o("div",X,[a.loading||a.loadingMoreData?(c(),h("div",Z,[o("span",Y,_(e.$Labels.Layers_On_The_Map_Loading),1),ee,se])):(c(),h("img",{key:1,src:d.layerIcon,style:{width:"30px"}},null,8,ie))]),o("div",le,[o("div",ae,_(i.layer.name),1),y(o("div",{class:"slds-text-color_weak"},_(a.loadingMsg),513),[[b,a.loading]]),y(o("div",{class:"slds-text-color_error",style:{overflow:"hidden","text-overflow":"ellipsis"}},_(a.errorMessage),513),[[b,!a.loading&&a.errorMessage]])]),p(n,{"data-q3-id":"mapARCGISLayerVisibilityToggle",iconCategory:"utility",iconName:a.layerIsVisible?"preview":"hide",size:"small",disabled:a.loading||a.errorMessage!=="",title:e.$Labels.Toggle_Layer_Visibility,assistiveText:e.$Labels.Toggle_Layer_Visibility,onClick:d.toggleVisibility},null,8,["iconName","disabled","title","assistiveText","onClick"]),p(C,{disabled:a.loading||a.errorMessage!==""},{button:f(()=>[p(n,{"data-q3-id":"mapARCGISLayerOptionsToggle",iconCategory:"utility",iconName:"threedots_vertical",size:"small",title:e.$Labels.Layer_Options,assistiveText:e.$Labels.Layer_Options},null,8,["title","assistiveText"])]),default:f(()=>[o("div",te,_(e.$Labels.MA_Options),1),(c(!0),h(I,null,S(d.layerOptions,t=>(c(),k(u,{key:t.id,"data-q3-id":`mapARCGISLayerOptions-${t.action}`,label:t.label,onClick:r=>d.handleAction(t.action)},null,8,["data-q3-id","label","onClick"]))),128))]),_:1},8,["disabled"]),p(n,{"data-q3-id":"mapARCGISLayerRemove",iconCategory:"utility",iconName:"close",size:"small",title:e.$Labels.Layers_On_The_Map_Remove_Layer,assistiveText:e.$Labels.Layers_On_The_Map_Remove_Layer,onClick:d.removeLayer},null,8,["title","assistiveText","onClick"])]),o("div",re,[(c(!0),h(I,null,S(a.legend,t=>(c(),h("div",{key:t.uid,class:"slds-col"},[t.hasLegend?(c(),h("div",oe,[t.readOnly?A("",!0):(c(),h("div",{key:0,class:"slds-checkbox slds-p-right_xx-small","data-q3-id":`mapARCGISLayerLegendCheckbox-${t.uid}`},[y(o("input",{id:t.id,"onUpdate:modelValue":r=>t.active=r,"aria-labelledby":t.label,type:"checkbox",onClick:r=>{d.hideMarkersInSection(t.uid)}},null,8,ne),[[M,t.active]]),o("label",{id:t.label,for:t.id,class:"slds-checkbox__label"},[he,o("span",_e,_(t.label),1)],8,ce)],8,de)),p(w,{"data-q3-id":`mapArcGISButton-${t.uid}`,variant:"base",iconCategory:"utility",title:t.label,iconName:t.collapsed?"chevronup":"chevrondown",iconPosition:"right",class:"slds-col slds-grow-none slds-col_bump-right slds-button__icon_left slds-truncate",onClick:r=>t.collapsed=!t.collapsed},{default:f(()=>[o("span",ye,_(t.label),1)]),_:2},1032,["data-q3-id","title","iconName","onClick"])])):(c(),k(q,{key:1,modelValue:t.active,"onUpdate:modelValue":r=>t.active=r,inputAttrs:{"data-q3-id":"mapARCGISCheckbox"},class:"slds-p-horizontal_small slds-p-vertical_xx-small",labels:{name:t.label},onChange:r=>{d.hideMarkersInSection(t.uid)}},null,8,["modelValue","onUpdate:modelValue","labels","onChange"])),t.sublayers.length?(c(!0),h(I,{key:2},S(t.sublayers,r=>y((c(),h("div",{key:r.uid,class:"slds-border_bottom slds-p-left_large slds-p-vertical_xx-small"},[r.readOnly?A("",!0):(c(),h("div",{key:0,class:"slds-checkbox slds-p-right_xx-small","data-q3-id":`mapARCGISSubLayerCheckbox-${r.uid}`},[y(o("input",{id:r.id,"onUpdate:modelValue":m=>r.active=m,"aria-labelledby":r.label,type:"checkbox",onClick:m=>{d.hideMarkersInSection(r.uid)}},null,8,ue),[[M,r.active]]),o("label",{id:r.label,for:r.id,class:"slds-checkbox__label"},[be,o("span",fe,_(r.label),1)],8,ge)],8,pe)),p(w,{"data-q3-id":`mapArcGISButton-${r.uid}`,variant:"base",title:r.label,iconCategory:"utility",iconName:r.collapsed?"chevronup":"chevrondown",iconPosition:"right",class:"slds-col slds-grow-none slds-col_bump-right slds-button__icon_left slds-truncate",style:{"max-width":"326px"},onClick:m=>r.collapsed=!r.collapsed},{default:f(()=>[o("span",ve,_(r.label),1)]),_:2},1032,["data-q3-id","title","iconName","onClick"]),o("div",me,[y(o("div",Le,[o("div",{ref_for:!0,ref:r.ref,class:"slds-col slds-size_1-of-1 slds-p-left_x-small slds-grid slds-grid_vertical-align-center"},null,512)],512),[[b,!r.collapsed]])])])),[[b,!t.collapsed]])),128)):(c(),h("div",Ie,[y(o("div",Se,[o("div",{ref_for:!0,ref:t.ref,class:"slds-col slds-size_1-of-1 slds-grid slds-grid_vertical-align-center slds-p-right_x-small slds-p-vertical_xx-small slds-border_bottom slds-p-left_medium"},null,512)],512),[[b,!t.collapsed]])]))]))),128))])])}const Me=O(j,[["render",we],["__scopeId","data-v-951a2947"]]);export{Me as default};