import{_ as y,O as M,P as g,a5 as O,bb as $,r as i,o as r,c as L,i as l,w as m,b as I,e as V}from"../bundle.js";import{u as v}from"./index.d251dbc7.js";import{c as n,r as B,i as x,b as H}from"./index.0172543b.js";const u=e=>n.withParams({type:"minIntegerValue",minInteger:e},t=>B.$validator(t)&&x.$validator(t)&&H(e).$validator(t)),f={name:"HeatMapOptions",components:{TextInput:M,Picklist:g,Checkbox:O},validations(){return{options:{heatmapRadius:{minIntegerValue:n.withMessage(this.$Labels.modal_MLB_Input_Error_Positive_Integer,u(1))},heatmapMaxIntensity:{minIntegerValue:n.withMessage(this.$Labels.modal_MLB_Input_Error_Positive_Integer,u(1))}}}},props:{options:{type:Object,required:!0},metadataBaseObjectFields:{type:Array,default:null}},emits:["form-validation"],setup(){return{v$:v()}},data(){return{selectedOpacity:"",selectedWeight:"",generatedId:$()}},computed:{opacityOptions(){const e=[];for(let t=5;t<=95;t+=5)e.push({title:`${t}%`,value:(t/100).toFixed(2)});return e.push({title:"100%",value:"1"}),e},baseObjectFields(){const e=["double","integer"];return[{apiName:"None",label:`--${this.$Labels.MA_None}--`}].concat(this.$props.metadataBaseObjectFields.filter(t=>e.includes(t.soapType)))},opacitySelected:{get(){return this.selectedOpacity},set(e){this.$props.options.heatmapOpacity=e,this.selectedOpacity=e}},weightSelected:{get(){return this.selectedWeight},set(e){this.$props.options.heatmapWeightedValue=e,this.selectedWeight=e}}},created(){this.opacitySelected=this.$props.options.heatmapOpacity,this.weightSelected=this.$props.options.heatmapWeightedValue}};function k(e,t,R,o,_,s){const p=i("TextInput"),d=i("Picklist"),c=i("Checkbox"),b=i("LayoutItem"),h=i("Layout");return r(),L("div",null,[l(h,null,{default:m(()=>[l(b,null,{default:m(()=>[l(p,{modelValue:o.v$.options.heatmapRadius.$model,"onUpdate:modelValue":t[0]||(t[0]=a=>o.v$.options.heatmapRadius.$model=a),inputAttrs:{id:"mlbHeatMapUnitRadiusResource"},labels:{name:e.$Labels.modal_MLB_option_DO_section_HeatMap_modal_Radius_Input_Label},errors:e.$getErrorsByField(o.v$.options.heatmapRadius)},null,8,["modelValue","labels","errors"]),l(d,{modelValue:s.opacitySelected,"onUpdate:modelValue":t[1]||(t[1]=a=>s.opacitySelected=a),inputAttrs:{id:"mlbProxOpacityOptionResource"},labels:{name:e.$Labels.modal_MLB_option_DO_section_HeatMap_modal_Opacity_Picklist_Label},options:s.opacityOptions,idKey:"value"},null,8,["modelValue","labels","options"]),l(p,{modelValue:o.v$.options.heatmapMaxIntensity.$model,"onUpdate:modelValue":t[2]||(t[2]=a=>o.v$.options.heatmapMaxIntensity.$model=a),inputAttrs:{id:"mlbHeatMapMaxIntensityResource"},labels:{name:e.$Labels.modal_MLB_option_DO_section_HeatMap_modal_Max_Intensity_Input_Label},helpText:e.$Labels.modal_MLB_option_DO_section_HeatMap_modal_Max_Intensity_Input_Tooltip,errors:e.$getErrorsByField(o.v$.options.heatmapMaxIntensity),class:"slds-p-bottom_xx-small",style:{"z-index":"2"}},null,8,["modelValue","labels","helpText","errors"]),l(c,{modelValue:e.$props.options.heatmapDissipating,"onUpdate:modelValue":t[3]||(t[3]=a=>e.$props.options.heatmapDissipating=a),inputAttrs:{id:`mlbHeatMapFadeHeatChxResource${_.generatedId}`},labels:{name:e.$Labels.modal_MLB_option_DO_section_HeatMap_modal_Fade_Zoom_Checkbox_Label}},null,8,["modelValue","inputAttrs","labels"]),e.$props.metadataBaseObjectFields?(r(),I(d,{key:0,modelValue:s.weightSelected,"onUpdate:modelValue":t[4]||(t[4]=a=>s.weightSelected=a),inputAttrs:{id:"mlbHeatMapWeightValueOptionResource"},labels:{name:e.$Labels.modal_MLB_option_DO_section_HeatMap_modal_Weighted_Value_Picklist_Label},options:s.baseObjectFields,idKey:"apiName",titleKey:"label"},null,8,["modelValue","labels","options"])):V("",!0)]),_:1})]),_:1})])}const S=y(f,[["render",k]]);export{S as H,u as m};