function addOption(theSel, theText, theValue){
	var newOpt = new Option(theText, theValue);
	var selLength = theSel.length;
  	theSel.options[selLength] = newOpt;
}

function deleteOption(theSel, theIndex){ 
	var selLength = theSel.length;
  	if(selLength>0){
    	theSel.options[theIndex] = null;
  	}
}

function moveOptions(theSelFrom, theSelTo){
 		var selLength = theSelFrom.length;
 		var selectedText = new Array();
 		var selectedValues = new Array();
 		var selectedCount = 0;
 
 		var i;
 
 		for(i=selLength-1; i>=0; i--){
   		if(theSelFrom.options[i].selected && theSelFrom.options[i].value != '###Standard###' && theSelFrom.options[i].value != '###Custom###' && theSelFrom.options[i].value != '###Removed###' && theSelFrom.options[i].value != '###Selected###'){
     			selectedText[selectedCount] = theSelFrom.options[i].text;
     			selectedValues[selectedCount] = theSelFrom.options[i].value;
     			deleteOption(theSelFrom, i);
     			selectedCount++;
   		}
 		}
 
 		for(i=selectedCount-1; i>=0; i--){
   		addOption(theSelTo, selectedText[i], selectedValues[i]);
 		}
 		
 		if(theSelFrom == document.getElementById('accountFieldsSelected') || theSelFrom == document.getElementById('contactFieldsSelected'))
 			updateFieldsSelected(theSelFrom);
 		else
 			updateFieldsSelected(theSelTo);
}

function moveUpDown(theSel, upDown){
    	var listemax = theSel.length - 2;
    	var listesel = theSel.selectedIndex;

	if(theSel.options[listesel].value != '###Selected###'){
    	if(!((listesel < 0) || (listesel<2 && upDown==-1 ) || (listesel>listemax && upDown==1))){
	    	tmpopt = new Option(theSel.options[listesel+upDown].text, theSel.options[listesel+upDown].value);
	    	theSel.options[listesel+upDown].text = theSel.options[listesel].text;
	    	theSel.options[listesel+upDown].value = theSel.options[listesel].value;
	    	theSel.options[listesel+upDown].selected = true;
	    	theSel.options[listesel].text = tmpopt.text;
	    	theSel.options[listesel].value = tmpopt.value;
	    	theSel.options[listesel].selected = false;
	
			updateFieldsSelected(theSel);
		}
	}
}