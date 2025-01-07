/*
* MAJ le prénom du contact doit etre en minuscules avec la première lettre en majuscule 
* et prendre en compte les noms composés
* @Author Sara Barakat
* @TestClass AP02Contact_TEST
* @CodeCoverage 100%
*/
public class AP02Contact {
  public static void MAJPrenomMajuscules(List<Contact> listContact)
  {
    list<String> listFirstnamesSplit=new list<String>();
    integer i=0;
    String newName='';

    List<string> listSpaceFirstname=new List<String>();
    List<string> listHyphenFirstname=new List<String>();
    List<String> listFirstnamesSplitSpace=new List<String>();
    List<String> listFirstnamesSplitHyphen=new List<String>();    
   
    for(Contact contact: listContact)
    {
        if(String.isNotBlank(contact.firstname))
        {
            list<String> listTmp =  contact.firstname.split(' ');
            listFirstnamesSplitSpace.addAll(listTmp);
            listFirstnamesSplitSpace.add(string.valueOf(i));
            i++;  
        }  
    }  
    for(String nameSplit: listFirstnamesSplitSpace)
    {
        try 
        {
            Integer x = Integer.valueOf(nameSplit);
            newName=newName.removeEnd(' ');
            listSpaceFirstname.add(newName);
            newName='';
        }
        Catch (exception e) {
        // it's not an Integer, try something else
            newName+= nameSplit.substring(0,1).toUpperCase()+nameSplit.substring(1,nameSplit.length()).toLowerCase()+' ';    
        }
    }  

    for(String firstname: listSpaceFirstname)
    {
        list<String> listTmp =  firstname.split('-');
        listFirstnamesSplitHyphen.addAll(listTmp);
        listFirstnamesSplitHyphen.add(String.valueOf(i));
        i++;     
    }
    for(String nameSplit: listFirstnamesSplitHyphen)
    {
        if(!nameSplit.isWhiteSpace()){
            try 
            {
                Integer x = Integer.valueOf(nameSplit);
                newName=newName.removeEnd('-');
                listHyphenFirstname.add(newName);
                newName='';
            }
            Catch (exception e) {
            // it's not an Integer, try something else
                newName+= nameSplit.substring(0,1).toUpperCase()+nameSplit.substring(1,nameSplit.length())+'-';     
            }
        }
    }
    integer j=0;
    for(String fn: listHyphenFirstname)
    {
        listContact.get(j).firstname=fn;
        j++;
    }  
  }
}