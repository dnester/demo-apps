/* 

  This class implements the database access layer.

  It implements all the CRUD operations. The complete SDE solution is expected to
  use this interface.
  
  DML Exceptions are not caught and are thrown as is.

*/

global class DriverAccess { 
    
    public DriverAccess () {
         
    }

//By Avadhut K
  /* 
     Find method that takes in the object as parameter on which the search
     is to be implemented. Also takes a list of outputFields and condition.
     The map is provided for passing options.
  */

  public List<SObject> findObjects(sObject sobj, List<String> fields, ConditionBuilder condition, Map<String,String> countAMap, String srchText) {
      String query;
      String extractedFields = '';
      
      if (sobj == null)
        throw new DriverAccessException ('DriverAccess Select Method: Object passed has a null reference.');
      
      integer i = 0;
      if(fields != null){
          for(String strFields : fields){
              if(i < fields.size()){
                  if((i+1)==fields.size())
                      extractedFields =extractedFields+ strFields;
                   else
                      extractedFields =extractedFields+ strFields + ',';
                  i++;
              } 
          }
      }else{
          Map<String, Schema.SObjectField> fieldsMap = new Map<String, Schema.SObjectField> ();
          
          fieldsMap = sobj.getSObjectType().getDescribe().fields.getMap();
              
          for(String s : fieldsMap.keySet()){
              if((i+1)==fieldsMap.size())
                  extractedFields = extractedFields +s;
              else
                  extractedFields = extractedFields +s +', ';
              i++;
            }
      }   
      
      /* If condition object is not passed or no condition is set then we need to drop the where clause */      
      if(condition != null && condition.getCondition() != null && condition.getCondition().trim().length()>0  &&  !(condition.getCondition().trim().startsWith('order by')) )   {
          query = 'FIND \''+srchText+'*\' IN ALL FIELDS RETURNING '+sobj.getSObjectType()+' ('+extractedFields+' WHERE '+condition.getCondition()+')';              
      }else if(condition != null && condition.getCondition() != null && condition.getCondition().trim().length()>0  &&  condition.getCondition().trim().startsWith('order by')){
        query = 'FIND \''+srchText+'*\' IN ALL FIELDS RETURNING '+sobj.getSObjectType()+' ('+extractedFields+' '+condition.getCondition()+')';            
      }else{
          query = 'FIND \''+srchText+'*\' IN ALL FIELDS RETURNING '+sobj.getSObjectType()+' ('+extractedFields+')';           
      }
      System.debug('-------->>>>>>-------'+query);
      List<List<Sobject>> rs = Search.query(query);
      if(rs.size()<1) {
        rs=new List<List<Sobject>>();
        rs.add(null);
      }            
      return rs[0];
  }
  

//End By Avadhut K    
  /* 
     Select method that takes in the object as parameter on which the search
     is to be implemented. Also takes a list of outputFields and condition.
     The map is provided for passing options.
     
  */

public List<SObject> selectObjects(sObject sobj, List<String> fields, ConditionBuilder condition, Map<String,String> countAMap) {
            String query;
            String extractedFields = '';
            
            if (sobj == null)
              throw new DriverAccessException ('DriverAccess Select Method: Object passed has a null reference.');
            
            /* Field list
               If the field list is null then we need to take all fields
               Else just need to have the specified fields
            */          
            integer i = 0;
            if(fields != null){
                for(String strFields : fields){
                    if(i < fields.size()){
                        if((i+1)==fields.size())
                            extractedFields =extractedFields+ strFields;
                         else
                            extractedFields =extractedFields+ strFields + ',';
                        i++;
                    } 
                }
            }else{
                Map<String, Schema.SObjectField> fieldsMap = new Map<String, Schema.SObjectField> ();
                
                fieldsMap = sobj.getSObjectType().getDescribe().fields.getMap();
                    
                for(String s : fieldsMap.keySet()){
                    if((i+1)==fieldsMap.size())
                        extractedFields = extractedFields +s;
                    else
                        extractedFields = extractedFields +s +', ';
                            i++;
                    }
            }   
            
            /* If condition object is not passed or no condition is set then we need to drop the where clause */
            
            if(condition != null && condition.getCondition() != null && condition.getCondition().trim().length()>0  &&  !(condition.getCondition().trim().startsWith('order by')) )   {
                query = 'SELECT ' + extractedFields + ' FROM ' + sobj.getSObjectType() + ' WHERE ' + condition.getCondition();
            }else if(condition != null && condition.getCondition() != null && condition.getCondition().trim().length()>0  &&  condition.getCondition().trim().startsWith('order by')){
                query = 'SELECT ' + extractedFields + ' FROM ' + sobj.getSObjectType() + '  '+condition.getCondition();
              }else{
                  query = 'SELECT ' + extractedFields + ' FROM ' + sobj.getSObjectType(); 
              }
            System.debug('-------->>>>>>-------'+query);
              return database.query(query);
        }

  /* 
     CreateObject takes in the object parameter which is to be created.
     The method also takes a map for passing options.
     It returns a boolean for  object creation result.
     
  */        
  
    public String getobjectType(sObject sobj){
      return sobj.getSObjectType()+'';
    }
        
    public Id insertObject(sObject sobj, Map<String,String> optionsMap) {
      
      if (sobj == null)
             throw new DriverAccessException ('DriverAccess Insert Method: Object passed has a null reference.');
      
        /* The parameter opt_allOrNone set to true so that partial inserts fail */
        Database.saveResult result = Database.insert(sobj, true);
        return result.getId();
        
    }

  /* 
     Createobject takes in the objects list as parameter which is to be created.
     The method also takes a map for passing options.
     It returns a map of id and boolean for each object creation result.
     
  */        
        
    public List<Id> insertObject(sObject[] sobj, Map<String,String> optionsMap) {
      
      if (sobj == null || sobj.size() == 0)
             throw new DriverAccessException ('DriverAccess Insert Method: Object List passed is empty.');
             
        for(Sobject obj: sobj)
          if (obj == null)
               throw new DriverAccessException ('DriverAccess Insert Method: Object List has a null reference.');  
      
        /* The parameter opt_allOrNone set to true so that partial inserts fail */
        Database.saveResult[] result = Database.insert(sobj, true);
        
        List<String> insertResult = new List<String>();
        for(Database.Saveresult rslt : result){
          insertResult.add(rslt.Id);
        }
        
        return insertResult;
        
    }

  /* 
     updateObject takes in the object as parameter which is to be updated.
     The method also takes a map for passing options.
     It returns a boolean for object updation result.
  */

    public Boolean updateObject(sObject sobj, ConditionBuilder condition, Map<String,String> optionsMap) {
        /* Check if the object matches the condition */
        sObject[] condnMatchedObjects = selectObjects(sobj, null, condition, optionsMap);
        Boolean found = false;
      
        for (sObject s : condnMatchedObjects)
          if (s.id == sobj.id)
            found = true;
                
            /* The parameter opt_allOrNone set to true so that partial inserts fail */
            if (found)
              {
                Database.saveResult result = Database.update(sobj, true);
                return result.isSuccess();
              }
              
            return false;
        }

  /* 
     updateObject takes in the list of objects as parameter which is to be updated.
     The method also takes a map for passing options.
     It returns a list of booleans for object updation result.
  */

    public Map<String,Boolean> updateObject(sObject[] sobj, ConditionBuilder condition, Map<String,String> optionsMap) {
      
        if (sobj == null || sobj.size() == 0)
              throw new DriverAccessException ('DriverAccess Update Method: Object list passed is empty.');
            
            /* Check if the object matches the condition */
        sObject[] condnMatchedObjects = selectObjects(sobj[0], null, condition, optionsMap);
        Map<String,Boolean> updateResult = new Map<String,Boolean>();
      Boolean found = false;
      
      /* As the sObject list cannot be created the option used here is to create a new list by using
      deep cloning and then clearing the new list so that it is empty. This new list contains the
      intersection of objects from original list with the objects that match condition */
      
      sObject[] mergedlist = sobj.deepClone(true);
      mergedlist.clear();  
      
        for (Sobject obj: sobj)  // for each object in sobj
        {
          if (obj == null)
                throw new DriverAccessException ('DriverAccess Update Method: Some object in the list has a null reference.');
            
          for (Sobject s: condnMatchedObjects) 
            if (s.ID == obj.ID)
              found = true;
              
          if (found) 
            mergedlist.add(obj);
          else
            updateResult.put(obj.ID, false);
          
          found = false;
                  
        }
        
        /* If the mergedlist size is zero then none of the objects in the original 
            list matched the condition */

            if (mergedlist.size()>0)
            {
              /* The parameter opt_allOrNone set to true so that partial inserts fail */
              Database.saveResult[] result = Database.update(mergedlist, true);
            
              for(Database.Saveresult rslt : result)
                updateResult.put(rslt.Id,rslt.isSuccess());
            }
            
            return updateResult;
            
        }
        
  /* 
     deleteObject takes in the object as parameter which is to be deleted.
     The method also takes a map for passing options.
     It returns a boolean for object deletion result.
  */        
        
 public Boolean deleteObject(sObject sobj, ConditionBuilder condition, Map<String,String> optionsMap) {
                
        /* Check if the object matches the condition */
        sObject[] condnMatchedObjects = selectObjects(sobj, null, condition, optionsMap);
        Boolean found = false;
        for (sObject s : condnMatchedObjects)
          if (s.id == sobj.id)
            found = true;
                
            /* The parameter opt_allOrNone set to true so that partial inserts fail */
            if (found)
            {
              Database.deleteResult result = Database.delete(sobj, true);     
              return result.isSuccess();
            }
            return false;      
        }        
        
        
  /* 
     deleteObject takes in the object list as parameter which is to be deleted.
     The method also takes a map for passing options.
     It returns a Map with Object ids and a boolean for object deletion result.
  */        
        
 public Map<String,Boolean> deleteObject(sObject[] sobj, ConditionBuilder condition, Map<String,String> optionsMap) {
                
            if (sobj == null || sobj.size() == 0)
              throw new DriverAccessException ('DriverAccess Delete Method: Object list passed is empty.');
              
            /* Check if the object matches the condition */
        sObject[] condnMatchedObjects = selectObjects(sobj[0], null, condition, optionsMap);
        Map<String,Boolean> deleteResult = new Map<String,Boolean>();
      Boolean found = false;

      /* As the sObject list cannot be created the option used here is to create a new list by using
      deep cloning and then clearing the new list so that it is empty. This new list contains the
      intersection of objects from original list with the objects that match condition */
      
      sObject[] mergedlist = sobj.deepClone(true);
      mergedlist.clear();  
        
        for (Sobject obj: sobj)  // for each object in sobj
        {
          
          if (obj == null)
                throw new DriverAccessException ('DriverAccess Delete Method: Some object in the list has a null reference.');
        
          for (Sobject s: condnMatchedObjects) 
            if (s.ID == obj.ID)
              found = true;
              
          if (found) 
            mergedlist.add(obj);
          else
            deleteResult.put(obj.ID, false);
          
          found = false;
                  
        }
        
            /* If the mergedlist size is zero then none of the objects in the original 
            list matched the condition */
            if (mergedlist.size()>0)
            {
              /* The parameter opt_allOrNone set to true so that partial inserts fail */
              Database.DeleteResult[] result = Database.delete(mergedlist, true);
            
              for(Database.DeleteResult rslt : result)
                deleteResult.put(rslt.Id,rslt.isSuccess());
            }
            
            return deleteResult;      
        }
        
        
}
			                            	