public class DirectionsService_JsonParser 
{
	public cls_geocoded_waypoints[] geocoded_waypoints;
	public cls_routes[] routes;
	public String status;	//OK
	class cls_geocoded_waypoints 
    {
		public String geocoder_status;	//OK
		public String place_id;	//ChIJD7fiBh9u5kcRYJSMaMOCCwQ
		//public cls_types[] types;
	}
	/*class cls_types {
		public String 0;	//l
		public String 1;	//o
		public String 2;	//c
		public String 3;	//a
		public String 4;	//l
		public String 5;	//i
		public String 6;	//t
		public String 7;	//y
	}*/
	public	class cls_routes {
		public cls_bounds bounds;
		public String copyrights;	//Map data ©2022 Google
		public cls_legs[] legs;
		public cls_overview_polyline overview_polyline;
		public String summary;	//A6
		public cls_warnings[] warnings;
		public cls_waypoint_order[] waypoint_order;
	}
	public	class cls_bounds {
		public cls_northeast northeast;
		public cls_southwest southwest;
	}
	public	class cls_northeast {
		public Double lat;	//48.8568332
		public Double lng;	//4.919595699999999
	}
	public	class cls_southwest {
		public Double lat;	//45.7493589
		public Double lng;	//2.3059051
	}
	public	class cls_legs {
		public cls_distance distance;
		public cls_duration duration;
		public String end_address;	//Lyon, France
		public cls_end_location end_location;
		public String start_address;	//Paris, France
		public cls_start_location start_location;
		public cls_steps[] steps;
		public cls_traffic_speed_entry[] traffic_speed_entry;
		public cls_via_waypoint[] via_waypoint;
	}
	public	class cls_distance {
		public String text;	//0,1 km
		public Integer value;	//146
	}
	public	class cls_duration {
		public String text;	//1 minute
		public Integer value;	//50
	}
	public	class cls_end_location {
		public Double lat;	//48.8573175
		public Double lng;	//2.3492495
	}
	public	class cls_start_location {
		public Double lat;	//48.8568332
		public Double lng;	//2.3510991
	}
	public	class cls_steps {
		public cls_distance distance;
		public cls_duration duration;
		public cls_end_location end_location;
		public String html_instructions;	//Prendre la direction <b>nord-ouest</b> sur <b>Av. Victoria</b> vers <b>Rue de la Coutellerie</b>
		public cls_polyline polyline;
		public cls_start_location start_location;
		public String travel_mode;	//DRIVING
	}
	public	class cls_polyline {
		public String points;	//ejeiHkejM[`BK~@]fBCLIb@Mt@
	}
	public	class cls_traffic_speed_entry {
	}
	public	class cls_via_waypoint {
	}
	public	class cls_overview_polyline {
		public String points;	//ejeiHkejMnEgAvGyTnOcg@|g@ob@|~AmzBzMiTvMz`@xs@h}Bn@fm@n^df@dm@|i@pk@`@bnAiMlxAzInnCfwBpvAtz@hsAj^`uAj\tq@mv@tnA}oA`w@enA~sBmdFfiBcjBfeBi_Dx_BmwAzuAsw@rjBgbCfs@sj@`dAurBbiAgh@lxCio@baBep@djB_EpvCyTlpCeiBhuDoaBbp@cc@be@f@niAcOhrBgw@j{AwtB|eAab@`iBygBrkAeqEn`@}eB|x@unAdiA{uClxBe}CrfC_{CtdCqcCvyCmvFfpGqkPvuBeyDlz@ydGrnA_bDhdAydE`wBgxCt~EwpKhdCmqBvwA}wBllAqvBbsAkzAteB_~Bn}C_~ElsAgtAv_@inCpkAseBtQ}|AgAgsCjq@cmBba@_|FnyAiiGzVehEfoAgnE~EirCnr@aiC`A{qFlh@s`C|fAitApk@yc@`o@_EpcAkPlo@cp@lk@}mCvr@ouAvu@iuAlYmaC|e@iuBn_Ai_@nxAjMx_A_z@hyAs`CbiA{qEhyAg`Gbd@avAxgA}{AbeAw_An`@kmAbi@ufBtmAqe@xyEqMdjAyYjx@mbArpBgdB|qA_vAb`AqnBlbDktBfv@waBrPaaATigEsFuaEjz@gmFh~B}yNxkA{pHnfAqaCt_@iwBlzAwjCl`BieCb_F_tGbzCokJj|Ay`EnpB_kCdbBinAlvB_c@|eCkv@bm@{`AxYy_Bxi@}kDtfBy{Ax}@w{@hkAe|CzbAqtFfvAwwBbyAc{A~e@{_@fc@dDr~@yOt{AlFveAwVdhBglAtSisAmEys@lUkj@fk@km@nbAegAdlAwPr~@wsAlIajHri@yUtg@olAxuA}nD|}@dJlpBj{@lwExgCdqFrpBp~DiNbjB`U`cCc[r_Cet@b`Elb@xeDth@veAwKnnA_q@r_G{}@jhH}_ApgAui@xwAsOfoAuDnd@Fhn@{h@zlAmnBzrA{uA~j@}Gfu@vQhrAE`|AeoBfu@mZbp@DrhBzt@vnAny@~oEffCzyCf{@b}BlY|vAhw@xcD~{@|lCzoBrpBnn@p|@v\lo@`xAf}@vk@zeApO|vBbYbcApBhfA_b@vz@{\zp@~ArfEdwAxuD~rAhzDBheGpgAtqA`kA`{AjXn_Dbs@bpBjr@~_CkFtoBos@z}Be@|`C~lBtoADr_A_}@ry@lP~wC{[znCg|@ziCgQ|pB}uAjcEmqAnrAolAnc@aPbZjRhd@yFfq@inAzrBg~DCq^afAgi@sRaAm@hQ
	}
	public	class cls_warnings {
	}
	public	class cls_waypoint_order {
	}
	public static DirectionsService_JsonParser parse(String json){
		return (DirectionsService_JsonParser) System.JSON.deserialize(json, DirectionsService_JsonParser.class);
	}

}