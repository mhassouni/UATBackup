"use strict";(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[3323],{706:(t,a,e)=>{e.r(a),e.d(a,{default:()=>i});var s=e(7813);const c={props:{tabId:{type:String,default:"details"}},data:()=>({accuracy:"",latitude:"",longitude:""}),computed:{accuracyValueText(){return this.accuracy?(0,s.N4)(this.$Labels.Mobile_Marker_Accuracy_Value,[this.accuracy]):""}},created(){const{myCachedPositionInfo:t={}}=window,{coords:a={}}=t;this.accuracy=a.accuracy,this.latitude=a.latitude,this.longitude=a.longitude}},i=(0,e(1900).Z)(c,(function(){var t=this,a=t._self._c;return a("div",{staticClass:"ma-tab-content-group"},[a("div",{directives:[{name:"show",rawName:"v-show",value:"details"===t.tabId,expression:"tabId === 'details'"}],staticClass:"ma-tab-content active"},[a("div",{staticClass:"tooltip-segment-item"},[a("label",[t._v(t._s(t.$Labels.Mobile_Marker_Accuracy))]),t._v(t._s(t._f("decode")(t.accuracyValueText))+"\n        ")]),t._v(" "),a("div",{staticClass:"tooltip-segment-item"},[a("label",[t._v(t._s(t.$Labels.MA_Latitude))]),t._v(t._s(t._f("decode")(t.latitude))+"\n        ")]),t._v(" "),a("div",{staticClass:"tooltip-segment-item"},[a("label",[t._v(t._s(t.$Labels.MA_Longitude))]),t._v(t._s(t._f("decode")(t.longitude))+"\n        ")])])])}),[],!1,null,null,null).exports}}]);