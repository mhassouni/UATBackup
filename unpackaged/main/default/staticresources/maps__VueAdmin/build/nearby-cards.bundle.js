"use strict";(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[967],{4890:(t,s,e)=>{e.d(s,{Z:()=>r});var a=e(3088);const{MARemoting:l}=window;class r{static read(t=!1){return(0,a.wX)(l.NearbyMap.read,[t])}static save(t){return(0,a.wX)(l.NearbyMap.save,[JSON.stringify(t)])}static delete(t){return(0,a.wX)(l.NearbyMap.delete,[t])}static getAllowableSObjects(){return(0,a.wX)(l.NearbyMap.getAllowableSObjects,[])}static getSObjectInfoBySObjectName(t){return(0,a.wX)(l.NearbyMap.getSObjectInfoBySObjectName,[t])}static fieldHasDuplicateValue(t,s){return(0,a.wX)(l.NearbyMap.fieldHasDuplicateValue,[t,s])}}},1222:(t,s,e)=>{e.d(s,{Z:()=>c});var a={};e.r(a),e.d(a,{circle:()=>l,pin:()=>r,square:()=>n,triangle:()=>i});const l={config:{name:"circle",size:{x:22,y:22},anchor:{x:11,y:22}},svg:'\n        <svg data-shape="circle" class="marker-legend-icon" id="markerCircle" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 24 24">\n            <style type="text/css">.st0{fill:#FFFFFF;}.st1{fill:__COLOR__;}.st2{fill:url(#SVGID_1_);}.st3{opacity:0.7;fill:url(#SVGID_2_);enable-background:new;}.st4{opacity:0.6;}.st5{fill:url(#SVGID_3_);}.st6{fill:url(#SVGID_4_);}.st7{opacity:0.7;fill:url(#SVGID_5_);enable-background:new;}.st8{fill:url(#SVGID_6_);}.st9{fill:url(#SVGID_7_);}.st10{opacity:0.7;fill:url(#SVGID_8_);enable-background:new;}.st11{fill:url(#SVGID_9_);}.st12{fill:url(#SVGID_10_);}.st13{fill:url(#SVGID_11_);}.st14{opacity:0.7;fill:url(#SVGID_12_);enable-background:new;}</style>\n            <g>\n                <g>\n                    <path class="st0" d="M12,23.5C5.7,23.5,0.5,18.3,0.5,12S5.7,0.5,12,0.5S23.5,5.7,23.5,12S18.3,23.5,12,23.5z M12,1.5C6.2,1.5,1.5,6.2,1.5,12S6.2,22.5,12,22.5S22.5,17.8,22.5,12S17.8,1.5,12,1.5z"/>\n                </g>\n                <g>\n                    <circle class="st1" cx="12" cy="12" r="11"/>\n                    <linearGradient id="SVGID_1_" gradientUnits="userSpaceOnUse" x1="12.0002" y1="1" x2="12.0002" y2="20.25">\n                        <stop offset="0.19" style="stop-color:#FFFFFF;stop-opacity:0.25"/>\n                        <stop offset="0.92" style="stop-color:#FFFFFF;stop-opacity:0"/>\n                    </linearGradient>\n                    <path class="st2" d="M23,12c0,11-22,11-22,0C1,5.9,5.9,1,12,1S23,5.9,23,12z"/>\n                </g>\n                <linearGradient id="SVGID_2_" gradientUnits="userSpaceOnUse" x1="8.8502" y1="1118" x2="15.1502" y2="1118" gradientTransform="matrix(1 0 0 1 0 -1106)">\n                    <stop offset="0" style="stop-color:#000000"/>\n                    <stop offset="1" style="stop-color:#000000"/>\n                </linearGradient>\n                <ellipse class="st3" cx="12" cy="12" rx="3.1" ry="3.2"/>\n                <g class="st4">\n                    <linearGradient id="SVGID_3_" gradientUnits="userSpaceOnUse" x1="1" y1="12" x2="23" y2="12">\n                        <stop offset="0" style="stop-color:#000000"/>\n                        <stop offset="1" style="stop-color:#000000"/>\n                    </linearGradient>\n                    <path class="st5" d="M12,23C5.9,23,1,18.1,1,12S5.9,1,12,1s11,4.9,11,11S18.1,23,12,23z M12,1.5C6.2,1.5,1.5,6.2,1.5,12S6.2,22.5,12,22.5S22.5,17.8,22.5,12S17.8,1.5,12,1.5z"/>\n                </g>\n            </g>\n        </svg>\n    '},r={config:{name:"pin",size:{x:22,y:36},anchor:{x:11,y:36}},svg:'\n        <svg data-shape="pin" class="marker-legend-icon" id="markerPin" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 26 42">\n            <defs>\n                <style>.cls-1{fill:#fff;}.cls-2{fill:__COLOR__;}.cls-3{fill:url(#linear-gradient);}.cls-4{opacity:0.7;isolation:isolate;fill:url(#linear-gradient-2);}.cls-5{opacity:0.6;}.cls-6{fill:url(#linear-gradient-3);}</style>\n                <linearGradient id="linear-gradient" x1="12.99" y1="1.51" x2="12.99" y2="23.9" gradientUnits="userSpaceOnUse">\n                    <stop offset="0.19" stop-color="#fff" stop-opacity="0.25"/>\n                    <stop offset="0.92" stop-color="#fff" stop-opacity="0"/>\n                </linearGradient>\n                <linearGradient id="linear-gradient-2" x1="9.85" y1="242.72" x2="16.15" y2="242.72" gradientTransform="translate(0 -230)" gradientUnits="userSpaceOnUse">\n                    <stop offset="0"/>\n                    <stop offset="1"/>\n                </linearGradient>\n                <linearGradient id="linear-gradient-3" x1="1.99" y1="-18.97" x2="23.99" y2="-18.97" gradientTransform="matrix(1, 0, 0, -1, 0, 2)" xlink:href="#linear-gradient-2"/>\n            </defs>\n            <path class="cls-1" d="M14.74,40.94H11.25v-1c0-9.38-3.73-14.92-6.19-18.58l-.79-1.12A13.67,13.67,0,0,1,1.5,12.62a11.5,11.5,0,1,1,23,0,13.68,13.68,0,0,1-2.78,7.63l-.78,1.17c-2.47,3.67-6.19,9.19-6.19,18.58v.95Zm-2.48-1h1.48c0-9.67,3.84-15.34,6.37-19.09l.79-1.17a12.75,12.75,0,0,0,2.6-7.07,10.5,10.5,0,1,0-21,0,12.74,12.74,0,0,0,2.6,7.07l.79,1.17c2.53,3.76,6.35,9.42,6.36,19.09Z"/>\n            <path class="cls-2" d="M13,1.51A11.06,11.06,0,0,0,2,12.62a13.21,13.21,0,0,0,2.7,7.32l.79,1.17C8,24.83,11.75,30.44,11.75,40v.45h2.48V40c0-9.54,3.78-15.15,6.28-18.86l.79-1.17A13.21,13.21,0,0,0,24,12.62,11.06,11.06,0,0,0,13,1.51Z"/>\n            <path class="cls-3" d="M13,1.51A11.06,11.06,0,0,0,2,12.62a13.21,13.21,0,0,0,2.7,7.32l.79,1.17c2.51,3.72,12.53,3.72,15,0l.79-1.17A13.21,13.21,0,0,0,24,12.62,11.06,11.06,0,0,0,13,1.51Z"/>\n            <ellipse class="cls-4" cx="13" cy="12.72" rx="3.15" ry="3.18"/>\n            <g class="cls-5">\n                <path class="cls-6" d="M14.24,40.43H11.75V40c0-9.54-3.78-15.15-6.28-18.86l-.78-1.18A13.21,13.21,0,0,1,2,12.62a11,11,0,1,1,22,0,13.21,13.21,0,0,1-2.69,7.33l-.79,1.17C18,24.83,14.24,30.44,14.24,40Zm-2-.51h1.48c0-9.67,3.84-15.33,6.37-19.09l.79-1.17a12.75,12.75,0,0,0,2.6-7.07,10.5,10.5,0,1,0-21,0,12.74,12.74,0,0,0,2.6,7.07l.81,1.17c2.53,3.76,6.35,9.42,6.36,19.09Z"/>\n            </g>\n        \'</svg>\n    '},n={config:{name:"square",size:{x:22,y:22},anchor:{x:11,y:22}},svg:'\n        <svg data-shape="square" class="marker-legend-icon" id="markerSquare" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 24 24">\n            <style type="text/css">.st0{fill:#FFFFFF;}.st1{fill:__COLOR__;}.st2{fill:url(#SVGID_1_);}.st3{opacity:0.7;fill:url(#SVGID_2_);enable-background:new;}.st4{opacity:0.6;}.st5{fill:url(#SVGID_3_);}.st6{fill:url(#SVGID_4_);}.st7{opacity:0.7;fill:url(#SVGID_5_);enable-background:new;}.st8{fill:url(#SVGID_6_);}.st9{fill:url(#SVGID_7_);}.st10{opacity:0.7;fill:url(#SVGID_8_);enable-background:new;}.st11{fill:url(#SVGID_9_);}.st12{fill:url(#SVGID_10_);}.st13{fill:url(#SVGID_11_);}.st14{opacity:0.7;fill:url(#SVGID_12_);enable-background:new;}</style>\n            <g>\n                <g>\n                    <g>\n                        <path class="st0" d="M23.5,23.5h-23v-23h23V23.5z M1.5,22.5h21v-21h-21V22.5z"/>\n                    </g>\n                    <rect x="1" y="1" class="st1" width="22" height="22"/>\n                    <linearGradient id="SVGID_1_" gradientUnits="userSpaceOnUse" x1="12" y1="1" x2="12" y2="20.0789">\n                        <stop offset="0.19" style="stop-color:#FFFFFF;stop-opacity:0.25"/>\n                        <stop offset="0.92" style="stop-color:#FFFFFF;stop-opacity:0"/>\n                    </linearGradient>\n                    <rect x="1" y="1" class="st2" width="22" height="19.1"/>\n                    <linearGradient id="SVGID_2_" gradientUnits="userSpaceOnUse" x1="8.85" y1="1118" x2="15.15" y2="1118" gradientTransform="matrix(1 0 0 1 0 -1106)">\n                        <stop offset="0" style="stop-color:#000000"/>\n                        <stop offset="1" style="stop-color:#000000"/>\n                    </linearGradient>\n                    <ellipse class="st3" cx="12" cy="12" rx="3.1" ry="3.2"/>\n                </g>\n                <g class="st4">\n                    <linearGradient id="SVGID_3_" gradientUnits="userSpaceOnUse" x1="1" y1="12" x2="23" y2="12">\n                        <stop offset="0" style="stop-color:#000000"/>\n                        <stop offset="1" style="stop-color:#000000"/>\n                    </linearGradient>\n                    <path class="st5" d="M23,23H1V1h22V23z M1.5,22.5h21v-21h-21V22.5z"/>\n                </g>\n            </g>\n        </svg>\n    '},i={config:{name:"triangle",size:{x:22,y:36},anchor:{x:11,y:36}},svg:'\n        <svg data-shape="triangle" class="marker-legend-icon" id="markerTriangle" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 26 23">\n            <style type="text/css">.st0{fill:#FFFFFF;}.st1{fill:__COLOR__;}.st2{fill:url(#SVGID_1_);}.st3{opacity:0.7;fill:url(#SVGID_2_);enable-background:new;}.st4{opacity:0.6;}.st5{fill:url(#SVGID_3_);}.st6{fill:url(#SVGID_4_);}.st7{opacity:0.7;fill:url(#SVGID_5_);enable-background:new;}.st8{fill:url(#SVGID_6_);}.st9{fill:url(#SVGID_7_);}.st10{opacity:0.7;fill:url(#SVGID_8_);enable-background:new;}.st11{fill:url(#SVGID_9_);}.st12{fill:url(#SVGID_10_);}.st13{fill:url(#SVGID_11_);}.st14{opacity:0.7;fill:url(#SVGID_12_);enable-background:new;}</style>\n            <g>\n                <g>\n                    <g>\n                        <g>\n                            <path class="st0" d="M25.5,22.5h-25L13,0.5L25.5,22.5z M2.3,21.5h21.4L13,2.6L2.3,21.5z"/>\n                        </g>\n                    </g>\n                    <g>\n                        <path class="st1" d="M24.6,22H1.4L13,1.6L24.6,22z"/>\n                    </g>\n                    <g>\n                        <linearGradient id="SVGID_1_" gradientUnits="userSpaceOnUse" x1="13.0105" y1="1.5601" x2="13.0105" y2="18.95">\n                            <stop offset="0.19" style="stop-color:#FFFFFF;stop-opacity:0.25"/>\n                            <stop offset="0.92" style="stop-color:#FFFFFF;stop-opacity:0"/>\n                        </linearGradient>\n                        <path class="st2" d="M22.9,19H3.1L13,1.6L22.9,19z"/>\n                    </g>\n                    <g class="st4">\n                        <linearGradient id="SVGID_2_" gradientUnits="userSpaceOnUse" x1="1.3924" y1="11.7748" x2="24.6076" y2="11.7748">\n                            <stop offset="0" style="stop-color:#000000"/>\n                            <stop offset="1" style="stop-color:#000000"/>\n                        </linearGradient>\n                        <path style="fill:url(#SVGID_2_);" d="M13,2.6l10.7,18.9H2.3L13,2.6 M13,1.6L1.4,22h23.2L13,1.6L13,1.6z"/>\n                    </g>\n                </g>\n                    <linearGradient id="SVGID_3_" gradientUnits="userSpaceOnUse" x1="10.125" y1="1120.644" x2="15.875" y2="1120.644" gradientTransform="matrix(1 0 0 1 0 -1106)">\n                    <stop offset="0" style="stop-color:#000000"/>\n                    <stop offset="1" style="stop-color:#000000"/>\n                </linearGradient>\n                <ellipse style="opacity:0.7;fill:url(#SVGID_3_);enable-background:new;" cx="13" cy="14.6" rx="2.9" ry="2.9"/>\n            </g>\n        </svg>\n    '},o=class{constructor(t){return this.options={type:"pin",color:"#f44336"},this.options=Object.assign(this.options,t),this.shape=a[this.options.type.toLowerCase()],this}getSVG(t){const s=this.shape.svg.replace(/__COLOR__/g,t||this.options.color);return`data:image/svg+xml;base64,${btoa(s)}`}},c={methods:{$__svg:(t,s)=>new o({type:t,color:s}).getSVG()}}},4046:(t,s,e)=>{e.r(s),e.d(s,{default:()=>f});var a=e(2646),l=e(3088),r=e(4890),n=e(1402);const i={components:{Modal:a.u_},props:{record:{type:Object,required:!0}},data:()=>({isLoading:!1}),methods:{async deleteConfig(){this.isLoading=!0;try{const t=await r.Z.delete(this.record.Id),{error:s,deleteResult:{success:e=!1}={}}=t;!s&&e?this.$bus.$emit("refresh-custom-nearby-configs"):this.$root.$emit("toast",{message:s,state:"error"})}catch(t){this.$root.$emit("toast",{message:t.message,state:"error"})}finally{this.isLoading=!1}}}};var o=e(1900);const c=(0,o.Z)(i,(function(){var t=this,s=t._self._c;return s("Modal",{attrs:{isLoading:t.isLoading,title:"Delete Setting"},on:{close:function(s){return t.$emit("close")}}},[s("template",{slot:"content"},[t._v("\n        "+t._s(t.$Labels.NearbyMaps_Delete_Setting)+"\n    ")]),t._v(" "),s("template",{slot:"footer"},[s("button",{staticClass:"slds-button slds-button_neutral",on:{click:function(s){return t.$emit("close")}}},[t._v("\n            "+t._s(t.$Labels.MA_Cancel)+"\n        ")]),t._v(" "),s("button",{staticClass:"slds-button slds-button_brand",on:{click:t.deleteConfig}},[t._v("\n            "+t._s(t.$Labels.MA_Delete)+"\n        ")])])],2)}),[],!1,null,null,null).exports;var d=e(1222);const{MASystem:_}=window,p={components:{DeleteConfig:c,ActionMenu:a.PC,ActionMenuItem:a.F9},mixins:[d.Z],props:{data:{type:Object,required:!0}},data:()=>({renderDeleteModal:!1,sitePrefix:_.MergeFields.SitePrefix,orgId:_.MergeFields.Organization_Id}),computed:{isCustom(){return this.data.record.maps__Is_Custom__c},recordName(){return this.data.record.maps__Name__c},isCustomMarker(){return this.data.options.config},layerMarkers(){if(!this.data.options.config)return[];const t=[];function s(s){const{name:e="No Label",marker:{imgURL:a,type:l="pin",color:r="#000000"}={}}=s||{};t.push({imgURL:((t,s,e)=>a?"015"===a.substring(0,3)?`${t}/servlet/servlet.ImageServer?id=${a}&oid=${s}`:`/sfc/servlet.shepherd/version/download/${a}`:e(l,r))(this.sitePrefix,this.orgId,this.$__svg),label:e,type:l})}return s.call(this,this.data.options.config.context),(this.data.options.config.layers||[]).forEach(s.bind(this)),t}},methods:{copy(){const t=document.createElement("input");t.value=this.getVFCode(),document.body.appendChild(t),t.select(),document.execCommand("copy"),document.body.removeChild(t)},getVFCode(){return`\n                    <apex:page standardController="${this.data.record.maps__Object__c}" showHeader="false" sidebar="false">\n                        <style>html, body {height: 100%;width: 100%;}.ma-iframe-wrapper {width: 100%;height: 100%;}.ma-iframe-wrapper > iframe {width: 100%;height: 100%;}</style>\n                        <div class="ma-iframe-wrapper">\n                            <iframe src="{!$Page.maps__Nearby}?rid={!$CurrentPage.parameters.id}&mmid=${this.data.record.Id}"></iframe>\n                        </div>\n                    </apex:page>\n                `},editConfig(){this.$bus.$emit("render-nearby-modal",this.data)},deleteConfig(){this.renderDeleteModal=!0}}},u=p,g={components:{Card:(0,o.Z)(u,(function(){var t=this,s=t._self._c;return s("article",{staticClass:"slds-card slds-card--narrow slds-card_boundary"},[s("div",{staticClass:"slds-card__header"},[s("header",{staticClass:"slds-media slds-media--center slds-has-flexi-truncate"},[s("div",{staticClass:"slds-media__body"},[s("div",{staticClass:"slds-grid"},[s("div",{staticClass:"slds-col slds-has-flexi-truncate",staticStyle:{"padding-top":"7px"}},[s("h2",[s("span",{staticClass:"slds-text-heading--small"},[t._v(t._s(t.recordName))])])]),t._v(" "),t.isCustom?s("ActionMenu",[s("button",{staticClass:"slds-button slds-button_icon slds-button_icon-border-filled slds-button_icon-x-small",attrs:{slot:"button","aria-haspopup":"true"},slot:"button"},[s("span",{staticClass:"slds-button__icon ma-icon ma-icon-down"}),t._v(" "),s("span",{staticClass:"slds-assistive-text"},[t._v("More Options")])]),t._v(" "),s("ActionMenuItem",{attrs:{label:t.$Labels.NearbyMaps_Copy_VisualForce_Code},on:{click:t.copy}}),t._v(" "),s("ActionMenuItem",{attrs:{label:t.$Labels.MA_Edit},on:{click:t.editConfig}}),t._v(" "),s("ActionMenuItem",{attrs:{label:t.$Labels.MA_Delete},on:{click:t.deleteConfig}})],1):t._e()],1)])])]),t._v(" "),s("div",{staticClass:"slds-card__body"},[s("div",{staticClass:"slds-card__body--inner mm-card-layers slds-p-horizontal_large"},[t._l(t.data.errors,(function(e,a){return s("div",{key:a,staticClass:"slds-tile"},[s("div",{staticClass:"title-marker-icon mm-card-layer-marker"}),t._v(" "),s("h3",{staticClass:"slds-truncate mm-card-layer-title",staticStyle:{color:"red"}},[t._v("\n                    "+t._s(e)+"\n                ")])])})),t._v(" "),t._l(t.layerMarkers,(function(e,a){return s("div",{key:a,staticClass:"slds-tile"},[s("div",{staticClass:"title-marker-icon"},[s("img",{attrs:{id:"svgCardIcon__"+e.type,src:e.imgURL}})]),t._v(" "),s("h3",{staticClass:"slds-truncate"},[t._v("\n                    "+t._s(e.label)+"\n                ")])])})),t._v(" "),t.isCustomMarker?t._e():t._l(t.data.options.layers,(function(e,a){return s("div",{key:a,staticClass:"slds-tile"},[s("div",{staticClass:"title-marker-icon"},[s("img",{attrs:{id:"svgCardIcon__"+e.marker.type,src:t.$__svg(e.marker.type,e.marker.color)}})]),t._v(" "),s("h3",{staticClass:"slds-truncate"},[t._v("\n                        "+t._s(e.label)+"\n                    ")])])}))],2)]),t._v(" "),t.renderDeleteModal?s("DeleteConfig",{attrs:{record:t.data.record},on:{close:function(s){t.renderDeleteModal=!1}}}):t._e()],1)}),[],!1,null,"61649ef2",null).exports,Tooltip:a.u,Spinner:a.$j},props:{type:{type:l.Jr,required:!0}},data:()=>({isLoading:!1,data:[],securityError:!1}),computed:{isCustom(){return n.yQ.CUSTOM.equals(this.type)},info(){return this.isCustom?this.$Labels.NearbyMaps_Custom_Nearby_Tooltip:this.$Labels.NearbyMaps_Default_Nearby_Tooltip},title(){return this.isCustom?this.$Labels.NearbyMaps_Custom_Nearby_Maps:this.$Labels.NearbyMaps_Default_Nearby_Maps}},watch:{securityError(){this.securityError&&this.$emit("securityError")}},created(){this.loadSettings(),this.type===n.yQ.CUSTOM&&this.$bus.$on("refresh-custom-nearby-configs",this.loadSettings)},destroyed(){this.$bus.$off("refresh-custom-nearby-configs")},methods:{async loadSettings(){this.isLoading=!0;try{const{records:t,securityError:s,success:e,message:a}=await r.Z.read(this.isCustom);e?(s&&this.$root.$emit("toast",{message:a,state:"warning"}),this.data=t,this.data=this.data.filter((t=>0===t.errors.length)),this.data=this.data.sort(((t,s)=>t.record.Name.toLowerCase()>s.record.Name.toLowerCase()?1:-1))):s&&(this.securityError=!0,this.$root.$emit("toast",{message:a,state:"error"}))}catch(t){this.$root.$emit("toast",{message:t.message,state:"error"})}finally{this.isLoading=!1}}}},f=(0,o.Z)(g,(function(){var t=this,s=t._self._c;return s("div",{staticClass:"wrapper"},[s("div",{staticClass:"slds-section slds-is-open"},[s("h3",{staticClass:"slds-section__title slds-theme_shade"},[s("span",{staticClass:"slds-truncate slds-p-horizontal_small",attrs:{title:"Section Title"}},[t._v("\n                "+t._s(t.title)+"\n            ")]),t._v(" "),s("Tooltip",{attrs:{text:t.info,assistiveText:t.info}}),t._v(" "),s("button",{staticClass:"slds-m-left_small slds-button",on:{click:t.loadSettings}},[t._v("\n                "+t._s(t.$Labels.MA_REFRESH)+"\n            ")])],1),t._v(" "),t.isCustom?s("article",{staticClass:"slds-card slds-card--narrow add-new-card",on:{click:function(s){return t.$bus.$emit("render-nearby-modal")}}},[s("div",{staticClass:"slds-card__body"},[s("svg",{attrs:{xmlns:"http://www.w3.org/2000/svg",width:"65",height:"65",viewBox:"0 0 52 52"}},[s("path",{attrs:{fill:"#fff",d:"m30 29h16.5c0.8 0 1.5-0.7 1.5-1.5v-3c0-0.8-0.7-1.5-1.5-1.5h-16.5c-0.6 0-1-0.4-1-1v-16.5c0-0.8-0.7-1.5-1.5-1.5h-3c-0.8 0-1.5 0.7-1.5 1.5v16.5c0 0.6-0.4 1-1 1h-16.5c-0.8 0-1.5 0.7-1.5 1.5v3c0 0.8 0.7 1.5 1.5 1.5h16.5c0.6 0 1 0.4 1 1v16.5c0 0.8 0.7 1.5 1.5 1.5h3c0.8 0 1.5-0.7 1.5-1.5v-16.5c0-0.6 0.4-1 1-1z"}})]),t._v(" "),s("p",{staticClass:"slds-text-heading--small"},[t._v("\n                    "+t._s(t.$Labels.NearbyMaps_Create_Nearby_Map)+"\n                ")])])]):t._e(),t._v(" "),t._l(t.data,(function(t){return s("Card",{key:t.record.Id,attrs:{data:t}})}))],2),t._v(" "),t.isLoading?s("Spinner"):t._e()],1)}),[],!1,null,"1f782fca",null).exports}}]);