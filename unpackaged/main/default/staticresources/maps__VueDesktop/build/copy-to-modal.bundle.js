"use strict";(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[532],{6154:(e,t,s)=>{s.r(t),s.d(t,{default:()=>n});var o=s(2646),r=s(257);const{jQuery:a}=window,i={components:{Spinner:o.$j,Modal:o.u_},props:{modalOptions:{type:Object,default:()=>{}}},data:()=>({isCopy:!1,isLoading:!1,itemName:"",layer:null,perms:{}}),computed:{modalHeader(){return`${this.isCopy?this.$Labels.MA_Copy:this.$Labels.MA_Move} ${this.itemName} ${this.$Labels.MA_To}`}},mounted(){const{layer:e={},isCopy:t=!1}=this.modalOptions;this.isCopy=t,this.layer=e,void 0!==a("#CopyToTree").data("jstree_instance_id")&&a("#CopyToTree").jstree("destroy").empty(),a("#CopyToTree").on("load_node.jstree load_node_json.jstree",(()=>{a("#CopyToTree li").each(((e,t)=>{const s=a(t);s.data("create",s.attr("create")),this.perms={...this.perms,[s.attr("id")]:{create:s.attr("create"),modify:s.attr("modify"),delete:s.attr("delete"),setperm:s.attr("setperm"),nodetype:s.attr("nodetype")}},(window.MASystem.User.IsCorporateAdmin||"CorporateRoot"!==s.attr("nodetype")&&("CorporateFolder"!==s.attr("nodetype")||"true"===this.perms[s.attr("id")].create))&&"RoleRoot"!==s.attr("nodetype")&&"RoleNameFolder"!==s.attr("nodetype")||s.addClass("disabled").find("> a > .jstree-checkbox").addClass("copyto-disabled")})),this.isCopy||document.querySelectorAll(".jstree-checkbox").forEach((e=>e.addEventListener("click",(()=>{this.checkForMultipleChecked()}))))})).jstree({json_data:{data:"",ajax:{url:window.MA.resources.TreeXML,data:e=>({id:e.attr?e.attr("id"):0,rand:(new Date).getTime(),type:e.attr?e.attr("NodeType"):0,types:"Folder"})}},checkbox:{real_checkboxes:!0,real_checkboxes_names:e=>{let t=0;return a(e).each(((e,s)=>{t=a(s).attr("nodeid")})),[`check_${t}`,t]},two_state:!0},core:{animation:10,strings:{loading:this.$Labels.MA_Loading_With_Ellipsis,new_node:"New Folder"}},plugins:["themes","json_data","ui","crrm","types","checkbox"]}),this.itemName=window.htmlEncode(e.name)},methods:{checkForMultipleChecked(){document.querySelectorAll(".jstree-checked").forEach((e=>{e.classList.remove("jstree-checked"),e.classList.add("jstree-unchecked")}))},submit(){this.isCopy?this.SubmitCopyTo():this.SubmitMoveTo()},SubmitCopyTo(){const e=this;this.isLoading=!0;const t=[];if(a("#CopyToTree").jstree("get_checked",null,!0).each(((e,s)=>{const o=a(s);(window.MASystem.User.IsCorporateAdmin||"true"===this.perms[o.attr("id")].create||"PersonalRoot"===this.perms[o.attr("id")].nodetype||"PersonalFolder"===this.perms[o.attr("id")].nodetype)&&t.push(`${o.attr("id")}~${o.attr("NodeType")}`)})),Array.isArray(t)&&!t.length)return e.isLoading=!1,e.showError("You do not have the required permissions to copy to the selected folder/s"),void e.close();a.each(t,((t,s)=>{const o=s.split("~"),a={ajaxResource:"TreeAJAXResources",action:"copy_node",copyid:e.layer.id,copynodetype:e.layer.nodetype,folderid:o[0],foldernodetype:o[1]};(new r.Z).setAction("maps.RemoteFunctions.processAJAXRequest").setErrorHandler((t=>{e.isLoading=!1,e.showError(t),e.close()})).invoke([a],(t=>{const{success:s=!1,error:o=this.$Labels.Common_Refresh_And_Try_Again_Contact_Admin}=t;s?(e.$bus.$emit("refresh-folder"),window.MAToastMessages.showSuccess({message:e.$Labels.MA_Success}),e.close()):(e.showError(o),e.close()),e.isLoading=!1}),{buffer:!1})}))},SubmitMoveTo(){const e=this;e.isLoading=!0;const t=[];if(a("#CopyToTree").jstree("get_checked",null,!0).each(((e,s)=>{const o=a(s);(window.MASystem.User.IsCorporateAdmin||"true"===this.perms[o.attr("id")].create||"PersonalRoot"===this.perms[o.attr("id")].nodetype||"PersonalFolder"===this.perms[o.attr("id")].nodetype)&&t.push(`${o.attr("id")}~${o.attr("NodeType")}`)})),Array.isArray(t)&&!t.length)return e.isLoading=!1,e.showError("You do not have the required permissions to move to the selected folder/s"),void e.close();a.each(t,((t,s)=>{const o=s.split("~"),a=e.layer.type,i=`${e.layer.id} ${e.layer.nodetype}`;let n="sqry";"folder"===a?n="folders":"marker"===a?n="sqry":"shape"===a?n="territories":"favorite"===a?n="favorites":"datalayer"===a?n="datalayers":"territory"===a&&(n="territory-layer");const d={ajaxResource:"TreeAJAXResources",action:"move_node",npid:o[0],npnt:o[1]};d[n]=i,(new r.Z).setAction("maps.RemoteFunctions.processAJAXRequest").setErrorHandler((t=>{e.isLoading=!1,e.showError(t),e.close()})).invoke([d],(t=>{const{success:s=!1,error:o=this.$Labels.Common_Refresh_And_Try_Again_Contact_Admin}=t;s?(e.$bus.$emit("refresh-folder"),window.MAToastMessages.showSuccess({message:e.$Labels.MA_Success}),e.close()):(e.showError(o),e.close()),e.isLoading=!1}),{buffer:!1})}))},close(){this.$emit("close")},showError(e){(e.indexOf("Too many SOQL queries: 101")>-1||e.indexOf("Too many DML statements")>-1)&&(e="The amount of layers and subfolders is too large to handle in one operation. Please reduce the number and try again."),window.MAToastMessages.showError({message:"Unable to Perform Action",subMessage:e,setTimeout:7e3})}}},n=(0,s(1900).Z)(i,(function(){var e=this,t=e._self._c;return t("Modal",{attrs:{id:"CopyToPopup",title:e.modalHeader,labels:{close:e.$Labels.MA_Close}},on:{close:e.close}},[t("div",{attrs:{slot:"content"},slot:"content"},[t("Spinner",{directives:[{name:"show",rawName:"v-show",value:e.isLoading,expression:"isLoading"}]}),e._v(" "),t("div",{staticClass:"slds-modal__content slds-p-around_medium",attrs:{id:"copyToPopupContent"}},[t("div",{staticStyle:{"padding-top":"3px"},attrs:{id:"CopyToTree"}})])],1),e._v(" "),t("div",{attrs:{slot:"footer"},slot:"footer"},[t("button",{staticClass:"slds-button slds-button_neutral",attrs:{disabled:e.isLoading},on:{click:e.close}},[e._v("\n            "+e._s(e.$Labels.MA_Cancel)+"\n        ")]),e._v(" "),t("button",{staticClass:"slds-button slds-button_brand",attrs:{disabled:e.isLoading},on:{click:e.submit}},[e._v("\n            "+e._s(e.$Labels.MA_Submit)+"\n        ")])])])}),[],!1,null,null,null).exports}}]);