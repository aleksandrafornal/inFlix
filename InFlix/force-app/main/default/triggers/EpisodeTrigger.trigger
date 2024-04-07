trigger EpisodeTrigger on Episode__c (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        if (Trigger.isInsert){
            EpisodeNameHandler.handleBeforeInsert(Trigger.new);
        }else if (Trigger.isUpdate){
            EpisodeNameHandler.handleBeforeUpdate(Trigger.new, Trigger.old);
        }
    }
}