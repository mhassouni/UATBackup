(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[3177],{9048:(e,s,t)=>{"use strict";t.d(s,{_:()=>a,a:()=>i});const a=(e,s)=>{if(e&&"object"==typeof e&&Array.isArray(s)){for(;s.length&&e;)e=e[s.shift()];return e}},i=(e,s="maps__")=>{try{const t=new Set(["marker","scatterMarker","clusterMarker","clusterGroup","workers","DeviceHistory","orderedPolyline","distanceLimitCircle","heatmapLayer"]);Object.entries(e).forEach((([a,o])=>{if(!t.has(a))if(a.startsWith(s)){const t=a.replace(s,"");e[t]=o,delete e[a],null!=e[t]&&"object"==typeof e[t]&&i(e[t],s)}else"object"==typeof o&&i(o,s)}))}catch(e){}return e}},8719:(e,s,t)=>{"use strict";t.d(s,{K:()=>l,x:()=>r});var a=t(5735),i=t.n(a),o=t(257),n=t(5658);const{MASystem:c}=window,l=async({sobject:e="",permissionsToCheck:s={isAccessible:!0},updateProgress:t=(()=>{}),includeDedicatedLookupOptions:a=!1})=>(async({sobject:e="",permissionsToCheck:s={isAccessible:!0},fieldIndex:t,progressCallback:a=(()=>{}),includeDedicatedLookupOptions:l=!1})=>{const{success:r=!1,data:_={},message:d}=await(0,n.wX)("RemoteFunctions.GetGlobalDescribeFields",[e,s,t,l],{escape:!1,buffer:!1});if(r){const{hasMore:t=!1,index:n,availableFields:l=[],totalSize:r=0}=_;if(t){let t=l;return await(async(e="",s={isAccessible:!0},t,a=(()=>{}))=>new Promise((n=>{let l=[];const r={status:"Running Batch",total:0,complete:0,success:0,failure:0},_=i()(((e,s)=>{const{object:t,limits:i,index:n}=e;((e="",s={isAccessible:!0},t)=>new Promise(((a,i)=>{(new o.Z).setAction("maps.RemoteFunctions.GetGlobalDescribeFields").setErrorHandler((e=>{i(new Error(e))})).invoke([e,s,t],(e=>{const{success:s=!1,data:t=[]}=e;s?a(t):(console.warn(c.Labels.Common_Refresh_And_Try_Again),i(new Error(c.Labels.Common_Refresh_And_Try_Again)))}),{escape:!1,buffer:!1,timeout:45e3})})))(t,i,n).then((e=>{const{hasMore:s=!1,availableFields:a=[]}=e,o=e.index;s&&_.push({object:t,limits:i,index:o}),l=[...l,...a],r.success+=a.length})).catch((e=>{console.warn("schema error",e),r.failure++})).finally((()=>{r.complete++,a(r),s()}))}),1);_.push({object:e,limits:s,index:t}),_.drain=()=>{const e=l.sort(((e,s)=>e.label>s.label?1:-1));n(e)}})))(e,s,n,(e=>{e.total=r,a(e)})).then((e=>{t=[...t,...e]})),t}return l}throw console.warn(c.Labels.Common_Refresh_And_Try_Again),new Error(d)})({sobject:e,permissionsToCheck:s,fieldIndex:0,updateProgress:e=>{t(e)},includeDedicatedLookupOptions:a}),r=async(e={},s=!1,t=(()=>{}))=>{const a=e.hideExtraObjects||!1;let n;return await(async(e=!1,s=!0,t={},a=0,n=(()=>{}))=>new Promise(((l,r)=>{const _=a;(new o.Z).setAction("maps.RemoteFunctions.GetGlobalDescribeObjects").setErrorHandler((e=>{r(new Error(e))})).invoke([e,t,s,_],(async a=>{const{success:_=!1,data:d={}}=a;if(_){const{hasMore:a=!1,index:r,availableObjects:_=[],totalSize:p=0}=d;if(a){let a=_;await((e=!1,s=!0,t={},a=0,n=(()=>{}))=>new Promise((l=>{const r={status:"Running Batch",total:0,complete:0,success:0,failure:0};let _=[];const d=i()(((e,s)=>{const{removeExtra:t,limitedSet:a,limits:i,index:l}=e;((e=!1,s=!0,t={},a=0)=>new Promise(((i,n)=>{(new o.Z).setAction("maps.RemoteFunctions.GetGlobalDescribeObjects").setErrorHandler((e=>{n(new Error(e))})).invoke([e,t,s,a],(e=>{const{success:s=!1,data:t={}}=e;s?i(t):(console.warn(c.Labels.Common_Refresh_And_Try_Again),n(new Error(c.Labels.Common_Refresh_And_Try_Again)))}),{escape:!1,buffer:!1})})))(t,a,i,l).then((e=>{const{hasMore:s=!1,availableObjects:o=[]}=e,n=e.index;s&&d.push({removeExtra:t,limitedSet:a,limits:i,index:n}),_=[..._,...o],r.success+=o.length})).catch((e=>{r.failure++,console.warn("schema error",e)})).finally((()=>{r.complete++,n(r),s()}))}),1);d.push({removeExtra:e,limitedSet:s,limits:t,index:a}),d.drain=()=>{const e=_.sort(((e,s)=>e.name>s.name?1:-1));l(e)}})))(e,s,t,r,(e=>{e.total=p,n(e)})).then((e=>{a=[...a,...e]})),l(a)}else l(_)}else console.warn(c.Labels.Common_Refresh_And_Try_Again),r(new Error(c.Labels.Common_Refresh_And_Try_Again))}),{escape:!1,buffer:!1})})))(a,s,e,0,(e=>{t(e)})).then((e=>{n=e})),n}},8137:e=>{e.exports='<svg xmlns=http://www.w3.org/2000/svg x=0px y=0px width=52px height=52px viewBox="0 0 52 52" enable-background="new 0 0 52 52" xml:space=preserve> <path fill=#FFFFFF d="M31,25.4L44,12.3c0.6-0.6,0.6-1.5,0-2.1L42,8.1c-0.6-0.6-1.5-0.6-2.1,0L26.8,21.2c-0.4,0.4-1,0.4-1.4,0\r\n\tL12.3,8c-0.6-0.6-1.5-0.6-2.1,0l-2.1,2.1c-0.6,0.6-0.6,1.5,0,2.1l13.1,13.1c0.4,0.4,0.4,1,0,1.4L8,39.9c-0.6,0.6-0.6,1.5,0,2.1\r\n\tl2.1,2.1c0.6,0.6,1.5,0.6,2.1,0L25.3,31c0.4-0.4,1-0.4,1.4,0l13.1,13.1c0.6,0.6,1.5,0.6,2.1,0l2.1-2.1c0.6-0.6,0.6-1.5,0-2.1\r\n\tL31,26.8C30.6,26.4,30.6,25.8,31,25.4z"/> </svg> '},6413:e=>{e.exports='<svg xmlns=http://www.w3.org/2000/svg x=0px y=0px width=52px height=52px viewBox="0 0 52 52" enable-background="new 0 0 52 52" xml:space=preserve> <path fill=#FFFFFF d="M26,2C12.8,2,2,12.8,2,26s10.8,24,24,24s24-10.8,24-24S39.2,2,26,2z M8,26c0-9.9,8.1-18,18-18\r\n\tc3.9,0,7.5,1.2,10.4,3.3L11.3,36.4C9.2,33.5,8,29.9,8,26z M26,44c-3.9,0-7.5-1.2-10.4-3.3c5.1-5.1,19.3-19.3,25.1-25.1\r\n\tC42.8,18.5,44,22.1,44,26C44,35.9,35.9,44,26,44z"/> </svg> '},8186:e=>{e.exports='<svg xmlns=http://www.w3.org/2000/svg x=0px y=0px width=52px height=52px viewBox="0 0 52 52" enable-background="new 0 0 52 52" xml:space=preserve> <path fill=#FFFFFF d="M26,2C12.7,2,2,12.7,2,26s10.7,24,24,24s24-10.7,24-24S39.3,2,26,2z M26,14.1c1.7,0,3,1.3,3,3s-1.3,3-3,3\r\n\ts-3-1.3-3-3S24.3,14.1,26,14.1z M31,35.1c0,0.5-0.4,0.9-1,0.9h-3c-0.4,0-3,0-3,0h-2c-0.5,0-1-0.3-1-0.9v-2c0-0.5,0.4-1.1,1-1.1l0,0\r\n\tc0.5,0,1-0.3,1-0.9v-4c0-0.5-0.4-1.1-1-1.1l0,0c-0.5,0-1-0.3-1-0.9v-2c0-0.5,0.4-1.1,1-1.1h6c0.5,0,1,0.5,1,1.1v8\r\n\tc0,0.5,0.4,0.9,1,0.9l0,0c0.5,0,1,0.5,1,1.1V35.1z"/> </svg> '},9718:e=>{e.exports='<svg xmlns=http://www.w3.org/2000/svg x=0px y=0px width=52px height=52px viewBox="0 0 52 52" enable-background="new 0 0 52 52" xml:space=preserve> <path fill=#FFFFFF d="M26,2C12.7,2,2,12.7,2,26s10.7,24,24,24s24-10.7,24-24S39.3,2,26,2z M39.4,20L24.1,35.5\r\n\tc-0.6,0.6-1.6,0.6-2.2,0L13.5,27c-0.6-0.6-0.6-1.6,0-2.2l2.2-2.2c0.6-0.6,1.6-0.6,2.2,0l4.4,4.5c0.4,0.4,1.1,0.4,1.5,0L35,15.5\r\n\tc0.6-0.6,1.6-0.6,2.2,0l2.2,2.2C40.1,18.3,40.1,19.3,39.4,20z"/> </svg> '},5953:e=>{e.exports='<svg xmlns=http://www.w3.org/2000/svg width=52 height=52 viewBox="0 0 52 52"><path fill=#fff d="m51.4 42.5l-22.9-37c-1.2-2-3.8-2-5 0l-22.9 37c-1.4 2.3 0 5.5 2.5 5.5h45.8c2.5 0 4-3.2 2.5-5.5z m-25.4-2.5c-1.7 0-3-1.3-3-3s1.3-3 3-3 3 1.3 3 3-1.3 3-3 3z m3-9c0 0.6-0.4 1-1 1h-4c-0.6 0-1-0.4-1-1v-13c0-0.6 0.4-1 1-1h4c0.6 0 1 0.4 1 1v13z"></path></svg>'},8081:(e,s,t)=>{"use strict";t.r(s),t.d(s,{default:()=>h});var a=t(2061),i=t(2646),o=t(5602),n=t(5908),c=t.n(n),l=t(257),r=t(9048),_=t(5735),d=t.n(_),p=t(8719);const{MARemoting:m,MASystem:b}=window,u=new(c().Store)({state:{showAdditionalFields:!0,callouts:0,isLoading:!1,toastMsg:null,toastType:"error",showAllObjects:!1,availableObjects:[],existingObjects:[],newBaseObject:{},newObjectData:{AddressFields:[],BaseObjectLabelPlural:"",BooleanFields:[],CoordinateFields:[],DatetimeFields:[],ObjectName:"",ParentBaseObject:"",QualityFields:[],RecordTypes:[],RelationshipFields:[],PolymorphicFields:{},isPolymorphic:!1,hasMarkerLayer:!1,ShapeFields:[],SimilarityFields:[],TooltipFields:[]},existingBaseObject:{},baseObjectDefaults:{Name:"",maps__AddressObject__c:"SAME",maps__City__c:"",maps__DisableGlobalSearch__c:!1,maps__Country__c:"",maps__Description__c:"",maps__Latitude__c:"",maps__Longitude__c:"",maps__PolylineVertices__c:{vertices:["","","",""]},maps__Name__c:"",maps__PostalCode__c:"",maps__PriorityField__c:"",maps__PriorityType__c:"",maps__RecordTypeId__c:"--All--",maps__RoutingEndTime__c:"",maps__RoutingHasAddress__c:"",maps__RoutingIsFlexible__c:"",maps__RoutingStartTime__c:"",maps__PolymorphicAddressObject__c:"",maps__Settings__c:{CheckInDateField:"",CheckOutDateField:"",ChatterBody:b.Labels.MapsSetting_Default_Chatter_Body,CheckInPostTo:"Chatter|Task",VerificationDistance:"",VerificationRequired:!1,VerificationUnit:"mi",MyTerritoryScope:!1,MyTerritoryTeamScope:!1},maps__Tooltip1__c:"",maps__Tooltip2__c:"",maps__Tooltip3__c:"",maps__Tooltip4__c:"",maps__Tooltip5__c:"",maps__Tooltip6__c:"",maps__Tooltip7__c:"",maps__Tooltip8__c:"",maps__Tooltip9__c:"",maps__Tooltip10__c:"",maps__Tooltip11__c:"",maps__Tooltip12__c:"",maps__Tooltip13__c:"",maps__Tooltip14__c:"",maps__Tooltip15__c:"",maps__MapIt_Zoom_Control__c:8,maps__MapIt_Proximity_On__c:!1,maps__MapIt_Show_Inside_Shape__c:!1,maps__MapIt_Proximity_Radius__c:0,maps__MapIt_Proximity_Measurement_Unit__c:"Miles",maps__SkipFailedGeocodes__c:!1,maps__State__c:"",maps__Street__c:"",maps__VerifiedLatitude__c:"",maps__VerifiedLongitude__c:"",maps__Type__c:"Marker"},existingObjectData:{AddressFields:[],BaseObjectLabelPlural:"",BooleanFields:[],CoordinateFields:[],DatetimeFields:[],ObjectName:"",ParentBaseObject:"",QualityFields:[],RecordTypes:[],RelationshipFields:[],PolymorphicFields:{},isPolymorphic:!1,hasMarkerLayer:!1,ShapeFields:[],SimilarityFields:[],TooltipFields:[],supportsSkipGeocoding:!1}},mutations:{setIsPolymorphic(e,{type:s,newValue:t}){"createNew"===s?e.newBaseObject.isPolymorphic=t:e.existingBaseObject.isPolymorphic=t},updateShowAdditionalFields(e,s){e.showAdditionalFields=s},updateAllObjects(e,s){e.showAllObjects=s},resetNewBaseObject(e,s){s=s||"";const t={...e.baseObjectDefaults,Name:s};e.newBaseObject=t},resetExistingBaseObject(e){const s={...e.baseObjectDefaults,Id:""};e.existingBaseObject=s},loadingToggle(e,s){"boolean"==typeof s?s?(e.callouts+=1,e.isLoading=!0):(e.callouts-=1,e.callouts<=0&&(e.isLoading=!1,e.callouts=0)):(e.callouts-=1,e.isLoading=!1)},updateToastMsg(e,{msg:s,type:t}){e.toastType=t,t=t||"error",e.toastMsg=""===s||void 0===s?null:s},updateBaseObjectName(e,{type:s,newValue:t}){"createNew"===s?e.newBaseObject.Name=t:e.existingBaseObject.Name=t},updateBaseObject(e,{type:s,newValue:t}){"createNew"===s?e.newBaseObject=t:e.existingBaseObject=t},updateExistingObjects(e,s){if("object"==typeof s){const t=Object.keys(s),a=[];for(let e=0;e<t.length;e++){const i=s[t[e]];a.push({label:i.Id,name:i.Name__c})}e.existingObjects=a}},updateAvailableObjects(e,s){if("object"==typeof s){const t=Object.values(s);e.availableObjects=t}},updateObjectData(e,{updateType:s,response:t}){"createNew"===s?e.newObjectData=t:e.existingObjectData=t},updatePolymorphicFields(e,{updateType:s,fieldApi:t,response:a}){"createNew"===s?e.newObjectData.PolymorphicFields[t]=a:e.existingObjectData.PolymorphicFields[t]=a},updateObjectFields(e,{updateType:s,response:t}){let a={};a="createNew"===s?e.newObjectData:e.existingObjectData,a.AddressFields=t.AddressFields||[],a.BooleanFields=t.BooleanFields||[],a.CoordinateFields=t.CoordinateFields||[],a.DatetimeFields=t.DatetimeFields||[],a.QualityFields=t.QualityFields||[],a.RecordTypes=t.RecordTypes||[],a.SimilarityFields=t.SimilarityFields||[],a.PriorityFields=t.PriorityFields||[],a.hasMarkerLayer=t.hasMarkerLayer||!1,a.PolylineFields=t.PolylineFields||[]},updateExistingObjectData(e,{data:s}){if("object"==typeof s)if(Object.prototype.hasOwnProperty.call(s,"BaseObject")){const t=s.BaseObject,a={CheckInDateField:"",CheckOutDateField:"",ChatterBody:b.Labels.MapsSetting_Default_Chatter_Body,CheckInPostTo:"Chatter|Task",VerificationDistance:"",VerificationRequired:!1,VerificationUnit:"mi",MyTerritoryScope:!1,MyTerritoryTeamScope:!1},i={vertices:["","","",""]};let o=t.maps__Settings__c,n=t.maps__PolylineVertices__c;try{const e=JSON.parse(t.maps__Settings__c);o={...a,...e};const s=JSON.parse(t.maps__PolylineVertices__c);n={...i,...s}}catch(e){console.warn(e),console.warn("Unable to parse checkin settings, defaults will be used."),o=a,n=i}t.maps__Settings__c=o,t.maps__PolylineVertices__c=n;const c={...e.baseObjectDefaults,...t};e.existingBaseObject=c}else console.warn("No base object data")},suggestAddressFields(e,s){let t,a;if("createNew"===s?(a=e.newBaseObject||e.baseObjectDefaults,t=e.newObjectData.AddressFields||[]):(a=e.existingBaseObject||e.baseObjectDefaults,t=e.existingObjectData.AddressFields||[]),""===a.maps__Street__c||null===a.maps__Street__c){const e=t.find((e=>-1!==e.value.toLowerCase().indexOf("street")));void 0!==e&&(a.maps__Street__c=e.value)}if(""===a.maps__State__c||null===a.maps__State__c){const e=t.find((e=>-1!==e.value.toLowerCase().indexOf("state")));void 0!==e&&(a.maps__State__c=e.value)}if(""===a.maps__City__c||null===a.maps__City__c){const e=t.find((e=>-1!==e.value.toLowerCase().indexOf("city")));void 0!==e&&(a.maps__City__c=e.value)}if(""===a.maps__PostalCode__c||null===a.maps__PostalCode__c){const e=t.find((e=>-1!==e.value.toLowerCase().indexOf("postalcode")));void 0!==e&&(a.maps__PostalCode__c=e.value)}if(""===a.maps__Country__c||null===a.maps__Country__c){const e=t.find((e=>-1!==e.value.toLowerCase().indexOf("country")));void 0!==e&&(a.maps__Country__c=e.value)}},suggestCoordFields(e,s){let t,a;if("createNew"===s?(a=e.newBaseObject||e.baseObjectDefaults,t=e.newObjectData.CoordinateFields||[]):(a=e.existingBaseObject||e.baseObjectDefaults,t=e.existingObjectData.CoordinateFields||[]),""===a.maps__Latitude__c||null===a.maps__Latitude__c){const e=t.find((e=>-1!==e.value.toLowerCase().indexOf("latitude")));void 0!==e&&(a.maps__Latitude__c=e.value||"")}if(""===a.maps__Longitude__c||null===a.maps__Longitude__c){const e=t.find((e=>-1!==e.value.toLowerCase().indexOf("longitude")));void 0!==e&&(a.maps__Longitude__c=e.value||"")}if(""===a.maps__VerifiedLatitude__c||null===a.maps__VerifiedLatitude__c){const e=t.find((e=>{const s=e.value.toLowerCase();return-1!==s.indexOf("latitude")&&-1!==s.indexOf("verified")}));void 0!==e&&(a.maps__VerifiedLatitude__c=e.value||"")}if(""===a.maps__VerifiedLongitude__c||null===a.maps__VerifiedLongitude__c){const e=t.find((e=>{const s=e.value.toLowerCase();return-1!==s.indexOf("longitude")&&-1!==s.indexOf("verified")}));void 0!==e&&(a.maps__VerifiedLongitude__c=e.value||"")}}},getters:{getShowAdditionalFields:e=>e.showAdditionalFields,getGeoSupport:e=>e.existingObjectData.supportsSkipGeocoding||!1,getNewBaseObjectName:e=>e.newBaseObject.Name,getNewBaseObjectPluralName(e){let s=(0,r._)(e.newObjectData,["BaseObjectLabelPlural"]);return void 0===s&&(s=e.newBaseObject.Name),s},getExistingBaseObjectName:e=>e.existingBaseObject.Name,getExistingBaseObjectPluralName(e){let s=(0,r._)(e.existingObjectData,["BaseObjectLabelPlural"]);return void 0===s&&(s=e.existingBaseObject.Name),s},getExistingBaseObjectId:e=>e.existingBaseObject.Id,getNewObjectData:e=>e.newObjectData,getExistingObjectData:e=>e.existingObjectData,getNewBaseObjectAddressLocation:e=>e.newBaseObject.maps__AddressObject__c,getExistingBaseObjectAddressLocation:e=>e.existingBaseObject.maps__AddressObject__c,getNewPolymorphicAddress:e=>e.newBaseObject.maps__PolymorphicAddressObject__c,getExistingPolymorphicAddress:e=>e.existingBaseObject.maps__PolymorphicAddressObject__c},actions:{populateExistingObjects:({commit:e})=>new Promise(((s,t)=>{(new l.Z).setAction("maps.RemoteFunctions.GetSavedBaseObjects").setErrorHandler((e=>{console.warn(e),t(new Error(e))})).invoke([],(a=>{const{success:i=!1,data:o={},securityError:n=!1,message:c=""}=a;if(i)if(n)e("updateToastMsg",{msg:c,type:"warning"}),s(a);else{const{core:t=[]}=o;e("updateExistingObjects",t),s(a)}else console.warn(b.Labels.Common_Refresh_And_Try_Again),t(new Error(b.Labels.Common_Refresh_And_Try_Again))}),{escape:!1,buffer:!1})})),async getAvailableObjects({state:e,commit:s}){try{const t={isAccessible:!0,isQueryable:!0,hideExtraObjects:!0},a=!e.showAllObjects;s("updateAvailableObjects",await(0,p.x)(t,a))}catch(e){console.warn(e)}},populateFields:({commit:e,getters:s},t)=>new Promise(((a,i)=>{let o="";o="createNew"===t?s.getNewBaseObjectName:s.getExistingBaseObjectName;const n={action:"populate_available_fields",object:o};(new l.Z).setAction(m.AdminStartUpAction).setErrorHandler((e=>{console.warn(e),i(new Error(e))})).invoke([n],(s=>{s&&s.success?(e("updateObjectData",{updateType:t,response:s}),a(s)):(console.warn(b.Labels.Common_Refresh_And_Try_Again),i(new Error(b.Labels.Common_Refresh_And_Try_Again)))}),{escape:!1,buffer:!1})})),describePolymorphicRelationships:({dispatch:e,getters:s},t)=>new Promise(((a,i)=>{let o="";const{fieldApi:n,objectIndex:c}=t;t.updateType?o="createNew"===t.updateType?s.getNewBaseObjectName:s.getExistingBaseObjectName:t.objectIndex&&(o=t.objectName);const r={action:"describePolymorphicRelationships",objectIndex:c,baseObject:o,fieldApi:n};(new l.Z).setAction(m.AdminStartUpAction).setErrorHandler((e=>{console.warn(e),i(new Error(e))})).invoke([r],(s=>{if(s&&s.success)if(s.objectIndexResponse){const{polyOptions:t,fieldApiResponse:o,baseObjectResponse:n,objectIndexResponse:c}=s;e("describePolymorphicRelationships",{fieldApi:o,objectName:n,objectIndex:c}).then((e=>{a([...t,...e])})).catch((e=>{i(e)}))}else a(s.polyOptions);else console.warn(b.Labels.Common_Refresh_And_Try_Again),i(new Error(b.Labels.Common_Refresh_And_Try_Again))}),{escape:!1,buffer:!1})})),rePopulateFields:({state:e,commit:s,getters:t},a)=>new Promise(((i,o)=>{let n="",c="",r=!1;"createNew"===a?(n=t.getNewBaseObjectName,r=e.newBaseObject.isPolymorphic,c=r?t.getNewPolymorphicAddress:t.getNewBaseObjectAddressLocation):(n=t.getExistingBaseObjectName,r=e.existingBaseObject.isPolymorphic,c=r?t.getExistingPolymorphicAddress:t.getExistingBaseObjectAddressLocation);const _={action:"repopulate_available_fields",object:n,addressloc:c,isPolymorphic:r};(new l.Z).setAction(m.AdminStartUpAction).setErrorHandler((e=>{console.warn(e),o(new Error(e))})).invoke([_],(e=>{e&&e.success?(s("updateObjectFields",{updateType:a,response:e}),i(e)):(console.warn(b.Labels.Common_Refresh_And_Try_Again),o(new Error(b.Labels.Common_Refresh_And_Try_Again)))}),{escape:!1,buffer:!1})})),getExistingSFDCData:({commit:e},s)=>new Promise(((t,a)=>{const i={action:"get_existing_object",object:s,type:"marker"};(new l.Z).setAction(m.AdminStartUpAction).setErrorHandler((e=>{console.warn(e),a(new Error(e))})).invoke([i],(s=>{s&&s.success?(e("updateObjectData",{updateType:"editExisting",response:s}),e("updateExistingObjectData",{data:s}),t(s)):(console.warn(b.Labels.Common_Refresh_And_Try_Again),a(new Error(b.Labels.Common_Refresh_And_Try_Again)))}),{escape:!1,buffer:!1})})),saveSFDCData:({dispatch:e},s)=>new Promise(((t,a)=>{try{const i={...s};i.maps__Settings__c=JSON.stringify(i.maps__Settings__c),i.maps__PolylineVertices__c=JSON.stringify(i.maps__PolylineVertices__c),delete i.maps__Saved_Queries__r;const o={action:"save_base_object",BaseObject:JSON.stringify(i)};(new l.Z).setAction(m.AdminStartUpAction).setErrorHandler((e=>{console.warn(e),a(new Error(e))})).invoke([o],(s=>{if(s&&s.success)e("populateExistingObjects").then((()=>{t(s)}));else{const e=s.error||b.Labels.Common_Refresh_And_Try_Again_Contact_Admin;console.warn(b.Labels.Common_Refresh_And_Try_Again,e),a(new Error(b.Labels.Could_Not_Get_Data))}}),{escape:!1,buffer:!1})}catch(e){a(new Error(b.Labels.MA_Something_Went_Wrong))}})),deleteSFDCData:({dispatch:e},s)=>new Promise(((t,a)=>{const i={action:"delete_base_object",object:s};(new l.Z).setAction(m.AdminStartUpAction).setErrorHandler((e=>{console.warn(e),a(new Error(e))})).invoke([i],(s=>{if(s&&s.success)e("populateExistingObjects").then((()=>{t(s)})).catch((e=>{a(e)}));else{const e=s.error||b.Labels.Common_Refresh_And_Try_Again_Contact_Admin;console.warn(b.Labels.Common_Refresh_And_Try_Again,e),a(new Error(b.Labels.MapsSetting_Cannot_Delete_Data))}}),{escape:!1,buffer:!1})})),validateFilterScopes:({commit:e,getters:s},t)=>new Promise((a=>{let i="";i="createNew"===t?s.getNewBaseObjectName:s.getExistingBaseObjectName;const o={},n=`Select Id From ${i} USING SCOPE `;e("loadingToggle",!0);const c=d()(((e,s)=>{const t={ajaxResource:"TooltipAJAXResources",action:"do_query",q:e.query};(new l.Z).setAction(m.processAJAXRequest).setErrorHandler((t=>{console.warn(t),o[e.scope]=!1,s()})).invoke([t],(t=>{t&&t.success?o[e.scope]=!0:o[e.scope]=!1,s()}),{escape:!1,buffer:!1})}),3),r=["My_Territory","My_Team_Territory"];for(let e=0;e<r.length;e++){const s=r[e];c.push({scope:s,query:`${n} ${s} LIMIT 1`})}c.drain=()=>{e("loadingToggle",!1),a(o)}}))}}),g={components:{Spinner:i.$j,MAToast:a.Z,Tabs:i.mQ,Tab:i.OK,createBaseObject:()=>({...(0,o.YH)(),component:Promise.all([t.e(8586),t.e(7772)]).then(t.bind(t,4322))}),editBaseObject:()=>({...(0,o.YH)(),component:Promise.all([t.e(8586),t.e(3553)]).then(t.bind(t,9380))}),deleteBaseObject:()=>({...(0,o.YH)(),component:t.e(6350).then(t.bind(t,8073))})},data:()=>({showSelectMessage:!1,toast:null,Labels:window.MASystem.Labels,activeTab:"createNewBO"}),computed:{...(0,n.mapState)(["toastMsg","toastType","isLoading"])},beforeCreate(){this.$store=u},created(){this.loadingToggle(!0),this.getAvailableObjects().catch((e=>{this.updateToastMsg({msg:e}),console.warn(e)})).finally((()=>{this.loadingToggle(!1)}))},methods:{...(0,n.mapGetters)([]),...(0,n.mapMutations)(["loadingToggle","updateToastMsg"]),...(0,n.mapActions)(["getAvailableObjects"]),closeToast(){this.updateToastMsg({msg:""})},updateTab(e){this.activeTab=e}}},h=(0,t(1900).Z)(g,(function(){var e=this,s=e._self._c;return s("div",{staticClass:"base-objects-wrap",staticStyle:{position:"relative"}},[e.isLoading?s("Spinner"):e._e(),e._v(" "),null!=e.toastMsg?s("MAToast",{attrs:{msg:e.toastMsg,state:e.toastType},on:{close:e.closeToast}}):e._e(),e._v(" "),s("Tabs",{staticClass:"slds-m-bottom_medium",attrs:{activeTabId:e.activeTab},on:{changed:e.updateTab}},[s("Tab",{staticClass:"slds-m-around_medium",attrs:{id:"createNewBO",title:e.Labels.MA_Create}},[s("createBaseObject")],1),e._v(" "),s("Tab",{staticClass:"slds-m-around_medium",attrs:{id:"editExisting",title:e.Labels.MA_Edit}},[s("keep-alive",["editExisting"===e.activeTab?s("editBaseObject"):e._e()],1)],1),e._v(" "),s("Tab",{staticClass:"slds-m-around_medium",attrs:{id:"deleteExisting",title:e.Labels.MA_Remove}},[s("keep-alive",["deleteExisting"===e.activeTab?s("deleteBaseObject"):e._e()],1)],1)],1)],1)}),[],!1,null,"2d2a74e1",null).exports},2061:(e,s,t)=>{"use strict";function a(e){if(e.setAttribute("aria-hidden",!0),Array.isArray(this.iconClass)?this.iconClass.forEach((s=>e.classList.add(s))):e.classList.add(this.iconClass),this.inheritFillFromParent){const s=e=>{e.forEach((e=>{"path"!==e.nodeName&&"g"!==e.nodeName||(e.style.fill="inherit"),e.childNodes.length&&s(e.childNodes)}))};s(e.childNodes||[])}if(this.$el.appendChild(e),this.assistiveText){const e=document.createElement("span");e.classList.add("slds-assistive-text"),e.textContent=this.assistiveText,this.$el.appendChild(e)}}t.d(s,{Z:()=>c});const i={render:e=>e("span"),props:{svg:{required:!0,validator(e){const s="string"==typeof e,t="object"==typeof e&&!0===e.__esModule;return s||t}},inheritFillFromParent:{type:Boolean,default:!0},assistiveText:{type:String},iconClass:{type:[Array,String]}},mounted(){const e="object"==typeof this.svg&&!0===this.svg.__esModule?this.svg.default:this.svg,s=document.createRange().createContextualFragment(e),t=Array.from(s.childNodes).find((e=>"svg"===e.nodeName));t?a.call(this,t):console.error("Could not build SVG.")}},o=new Map;o.set("info",{divClass:"slds-theme_info"}),o.set("success",{divClass:"slds-theme_success"}),o.set("warning",{divClass:"slds-theme_warning"}),o.set("error",{divClass:"slds-theme_error"});const n={name:"MAToast",components:{MAIconInline:i},props:{msg:{type:String,required:!1,default:""},state:{type:String,default:"error",validate:e=>e&&(void 0).stateMap.has(e)},closeLabel:{type:String,default:"Close"}},data:()=>({stateMap:o}),methods:{close(){this.$emit("close")}}},c=(0,t(1900).Z)(n,(function(){var e=this,s=e._self._c;return s("div",{staticClass:"slds-grid slds-grid_vertical-align-center ma-wrapper"},[s("div",{staticClass:"slds-spinner_container"}),e._v(" "),s("div",{staticClass:"slds-notify_container slds-is-relative"},[s("div",{staticClass:"slds-notify slds-notify_toast ma-toast",class:e.stateMap.get(e.state).divClass,attrs:{role:"alert"}},[s("span",{staticClass:"slds-assistive-text"},[e._v(e._s(e.state))]),e._v(" "),s("MAIconInline",{directives:[{name:"show",rawName:"v-show",value:"error"===e.state,expression:"state === 'error'"}],staticClass:"slds-icon_container slds-m-right_small slds-no-flex slds-align-top",attrs:{svg:t(6413),iconClass:["slds-button__icon","slds-button__icon_large"]}}),e._v(" "),s("MAIconInline",{directives:[{name:"show",rawName:"v-show",value:"success"===e.state,expression:"state === 'success'"}],staticClass:"slds-icon_container slds-m-right_small slds-no-flex slds-align-top",attrs:{svg:t(9718),iconClass:["slds-button__icon","slds-button__icon_large"]}}),e._v(" "),s("MAIconInline",{directives:[{name:"show",rawName:"v-show",value:"info"===e.state,expression:"state === 'info'"}],staticClass:"slds-icon_container slds-m-right_small slds-no-flex slds-align-top",attrs:{svg:t(8186),iconClass:["slds-button__icon","slds-button__icon_large"]}}),e._v(" "),s("MAIconInline",{directives:[{name:"show",rawName:"v-show",value:"warning"===e.state,expression:"state === 'warning'"}],staticClass:"slds-icon_container slds-m-right_small slds-no-flex slds-align-top",attrs:{svg:t(5953),iconClass:["slds-button__icon","slds-button__icon_large"]}}),e._v(" "),s("div",{staticClass:"slds-notify__content"},[e._t("default",(function(){return[s("div",[e._v(e._s(e.msg))])]}))],2),e._v(" "),s("button",{staticClass:"slds-button slds-button_icon slds-notify__close slds-button_icon-inverse",attrs:{title:e.closeLabel},on:{click:e.close}},[s("MAIconInline",{staticClass:"slds-icon_container",attrs:{svg:t(8137),iconClass:["slds-button__icon","slds-button__icon_large"]}}),e._v(" "),s("span",{staticClass:"slds-assistive-text"},[e._v(e._s(e.closeLabel))])],1)],1)])])}),[],!1,null,"2d0cadea",null).exports}}]);