trigger SeasonTrigger on Season__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            SeasonNameHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            SeasonNameHandler.handleBeforeUpdate(Trigger.new, Trigger.old);
        }
    }
}