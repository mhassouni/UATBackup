"use strict";(globalThis.webpackChunkmaps_desktop=globalThis.webpackChunkmaps_desktop||[]).push([[683],{2544:(e,a,s)=>{s.r(a),s.d(a,{default:()=>l});var t=s(2134);const i={props:{numberOfTilesInRow:{type:Number,default:4},visible:{type:Boolean,required:!0}},data(){return{tiles:[{name:"esri_street",label:this.$Labels.NavBar_Map_Types_ESRI_Street,imageURL:window.MASystem.Images.streetsTile,isCustom:!0,tileURL:t.Z.getEsriTileUrl("esri_street")},{name:"esri_topography",label:this.$Labels.NavBar_Map_Types_ESRI_Topography,imageURL:window.MASystem.Images.topographyTile,isCustom:!0,tileURL:t.Z.getEsriTileUrl("esri_topography")},{name:"esri_imagery",label:this.$Labels.NavBar_Map_Types_ESRI_Imagery,imageURL:window.MASystem.Images.imageryTile,isCustom:!0,tileURL:t.Z.getEsriTileUrl("esri_imagery")},{name:"roadmap (Google)",label:this.$Labels.NavBar_Map_Types_Google_Road,imageURL:window.MASystem.Images.roadmapTile,isCustom:!1,tileURL:""},{name:"terrain",label:this.$Labels.NavBar_Map_Types_Google_Terrain,imageURL:window.MASystem.Images.terrainTile,isCustom:!1,tileURL:""},{name:"hybrid",label:this.$Labels.NavBar_Map_Types_Google_Hybrid,imageURL:window.MASystem.Images.hybridTile,isCustom:!1,tileURL:""},{name:"satellite",label:this.$Labels.NavBar_Map_Types_Google_Satelitte,imageURL:window.MASystem.Images.satelliteTile,isCustom:!1,tileURL:""}],activeTileNameOrId:"esri_street"}},computed:{tileRows(){const e=window.MA.Map.customTiles||[],a=[];for(let s=0;s<e.length;s++){const t=e[s],i=JSON.parse(t.maps__Options__c)||{},l=i&&"object"==typeof i?i.url:"";a.push({name:t.Id,label:t.Name,imageURL:window.MASystem.Images.customMapTile,isCustom:!0,tileURL:l})}const s=[...this.tiles,...a];return window.MA.Util.createBatchable(s,this.numberOfTilesInRow)},tileClassObject(e){return{active:"object"==typeof e&&e.name===this.activeTileNameOrId}}},created(){this.$bus.$on("add-map-tiles",this.addMapTiles),this.$bus.$on("map-type-updated",this.mapTypeUpdated);const e=window.getProperty(window.userSettings||{},"defaultMapSettings.mapType",!1)||"esri_street";this.activeTileNameOrId=e.replace("google_","")},destroyed(){this.$bus.$off("add-map-tiles"),this.$bus.$off("map-type-updated",this.mapTypeUpdated)},methods:{addMapTiles(e){Array.isArray(e)&&(this.tiles=this.tiles.concat(e))},mapTypeTileClick(e){e.isCustom?(this.$bus.$emit("remove-base-esri-attribution"),this.$bus.$emit("add-base-esri-attribution",e.name),window.MA.Map.updateCustomType(null,e.tileURL,e.name)):("roadmap (Google)"===e.name?window.trackUsage("Maps",{action:"Google Road - Map Types - Manually Selected",description:"Google Road was manually selected"}):"terrain"===e.name?window.trackUsage("Maps",{action:"Google Terrain - Map Types - Manually Selected",description:"Google Terrain was manually selected"}):"hybrid"===e.name?window.trackUsage("Maps",{action:"Google Hybrid - Map Types - Manually Selected",description:"Google Hybrid was manually selected"}):"satellite"===e.name&&window.trackUsage("Maps",{action:"Google Satellite - Map Types - Manually Selected",description:"Google Satellite was manually selected"}),window.MA.Map.updateMapType({mapTypeId:e.name})),this.activeTileNameOrId=e.name},close(){this.$emit("update:visible",!1)},mapTypeUpdated(e){e&&(this.activeTileNameOrId=e)}}},l=(0,s(1900).Z)(i,(function(){var e=this,a=e._self._c;return a("section",{staticClass:"slds-popover popover-act-like-dropdown",attrs:{id:"mapTileDropdownWrap"}},[a("div",{staticClass:"slds-popover__body",attrs:{id:"mapTileDropdownInner"}},[a("div",{staticClass:"map-tile-group slds-grid slds-grid_vertical",attrs:{id:"mapTileDropdownMapWrap"}},[a("div",{staticClass:"map-type-header slds-grid slds-grid slds-grid_vertical-align-center"},[a("div",{staticClass:"slds-col"},[a("h2",{staticClass:"slds-align-middle slds-text-heading_small"},[e._v(e._s(e.$Labels.NavBar_Map_Types_Header))])]),e._v(" "),a("div",[a("button",{staticClass:"slds-button slds-button_icon slds-button_icon-small",on:{click:e.close}},[a("span",{staticClass:"slds-button__icon ma-icon ma-icon-close"})])])]),e._v(" "),a("div",{staticClass:"map-type-body slds-col"},e._l(e.tileRows,(function(s,t){return a("div",{key:t,staticClass:"slds-grid"},e._l(s,(function(s,t){return a("div",{key:t,staticClass:"map-tile-map-type",class:{active:s.name==e.activeTileNameOrId},on:{click:function(a){return e.mapTypeTileClick(s)}}},[a("div",{staticClass:"map-tile-image-wrap"},[a("img",{attrs:{src:s.imageURL}})]),e._v(" "),a("div",{staticClass:"map-tile-label"},[e._v("\n                            "+e._s(s.label)+"\n                        ")]),e._v(" "),a("div",{staticClass:"active-check"}),e._v(" "),a("span",{staticClass:"active-check-icon ma-icon ma-icon-check"})])})),0)})),0)])])])}),[],!1,null,"5f92df7c",null).exports}}]);