import{_ as T,d as g,a as L,S as h,aO as v,f as D,u as N,aP as m,aQ as n,aR as y,r as l,o as p,c as S,s as _,v as R,i as f,w as O,j as k,t as M,F as b,b as C,e as w}from"../bundle.js";const P=g({loader:()=>L(()=>import("./RoutesListWrapper.3dd9a591.js"),[MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/RoutesListWrapper.3dd9a591.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "bundle.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/main.feeda730.css" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/Popover.93a0feed.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/RoutesListWrapper.5314d897.css" })],import.meta.url),loadingComponent:h}),A=g({loader:()=>L(()=>import("./Route.f0292722.js"),[MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/Route.f0292722.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "bundle.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/main.feeda730.css" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/routing.d6c1f97a.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/RouteSummary.cb0ffc72.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/RouteSummary.083f6add.css" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/index.0172543b.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/index.d251dbc7.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/TimePicker.bfa4e2f9.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/RouteSaveMixin.1664df7a.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/vuedraggable.umd.c7e4adc2.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/Popover.93a0feed.js" }),MAPS.getURLPath({ base: '/resource/1730379547462/maps__VueDesktopV2/dist/', path: "assets/Route.bd8b93d4.css" })],import.meta.url),loadingComponent:h}),B={name:"RoutesPanel",components:{Spinner:h,RouteListWrapper:P,CurrentRoute:A},emits:["hide-route"],setup(){const e=v(),o=D(),s=N();return{routesStore:e,mainStore:o,listStore:s}},data(){return{routeCounter:1,panelIsLoaded:!1}},computed:{currentDate(){const e=new Date;return{date:e.getDate(),month:e.getMonth(),year:e.getFullYear()}}},async created(){this.$bus.on("add-to-route",this.addToRouteHandler),this.addToNewRouteBus()},unmounted(){this.$bus.off("add-to-route",this.addToRouteHandler),this.$bus.off("add-to-new-route",this.addToNewRouteHandler)},methods:{addToNewRouteBus(){this.$bus.on("add-to-new-route",this.addToNewRouteHandler)},async openNewRoute(e=[]){const o=m.now(),s=o.toLocaleString(m.DATE_SHORT,{locale:MAPS.currentUser.LocaleFormatted});!n.enabledDuplicateStops&&e&&e.length>0&&(e=await this.removeDuplicates(e));const t={travelMode:n.mode,waypoints:e,Name:`${this.$Labels.MA_ROUTE} ${this.routeCounter} (${s})`,maps__Date__c:o.toISODate(),maps__User__c:MAPS.currentUser.Id,maps__User__r:{Name:MAPS.currentUser.Name,Id:MAPS.currentUser.Id},pendingChanges:e.length>0,maps__Options__c:n.defaultOptions,isGuideRoute:!1,timeBasedOptions:n.timeBasedOptions};this.routesStore.updateCurrentRoute(t),this.routeCounter+=1,await this.$nextTick(),this.routesStore.showRouteList=!1},async addToRouteHandler(e){!this.mainStore.activeTab!=="routes"&&(this.mainStore.activeTab="routes",await this.$nextTick());const o=[];Object.keys(e).forEach(r=>{const a=e[r],{features:u,type:i}=a;i==="sfMarkerLayer"&&u.forEach(d=>{const{linkId:c=""}=d;String(c).indexOf("00U")===0&&o.push(c)})});let s={};if(o.length>0)try{s=await y.loadEventData(o)}catch(r){console.warn("event data will not appear in route",r)}const t=this.routesStore.currentRoute.waypoints.length+1;this.routesStore.routeWorker.addListener("processedFeatures",async({waypoints:r,isTimeBased:a=!1})=>{this.routesStore.routeWorker.removeListener("processedFeatures"),this.routesStore.showRouteList?await this.openNewRoute(r):await this.routesStore.addWaypoints(r),a&&this.routesStore.setTimeBased(!0)}),this.routesStore.routeWorker.sendQuery("processRecords",{layerMap:e,startIndex:t,eventData:s,locale:MAPS.currentUser.Locale.replace("sh_ME_USD","sh-ME").replace("_","-").slice(0,5),timeZone:MAPS.currentUser.TimeZone,defaultSettings:n.defaultOptions})},addToNewRouteHandler(e){this.routesStore.showRouteList&&this.addToRouteHandler(e)},removeDuplicates(e){return new Promise(async(o,s)=>{try{this.routesStore.routeWorker.addListener("uniqueWaypoints",({uniqueWaypoints:r})=>{o(r)});let t=this.routesStore?.currentRoute?.waypoints||[];t=JSON.parse(JSON.stringify(t)),this.routesStore.routeWorker.sendQuery("removeDuplicates",{waypoints:e,currentWaypoints:t})}catch(t){console.warn(t),s()}})}}},E={id:"routesSingleWrapper",class:"slds-grid slds-grid--vertical slds-is-relative"};function I(e,o,s,t,r,a){const u=l("Spinner"),i=l("RouteListWrapper"),d=l("CurrentRoute");return p(),S("div",E,[_(f(u,{loadingLabel:e.$Labels.MA_Loading},{description:O(()=>[k(M(t.routesStore.loadingMessage),1)]),_:1},8,["loadingLabel"]),[[R,t.routesStore.callouts>0]]),t.mainStore.activeTab==="routes"||r.panelIsLoaded?(p(),S(b,{key:0},[_(f(i,{onOpenNewRoute:a.openNewRoute,onLoadPanel:o[0]||(o[0]=c=>r.panelIsLoaded=!0)},null,8,["onOpenNewRoute"]),[[R,t.routesStore.showRouteList]]),t.routesStore.showRouteList?w("",!0):(p(),C(d,{key:0,onResetNewRouteBus:a.addToNewRouteBus},null,8,["onResetNewRouteBus"]))],64)):w("",!0)])}const U=T(B,[["render",I]]);export{U as default};