/**
 * Date: 2017.12.26
 * Author: Eric
 * Function: Tigger Management
 * Test:
 */

public without sharing class TriggerManagement {
    
    public enum TriggerType {
        BeforeInsert,
        BeforeUpdate,
        BeforeDelete,
        AfterInsert,
        AfterUpdate,
        AfterDelete,
        AfterUnDelete
    }
    
    public interface Handler {
        void execute();
    }
    
    public virtual class TriggerException extends exception {}
    
    private static Map<TriggerType, List<Object>> handlersMapping = null;
    
    //handler just for String and instance that implements Handler interface
    public static Map<TriggerType, List<Object>> bind(TriggerType type, Object handler) {
        if(handlersMapping == null) {
            handlersMapping = new Map<TriggerType, List<Object>>();
        }
    
        if(!handlersMapping.isEmpty()) {
            List<Object> handlers = new List<Object>();
            handlers.add(handler);
            handlersMapping.put(type, handlers);
        } else {
            handlersMapping.get(type).add(handler);
        }
        
        return handlersMapping;
    }
    
    public static void execute() {
        TriggerType key = null;
    
        if(Trigger.isBefore && Trigger.isInsert) {
            key = TriggerType.BeforeInsert;
        } else if(Trigger.isBefore && Trigger.isUpdate) {
            key = TriggerType.BeforeUpdate;
        } else if(Trigger.isBefore && Trigger.isDelete) {
            key = TriggerType.BeforeDelete;
        } else if(Trigger.isAfter && Trigger.isInsert) {
            key = TriggerType.AfterInsert;
        } else if(Trigger.isAfter && Trigger.isUpdate) {
            key = TriggerType.AfterUpdate;
        } else if(Trigger.isAfter && Trigger.isDelete) {
            key = TriggerType.AfterDelete;
        } else if(Trigger.isAfter && Trigger.isUnDelete) {
            key = TriggerType.AfterUnDelete;
        }
        
        List<Object> handlers = handlersMapping.get(key);
        
        for(Object handler : handlers) {
            if(handler instanceof Handler) {
                ((Handler) handler).execute();
            } else if(handler instanceof String) {
                Handler ins = (Handler) Type.forName((String) handler).newInstance();
                ins.execute();
            } else {
                throw new TriggerException('TriggerManagement unspported handler: ' + handler);
            }
        }
    }
}
