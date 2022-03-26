public class TriggerInvoke { 
    /* An enum for why the trigger was invoked */
    public enum TriggerReason {BEFOREINSERT, AFTERINSERT, 
        BEFOREUPDATE, AFTERUPDATE, BEFOREDELETE, AFTERDELETE}


    /*@Method : callFilter :- searches the Sobject for which trigger will get invoked. Also find outs the pre,post method 
     *                         for insert,update or delete. 
     *@param  : isInsert:-  Boolean
     *@param  : isUpdate:-  Boolean 
     *@param  : isDelete:-  Boolean 
     *@param  : isBefore:-  Boolean 
     *@param  : isAfter:-   Boolean 
     *@param  : newrecord:- Sboject 
     *@param  : oldRecoed:- Sobject 
     */
    public static boolean callFilter(boolean isInsert, boolean isUpdate, boolean isDelete, 
            boolean isBefore, boolean isAfter, SObject newRecord, SObject oldRecord)
    { 
        boolean returnValue = false;
        TriggerInvoke.TriggerReason reason = TriggerInvoke.getReason(isInsert, 
                                                                     isUpdate, 
                                                                     isDelete, 
                                                                     isBefore, 
                                                                     isAfter);
    
    system.debug('Filter object : '+ reason);
        // Get the filter-logic object from the factory
        FilterImplementation.FilterLogic filterLogicObject;
        if(newRecord!=null){
             filterLogicObject = FilterImplementation.GetFilterFromFactory(newRecord.getSObjectType());
        }else{
             filterLogicObject = FilterImplementation.GetFilterFromFactory(oldRecord.getSObjectType());
        }        
            system.debug('Filter object : '+ filterLogicObject);
            if (reason == TriggerReason.BEFOREINSERT) 
                returnValue = filterLogicObject.preInsert(newRecord,oldRecord);
            else if (reason == TriggerReason.AFTERINSERT) 
                returnValue = filterLogicObject.postInsert(newRecord,oldRecord);
            else if (reason == TriggerReason.BEFOREUPDATE) 
               returnValue = filterLogicObject.preUpdate(newRecord,oldRecord);
            else if (reason == TriggerReason.AFTERUPDATE) 
               returnValue = filterLogicObject.postUpdate(newRecord,oldRecord);
            else if (reason == TriggerReason.BEFOREDELETE) 
               returnValue = filterLogicObject.preDelete(newRecord,oldRecord);
            else if (reason == TriggerReason.AFTERDELETE) 
               returnValue = filterLogicObject.postDelete(newRecord,oldRecord);
            else  
               returnValue = false;
                       
        return returnValue;

    }

    /* Generating the enum from Trigger Constants */
    public static TriggerReason getReason(boolean isInsert, boolean isUpdate, boolean isDelete, 
                boolean isBefore, boolean isAfter){ 

        if (isInsert && isBefore)
            return TriggerReason.BEFOREINSERT;
        else if (isInsert && isAfter)
            return TriggerReason.AFTERINSERT;
        else if (isUpdate && isBefore)
            return TriggerReason.BEFOREUPDATE;
        else if (isUpdate && isAfter)
            return TriggerReason.AFTERUPDATE;           
        else if (isDelete && isBefore)
            return TriggerReason.BEFOREDELETE;
        else if (isDelete && isAfter)
            return TriggerReason.AFTERDELETE;

        /* If nothing matches throw an exception */
        throw new FilterException('Invalid Trigger');

    } 

}
			                            	