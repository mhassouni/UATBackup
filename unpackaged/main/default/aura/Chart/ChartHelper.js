({
    getClosest : function(data, target){
          data.reduce((prev, next) =>
             target < prev.age ? prev : next
          );  
    },
    
	createGraph : function(cmp, temp) {
        
        var dataMap = {"chartLabels": Object.keys(temp.myLineChartVarList),
                       "chartData": Object.values(temp.myLineChartVarList)
                       };
        
        var el = cmp.find('barChart').getElement();
        var ctx = el.getContext('2d');
        
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dataMap.chartLabels,
                datasets: [
                    {
                        label: "Evolution Tension",
                        backgroundColor: "rgba(153,255,51,0.5)",
                        data: dataMap.chartData
                    }
                ]
            }
        });
	},
    createLineGraph : function(cmp, temp) {
        var typeTensionBatterie = 'Tension batterie basse';
        var typeVoyantMoteur = 'Voyant moteur';
        var typeAlarmsA01 = 'Coupure basse pression';
        
        var globalStaticResourcePath = $A.get('$Resource.checked_icon');
        //console.log(globalStaticResourcePath);

        var engineStartImage = new Image(20,20);
        engineStartImage.src = globalStaticResourcePath;
        //engineStartImage.src = 'https://greenforce--infra--c.visualforce.com/resource/1649252368000/LastPositionMin?';
        
        var voltageLabels = [];
        var firstValue = [];
        
        var lightsLabels = [];
        var lightsValues = [];
        var lightsData = [];    
        
        var lightsDict = [];
        var enginesDict = [];
        var alarmsA01Dict = [];
        
        var alertBubbleData = [];
        
        var refLabels = [];
        
        var engineLabels = [];
        var engineValues = [];
        var engineLines = [];
        var threesholdValues = [];
                
        var temperatureLabels = [];
        var temperatureValues = [];
        
        var chartData = temp.myLineChartVarList;
        var engineStarts = temp.engineStartsList;
        var engineLightsList = temp.engineLightsList;
        var alarmsList = temp.alarmsList;
        var ambientAirTemperatureList = temp.ambientAirTemperatureList;
        
        var maxTemperature = 2;
        var minTemperature = 0;
        var valAlarmsA01 = 1;
        if(temp.maxTemperature && ambientAirTemperatureList.length > 0){
           	maxTemperature = temp.maxTemperature + 2;
            minTemperature = temp.minTemperature - 1;            
            valAlarmsA01 = temp.maxTemperature;
            console.log('******' + maxTemperature + ' - ' + minTemperature + ' - ' + valAlarmsA01)
        }else if (temp.setPointValue != null){
            valAlarmsA01 = temp.setPointValue + 1;
            minTemperature = temp.setPointValue - 2;
            maxTemperature = temp.setPointValue + 2;
        }
        
        if(temp.setPointValue != null){
            if(minTemperature >= temp.setPointValue){
                minTemperature = temp.setPointValue - 2;
            }
            
            if(maxTemperature <= temp.setPointValue){
                maxTemperature = temp.setPointValue + 2;
            }
        }
        
        var dateAlertIsInPlage = temp.dateTimeAlerte >= temp.xAxisMin && temp.dateTimeAlerte <= temp.xAxisMax;
        console.log ('dateAlertIsInPlage : ' + dateAlertIsInPlage)
        
        console.log("Type Alerte : " + temp.typeAlerte);
        console.log("dateTimeAlerte " + temp.dateTimeAlerte );
        console.log("engineLightsList : " + engineLightsList.length);
        console.dir("engineLightsList : " + engineLightsList);
        console.log("alarmsList : " + alarmsList.length);
        console.dir("alarmsList : " + alarmsList);
        console.dir("ambientAirTemperatureList : " + ambientAirTemperatureList.length);
        console.dir(ambientAirTemperatureList);
        console.log("chartData : " + chartData.length);
        console.log("engineStarts : " + engineStarts.length);
        console.log("xAxis : " + temp.xAxisMin + " - " + temp.xAxisMax);
        console.log("maxTemperature : " + temp.maxTemperature);
        console.log("setPointValue : " + temp.setPointValue);

        if(temp.typeAlerte === typeTensionBatterie && chartData.length === 0 ){
            cmp.set('v.msg','Pas de données');
        }else if(temp.typeAlerte === typeVoyantMoteur && engineLightsList.length === 0 ){
            cmp.set('v.msg','Pas de données');
        }else if(temp.typeAlerte === typeAlarmsA01 && alarmsList.length === 0 && ambientAirTemperatureList.length === 0 ){
            cmp.set('v.msg','Pas de données');            
        }else {
            cmp.set('v.msg','');
        }
        //cmp.set('v.dateDebut','Date : ' + temp.dateDebutGraph);
        
        // batteries
        for(var a=0; a < chartData.length; a++){
            voltageLabels.push(chartData[a]["label"]);
            refLabels.push(chartData[a]["label"]);
            firstValue.push(chartData[a]["firstValue"]);
            //threesholdValues.push(temp.thresholdVoltage);
            engineLines.push(0);
        }
        
        // Annotation seuil batterie
        var annotationBattery = {};
        if(temp.thresholdVoltage != null){
            console.log("annotationBatterie : " + temp.thresholdVoltage);
        	annotationBattery = {
	                //drawTime: 'afterDatasetsDraw',
	                annotations: [{
                        //drawTime: 'afterDraw',
	                    id: 'hline',
	                    type: 'line',
	                    mode: 'horizontal',
	                    scaleID: 'y-axis-0',
	                    value: temp.thresholdVoltage,
	                    borderColor: 'red',
	                    borderWidth: 2,
	                    label: {
	                        content: "Seuil (" + temp.thresholdVoltage +" Volts)",
                            enabled: true
	                    }
	                }]
	            };    
        }
        
        // voyants moteur
        for(var a=0; a < engineLightsList.length; a++){
            var timePart = engineLightsList[a]["label"];
            lightsLabels.push(timePart);
            refLabels.push(timePart);
            
            lightsValues.push(engineLightsList[a]["secondValue"]);
			var lightVal = 0;
            if(engineLightsList[a]["secondValue"] === "On"){
                lightVal = 1;
            }
			lightsData.push(lightVal);
            //lightsDict.push({x:engineLightsList[a]["label"], y:lightVal});
            engineLines.push(0);        
        }
        
        // alarms A01
        for(var a=0; a < alarmsList.length; a++){
            var timePart = alarmsList[a]["label"];
            alarmsA01Dict.push({x:timePart, y:valAlarmsA01, r:10});            
            
        }
        
        // Temperature ambiante
        for(var a=0; a < ambientAirTemperatureList.length; a++){
            temperatureLabels.push(ambientAirTemperatureList[a]["label"]);
            temperatureValues.push(ambientAirTemperatureList[a]["firstValue"]);
        }
        
        // Point de consigne
        var annotationSetPoint = {};
        if(temp.setPointValue != null){
            console.log("annotationSetPoint : " + temp.setPointValue);
        	annotationSetPoint = {
	                //drawTime: 'afterDatasetsDraw',
	                annotations: [{
                        //drawTime: 'afterDraw',
	                    id: 'hline',
	                    type: 'line',
	                    mode: 'horizontal',
	                    scaleID: 'y-axis-0',
	                    value: temp.setPointValue,
	                    borderColor: 'blue',
	                    borderWidth: 2,
	                    label: {
	                        content: "Point de consigne (" + temp.setPointValue +"°C)",
                            enabled: true
	                    }
	                }]
	            };    
        }
        
         // Démarrages moteur
         var indexTest = 0;
        if(temp.typeAlerte !== typeAlarmsA01 && refLabels.length > 0){
            for(var a=0; a < engineStarts.length; a++){
                var val = engineStarts[a]["label"]
                engineLabels.push(val);
                var closest = refLabels.reduce((prev, next) =>
                                val < prev ? prev : next
                              );
                var indexClosest = refLabels.indexOf(closest);
                indexTest = indexClosest;
                engineLines[indexClosest] = temp.thresholdVoltage + 7;
                
                //enginesDict.push({x:val, y:temp.thresholdVoltage + 7});  
        	}
        }
                             
        var el = cmp.find('lineChart').getElement();
        var ctx = el.getContext('2d');
        
        var chartobj = cmp.get("v.chartobj");
        //if chartobj is not empty, then destory the chart in the view
        if(chartobj){
            console.log("chartobj existe")
            chartobj.destroy();
        }else{
            console.log("chartobj n'existe pas")
        }   
        
        if(temp.typeAlerte === typeTensionBatterie && chartData.length > 0){
            if(dateAlertIsInPlage){
                alertBubbleData = [{x: temp.dateTimeAlerte, y: temp.thresholdVoltage, r: 10}];
            }
            chartobj = new Chart(ctx, {            
                type: 'bar',
                data: {                	
                        labels: voltageLabels,
                        datasets: [{
                                type: 'line',
                                label: 'Tension en volts',
                                data: firstValue,
                                backgroundColor: "rgba(153,255,51,0.4)",
                                borderColor: "rgba(153,255,51,0.4)",
                            }, 
                            /*{
                                type: 'line',
                                label: 'Seuil (' + temp.thresholdVoltage + 'Volts)',
                                data: threesholdValues,
                                fill: false,
                                borderColor: "red",
                                backgroundColor : "red",
                                pointRadius: 0,
                                pointHoverRadius: 0
                            },*/
                            {
                                type: 'bar',
                                label: 'Démarrage moteur',
                                data: engineLines,                            
                                borderColor: "blue",
                                fill: true,
                                backgroundColor : "blue",
                                fillColor: "blue",
                            },
                            {
                                type: 'bubble',                                
                                backgroundColor: 'red',
                                data: alertBubbleData
                            },
                         ]
                      },                
                options: {
                   	elements: {
                        point:{
                            radius: 0
                        }
                    },
                    legend: {
                      display: false,
                    },
                    tooltips: {
                        enabled: false
                    },                
                    scales: {
                        xAxes: [{
                            type: 'time',
                            time:       {                                
                                //unit: 'minute',
                                displayFormats: {minute: 'HH:mm', hour: 'HH:mm'},
                                //min:temp.xAxisMin,
                                //max:temp.xAxisMax
                            },
                            ticks: {                            
                                beginAtZero: false,                            
                            },
                            gridLines: {
                            },
                            maxBarThickness: 1,
                            scaleLabel: {
								display: true,
                                labelString: 'Période du ' + temp.xAxisMinLabel + ' au ' + temp.xAxisMaxLabel 
                             
                        	}
                        }],
                        yAxes: [{
                            ticks: {                            
                                beginAtZero: true,
                                min: 0,
                                max: temp.maxValueVoltage
                            },
                            maxBarThickness: 1,
                            scaleLabel: {
								display: true,
                                labelString: 'Tension (Volts)'
                             
                        	}
                         },                     
                        ]
                    },
                    annotation : annotationBattery
                }            
            });
        }else if(temp.typeAlerte === typeVoyantMoteur ){
			if(dateAlertIsInPlage){
                alertBubbleData = [{x: temp.dateTimeAlerte, y: 1, r: 10}];
            }                                
            chartobj = new Chart(ctx, {            
                type: 'bar',
                data: {                	
                        labels: lightsLabels,
                        datasets: [{
                                type: 'line',
                                label: typeVoyantMoteur,
                                data: lightsData,
                                backgroundColor: "white",
                                borderColor: "red",
                                fill: false,
                                stepped:true,
                                pointRadius: 0,
                                pointHoverRadius: 0
                            },
                            {
                                type: 'bar',
                                label: 'Démarrage moteur',
                                data: engineLines,                            
                                borderColor: "blue",
                                //fill: true,
                                backgroundColor : "blue",
                                fillColor: "blue",
                            },
                            {
                                type: 'bubble',                                
                                backgroundColor: 'red',
                                data: alertBubbleData
                            },
                         ]
                      },                
                options: {
                    elements: {
                        point:{
                            radius: 0
                        }
                    },
                    legend: {
                      display: false,
                      labels: {                      
                      }
                    },
                    tooltips: {
                        enabled: false
                    },                
                    scales: {
                        xAxes: [{
                            type: 'time',
                            time:       {                                
                                //unit: 'minute',
                                displayFormats: {minute: 'HH:mm', hour: 'HH:mm'},
                                //min:temp.xAxisMin,
                                //max:temp.xAxisMax
                            },
                            ticks: {                            
                                beginAtZero: false,                            
                                align: 'start'
                            },
                            gridLines: {
                                //color: "rgba(0, 0, 0, 0)",
                                //display: false,
                            },
                            maxBarThickness: 1,
                            scaleLabel: {
								display: true,
                                labelString: 'Période du ' + temp.xAxisMinLabel + ' au ' + temp.xAxisMaxLabel 
                             
                        	}
                        }],
                        yAxes: [{
                            ticks: {                            
                                //beginAtZero: true,
                                min: 0,
                                max: 1.1,
                                fontSize: 13,
          						fontStyle: 'bold',
                                callback: value => {
                                    if (value === 1) {
                                      return 'Allumé';
                                    } else if (value === 0) {
                                      return 'Eteint';
                                    } else {
                                      return '';
                                    }
                                },
                            },
                            maxBarThickness: 1,
    						scaleLabel: {
								display: true,
                                labelString: 'Voyant moteur' 
                             
                        	}
                         },                     
                        ]
                    }
                }            
            });                
        } else if(temp.typeAlerte === typeAlarmsA01 && (alarmsList.length > 0 || ambientAirTemperatureList.length > 0)){
            chartobj = new Chart(ctx, {            
                type: 'bubble',
                data: {                	
                        labels: temperatureLabels,
                        datasets: [
                                    {
                                        type: 'line',
                                        label: 'Temperature ambiante',
                                        data: temperatureValues,
                                        backgroundColor: "rgba(153,255,51,0.4)",
                                        borderColor: "rgba(153,255,51,0.4)",
                                        pointRadius: 0,
                                		pointHoverRadius: 0
                                    },{
                                        label: 'Alarmes A01/P01',
                                        type: 'bubble',                                
                                        backgroundColor: 'red',
                                        data: alarmsA01Dict
                                }]
                      },                
                options: {
                    elements: {
                        point:{
                            radius: 0
                        }
                    },
                    legend: {
                      display: false,
                      labels: {                      
                      }
                    },
                    tooltips: {
                        enabled: false
                    },                
                    scales: {
                        xAxes: [{
                            type: 'time',
                            time:       {                                
                                //unit: 'hour',
                                displayFormats: {minute: 'HH:mm', hour: 'HH:mm'},
                                //min:temp.xAxisMin,
                                //max:temp.xAxisMax
                            },
                            ticks: {                            
                                beginAtZero: true,                            
                                align: 'start'
                            },
                            gridLines: {
                                //color: "rgba(0, 0, 0, 0)",
                                //display: false,
                            },
                            maxBarThickness: 1,
                            scaleLabel: {
								display: true,
                                labelString: 'Période du ' + temp.xAxisMinLabel + ' au ' + temp.xAxisMaxLabel 
                             
                        	}
                        }],
                        yAxes: [{
                            ticks: {                            
                                //beginAtZero: true,
                                min: minTemperature,
                                max: maxTemperature,
                                //fontSize: 13,
          						//fontStyle: 'bold',
                                /*callback: value => {
                                    if (value === 1) {
                                      return 'A01-P01';
                                    } else if (value === 0) {
                                      return '';
                                    } else {
                                      return '';
                                    }
                                },*/
                            },
                            maxBarThickness: 1,
                            scaleLabel: {
								display: true,
                                labelString: 'Température ambiante (°C)'
                             
                        	}
                         },                     
                        ]
                    },
                    annotation: annotationSetPoint
                }            
            });                
        }
        
        cmp.set("v.chartobj",chartobj);           
	},
                            
})