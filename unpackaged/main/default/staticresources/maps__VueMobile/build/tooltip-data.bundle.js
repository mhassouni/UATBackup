"use strict";(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[6660],{2632:(t,e,a)=>{a.r(e),a.d(e,{default:()=>i});var s=a(5908);const o={components:{},props:{tabId:{type:String,default:"notes"}},data:()=>({tooltipTabs:[]}),computed:{...(0,s.mapGetters)("tooltip",{tooltip__record:"record"})},created(){this.createDynamicTabs()},methods:{createDynamicTabs(){const{data:t={}}=this.tooltip__record,{popup:e={}}=t,{header:a=[],tabs:s=[]}=e;this.tooltipTabs.push({id:"header",rows:a}),s.forEach((t=>{this.tooltipTabs.push({id:t.tab_id,rows:t.data})}))}}},i=(0,a(1900).Z)(o,(function(){var t=this,e=t._self._c;return e("div",{staticClass:"ma-tab-content-group"},t._l(t.tooltipTabs,(function(a,s){return e("div",{directives:[{name:"show",rawName:"v-show",value:t.tabId===a.id,expression:"tabId === tab.id"}],key:s,staticClass:"ma-tab-content",class:{active:t.tabId===a.id}},t._l(a.rows,(function(a,s){return e("div",{key:s,staticClass:"tooltip-segment-item"},[String(a.formatted_value).indexOf("href=")>-1?e("div",[e("label",[t._v(t._s(t._f("decode")(a.label)))]),t._v(" "),e("a",{attrs:{href:"http://"===a.value.substring(0,7)||"https://"===a.value.substring(0,8)?a.value:`http://${a.value}`,target:"_blank"}},[t._v("\n                    "+t._s(t._f("decode")(a.value))+"\n                ")])]):e("div",[e("label",[t._v(t._s(t._f("decode")(a.label)))]),t._v("\n                "+t._s(t._f("decode")(a.formatted_value))+"\n            ")])])})),0)})),0)}),[],!1,null,null,null).exports}}]);