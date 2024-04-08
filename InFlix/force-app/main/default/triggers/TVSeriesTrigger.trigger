trigger TVSeriesTrigger on TV_Series__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        NewTVSeriesEmailSender.handleAfterInsert(Trigger.new);
    }
}