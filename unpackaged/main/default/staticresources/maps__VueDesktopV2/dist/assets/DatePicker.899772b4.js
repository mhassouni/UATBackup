import{_ as O,B as S,T as Y,aB as E,ai as N,ac as B,aC as A,r as C,aD as L,o,c as u,h as l,e as b,j as V,t as g,b as W,s as T,aE as P,Y as q,i as x,a6 as m,v as H,a0 as w,a8 as h,F as v,q as k,aF as U}from"../bundle.js";function M({firstDayOfWeek:e=0}={}){const t=[];let r=e;for(let d=0;d<7;d++)t.push(r),r++,r>6&&(r=0);return t}function j({locale:e="en-US",weekday:t="long",firstDayOfWeek:r=0}={}){const{format:d}=new Intl.DateTimeFormat(e,{weekday:t});return M({firstDayOfWeek:r}).map(c=>d(new Date(2021,10,c,0,0,0,0)))}function I(e,t){e.setMonth(e.getMonth()-t)}function K(e,t){e.setMonth(e.getMonth()+t)}function _(e){return new Date(e.getFullYear(),e.getMonth()+1,0).getDate()}const R=()=>({name:null,nextMonthTitle:"Next Month",nextMonthAssistiveText:"Next Month",pickYear:"Pick a Year",previousMonthTitle:"Previous Month",previousMonthAssistiveText:"Previous Month",selectDateTitle:"Select a Date",selectDateAssistiveText:"Select a Date",today:"Today",required:"Required"}),G={name:"DatePicker",components:{ButtonIcon:S,Tooltip:Y},directives:{"click-outside":E},mixins:[N],props:{alignRight:Boolean,dateDisabled:{type:Function,default:null},dateFormat:{type:Object,default:null},detach:Boolean,displayAsStatic:Boolean,errors:{type:Array,default:()=>[]},firstDayOfWeek:{type:Number,default:0},helpText:{type:String,default:""},inputAttrs:{type:Object,default:()=>{}},labels:{type:Object,default:()=>{}},locale:{type:String,required:!0},modelValue:{type:Object,default:null},numYearsInFuture:{type:Number,default:4},numYearsInPast:{type:Number,default:1},readonly:Boolean,required:Boolean,refToIgnoreClickOutside:{type:HTMLElement,default:null},showCalendarSync:Boolean,showInputField:{type:Boolean,default:!0}},data(){return{month:"",year:"",date:null,showCalendar:!1,weeks:[],currentFocusedDate:null,popperInstance:null,errorId:B()}},computed:{computedLabels(){const e=Object.hasOwn(this,"$__getGlobalLabels")?this.$__getGlobalLabels().datePicker||{}:{};return{...R(),...e,...this.$props.labels}},hasErrors(){return this.$props.errors.length},anchorRef(){return this.refToIgnoreClickOutside||this.$refs.date},years(){const e=[];for(let t=this.year-this.numYearsInPast;t<=this.year+this.numYearsInFuture;t++)e.push(t);return e},formattedDate(){return this.$props.modelValue?new Intl.DateTimeFormat(this.$props.locale||"en-US",this.$props.dateFormat||{}).format(this.$props.modelValue):null},daysOfWeek(){return j({locale:this.$props.locale||"en-US",weekday:"short",firstDayOfWeek:this.$props.firstDayOfWeek})},clickOutsideOptions(){return{active:!0,handler:this.doHide}}},watch:{modelValue(e){e&&(this.date=new Date(e)),this.displayAsStatic&&this.render()},showCalendar(e){e?(this.date=this.$props.modelValue?new Date(this.$props.modelValue):new Date,this.render(),this.renderCalendar()):this.popperInstance&&this.popperInstance.destroy()},showCalendarSync(e){this.showCalendar=e},locale(){this.render()},readonly(e){e&&(this.showCalendar=!1)}},created(){this.date=this.$props.modelValue?new Date(this.$props.modelValue):new Date,this.showCalendar=this.displayAsStatic},methods:{setYear(){this.date.setFullYear(this.year),this.render()},render(e){this.month=new Intl.DateTimeFormat(this.$props.locale||"en-US",{month:"long"}).format(this.date),this.year=this.date.getFullYear(),this.setWeeks(e),this.popperInstance&&this.popperInstance.update()},doHide(e){if(!this.$props.displayAsStatic){if(e){const t=document.getElementById("dateInput");if(e.target===this.refToIgnoreClickOutside||e.target===t)return;let r=e.target.parentNode;for(;r;){if(r===this.refToIgnoreClickOutside||r===t)return;r=r.parentNode}}this.showCalendar=!1,this.setFocusOnElement(this.anchorRef),this.$emit("update:showCalendarSync",!1)}},async select(e){!e||e.disabled||(this.$emit("update:modelValue",e.date),await this.$nextTick(),this.doHide())},previous(e){I(this.date,1),this.render(e)},next(e){K(this.date,1),this.render(e)},previousYear(){this.date.setFullYear(this.date.getFullYear()-1),this.render()},nextYear(){this.date.setFullYear(this.date.getFullYear()+1),this.render()},today(){const e=new Date;this.select({date:e}),this.date=e},setWeeks(e){this.currentFocusedDate&&(this.currentFocusedDate.tabIndex=-1),this.weeks=[];const t=new Date,r=new Date(this.date);let d=[];r.setDate(1);const c=M({firstDayOfWeek:this.$props.firstDayOfWeek}),s=c.findIndex(n=>n===r.getDay());if(s){const n=new Date(r);I(n,1);const i=_(n),a=s-0-1;for(let p=i-a;p<=i;p++)d.push({value:p,disabled:!0})}for(let n=1;n<=_(r);n++){d.length===7&&(this.weeks.push(d),d=[]);const i=new Date(r);i.setDate(n);const a=this.$props.modelValue||new Date,p=this.$props.dateDisabled?this.$props.dateDisabled(i)??!1:!1;d.push({disabled:p,date:i,value:n,isToday:t.getDate()===i.getDate()&&t.getMonth()===i.getMonth()&&t.getFullYear()===i.getFullYear(),isSelected:a.getDate()===i.getDate()&&a.getMonth()===i.getMonth()&&a.getFullYear()===i.getFullYear()})}r.setDate(_(r));const D=c.findIndex(n=>n===r.getDay());if(D<6){const n=6-D;for(let i=1;i<=n;i++)d.length===7&&(this.weeks.push(d),d=[]),d.push({value:i,disabled:!0})}this.weeks.push(d),setTimeout(()=>{this.currentFocusedDate=this.$refs.dayTable?.querySelector(".slds-is-selected")||this.$refs.dayTable?.querySelector(".slds-is-today")||this.$refs.dayTable?.querySelector("tr").children.item(s),e&&(e.type==="click"||e.key==="Enter"||e.key==="Spacebar")?(this.setFocusOnElement(e.target),this.currentFocusedDate.tabIndex=0):this.setFocusOnElement(this.currentFocusedDate)},0)},onIconClick(){this.formattedDate&&this.$emit("update:modelValue",null),this.showCalendar=!0},onClick(){this.readonly||(this.showCalendar=!0)},setFocusOnElement(e){!e||(e.tabIndex=0,e.focus())},async renderCalendar(){this.$props.displayAsStatic||(await this.$nextTick(),this.$props.detach&&(this.$refs.dropdown.style.display="block"),this.popperInstance=A(this.$refs.date,this.$refs.dropdown,{strategy:"fixed",modifiers:[{name:"offset",options:{offset:({popper:e,reference:t})=>[(e.width-t.width)/2,2]}},{name:"flip",options:{fallbackPlacements:["left","right","top","bottom"]}}]}))},changeFocusedElement(e){this.currentFocusedDate.tabIndex=-1,this.currentFocusedDate=e,this.setFocusOnElement(this.currentFocusedDate)},left(){const e=this.currentFocusedDate.previousElementSibling;e&&this.changeFocusedElement(e)},right(){const e=this.currentFocusedDate.nextElementSibling;e&&this.changeFocusedElement(e)},up(e){const t=this.currentFocusedDate.parentNode.previousElementSibling;t&&this.changeFocusedElement(t.childNodes.item(e+1))},down(e){const t=this.currentFocusedDate.parentNode.nextElementSibling;t&&this.changeFocusedElement(t.childNodes.item(e+1))},home(){this.changeFocusedElement(this.currentFocusedDate.parentNode.childNodes.item(0))},end(){this.changeFocusedElement(this.currentFocusedDate.parentNode.childNodes.item(6))},enter(e){e.disabled||this.select(e)}}},z={key:0},J={key:0,class:"slds-form-element__label",for:"date-input-id"},Q=["title"],X={class:"slds-form-element__control slds-input-has-icon slds-input-has-icon_right"},Z=["placeholder","aria-invalid","aria-describedby"],$=["aria-label"],ee={class:"slds-datepicker__filter slds-grid"},te={class:"slds-datepicker__filter_month slds-grid slds-grid_align-spread slds-grow"},se={class:"slds-align-middle"},ae={"aria-atomic":"true","aria-live":"assertive",class:"slds-align-middle"},re={class:"slds-align-middle"},le={class:"slds-shrink-none"},ie={class:"slds-assistive-text",for:"select-01"},ne={class:"slds-select_container"},oe=["value"],de={"aria-labelledby":"month","aria-multiselectable":"true",class:"slds-datepicker__month",role:"grid"},ue={id:"weekdays"},ce=["title"],he={ref:"dayTable"},pe=["aria-disabled","aria-selected","aria-current","onKeydown","onClick"],me={class:"slds-day"},fe=["id"];function ye(e,t,r,d,c,s){const D=C("Tooltip"),n=C("ButtonIcon"),i=L("click-outside");return o(),u("div",{class:w({"slds-has-error":s.hasErrors}),onKeydown:[t[13]||(t[13]=h(m((...a)=>s.previous&&s.previous(...a),["exact","prevent"]),["page-up"])),t[14]||(t[14]=h(m((...a)=>s.next&&s.next(...a),["exact","prevent"]),["page-down"])),t[15]||(t[15]=h(m((...a)=>s.previousYear&&s.previousYear(...a),["alt","exact","prevent"]),["page-up"])),t[16]||(t[16]=h(m((...a)=>s.nextYear&&s.nextYear(...a),["alt","exact","prevent"]),["page-down"])),t[17]||(t[17]=h(m((...a)=>s.doHide&&s.doHide(...a),["stop"]),["esc"]))]},[l("div",{class:w(["slds-form-element slds-dropdown-trigger slds-dropdown-trigger_click",{"slds-is-open":c.showCalendar}])},[r.showInputField?(o(),u("span",z,[s.computedLabels.name?(o(),u("label",J,[e.$props.required?(o(),u("abbr",{key:0,class:"slds-required",title:s.computedLabels.required},"*",8,Q)):b("",!0),V(" "+g(e.decodeHtml(s.computedLabels.name)),1)])):b("",!0),e.$props.helpText?(o(),W(D,{key:1,class:"slds-form-element__icon",alignment:"top right",text:e.$props.helpText},null,8,["text"])):b("",!0),l("div",X,[T(l("input",q({ref:"date","onUpdate:modelValue":t[0]||(t[0]=a=>s.formattedDate=a),placeholder:s.computedLabels.selectDate,type:"text",class:["slds-input",{"standard-input":!r.readonly}],"aria-invalid":!!e.$props.errors.length,"aria-describedby":e.$props.errors.length?c.errorId:null,readonly:""},e.$props.inputAttrs,{onClick:t[1]||(t[1]=(...a)=>s.onClick&&s.onClick(...a))}),null,16,Z),[[P,s.formattedDate]]),x(n,{class:"slds-input__icon",title:s.computedLabels.selectDateTitle,assistiveText:s.computedLabels.selectDateAssistiveText,iconCategory:"utility",iconName:s.formattedDate?"clear":"event",onClick:m(s.onIconClick,["stop"])},null,8,["title","assistiveText","iconName","onClick"])])])):b("",!0),c.showCalendar?T((o(),u("div",{key:1,ref:"dropdown","aria-label":"Date picker: "+c.month,class:w([[{"slds-is-static":r.displayAsStatic,"unset-margin":e.$props.detach},r.alignRight?"slds-dropdown_right":"slds-dropdown_left"],"slds-datepicker slds-dropdown"]),role:"dialog"},[l("div",ee,[l("div",te,[l("div",se,[x(n,{ref:"previousButton",title:s.computedLabels.previousMonthTitle,class:"slds-button slds-button_icon slds-button_icon-container",iconCategory:"utility",iconName:"left",assistiveText:s.computedLabels.previousMonthAssistiveText,onKeydown:t[2]||(t[2]=h(m(a=>s.setFocusOnElement(e.$refs.todayButton),["shift","prevent"]),["tab"])),onClick:t[3]||(t[3]=a=>s.previous(a))},null,8,["title","assistiveText"])]),l("h2",ae,g(c.month),1),l("div",re,[x(n,{ref:"nextButton",title:s.computedLabels.nextMonthTitle,class:"slds-button slds-button_icon slds-button_icon-container",iconCategory:"utility",iconName:"right",assistiveText:s.computedLabels.nextMonthAssistiveText,onClick:t[4]||(t[4]=a=>s.next(a))},null,8,["title","assistiveText"])])]),l("div",le,[l("label",ie,g(e.decodeHtml(s.computedLabels.pickYear)),1),l("div",ne,[T(l("select",{"onUpdate:modelValue":t[5]||(t[5]=a=>c.year=a),class:"slds-select",onChange:t[6]||(t[6]=(...a)=>s.setYear&&s.setYear(...a))},[(o(!0),u(v,null,k(s.years,(a,p)=>(o(),u("option",{key:p,value:a},g(a),9,oe))),128))],544),[[U,c.year]])])])]),l("table",de,[l("thead",null,[l("tr",ue,[(o(!0),u(v,null,k(s.daysOfWeek,(a,p)=>(o(),u("th",{key:p},[l("abbr",{title:a},g(a),9,ce)]))),128))])]),l("tbody",he,[(o(!0),u(v,null,k(c.weeks,(a,p)=>(o(),u("tr",{key:p},[(o(!0),u(v,null,k(a,(y,F)=>(o(),u("td",{key:F,class:w({"slds-disabled-text":y.disabled,"slds-is-selected":y.isSelected,"slds-is-today":y.isToday}),"aria-disabled":y.disabled,"aria-selected":y.isSelected,"aria-current":y.isToday,role:"gridcell",onKeydown:[t[7]||(t[7]=h(m((...f)=>s.right&&s.right(...f),["prevent"]),["right"])),t[8]||(t[8]=h(m((...f)=>s.left&&s.left(...f),["prevent"]),["left"])),h(m(f=>s.up(F),["prevent"]),["up"]),h(m(f=>s.down(F),["prevent"]),["down"]),t[9]||(t[9]=h((...f)=>s.home&&s.home(...f),["home"])),t[10]||(t[10]=h((...f)=>s.end&&s.end(...f),["end"])),h(f=>s.enter(y),["enter"])],onClick:f=>s.select(y)},[l("span",me,g(y.value),1)],42,pe))),128))]))),128))],512)]),l("button",{ref:"todayButton",class:"slds-button slds-align_absolute-center slds-text-link",onKeydown:t[11]||(t[11]=h(m(a=>s.setFocusOnElement(e.$refs.previousButton.$el),["exact","prevent"]),["tab"])),onClick:t[12]||(t[12]=(...a)=>s.today&&s.today(...a))},g(e.decodeHtml(s.computedLabels.today)),545)],10,$)),[[H,!e.$props.detach],[i,void 0,s.clickOutsideOptions]]):b("",!0)],2),e.$props.errors.length?(o(),u("div",{key:0,id:c.errorId,class:"slds-form-element__help"},[(o(!0),u(v,null,k(r.errors,(a,p)=>(o(),u("p",{key:p},g(e.decodeHtml(a)),1))),128))],8,fe)):b("",!0)],34)}const be=O(G,[["render",ye],["__scopeId","data-v-1bbd0825"]]);export{be as D};