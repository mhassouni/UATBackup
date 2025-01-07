public with sharing class CatalogueController {
   
    public Boolean State{get;set;}

    public Boolean DisplayNotFound{get;set;}
    public Boolean DisplayCreated{get;set;}
    public Boolean DisplayInfo{get;set;}
    public Boolean DisplayError{get;set;}
    public Boolean DisplayErrorDM{get;set;}
    public Boolean DisplayNotAllowed{get;set;}
    public Boolean CatalogueNotAllowed{get;set;}
    public string CodePaysParam{get; set;}
    public string CatalogueParam{get;set;}
    public string StandardPFParam{get;set;}
    public string CodePFParam{get;set;}
    public string MarqueParam{get;set;}
    public string ModeleParam{get;set;}
    public string QuoteId {get;set;}
    public Quote currentQuote{get;set;}
    
    public List<SelectOption> optionsCODEPAYSValues{get; set;}
    public List<SelectOption> optionsCODEPFValues{get; set;}
    public List<SelectOption> optionsCATALOGUEValues{get; set;}
    public List<SelectOption> optionsSTANDARDPFValues{get; set;}
    public List<SelectOption> optionsMARQUEValues{get; set;}
    public List<SelectOption> optionsMODELEValues{get; set;}

    
    public List<String> ListeCodePaysValues{get; set;}
    public List<String> ListeCodePFValues{get; set;}
    public List<String> ListeStandardPFValues{get; set;}
    public List<String> ListeCatalogueValues{get; set;}
    public List<String> ListeMarqueValues{get; set;}
    public List<String> ListeModeleValues{get; set;}
    
     public CatalogueController(ApexPages.StandardController controller) {
        
         //*Message display Params
         this.DisplayInfo=true;
         this.DisplayCreated = false;
         this.DisplayNotFound=false;
         this.DisplayError=false;
         this.DisplayErrorDM=false;
         this.DisplayNotAllowed = false;
         
     	this.currentQuote= (Quote) controller.getRecord();//ApexPages.currentPage().getParameters().get('id');
        currentQuote= [Select id,Pays_Region_PF__c from Quote where id=:currentQuote.Id];
         system.debug('CurrentQuote : '+currentQuote.Id);
		//** Init the list FirstRun
      	InitLists();
    }
    
//**Init Methods
     public void InitLists()
      {

          InitCODEPays();InitCatalogue();InitCodePF();InitStandardPF();InitMarque();InitModele();
      } 
    public void InitCODEPays()
    {
        
        List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c ];
        ListeCodePaysValues = new list<String>();ListeCodePaysValues.clear();
        optionsCODEPAYSValues = new List<SelectOption>();optionsCODEPAYSValues.clear();
       	
		optionsCODEPAYSValues.add(new SelectOption('-', Label.Catalogue_Select_CodePays));
     	for(Base_produit__c BP : BPList)
     		{
         	if(!ListeCodePaysValues.contains(BP.Code_Pays__c))            
         	{
                ListeCodePaysValues.add(BP.Code_Pays__c);
         	}
     		}
         
         	for( String x : ListeCodePaysValues)
   			{
      		optionsCODEPAYSValues.add(new SelectOption(x,x));
   			}     
        system.debug('optionsCODEPAYSValues: '+optionsCODEPAYSValues.size());
    }
    public void InitCatalogue()
    {
        List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c ];
        ListeCatalogueValues = new list<String>();

        optionsCATALOGUEValues = new List<SelectOption>();
        optionsCATALOGUEValues.add(new SelectOption('-', Label.Catalogue_Select_Catalogue));
     for(Base_produit__c BP : BPList)
     {
         if(!ListeCatalogueValues.contains(BP.Catalogue__c))            
         {
                ListeCatalogueValues.add(BP.Catalogue__c);
         }
     }
        
        for( String x : ListeCatalogueValues)
   {
      optionsCATALOGUEValues.add(new SelectOption(x,x));
   }  
        system.debug('optionsCATALOGUEValues: '+optionsCATALOGUEValues.size());
    }
    public void InitCodePF()
    {
        List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c limit 1000];
        ListeCodePFValues = new list<String>();
        optionsCODEPFValues = new List<SelectOption>();optionsCODEPFValues.clear();
        optionsCODEPFValues.add(new SelectOption('-', Label.Catalogue_Select_CodePF));
     for(Base_produit__c BP : BPList)
     {
         if(!ListeCodePFValues.contains(BP.Code_PF__c))            
         {
                ListeCodePFValues.add(BP.Code_PF__c);
         }
     }
        for( String x : ListeCodePFValues)
   {
      optionsCODEPFValues.add(new SelectOption(x,x));
   }   
         system.debug('optionsCODEPFValues: '+optionsCODEPFValues.size());
    }
    public void InitStandardPF()
    {
        List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c ];
        ListeStandardPFValues = new list<String>();
        optionsSTANDARDPFValues = new List<SelectOption>();
        optionsSTANDARDPFValues.add(new SelectOption('-', Label.Catalogue_Select_StandardPF));
     for(Base_produit__c BP : BPList)
     {
         if(!ListeStandardPFValues.contains(BP.Standard__c))            
         {
                ListeStandardPFValues.add(BP.Standard__c);
         }
     }
        for( String x : ListeStandardPFValues)
   {
      optionsSTANDARDPFValues.add(new SelectOption(x,x));
   }  
              system.debug('optionsSTANDARDPFValues: '+optionsSTANDARDPFValues.size());
   
    }
    public void InitMarque()
    {
        List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c ];
        ListeMarqueValues = new list<String>();
        optionsMARQUEValues = new List<SelectOption>();optionsMARQUEValues.clear();
        optionsMARQUEValues.add(new SelectOption('-', Label.Catalogue_Select_Marque));
     for(Base_produit__c BP : BPList)
     {
         if(!ListeMarqueValues.contains(BP.Marque__c))            
         {
                ListeMarqueValues.add(BP.Marque__c);
         }
     }
        for( String x : ListeMarqueValues)
   {
      optionsMARQUEValues.add(new SelectOption(x,x));
   }   
        system.debug('optionsMARQUEValues: '+optionsMARQUEValues.size());
    }
 	public void InitModele()
    {
        List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c ];
        ListeModeleValues = new list<String>();
        optionsMODELEValues = new List<SelectOption>();optionsMODELEValues.clear();
        optionsMODELEValues.add(new SelectOption('-', Label.Catalogue_Select_Modele));
     for(Base_produit__c BP : BPList)
     {
         if(!ListeModeleValues.contains(BP.modele__c))            
         {
                ListeModeleValues.add(BP.Modele__c);
         }
     }
        for( String x : ListeModeleValues)
   {
      optionsMODELEValues.add(new SelectOption(x,x));
   }   
                system.debug('optionsMODELEValues: '+optionsMODELEValues.size());

    }
//**Get Methods    
    public void getCODEPAYSValues()
{
   	optionsCATALOGUEValues = new List<SelectOption>(); 
   	optionsCODEPFValues = new List<SelectOption>(); 
    optionsSTANDARDPFValues =  new List<SelectOption>(); 
    optionsMARQUEValues =  new List<SelectOption>(); 
    optionsMODELEValues =   new List<SelectOption>(); 
    list<String> ListeCatalogueValuesx = new list<string>();
    list<String> ListeCodePFValuesx = new list<string>();
    list<String> ListeStandardPFValuesx = new list<string>();
	list<String> ListeMarqueValuesx = new list<string>();
    list<String> ListeModeleValuesx = new list<string>();
    
	List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c where Code_Pays__c=:CodePaysParam  ];
   	for( Base_produit__c f : BPList)
   	{
      if(!ListeCatalogueValuesx.contains(f.Catalogue__c))
      {          
       ListeCatalogueValuesx.add(f.Catalogue__c);
      }
       if(!ListeCodePFValuesx.contains(f.Code_PF__c))
      {          
       ListeCodePFValuesx.add(f.Code_PF__c);
      }
       if(!ListeStandardPFValuesx.contains(f.Standard__c))
      {          
       ListeStandardPFValuesx.add(f.Standard__c);
      }
        if(!ListeMarqueValuesx.contains(f.Marque__c))
      {          
       ListeMarqueValuesx.add(f.Marque__c);
      }
        if(!ListeModeleValuesx.contains(f.Modele__c))
      {          
       ListeModeleValuesx.add(f.Modele__c);
      }
   	}
    for( String x : ListeCatalogueValuesx)
   			{
      		optionsCATALOGUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeCodePFValuesx)
   			{
      		optionsCODEPFValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeStandardPFValuesx)
   			{
      		optionsSTANDARDPFValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeMarqueValuesx)
   			{
      		optionsMARQUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeModeleValuesx)
   			{
      		optionsMODELEValues.add(new SelectOption(x,x));
   			}
  
}
    public void getCATALOGUEPFValues()
{
   	optionsCODEPAYSValues = new List<SelectOption>();
   	optionsCODEPFValues = new List<SelectOption>();
    optionsSTANDARDPFValues =  new List<SelectOption>();
    optionsMARQUEValues =  new List<SelectOption>();
    optionsMODELEValues =   new List<SelectOption>();
    list<String> ListeCodePaysValuesx = new list<string>();
    list<String> ListeCodePFValuesx = new list<string>();
    list<String> ListeStandardPFValuesx = new list<string>();
	list<String> ListeMarqueValuesx = new list<string>();
    list<String> ListeModeleValuesx = new list<string>();
    
	List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c where Catalogue__c=:CatalogueParam  ];
   	for( Base_produit__c f : BPList)
   	{
      if(!ListeCodePaysValuesx.contains(f.Code_Pays__c))
      {          
       ListeCodePaysValuesx.add(f.Code_Pays__c);
      }
       if(!ListeCodePFValuesx.contains(f.Code_PF__c))
      {          
       ListeCodePFValuesx.add(f.Code_PF__c);
      }
       if(!ListeStandardPFValuesx.contains(f.Standard__c))
      {          
       ListeStandardPFValuesx.add(f.Standard__c);
      }
        if(!ListeMarqueValuesx.contains(f.Marque__c))
      {          
       ListeMarqueValuesx.add(f.Marque__c);
      }
        if(!ListeModeleValuesx.contains(f.Modele__c))
      {          
       ListeModeleValuesx.add(f.Modele__c);
   	}
    for( String x : ListeCodePaysValuesx)
   			{
      		optionsCODEPAYSValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeCodePFValuesx)
   			{
      		optionsCODEPFValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeStandardPFValuesx)
   			{
      		optionsSTANDARDPFValues.add(new SelectOption(x,x));
   			}
      for( String x : ListeMarqueValuesx)
   			{
      		optionsMARQUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeModeleValuesx)
   			{
      		optionsMODELEValues.add(new SelectOption(x,x));
   			}
    }    
}
    
    public void getCODEPFValues()
{
   	optionsCODEPAYSValues = new List<SelectOption>();
   	optionsCATALOGUEValues = new List<SelectOption>();
    optionsSTANDARDPFValues =  new List<SelectOption>();
      optionsMARQUEValues =  new List<SelectOption>();
    optionsMODELEValues =   new List<SelectOption>();
	
    list<String> ListeCodePaysValuesx = new list<string>();
    list<String> ListeCatalogueValuesx = new list<string>();
    list<String> ListeStandardPFValuesx = new list<string>();
    list<String> ListeMarqueValuesx = new list<string>();
    list<String> ListeModeleValuesx = new list<string>();

	List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c where Code_PF__c=:CodePFParam  ];
   	for( Base_produit__c f : BPList)
   	{
      if(!ListeCodePaysValuesx.contains(f.Code_Pays__c))
      {          
       ListeCodePaysValuesx.add(f.Code_Pays__c);
      }
       if(!ListeCatalogueValuesx.contains(f.Catalogue__c))
      {          
       ListeCatalogueValuesx.add(f.Catalogue__c);
      }
       if(!ListeStandardPFValuesx.contains(f.Standard__c))
      {          
       ListeStandardPFValuesx.add(f.Standard__c);
      }
      if(!ListeMarqueValuesx.contains(f.Marque__c))
      {          
       ListeMarqueValuesx.add(f.Marque__c);
      }
      if(!ListeModeleValuesx.contains(f.Modele__c))
      {          
       ListeModeleValuesx.add(f.Modele__c);
   	  }
   	}
    for( String x : ListeCodePaysValuesx)
   			{
      		optionsCODEPAYSValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeCatalogueValuesx)
   			{
      		optionsCATALOGUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeStandardPFValuesx)
   			{
      		optionsSTANDARDPFValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeMarqueValuesx)
   			{
      		optionsMARQUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeModeleValuesx)
   			{
      		optionsMODELEValues.add(new SelectOption(x,x));
   			}
} 
    
    public void getSTANDARDPFValues()
{
   	optionsCODEPAYSValues = new List<SelectOption>();
   	optionsCATALOGUEValues = new List<SelectOption>();
    optionsCODEPFValues =  new List<SelectOption>();
    optionsMARQUEValues =  new List<SelectOption>();
    optionsMODELEValues =   new List<SelectOption>();
    
    list<String> ListeCodePaysValuesx = new list<string>();
    list<String> ListeCatalogueValuesx = new list<string>();
    list<String> ListeCodePFValuesx = new list<string>();
    list<String> ListeMarqueValuesx = new list<string>();
    list<String> ListeModeleValuesx = new list<string>();

	List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c where Standard__c=:StandardPFParam  ];
   	for( Base_produit__c f : BPList)
   	{
      if(!ListeCodePaysValuesx.contains(f.Code_Pays__c))
      {          
       ListeCodePaysValuesx.add(f.Code_Pays__c);
      }
       if(!ListeCatalogueValuesx.contains(f.Catalogue__c))
      {          
       ListeCatalogueValuesx.add(f.Catalogue__c);
      }
       if(!ListeCodePFValuesx.contains(f.Code_PF__c))
      {          
       ListeCodePFValuesx.add(f.Code_PF__c);
      }
      if(!ListeMarqueValuesx.contains(f.Marque__c))
      {          
       ListeMarqueValuesx.add(f.Marque__c);
      }
      if(!ListeModeleValuesx.contains(f.Modele__c))
      {          
       ListeModeleValuesx.add(f.Modele__c);
   	  }
   	}
    for( String x : ListeCodePaysValuesx)
   			{
      		optionsCODEPAYSValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeCatalogueValuesx)
   			{
      		optionsCATALOGUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeCodePFValuesx)
   			{
      		optionsCODEPFValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeMarqueValuesx)
   			{
      		optionsMARQUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeModeleValuesx)
   			{
      		optionsMODELEValues.add(new SelectOption(x,x));
   			}
  
}  
    public void getMARQUEValues()
{
   	optionsCODEPAYSValues = new List<SelectOption>();
    optionsCATALOGUEValues = new List<SelectOption>();
   	optionsCODEPFValues = new List<SelectOption>();
    optionsSTANDARDPFValues =  new List<SelectOption>();
    optionsMODELEValues = new List<SelectOption>();
    list<String> ListeCodePaysValuesx = new list<string>();
    list<String> ListeCatalogueValuesx = new list<string>();
    list<String> ListeCodePFValuesx = new list<string>();
    list<String> ListeStandardPFValuesx = new list<string>();
    list<String> ListeModeleValuesx = new list<string>();

	List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c where Marque__c=:MarqueParam  ];
   	for( Base_produit__c f : BPList)
   	{
      if(!ListeCodePaysValuesx.contains(f.Code_Pays__c))
      {          
       ListeCodePaysValuesx.add(f.Code_Pays__c);
      }
       if(!ListeCatalogueValuesx.contains(f.Catalogue__c))
      {          
       ListeCatalogueValuesx.add(f.Catalogue__c);
      }
       if(!ListeCodePFValuesx.contains(f.Code_PF__c))
      {          
       ListeCodePFValuesx.add(f.Code_PF__c);
      }
       if(!ListeStandardPFValuesx.contains(f.Standard__c))
      {          
       ListeStandardPFValuesx.add(f.Standard__c);
      }
        if(!ListeModeleValuesx.contains(f.Modele__c))
      {          
       ListeModeleValuesx.add(f.Modele__c);
      }
   	}
    for( String x : ListeCatalogueValuesx)
   			{
      		optionsCATALOGUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeCodePFValuesx)
   			{
      		optionsCODEPFValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeStandardPFValuesx)
   			{
      		optionsSTANDARDPFValues.add(new SelectOption(x,x));
   			}
   for( String x : ListeCodePaysValuesx)
   			{
      		optionsCODEPAYSValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeModeleValuesx)
   			{
      		optionsMODELEValues.add(new SelectOption(x,x));
   			}
}
 	public void getMODELEValues()
{
   	optionsCODEPAYSValues = new List<SelectOption>();
    optionsCATALOGUEValues = new List<SelectOption>();
   	optionsCODEPFValues = new List<SelectOption>();
    optionsSTANDARDPFValues =  new List<SelectOption>();
    optionsMARQUEValues = new List<SelectOption>();
    list<String> ListeCodePaysValuesx = new list<string>();
    list<String> ListeCatalogueValuesx = new list<string>();
    list<String> ListeCodePFValuesx = new list<string>();
    list<String> ListeStandardPFValuesx = new list<string>();
    list<String> ListeMarqueValuesx = new list<string>();

	List<Base_produit__c> BPList= [Select id,Code_Pays__c,Catalogue__c,Code_PF__c,Standard__c,Marque__c	,Modele__c from Base_produit__c where Modele__c=:ModeleParam  ];
   	for( Base_produit__c f : BPList)
   	{
      if(!ListeCodePaysValuesx.contains(f.Code_Pays__c))
      {          
       ListeCodePaysValuesx.add(f.Code_Pays__c);
      }
       if(!ListeCatalogueValuesx.contains(f.Catalogue__c))
      {          
       ListeCatalogueValuesx.add(f.Catalogue__c);
      }
       if(!ListeCodePFValuesx.contains(f.Code_PF__c))
      {          
       ListeCodePFValuesx.add(f.Code_PF__c);
      }
       if(!ListeStandardPFValuesx.contains(f.Standard__c))
      {          
       ListeStandardPFValuesx.add(f.Standard__c);
      }
        if(!ListeMarqueValuesx.contains(f.Marque__c))
      {          
       ListeMarqueValuesx.add(f.Marque__c);
      }
   	}
    for( String x : ListeCatalogueValuesx)
   			{
      		optionsCATALOGUEValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeCodePFValuesx)
   			{
      		optionsCODEPFValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeStandardPFValuesx)
   			{
      		optionsSTANDARDPFValues.add(new SelectOption(x,x));
   			}
   for( String x : ListeCodePaysValuesx)
   			{
      		optionsCODEPAYSValues.add(new SelectOption(x,x));
   			}
    for( String x : ListeMarqueValuesx)
   			{
      		optionsMARQUEValues.add(new SelectOption(x,x));
   			}
}  
 //**WS method
   
    
   ///
   public void SearchCatalogue()
    {
       State =  SearchAllowedCountryCatalogue(currentQuote.Pays_Region_PF__c,CodePaysParam);
        
      if(CodePaysParam == '-' || CodePFParam =='-' || CatalogueParam =='-' ||StandardPFParam =='-')
      {
       DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=true;CatalogueNotAllowed=false;
      }
      else if (State==TRUE)
      {
       DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=false;DisplayNotAllowed=false;CatalogueNotAllowed=TRUE ;
      }
        else {
           String Result = CatalogueAPI.WSCallCatalogue( CodePaysParam, CodePFParam, CatalogueParam, StandardPFParam,currentQuote.Id,MarqueParam,ModeleParam);
        switch on Result {
            when 'OK' {		
                DisplayInfo = false;DisplayCreated=true;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=false;DisplayNotAllowed=false;CatalogueNotAllowed=false;
            }
            when 'null' {		
                DisplayInfo = false;DisplayCreated=false;DisplayNotFound=true;DisplayError=false;DisplayErrorDM=false;DisplayNotAllowed=false;CatalogueNotAllowed=false;
            }
            when 'Erreur' {
                DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=true;DisplayErrorDM=false;DisplayNotAllowed=false;CatalogueNotAllowed=false;
            }
            when 'ErreurDM' {
                DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=true;DisplayNotAllowed=false;CatalogueNotAllowed=false;
            }
            when 'NOT_ALLOWED'{
				DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=false;DisplayNotAllowed=true;CatalogueNotAllowed=false;
            }
            
           }   
        }
      
        
    }
    
    /*   ************* GFC-1192 ************* 
    *   Edited by : Hicham El Achboura
    *   Used on Lightning Web Component : CatalogDependentPicklists 
    *   Date : 17/01/2023
    *   Comment : This method is used to verify Allowed Country in Catalogues
    */
   //public boolean SearchAllowedCountryCatalogue(String Pays,String Catalogue)
   @AuraEnabled
   public static boolean SearchAllowedCountryCatalogue(String Pays,String Catalogue)

        {
            if(userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFAdministrateurSysteme.left(15) || userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFSupport.left(15)
               || userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFCentrale.left(15) || userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFTarification.left(15) || userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFCreditManagement.left(15))
            {
                return false;
            }
            else
            {
		
              //DRO
             if(Pays.contains('DRO') == true && (Catalogue <> 'FR' && Catalogue <>'FR_FR' && Catalogue <> 'AN_FR' && Catalogue <>'RE_FR') )
            {return true;}
            //STFR
            else if(Pays.contains('STFR')==true && (Catalogue <> 'FR' && Catalogue <>'FR_FR') )
            {return true;}
            //PFUK
            Else if (Pays == 'PFUK' && Catalogue <> 'GB_EN' && Catalogue <> 'GB_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR')
            {return true;}
            //PIAE
            Else if (Pays == 'PIAE' && (Catalogue <> 'AE_EN' && Catalogue <> 'AE_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PICH
            Else if (Pays == 'PICH' && (Catalogue <> 'CH_DE' && Catalogue <> 'CH_EN' && Catalogue <> 'CH_FR' && Catalogue <> 'CH_IT' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PICZ
            Else if (Pays == 'PICZ' && (Catalogue <> 'CZ_CZ' && Catalogue <> 'CZ_FR' && Catalogue <> 'PIPL' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
           {return true;}
            //PIDE
            Else if (Pays == 'PIDE' && (Catalogue <> 'DE_DE' && Catalogue <> 'DE_EN' && Catalogue <> 'DE_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIES
             Else if (Pays == 'PIES' && (Catalogue <> 'ES_ES' && Catalogue <> 'ES_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIHU
             Else if (Pays == 'PIHU' && (Catalogue <> 'HU_HU' && Catalogue <> 'HU_FR' && Catalogue <> 'PIPL' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
           {return true;}
            //PILU
             Else if (Pays == 'PILU' && (Catalogue <> 'LU_EN' && Catalogue <> 'LU_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIMA
            Else if (Pays == 'PIMA' && (Catalogue <> 'MA_FR' && Catalogue <> 'MA_EN' ))
            {return true;}
            //PIND
            Else if (Pays == 'PIND' && (Catalogue <> 'NL_EN' && Catalogue <> 'NL_FR' && Catalogue <> 'NL_NL' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIPL
            Else if (Pays == 'PIPL' && (Catalogue <> 'PL_PL' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIPT
            Else if (Pays == 'PIPT' && (Catalogue <> 'PT_FR' && Catalogue <> 'PT_PT' && Catalogue <> 'FR' && Catalogue <> 'FR_FR' && Catalogue <> 'ES_ES' && Catalogue <> 'ES_FR'))
            {return true;}
            //PIPL
            Else if (Pays == 'PIRL' && (Catalogue <> 'IE_EN' && Catalogue <> 'IE_FR' && Catalogue <> 'PFUK' && Catalogue <> 'GB_EN' && Catalogue <> 'GB_FR'))
            {return true;}
            //PIRO
            Else if (Pays == 'PIRO' && (Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PISK
            Else if (Pays == 'PISK' && (Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PITA
            Else if (Pays == 'PITA' && (Catalogue <> 'IT_FR' && Catalogue <> 'IT_IT' && Catalogue <> 'FR' && Catalogue <> 'FR_FR' && Catalogue <> 'ES_ES' && Catalogue <> 'ES_FR'))
            {return true;}
            //PIZA
            Else if (Pays == 'PIZA' && (Catalogue <> 'ZA_FR' && Catalogue <> 'ZA_EN' && Catalogue <> 'FR' && Catalogue <> 'FR_FR' && Catalogue <> 'ES_ES' && Catalogue <> 'ES_FR'))
             {return true;}   
            //PIAT
            Else if (Pays == 'PIAT' && (Catalogue <> 'DE_DE' && Catalogue <> 'DE_FR' &&  Catalogue <> 'AT_DE' && Catalogue <> 'AT_EN' && Catalogue <> 'AT_FR' && Catalogue <> 'FR_FR' && Catalogue <> 'FR'))
            {return true;}
            //PIBE
            Else if (Pays == 'PIBE' && (Catalogue <> 'BE_DE' && Catalogue <> 'BE_EN' && Catalogue <> 'BE_FR' && Catalogue <> 'BE_NL' && Catalogue <> 'FR' && Catalogue<> 'FR_FR'))
            {return true;}
            else IF( Pays == 'DROM' && (Catalogue <> 'AN_FR' && Catalogue <>'RE_FR' && Catalogue <> 'FR' && Catalogue <>'FR_FR'))
        	{return true;}
            else {return false;}  
            }
        
            
        }
    
    /*   ************* GFC-1192 ************* 
    *   Edited by : Hicham El Achboura
    *   Used on Lightning Web Component : CatalogDependentPicklists 
    *   Date : 27/12/2022
    *   Comment : This method is used to verify Allowed Country in Catalogues
    
   @AuraEnabled
   public static boolean SearchAllowedCountryCatalogueToLWC(String Pays,String Catalogue)
   {
        if(userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFAdministrateurSysteme || userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFSupport || userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFCentrale || userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFTarification || userinfo.getProfileId().left(15)==Label.USR_ProfileId_PFCreditManagement)
        {
            return false;
        }
        else
        {
            //DRO
            IF(Pays.contains('DRO') == true && (Catalogue <> 'FR' && Catalogue <>'FR_FR') )
            {return true;}
            //STFR
            else if(Pays.contains('STFR')==true && (Catalogue <> 'FR' && Catalogue <>'FR_FR') )
            {return true;}
            //PFUK
            Else if (Pays == 'PFUK' && Catalogue <> 'GB_EN' && Catalogue <> 'GB_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR')
            {return true;}
            //PIAE
            Else if (Pays == 'PIAE' && (Catalogue <> 'AE_EN' && Catalogue <> 'AE_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PICH
            Else if (Pays == 'PICH' && (Catalogue <> 'CH_DE' && Catalogue <> 'CH_EN' && Catalogue <> 'CH_FR' && Catalogue <> 'CH_IT' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PICZ
            Else if (Pays == 'PICZ' && (Catalogue <> 'CZ_CZ' && Catalogue <> 'CZ_FR' && Catalogue <> 'PIPL' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIDE
            Else if (Pays == 'PIDE' && (Catalogue <> 'DE_DE' && Catalogue <> 'DE_EN' && Catalogue <> 'DE_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIES
            Else if (Pays == 'PIES' && (Catalogue <> 'ES_ES' && Catalogue <> 'ES_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIHU
            Else if (Pays == 'PIHU' && (Catalogue <> 'HU_HU' && Catalogue <> 'HU_FR' && Catalogue <> 'PIPL' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PILU
            Else if (Pays == 'PILU' && (Catalogue <> 'LU_EN' && Catalogue <> 'LU_FR' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIMA
            Else if (Pays == 'PIMA' && (Catalogue <> 'MA_FR' && Catalogue <> 'MA_EN' ))
            {return true;}
            //PIND
            Else if (Pays == 'PIND' && (Catalogue <> 'NL_EN' && Catalogue <> 'NL_FR' && Catalogue <> 'NL_NL' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIPL
            Else if (Pays == 'PIPL' && (Catalogue <> 'PL_PL' && Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PIPT
            Else if (Pays == 'PIPT' && (Catalogue <> 'PT_FR' && Catalogue <> 'PT_PT' && Catalogue <> 'FR' && Catalogue <> 'FR_FR' && Catalogue <> 'ES_ES' && Catalogue <> 'ES_FR'))
            {return true;}
            //PIPL
            Else if (Pays == 'PIRL' && (Catalogue <> 'IE_EN' && Catalogue <> 'IE_FR' && Catalogue <> 'PFUK' && Catalogue <> 'GB_EN' && Catalogue <> 'GB_FR'))
            {return true;}
            //PIRO
            Else if (Pays == 'PIRO' && (Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PISK
            Else if (Pays == 'PISK' && (Catalogue <> 'FR' && Catalogue <> 'FR_FR'))
            {return true;}
            //PITA
            Else if (Pays == 'PITA' && (Catalogue <> 'IT_FR' && Catalogue <> 'IT_IT' && Catalogue <> 'FR' && Catalogue <> 'FR_FR' && Catalogue <> 'ES_ES' && Catalogue <> 'ES_FR'))
            {return true;}
            //PIZA
            Else if (Pays == 'PIZA' && (Catalogue <> 'ZA_FR' && Catalogue <> 'ZA_EN' && Catalogue <> 'FR' && Catalogue <> 'FR_FR' && Catalogue <> 'ES_ES' && Catalogue <> 'ES_FR'))
            {return true;}   
            //PIAT
            Else if (Pays == 'PIAT' && (Catalogue <> 'AT_DE' && Catalogue <> 'AT_EN' && Catalogue <> 'AT_FR' && Catalogue <> 'FR_FR' && Catalogue <> 'FR'))
            {return true;}
            //PIBE
            Else if (Pays == 'PIBE' && (Catalogue <> 'BE_DE' && Catalogue <> 'BE_EN' && Catalogue <> 'BE_FR' && Catalogue <> 'BE_NL' && Catalogue <> 'FR' && Catalogue<> 'FR_FR'))
            {return true;}
            else {return false;}  
        }      
   }
   */
    /*   ************* GFC-1192 ************* 
    *   Edited by : Hicham El Achboura
    *   Used on Lightning Web Component : CatalogDependentPicklists 
    *   Date : 27/12/2022
    *   Comment : This method is used to Search Catalogues availabilities consuming Talend Webservices 
    */
   @AuraEnabled
   public static String SearchCatalogueFromLWC(String CodePaysParam, String CodePFParam, String CatalogueParam, String StandardPFParam,String currentQuoteID,String MarqueParam,String ModeleParam)
    {
        Boolean DisplayNotFound;
        Boolean DisplayCreated;
        Boolean DisplayInfo;
        Boolean DisplayError;
        Boolean DisplayErrorDM;
        Boolean DisplayNotAllowed;
        Boolean CatalogueNotAllowed;
        String Result;

        Quote currentQuote= [Select id,Pays_Region_PF__c from Quote where id=:currentQuoteID];
        //Boolean State =  CatalogueController.SearchAllowedCountryCatalogueToLWC(currentQuote.Pays_Region_PF__c,CodePaysParam);
        Boolean State =  CatalogueController.SearchAllowedCountryCatalogue(currentQuote.Pays_Region_PF__c,CodePaysParam);
        Result = String.valueOf(State) + ' getProfileId : ' + userinfo.getProfileId().left(15) + ' USR_ProfileId_PFCreditManagement : ' + Label.USR_ProfileId_PFCreditManagement.left(15);
        if(CodePaysParam == '-' || CodePFParam =='-' || CatalogueParam =='-' || StandardPFParam =='-')
        {
            DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=true;CatalogueNotAllowed=false;
        }
        else if (State==TRUE)
        {
            DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=false;DisplayNotAllowed=false;CatalogueNotAllowed=TRUE ;
            Result = 'Catalogue_Not_Allowed' ; 
        }
        else 
        {
            Result = CatalogueAPI.WSCallCatalogue( CodePaysParam, CodePFParam, CatalogueParam, StandardPFParam,currentQuote.Id,MarqueParam,ModeleParam);
            switch on Result 
            {
                when 'OK' 
                {		
                    DisplayInfo = false;DisplayCreated=true;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=false;DisplayNotAllowed=false;CatalogueNotAllowed=false;
                }
                when 'null' 
                {		
                    DisplayInfo = false;DisplayCreated=false;DisplayNotFound=true;DisplayError=false;DisplayErrorDM=false;DisplayNotAllowed=false;CatalogueNotAllowed=false;
                }
                when 'Erreur' 
                {
                    DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=true;DisplayErrorDM=false;DisplayNotAllowed=false;CatalogueNotAllowed=false;
                }
                when 'ErreurDM' 
                {
                    DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=true;DisplayNotAllowed=false;CatalogueNotAllowed=false;
                }
                when 'NOT_ALLOWED'
                {
                    DisplayInfo = false;DisplayCreated=false;DisplayNotFound=false;DisplayError=false;DisplayErrorDM=false;DisplayNotAllowed=true;CatalogueNotAllowed=false;
                }   
            }   
        }
        return Result;
    }
}