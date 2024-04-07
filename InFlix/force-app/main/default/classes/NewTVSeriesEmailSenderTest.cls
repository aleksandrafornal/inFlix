/**
 * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
 * @date 07/04/2024
 * @description This class contains test methods for the NewTVSeriesEmailSender.
 */
@isTest
public class NewTVSeriesEmailSenderTest {
    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that no email is send during insertion.
     */
    @isTest
    static void shouldNotSendAnyEmailWhenInsertedTVSeriesListIsNull() {
        Test.startTest();
        NewTVSeriesEmailSender.handleAfterInsert(null);
        Test.stopTest();
        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage];
        System.assertEquals(0, emailMessages.size(), 'No email should be sent');
    }

    /**
     * @author Aleksandra Fornal <aleksandrafornal@accenture.com>
     * @date 07/04/2024
     * @description Test method to verify that one email is send during insertion.
     */
    @isTest
    static void shouldSendOneEmailIfNewTVSeriesAreInserted() {
        List<TV_Series__c> newTVSeries = new List<TV_Series__c>();
        for (Integer i = 0; i < 5; i++) {
            newTVSeries.add(new TV_Series__c(Name = 'TestTVSeries' + i));
        }

        Test.startTest();
        insert newTVSeries;
        Test.stopTest();

        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage];
        System.assertEquals(1, emailMessages.size(), 'One email message should be saved as an activity.');
    }
}