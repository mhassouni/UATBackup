/*
*le nomde l'opportunite de type mono doit etre genere en combinant 4 champs
* @Author Ali Naji
* @TestClass AP04Opportunite_TEST
* @CodeCoverage 100%
*/

public class AP04Opportunite
{
    public static void GenerateOppName(list<opportunity> opportunities)
    {
        set<string> AccountIDs = new set<string>();

        for(Opportunity o : opportunities)
        {
            AccountIDs.add(o.AccountId);
        }
        map<string,Account> AccountsMap =new map<string,Account>([  SELECT Name 
                                                                    FROM Account 
                                                                    WHERE Id in: AccountIDs ]);
                
        for(opportunity o : opportunities)
        {
            string s1='';
            
            if(AccountsMap.get(o.AccountId)!=null)
            {
                s1= AccountsMap.get(o.AccountId).Name;
            }
            s1 = s1.replaceAll('[ \\\\\t\r\n\f0-9!"#$%&\'()*+,./:;<=>?@\\^_`{|}~-]','');
            s1 = s1.left(10);
            
            string comb;
            if(o.TypeOpportunite__c!=null && o.Quantite__c!=null && AccountsMap.get(o.accountid).name!=null )
            {
                if(o.CodePF__c!=null)
                {
                    comb = String.valueOf(o.TypeOpportunite__c)+'_' + String.valueOf(o.Quantite__c)+'_'+String.valueOf(o.CodePF__c)+'_'+s1;
                    o.Name=comb;
                }
                else if(o.SousCategorie__c!=null)
                {
                    comb = String.valueOf(o.TypeOpportunite__c)+'_' + String.valueOf(o.Quantite__c)+'_'+String.valueOf(o.SousCategorie__c)+'_'+s1;
                    o.Name=comb;
                }
            }
        }
    }   
    
    
    public static void GenerateOppName_Container(list<opportunity> opportunities)
    {
        set<string> AccountIDs = new set<string>();

        for(Opportunity o : opportunities)
        {
            AccountIDs.add(o.AccountId);
        }
        map<string,Account> AccountsMap =new map<string,Account>([  SELECT Name 
                                                                    FROM Account 
                                                                    WHERE Id in: AccountIDs ]);
                
        for(opportunity o : opportunities)
        {
            string s1='';
            string s2='';
            if(AccountsMap.get(o.AccountId)!=null)
            {
                s1= AccountsMap.get(o.AccountId).Name;
            }
            s1 = s1.replaceAll('[ \\\\\t\r\n\f0-9!"#$%&\'()*+,./:;<=>?@\\^_`{|}~-]','');
            s1 = s1.left(10);
            
            string comb;
            if(o.TypeOpportunite__c!=null && o.Type_Location__c!=null && AccountsMap.get(o.accountid).name!=null )
            {
               s2 = String.valueOf(o.Type_Location__c);
               s2 = s2.replaceAll('[ \\\\\t\r\n\f0-9!"#$%&\'()*+,./:;<=>?@\\^_`{|}~-]','');
                
                    comb = String.valueOf(o.TypeOpportunite__c)+ '_' + s2 +'_'+s1;
                    o.Name=comb;
                
               
            }
        }
    }
    public static void GenerateOppName_SAPCPQ(list<opportunity> opportunities)
    {
        set<string> AccountIDs = new set<string>();

        for(Opportunity o : opportunities)
        {
            AccountIDs.add(o.AccountId);
        }
        map<string,Account> AccountsMap =new map<string,Account>([  SELECT Name 
                                                                    FROM Account 
                                                                    WHERE Id in: AccountIDs ]);
        for(opportunity o : opportunities)
        {
             string AccountName='';
            if(AccountsMap.get(o.AccountId)!=null)
            {
                AccountName= AccountsMap.get(o.AccountId).Name;
            }
            AccountName = AccountName.replaceAll('[ \\\\\t\r\n\f0-9!"#$%&\'()*+,./:;<=>?@\\^_`{|}~-]','');
            AccountName = AccountName.left(10);
            
          
            if(o.TypeContrat__c !=null  &&  AccountName !=null && o.CreatedDate<>null)
            {
                String day = String.valueOf(o.CreatedDate.day());
        		String month = String.valueOf(o.CreatedDate.month());
        		String year = String.valueOf(o.CreatedDate.year());
          
                    o.Name= day+'/'+month+'/'+year+' - '+o.TypeContrat__c+' - '+AccountName;
                }
               else if(o.TypeContrat__c !=null  && AccountName!=null && o.CreatedDate==null)
            {
				Date Todays = Date.today();
                String day = String.valueOf(Todays.day());
        		String month = String.valueOf(Todays.month());
        		String year = String.valueOf(Todays.year());
          
                    o.Name= day+'/'+month+'/'+year+' - '+o.TypeContrat__c+' - '+AccountName;
            }
            }
        	
        }
 
    public static void GenerateOppName_Reways(list<opportunity> opportunities)
    {
        set<string> AccountIDs = new set<string>();

        for(Opportunity o : opportunities)
        {
            AccountIDs.add(o.AccountId);
        }
        map<string,Account> AccountsMap =new map<string,Account>([  SELECT Name 
                                                                    FROM Account 
                                                                    WHERE Id in: AccountIDs ]);
                
        for(opportunity o : opportunities)
        {
            string s1='';
            
            if(AccountsMap.get(o.AccountId)!=null)
            {
                s1= AccountsMap.get(o.AccountId).Name;
            }
            s1 = s1.replaceAll('[ \\\\\t\r\n\f0-9!"#$%&\'()*+,./:;<=>?@\\^_`{|}~-]','');
            s1 = s1.left(10);
            
            string comb;
            if(o.Quantite__c!=null && o.SousFamille__c !=null && AccountsMap.get(o.accountid).name!=null )
            {
                if(o.SousFamille__c!=null)
                {
                    comb = 'Cession_' + String.valueOf(o.Quantite__c)+'_'+String.valueOf(o.SousFamille__c)+'_'+s1;
                    o.Name=comb;
                }
               
            }
        }
    }   
}