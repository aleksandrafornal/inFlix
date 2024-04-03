trigger MovieTrigger on Movie__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        NewMoviesEmailSender.handleAfterInsert(Trigger.new);
    }
}