(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[376],{2855:(e,t,s)=>{e.exports=s.p+"images/3c625a8f719075e844442ec810b32c3f.svg"},3528:(e,t,s)=>{"use strict";s.r(t),s.d(t,{default:()=>u});var l=s(5908),o=s(5493);const a={components:{ScheduleQueue:()=>s.e(7135).then(s.bind(s,944))},computed:{...(0,l.mapGetters)("schedule",{schedule__onMap:"onMap",schedule__date:"date"}),mapButtonText(){return this.schedule__onMap?this.$Labels.MA_REMOVE_FROM_MAP:this.$Labels.Schedule_Map_My_Schedule_Tooltip_Text}},methods:{...(0,l.mapMutations)("schedule",{schedule__loadingToggle:"loadingToggle",schedule__setStateMobile:"updateMobileStateSchedule"}),...(0,l.mapActions)("schedule",{schedule__buildRoute:"buildRoute",schedule__removeRoute:"removeRoute"}),generateRoute(e=!1){let t=!0;window.trackUsage("Maps",{action:"Plot Schedule",description:"Plotting a Schedule"}),this.doDisableOptimizationDueToInvalidDuration()?window.MAToastMessages.showError({message:this.$Labels.Schedule_Error_Event_Duration}):(this.schedule__loadingToggle(!0),this.$bus.$emit("remove-route"),this.schedule__buildRoute({doOptimize:e}).then((()=>{window.MAToastMessages.showSuccess({message:this.$Labels.MA_Success})})).catch((()=>{t=!1})).finally((()=>{this.schedule__loadingToggle(!1),this.setScheduleMobileState({dateString:this.schedule__date.format("YYYY-MM-DD"),schedulePlotted:t})})))},removeSchedule(){this.schedule__removeRoute(),this.setScheduleMobileState({dateString:this.schedule__date.format("YYYY-MM-DD"),schedulePlotted:!1})},doDisableOptimizationDueToInvalidDuration:()=>!!o.default.duration&&o.default.duration<15,setScheduleMobileState(e){this.schedule__setStateMobile(e),window.setMobileState()}}},u=(0,s(1900).Z)(a,(function(){var e=this,t=e._self._c;return t("div",{staticClass:"schedule-footer slds-is-relative slds-border_top"},[t("ScheduleQueue",{on:{"generate-route":function(t){return e.generateRoute(!0)}}}),e._v(" "),t("div",{staticClass:"slds-p-horizontal_medium slds-p-vertical_small"},[e.schedule__onMap?t("button",{staticClass:"slds-button slds-button_neutral",on:{click:e.removeSchedule}},[e._v("\n            "+e._s(e.$Labels.MA_REMOVE_FROM_MAP)+"\n        ")]):t("button",{staticClass:"slds-button slds-button_brand slds-button_stretch",on:{click:function(t){return e.generateRoute(!1)}}},[t("MAIcon",{attrs:{iconClass:["slds-button__icon","slds-button__icon_left"],src:s(2855)}}),e._v(" "),t("span",[e._v(e._s(e.$Labels.Schedule_Map_My_Schedule_Tooltip_Text))])],1)])],1)}),[],!1,null,"6f9b16f6",null).exports}}]);