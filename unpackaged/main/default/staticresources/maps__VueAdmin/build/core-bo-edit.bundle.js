"use strict";(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[3553],{9380:(t,e,s)=>{s.r(e),s.d(e,{default:()=>F});var i=s(5908),a=s(9048),o=s(7964),c=s(6548),n=s(2106),l=s(5240),d=s(1583),r=s(1217),b=s(6534),p=s(5049),g=s(8878),h=s(4571),j=s(9293),_=s(2761);const O={components:{baseObjectSelection:o.Z,PriorityValueSettings:c.Z,objectDetails:n.Z,addressFields:r.Z,coordinateFields:l.Z,polylineFields:d.Z,checkInSettings:b.Z,mapItSettings:p.Z,footerButtons:g.Z,scopeFilters:h.Z,advancedOptions:j.Z,suggestFieldsButton:_.Z},data:()=>({showMoreOptions:!1}),computed:{...(0,i.mapState)(["existingObjects","existingBaseObject","existingObjectData","showAdditionalFields"]),baseObject(){return this.getExistingBaseObjectId()},relationshipFields(){const t=this.existingObjectData||{};return(0,a._)(t,["RelationshipFields"],!1)||[]},polymorphicFields(){const t=this.existingObjectData||{};return(0,a._)(t,["PolymorphicFields"])||{}},hasMarkerLayer(){const t=this.existingObjectData||{};return(0,a._)(t,["HasMarkerLayer"])||!1},recordTypeFields(){const t=this.existingObjectData||{};let e=[];const s=(0,a._)(t,["RecordTypes"],!1)||[];return this.existingBaseObject.isPolymorphic?s.forEach((t=>{const s=t;s.value=`${this.existingBaseObject.maps__PolymorphicAddressObject__c}::${s.value}`,e.push(s)})):e=s,e.unshift({name:this.$Labels.MA_All,value:"--All--"}),e},sfdcAddressFields(){const t=this.existingObjectData||{};return(0,a._)(t,["AddressFields"],!1)||[]},sfdcCoordFields(){const t=this.existingObjectData||{};return(0,a._)(t,["CoordinateFields"],!1)||[]},sfdcPolylineFields(){const t=this.existingObjectData||{};return(0,a._)(t,["PolylineFields"])||[]},sfdcCheckInFields(){const t=this.existingObjectData||{};return(0,a._)(t,["CheckInDateFields"],!1)||[]},sfdcPriorityFields(){const t=this.existingObjectData||{};let e=[];const s=(0,a._)(t,["PriorityFields"],!1)||[];return this.existingBaseObject.isPolymorphic?s.forEach((t=>{const s=t;s.value=`${this.existingBaseObject.maps__PolymorphicAddressObject__c}::${s.value}`,e.push(s)})):e=s,e},tooltipFields(){const t=this.existingObjectData||{};return(0,a._)(t,["TooltipFields"],!1)||[]}},watch:{baseObject(){this.showMoreOptions=!1,""!==this.baseObject&&null!==this.baseObject&&this.$nextTick((()=>{this.showMoreOptions=!0}))}},created(){this.existingObjects.length||(this.loadingToggle(!0),this.populateExistingObjects().catch((t=>{this.updateToastMsg({msg:t.message}),console.warn(t)})).finally((()=>{this.loadingToggle(!1)})))},methods:{...(0,i.mapGetters)(["getExistingBaseObjectId"]),...(0,i.mapMutations)(["resetNewBaseObject","loadingToggle","updateToastMsg"]),...(0,i.mapActions)(["populateFields","populateExistingObjects"])}},F=(0,s(1900).Z)(O,(function(){var t=this,e=t._self._c;return e("div",[e("baseObjectSelection",{attrs:{objectData:t.existingBaseObject,objectOptions:t.existingObjects,objectType:"editExisting"}}),t._v(" "),t.showMoreOptions?e("div",[e("objectDetails",{attrs:{relationshipFields:t.relationshipFields,recordTypeFields:t.recordTypeFields,objectData:t.existingBaseObject,polymorphicFields:t.polymorphicFields,hasMarkerLayer:t.hasMarkerLayer,objectType:"editExisting"}}),t._v(" "),t.showAdditionalFields?e("div",[e("div",{staticClass:"slds-section slds-m-bottom_large slds-is-open"},[e("div",{staticClass:"slds-section__title slds-theme--shade"},[e("span",{staticClass:"section-header-title slds-p-horizontal--small slds-truncate"},[t._v("\n                        "+t._s(t.$Labels.BaseObject_AddressAndCoordinateFields_SectionHeader)+"\n                    ")])]),t._v(" "),e("div",{staticClass:"slds-section__content section__content"},[e("suggestFieldsButton",{attrs:{objectData:t.existingBaseObject,objectType:"editExisting"}}),t._v(" "),e("addressFields",{attrs:{sfdcAddressFields:t.sfdcAddressFields,objectData:t.existingBaseObject,objectType:"editExisting"}}),t._v(" "),e("coordinateFields",{attrs:{sfdcCoordFields:t.sfdcCoordFields,objectData:t.existingBaseObject,objectType:"editExisting"}}),t._v(" "),e("div",{staticClass:"slds-text-body_small",staticStyle:{"font-weight":"bold","font-style":"italic"}},[t._v("\n                        "+t._s(t.$Labels.BaseObject_AddressAndCoordinateFields_RequiredFieldsText)+"\n                    ")]),t._v(" "),e("polylineFields",{attrs:{sfdcPolylineFields:t.sfdcPolylineFields,objectData:t.existingBaseObject,objectType:"createNew"}})],1)]),t._v(" "),e("PriorityValueSettings",{attrs:{objectData:t.existingBaseObject,priorityFields:t.sfdcPriorityFields,objectType:"editExisting"}}),t._v(" "),e("scopeFilters",{attrs:{objectData:t.existingBaseObject,objectType:"editExisting"}}),t._v(" "),e("checkInSettings",{attrs:{objectData:t.existingBaseObject,sfdcCheckInFields:t.sfdcCheckInFields,objectType:"editExisting"}}),t._v(" "),e("mapItSettings",{attrs:{objectData:t.existingBaseObject,tooltipFields:t.tooltipFields,objectType:"editExisting"}}),t._v(" "),e("advancedOptions",{attrs:{objectData:t.existingBaseObject,objectType:"editExisting"}}),t._v(" "),e("footerButtons",{attrs:{objectData:t.existingBaseObject,objectType:"editExisting"}})],1):t._e()],1):t._e()],1)}),[],!1,null,null,null).exports}}]);