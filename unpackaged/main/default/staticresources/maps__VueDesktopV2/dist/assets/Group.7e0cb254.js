import{_ as m,ai as u,r as c,o as s,c as o,e as l,j as b,t as i,b as f,F as _,q as $,s as h,ao as y,h as a,Y as v,a7 as g,a0 as k}from"../bundle.js";import{B}from"./Radio.2202254f.js";const R={name:"RadioGroup",extends:B,mixins:[u]},T={key:0,class:"slds-form-element__label"},V=["title"],q={key:2,class:"slds-form-element__control",style:{position:"relative"}},H=["id","name","value","disabled","aria-describedby"],L=["for"],C=a("span",{class:"slds-radio_faux"},null,-1),N={class:"slds-form-element__label"},D={key:3,class:"slds-form-element__control readonly-radio-label"},F=["id"];function G(e,t,S,j,w,z){const n=c("Tooltip");return s(),o("fieldset",{class:k([{"slds-has-error":e.$props.invalid},"slds-form-element"])},[e.computedLabels.name?(s(),o("label",T,[e.$props.required?(s(),o("abbr",{key:0,class:"slds-required",title:e.computedLabels.required},"*",8,V)):l("",!0),b(" "+i(e.decodeHtml(e.computedLabels.name)),1)])):l("",!0),e.$props.helpText?(s(),f(n,{key:1,alignment:"top right",class:"slds-form-element__icon",text:e.$props.helpText},null,8,["text"])):l("",!0),e.$props.readonly?(s(),o("div",D,i(e.decodeHtml(e.$props.modelValue)||"\xA0"),1)):(s(),o("div",q,[(s(!0),o(_,null,$(e.options,(r,d)=>(s(),o("span",{key:d,class:"slds-radio"},[h(a("input",v(e.$props.inputAttrs,{id:e.guid+d,"onUpdate:modelValue":t[0]||(t[0]=p=>e.input=p),name:e.guid,value:r.value,disabled:e.$props.disabled||r.disabled,"aria-describedby":e.$props.invalid?`error-${e.guid}`:null,type:"radio"}),null,16,H),[[y,e.input]]),a("label",{for:e.guid+d,class:"slds-radio__label"},[C,a("span",N,i(e.decodeHtml(r.label)),1)],8,L)]))),128))])),e.$props.invalid?(s(),o("div",{key:4,id:`error-${e.guid}`,class:"slds-form-element__help"},[g(e.$slots,"errors")],8,F)):l("",!0)],2)}const M=m(R,[["render",G]]);export{M as R};